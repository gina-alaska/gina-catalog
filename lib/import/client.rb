# rubocop:disable Rails/Output
require 'open-uri'

module Import
  module Client
    module_function

    def api_url(path)
      File.join(::Import::API_URL, path)
    end

    def portal_api_url(portal, path)
      File.join(::Import::API_URL, 'setups', portal, path)
    end

    def pages_url(portal)
      portal_api_url portal, 'pages.json'
    end

    def attachments_url(portal)
      portal_api_url portal, 'attachments.json'
    end

    def layouts_url(portal)
      portal_api_url portal, 'layouts.json'
    end

    def snippets_url(portal)
      portal_api_url portal, 'snippets.json'
    end

    def themes_url(portal)
      portal_api_url portal, 'themes.json'
    end

    def agencies_url
      api_url '/agencies.json'
    end

    def catalog_records_url(portal)
      api_url "/setups/#{portal}/catalogs.json"
    end

    def contacts_url
      api_url '/contacts.json'
    end

    def collections_url(portal)
      api_url "/setups/#{portal}/collections.json"
    end

    def regions_url
      api_url '/geokeywords.json'
    end

    def data_types_url
      api_url '/data_types.json'
    end

    def use_agreements_url(portal)
      api_url "/setups/#{portal}/use_agreements.json"
    end

    def fetch(url)
      JSON.load(open(url))
    end

    def results(name, url, &_block)
      items = fetch(url)
      puts "[#{name}] Fetched #{items.count} items"

      items.each do |item|
        print '.'
        yield item
      end
      puts ''
      items
    end

    def paged_results(name, url, page = 1, &block)
      puts "[#{name}] Fetching page #{page}"
      while (items = results(name, "#{url}?page=#{page}", &block))
        break if items.count == 0
        page += 1
        puts "[#{name}] Fetching page #{page}"
      end
    end
  end
end
