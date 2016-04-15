#
# You can always specify a template:
#
#  def called_action
#    render xlsx: 'filename', template: 'controller/diff_action'
#  end
#
# And the normal use case works:
#
#  def called_action
#    render 'diff_action'
#    # or
#    render 'controller/diff_action'
#  end
#
WorkbookRails::FORMATS.each do |format|
  ActionController::Renderers.add format do |filename, options|
    if options[:template] == action_name
      options[:template] = filename.gsub(/^.*\//,'')
    end

    # disposition / filename
    disposition = options.delete(:disposition) || 'attachment'
    if file_name = options.delete(:filename)
      file_name += ".#{format}" unless file_name =~ /\.#{format}$/
    else
      file_name = "#{filename.gsub(/^.*\//,'')}.#{format}"
    end

    options = options.merge(:formats => [format])
    send_data render_to_string(options), :filename => file_name, :type => Mime::Type.lookup_by_extension(format), :disposition => disposition
  end
end

# For respond_to default
begin
  ActionController::Responder
rescue
else
  class ActionController::Responder
    WorkbookRails::FORMATS.each do |format|
      define_method "to_#{format}" do
        if @default_response
          @default_response.call(options)
        else
          controller.render options.reverse_merge(format => controller.action_name)
        end
      end
    end
  end
end