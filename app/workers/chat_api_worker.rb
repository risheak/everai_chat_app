class ChatApiWorker
  include Sidekiq::Worker

  def perform(profile_id, params)
    profile = Profile.find(profile_id)
    response = ChatApiService.send_message(params, profile)
  end
end
