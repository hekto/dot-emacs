(message "Setting up flycheck")
(require 'flycheck)
(require 'flycheck-color-mode-line)
;; (require 'flycheck-tip)
;;(require 'flycheck-jscs)



;; (defun flycheck-popup-tip (errors)
;;   "Display flycheck error at point in popup-tip. Deletes old popup if it exists first."
;;   (message "tip")
;;   (when errors
;;     (let ((messages (mapcar 'flycheck-error-message errors)))
;;       (popup-tip
;;        (mapconcat 'identity messages "\n")))))



(eval-after-load "flycheck"
  '(add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode))

;; (eval-after-load 'flycheck
;;   '(custom-set-variables
;;     '(flycheck-display-errors-function #'flycheck-popup-tip)))


;; (eval-after-load 'flycheck
;;   '(custom-set-variables
;;    '(flycheck-display-errors-function #'flycheck-pos-tip-error-messages)))

;; (eval-after-load 'flycheck
;;   '(custom-set-variables
;;    '(flycheck-display-errors-function #'flycheck-pos-tip-error-messages)))


(set-face-attribute 'flycheck-color-mode-line-error-face nil
                    :background "#000000")

(set-face-attribute 'flycheck-color-mode-line-warning-face nil
                    :background "#5A512C")


(when (not (window-system))
  (set-face-background 'flycheck-color-mode-line-error-face "#990000")
  (set-face-background 'flycheck-color-mode-line-warning-face "#999900"))


(defun magnars/adjust-flycheck-automatic-syntax-eagerness ()
  "Adjust how often we check for errors based on if there are any.

This lets us fix any errors as quickly as possible, but in a
clean buffer we're an order of magnitude laxer about checking."
  (setq flycheck-idle-change-delay
        (if flycheck-current-errors 0.5 5.0)))

;; Each buffer gets its own idle-change-delay because of the
;; buffer-sensitive adjustment above.
(make-variable-buffer-local 'flycheck-idle-change-delay)

(add-hook 'flycheck-after-syntax-check-hook
          'magnars/adjust-flycheck-automatic-syntax-eagerness)

;; Remove newline checks, since they would trigger an immediate check
;; when we want the idle-change-delay to be in effect while editing.
(setq flycheck-check-syntax-automatically '(save
                                            idle-change
                                            mode-enabled))

(defun flycheck-handle-idle-change ()
  "Handle an expired idle time since the last change.

This is an overwritten version of the original
flycheck-handle-idle-change, which removes the forced deferred.
Timers should only trigger inbetween commands in a single
threaded system and the forced deferred makes errors never show
up before you execute another command."
  (flycheck-clear-idle-change-timer)
  (flycheck-buffer-automatically 'idle-change))


;; marcus here...
;; (defadvice flymake-on-timer-event (around ac-flymake-stop-advice activate)
;;   (unless ac-completing
;;     ad-do-it))
;; (ad-disable-advice 'flymake-on-timer-event 'around 'ac-flymake-stop-advice)

;; (defun hekto/disable-flycheck-during-autocomplete ()
;;   "Disable flycheck while autocomplete is running. It messes with the popup."
;;   (message "Hello world!")
;;   )


;; (add-hook 'flycheck-after-syntax-check-hook
;;           'hekto/disable-flycheck-during-autocomplete)


(setq flycheck-highlighting-mode 'columns)

;; (when (not window-system)
;;   (setq flycheck-highlighting-mode 'columns))

;; disable jshint since we prefer eslint checking
(setq-default flycheck-disabled-checkers (append flycheck-disabled-checkers '(javascript-jshint)))

;; use eslint with web-mode for jsx files
(flycheck-add-mode 'javascript-eslint 'web-mode)

;; disable json-jsonlist checking for json files
(setq-default flycheck-disabled-checkers (append flycheck-disabled-checkers '(json-jsonlist)))



(provide 'setup-flycheck)
