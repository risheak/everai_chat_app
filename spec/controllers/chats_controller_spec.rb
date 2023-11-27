# spec/controllers/chats_controller_spec.rb

require 'rails_helper'

RSpec.describe ChatsController, type: :controller do
  let(:profile) { create(:profile) }

  describe 'POST #send_message' do
    before do
      allow(Profile).to receive(:find).with(profile.id.to_s).and_return(profile)
    end

    it 'enqueues the ChatApiWorker and saves user message' do
      expect(ChatApiWorker).to receive(:perform_async).with(profile.id, anything)
      expect(profile.messages).to receive(:create).with(body: 'Hello, AI!', sent_by: 'user', archived: false)

      post :send_message, params: { profile_id: profile.id, body: 'Hello, AI!' }

      expect(response).to redirect_to(profile_chats_path(profile_id: profile.id))
    end

    it 'renders the JavaScript response' do
      allow(ChatApiWorker).to receive(:perform_async)
      allow(profile.messages).to receive(:create)

      post :send_message, params: { profile_id: profile.id, body: 'Hello, AI!' }, format: :js

      expect(response).to render_template(:send_message)
      expect(response.content_type).to eq('text/javascript')
    end
  end
end
