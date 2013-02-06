class AddOptinToInquiries < ActiveRecord::Migration
  def change
    add_column :refinery_inquiries_inquiries, :opt_in, :boolean
  end
end
