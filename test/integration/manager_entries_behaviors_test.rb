require 'test_helper'

class ManagerEntriesBehaviorsTest < ActionDispatch::IntegrationTest
  setup do
    @entry = entries(:one)
    Searchkick.disable_callbacks
    Capybara.current_driver = Capybara.javascript_driver
  end

  test 'redirects when clicking the save button' do
    login(:admin)

    update_entry('Save')
    assert_equal edit_manager_entry_path(@entry), current_path
  end

  test 'redirects when clicking the save & close button' do
    login(:admin)

    update_entry('Save & Close')
    assert_equal manager_entries_path, current_path
  end

  private

  def update_entry(commit)
    visit edit_manager_entry_path(@entry)
    click_button commit
    sleep 1 # need to wait for ajax request to finish
  end

  def login(user)
    @user = users(user)
    visit '/auth/developer'
    fill_in('Name', with: @user.name)
    fill_in('Email', with: @user.email)
    click_button 'Sign In'

    assert page.has_selector?('.alert', text: 'Logged in succesfully')
    assert_equal root_path, current_path
  end
end
