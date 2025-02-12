;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-02-12 16:59:47>
;;; File: /home/ywatanabe/proj/emacs-slack/tests/test-esl-file.el

(require 'ert)
(require 'esl-file)

(ert-deftest test-esl-file-upload
    ()
  (let
      ((temp-file
        (make-temp-file "test-slack-upload" nil ".txt")))
    (with-temp-file temp-file
      (insert "dummy content"))
    (should
     (esl-file-upload "random" temp-file "Test Title" "Initial Comment"))))

(provide 'test-esl-file)

(when
    (not load-file-name)
  (message "test-esl-file.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))