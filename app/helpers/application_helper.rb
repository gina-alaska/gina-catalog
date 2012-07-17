module ApplicationHelper
  def flashes
    flash.map do |type, content|
      content_tag(:div, content_tag(:p, content), :class => "flash_message #{type}")
    end
  end
  def jsflashes
    flash.map { |type, content| "Ext.gina.Notify.show(\"#{type}\", \"#{content}\");"  }.join(' ')
  end
  
  def show_flash_messages
    dismiss = '<a class="close" data-dismiss="alert" href="#">X</a>'.html_safe
    flash.map do |type,content|
      content_tag(:div, :class => "alert alert-#{type}") do
        dismiss + content
      end
    end.join(' ').html_safe
  end
  
  def add_js_errors_for(model)
    klass = model.class.to_s.underscore
    output = ''
    
    model.errors.each do |field,msg|
      output << "
        $('##{klass}_#{field}').parents('.control-group').addClass('error');
        $('##{klass}_#{field}').parents('.control-group').append(
          '#{content_tag :p, "<i class=\"icon-warning-sign\" /> ".html_safe + escape_javascript("#{field.to_s.humanize} #{h msg}"), :class => 'alert alert-error'}'
        );
      "
    end
    
    output.html_safe
  end
  
  def search_regions
    regions = {}

    Dir.glob(File.join(Rails.root, 'public/regions/*.geojson')) do |f|
      regions[File.basename(f, '.geojson')] = JSON.parse(File.read(f))
    end

    regions
  end
end
