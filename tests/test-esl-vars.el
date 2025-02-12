;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-02-12 17:01:52>
;;; File: /home/ywatanabe/proj/emacs-slack/tests/test-esl-vars.el

(require 'ert)
(require 'esl-vars)

(ert-deftest test-esl-user-token-string
    ()
  (should
   (stringp esl-user-token)))

(ert-deftest test--esl-user-map-initially-nil
    ()
  (should
   (null --esl-user-map)))

(ert-deftest test--esl-channel-map-initially-nil
    ()
  (should
   (null --esl-channel-map)))

(when
    (not load-file-name)
  (message "test-esl-user.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))

(provide 'test-esl-vars)

(when
    (not load-file-name)
  (message "test-esl-vars.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))