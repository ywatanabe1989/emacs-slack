;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: ywatanabe
;;; Timestamp: <2025-02-12 17:19:52>
;;; File: /home/ywatanabe/proj/emacs-slack/tests/test-esl-user.el

(require 'ert)
(require 'esl-user)

(ert-deftest test-esl-user-get-all-info
    ()
  (let
      ((mock-response
        (make-request-response
         :data
         '((ok . t)
           (members .
                    [((id . "U123")
                      (real_name . "Alice"))
                     ((id . "U456")
                      (real_name . "Bob"))])))))
    (cl-letf
        (((symbol-function 'request)
          (lambda
            (&rest _)
            mock-response)))
      (should
       (equal
        (esl-user-get-all-info)
        '(((id . "U123")
           (real_name . "Alice"))
          ((id . "U456")
           (real_name . "Bob"))))))))

(ert-deftest test--esl-user-update-map
    ()
  (let
      ((mock-response
        (make-request-response
         :data
         '((ok . t)
           (members .
                    [((id . "U123")
                      (real_name . "Alice"))])))))
    (cl-letf
        (((symbol-function 'request)
          (lambda
            (&rest _)
            mock-response)))
      (--esl-user-update-map)
      (should
       (equal --esl-user-map
              '(("U123" . "Alice")))))))

(ert-deftest test--esl-user-replace-id-to-name
    ()
  (let
      ((--esl-user-map
        '(("U123" . "Alice"))))
    (should
     (equal
      (--esl-user-replace-id-to-name "Hello <@U123>!")
      "Hello @Alice!"))))

(provide 'test-esl-user)

(when
    (not load-file-name)
  (message "test-esl-user.el loaded."
           (file-name-nondirectory
            (or load-file-name buffer-file-name))))