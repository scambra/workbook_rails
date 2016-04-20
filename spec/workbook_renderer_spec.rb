require'spec_helper'
describe 'Workbook renderer' do

  it "is registered" do
    ActionController::Renderers::RENDERERS.include?(:xlsx)
    ActionController::Renderers::RENDERERS.include?(:xls)
    ActionController::Renderers::RENDERERS.include?(:csv)
  end

  it "has xlsx mime type" do
    expect(Mime::XLSX).to be
  	expect(Mime::XLSX.to_sym).to eq(:xlsx)
    expect(Mime::XLSX.to_s).to eq("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
  end

  it "has xls mime type" do
    expect(Mime::XLS).to be
    expect(Mime::XLS.to_sym).to eq(:xls)
    expect(Mime::XLS.to_s).to eq("application/vnd.ms-excel")
  end

  it "has csv mime type" do
    expect(Mime::CSV).to be
    expect(Mime::CSV.to_sym).to eq(:csv)
    expect(Mime::CSV.to_s).to eq("text/csv")
  end

end