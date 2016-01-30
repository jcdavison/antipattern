module FeaturesHelper
  def register_user scope = 'Public'
    visit '/code-reviews'
    click_link 'Sign In'
    click_link "Sign In With Github - #{scope} Repo Scope"
    fill_in 'Username or email address', with: OCTO_USERNAME
    fill_in 'Password', with: OCTO_PASSWORD
    if page.has_content? 'Sign in'
      click_button 'Sign in'
    elsif page.has_content? 'Authorize application'
      click_button 'Authorize application'
    end
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
