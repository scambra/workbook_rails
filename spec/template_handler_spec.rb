require'spec_helper'
describe 'Workbook template handler' do

  TH = WorkbookRails::TemplateHandler
  VT = Struct.new(:source)

  let( :handler ) { TH.new }

  let( :template ) do
    VT.new("workbook.sheet.table = Workbook::Table.new([['one', 'two', 'three'],['a', 'b', 'c']])")
  end

  context "Rails #{Rails.version}" do
    # for testing if the author is set
    # before do
      # Rails.stub_chain(:application, :config, :axlsx_author).and_return( 'Elmer Fudd' )
    # end

    it "has xlsx format" do
      expect(handler.default_format).to eq(:xlsx)
    end

    it "compiles to an excel spreadsheet" do
      workbook, wb = nil
      lookup_context = double(rendered_format: :xlsx)
      eval TH.call(template)
      workbook.write_to_xlsx('/tmp/wb_temp.xlsx')
      expect{ wb = Workbook::Book.open('/tmp/wb_temp.xlsx') }.to_not raise_error
      expect(wb.sheet.table[1][2]).to eq('c')
    end

    #TODO:
    # Test if author field is set - does roo parse that?
  end
end
