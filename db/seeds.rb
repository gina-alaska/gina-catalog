# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
PublicActivity.enabled = false

EntryType.where(name: 'Project', description: 'catalog record for projects with no associated data/observation files', color: '#c09853').first_or_create
EntryType.where(name: 'Data', description: 'catalog record for projects with associated data/observation files', color: '#3a87ad').first_or_create

data_types = ['Image','Database', 'GIS', 'Map', 'Web Service', 'Other', 'Report']
data_types.each do |data_type|
  DataType.where(name: data_type).first_or_create
end

networks = [['Facebook', 'fa-facebook'], ['GitHub', 'fa-github'], ['Google+', 'fa-google-plus'],
            ['Instagram', 'fa-instagram'], ['Linkedin', 'fa-linkedin'], ['Tumblr', 'fa-tumblr'],
            ['Twitter', 'fa-twitter'], ['YouTube', 'fa-youtube']]
networks.each do |network|
  SocialNetworkConfig.where(name: network[0], icon: network[1]).first_or_create
end

iso_topics = [
  [ "001", "farming", "rearing of animals and/or cultivation of plants"],
  [ "002", "biota", "flora and/or fauna in natural environment"],
  [ "003", "boundaries", "legal land descriptions"],
  [ "004", "climatologyMeteorologyAtmosphere", "processes and phenomena of the atmosphere"],
  [ "005", "economy", "economic activities, conditions and employment"],
  [ "006", "elevation", "height above or below sea level"],
  [ "007", "environment", "environmental resources, protection and conservation"],
  [ "008", "geoscientificInformation", "information pertaining to earth sciences"],
  [ "009", "health", "health, health services, human ecology, and safety"],
  [ "010", "imageryBaseMapsEarthCover", "base maps"],
  [ "011", "intelligenceMilitary", "military bases, structures, activities"],
  [ "012", "inlandWaters", "inland water features, drainage systems and their characteristics"],
  [ "013", "location", "positional information and services"],
  [ "014", "oceans", "features and characteristics of salt water bodies (excluding inland waters)"],
  [ "015", "planningCadastre", "information used for appropriate actions for future use of the land"],
  [ "016", "society", "characteristics of society and cultures"],
  [ "017", "structure", "man-made construction"],
  [ "018", "transportation", "means and aids for conveying persons and/or goods"],
  [ "019", "utilitiesCommunication", "energy, water and waste systems and communications infrastructure and services"]
]
iso_topics.each do |iso_topic|
  IsoTopic.where( iso_theme_code: iso_topic[0], name: iso_topic[1], long_name: iso_topic[2] ).first_or_create
end

default_portal = Portal.where(title: 'gLynx Portal', acronym: 'gLynx').first_or_create do |portal|
  portal.contact_email = 'support@gina.alaska.edu'

  portal.urls.build(url: 'catalog.192.168.222.225.xip.io', active: true)
  portal.urls.build(url: 'localhost', active: true)
  portal.urls.build(url: 'catalog.127.0.0.1.xip.io', active: true)
  portal.urls.build(url: 'portal.gina.alaska.edu', active: true)
end

if Rails.env.development?
  Contact.where(name: 'Will Fisher', email: 'will@alaska.edu').first_or_create
  Organization.where(name: 'Geographic Information Network of Alaska', acronym: 'GINA').first_or_create
end

Entry.where(title: 'Example record').first_or_create do |entry|
  entry.description = 'This is an example record'
  entry.status = 'Complete'
  entry.entry_type = EntryType.first
  entry.portals = [default_portal]
end

default_layout = default_portal.layouts.where(name: 'default').first_or_create do |l|
  l.content = <<-EOHTML
<div class="header">
  {{>header}}
  {{>navbar}}
</div>
<div class="container-fluid">
  <div class="content">
    {{{content}}}
  </div>
</div>
<div class="footer">
  {{>footer}}
</div>
  EOHTML
end
default_portal.default_cms_layout = default_layout

twocol_layout = default_portal.layouts.where(name: 'twocolumns').first_or_create do |layout|
  layout.content = <<-EOHTML
<div class="header">
  {{>header}}
  {{>navbar}}
</div>
<div class="container-fluid">
  <div class="content">
    <div class="row-fluid">
      <div class="col-sm-9">
        {{{content}}}
      </div>
      <div class="col-sm-3">
        {{{ show_content_for "sidebar" }}}
      </div>
    </div>
  </div>
</div>
<div class="footer">
  {{>footer}}
</div>
  EOHTML
end

default_portal.snippets.where(name: 'header').first_or_create do |s|
  s.content = <<-EOHTML
<h1 class="page-title">{{portal.title}}</h1>
  EOHTML
end

default_portal.snippets.where(name: 'footer').first_or_create do |s|
  s.content = <<-EOHTML
<small>Powered by <a href="http://www.gina.alaska.edu">GINA</a></small>
|
<small><a href="/login">Manager Login</a></small>
  EOHTML
end

default_portal.snippets.where(name: 'navbar').first_or_create do |s|
  s.content = <<-EOHTML
