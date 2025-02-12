<!-- ---
!-- Timestamp: 2025-02-12 17:40:09
!-- Author: ywatanabe
!-- File: /home/ywatanabe/proj/emacs-slack/README.md
!-- --- -->

# Emacs Slack (ESL)
Slack client for Emacs

## Features
- Channel management (listing, joining)
- Message operations (sending, reactions)
- File handling (uploading)
- Threading capabilities

## Installation
```elisp
;; Add to load-path
(add-to-list 'load-path "/path/to/emacs-slack")
(require 'esl)

;; Set token
(setq esl-user-token "<YOUR-USER-TOKEN>") 
```

## Basic Usage

```elisp
;; Verify setup
(esl-auth-verify-token)   ;; t or nil

;; Get Users Information
(esl-user-get-all-info)   ;; Needs parsing

;; Channel operations
(esl-ch-get-all-info)     ;; Needs parsing
(esl-ch-join "random")    ;; Join to #random channel
(esl-ch-join-all)         ;; Join to all channel

;; Send messages
(esl-msg-send "random" "Hello!") ;; Send message (and return "timestamp")
(esl-msg-get "random" 3)         ;; Get the last 3 messages

;; Add reaction to a message
;; Note that in slack, channel name + timestamp works as message identifier
(setq msg-timestamp 
  (esl-msg-send "random" "Could you add reaction to me?"))
(esl-msg-add-reaction "random" msg-timestamp "thumbsup") 

;; Thread operations
(esl-thread-reply "random" msg-timestamp "This is my reply message")
(esl-thread-get-replies "random" msg-timestamp)

;; File uploads
(esl-file-upload "random" "/path/to/file" "Title" "Comment")
```
<!-- esl-msg-on-message -->
<!-- esl-msg-on-reaction -->
<!-- esl-thread-get-replies -->



## Appendices
<details>
<summary>1. Slack App Creation</summary>

``` markdown
- Go to https://api.slack.com/apps
- Click "Create New App" > "From scratch"
- Name it and select workspace
```
</details>

<details>
<summary>1-1. Slack Token Setup (as a **user**)</summary>
``` markdown
- Go to "OAuth & Permissions" (https://api.slack.com/apps/<YOUR-APP-ID>/oauth)  
- Add **User** Token Scopes:  
  ```
  channels:history
  channels:read
  channels:write
  channels:write.invites
  channels:write.topic
  chat:write
  files:read
  files:write
  groups:history
  groups:read
  groups:write
  groups:write.invites
  groups:write.topic
  im:history
  im:read
  im:write
  im:write.topic
  mpim:history
  mpim:read
  mpim:write
  mpim:write.topic
  reactions:read
  reactions:write
  remote_files:read
  remote_files:share
  team:read
  users:read
  users:write
  ```
- Install to workspace
- Save User Token:
  ```bash
  export SLACK_USER_TOKEN="xoxp-..."
  ```
```- 
</details>

<details>
<summary>1-2. Slack Token Setup (as a **bot**)</summary>
``` markdown
- Go to "OAuth & Permissions" (https://api.slack.com/apps/<YOUR-APP-ID>/oauth)
- Add **Bot** Token Scopes:
  ```
  channels:history
  channels:join
  channels:read
  channels:write
  chat:write
  chat:write.customize
  files:read
  files:write
  groups:history
  groups:read
  groups:write
  im:history
  im:read
  im:write
  mpim:history
  mpim:read
  mpim:write
  reactions:read
  reactions:write
  team:read
  users:read
  users:write
  ```
- Install to workspace
- Save Bot Token:
  ```bash
  export SLACK_BOT_TOKEN="xoxb-..."
  ```
```
</details>

<details>
<summary>2. Working from Shell</summary>
# Check existing channels
#### Bot: xoxb-
curl -X GET \
-H "Authorization: Bearer xoxb-8373976301939-8377047361428-tU41xaJrNzg6E9Y3q3HaQdYz" \
-H "Content-type: application/json" \
https://slack.com/api/conversations.list

#### Person: xoxp-
curl -X GET \
-H "Authorization: Bearer xoxp-8373976301939-8386762178657-8387992842257-768abe7221420aa48b1521c8219896e5" \
-H "Content-type: application/json" \
https://slack.com/api/conversations.list

# Join the channel
curl -X POST \
-H "Authorization: Bearer xoxb-8373976301939-8377047361428-tU41xaJrNzg6E9Y3q3HaQdYz" \
-H "Content-type: application/json" \
-d '{"channel":"C08AU178Z8W"}' \
https://slack.com/api/conversations.join

# Send message
curl -X POST \
-H "Authorization: Bearer xoxb-8373976301939-8377047361428-tU41xaJrNzg6E9Y3q3HaQdYz" \
-H "Content-type: application/json" \
-d '{"channel":"C08AU178Z8W","text":"Hello from CLI"}' \
https://slack.com/api/chat.postMessage
</details>

## Contact
Yusuke.Watanabe@alumni.u-tokyo.ac.jp

<!-- EOF -->