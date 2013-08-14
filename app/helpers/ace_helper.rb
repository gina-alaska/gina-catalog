module AceHelper
  def load_icons
    YAML.load(File.read("#{Rails.root}/config/font_awesome.yml"))
  end
end
