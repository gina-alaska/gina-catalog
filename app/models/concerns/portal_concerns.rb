module PortalConcerns
  extend ActiveSupport::Concern

  included do
    after_commit :create_cms, on: :create
  end

  def create_cms
    json_file = File.read('portal_templates/default_cms.json')
    cms_data = JSON.parse(json_file)

    # create layouts
    layouts = cms_data['layouts']
    layouts.each { |layout| create_layout(layout) }

    # create themes
    themes = cms_data['themes']
    themes.each { |theme| create_theme(theme) }

    # create snippets
    snippets = cms_data['snippets']
    snippets.each { |snippet| create_snippet(snippet) }

    # create pages
    pages = cms_data['pages']
    pages.each { |page| create_page(page) }
  end

  def create_layout(layout)
    self.layouts.where(name: layout['name']).first_or_create(name: layout['name'], content: layout['content'])
  end

  def create_theme(theme)
    self.themes.where(name: theme['name']).first_or_create(name: theme['name'], css: theme['css'])
  end

  def create_snippet(snippet)
    self.snippets.where(name: snippet['name']).first_or_create(name: snippet['name'], content: snippet['content'])
  end

  def create_page(template_page)
    self.pages.where(title: template_page['title']).first_or_create(title: template_page['title'], content: template_page['content'], cms_layout_id: self.layouts.first.id)
  end

  def export_cms
    json = {
      layouts: layouts.as_json(only: [:name, :content]),
      snippets: snippets.as_json(only: [:name, :content]),
      themes: themes.as_json(only: [:name, :css]),
      pages: pages.as_json(only: [:title, :content])
    }

    File.open('portal_templates/default_cms.json', 'w') { |fp| fp << JSON.pretty_generate(json) }
  end
end
