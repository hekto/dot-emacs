;; Turn off mouse interface early in startup to avoid momentary display
;;(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
;;(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; No splash screen please ... jeez
(setq inhibit-startup-message t)

;; Set path to dependencies
(setq site-lisp-dir (expand-file-name "site-lisp" user-emacs-directory))
(setq settings-dir (expand-file-name "settings" user-emacs-directory))
(setq tern-dir (expand-file-name "tern/emacs" site-lisp-dir))


;; Set up load path
(add-to-list 'load-path settings-dir)
(add-to-list 'load-path site-lisp-dir)
(add-to-list 'load-path tern-dir)

;; Keep emacs Custom-settings in separate file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;;(global-linum-mode 1)


;;(byte-recompile-directory (expand-file-name "~/.emacs.d") 0)




;; ;; Add external projects to load path
(dolist (project (directory-files site-lisp-dir t "\\w+"))
  (when (file-directory-p project)
    (add-to-list 'load-path project)))

;; Write backup files to own directory
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

;; no autosave files
(setq auto-save-default nil)

;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)

;; EOF/EOL settings
(setq next-line-add-newlines nil)
(setq track-eol nil)
(setq require-final-newline t)

;; Clean up whitespace
(add-hook 'before-save-hook 'whitespace-cleanup)

;; Save point position between sessions
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))

;; Are we on a mac?
(setq is-mac (equal system-type 'darwin))
(setq is-linux (equal system-type 'gnu/linux))

;; Setup packages
(require 'setup-package)

;; Install extensions if they're missing
(defun init--install-packages ()
  (packages-install
   '(flycheck
     flycheck-color-mode-line
     ;; flycheck-pos-tip
     ;; flycheck-tip
     rainbow-mode
     visual-regexp
     smartparens
     emmet-mode
     expand-region
     ido-ubiquitous
     js2-mode
     json-mode
     tagedit
     multiple-cursors
     anzu
     yasnippet
     s
     smex
     ;;smart-forward
     color-identifiers-mode
     tabbar
     flx
     flx-ido
     zoom-frm
    ido-vertical-mode
     find-file-in-project
     highlight-escape-sequences)))

(condition-case nil
    (init--install-packages)
  (error
   (package-refresh-contents)
   (init--install-packages)))

;; Lets start with a smattering of sanity
(require 'sane-defaults)

;; Setup environment variables from the user's shell.
;; (when is-mac
;;   (require-package 'exec-path-from-shell)
;;   (exec-path-from-shell-initialize))


;; Setup extensions
;; (eval-after-load 'ido '(require 'setup-ido))
(eval-after-load 'ivy '(require 'setup-ivy))
(require 'setup-html-mode)
(require 'setup-glsl-mode)
(require 'setup-ffip)

;; ;; Default setup of smartparens
(require 'smartparens-config)
(setq sp-autoescape-string-quote nil)
;; (--each '(css-mode-hook
;;           js-mode-hook)
;;   (add-hook it 'turn-on-smartparens-mode))

;; (--each '(css-mode-hook
;;        js-mode-hook
;;        html-mode-hook
;;        php-mode-hook)
;;   (add-hook it 'linum-mode))

(--each '(css-mode-hook
          html-mode-hook)
  (add-hook it 'flycheck-mode))

;; (--each '(css-mode-hook)
;;   (add-hook it 'auto-complete-mode))


;(add-hook 'css-mode-hook	'(lambda () (pabbrev-mode)))
;(add-hook 'php-mode-hook 'my-disable-indent-tabs-mode)
(add-hook 'makefile-mode-hook '(lambda () (setq tab-width 8)))
;(require 'php-mode)
;(add-hook 'php-mode-hook (lambda () (setq comment-start "// "
;                                        comment-end   "")))

(require 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
(add-hook 'emmet-mode-hook (lambda () (setq emmet-indentation 2))) ;indent 2 spaces.


;; Stop autocomplete on semi colon
(defun ac-css-prefix ()
  (when (save-excursion (re-search-backward "\\_<\\(.+?\\)\\_>\\s *:.*\\=\\;" nil t))
    (setq ac-css-property (match-string 1))
    (or (ac-prefix-symbol) (point))))

;; dont autocomplete (hex?) numbers.
;; (eval-after-load "auto-complete"
;;   '(progn
;;      (defun ac-prefix-default ()
;;        "Same as `ac-prefix-symbol' but ignore a number prefix."
;;        (let ((start (ac-prefix-symbol)))
;;          (when (and start
;;                   (not (string-match "^\\(?:0[xX][0-9A-Fa-f]+\\|[0-9]+\\)$"
;;                                      (buffer-substring-no-properties start (point)))))
;;            start)))
;;      ))



;; vcs diff highlight
;; (require 'diff-hl)
;; (setq diff-hl-draw-borders nil)
;; (global-diff-hl-mode)

;; clickable urls
(add-hook 'find-file-hooks 'goto-address-mode)

(setq ns-pop-up-frames nil)

;; Load stuff on demand
;;(autoload 'flycheck-mode "setup-flycheck" nil t)
;; (autoload 'auto-complete-mode "auto-complete" nil t)
(require 'setup-flycheck)
(require 'setup-yasnippet)

;; Map files to modes
(require 'mode-mappings)

;; Highlight escape sequences
(require 'highlight-escape-sequences)
(hes-mode)
(put 'font-lock-regexp-grouping-backslash 'face-alias 'font-lock-builtin-face)

;; Functions (load all files in defuns-dir)
(setq defuns-dir (expand-file-name "defuns" user-emacs-directory))
(dolist (file (directory-files defuns-dir t "\\w+"))
  (when (file-regular-p file)
    (load file)))

;; Language specific setup files
;;(eval-after-load 'js2-mode '(require 'setup-js2-mode))
(require 'setup-js-mode)

;; Visual regexp
(require 'visual-regexp)
(define-key global-map (kbd "M-&") 'vr/query-replace)
(define-key global-map (kbd "M-/") 'vr/replace)

(require 'expand-region)
(require 'multiple-cursors)
;;(require 'smart-forward)
;;(require 'change-inner)


;; Browse kill ring
;;(require 'browse-kill-ring)
;;(setq browse-kill-ring-quit-action 'save-and-restore)

;; Smart M-x is smart
(require 'smex)
(smex-initialize)

;; Misc
(when is-mac (require 'mac))
(when is-linux (require 'linux))

;; Set up appearance early
(require 'appearance)
(menu-bar-mode -1)

;; Setup key bindings
(require 'key-bindings)

(setq line-move-visual nil)

;; Make kill-line nuke leading whitespace on next line
;; should probably only be in html/css/js modes.
(defadvice kill-line (after kill-line-cleanup-whitespace activate compile)
  "cleanup whitespace on kill-line"
  (if (not (bolp))
      (delete-region (point) (progn (skip-chars-forward " \t") (point)))))


;; show matching paren in minibuffer if off screen
(defadvice show-paren-function
    (after show-matching-paren-offscreen activate)
  "If the matching paren is offscreen, show the matching line in the
        echo area. Has no effect if the character before point is not of
        the syntax class ')'."
  (interactive)
  (let* ((cb (char-before (point)))
         (matching-text (and cb
                             (char-equal (char-syntax cb) ?\) )
                             (blink-matching-open))))
    (when matching-text (message matching-text))))



;; Run at full power please
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)

(add-hook 'css-mode-hook
  (lambda ()
     (make-local-variable 'ac-ignores)
     (add-to-list 'ac-ignores ";")
     (define-key ac-complete-mode-map "\r" nil)
  ))

(require 'setup-tabbar)

;;(desktop-save-mode 1)

(global-anzu-mode +1)


;; for sr-speedbar:
(defun ad-advised-definition-p (definition) "Return non-nil if DEFINITION was generated from advice information." (if (or (ad-lambda-p definition) (macrop definition) (ad-compiled-p definition)) (let ((docstring (ad-docstring definition))) (and (stringp docstring) (get-text-property 0 ‘dynamic-docstring-function docstring)))))

(when window-system
  ;;(global-nlinum-mode 1)
  (global-linum-mode 1)
  (set-face-attribute 'linum nil
                      :inherit 'default
                      :height 100))

;;(add-hook 'after-init-hook 'global-color-identifiers-mode)
;;(setq color-identifiers:num-colors 50)
