require 'dragonfly'

module Refinery
  module Inquiries
    module Dragonfly

      class << self
        def setup!
          app_inquiries = ::Dragonfly[:refinery_inquiries]

          app_inquiries.define_macro(Refinery::Inquiries::Inquiry, :file_accessor)

          app_inquiries.analyser.register(::Dragonfly::Analysis::FileCommandAnalyser)
          app_inquiries.content_disposition = :attachment
        end

        def configure!
          app_inquiries = ::Dragonfly[:refinery_inquiries]
          app_inquiries.configure_with(:rails) do |c|
            c.datastore.root_path = Refinery::Inquiries.datastore_root_path
            c.url_format = Refinery::Inquiries.dragonfly_url_format
            c.secret = Refinery::Inquiries.dragonfly_secret
          end

          if ::Refinery::Inquiries.s3_backend
            app_inquiries.datastore = ::Dragonfly::DataStorage::S3DataStore.new
            app_inquiries.datastore.configure do |s3|
              s3.bucket_name = Refinery::Inquiries.s3_bucket_name
              s3.access_key_id = Refinery::Inquiries.s3_access_key_id
              s3.secret_access_key = Refinery::Inquiries.s3_secret_access_key
              # S3 Region otherwise defaults to 'us-east-1'
              s3.region = Refinery::Inquiries.s3_region if Refinery::Inquiries.s3_region
            end
          end
        end

        def attach!(app)
          ### Extend active record ###
          app.config.middleware.insert_before Refinery::Inquiries.dragonfly_insert_before,
                                              'Dragonfly::Middleware', :refinery_inquiries

          app.config.middleware.insert_before 'Dragonfly::Middleware', 'Rack::Cache', {
            :verbose     => Rails.env.development?,
            :metastore   => "file:#{URI.encode(Rails.root.join('tmp', 'dragonfly', 'cache', 'meta').to_s)}",
            :entitystore => "file:#{URI.encode(Rails.root.join('tmp', 'dragonfly', 'cache', 'body').to_s)}"
          }
        end
      end

    end
  end
end
