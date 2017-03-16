Workbook-Rails &mdash; Workbook templates for Rails views
===================================================

[![Gem
Version](https://badge.fury.io/rb/workbook_rails.svg)](http://badge.fury.io/rb/workbook_rails)
[![Build Status](https://secure.travis-ci.org/Programatica/workbook_rails.png?branch=master)](http://travis-ci.org/Programatica/workbook_rails)
[![Code Climate](https://codeclimate.com/github/Programatica/workbook_rails/badges/gpa.svg)](https://codeclimate.com/github/Programatica/workbook_rails)
[![Dependency Status](https://gemnasium.com/Programatica/workbook_rails.png?branch=master)](https://gemnasium.com/Programatica/workbook_rails)
[![Coverage
Status](https://coveralls.io/repos/Programatica/workbook_rails/badge.png)](https://coveralls.io/r/Programatica/workbook_rails)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)


## Installation

In your Gemfile:

```ruby
gem 'workbook_rails'
```

## Requirements

* Rails 3.2, 4.0, 4.1 or 4.2 (tested)
* **Workbook 0.4.16 requires Axlsx 2.0.1, which requires rubyzip 1.0.0**
* You must use `render_to_string` to render a mail attachment.

## FYI

* This gem depends on [Workbook](https://github.com/murb/workbook). See [README](https://github.com/murb/workbook) or [rdoc](http://www.rubydoc.info/github/murb/workbook) for usage.

## Usage

Workbook-Rails provides a renderer and a template handler. It adds the `:xlsx` and `:xls` formats and parses `.wb` templates. This lets you take all the [Workbook](https://github.com/murb/workbook) code out of your controller or model and place it inside the template, where view code belongs!

### Controller

To use Workbook-Rails set your instance variables in your controller and configure the response if needed:

```ruby
class ButtonController < ApplicationController
  def action_name
    @buttons = Button.all
    respond_to do |format|
      format.xlsx
    end
  end
end
```

### Template

Create the template with the `.xlsx.wb` extension (`action_name.xlsx.wb` for example.) [**Watch out for typos!**](#troubleshooting) In the template, use workbook variable to create your spreadsheet:

```ruby
table = workbook.sheet.table
@buttons.each do |button|
  table << [button.name, button.category, button.price]
end
```

This is where you place all your [Workbook](https://github.com/murb/workbook) specific markup. Add worksheets, fill content, merge cells, add styles.

Remember, like in `erb` templates, view helpers are available to use the `.wb` template.

That's it. Call your action and your spreadsheet will be delivered.

### Rendering Options

You can call render in any of the following ways:

```ruby
# rendered, no disposition/filename header
render 'buttons'
# rendered from another controller, no disposition/filename header
render 'featured/latest'
# template and filename of 'buttons'
render xlsx: 'buttons'
# template from another controller, filename of 'latest_buttons'
render xlsx: 'latest_buttons', template: 'featured/latest'
```

### Multi-format Templates

You can create a template with `.wb` extension, without format, and use for generating different spreadsheets formats, such as xls and xlsx, using respond_to and format param.

Set :format param in the route (/route_path.xlsx, or /route_path.xls) and use respond_to in the controller

```ruby
respond_to do |format|
  format.xlsx
  format.xls
end
```

### Disposition

To specify a disposition (such as `inline` so the spreadsheet is opened inside the browser), use the `disposition` option:

```ruby
render xlsx: "buttons", disposition: 'inline'
```

If `render xlsx:` is called, the disposition defaults to `attachment`.

### File name

If Rails calls Workbook through default channels (because you use `format.xlsx {}` for example) you must set the filename using the response header:

```ruby
format.xlsx {
  response.headers['Content-Disposition'] = 'attachment; filename="my_new_filename.xlsx"'
}
```

If you use `render xlsx:` the gem will try to guess the file name:

```ruby
# filename of 'buttons'
render xlsx: 'buttons'
# filename of 'latest_buttons'
render xlsx: 'latest_buttons', template: 'featured/latest'
```

If that fails, pass the `:filename` parameter:

```ruby
render xlsx: "action_or_template", filename: "my_new_filename.xlsx"
```

### Partials

Partials work as expected:

```ruby
render :partial => 'cover_sheet', :locals => {:sheet => workbook.sheet}
workbook << [['Content']]
workbook.last.name = 'Content'
```

With the partial simply using the passed variables:

```ruby
sheet.name = "Cover Sheet"
sheet.table.push ['Cover', 'Sheet']
```

### Mailers

To use an xlsx template to render a mail attachment, use the following syntax:

```ruby
class UserMailer < ActionMailer::Base
  def export(users)
    xlsx = render_to_string handlers: [:wb], formats: [:xlsx], template: "users/export", locals: {users: users}
    attachments["Users.xlsx"] = {mime_type: Mime::XLSX, content: xlsx}
    ...
  end
end
```

* If the route specifies or suggests the `:xlsx` format you do not need to specify `formats` or `handlers`.
* If the template (`users/export`) can refer to only one file (the xlsx.axlsx template), you do not need to specify `handlers`, provided the `formats` includes `:xlsx`.

### Scripts

To generate a template within a script, you need to instantiate an ActionView context. Here are two gists showing how to perform this:

* [Using rails runner](https://gist.github.com/straydogstudio/323139591f2cc5d48fbc)
* [Without rails runner](https://gist.github.com/straydogstudio/dceb775ead81470cea70)

## Troubleshooting

### Mispellings

**It is easy to get the spelling wrong in the extension name, the format.xlsx statement, or in a render call.** Here are some possibilities:

* If it says your template is missing, check that its extension is `.xlsx.wb`.
* If you get the error `uninitialized constant Mime::XSLX` you have used `format.xslx` instead of `format.xlsx`, or something similar.

### Rails 4.2 changes

Before Rails 4.2 you could call:

```ruby
  render xlsx: "users/index"
```

And workbook_rails could adjust the paths and make sure the template was loaded from the right directory. This is no longer possible because the paths are cached between requests for a given controller. As a result, to display a template in another directory you must use the `:template` parameter (which is normal Rails behavior anyway):

```ruby
  render xlsx: "index", template: "users/index"
```

If the request format matches you should be able to call:

```ruby
  render "users/index"
```

This is a breaking change if you have the old syntax!

### What to do

If you are having problems, try to isolate the issue. Use the console or a script to make sure your data is good. Then create the spreadsheet line by line without Workbook-Rails to see if you are having Workbook problems. If you can manually create the spreadsheet, create an issue and we will work it out.

## Dependencies

- [Rails](https://github.com/rails/rails)
- [Workbook](https://github.com/murb/workbook)

## Authors

* [Sergio Cambra](https://github.com/scambra)

## Thanks

Many thanks to [straydogstudio](https://github.com/straydogstudio) for [axlsx_rails](https://github.com/straydogstudio/axlsx_rails), which this gem is based in.
