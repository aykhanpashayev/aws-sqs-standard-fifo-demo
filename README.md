# aws-sqs-standard-fifo-demo
This project is my hands-on deep dive into Amazon SQS, where I built, deployed, and tested both Standard and FIFO queues using:

- CloudFormation (Infrastructure as Code)
- AWS CLI automation (Bash)
- Ruby AWS SDK producers/consumers

It reflects how I approach cloud engineering:
build it, automate it, break it, understand it.

## 🚀 What This Project Covers

### 🟦 Standard SQS Queue

At-least-once delivery
Best-effort ordering
Message attributes
Delayed messages
Simple send/receive flows

### 🔵 FIFO SQS Queue

Strict message ordering
Exactly-once processing
Message Group IDs
Deduplication IDs
Multi-message batch tests

### 🛠 Tools & Skills Demonstrated

CloudFormation for consistent, automated queue creation
Bash scripts with set -euo pipefail for reliability
AWS CLI commands for sending/receiving messages
Ruby scripts using aws-sdk-sqs
Long polling, attributes, delay queues, and ordering logic
Clear folder structure & reproducible workflows

## 📁 Project Structure
```
sqs/
├── standard/
│   ├── template.yaml          # CloudFormation template for Standard queue
│   ├── send-message.json      # Message attributes
│   ├── bin/
│   │   ├── deploy             # Deploy stack
│   │   ├── send               # Send message via AWS CLI
│   │   └── receive            # Receive message via AWS CLI
│   └── ruby/
│       ├── Gemfile
│       ├── send.rb            # Ruby producer
│       └── receive.rb         # Ruby consumer
└── fifo/
    ├── template.yaml          # CloudFormation template for FIFO queue
    ├── send-message.json
    └── bin/
        ├── deploy
        ├── send               # Sends multiple messages with ordering
        └── receive
```
## 📊 Standard vs FIFO Behavior (Visual)
```
                    ┌──────────────────────────┐
                    │        Standard SQS       │
                    └──────────────────────────┘
                           (At-least-once,
                       best-effort ordering)

Producer ─── Msg1 ───────►
         ─── Msg2 ──────────────► Queue ───────► Consumer
         ─── Msg3 ───────►

Messages MAY arrive:
- Out of order
- More than once
- High throughput, no strict sequence
---------------------------------------------------------------

                    ┌──────────────────────────┐
                    │          FIFO SQS        │
                    └──────────────────────────┘
                       (Exactly-once, strict order
                        within Message Groups)

Producer ─── Msg1 ──┐
         ─── Msg2 ──┼──► { Group ID = "Certification" } ───► Queue ───► Consumer
         ─── Msg3 ──┘

Messages WILL arrive:
- In exact order sent
- Without duplicates (deduplication ID)
---------------------------------------------------------------
```
This diagram gives a quick mental model of what the repo tests and why FIFO queues behave differently in real systems.

## 🟦 Standard Queue – CloudFormation + CLI + Ruby
📌 Deploy
```
cd standard/bin
./deploy
```

📤 Send a message (with attributes + delay)
```
./send
```

📥 Receive a message
```
./receive
```

💎 Ruby Producer/Consumer
```
cd standard/ruby
bundle install
ruby send.rb
ruby receive.rb
```

This setup is perfect for learning or testing SQS integrations in real applications.

## 🔵 FIFO Queue – Ordered Messaging & Deduplication
📌 Deploy
```
cd fifo/bin
./deploy
```

📤 Send multiple messages with strict ordering
```
./send
```

This script pushes:

3 messages
Same message group (Certification)
Unique deduplication IDs
Custom attributes

📥 Receive up to 5 messages
```
./receive
```

You'll see strict ordering preserved exactly as intended.

## 🔧 Quick Run Commands (Everything in One Place)
Standard Queue
```
cd standard/bin
./deploy
./send
./receive
```

FIFO Queue
```
cd fifo/bin
./deploy
./send
./receive
```

Ruby
```
cd standard/ruby
bundle install
ruby send.rb
ruby receive.rb
```

## 🧹 Cleanup
Remove stacks to avoid charges:
```
aws cloudformation delete-stack --stack-name standart-sqs --region us-east-2
aws cloudformation delete-stack --stack-name fifo-sqs1 --region us-east-2
```

## 🎯 Why I Built This
I wanted to understand SQS in a way no diagram or FAQ can teach you.
So I deployed real queues, wrote scripts, hit them with messages, and saw how they behave under real conditions.

This helped me fully understand:

- Ordering guarantees
- Deduplication behavior
- When to use FIFO vs Standard
- How SDKs and CLI interact with queues
- How IaC ties everything together
- This is the foundation of modern event-driven architecture, microservices, and serverless systems — all powered by SQS behind the scenes.
