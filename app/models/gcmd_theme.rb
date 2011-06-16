class GcmdTheme < ActiveRecord::Base
  acts_as_tree
  has_and_belongs_to_many :granules
  
##
# This is now included in the database
##
  def old_path
      t_path = name
      n = parent
      while (n != nil )
        t_path = n.name + " > " + t_path
        n = n.parent
       end
      return t_path
  end

  ##
  # Helper function to quickly find all root GcmdTheme nodes
  ##
  def self.find_all_root_nodes
    GcmdTheme.find(:all, :conditions => "parent_id is null")      
  end
  
  ##
  # This is the old method for how we calculate the number of granules for all descendants.  It has been
  # replaced with a descendant_granules_count field in each GcmdTheme node that will cache the value normally
  # calculated by this function.  The value will have to be updated every time a new granule is added to the 
  # system.
  ##
#  def descendant_granules_count
#      if ( self.children.length == 0 )
#          return self.granules.length 
#      else
#        count = 0
#        self.children.each {|x|
#            count += x.descendant_granule_count
#        }
#        return count
#      end    
#  end

  ##
  # Utility function used to recalulate all the granule counts for all GcmdTheme nodes
  # This function can be slow and should not normally be needed if every works correctly
  # when adding in new granule nodes.
  ##
  def self.update_all_granule_counts
    GcmdTheme.find_all_root_nodes.each do |theme|
      theme.update_children_granule_counts
    end
  end
  
  def get_child_ids
    unless children.size > 0
      return self.id
    end
    ids = []
    children.each do |x|
      ids << x.id
      ids << x.get_child_ids
    end
    
    return ids.flatten.uniq
  end

  def all_children
    return [] if self.children.nil?
    self.children.inject([]) do |all, child|
      all << child
      all += child.all_children
    end
  end
  
  ##
  # Utility function used with the update_all_granule_counts function to deal with the children nodes
  ##
  def update_children_granule_counts
    count = self.granules.count
    
    unless self.children.length == 0
      self.children.each do |x|
        count += x.update_children_granule_counts
      end
    end
    
    self.descendant_granules_count = count
    self.save
    
    return self.descendant_granules_count
  end
  
  ##
  # Utility function for use when adding a granule to a GcmdTheme node
  # We need to update all the parent nodes with a new descendent_granules_count
  #
  # Note: This function has not been tested yet as we do not have a method for adding in new granules to the
  # system yet
  ##
  def update_parent_granules_count
    count = self.granules.length
    self.children.each { |theme| count += theme.descendant_granules_count }
    self.descendant_granules_count = count
    self.save
    
    unless self.parent.nil?
      self.parent.update_parent_granules_count
    end
  end
end
