require 'rails_helper'

RSpec.describe Admin::AssetsController, type: :request do
  before do
    create_user_session(users(:sudara))
  end

  describe '#delete' do
    it "should delete a user" do
      expect {
        put delete_admin_user_path(users(:arthur))
      }.to change(User, :count).by(-1)
    end

    it "should redirect admin to root_path" do
      put delete_admin_user_path(users(:arthur))
      expect(response).to redirect_to(root_path)
    end

    it "sets deleted_at to true" do
      put delete_admin_user_path(users(:arthur))
      users(:arthur).reload
      expect(users(:arthur).deleted_at).not_to be_nil
    end

    it "soft deletes all associated records" do
      expect(users(:arthur).assets.count).to be > 0
      expect(users(:arthur).tracks.count).to be > 0
      expect(users(:arthur).listens.count).to be > 0
      expect(users(:arthur).playlists.count).to be > 0
      expect(users(:arthur).topics.count).to be > 0
      expect(users(:arthur).topics.count).to be > 0

      put delete_admin_user_path(users(:arthur))

      users(:arthur).reload

      expect(users(:arthur).assets.count).to eq(0)
      expect(users(:arthur).tracks.count).to eq(0)
      expect(users(:arthur).listens.count).to eq(0)
      expect(users(:arthur).playlists.count).to eq(0)
      expect(users(:arthur).topics.count).to eq(0)
      expect(users(:arthur).comments.count).to eq(0)
    end
  end
end