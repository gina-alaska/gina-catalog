class SocialTag < Liquid::Tag
  def intialize(tag_name, type, tokens)
    super
  end
  
  def render(context)
    setup = context.environments.first['setup']
    results = ""
    
    { twitter_url: 'icon-twitter', github_url: 'icon-github', facebook_url: 'icon-facebook' }.each do |k,v|
      next if setup.send(k).nil? or setup.send(k).blank?
      results << "<a href=\"#{setup.send(k)}\" target=\"_blank\" title=\"Visit us at #{k.to_s.gsub('_url', '')}\"><i class=\"#{v}\"></i></a>"
    end

    if setup.pages.contact.first
      results << "<a href=\"/#{setup.pages.contact.first.slug}\" title=\"Contact us\"><i class=\"icon-envelope\"></i></a>"
    end
    
    results
  end
end