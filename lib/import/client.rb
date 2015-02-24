# rubocop:disable Rails/Output
require 'open-uri'

module Import
  module Client
    module_function

    def api_url(path)
      File.join(::Import::API_URL, path)
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

    def paged_results(name, url, &block)
      page = 1
      puts "[#{name}] Fetching page #{page}"
      while (items = results(name, "#{url}?page=#{page}", &block))
        break if items.count == 0
        page += 1
        puts "[#{name}] Fetching page #{page}"
      end
    end
  end
end
