require 'rails_helper'

feature 'reviewing' do
  before do
    sign_up
    manually_create_restaurants
  end

  scenario 'allows users to leave a review using a form' do
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in 'Thoughts', with: 'so so'
    select '3', from: 'Rating'
    click_button 'Leave Review'

    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('so so')
  end

  scenario 'do not allow user to post two reviews on the same restaurant' do
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in 'Thoughts', with: 'so so'
    select '3', from: 'Rating'
    click_button 'Leave Review'

    click_link 'Review KFC'
    fill_in 'Thoughts', with: 'Good actually'
    select '5', from: 'Rating'
    click_button 'Leave Review'

    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('has reviewed this restaurant already')
  end

  scenario 'displays an average rating for all reviews' do
    leave_review('So so', '3')
    click_link 'Sign out'
    sign_up_user2
    leave_review('Great', '5')
    expect(page).to have_content("Average rating: ★★★★☆")
  end
end
