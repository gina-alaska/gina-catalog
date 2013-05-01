class SocialTag < Liquid::Tag
  def initialize(tag_name, type, tokens)
    super
    @tag = tag_name
    Rails.logger.info "TAGS: #{@tag}"
  end
  
  def facebook_block(setup)
    return '' if setup.facebook_url.blank?
    
    <<-EOHTML
<iframe src="//www.facebook.com/plugins/likebox.php?href=#{setup.facebook_url}&amp;width=292&amp;height=590&amp;show_faces=true&amp;colorscheme=light&amp;stream=true&amp;border_color&amp;header=true" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:292px; height:590px;" allowTransparency="true"></iframe>
EOHTML
  end
  
  def twitter_block(setup)
    return '' if setup.twitter_url.blank?
    
    <<-EOHTML
    <a class="twitter-timeline" href="#{setup.twitter_url}" width="300" height="400" data-widget-id="266284360179781632">Tweets by @uafgina</a>
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
    # when 'twitter_block'
    #   twitter_block(setup).html_safe
    when 'facebook_block'
      facebook_block(setup).html_safe
    when 'social_icons'
      social_icons(setup).html_safe
    end
  end
end