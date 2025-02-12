;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-02-12 17:00:38>
;;; File: /home/ywatanabe/proj/emacs-slack/tests/test-esl-thread.el

(require 'ert)
(require 'esl-thread)

(ert-deftest test-esl-thread-reply
    ()
  (let
      ((timestamp
        (esl-msg-send "random" "Hello")))
    (should
     (esl-thread-reply "random" timestamp "Reply message"))))

(provide 'test-esl-thread)

(when
    (not load-file-name)
  (message "test-esl-thread.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))