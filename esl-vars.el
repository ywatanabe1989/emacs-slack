;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-02-12 16:22:44>
;;; File: /home/ywatanabe/proj/emacs-slack/esl-vars.el
;;; Copyright (C) 2024-2025 Yusuke Watanabe (ywatanabe@alumni.u-tokyo.ac.jp)

(defconst esl-user-token ""
  "User OAuth Token.")

(defvar --esl-user-map nil
  "Association list map user IDs to user names.")

(defvar --esl-channel-map nil
  "Association list map channel names to their IDs.")

(provide 'esl-vars)

(when
    (not load-file-name)
  (message "esl-vars.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))