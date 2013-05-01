class SocialTag < Liquid::Tag
  def initialize(tag_name, type, tokens)
    super
    @tag = tag_name
    Rails.logger.info "TAGS: #{@tag}"
  end
  
  def facebook_block(setup)
    return '' if setup.facebook_url.blank?
    
    <<-EOHTML
<div id="fb-root"></div>
<script>(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));</script>
<div class="fb-like-box" data-href="#{setup.facebook_url}" data-width="292" data-show-faces="true" data-stream="true" data-header="true"></div>
EOHTML
  end
  
  def social_icons(setup)
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
  
  def render(context)
    setup = context.environments.first['setup']
    case @tag.to_s
    when 'facebook_block'
      facebook_block(setup)
    when 'social_icons'
      social_icons(setup)
    else
      social_icons(setup)      
    end
  end
end