module Refinery
  module Inquiries
    class Inquiry < Refinery::Core::BaseModel
      ::Refinery::Inquiries::Dragonfly.setup!

      include Validators

      filters_spam :message_field => :message,
                   :email_field => :email,
                   :author_field => :name,
                   :other_fields => [:phone],
                   :extra_spam_words => %w()

      validates :name, :presence => true
      validates :message, :presence => true
      validates :email, :format=> { :with =>  /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }

      file_accessor :file
      validates_with FileSizeValidator
      validates_with FileTypeValidator

      acts_as_indexed :fields => [:name, :email, :message, :phone]

      default_scope :order => 'created_at DESC'

      attr_accessible :name, :phone, :message, :email, :file

      def self.latest(number = 7, include_spam = false)
        include_spam ? limit(number) : ham.limit(number)
      end

    end
  end
end
