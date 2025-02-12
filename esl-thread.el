;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-02-12 16:28:42>
;;; File: /home/ywatanabe/proj/emacs-slack/esl-thread.el
;;; Copyright (C) 2024-2025 Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)

(require 'esl-vars)
(require 'esl-ch)
(require 'request)

;; Main
;; ----------------------------------------

(defun esl-thread-reply
    (channel thread-ts text)
  "Reply with TEXT in thread specified by THREAD-TS in CHANNEL."
  (let*
      ((channel-id
        (if
            (string-prefix-p "C" channel)
            channel
          (--esl-ch-name-to-id channel)))
       (url "https://slack.com/api/chat.postMessage")
       (headers
        `(("Authorization" . ,(concat "Bearer " esl-user-token))
          ("Content-Type" . "application/json")))
       (data
        (json-encode
         `((channel . ,channel-id)
           (thread_ts . ,thread-ts)
           (text . ,text))))
       (response
        (request-response-data
         (request url
           :type "POST"
           :headers headers
           :data data
           :parser 'json-read
           :sync t))))
    (eq
     (alist-get 'ok response)
     t)))

(defun esl-thread-get-replies
    (channel thread-ts)
  "Get replies in thread specified by THREAD-TS in CHANNEL."
  (let*
      ((channel-id
        (if
            (string-prefix-p "C" channel)
            channel
          (--esl-ch-name-to-id channel)))
       (url "https://slack.com/api/conversations.replies")
       (headers
        `(("Authorization" . ,(concat "Bearer " esl-user-token))
          ("Content-Type" . "application/json")))
       (params
        `(("channel" . ,channel-id)
          ("ts" . ,thread-ts)))
       (response
        (request-response-data
         (request url
           :type "GET"
           :headers headers
           :params params
           :parser 'json-read
           :sync t))))
    (when
        (eq
         (alist-get 'ok response)
         t)
      (append
       (alist-get 'messages response)
       nil))))

(provide 'esl-thread)

(when
    (not load-file-name)
  (message "esl-thread.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))