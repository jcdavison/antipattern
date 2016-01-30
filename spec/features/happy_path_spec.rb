require 'rails_helper'

OCTO_USERNAME = ENV['OCTO_USERNAME']
OCTO_PASSWORD = ENV['OCTO_PASSWORD']
TEST_ENTITY = 'AntiPatternIO'
TEST_REPO = 'antipattern-private | PRIVATE REPO'
TEST_BRANCH = 'master'
TEST_COMMIT = 'Add secret token.'
TEST_CONTEXT = "capy-spec-#{SecureRandom.hex.first(15)}"

describe "The Happy Path :)", :js => true do
  context 'no logged in user' do
    context 'attempt to create a new code review' do
      it 'prompts sign in' do
        visit '/code-reviews'
        click_link 'Request Code Review'
        expect(page).to have_content 'please sign in to continue'
        sanity_check
      end
    end
  end

  context 'authenticated user' do
    context 'private repo scope' do
      it 'successfully creates a new code review' do
        register_user 'Private'
        visit '/code-reviews'

        code_reviews = all('a.code-review-show')
        expect(code_reviews.length).to be > 0
        expect(code_reviews.any? {|code_review| code_review.text == TEST_CONTEXT}).to be false

        click_link 'Request Code Review'
        expect(page).to have_content 'Please Choose a Commit.'

        all('span.select2.select2-container').select {|ele| ele.text == 'select self or org'}.first.click
        all('li.select2-results__option').select { |ele| ele.text == TEST_ENTITY }.first.click

        [ {select_content: 'select a repo' , click_content: TEST_REPO},
          {select_content: 'select a branch' , click_content: TEST_BRANCH},
          {select_content: 'select a commit' , click_content: TEST_COMMIT} ].each do |opts|
            expect_find_and_click opts
          end

        expect(page).to have_content 'Commit Topic(s)'
        all('span.select2.select2-container').last.click
        all('li.select2-results__option').select {|ele| ele.text == 'ruby'}.first.click

        expect(page).to have_content 'Context'
        fill_in 'context', with: TEST_CONTEXT
        click_button 'Submit'

        expect(page).to have_content 'Congrats!'
        first('button.close').click
        expect(page).to have_content "#{TEST_CONTEXT}..."
        all("span#delete-#{TEST_CONTEXT}").each do |thing|
          puts thing.text
          thing.click
        end
        expect(page).to_not have_content "#{TEST_CONTEXT}..."
        sanity_check
      end
    end
  end
end
