class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string :description
      t.string :content_type
      t.string :filename
      t.binary :binary_data, :limit => 1024 * 1024

      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
