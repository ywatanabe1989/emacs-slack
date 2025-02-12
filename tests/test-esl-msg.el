;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-02-12 17:27:57>
;;; File: /home/ywatanabe/proj/emacs-slack/tests/test-esl-msg.el

(require 'ert)
(require 'esl-msg)

(ert-deftest test-esl-msg-send
    ()
  (should
   (esl-msg-send "random" "Hello")))

(ert-deftest test-esl-msg-get
    ()
  (should
   (esl-msg-get "random" 3)))

(ert-deftest test-esl-msg-add-reaction
    ()
  (let
      ((timestamp
        (esl-msg-send "random" "Hello")))
    (should
     (esl-msg-add-reaction "random" timestamp "thumbsup"))))

(provide 'test-esl-msg)

(when
    (not load-file-name)
  (message "test-esl-msg.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))