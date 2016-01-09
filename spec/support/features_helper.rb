module FeaturesHelper
  def register_user
    visit '/code-reviews'
    click_link 'Sign In'
    click_link 'Sign In With Github'
    fill_in 'Username or email address', with: OCTO_USERNAME
    fill_in 'Password', with: OCTO_PASSWORD
    click_button 'Sign in'
    expect(page).to have_content 'Request Code Review'
    expect(page).to have_content 'SIGN OUT'
  end

  def expect_find_and_click opts
    expect(page).to have_content opts[:select_content]
    all('span.select2.select2-container').select {|ele| ele.text == opts[:select_content]}.first.click
    all('li.select2-results__option').select { |ele| ele.text == opts[:click_content]}.first.click
  end

  def sanity_check
    expect(page.has_content?(SecureRandom.hex)).to be false
  end
end
