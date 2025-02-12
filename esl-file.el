;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-02-12 17:04:19>
;;; File: /home/ywatanabe/proj/emacs-slack/esl-file.el
;;; Copyright (C) 2024-2025 Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)

(require 'esl-vars)
(require 'esl-ch)
(require 'request)

;; Main
;; ----------------------------------------
(defun esl-file-upload
    (channel filepath &optional title initial-comment)
  "Upload file at FILEPATH to CHANNEL with optional TITLE and INITIAL-COMMENT."
  (interactive "sChannel: \nfFile: \nsTitle (optional): \nsInitial comment (optional): ")
  (let*
      ((url-get "https://slack.com/api/files.getUploadURLExternal")
       (url-complete "https://slack.com/api/files.completeUploadExternal")
       (channel-id
        (if
            (string-prefix-p "C" channel)
            channel
          (--esl-ch-name-to-id channel)))
       (filename
        (file-name-nondirectory filepath))
       (file-size
        (file-attribute-size
         (file-attributes filepath)))
       response-get
       upload-url
       file-id)

    (setq response-get
          (request-response-data
           (request url-get
             :type "POST"
             :headers
             `(("Authorization" . ,(concat "Bearer " esl-user-token))
               ("Content-Type" . "application/x-www-form-urlencoded"))
             :data
             (format "filename=%s&length=%d"
                     (url-hexify-string filename)
                     file-size)
             :parser 'json-read
             :sync t)))

    (when
        (eq
         (alist-get 'ok response-get)
         t)
      (setq upload-url
            (alist-get 'upload_url response-get))
      (setq file-id
            (alist-get 'file_id response-get))

      (let
          ((upload-response
            (request upload-url
              :type "POST"
              :files
              `(("file" . ,filepath))
              :sync t)))

        (let
            ((complete-response
              (request-response-data
               (request url-complete
                 :type "POST"
                 :headers
                 `(("Authorization" . ,(concat "Bearer " esl-user-token))
                   ("Content-Type" . "application/x-www-form-urlencoded"))
                 :data
                 (format "files=[{\"id\":\"%s\",\"title\":\"%s\"}]&channels=%s&initial_comment=%s"
                         file-id
                         (or title filename)
                         channel-id
                         (or initial-comment ""))
                 :parser 'json-read
                 :sync t))))

          complete-response)))))

(provide 'esl-file)

(when
    (not load-file-name)
  (message "esl-file.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))