module Catalog::EntryExportsHelper
	def check_export_visible_params(name)
    @entry_export.send(name).present?
  end
end
