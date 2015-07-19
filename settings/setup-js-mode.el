(message "Setting up js²")
(require 's)
;;(require 'js)
(require 'js2-mode)
;;(require 'js2-indent)

;; (add-to-list 'load-path (expand-file-name "tern/emacs" site-lisp-dir))
;; (autoload 'tern-mode "tern.el" nil t)
;; (require 'tern)

(defun js2-mode-inside-comment-or-string ()
  "Return non-nil if inside a comment or string."
  (or
   (let ((comment-start
          (save-excursion
            (goto-char (point-at-bol))
            (if (re-search-forward "//" (point-at-eol) t)
                (match-beginning 0)))))
     (and comment-start
          (<= comment-start (point))))
   (let ((parse-state (syntax-ppss)))
     (or (nth 3 parse-state)
         (nth 4 parse-state)))))


(setq-default js2-idle-timer-delay 0.01)
(setq-default js2-allow-rhino-new-expr-initializer nil)

(setq-default js2-enter-indents-newline t)
(setq-default js2-idle-timer-delay 0.1)
(setq-default js2-auto-indent-p t)
(setq-default js2-basic-offset 4)
(setq-default js-indent-level 4)

;; '(js-flat-functions t)
;; '(js2-auto-indent-p t t)
;; '(js2-basic-offset 2)
;; '(js2-enter-indents-newline t t)
;; '(js2-highlight-level 3)
;; '(js2-idle-timer-delay 0.001)
;; '(js2-mode-show-parse-errors nil)
;; '(js2-mode-show-strict-warnings nil)
;; '(js2-skip-preprocessor-directives t)

(setq-default js2-highlight-level 3)
(setq-default js2-mode-show-parse-errors nil)
(setq-default js2-mode-show-strict-warnings nil)
(setq-default js2-skip-preprocessor-directives t)



(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . json-mode))
(add-to-list 'auto-mode-alist '("\\.eslintrc$" . json-mode))

;; (add-hook 'js-mode-hook 'js2-minor-mode)
;; (add-hook 'js-mode-hook (lambda() (setq mode-name "js")))
;; (add-hook 'js-mode-hook (lambda () (flycheck-mode 1)))
;; (add-hook 'js-mode-hook 'electric-indent-mode)

(add-hook 'js2-mode-hook
          (lambda()
            (setq mode-name "js²")
            (set (make-local-variable 'indent-line-function) 'js-indent-line)
            (flycheck-mode 1)
            ;;(run-with-idle-timer 1 t 'font-lock-fontify-buffer)
            ;; (rainbow-identifiers-mode)
            ;; (setq rainbow-identifiers-faces-to-override '(font-lock-type-face
            ;;                                               font-lock-variable-name-face
            ;;                                               font-lock-function-name-face))

            ))
;; (add-hook 'js2-mode-hook (lambda()
;; (add-hook 'js2-mode-hook (lambda () ))
;; (add-hook 'js2-mode-hook (lambda ()




;; js2-mode steals TAB, let's steal it back for yasnippet
;; (defun js2-tab-properly ()
;;   (interactive)
;;   (let ((yas-fallback-behavior 'return-nil))
;;     (unless (yas-expand)
;;       (indent-for-tab-command)
;;       (if (looking-back "^\s*")
;;           (back-to-indentation)))))

;; (define-key js2-mode-map (kbd "TAB") 'js2-tab-properly)

(setq ac-source-yasnippet nil)

;; (add-hook 'js2-mode-hook
;;           (lambda ()
;;             (require 'js)
;;             (setq indent-line-function 'js-indent-line)
;;             ))

(require 'json)

;; troubles...
;; - kill with scope
;; - slurp multiline ( )
;; - barf multiline ( )
(defun mm-slurp-line ()
  (interactive)
  (save-excursion
    (end-of-line)
    (if (looking-back "{};?")
        (progn (search-backward "}")
               (newline)
               (indent-region (line-beginning-position) (line-end-position)))

      (let ((str (nth 1 (syntax-ppss))))
        (when str
          (goto-char str)
          (forward-list)
          (forward-line)
          (if (looking-at ".*{\$")
              (progn (end-of-line)
                     (backward-char)
                     (let ((lstart (line-number-at-pos (point))))
                       (forward-list)
                       (let ((lend (line-number-at-pos (point))))
                         (backward-list)
                         (transpose-lines (+ 1 (- lend lstart)))
                         (indent-region str (point)))))
            ;; (if (looking-at ".*([^)]*\$")
            ;;     (progn)

            (if (looking-at ".*\\[\$")
                (progn (let ((beg (line-beginning-position) ))
                         (forward-list)
                         (end-of-line)
                         (let ((lines (delete-and-extract-region beg (+ 1 (point)))))
                           (previous-line)
                           (insert lines))
                         ))
              (when (looking-at ".*)\$")
                (transpose-lines 1))
              (transpose-lines 1))
            (indent-region str (point))))))))

(defun mm-barf-line ()
  (interactive)
  (save-excursion
    (end-of-line)
    (let ((str (nth 1 (syntax-ppss))) (open-line (line-number-at-pos (point))))
      (when str
        (goto-char str)
        (forward-list)

        (if (= (+ 1 open-line) (line-number-at-pos (point)))
            (progn (beginning-of-line) (delete-backward-char 1))
          (previous-line)
          (end-of-line)

          (if (looking-back "}[,;]?\\|][,;]?")
              (progn (next-line)
                     (let ((close (point)) (line-text (delete-and-extract-region (line-beginning-position) (+ 1 (line-end-position)))))
                       (previous-line)
                       (end-of-line)
                       (backward-list)
                       (beginning-of-line)
                       (let ((open (point)))
                         (insert line-text)
                         (indent-region open close))
                       ))
            (forward-line)
            (transpose-lines 1)
            (previous-line 3)
            (when (looking-at ".*)\$")
              (forward-line)
              (transpose-lines 1)
              (forward-line))

            (indent-region str (point))))))))



(defun mm-set-region (start end)
  (interactive)
  (goto-char start)
  (set-mark-command nil)
  (goto-char end)
  (setq deactivate-mark nil))

(define-key js2-mode-map (kbd "s-<right>") 'mm-slurp-line)
(define-key js2-mode-map (kbd "s-<left>") 'mm-barf-line)

(define-key js2-mode-map (kbd "s-<right>") 'mm-slurp-line)


;; (font-lock-add-keywords 'js2-mode '(("[^?]\\s-*\\(\\sw+\\)\\s-*:" 1 font-lock-function-name-face)))
(font-lock-add-keywords 'js2-mode '(("\\([;()]\\)" 0 '(:foreground "#71685E") nil)))

(font-lock-add-keywords 'js2-mode '(("\\.\\(prototype\\|undefined\\)" 0 font-lock-builtin-face)))


;; (font-lock-add-keywords 'js2-mode
;;   '(("\\_<\\([[:upper:]_]\\{2,\\}+\\)\\_>" . font-lock-function-name-face)))

;; (font-lock-add-keywords 'js2-mode
;;    '(("<\\(global\\|require\\|process\\|module\\|console\\|prototype\\)>" . font-lock-builtin-face)))


;; (add-hook 'js2-mode-hook
;;           (lambda ()
;;             (set (make-local-variable 'compile-command)
;;                  (concat "jshint -c ~/.jshintrc-prod " buffer-file-name))))

;; (require 'compile)
;; (add-to-list 'compilation-error-regexp-alist-alist '(jshint "^\\(.*\\): line \\([0-9]+\\), col \\([0-9]+\\), " 1 2 3))
;; (add-to-list 'compilation-error-regexp-alist 'jshint)

;; compensate for mess with js2-mode highlighting and added keywords..

(define-key js2-mode-map [down-mouse-1] #'js2-mode-show-node)
(setq js2-mode-dev-mode-p t)

(defun my-disable-indent-tabs-mode ()
  (set-variable 'indent-tabs-mode nil)
  (set-variable 'whitespace-indent-tabs-mode nil))

;; Nice comma leading list automacy
(define-key js2-mode-map (kbd "SPC")
  `(lambda ()
     (interactive)
     (when (and (looking-at ")") (looking-back "(")) (funcall 'self-insert-command 1) (backward-char))
     (when (and (looking-at "]") (looking-back "\\[")) (funcall 'self-insert-command 1) (backward-char))
     (when (and (looking-at "}") (looking-back "{")) (funcall 'self-insert-command 1) (backward-char))
     (funcall 'self-insert-command 1)
     (mm-remove-all-this-cruft-on-backward-delete)
     ))

(define-key js2-mode-map (kbd "RET")
  `(lambda ()
     (interactive)
     (when (and (looking-at "]") (looking-back "\\[")) (save-excursion (newline-and-indent)))
     (when (and (looking-at "}") (looking-back "{")) (save-excursion (newline-and-indent)))
     (newline-and-indent)
     (mm-remove-all-this-cruft-on-backward-delete)
     ))

(define-key js2-mode-map (kbd ";")
  `(lambda ()
     (interactive)
     (if (looking-at ";")
         (forward-char)
       (funcall 'self-insert-command 1))))

(defun mm-remove-all-this-cruft-on-backward-delete ()
  (set-temporary-overlay-map
   (let ((map (make-sparse-keymap)))
     (define-key map (kbd "DEL") 'undo)
     map) nil))


(defun mm-setup-pair (open close)
  (define-key js2-mode-map (kbd open)
    `(lambda ()
       (interactive)
       (if (looking-at (regexp-quote ,open))
           (forward-char (length ,open))
         (funcall 'self-insert-command 1)
         (when (looking-at "\$\\|[\\ \\.\\,\\)\\;]")
           (insert ,close)
           (backward-char (+ (length ,close)))))
       (mm-remove-all-this-cruft-on-backward-delete)
       ))

  (define-key js2-mode-map (kbd close)
    `(lambda ()
       (interactive)
       (if (looking-at (regexp-quote ,close))
           (forward-char (length ,close))
         (funcall 'self-insert-command 1)))))

(defun mm-setup-single (open)
  (define-key js2-mode-map (kbd open)
    `(lambda ()
       (interactive)
       (if (looking-at ,open)
           (forward-char (length ,open))
         (let ((str (nth 3 (syntax-ppss))))
           (funcall 'self-insert-command 1)
           (when (looking-at "\$\\|[\\ \\.\\,\\)\\;]")
             (unless str
               (insert ,open)
               (backward-char (+ (length ,open))))))))))

;; (mm-setup-pair "(" ")")
;; (mm-setup-pair "{" "}")
;; (mm-setup-pair "[" "]")
;; (mm-setup-single "'")
;; (mm-setup-single "\"")


;; Copied from https://github.com/magnars/.emacs.d/blob/master/settings/setup-js2-mode.el
;; Set up wrapping of pairs, with the possiblity of semicolons thrown into the mix

(defun js2r--setup-wrapping-pair (open close)

  (let ((open open))
    (define-key js2-mode-map (kbd open)
      `(lambda ()
         (interactive)
         (js2r--self-insert-wrapping ,open ,close)))
    (unless (string= open close)
      (define-key js2-mode-map (kbd close)
        `(lambda ()
           (interactive)
           (js2r--self-insert-closing ,open ,close))))))

(define-key js2-mode-map (kbd ";")
  (lambda ()
    (interactive)
    (if (looking-at ";")
        (forward-char)
      (funcall 'self-insert-command 1))))

(defun js2r--self-insert-wrapping (open close)
  (cond
   ((use-region-p)
    (save-excursion
      (let ((beg (region-beginning))
            (end (region-end)))
        (goto-char end)
        (insert close)
        (goto-char beg)
        (insert open))))

   ((and (s-equals? open close)
         ;;(looking-back (regexp-quote open)))
         (looking-at (regexp-quote close)))
    (forward-char (length close)))

   ((js2-mode-inside-comment-or-string)
    (funcall 'self-insert-command 1))

   (:else
    (let ((end (js2r--something-to-close-statement)))
      ;; (insert open close end)
      ;; (backward-char (+ (length close) (length end)))
      (insert open)
      (when (looking-at "\$\\|[\\ \\.\\,\\)\\;]")
        (insert close end)
        (backward-char (+ (length close) (length end))))
      (js2r--remove-all-this-cruft-on-backward-delete)))))

(defun js2r--remove-all-this-cruft-on-backward-delete ()
  (set-temporary-overlay-map
   (let ((map (make-sparse-keymap)))
     (define-key map (kbd "DEL") 'undo)
     (define-key map (kbd "C-h") 'undo)
     map) nil))

(defun js2r--self-insert-closing (open close)
  (if (and (looking-back (regexp-quote open))
           (looking-at (regexp-quote close)))
      (forward-char (length close))
    (funcall 'self-insert-command 1)))

(defun js2r--does-not-need-semi ()
  (or (js2-if-node-p (js2-node-at-point))
      ;;(js2-else-node-p (js2-node-at-point)) ;; else are treated as if-nodes in js2-mode
      (js2-for-node-p (js2-node-at-point))
      (js2-while-node-p (js2-node-at-point))
      (js2-switch-node-p (js2-node-at-point))
      (js2-try-node-p (js2-node-at-point))
      (js2-catch-node-p (js2-node-at-point))
      (save-excursion (back-to-indentation)
                      (looking-at "function"))
  ))

  ;; (save-excursion
  ;;   (back-to-indentation)
  ;;   (or (looking-at "if ")
  ;;       (looking-at "function")
  ;;       (looking-at "for ")
  ;;       (looking-at "while ")
  ;;       (looking-at "try ")
  ;;       (looking-at "catch ")
  ;;       (looking-at "else "))))

(defun js2r--comma-unless (delimiter)
  (if (looking-at (concat "[\n\t\r ]*" (regexp-quote delimiter)))
      ""
    ","))

(defun js2r--something-to-close-statement ()
  (cond
   ((and (js2-block-node-p (js2-node-at-point)) (looking-at " *}")) ";")
   ((not (eolp)) "")
   ((js2-array-node-p       (js2-node-at-point)) (js2r--comma-unless "]"))
   ((js2-object-node-p      (js2-node-at-point)) (js2r--comma-unless "}"))
   ((js2-object-prop-node-p (js2-node-at-point)) (js2r--comma-unless "}"))
   ((js2-call-node-p        (js2-node-at-point)) (js2r--comma-unless ")"))
   ((and (js2-function-node-p (js2-node-at-point)) (js2-object-prop-node-p (js2-node-parent (js2-node-at-point)))) (js2r--comma-unless "}" ))
   ((and (js2-function-node-p (js2-node-at-point)) (js2-array-node-p       (js2-node-parent (js2-node-at-point)))) (js2r--comma-unless "]" ))
;;   ((and (js2-function-node-p (js2-node-at-point)) (js2-var-init-node-p       (js2-node-parent (js2-node-at-point)))) "")
   ((js2r--does-not-need-semi) "")
   (:else ";")))

(defun wantsemi ()
  (interactive)
  (print (elt (js2-node-at-point) 0))
  (print (elt (js2-node-parent (js2-node-at-point)) 0))
)

(js2r--setup-wrapping-pair "(" ")")
(js2r--setup-wrapping-pair "{" "}")
(js2r--setup-wrapping-pair "[" "]")
(js2r--setup-wrapping-pair "\"" "\"")
(js2r--setup-wrapping-pair "'" "'")

;;


(defun fix-file ()
  (interactive)
  (beginning-of-buffer)
  (replace-string "\"use strict\"" "'use strict'")
  ;; (beginning-of-buffer)
  ;; (replace-regexp "\\(;\\)$" "")
  ;; (beginning-of-buffer)
;;  (query-replace ";" "")
  ;; (beginning-of-buffer)
  ;; (query-replace-regexp "(\\([^) ]\\)" "( \\1")
  ;; (beginning-of-buffer)
  ;; (query-replace-regexp "\\([^( ]\\))" "\\1 )")

  ;; (beginning-of-buffer)
  ;; (replace-regexp ",\n\\( *\\)" "\n\\1, ")

  (whitespace-cleanup-region (point-min) (point-max))
  (indent-buffer)
  (beginning-of-buffer)
  (whitespace-cleanup)
  (beginning-of-buffer)
  (flycheck-buffer)
  )



(provide 'setup-js-mode)
