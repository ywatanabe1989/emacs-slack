;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-02-12 17:19:32>
;;; File: /home/ywatanabe/proj/emacs-slack/tests/test-esl-ch.el

(require 'ert)
(require 'esl-ch)

(ert-deftest test-esl-ch-get-all-info
    ()
  (let
      ((mock-response
        (make-request-response
         :data
         '((ok . t)
           (channels .
                     [((id . "C001")
                       (name . "general"))])))))
    (cl-letf
        (((symbol-function 'request)
          (lambda
            (&rest _)
            mock-response)))
      (should
       (equal
        (esl-ch-get-all-info)
        '(((id . "C001")
           (name . "general"))))))))

(ert-deftest test-esl-ch-join
    ()
  (let
      ((mock-response
        (make-request-response
         :data
         '((ok . t)))))
    (cl-letf
        (((symbol-function 'request)
          (lambda
            (&rest _)
            mock-response)))
      (should
       (esl-ch-join "C001")))))

(provide 'test-esl-ch)

(when
    (not load-file-name)
  (message "test-esl-ch.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))