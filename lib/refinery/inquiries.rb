require 'refinerycms-core'
require 'refinerycms-settings'
require 'filters_spam'
require 'acts_as_indexed'
require 'dragonfly'
require 'rack/cache'

module Refinery
  autoload :InquiriesGenerator, 'generators/refinery/inquiries/inquiries_generator'

  module Inquiries
    require 'refinery/inquiries/engine'
    require 'refinery/inquiries/configuration'

    autoload :Version, 'refinery/inquiries/version'

    autoload :Dragonfly, 'refinery/inquiries/dragonfly'
    autoload :Validators, 'refinery/inquiries/validators'

    class << self
      attr_writer :root

      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end

      def factory_paths
        @factory_paths ||= [ root.join("spec/factories").to_s ]
      end
    end
  end
end
