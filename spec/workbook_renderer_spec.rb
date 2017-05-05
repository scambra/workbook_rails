require'spec_helper'
describe 'Workbook renderer' do

  it "is registered" do
    ActionController::Renderers::RENDERERS.include?(:xlsx)
    ActionController::Renderers::RENDERERS.include?(:xls)
    ActionController::Renderers::RENDERERS.include?(:csv)
  end

  it "has xlsx mime type" do
    expect(get_mime(:xlsx)).to be
    expect(get_mime(:xlsx).to_sym).to eq(:xlsx)
    expect(get_mime(:xlsx).to_s).to eq("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
  end

  it "has xls mime type" do
    expect(get_mime(:xls)).to be
    expect(get_mime(:xls).to_sym).to eq(:xls)
    expect(get_mime(:xls).to_s).to eq("application/vnd.ms-excel")
  end

  it "has csv mime type" do
    expect(get_mime(:csv)).to be
    expect(get_mime(:csv).to_sym).to eq(:csv)
    expect(get_mime(:csv).to_s).to eq("text/csv")
  end

  protected

  def get_mime(extension)
    Mime[extension]
  end

end
