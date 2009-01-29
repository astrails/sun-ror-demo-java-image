class PhotosController < ApplicationController
  resource_controller

  index.wants.xml { render :xml => @photos }

  show do
    wants.xml { render :xml => @photo }
    wants.jpg do
      data = params[:bw] ? @photo.bw_image : @photo.binary_data
      send_data(data, :type => @photo.content_type, :filename => @photo.filename, :disposition => 'inline')
    end
  end

  create do
    flash = "Photo was successfully created."
    wants.xml { render :xml => @photo, :status => :created, :location => @photo }
    failure.wants.xml { render :xml => @photo.errors, :status => :unprocessable_entity }
  end

  update do
    flash 'Photo was successfully updated.'
    wants.xml { head :ok }
    failure.wants.xml { render :xml => @photo.errors, :status => :unprocessable_entity }
  end

  destroy.wants.xml { head :ok }

end
