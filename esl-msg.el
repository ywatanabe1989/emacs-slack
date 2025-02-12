;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-02-12 17:26:32>
;;; File: /home/ywatanabe/proj/emacs-slack/esl-msg.el
;;; Copyright (C) 2024-2025 Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)

(require 'esl-vars)
(require 'esl-ch)
(require 'request)

;; Main
;; ----------------------------------------

(defun esl-msg-send
    (channel text)
  "Send TEXT message to CHANNEL (name or ID). Returns timestamp if successful, nil otherwise."
  (let*
      ((channel-id
        (if
            (string-prefix-p "C" channel)
            channel
          (--esl-ch-name-to-id channel)))
       (url "https://slack.com/api/chat.postMessage")
       (headers
        `(("Authorization" . ,(concat "Bearer " esl-user-token))
          ("Content-Type" . "application/json; charset=utf-8")))
       (data
        (json-encode-alist
         `(("channel" . ,channel-id)
           ("text" . ,text))))
       (response
        (request-response-data
         (request url
           :type "POST"
           :headers headers
           :data data
           :parser 'json-read
           :sync t))))
    (if
        (eq
         (alist-get 'ok response)
         t)
        (alist-get 'ts response)
      (progn
        (error "Error: %s"
               (alist-get 'error response))
        nil))))

(defun esl-msg-get
    (channel &optional limit)
  "Get message history from CHANNEL, optionally limiting to LIMIT messages."
  (let*
      ((channel-id
        (if
            (string-prefix-p "C" channel)
            channel
          (--esl-ch-name-to-id channel)))
       (url "https://slack.com/api/conversations.history")
       (headers
        `(("Authorization" . ,(concat "Bearer " esl-user-token))
          ("Content-Type" . "application/json")))
       (params
        `(("channel" . ,channel-id)
          ,@(when limit
              `(("limit" . ,limit)))))
       (response
        (request-response-data
         (request url :type "GET" :headers headers :params params :parser 'json-read :sync t))))
    (when
        (eq
         (alist-get 'ok response)
         t)
      (append
       (alist-get 'messages response)
       nil))))

(defun esl-msg-add-reaction
    (channel timestamp emoji)
  "Add EMOJI reaction to message in CHANNEL at TIMESTAMP."
  (let*
      ((channel-id
        (if
            (string-prefix-p "C" channel)
            channel
          (--esl-ch-name-to-id channel)))
       (url "https://slack.com/api/reactions.add")
       (headers
        `(("Authorization" . ,(concat "Bearer " esl-user-token))
          ("Content-Type" . "application/json")))
       (data
        (json-encode
         `((channel . ,channel-id)
           (timestamp . ,timestamp)
           (name . ,emoji))))
       (response
        (request-response-data
         (request url :type "POST" :headers headers :data data :parser 'json-read :sync t))))
    (eq
     (alist-get 'ok response)
     t)))

;; 2. Event handlers
;; ----------------------------------------
(defun esl-msg-on-message
    (event)
  "Handle incoming message EVENT."
  (let*
      ((text
        (alist-get 'text event))
       (channel
        (alist-get 'channel event))
       (user
        (alist-get 'user event))
       (ts
        (alist-get 'ts event)))
    (message "Message from %s in %s: %s"
             user
             (--esl-ch-id-to-name channel)
             text)))

(defun esl-msg-on-reaction
    (event)
  "Handle reaction EVENT."
  (let*
      ((reaction
        (alist-get 'reaction event))
       (channel
        (alist-get 'item_channel event))
       (ts
        (alist-get 'item_ts event))
       (user
        (alist-get 'user event)))))

;; 3. Message formatting utilities
;; ----------------------------------------
(defun --esl-msg-format-message
    (text &optional mrkdwn)
  "Format message TEXT with optional MRKDWN flag."
  (if mrkdwn
      (json-encode
       `((text . ,text)
         (mrkdwn . t)))
    (json-encode
     `((text . ,text)))))

(defun --esl-msg-format-message-blocks
    (blocks)
  "Format message BLOCKS into Slack block format."
  (json-encode
   `((blocks . ,blocks))))

(provide 'esl-msg)

(when
    (not load-file-name)
  (message "esl-msg.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))