module PortfoliosHelper

def link_to_add_assets(name, f,association)
	new_object = Asset.new
	fields = f.fields_for(:assets, new_object, :child_index => "new_#{association}") do |builder|
      render("asset_form", :a => builder)
  	end
  	link_to_function(name,"add_fields(this,\"#{association}\",\"#{escape_javascript(fields)}\")")
end
 
end
