def sign_up
  visit '/'
 click_link("Sign up")
 fill_in("Email", with: "test@test.com")
 fill_in("Password", with: "test1234")
 fill_in("Password confirmation", with: "test1234")
 click_button("Sign up")
end

def sign_up_user2
 visit '/'
 click_link("Sign up")
 fill_in("Email", with: "test@test.com")
 fill_in("Password", with: "test1234")
 fill_in("Password confirmation", with: "test1234")
 click_button("Sign up")
end

def leave_review(thoughts, rating)
  visit '/restaurants'
  click_link 'Review KFC'
  fill_in 'Thoughts', with: thoughts
  select rating, from: 'Rating'
  click_button 'Leave Review'
end
