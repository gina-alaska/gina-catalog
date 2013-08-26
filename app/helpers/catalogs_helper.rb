module CatalogsHelper
  def display_result_info(results, page, limit, total)
    startitem = [((page.to_i - 1) * limit.to_i)+1, total].min
    enditem = [startitem + limit.to_i - 1, total].min
    
    if total > 0
      "Showing #{startitem}-#{enditem} of #{total} results"
    else
      "No results displayed"
    end
  end
  
  def link_to_first_page(scope, options = {}, &block)
    # options = name if name.is_a? Hash
    
    disable_class = options.delete(:disable_class) || 'disabled'
    params = options.delete(:params) || {}
    param_name = options.delete(:param_name) || Kaminari.config.param_name

    if scope.first_page?
      options[:class] ||= ''
      options[:data] ||= {}
      options[:class] << " #{disable_class}"
      options[:data][:disabled] = true
      #turn off remote if the button should be disabled
      options[:remote] = false
    end    
    
    link_to params.merge(param_name => 1), options.reverse_merge(:rel => 'previous'), &block
  end
  
  def link_to_prev_page(scope, options = {}, &block)
    # options = name if name.is_a? Hash
    
    disable_class = options.delete(:disable_class) || 'disabled'
    params = options.delete(:params) || {}
    param_name = options.delete(:param_name) || Kaminari.config.param_name

    if scope.first_page?
      options[:class] ||= ''
      options[:data] ||= {}
      options[:class] << " #{disable_class}"
      options[:data][:disabled] = true
      #turn off remote if the button should be disabled
      options[:remote] = false
    end    
    
    link_to params.merge(param_name => (scope.current_page - 1)), options.reverse_merge(:rel => 'previous'), &block
  end
  
  def link_to_next_page(scope, options = {}, &block)
    # options = name if name.is_a? Hash
    
    disable_class = options.delete(:disable_class) || 'disabled'
    params = options.delete(:params) || {}
    param_name = options.delete(:param_name) || Kaminari.config.param_name

    if scope.last_page?
      options[:class] ||= ''
      options[:data] ||= {}
      options[:class] << " #{disable_class}"
      options[:data][:disabled] = true
      #turn off remote if the button should be disabled
      options[:remote] = false
    end
    
    link_to params.merge(param_name => (scope.current_page + 1)), options.reverse_merge(:rel => 'previous'), &block
  end

  def link_to_last_page(scope, options = {}, &block)
    # options = name if name.is_a? Hash
    
    disable_class = options.delete(:disable_class) || 'disabled'
    params = options.delete(:params) || {}
    param_name = options.delete(:param_name) || Kaminari.config.param_name

    if scope.last_page?
      options[:class] ||= ''
      options[:data] ||= {}
      options[:class] << " #{disable_class}"
      options[:data][:disabled] = true
      #turn off remote if the button should be disabled
      options[:remote] = false
    end
    
    link_to params.merge(param_name => scope.num_pages), options.reverse_merge(:rel => 'previous'), &block
  end  
  
  def dir_btn_class(sort_field)
    sort_field[:field] == 'relevance' ? 'disabled' : ''
  end
end
