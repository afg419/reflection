require 'rails_helper'

RSpec.describe User, type: :model do
  it "finds by auth" do
    user1 = User.create("email" => "x", "name" => "y", "permission_id" => "z")
    user2 = User.find_or_create_by_auth("email" => "x")

    expect(user2.email).to eq user1.email
    expect(user2.name).to eq user1.name
    expect(user2.permission_id).to eq user1.permission_id
  end

  it "creates by auth" do
    user_email = "x"
    user_name = "y"
    user_permission_id = "z"

    user = User.find_or_create_by_auth("email" => user_email, "name" => user_name, "permission_id" => user_permission_id)

    expect(user.email).to eq user_email
    expect(user.name).to eq user_name
    expect(user.permission_id).to eq user_permission_id
  end

  it "updates by auth" do
    user_email = "x"
    user_name = "y2"
    user_permission_id = "z2"

    user1 = User.create("email" => user_email, "name" => "y", "permission_id" => "z")
    user2 = User.find_or_create_by_auth("email" => user_email, "name" => user_name, "permission_id" => user_permission_id)
    user3 = User.find_by("name" => "y")

    expect(user2.email).to eq user_email
    expect(user2.name).to eq user_name
    expect(user2.permission_id).to eq user_permission_id
    expect(user3).to eq nil
  end



end