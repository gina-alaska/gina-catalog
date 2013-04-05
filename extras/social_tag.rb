class SocialTag < Liquid::Tag
  def intialize(tag_name, type, tokens)
    super
  end
  
  def render(context)
    setup = context.environments.first['setup']
    results = ""
    
    { twitter_url: 'icon-twitter', github_url: 'icon-github', facebook_url: 'icon-facebook' }.each do |k,v|
      next if setup.send(k).nil? or setup.send(k).blank?
      results << "<a href=\"#{setup.send(k)}\"><i class=\"#{v}\"></i></a>"
    end
    
    results
  end
end