module ApplicationHelper
  def flashes
    flash.map do |type, content|
      content_tag(:div, content_tag(:p, content), :class => "flash_message #{type}")
    end
  end
  def jsflashes
    flash.map { |type, content| "Ext.gina.Notify.show(\"#{type}\", \"#{content}\");"  }.join(' ')
  end

  def search_regions
    regions = {}

    Dir.glob(File.join(Rails.root, 'public/regions/*.geojson')) do |f|
      regions[File.basename(f, '.geojson')] = JSON.parse(File.read(f))
    end

    regions
  end
end
