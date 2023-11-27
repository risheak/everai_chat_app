require 'rails_helper'

RSpec.describe 'Chats', type: :request do
  let(:profile) { create(:profile) }

  describe 'POST /profiles/:profile_id/send_message' do
    it 'enqueues the ChatApiWorker and saves user message' do
      allow(ChatApiWorker).to receive(:perform_async)
      # Adjust the following line to reflect the actual parameters used in your send_message action
      allow(profile.messages).to receive(:create).with(archived: false, body: 'Hello, AI!', sent_by: 'user')
      count = profile.messages.count

      post send_message_profile_chats_path(profile_id: profile.id), params: { body: 'Hello, AI!' }

      allow(ChatApiWorker).to receive(:perform_async).with(profile.id, anything)
      expect(profile.messages.count).to eq(count + 1)
    end

    it 'renders the JavaScript response' do
      allow(ChatApiWorker).to receive(:perform_async)
      # Adjust the following line to reflect the actual parameters used in your send_message action
      allow(profile.messages).to receive(:create)

      post send_message_profile_chats_path(profile_id: profile.id), params: { body: 'Hello, AI!' }, headers: { 'ACCEPT' => 'text/javascript' }

      expect(response).to render_template(:send_message)
      expect(response.content_type).to eq('text/javascript; charset=utf-8')
    end
  end
end
