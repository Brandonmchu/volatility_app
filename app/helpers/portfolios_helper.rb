module PortfoliosHelper

def link_to_add_assets(name, f,association)
	new_object = Asset.new
	fields = f.fields_for(:assets, new_object, :child_index => "new_#{association}") do |builder|
      render("asset_form", :a => builder)
  	end
  	link_to_function(name,"add_fields(this,\"#{association}\",\"#{escape_javascript(fields)}\")")
end

def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
end
 
end
