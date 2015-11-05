module Glynx
  module Refile
    # Generate a path for the file to save to
    class DateHasher
      def hash(_uploadable = nil)
        date = Time.zone.now
        encode(::File.join(date.strftime('%Y/%m/%d'), SecureRandom.hex(30)))
      end

      def encode(path)
        # strip out padding, decode will add it back in
        Base64.urlsafe_encode64(path).gsub(/={0,2}$/, '')
      end

      def decode(hash)
        Base64.decode64(hash)
      end
    end
  end
end
