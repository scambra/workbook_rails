module WorkbookRails
  class TemplateHandler
    class_attribute :default_format
    self.default_format = :xlsx

    def self.workbook_to_string(workbook, format)
      case format
      when :csv then workbook.sheet.table.to_csv
      when :xlsx then workbook.stream_xlsx
      when :xls then
        io = StringIO.new
        xls = workbook.is_a?(Spreadsheet::Workbook) ? workbook : workbook.to_xls
        xls.write(io)
        io.string
      end
    end

    def self.call(template)
      "workbook = Workbook::Book.new;\n" +
      template.source +
      ";\nWorkbookRails::TemplateHandler.workbook_to_string(workbook, lookup_context.rendered_format);"
    end

  end
end
