require 'rails_helper'
require 'web_helper'

feature 'restaurants' do
  context 'no restaurants have been added' do
    scenario 'should display a prompt to ad a new restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'while not signed in' do
    context 'creating restaurants' do
      scenario 'user cannot create a restaurant' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        expect(current_path).to eq '/users/sign_in'
      end
    end

    context 'editing restaurants' do
      before { Restaurant.create name: 'KFC'}

      scenario 'user cannot edit a restaurant from another user' do
        visit '/restaurants'
        click_link 'Edit KFC'
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end

  context 'restaurants have been added' do
    before do
      Restaurant.create(name: 'Hawksmoor')
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('Hawksmoor')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do
    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      visit '/restaurants'
      sign_up
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'Hawksmoor'
      click_button 'Create Restaurant'
      expect(page).to have_content 'Hawksmoor'
      expect(current_path).to eq '/restaurants'
    end
    context 'an invalid restaurant' do
      it 'does not let you submit a name that is too short' do
        visit '/restaurants'
        sign_up
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end
  end

  context 'viewing restaurants' do
    let!(:kfc){Restaurant.create(name:'KFC')}

    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'editing restaurants' do
    before do
      sign_up
    end
    context 'when restaurant was created by different user' do
      before {Restaurant.create name: 'KFC'}

      scenario 'a user cannot edit a restaurant' do
        visit '/restaurants'
        click_link 'Edit KFC'
        fill_in 'Name', with: 'Kentucky Fried Chicken'
        click_button 'Update Restaurant'
        expect(page).to have_content 'KFC'
        expect(current_path).to eq '/restaurants'
        expect(page).to have_content 'Only owners can edit'
      end
    end

    context 'when restaurant was created by the same user' do
      before { manually_create_restaurants }

      scenario 'a user can edit a restaurant' do
        visit '/restaurants'
        click_link 'Edit KFC'
        fill_in 'Name', with: 'Kentucky Fried Chicken'
        click_button 'Update Restaurant'
        expect(page).to have_content 'Kentucky Fried Chicken'
        expect(current_path).to eq '/restaurants'
      end
    end
  end

  context 'deleting restaurants' do
    before  do
      sign_up
    end
    context 'the restaurant was created by the user' do
      before { manually_create_restaurants }

      scenario 'removes a restaurant when a user clicks a delete link' do
        visit '/restaurants'
        click_link 'Delete KFC'
        expect(page).not_to have_content 'KFC'
        expect(page).to have_content 'Restaurant deleted successfully'
      end
    end

  end
end
