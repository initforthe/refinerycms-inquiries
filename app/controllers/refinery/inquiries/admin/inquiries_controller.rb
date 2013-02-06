require 'csv'

module Refinery
  module Inquiries
    module Admin
      class InquiriesController < ::Refinery::AdminController

        crudify :'refinery/inquiries/inquiry',
                :title_attribute => "name",
                :order => "created_at DESC"

        helper_method :group_by_date

        before_filter :find_all_ham, :only => [:index]
        before_filter :find_all_spam, :only => [:spam]
        before_filter :get_spam_count, :only => [:index, :spam]

        def index
          @inquiries = @inquiries.with_query(params[:search]) if searching?
          @inquiries = @inquiries.page(params[:page])
        end

        def spam
          self.index
          render :action => 'index'
        end

        def opt_in
          inquiries = Refinery::Inquiries::Inquiry.opt_in.page(params[:page])
          send_csv_data(inquiries, [:name, :email], 'opt_in.csv')
        end

        def export
          inquiries = Refinery::Inquiries::Inquiry.all
          send_csv_data(inquiries, Refinery::Inquiries::Inquiry.column_names.map(&:to_sym))
        end

        def toggle_spam
          find_inquiry
          @inquiry.toggle!(:spam)

          redirect_to :back
        end

        protected

        def send_csv_data(collection, fields, filename = 'export.csv')
          data = CSV.generate do |output|
            output << fields.map { |f| f.to_s.titleize }
            collection.each do |inquiry|
              output << fields.map { |f| inquiry.send(f) }
            end
          end
          send_data data, 
            type: 'text/csv; charset=iso-8859-1; header=present', 
            disposition: "attachment; filename=#{filename}"
        end

        def find_all_ham
          @inquiries = Refinery::Inquiries::Inquiry.ham
        end

        def find_all_spam
          @inquiries = Refinery::Inquiries::Inquiry.spam
        end

        def get_spam_count
          @spam_count = Refinery::Inquiries::Inquiry.where(:spam => true).count
        end

      end
    end
  end
end
