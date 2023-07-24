require "rails_helper"

RSpec.describe "guests show page" do

# Story 1
# Guest Show
# As a visitor
# When I visit a guest's show page
# I see the guest's name
# And I see a list of all the rooms they've stayed in
# including the room's suite, nightly rate, 
# and the name of the hotel that it belongs to.

  it "displays the guest's name" do
    hotel_1 = Hotel.create!(name: "Aspen Inn", location: "Aspen" )
    room_1 = hotel_1.rooms.create!(rate: 125, suite: "Presidential")

    guest_1 = Guest.create!(name: "Charlie Day", nights: 3)

    visit "/guests/#{guest_1.id}"

    expect(page).to have_content("Charlie Day")
  end

  it "has a list of all the rooms they've stayed in with nightly rate, suite and hotel affiliation" do
    hotel_1 = Hotel.create!(name: "Aspen Inn", location: "Aspen" )
    room_1 = hotel_1.rooms.create!(rate: 125, suite: "Presidential")
    room_2 = hotel_1.rooms.create!(rate: 150, suite: "Honeymoon")

    guest_1 = Guest.create!(name: "Charlie Day", nights: 3)

    guest_1.rooms << room_1
    guest_1.rooms << room_2

    visit "/guests/#{guest_1.id}"


    expect(page).to have_content("Presidential")
    expect(page).to have_content("125")
    expect(page).to have_content("Honeymoon")
    expect(page).to have_content("150")
    expect(page).to have_content("Aspen Inn")
  end

# Story 2
# Add a Guest to a Room
# As a visitor
# When I visit a guest's show page
# Then I see a form to add a room to this guest.
# When I fill in a field with the id of an existing room
# And I click submit
# Then I am redirected back to the guest's show page
# And I see the room now listed under this guest's rooms.
# (You do not have to test for a sad path, 
# for example if the ID submitted is not an existing room)

  it "has a form to add a room to this guest" do
    hotel_1 = Hotel.create!(name: "Aspen Inn", location: "Aspen" )
    room_1 = hotel_1.rooms.create!(rate: 125, suite: "Presidential")

    guest_1 = Guest.create!(name: "Charlie Day", nights: 3)

    visit "/guests/#{guest_1.id}"

    expect(page).to have_field("room_id")
  end

  it "it adds a room when I fill in the field of an id for an existing room and redirects back to guest show page" do
    hotel_1 = Hotel.create!(name: "Aspen Inn", location: "Aspen" )
    room_1 = hotel_1.rooms.create!(rate: 125, suite: "Presidential")

    guest_1 = Guest.create!(name: "Charlie Day", nights: 3)

    visit "/guests/#{guest_1.id}"

    fill_in "room_id", with: room_1.id
    click_button "Add Room"
    
    expect(current_path).to eq("/guests/#{guest_1.id}")
    expect(page).to have_content("#{room_1.suite}")
    expect(page).to have_content("#{room_1.hotel.name}")
  end
end