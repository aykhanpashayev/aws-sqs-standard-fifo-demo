require "aws-sdk-sqs"

client = Aws::SQS::Client.new(region: "us-east-2")

queue_url = "https://sqs.us-east-2.amazonaws.com/000345487584/StandartQueue"

resp = client.receive_message(
  queue_url: queue_url,
  max_number_of_messages: 1,
  wait_time_seconds: 5,           # short long-poll
  message_attribute_names: ["All"] # IMPORTANT: get all custom attributes
)

if resp.messages.empty?
  puts "No messages available in the queue."
  exit
end

msg = resp.messages.first

body   = msg.body
author = msg.message_attributes["Author"]&.string_value

puts "Body: #{body}"
puts "Author: #{author}"
puts "Message ID: #{msg.message_id}"
