class RepoFilelist
  def initialize(repo)
    @repo = repo

  end
  
  def empty?
    @repo.tree.contents.count <= 1
  end

  def tree
    @repo.tree.contents.collect do |item|
      process(item)
    end
  end

  def find(name)
    @repo.tree.contents.find { |f| f.name == name }
  end

  protected

  def process(item)
    if item.kind_of? Grit::Tree
      return {
        :name => item.name,
        :type => 'tree',
        :children => item.contents.collect { |i| process(i) } 
      }
    elsif item.kind_of? Grit::Blob
      return { name: item.name, :type => 'blob', size: item.size }
    else
      raise "Unknown Grit::Tree content type #{item.class}::#{item.inspect}"
    end
  end
end