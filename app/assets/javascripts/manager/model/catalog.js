Ext.define('Manager.model.Catalog', {
  extend: 'Ext.data.Model',
  fields: [
    'id', 'title', 'tags', 'source_agency_acronym', 'status','type', 'locations', 'fid',
    'source_agency_id', 'funding_agency_id', 'agency_ids', 'people_ids', 'primary_contact_id',
    'updated_at', 'created_at', 'published_at', 'start_date_year', 'end_date_year', 'description',
    'geokeywords', 'features'
  ]
});