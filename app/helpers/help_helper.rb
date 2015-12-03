module HelpHelper
  def help_link(section, options={}, &block)
    section = Array.wrap(section)
    title_text = "Help for #{section.join('/')}"
    link_text = capture(&block) if block_given?
    link_text ||= 'Help'
    
    options.merge!({ remote: true, title: title_text })

    #link_to link_text, help_path(section.first, options: section), options
    link_to link_text, help_path(*section), options
  end

  def check_active(subsection, tab)
    'active' if subsection == tab
  end
end
