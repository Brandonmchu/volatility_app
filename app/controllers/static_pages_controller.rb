class StaticPagesController < ApplicationController
  layout :conditional_layout, :only => :home

def home
end

def conditional_layout
  if current_user.nil?
    return 'landing'
  else
  	return 'application'
  end
end

end
