(setq font-lock-maximum-decoration t
      color-theme-is-global t)

(setq ring-bell-function (lambda () (message "*beep*")))


;; Highlight current line
;;(global-hl-line-mode 1)

;; Set custom theme path
(setq custom-theme-directory (concat user-emacs-directory "themes"))

;; Load default theme
(load-theme 'marcus t)

;; Don't defer screen updates when performing operations
(setq redisplay-dont-pause t)

;; Highlight matching parentheses when the point is on them.
(show-paren-mode 1)

(defun get-default-height ()
  (- (/ (display-pixel-height) (frame-char-height)) 3))

(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b")))
  (tooltip-mode -1)
  (blink-cursor-mode -1)
  ;; (set-frame-height (selected-frame) 72)
  ;; (set-frame-width (selected-frame) 140)
  (add-to-list 'default-frame-alist '(width . 140))
  (add-to-list 'default-frame-alist (cons 'height (get-default-height)))
  (set-frame-position (selected-frame) 250 0)
  (setq whitespace-style '(tabs spaces trailing space-before-tab indentation space-after-tab space-mark tab-mark empty))
  (setq show-paren-delay 0.5)
  (show-paren-mode 1)
  (column-number-mode 1)
  )

(when (not window-system)
  (xterm-mouse-mode))


;;(when not window-system

;; Make zooming affect frame instead of buffers
;;(require 'zoom-frm)

;;--
;; Mode line setup

;;  ("%e" mode-line-front-space mode-line-mule-info mode-line-client mode-line-modified mode-line-remote mode-line-frame-identification mode-line-buffer-identification "   " mode-line-position
;; (vc-mode vc-mode)
;; "  " mode-line-modes mode-line-misc-info mode-line-end-spaces)

(setq-default
 mode-line-format
 '(; Position, including warning for 80 columns
   (:propertize "%4l:" face mode-line-position-face)
   (:eval (propertize "%3c" 'face
                      (if (>= (current-column) 80)
                          'mode-line-80col-face
                        'mode-line-position-face)))
                                        ; emacsclient [default -- keep?]
   mode-line-client
   "  "
                                        ; read-only or modified status

   (:propertize mode-line-modified
                face mode-line-modified-face)

   ;; (:eval
   ;;  (cond (buffer-read-only
   ;;         (propertize "RO" 'face 'mode-line-read-only-face))
   ;;        ((buffer-modified-p)
   ;;         (propertize "**" 'face 'mode-line-modified-face))
   ;;        (t "      ")))
   "    "
                                        ; directory and buffer/file name
   ;; (:propertize mode-line-buffer-identification
   ;;              face mode-line-filename-face)

   (:propertize (:eval (shorten-directory default-directory 15))
                face mode-line-folder-face)
   (:propertize "%b"
                face mode-line-filename-face)

                                        ; narrow [default -- keep?]
   " %n "
                                        ; mode indicators: vc, recursive edit, major mode, minor modes, process, global



   (vc-mode vc-mode)
   "  %["
   (:propertize mode-name
                face mode-line-mode-face)
   "%] "
   (:eval (propertize (format-mode-line minor-mode-alist)
                      'face 'mode-line-minor-mode-face))
   (:propertize mode-line-process
                face mode-line-process-face)
   (global-mode-string global-mode-string)
   "    "
   (:propertize which-func-format
                face mode-line-mode-face)

                                        ; nyan-mode uses nyan cat as an alternative to %p
                                        ;(:eval (when nyan-mode (list (nyan-create))))
   ))

;; Helper functions
(defun shorten-directory (dir max-length)
  "Show up to max-length' characters of a directory name dir'."
  (let ((path (reverse (split-string (abbreviate-file-name dir) "/")))
        (output ""))
    (when (and path (equal "" (car path)))
      (setq path (cdr path)))
    (while (and path (< (length output) (- max-length 4)))
      (setq output (concat (car path) "/" output))
      (setq path (cdr path)))
    (when path
      (setq output (concat ".../" output)))
    output))


;; Extra mode line faces
(make-face 'mode-line-read-only-face)
(make-face 'mode-line-modified-face)
(make-face 'mode-line-folder-face)
(make-face 'mode-line-filename-face)
(make-face 'mode-line-position-face)
(make-face 'mode-line-mode-face)
(make-face 'mode-line-minor-mode-face)
(make-face 'mode-line-process-face)
(make-face 'mode-line-80col-face)

(set-face-attribute 'mode-line nil
                    :foreground "gray60" :background "#3A312C"
                    :inverse-video nil
                    :box '(:line-width 1 :color "#3A312C" :style nil))
(set-face-attribute 'mode-line-inactive nil
                    :foreground "gray80" :background "gray40"
                    :inverse-video nil
                    :box '(:line-width 1 :color "gray40" :style nil))

(set-face-attribute 'mode-line-read-only-face nil
                    :inherit 'mode-line-face
                    :foreground "#4271ae"
                    :box '(:line-width 2 :color "#4271ae"))
(set-face-attribute 'mode-line-modified-face nil
                    :inherit 'mode-line-face
                    :foreground "gray60"
                    ;;    :background "#2A211C"
                    ;;    :box '(:line-width 2 :color "#c82829")
                    :family "Menlo" :height 100)

(set-face-attribute 'mode-line-folder-face nil
                    :inherit 'mode-line-face
                    :foreground "gray40"
                    :family "Menlo" :height 100)

(set-face-attribute 'mode-line-filename-face nil
                    :inherit 'mode-line-face
                    :foreground "#eab700"
                    :weight 'bold)
(set-face-attribute 'mode-line-position-face nil
                    :inherit 'mode-line-face
                    :family "Menlo" :height 100)
(set-face-attribute 'mode-line-mode-face nil
                    :inherit 'mode-line-face
                    :foreground "gray80")
(set-face-attribute 'mode-line-minor-mode-face nil
                    :inherit 'mode-line-mode-face
                    :foreground "gray40"
                    :height 110)
(set-face-attribute 'mode-line-process-face nil
                    :inherit 'mode-line-face
                    :foreground "#718c00")
(set-face-attribute 'mode-line-80col-face nil
                    :inherit 'mode-line-position-face
                    :foreground "black" :background "#eab700")


(setq linum-format "%3d")
(when (not (window-system))
      (set-face-attribute 'mode-line nil
                          :foreground "gray60" :background "black"
                          :inverse-video nil
                          :box '(:line-width 1 :color "black" :style nil))
      (setq linum-format "%2d ")
      (set-face-background 'region "#333333")
      (set-face-foreground 'default "#cccccc")
      )

;; ido
;(set-face-attribute 'ido-only-match nil  :foreground "orange")
;(set-face-attribute 'ido-first-match nil :foreground "#eab700")

(provide 'appearance)
