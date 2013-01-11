module Manager::DataHelper
  def iso_topic_options(asset)
    opts = IsoTopic.order('iso_theme_code ASC').all.map do |it|
      ["#{it.iso_theme_code} - #{it.name.underscore.humanize}: #{it.long_name}", it.id]
    end
    options_for_select(opts, asset.iso_topics.map(&:id))
  end
end
