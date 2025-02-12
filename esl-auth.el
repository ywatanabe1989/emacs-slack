;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-02-12 16:57:21>
;;; File: /home/ywatanabe/proj/emacs-slack/esl-auth.el

;; Main
;; ----------------------------------------

(defun esl-auth-verify-token
    ()
  "Verify if the Slack token is valid by attempting to list channels."
  (interactive)
  (let*
      ((url "https://slack.com/api/auth.test")
       (headers
        `(("Authorization" . ,(concat "Bearer " esl-user-token))
          ("Content-Type" . "application/json")))
       (response
        (request-response-data
         (request url :type "GET" :headers headers :parser 'json-read :sync t))))
    (if
        (eq
         (alist-get 'ok response)
         t)
        (progn
          (message "Token is valid. User: %s, Team: %s"
                   (alist-get 'user response)
                   (alist-get 'team response))
          t)
      (progn
        (error "Token verification failed: %s"
               (alist-get 'error response)))
      nil)))

(provide 'esl-auth)

(when
    (not load-file-name)
  (message "esl-auth.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))