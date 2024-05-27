require 'spec_helper'
describe 'Workbook request', :type => :request do

  it "has a working dummy app" do
    @user1 = User.create name: 'Elmer', last_name: 'Fudd', address: '1234 Somewhere, Over NY 11111', email: 'elmer@fudd.com'
    visit '/'
    expect(page).to have_content("Hey, you")
  end

  it "downloads an excel file from default respond_to" do
    visit '/home.xlsx'

    expect(page.response_headers['Content-Type']).to eq(Mime[:xlsx].to_s + "; charset=utf-8")
    wb = write_and_open_workbook(page)
    expect(wb.sheet.table[1][0]).to eq('Untie!')
  end

  it "downloads an xls file from default respond_to" do
    visit '/home.xls'

    expect(page.response_headers['Content-Type']).to eq(Mime[:xls].to_s + "; charset=utf-8")
    wb = write_and_open_workbook(page, 'xls')
    expect(wb.sheet.table[1][0]).to eq('Untie!')
  end

  it "downloads an csv file from default respond_to" do
    visit '/home.csv'

    expect(page.response_headers['Content-Type']).to eq(Mime[:csv].to_s + "; charset=utf-8")
    wb = write_and_open_workbook(page, 'csv')
    expect(wb.sheet.table[1][0]).to eq('Untie!')
  end

  it "downloads an excel file from params format" do
    visit '/home/generic.xlsx'

    expect(page.response_headers['Content-Type']).to eq(Mime[:xlsx].to_s + "; charset=utf-8")
    wb = write_and_open_workbook(page)
    expect(wb.sheet.table[1][0]).to eq('Untie!')
  end

  it "downloads an xls file from params format" do
    visit '/home/generic.xls'

    expect(page.response_headers['Content-Type']).to eq(Mime[:xls].to_s + "; charset=utf-8")
    wb = write_and_open_workbook(page, 'xls')
    expect(wb.sheet.table[1][0]).to eq('Untie!')
  end

  it "downloads an csv file from params format" do
    visit '/home/generic.csv'

    expect(page.response_headers['Content-Type']).to eq(Mime[:csv].to_s + "; charset=utf-8")
    wb = write_and_open_workbook(page, 'csv')
    expect(wb.sheet.table[1][0]).to eq('Untie!')
  end

  it "downloads an excel file from respond_to while specifying filename" do
    visit '/useheader.xlsx'

    expect(page.response_headers['Content-Type']).to eq(Mime[:xlsx].to_s)
    expect(page.response_headers['Content-Disposition']).to include("filename=\"filename_test.xlsx\"")

    wb = write_and_open_workbook(page)
    expect(wb.sheet.table[1][0]).to eq('Untie!')
  end

  it "downloads an excel file from respond_to while specifying filename in direct format" do
    visit '/useheader.xlsx?set_direct=true'

    expect(page.response_headers['Content-Type']).to eq(Mime[:xlsx].to_s + "; charset=utf-8")
    expect(page.response_headers['Content-Disposition']).to include("filename=\"filename_test.xlsx\"")

    wb = write_and_open_workbook(page)
    expect(wb.sheet.table[1][0]).to eq('Untie!')
  end

  it "downloads an excel file from render statement with filename" do
    visit '/another.xlsx'

    expect(page.response_headers['Content-Type']).to eq(Mime[:xlsx])
    expect(page.response_headers['Content-Disposition']).to include("filename=\"filename_test.xlsx\"")

    wb = write_and_open_workbook(page)
    expect(wb.sheet.table[1][0]).to eq('Untie!')
  end

  it "downloads an excel file with partial" do
    visit '/withpartial.xlsx'
    expect(page.response_headers['Content-Type']).to eq(Mime[:xlsx].to_s + "; charset=utf-8")
    wb = write_and_open_workbook(page)
    expect(wb.sheet.table[0][0]).to eq('Cover')
    expect(wb[1].table[1][0]).to eq("Untie!")
  end

  it "handles nested resources" do
    User.destroy_all
    @user = User.create name: 'Bugs', last_name: 'Bunny', address: '1234 Left Turn, Albuquerque NM 22222', email: 'bugs@bunny.com'
    @user.likes.create(:name => 'Carrots')
    @user.likes.create(:name => 'Celery')
    visit "/users/#{@user.id}/likes.xlsx"
    expect(page.response_headers['Content-Type']).to eq(Mime[:xlsx].to_s + "; charset=utf-8")
    wb = write_and_open_workbook(page)
    expect(wb.sheet.table[0][0]).to eq('Bugs')
    expect(wb.sheet.table[1][0]).to eq('Carrots')
    expect(wb.sheet.table[2][0]).to eq('Celery')
  end

  it "handles reference to absolute paths" do
    User.destroy_all
    @user = User.create name: 'Bugs', last_name: 'Bunny', address: '1234 Left Turn, Albuquerque NM 22222', email: 'bugs@bunny.com'
    visit "/users/#{@user.id}/render_elsewhere.xlsx"
    expect(page.response_headers['Content-Type']).to eq(Mime[:xlsx].to_s)
    wb = write_and_open_workbook(page)
    expect(wb.sheet.table[1][0]).to eq('User!')

    [[1,false], [2,false], [3,true], [4,true], [5,false]].reverse.each do |s|
      visit "/home/render_elsewhere.xlsx?type=#{s[0]}"
      expect(page.response_headers['Content-Type']).to eq(Mime[:xlsx].to_s +
        (s[1] ? "; charset=utf-8" : ''))
      wb = write_and_open_workbook(page)
      expect(wb.sheet.table[1][0]).to eq(s[0] == 5 ? 'Untie!' : 'User!')
    end
  end

  it "uses respond_with" do
    User.destroy_all
    @user = User.create name: 'Responder', last_name: 'Bunny', address: '1234 Right Turn, Albuquerque NM 22222', email: 'bugs@bunny.com'
    expect { visit "/users/#{@user.id}.xlsx" }.to_not raise_error
    wb = write_and_open_workbook(page)
    expect(wb.sheet.table[1][0]).to eq('User!')
  end

  it "handles missing format with render :xlsx" do
    visit '/another.xlsx'

    expect(page.response_headers['Content-Type']).to eq(Mime[:xlsx])
    expect(page.response_headers['Content-Disposition']).to include("filename=\"filename_test.xlsx\"")

    wb = write_and_open_workbook(page)
    expect(wb.sheet.table[1][0]).to eq('Untie!')
  end

  Capybara.register_driver :mime_all do |app|
    Capybara::RackTest::Driver.new(app, headers: { 'HTTP_ACCEPT' => '*/*' })
  end

  it "mime all with render :xlsx and then :html" do
    ActionView::Base.default_formats.delete :xlsx # see notes
    Capybara.current_driver = :mime_all
    visit '/another'
    expect{ visit '/home/only_html' }.to_not raise_error
    ActionView::Base.default_formats.push :xlsx

    # Output:
    # default formats before                        : [:html, :text, :js, :css, :ics, :csv, :vcf, :png, :jpeg, :gif, :bmp, :tiff, :mpeg, :xml, :rss, :atom, :yaml, :multipart_form, :url_encoded_form, :json, :pdf, :zip, :xlsx]
    # default formats in my project                 : [:html, :text, :js, :css, :ics, :csv, :vcf, :png, :jpeg, :gif, :bmp, :tiff, :mpeg, :xml, :rss, :atom, :yaml, :multipart_form, :url_encoded_form, :json, :pdf, :zip]
    # default formats after render xlsx with */*    : [:xlsx, :text, :js, :css, :ics, :csv, :vcf, :png, :jpeg, :gif, :bmp, :tiff, :mpeg, :xml, :rss, :atom, :yaml, :multipart_form, :url_encoded_form, :json, :pdf, :zip]

    # Failure/Error: visit '/home/only_html'
    # ActionView::MissingTemplate:
    #   Missing template home/only_html, application/only_html with {:locale=>[:en], :formats=>[:xlsx, :text, :js, :css, :ics, :csv, :vcf, :png, :jpeg, :gif, :bmp, :tiff, :mpeg, :xml, :rss, :atom, :yaml, :multipart_form, :url_encoded_form, :json, :pdf, :zip], :variants=>[], :handlers=>[:erb, :builder, :raw, :ruby, :axlsx]}.
  end

  protected
  def write_and_open_workbook(page, extension = 'xlsx')
    file = "/tmp/workbook_temp.#{extension}"
    File.open(file, 'wb') {|f| f.write(page.source) }
    wb = nil
    expect{ wb = Workbook::Book.open(file) }.to_not raise_error
    #File.unlink file
    wb
  end
end
