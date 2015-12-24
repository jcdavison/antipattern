require 'rails_helper'

OCTO_USERNAME = ENV['OCTO_USERNAME']
OCTO_PASSWORD = ENV['OCTO_PASSWORD']

describe "The Happy Path :)", :js => true do
  context 'no logged in user' do
    context 'attempt to create a new code review' do
      it 'prompts sign in' do
        visit '/code-reviews'
        click_link 'Request Code Review'
        expect(page).to have_content 'please sign in to continue'
      end
    end
  end

  context 'after a user logs in' do
    context 'attempt to create a new code review' do
      it 'success' do
        register_user
        visit '/code-reviews'
        click_link 'Request Code Review'
        expect(page).to have_content 'Please Choose a Commit.'

        all('span.select2.select2-container').select {|ele| ele.text == 'select self or org'}.first.click
        all('li.select2-results__option').select { |ele| ele.text == 'jcdavison' }.first.click

        [ {select_content: 'select a repo' , click_content: 'antipattern-growth | PRIVATE REPO'},
          {select_content: 'select a branch' , click_content: 'master'},
          {select_content: 'select a commit' , click_content: 'Edit.'} ].each do |opts|
            expect_find_and_click opts
          end

        expect(page).to have_content 'Commit Topic(s)'
        all('span.select2.select2-container').last.click
        all('li.select2-results__option').select {|ele| ele.text == 'ruby'}.first.click

        expect(page).to have_content 'Context'
        fill_in 'context', with: 'some context'
        click_button 'Submit'

        expect(page).to have_content 'Congrats!'
        first('button.close').click
        expect(page).to have_content 'some context...'
      end
    end
  end
end
