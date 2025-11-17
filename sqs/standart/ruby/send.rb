require "aws-sdk-sqs"

client = Aws::SQS::Client.new(region: "us-east-2")

queue_url = "https://sqs.us-east-2.amazonaws.com/000345487584/StandartQueue"

resp = client.send_message(
  queue_url: queue_url,
  message_body: "AWS SAA 03 Certification Coming Soon!",
  delay_seconds: 1,
  message_attributes: {
    "Author" => {
      string_value: "Aykhan",
      data_type: "String",
    },
  },
)

puts "Message sent!"
puts "Message ID: #{resp.message_id}"
puts "MD5 of body: #{resp.md5_of_message_body}"
