class SystemTag < Liquid::Tag
  def initialize(tag_name, type, tokens)
    super
    @tag = tag_name
  end
  
  def render(context)
    context.environments.first['system_content'].try(:html_safe)
  end
end