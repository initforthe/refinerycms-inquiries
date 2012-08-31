module Refinery
  module Inquiries
    module Validators
      class FileTypeValidator < ActiveModel::Validator

        def validate(record)
          file = record.file

          if file.respond_to?(:mime_type) && !Inquiries.mime_types.include?(file.mime_type)
            record.errors[:file] << ::I18n.t('wrong_formats',
                                             :scope => 'activerecord.errors.models.refinery/inquiries/inquiry',
                                             :file_types => Inquiries.file_extensions.join(', '))
          end
        end

      end
    end
  end
end
