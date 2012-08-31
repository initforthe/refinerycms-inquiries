module Refinery
  module Inquiries 
    module Validators
      class FileSizeValidator < ActiveModel::Validator

        def validate(record)
          file = record.file

          if file.respond_to?(:length) && file.length > Inquiries.max_file_size
            record.errors[:file] << ::I18n.t('too_big',
                                             :scope => 'activerecord.errors.models.refinery/inquiries/inquiry',
                                             :size => Inquiries.max_file_size)
          end
        end

      end
    end
  end
end
