module CatalogsHelper
  def display_result_info(results, page, limit, total)
    startitem = [((page.to_i - 1) * limit.to_i)+1, total].min
    enditem = [startitem + limit.to_i - 1, total].min
    
    if total > 0
      "Display #{startitem}-#{enditem} of #{total}"
    else
      "No results displayed"
    end
  end
end
