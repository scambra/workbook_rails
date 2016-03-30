module WorkbookRails
  class TemplateHandler
    class_attribute :default_format
    self.default_format = :xlsx

    def self.workbook_to_string(workbook, format)
      case format
      when :xlsx then workbook.stream_xlsx
      when :xls then
        io = StringIO.new
        workbook.to_xls.write(io)
        io.string
      end
    end

    def self.call(template)
      "workbook = Workbook::Book.new;\n" +
      template.source +
      ";\nWorkbookRails::TemplateHandler.workbook_to_string(workbook, local_assigns[:wb_format] || request.format.symbol);"
    end

  end
end

