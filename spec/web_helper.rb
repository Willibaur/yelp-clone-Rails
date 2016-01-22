def sign_up
  visit '/'
 click_link("Sign up")
 fill_in("Email", with: "test@test.com")
 fill_in("Password", with: "test1234")
 fill_in("Password confirmation", with: "test1234")
 click_button("Sign up")
end
