module CmsConcerns
  extend ActiveSupport::Concern

  def create_cms(filename = 'portal_templates/default_cms.json')
    return false if new_record?

    json_file = File.read(filename)
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
    page_templates = cms_data['pages']
    page_templates.each { |page| create_page(page) }
  end

  def create_layout(template_layout)
    layout = layouts.where(name: template_layout['name']).first_or_create
    layout.update_attributes(content: template_layout['content'])
  end

  def create_theme(theme)
    themes.where(name: theme['name']).first_or_create(name: theme['name'], css: theme['css'])
  end

  def create_snippet(template_snippet)
    snippet = snippets.where(name: template_snippet['name']).first_or_create
    snippet.update_attributes(content: template_snippet['content'])
  end

  def create_page(template_page)
    page = pages.where(title: template_page['title'], slug: template_page['slug']).first_or_create

    page.update_attributes(content: template_page['content'],
                           hidden: template_page['hidden'],
                           redirect_url: template_page['redirect_url'],
                           cms_layout: layouts.where(name: template_page['cms_layout_name']).first,
                           parent: pages.find_by_path(template_page['parent_ancestry_path']))
  end

  def export_pages(pages)
    page_list = []
    pages.includes(:cms_layout).each do |page|
      page_list << page.as_json(only: [:title, :content, :hidden, :redirect_url, :slug], methods: [:parent_ancestry_path, :cms_layout_name])
      page_list += export_pages(page.children)
    end

    page_list
  end

  def export_cms
    json = {
      layouts: layouts.as_json(only: [:name, :content]),
      snippets: snippets.as_json(only: [:name, :content]),
      themes: themes.as_json(only: [:name, :css]),
      pages: export_pages(pages.roots)
    }

    File.open('portal_templates/default_cms.json', 'w') { |fp| fp << JSON.pretty_generate(json) }
  end
end
