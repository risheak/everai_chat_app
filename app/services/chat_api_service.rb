class ChatApiService
  include HTTParty

  SERVERS = Server.pluck(:url).freeze

  def self.next_server_url
    server = Rails.cache.fetch('load_balancer_cache') { 0 }
    servers = SERVERS.blank? ? Server.pluck(:url) : SERVERS
    servers[server]
  end

  def self.build_messages_history(profile)
    messages_history = {
      'internal' => [],
      'visible' => []
    }
    previous_message = ""
    profile.messages.where(archived: [false, nil]).order(:created_at).each_with_index do |message, index|
      if message.sent_by == "profile"
        if index == 0
          messages_history['internal'] << ["<|BEGIN-VISIBLE-CHAT|>", message.body] if index == 0
          messages_history['visible'] << ["", message.body]
        else
          messages_history['internal'] << [previous_message, message.body]
          messages_history['visible'] << [previous_message, message.body]
        end

        previous_message = ""
      else
        previous_message = message.body
      end
    end

    messages_history
  end

  def self.send_message(params, profile)
    params = JSON.parse params
    body = params.merge({
      'history' => build_messages_history(profile)
    })
    response = HTTParty.post(next_server_url, body: body.to_json, headers: { 'Content-Type' => 'application/json' })
    byebug
    if response.success?
      # Save the response as a message with the role 'Profile'
      res = JSON.parse response.body
      last_res = res['results'][0]['history']['internal'].last.last
      # last_res = JSON.parse last_res
      # last_res_message = last_res['results'][0]['history']['internal'].last.last
      profile.messages.create(body: last_res, sent_by: 'profile', archived: false)
    else
      # Handle the failure scenario
      # For example, log the error or retry the job
    end
    update_cache
    response
  end

  def self.update_cache
    cache = Rails.cache.read('load_balancer_cache')
    new_val = cache == 0 ? 1 : 0
    Rails.cache.write('load_balancer_cache', new_val)
  end
end
