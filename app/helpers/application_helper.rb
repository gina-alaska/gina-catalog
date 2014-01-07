module ApplicationHelper
  def avatar_url(user, size=48)
    default_url = "mm"
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=#{CGI.escape(default_url)}"
  end
  
  def flashes
    flash.map { |type, content|
      content_tag(:div, content, :class => "alert alert-#{type}")
    }.join('').html_safe
  end
  
  def jsflashes
    flash.map { |type, content| "Ext.gina.Notify.show(\"#{type}\", \"#{content}\");"  }.join(' ')
  end
  
  def show_flash_messages
    output = ''
    dismiss = '<a class="close" data-dismiss="alert" href="#">X</a>'.html_safe
    [:notice, :error, :success, :warning].each do |type|
      next if flash[type].blank?
      output << content_tag(:div, :class => "alert fade in alert-#{type}") do
        dismiss + flash[type]
      end
    end

    output.html_safe
  end
  
  def show_notifications
    output = ''
    current_notifications.each do |notice|
      output << content_tag(:div, class: "alert alert-block fade in alert-#{notice.message_type}",id: dom_id(notice)) do
        content_tag(:h4) {
          content_tag(:i, '', class: notice.icon_name) + " " + notice.title
        } + notice.message +
        content_tag(:div, style: "float: right;") do
          link_to 'Dismiss', dismiss_notification_path(notice), class: "btn btn-#{notice.message_type}", title: "Dismiss Notification", remote: true, method: :post
        end
      end
    end

    output.html_safe
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
  
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)", class: 'btn btn-danger')
  end
  
  def link_to_add_fields(name, f, association, html_options = {})
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", html_options)
  end
  
  def build_result_layer(map, results)
    output = <<-EOJS
      var features, layer = new OpenLayers.Layer.Vector('Search Results'),
          wktReader = new OpenLayers.Format.WKT();
    EOJS
    
    @results.each do |result|
      next if result.geometry_center_collection.empty?
      
      output << <<-EOJS
      features = wktReader.read('#{result.geometry_center_collection}');
      if (features.length > 0) {
        $(features).each(function(k,f) {
          f.geometry.transform('EPSG:4326', 'EPSG:3572');
          f.attributes = { record_id: '#{dom_id(result, :record)}', type: '#{result.type}' }
        });
        layer.addFeatures(features);
      }
      EOJS
    end
    
    output << <<-EOJS
    #{map}.addLayer(layer);
    #{map}.zoomToExtent(layer.getDataExtent());

    var select = new OpenLayers.Control.SelectFeature(layer, {
      autoActivate: true,
      onSelect: function(feature) {
        var el = $('#' + feature.attributes.record_id);
        var parent = $('body');
      
        var cur_scroll = parent.scrollTop();
        parent.animate({
          scrollTop: el.offset().top
        });
        el.effect("highlight", {}, 1500);
      }
    });
    #{map}.addControl(select);
    EOJS
    
    output.html_safe
  end
    
  def ddtext(string)
    string.blank? ? "&nbsp;".html_safe : string
  end

  def sass_color(primary, gradient)
    if gradient.nil? or gradient.empty?
      "#{primary}".html_safe
    else
      "linear-gradient(to bottom, #{primary}, #{gradient})".html_safe
    end
  end
end
