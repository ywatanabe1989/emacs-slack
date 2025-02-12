;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-02-12 17:26:51>
;;; File: /home/ywatanabe/proj/emacs-slack/esl-ch.el
;;; Copyright (C) 2024-2025 Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)

(require 'esl-vars)
(require 'request)

;; 1. Main
;; ----------------------------------------

(defun esl-ch-get-all-info
    ()
  "Get list of all channels."
  (let*
      ((url "https://slack.com/api/conversations.list")
       (headers
        `(("Authorization" . ,(concat "Bearer " esl-user-token))
          ("Content-Type" . "application/json")))
       (response
        (request-response-data
         (request url :type "GET" :headers headers :parser 'json-read :sync t))))
    (when
        (eq
         (alist-get 'ok response)
         t)
      (append
       (alist-get 'channels response)
       nil))))

;; 2. Core
;; ----------------------------------------

(defun esl-ch-join
    (channel-id)
  "Join a channel by its ID."
  (let*
      ((url "https://slack.com/api/conversations.join")
       (headers
        `(("Authorization" . ,(concat "Bearer " esl-user-token))
          ("Content-Type" . "application/json")))
       (data
        (json-encode
         `((channel . ,channel-id))))
       (response
        (request-response-data
         (request url :type "POST" :headers headers :data data :parser 'json-read :sync t))))
    (eq
     (alist-get 'ok response)
     t)))

(defun esl-ch-join-all
    ()
  "Join all available channels."
  (interactive)
  (let
      ((channels
        (esl-ch-get-all-info)))
    (dolist
        (channel channels)
      (let
          ((channel-id
            (alist-get 'id channel))
           (channel-name
            (alist-get 'name channel)))
        (when
            (esl-ch-join channel-id)
          (message "Joined channel: %s" channel-name))))))

;; 3. Helper
;; ----------------------------------------
(defun --esl-ch-update-map
    ()
  "Update the map between channel names and IDs."
  (let
      ((channels
        (esl-ch-get-all-info)))
    (setq --esl-channel-map
          (mapcar
           (lambda
             (channel)
             (cons
              (alist-get 'name channel)
              (alist-get 'id channel)))
           channels))))

(defun --esl-ch-name-to-id
    (channel-name)
  "Get channel ID from CHANNEL-NAME, updating map if needed."
  (--esl-ch-update-map)
  ;; (message "Channel map: %S" --esl-channel-map)
  (cdr
   (assoc channel-name --esl-channel-map)))

(defun --esl-ch-id-to-name
    (channel-id)
  "Get channel name from CHANNEL-ID, updating map if needed."
  (unless --esl-channel-map
    (--esl-ch-update-map))
  (car
   (rassoc channel-id --esl-channel-map)))

(provide 'esl-ch)

(when
    (not load-file-name)
  (message "esl-ch.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))