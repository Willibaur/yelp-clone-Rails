require 'rails_helper'

module Helpers
  def manually_create_restaurants
    visit '/restaurants'
    click_link 'Add a restaurant'
    fill_in 'Name', with: 'KFC'
    click_button 'Create Restaurant'
  end
end
