;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-02-12 16:23:26>
;;; File: /home/ywatanabe/proj/emacs-slack/esl.el
;;; Copyright (C) 2024-2025 Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)

;; Add to load path
(add-to-list 'load-path
             (file-name-directory
              (or load-file-name buffer-file-name)))

(require 'esl-vars)
(require 'esl-ch)
(require 'esl-msg)
(require 'esl-thread)
(require 'esl-user)
(require 'esl-file)
(require 'esl-auth)

(provide 'esl)

(when
    (not load-file-name)
  (message "esl.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))