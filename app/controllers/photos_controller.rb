class PhotosController < ApplicationController
  # GET /photos
  # GET /photos.xml
  include Java
  BI = java.awt.image.BufferedImage
  BA = java.io.ByteArrayInputStream

  def index
    @photos = Photo.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @photos }
    end
  end

  # GET /photos/1
  # GET /photos/1.xml
  def show
    @photo = Photo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @photo }
    end
  end

  # GET /photos/new
  # GET /photos/new.xml
  def new
    @photo = Photo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @photo }
    end
  end

  # GET /photos/1/edit
  def edit
    @photo = Photo.find(params[:id])
  end

  # POST /photos
  # POST /photos.xml
  def create
    @photo = Photo.new(params[:photo])

    respond_to do |format|
      if @photo.save
        flash[:notice] = 'Photo was successfully created.'
        format.html { redirect_to(@photo) }
        format.xml  { render :xml => @photo, :status => :created, :location => @photo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @photo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /photos/1
  # PUT /photos/1.xml
  def update
    @photo = Photo.find(params[:id])

    respond_to do |format|
      if @photo.update_attributes(params[:photo])
        flash[:notice] = 'Photo was successfully updated.'
        format.html { redirect_to(@photo) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @photo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.xml
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to(photos_url) }
      format.xml  { head :ok }
    end
  end

  def code_image
   @image_data = Photo.find(params[:id])
   @image = @image_data.binary_data
   send_data (@image, :type => @image_data.content_type, :filename =>@image_data.filename, :disposition => 'inline')
  end

  def bwimage
    @image_data = Photo.find(params[:id])
    @image = @image_data.binary_data
    java_bytes = @image.to_java_bytes
    ba = BA.new(java_bytes)
    #Read the file into a BufferedImage object and creates a Graphics2D object
    #from it so that you can perform the image processing on it.
    bi = javax.imageio.ImageIO.read(ba)
    w = bi.getWidth()
    h = bi.getHeight()
    bi2 = BI.new(w, h, BI::TYPE_INT_RGB)
    big = bi2.getGraphics()
    big.drawImage(bi, 0, 0, nil)
    bi = bi2
    biFiltered = bi
    # convert the image to grayscale:
    colorSpace =
    java.awt.color.ColorSpace.getInstance(java.awt.color.ColorSpace::CS_GRAY)
    op = java.awt.image.ColorConvertOp.new(colorSpace, nil)
    dest = op.filter(biFiltered, nil)
    big.drawImage(dest, 0, 0, nil);
    #Stream the file to the browser:
    os = java.io.ByteArrayOutputStream.new
    javax.imageio.ImageIO.write(biFiltered, "jpeg", os)
    string = String.from_java_bytes(os.toByteArray)
    send_data string, :type => "image/jpeg", :disposition => "inline", :filename=> "newkids.jpg"
  end

end
