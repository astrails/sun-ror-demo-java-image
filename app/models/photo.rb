class Photo < ActiveRecord::Base

  include Java
  BI = java.awt.image.BufferedImage
  BA = java.io.ByteArrayInputStream


  validates_presence_of :description

  def validate
    errors.add(:image_file, "Please upload image") unless binary_data
  end

  def image_file=(input_data)
    if input_data.blank?
      self.binary_data = nil
      self.filename = nil
      self.content_type = nil
    else
      self.filename = input_data.original_filename
      self.content_type = input_data.content_type.chomp
      self.binary_data = input_data.read
    end
  end

  def bw_image
    return nil unless binary_data

    java_bytes = binary_data.to_java_bytes
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
    String.from_java_bytes(os.toByteArray)
  end

end
