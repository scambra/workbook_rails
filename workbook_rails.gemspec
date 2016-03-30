$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "workbook_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "workbook_rails"
  s.version     = WorkbookRails::VERSION
  s.authors     = ["Noel Peden"]
  s.email       = ["noel@peden.biz"]
  s.homepage    = "https://github.com/Programatica/workbook_rails"
  s.summary     = "A simple rails plugin to provide an spreadsheet renderer using the workbook gem."
  s.description = "Workbook_Rails provides a Workbook renderer so you can move all your spreadsheet code from your controller into view files. Partials are supported so you can organize any code into reusable chunks (e.g. cover sheets, common styling, etc.) Now you can keep your controllers thin!"

  s.files = Dir["{app,config,db,lib}/**/*"] + Dir['[A-Z]*'] - ['Guardfile']
  s.test_files = Dir["spec/**/*"] + ['Guardfile']

  s.add_dependency "actionpack", ">= 3.1"
  s.add_dependency "workbook", ">= 0.4.10"

  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "capybara"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "growl"
  s.add_development_dependency "rb-fsevent"
  s.add_development_dependency "coveralls"
  s.add_development_dependency "pry"
  s.add_development_dependency "pry-nav"
end
