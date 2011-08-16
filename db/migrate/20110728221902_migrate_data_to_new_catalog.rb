class MigrateDataToNewCatalog < ActiveRecord::Migration
  def self.up
    Catalog.destroy_all

    OldAsset.includes(:tags).all.each do |op|
      a = Asset.create({
        #:uuid => op.uuid,
        :title => op.title,
        :description => op.description.try(:text),
        :status => op.status,
        :owner_id => op.owner_id,
        :data_source_id => op.data_source_id,
        :source_agency_id => op.source_agency_id,
        :funding_agency_id => op.funding_agency_id,
        :archived_at => op.archived_at,
        :published_at => op.published_at,
        :start_date => op.start_date,
        :end_date => op.end_date,
        #:source_url => op.source_url,
        :created_at => op.created_at,
        :updated_at => op.updated_at
      })

      a.tags = op.tags

      OldLocation.where(:locatable_id => op.id, :locatable_type => 'Asset').each do |loc|
        a.locations.create({
          :name => loc.name,
          :region => loc.region,
          :subregion => loc.subregion,
          :geom => loc.geom
        })
      end

      OldLink.where(:linkable_id => op.id, :linkable_type => 'Asset').each do |link|
        a.links.create({
          :display_text => link.display_text,
          :url => link.url,
          :category => link.category
        })
      end

      path = File.join(Dir.pwd, 'vendor/nssi-prod', op.path)
      if File.directory? path
        Dir.entries(path).each do |f|
          next if f[0] == '.'
          a.repo.add(File.join(path, f))
        end
      end

      #op.agencies.each do |agency|
      #  a.agencies << agency
      #end
    end

    OldProject.includes(:tags, :agencies, :people).all.each do |op|
      p = Project.create({
        :uuid => op.uuid,
        :title => op.title,
        :description => op.synopsis.try(:text),
        :status => op.status,
        :owner_id => op.owner_id,
        :primary_contact_id => op.primary_contact_id,
        :data_source_id => op.data_source_id,
        :source_agency_id => op.source_agency_id,
        :funding_agency_id => op.funding_agency_id,
        :archived_at => op.archived_at,
        :published_at => op.published_at,
        :start_date => op.start_date,
        :end_date => op.end_date,
        :source_url => op.source_url,
        :created_at => op.created_at,
        :updated_at => op.updated_at
      })

      p.tags = op.tags

      OldLocation.where(:locatable_id => op.id, :locatable_type => 'Project').each do |loc|
        p.locations.create({
          :name => loc.name,
          :region => loc.region,
          :subregion => loc.subregion,
          :geom => loc.geom
        })
      end

      OldLink.where(:linkable_id => op.id, :linkable_type => 'Project').each do |link|
        p.links.create({
          :display_text => link.display_text,
          :url => link.url,
          :category => link.category
        })
      end

      op.agencies.each do |agency|
        p.agencies << agency
      end

      op.people.each do |person|
        p.people << person
      end
    end
  end

  def self.down
    Catalog.destroy_all
  end
end
