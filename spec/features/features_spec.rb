require 'rails_helper'

feature "creating subreddits" do
  scenario "user can open new subreddit form" do
    visit '/'
    click_on 'Add New Subreddit'
    expect(page).to have_text("Make a new Subreddit")
  end

  scenario "user can create a new subreddit" do
    visit '/'
    click_on 'Add New Subreddit'
    fill_in 'Name', :with => 'Rspec sucks'
    fill_in 'Description', :with => 'Rspec is kind of a jerk'
    click_on 'Save Subreddit'
    expect(page).to have_text('Rspec sucks')
  end
end

feature "User visits a subreddit" do
  before do
    Subreddit.create!(name: "yellow", description: "blue")
    Post.create!(title: "colors", body: "let's talk about them", author: User.create(email: "emily.owaki@gmail.com",cohort: "wolves"), subreddit: Subreddit.find(1))
    Comment.create!(body: "I think colors are stupid", author: User.find(1), post: Post.find(1))
  end

  scenario "sees a list of posts and can view them" do
    visit '/subreddits/1'
    expect(page).to have_text("color")
  end

  scenario "user can visit a post on a subreddit" do
    visit '/subreddits/1'
    click_on "colors"
    expect(page).to have_text("let's talk about them")
  end

  scenario "user can view a comment" do
    visit '/subreddits/1/posts/1'
    expect(page).to have_text("I think colors are stupid")
  end
end

feature "User can leave feedback on a post" do
  before do
    Subreddit.create!(name: "yellow", description: "blue")
    Post.create!(title: "colors", body: "let's talk about them", author: User.create(email: "emily.owaki@gmail.com",cohort: "wolves"), subreddit: Subreddit.find(1))
    Comment.create!(body: "I think colors are stupid", author: User.find(1), post: Post.find(1))
  end

  scenario "User can view the comment form" do
    visit '/subreddits/1/posts/1'
    click_on "Leave a comment"
    expect(page).to have_text("Body")
  end

  scenario "User can leave a comment" do
    visit '/subreddits/1/posts/1/comments/new'
    fill_in 'Body', :with => 'Cats?'
    click_on 'Create Comment'
    expect(page).to have_text('Cats?')
  end

  # scenario "User can delete a comment" do
  #   visit '/subreddits/1/posts/1/comments/new'
  #   fill_in 'Body', :with => 'Cats?'
  #   click_on 'Create Comment'
  #   click_on 'Delete'
  #   expect(page).to_not have_text("Cats?")
  # end

  scenario "User can upvote a post" do
    visit '/subreddits/1/posts/1'
    click_on 'Up Vote'
    expect(page).to have_text("1")
  end

  scenario "User can downvote a post" do
    visit '/subreddits/1/posts/1'
    click_on 'Down Vote'
    expect(page).to have_text("-1")
  end

  scenario "Upvotes increase by 1 point" do
    visit '/subreddits/1/posts/1'
    click_on 'Up Vote'
    visit '/subreddits/1/posts/1'
    click_on 'Up Vote'
    expect(page).to have_text("2")
  end
end
