class SocialTag < Liquid::Tag
  include ActionView::Helpers
  
  def initialize(tag_name, args, tokens)
    super
    @args = args
    @tag = tag_name
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
  
  def tumblr_block(setup, tumblr_url)
    
    feed = Feedzirra::Feed.fetch_and_parse(tumblr_url)  
    
    if feed.respond_to?(:entries)
      entry = feed.entries.first
      <<-EOHTML
      <table class="table table-bordered tumblr tumblr-home">
        <tr>
          <td class="tumblr_title">
            <a href="#{entry.url}">#{entry.title}</a>
          </td>
        </tr>
        <tr>
          <td class="tumblr_post">
            <small> Posted #{time_ago_in_words entry.published} ago</small>
            #{entry.summary.html_safe}
          </td>
        </tr>
      </table>
      EOHTML
    else
      <<-EOHTML
      <p>No tumblr entries available</p>
      EOHTML
    end
  end
  
  def social_icons(setup)
    results = ""
    
    { twitter_url: 'icon-twitter', github_url: 'icon-github', facebook_url: 'icon-facebook', google_plus_url: 'icon-google-plus-sign', instagram_url: 'icon-instagram', linkedin_url: 'icon-linkedin-sign', youtube_url: 'icon-youtube-sign', tumblr_url: 'icon-text-width' }.each do |k,v|
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
    when 'tumblr_block'
      tumblr_block(setup, @args).html_safe
    when 'facebook_block'
      facebook_block(setup).html_safe
    when 'social_icons'
      social_icons(setup).html_safe
    end
  end
end