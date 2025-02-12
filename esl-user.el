;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-02-12 17:19:52>
;;; File: /home/ywatanabe/proj/emacs-slack/esl-user.el
;;; Copyright (C) 2024-2025 Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)

(require 'esl-vars)
(require 'request)

;; Main
;; ----------------------------------------

(defun esl-user-get-all-info
    ()
  "Get list of all users."
  (let*
      ((url "https://slack.com/api/users.list")
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
       (alist-get 'members response)
       nil))))

;; Helper
;; ----------------------------------------

(defun --esl-user-update-map
    ()
  "Update the map between user IDs and names."
  (let
      ((users
        (esl-user-get-all-info)))
    (setq --esl-user-map
          (mapcar
           (lambda
             (user)
             (cons
              (alist-get 'id user)
              (alist-get 'real_name user)))
           users))))

(defun --esl-user-id-to-name
    (user-id)
  "Get user name from USER-ID, updating map if needed."
  (unless --esl-user-map
    (--esl-user-update-map))
  (or
   (cdr
    (assoc user-id --esl-user-map))
   user-id))

(defun --esl-user-replace-id-to-name
    (text)
  "Format TEXT by replacing user IDs with real names."
  (unless --esl-user-map
    (--esl-user-update-map))
  (replace-regexp-in-string
   "<@\\(U[A-Z0-9]+\\)>"
   (lambda
     (match)
     (let*
         ((user-id
           (match-string 1 match))
          (user-name
           (--esl-user-id-to-name user-id)))
       (concat "@" user-name)))
   text))

(provide 'esl-user)

(when
    (not load-file-name)
  (message "esl-user.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))