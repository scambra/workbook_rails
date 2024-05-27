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

    def self.call(template, source = nil)
      "workbook = Workbook::Book.new;\n" +
        (source || template.source) +
        ";\nWorkbookRails::TemplateHandler.workbook_to_string(workbook, lookup_context.formats.last);"
    end

  end
end
