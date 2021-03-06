require "rails_helper"

feature "User edits a review" do
  it "shows the new information on the page" do
    review = FactoryGirl.create(:review)
    user = review.user
    sign_in(user)
    visit review_path(review)

    click_on "Edit Review"

    fill_in "Title", with: "Edited Title"
    fill_in "Body", with: "#{'y' * 50}"
    select 2, from: "Rating"
    attach_file("Photo", "spec/fixtures/images/pizza_slice.jpeg")
    click_on "Update Review"

    expect(page).to have_content "Edited Title"
    expect(page).to have_content "★★"
    expect(page).to have_content "#{'y' * 50}"
    expect(page).to have_selector("img[alt=\"Edited Title\"]")
  end

  it "fills out invalid information" do
    review = FactoryGirl.create(:review)
    user = review.user
    sign_in(user)
    visit review_path(review)

    click_on "Edit Review"

    fill_in "Title", with: ""
    fill_in "Body", with: ""
    select "", from: "Rating"
    click_on "Update Review"

    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Body can't be blank"
    expect(page).to have_content "Rating can't be blank"
  end

  it "tries to edit a review that was not created by user" do
    review = FactoryGirl.create(:review)
    user1 = FactoryGirl.create(:user)
    sign_in(user1)
    visit review_path(review)

    expect(page).not_to have_content "Edit Review"
  end
end
