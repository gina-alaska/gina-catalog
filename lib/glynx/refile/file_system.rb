module Glynx
  module Refile
    class FileSystem < ::Refile::Backend::FileSystem
      def upload(uploadable)
        id = @hasher.hash(uploadable)

        FileUtils.mkdir_p(::File.dirname(path(id)))
        IO.copy_stream(uploadable, path(id))

        ::Refile::File.new(self, id)
      end

      def path(id)
        ::File.join(@directory, @hasher.decode(id))
      end
    end
  end
end
