namespace :linkscan do
  desc 'run a scan for bad links and mark those that are bad as invalid.'
  task bad_links: :environment do
    require 'net/http'

    PublicActivity.enabled = false
    Link.find_each do |link|
      begin
        uri = URI(link.url)
        response = Net::HTTP.get_response(uri)

        link.valid_link = response.code.to_i < 400
      rescue
        link.valid_link = false
      end
      link.last_checked_at = Time.zone.now
      link.save
    end
    PublicActivity.enabled = true
  end
end
