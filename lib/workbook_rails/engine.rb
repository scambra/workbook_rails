require 'workbook'
require 'workbook_rails/template_handler'

module WorkbookRails
  class Engine < Rails::Engine
    initializer 'workbook_rails.action_view' do
      ActiveSupport.on_load :action_view do
        ::ActionView::Template.register_template_handler :wb, WorkbookRails::TemplateHandler
      end
    end

    initializer 'workbook_rails.action_controller' do
      ActiveSupport.on_load :action_controller do
        require 'workbook_rails/action_controller'
      end
    end

    unless Mime::Type.lookup_by_extension(:xlsx)
      Mime::Type.register "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", :xlsx
    end
    unless Mime::Type.lookup_by_extension(:xls)
      Mime::Type.register "application/vnd.ms-excel", :xls
    end
  end
end