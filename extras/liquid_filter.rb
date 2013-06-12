class LiquidFilter < HTML::Pipeline::Filter
  def call
    Liquid::Template.parse(@html).render('page' => context[:page], 'setup' => context[:setup], 'snippets' => context[:snippets], 'system_content' => context[:system_content])
  end
end