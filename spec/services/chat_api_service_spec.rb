# spec/services/chat_api_service_spec.rb

require 'rails_helper'

RSpec.describe ChatApiService, type: :service do
  let(:profile) { create(:profile) }

  before do
    # Stub the pluck method on the Server model to return mock server URLs
    allow(Server).to receive(:pluck).with(:url).and_return(['http://server-1/api/v1/chat', 'http://server-2/api/v1/chat'])
  end

  describe '.send_message' do
    it 'distributes requests evenly between servers' do
      # Mock the HTTParty post method without using webmock
      allow(HTTParty).to receive(:post) do |url, options|
        if url == 'http://server-1/api/v1/chat'
          body = '{"results": "Sample results"}'
        elsif url == 'http://server-2/api/v1/chat'
          body = '{"results": "Sample results"}'
        else
          # Handle unexpected URL
          raise "Unexpected URL: #{url}"
        end

        OpenStruct.new(body: body, status: 200, url: url)
      end

      # Use a large number of requests
      total_requests = 100

      # Make multiple requests
      responses = Array.new(total_requests) { ChatApiService.send_message({}.to_json, profile) }

      # Count the occurrences of each server URL in the responses
      server_counts = Hash.new(0)
      responses.each { |response| server_counts[response.url] += 1 }

      # Calculate the expected number of requests per server (assuming even distribution)
      expected_requests_per_server = total_requests / Server.pluck(:url).count

      # Expect each server to receive a roughly equal number of requests
      server_counts.each do |server_url, count|
        expect(count).to be_within(1).of(expected_requests_per_server)
      end
    end
  end
end
