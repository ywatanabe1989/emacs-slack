;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-02-12 16:58:41>
;;; File: /home/ywatanabe/proj/emacs-slack/tests/test-esl-auth.el

(require 'ert)
(require 'esl-auth)

(ert-deftest test-esl-auth-verify-token
    ()
  (should
   (esl-auth-verify-token)))

(provide 'test-esl-auth)

(when
    (not load-file-name)
  (message "test-esl-auth.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))