<nav class="navbar navbar-default navbar-static-top">
  <ul class="nav navbar-nav">
    {{#pages}}
      <li><a href="/{{slug}}">{{title}}</a></li>
    {{/pages}}
  </ul>
</nav>
  EOHTML
end

default_portal.pages.where(title: 'Home', slug: 'home').first_or_create do |page|
  page.cms_layout = default_layout
  page.content = <<-EOHTML
<h1>Welcome to gLynx</h1>
<p>This is a new instance of gLynx please take a moment to login and update the site with your content</p>
  EOHTML
end

default_portal.pages.where(title: 'Catalog', slug: 'catalog').first_or_create do |page|
  page.cms_layout = default_layout
  page.content = <<-EOHTML
<h1>
  Place holder for the data catalog page, this will show the search interface and full record views for catalog entries.
</h1>
  EOHTML
end

default_portal.pages.where(title: 'All helpers examples', slug: 'all-helpers-examples').first_or_create do |page|
  page.cms_layout = twocol_layout
  page.content = <<-EOHTML
<p>{{ portal.title }}</p>
<p>Wahooo</p>
<p>{{ page.title }}</p>

<p>{{ page.url }}</p>

<p>{{ page.description }}</p>
<p>{{ page.updated_at }}</p>

{{# root_page }}
  <p>Title: {{ page.title }}</p>
  <p>Slug: {{ page.slug }}</p>
  <p>Desc: {{ page.description }}</p>
{{/ root_page }}
{{#image_attachments}}
  {{ thumbnail size="200x100" }}
  {{ fill size="200x100" }}
  {{ fit size="200x100" }}
  {{ title }}
{{/image_attachments}}

<h4>Collections</h4>
{{#collections limit="5" }}
  <p><b>Collection:</b> {{ collection.name }}</p>
  {{#entries limit="1"}}
    <a href="{{ catalog_entry.url }}">{{ catalog_entry.title }}</a>
    <p>Desc: {{ catalog_entry.description }}</p>
    <p>Type: {{ catalog_entry.type }}</p>
    <p>Start: {{ catalog_entry.start_date }}</p>
    <p>End: {{ catalog_entry.end_date }}</p>
  {{/entries}}

{{/collections}}

<h4>Newest</h4>
{{#newest_entries limit="5"}}
  <ul>
    <ol><a href="{{catalog_entry.url}}">{{ catalog_entry.title }}</a></ol>
  </ul>
{{/newest_entries}}

<h4>Latest</h4>
{{#updated_entries limit="5"}}
  <ul>
    <ol><a href="{{catalog_entry.url}}">{{ catalog_entry.title }}</a></ol>
  </ul>
{{/updated_entries}}

<h4>Parent portal</h4>
{{#parent_portal}}
  {{ portal.title }}
  {{ portal.acronym }}
  {{ portal.description }}
  <ol>
    <h5>childs</h5>
    {{#child_portals}}
      <li>{{ portal.title }}</li>
    {{/child_portals}}
  </ol>
{{/parent_portal}}

<h5>sibs</h5>
<ol>
  {{#sibling_portals}}
    <li>{{ portal.title }}</li>
  {{/sibling_portals}}
</ol>

{{#content_for "sidebar"}}
  {{ title }}
  <ul>{{#pages}}
    <li>{{ page.title }}</li>
  {{/pages}}</ul>
{{/content_for}}
  EOHTML
end

default_portal.pages.where(title: 'Page not found', slug: 'page-not-found').first_or_create do |page|
  page.try(:hidden=, true)
  page.cms_layout = default_layout
  page.content = <<-EOHTML
<div class="jumbotron">
  <h1>404 - Page not found</h1>
  <p>We're sorry but the page you requested could not be found</p>
</div>
  EOHTML
end

default_portal.pages.where(title: 'Sitemap', slug: 'sitemap').first_or_create do |page|
  page.try(:hidden=, true)
  page.cms_layout = default_layout
  page.content = <<-EOHTML
This page is automatically generated, editing it will not change the content.
  EOHTML
end

default_portal.active_cms_theme = default_portal.themes.where(name: 'default').first_or_create do |theme|
  theme.css = <<-EOCSS
//will be applied to the body html tag
&.page {
  background-color: #fff;
}

.header {
  padding:0px;
  background: #4d91ae; /* Old browsers */
  background: -moz-linear-gradient(top, #4d91ae 0%, #00628b 85%); /* FF3.6+ */
  background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#4d91ae), color-stop(85%,#00628b)); /* Chrome    ,Safari4+
  background: -webkit-linear-gradient(top, #4d91ae 0%,#00628b 85%); /* Chrome10+,Safari5.1+ */
  background: -o-linear-gradient(top, #4d91ae 0%,#00628b 85%); /* Opera 11.10+ */
  background: -ms-linear-gradient(top, #4d91ae 0%,#00628b 85%); /* IE10+ */
  background: linear-gradient(to bottom, #4d91ae 0%,#00628b 85%); /* W3C */
  filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#4d91ae', endColorstr='#00628b',GradientType=0 ); /*   IE6-9 */

  h1 {
    margin:0px;
    padding: 10px;
    color: #fff;
  }
}

.footer {
  margin-top: 20px;
  padding: 10px;
}

// Catalog Search Results
.search-results {
  padding-left: 0;

  .results-heading {
    padding: 8px;
    background-color: #fff;
    margin-bottom: 0px;
    border-radius: 5px 5px 0 0;

  }

  .results-body {
    clear: both;
    background-color: #fff;
  }

  .results-footer {
    padding: 10px;
    border-top: 1px solid #dfdfdf;
    background-color: #fff;
    border-radius: 0 0 5px 5px;
  }
}
  EOCSS
end
default_portal.save
