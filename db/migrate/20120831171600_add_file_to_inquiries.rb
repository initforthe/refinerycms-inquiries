class AddFileToInquiries < ActiveRecord::Migration
  def change
    add_column :refinery_inquiries_inquiries, :file_uid, :string
    add_column :refinery_inquiries_inquiries, :file_name, :string
  end
end
