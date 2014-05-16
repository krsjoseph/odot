require 'spec_helper'

describe "Editing todo items" do
  let!(:todo_list) {TodoList.create(title: "My List", description: "My list item")}
  let!(:todo_item) {todo_list.todo_items.create(content: "Milk")}



  it "is successful with valid content" do
    visit_todo_list(todo_list)
    within("#todo_item_#{todo_item.id}") do
      click_link "Edit"
    end
    fill_in "Content", with: "Lots of Milk"
    click_button "Save"
    expect(page).to have_content("Added todo list item.")
    todo_item.reload
    expect(todo_item.content).to eq("Lots of Milk")
  end

  it "displays and error with no content" do
    visit_todo_list(todo_list)
    within("#todo_item_#{todo_item.id}") do
      click_link "Edit"
    end
    fill_in "Content", with: ""
    click_button "Save"
    within("div.flash") do
      expect(page).to have_content("There was a problem adding that todo list item.")
    end
    expect(page).to have_content("Content can't be blank")
  end

  it "displays an error with content less than 2 characters long" do
    visit_todo_list(todo_list)
    click_link "New Todo Item"
    fill_in "Content", with: "1"
    click_button "Save"
    within("div.flash") do
      expect(page).to have_content("There was a problem adding that todo list item.")
    end
    expect(page).to have_content("Content is too short")
  end

end

