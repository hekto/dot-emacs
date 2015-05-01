(global-unset-key (kbd "s-t")) ;; annoying default font popup
(global-set-key (kbd "C-<up>")   'previous-line)
(global-set-key (kbd "C-<down>")   'next-line)
(global-set-key (kbd "M--")   'undo)
(global-set-key (kbd "C--")   'undo)
;;(global-set-key (kbd "s-1")   'whitespace-mode)
;;(global-set-key (kbd "`")     'pabbrev-expand-maybe)
(global-set-key [?\C-c ?c]    'compile)
;;(global-set-key [?\C-c ?n]    'repeat-next-error)
;;(global-set-key [?\C-c ?p]    'repeat-prev-error)
(global-set-key (kbd "C-.") 'flycheck-next-error)
(global-set-key (kbd "C-,") 'flycheck-previous-error)
(global-set-key (kbd "C-S-n") 'flycheck-next-error)
(global-set-key (kbd "C-S-p") 'flycheck-previous-error)
(global-set-key [?\C-x ?n]    'repeat-diff-hl-goto-next-hunk)
(global-set-key [?\C-x ?p]    'repeat-diff-hl-goto-prev-hunk)
;;(global-set-key [?\C-c ?\C-c] 'comment-region)
(global-set-key (kbd "C-c c") 'comment-region)
(global-set-key (kbd "C-c u") 'uncomment-region)
;;(global-set-key [?\C-c ?\C-u] 'uncomment-region)
(global-set-key [?\C-c ?\C-i] 'indent-region)
(global-set-key [?\C-c ?\C-g] 'goto-line)
(global-set-key (kbd "C-c g") 'goto-line)

;;(global-set-key (kbd "C-x f") 'recentf-ido-find-file)
(global-set-key (kbd "C-x f") 'find-file-in-project)
(global-set-key (kbd "C-c r") 'revert-buffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)

(global-set-key (kbd "M-[") 'insert-pair)
(global-set-key (kbd "M-{") 'insert-pair)
(global-set-key (kbd "M-\"") 'insert-pair)
(global-set-key (kbd "M-'") 'insert-pair)
(global-set-key (kbd "M-]") 'delete-pair)

(defun align-= (p1 p2)
  "Align lines by ="
  (interactive "r")
  (align-regexp p1 p2 "\\(\\s-*\\)=" 1 1 nil)
)

(defun align-paragraph-= ()
  "Align paragraph by ="
  (interactive)
  (save-excursion
    (mark-paragraph)
    (align-= (region-beginning) (region-end)))
)

(defun align-arg (p1 p2 c)
  "Align lines by <char>"
  (interactive "r")
  (align-regexp p1 p2 (concat "\\(\\s-*\\)" c) 1 1 nil)
)

(defun align-paragraph-arg (c)
  "Align paragraph by <char>"
  (interactive)
  (save-excursion
    (unless mark-active (mark-paragraph))
    (align-arg (region-beginning) (region-end) c))
)

;; todo: identify adjacent lines with " = " in them and set points and run em all... so i dont have to mark the block!
;; mark-paragraph with M-h
(global-set-key (kbd "C-c =") 'align-paragraph-= )
(global-set-key (kbd "C-c =") (lambda () (interactive) (align-paragraph-arg "=")))
(global-set-key (kbd "C-c :") (lambda () (interactive) (align-paragraph-arg ":")))
(global-set-key (kbd "C-c ,") (lambda () (interactive) (align-paragraph-arg ",")))
(global-set-key (kbd "C-c [") (lambda () (interactive) (align-paragraph-arg "\\[")))
(global-set-key (kbd "C-c ]") (lambda () (interactive) (align-paragraph-arg "\\]")))
(global-set-key (kbd "C-c /") (lambda () (interactive) (align-paragraph-arg "//")))
(global-set-key (kbd "C-c (") (lambda () (interactive) (align-paragraph-arg "(")))
(global-set-key (kbd "C-c )") (lambda () (interactive) (align-paragraph-arg ")")))
(global-set-key (kbd "C-c {") (lambda () (interactive) (align-paragraph-arg "{")))
(global-set-key (kbd "C-c }") (lambda () (interactive) (align-paragraph-arg "}")))


(define-key emacs-lisp-mode-map (kbd "C-x x") 'eval-region)


;; bookmarks on fringe
(global-set-key (kbd "<left-fringe> <wheel-down>") 'bm-next-mouse)
(global-set-key (kbd "<left-fringe> <wheel-up>") 'bm-previous-mouse)
(global-set-key (kbd "<left-fringe> <mouse-1>") 'bm-toggle-mouse)

;; expand region
(global-set-key (kbd "C-=") 'er/expand-region)

;; smart forward
(global-set-key (kbd "M-<up>") 'smart-up)
(global-set-key (kbd "M-<down>") 'smart-down)
(global-set-key (kbd "M-<left>") 'smart-backward)
(global-set-key (kbd "M-<right>") 'smart-forward)


;; multiple cursors
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; ace jump mode
;;(require 'ace-jump-mode)
;;(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)


(defun rpt-next-error ()
  (interactive)
  ;;  (end-of-line)
  (flycheck-next-error)
  ;;(flycheck-tip-cycle)
  (set-temporary-overlay-map
   (let ((map (make-sparse-keymap)))
     (define-key map (kbd "n") 'rpt-next-error)
     (define-key map (kbd "p") 'rpt-previous-error)
     (define-key map (kbd "SPC") 'fix-error)
     map)))

(defun rpt-previous-error ()
  (interactive)
  ;;  (beginning-of-line)
  (flycheck-previous-error)
  ;;(flycheck-tip-cycle-reverse)
  (set-temporary-overlay-map
   (let ((map (make-sparse-keymap)))
     (define-key map (kbd "n") 'rpt-next-error)
     (define-key map (kbd "p") 'rpt-previous-error)
     (define-key map (kbd "SPC") 'fix-error)
     map)))

(defun fix-error ()
  (interactive)
  (if (looking-at ";")
      (delete-char 1)
    (save-excursion
      (right-char)
      (cond ((looking-at "(") (right-char) (insert " "))
	    ((looking-at "\\[") (right-char) (insert " "))
	    ((looking-at "=") (insert "="))
	    ((looking-at ")") (insert " "))
	    ((looking-at "]") (insert " ")))))



  (flycheck-buffer)
  (flycheck-next-error)

  (set-temporary-overlay-map
   (let ((map (make-sparse-keymap)))
     (define-key map (kbd "n") 'rpt-next-error)
     (define-key map (kbd "p") 'rpt-previous-error)
     (define-key map (kbd "SPC") 'fix-error)
     map)))




(global-set-key [?\C-c ?n]    'rpt-next-error)
(global-set-key [?\C-c ?p]    'rpt-previous-error)


;; make repeatable command
(defmacro with-easy-repeat (&rest body)
  "Execute BODY and repeat while the user presses the last key."
  (declare (indent 0))
  `(let* ((repeat-key (and (> (length (this-single-command-keys)) 1)
			   last-input-event))
	  (repeat-key-str (format-kbd-macro (vector repeat-key) nil)))
     ,@body
     (while repeat-key
;       (message "(Type %s to repeat)" repeat-key-str)
       (let ((event (read-event)))
	 (clear-this-command-keys t)
	 (if (equal event repeat-key)
	     (progn ,@body
		    (setq last-input-event nil))
	   (setq repeat-key nil)
	   (push last-input-event unread-command-events))))))
;; ------------------------------

(defun repeat-next-error () (interactive) (with-easy-repeat (next-error)))
(defun repeat-prev-error () (interactive) (with-easy-repeat (previous-error)))

(defun repeat-diff-hl-goto-next-hunk () (interactive) (with-easy-repeat (diff-hl-next-hunk)))
(defun repeat-diff-hl-goto-prev-hunk () (interactive) (with-easy-repeat (diff-hl-previous-hunk)))


(provide 'key-bindings)
