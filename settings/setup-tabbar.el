(require 'tabbar)
(tabbar-mode 1)

;; (setq tabbar-ruler-global-tabbar t) ;; If you want tabbar
;; (setq tabbar-ruler-global-ruler nil) ;; if you want a global ruler
;; (setq tabbar-ruler-popup-menu nil) ;; If you want a popup menu.
;; (setq tabbar-ruler-popup-toolbar nil) ;; If you want a popup toolbar
;; (setq tabbar-ruler-popup-scrollbar nil) ;; If you want to only show the
;;                                         ;; scroll bar when your mouse is moving.
;; (setq tabbar-ruler-invert-deselected nil)
;; (require 'tabbar-ruler)


(custom-set-faces
 ;; '(tabbar-button ((t (:box nil))))
 ;; '(tabbar-default ((t (:inherit variable-pitch :background "gray94" :foreground "gray25" :height 0.8))))
 ;; '(tabbar-highlight ((t (:foreground "blue"))))
 ;; '(tabbar-modified ((t (:inherit tabbar-default :foreground "white"))))
 ;; '(tabbar-selected ((t (:inherit tabbar-default :background "gray95" :weight bold))))
 ;; '(tabbar-separator ((t (:background "gray50" :height 1.2))))
 ;; '(tabbar-unselected ((t (:inherit tabbar-default :background "gray85" :foreground "gray30"))))

 '(tabbar-default               ((t ( :inherit default :family "Lucida Grande" :background "#3A312C" :foreground "gray40" :height 0.8         ))))

 '(tabbar-button                ((t ( :inherit tabbar-default :box nil                                   ))))
 '(tabbar-button-highlight      ((t ( :inherit tabbar-button                                             ))))
 '(tabbar-separator             ((t ( :inherit tabbar-default :background "gray40"                       ))))
 '(tabbar-highlight             ((t ( :inherit tabbar-default                       :foreground "red"    ))))
 '(tabbar-modified              ((t ( :inherit tabbar-default                       :foreground "white"  ))))
 '(tabbar-selected              ((t ( :inherit tabbar-default :background "#2A211C" :foreground "orange" ))))
 '(tabbar-selected-highlight    ((t ( :inherit tabbar-default :background "green"                        ))))
 '(tabbar-selected-modified     ((t ( :inherit tabbar-default :background "yellow"                       ))))
 '(tabbar-unselected            ((t ( :inherit tabbar-default :background "#3A312C" :foreground "gray60" ))))
 '(tabbar-unselected-highlight  ((t ( :inherit tabbar-default :background "blue"                         ))))
 '(tabbar-unselected-modified   ((t ( :inherit tabbar-default :background "orange"                       ))))
                                                                                                         )

;; (custom-set-faces
;;  '(tabbar-default
;;    ((t (:inherit variable-pitch :family "Monaco" :background "#3A312C" :foreground "gray40" :height 0.9))))
;;  '(tabbar-highlight
;;    ((t (:foreground "blue"))))
;;  '(tabbar-modified
;;    ((t (:inherit tabbar-default :foreground "white"))))
;;  '(tabbar-selected
;;    ((t (:inherit tabbar-default  :foreground "#eab700"
;; ;                                :box '(:line-width 8 :color "white" :style released-button)
;;                                  ))))
;;  '(tabbar-unselected
;;    ((t (:inherit tabbar-default :foreground "gray40"
;; ;                                :box '(:line-width 1 :color "gray80" :style nil)
;;                                  ))))
;;  '(tabbar-separator
;;    ((t (:background "#3A312C" :height 1.0 )))
;;    )
;;  '(tabbar-button
;;    ((t (:box nil :background "#3A312C"))))
;;  )


(setq tabbar-separator (quote (0.3)))
;;(setq tabbar-separator '(100)) ;; set tabbar-separator size to 1 pixel

(setq tabbar-background-color "#3A312C")
(setq tabbar-cycle-scope (quote tabs))
(setq tabbar-use-images nil)

(defun tabbar-group-message ()
  (message (concat "tabbar group: "
                   (car (funcall tabbar-buffer-groups-function))))
)

(defun tabbar-group-up ()
  (interactive)
  (tabbar-forward-group)
  (tabbar-group-message)
)

(defun tabbar-group-down ()
  (interactive)
  (tabbar-backward-group)
  (tabbar-group-message)
)

(global-set-key [(control shift t)] 'tabbar-mode)
(global-set-key [(control shift up)] 'tabbar-group-up)
(global-set-key [(control shift down)] 'tabbar-group-down)
(global-set-key [(control shift left)] 'tabbar-backward)
(global-set-key [(control shift right)] 'tabbar-forward)
(global-set-key [C-tab] 'tabbar-forward)

(setq tabbar-buffer-groups-function
      (lambda ()
        (list (cond
               ((string-equal "*" (substring (buffer-name) 0 1)) "Emacs")
               ((eq major-mode 'dired-mode) "Dired")
               ((eq major-mode 'compilation-mode) "Compilation")
               (t "User")
               ))))


;; (setq tabbar-buffer-groups-function
;;       (lambda ()
;;      (let ((dir (expand-file-name default-directory)))
;;        (cond
;;         ((eq major-mode 'compilation-mode) (list "Compilation"))
;;         ((string-equal "*" (substring (buffer-name) 0 1)) (list "Emacs"))
;;         ((eq major-mode 'dired-mode) (list "Dired"))
;;         ((string-match-p "/.emacs.d/" dir) (list ".emacs.d"))
;;         (t (list dir)))
;;        )))


;--- from  http://emacswiki.org/emacs/TabBarMode
(defadvice tabbar-buffer-tab-label (after fixup_tab_label_space_and_flag activate)
  (setq ad-return-value (concat "  " (concat ad-return-value "  "))))


;--- From https://github.com/dholm/tabbar/blob/master/aquamacs-tabbar.el

;; you may redefine these:
(defvar tabbar-key-binding-modifier-list '(super)
  "List of modifiers to be used for keys bound to tabs.
Must call `tabbar-define-access-keys' or toggle `tabbar-mode' for
changes to this variable to take effect.")

(defvar tabbar-key-binding-keys '((49 kp-1) (50 kp-2) (51 kp-3) (52 kp-4) (53 kp-5) (54 kp-6) (55 kp-7) (56 kp-8) (57 kp-9) (48 kp-0))
  "Codes of ten keys bound to tabs (without modifiers.
This is a list with 10 elements, one for each of the first 10
tabs.  Each element is a list of keys, either of which can be
used in conjunction with the modifiers defined in
`tabbar-key-binding-modifier-list'. Must call
`tabbar-define-access-keys' or toggle `tabbar-mode' for changes
to this variable to take effect.")

(defsubst tabbar-key-command (index)	; command name
  (intern (format "tabbar-select-tab-%s" index)))

(eval-when-compile (require 'cl))
(defun tabbar-define-access-keys (&optional modifiers keys)
  "Set tab access keys for `tabbar-mode'.
MODIFIERS as in `tabbar-key-binding-modifier-list', and
KEYS defines the elements to use for `tabbar-key-binding-keys'."
  (if modifiers (setq tabbar-key-binding-modifier-list modifiers))
  (if keys (setq tabbar-key-binding-keys keys))
  (loop for keys in tabbar-key-binding-keys
        for ni from 1 to 10 do
        (let ((name (tabbar-key-command ni)))
          (eval `(defun ,name ()
                   "Select tab in selected window."
                   (interactive)
                   (tabbar-select-tab-by-index ,(- ni 1))))
          ;; store label in property of command name symbol
          (put name 'label
               (format "%c" (car keys)))
          (loop for key in keys do
                (define-key tabbar-mode-map
                  (vector (append
                           tabbar-key-binding-modifier-list
                           (list key)))
                  name)))))

(defun tabbar-select-tab-by-index (index)
  ;; (let ((vis-index (+ index (or (get (tabbar-current-tabset) 'start) 0))))
  (unless (> (length (tabbar-tabs (tabbar-current-tabset))) 1)
    ;; better window (with tabs)in this frame?

    (let ((better-w))
      (walk-windows (lambda (w)
                      (and (not better-w)
                           (with-selected-window w
                             (if (> (length (tabbar-tabs (tabbar-current-tabset t))) 1)
                                 (setq better-w w)))))
                    'avoid-minibuf (selected-frame))
      (if better-w (select-window better-w))))

  (tabbar-window-select-a-tab
   (nth index (tabbar-tabs (tabbar-current-tabset)))))

(defun tabbar-window-select-a-tab (tab)
  "Select TAB"
  (let ((one-buffer-one-frame nil)
        (buffer (tabbar-tab-value tab)))
    (when buffer

      (set-window-dedicated-p (selected-window) nil)
      (let ((prevtab (tabbar-get-tab (window-buffer (selected-window))
                                     (tabbar-tab-tabset tab)))
            (marker (cond ((bobp) (point-min-marker))
                                ((eobp) (point-max-marker))
                                (t (point-marker)))))
        (set-marker-insertion-type marker t)
;	(assq-set prevtab marker 'tab-points)
        )
      (switch-to-buffer buffer)
;      (let ((new-pt (cdr (assq tab tab-points))))
;	(and new-pt
;            (eq (marker-buffer new-pt) (window-buffer (selected-window)))
;            (let ((pos (marker-position new-pt)))
;              (unless (eq pos (point))
;                (if transient-mark-mode
;                    (deactivate-mark))
;                (goto-char pos))
;              (set-marker new-pt nil) ;; delete marker
;              )))
          )))
; (marker-insertion-type (cdr (car tab-points)))

(tabbar-define-access-keys)


;--- start with only a window
(run-with-idle-timer 0 nil (quote delete-other-windows))



;; (setq-default mode-line-format
;;     (list
;;      '(:eval (when (tabbar-mode-on-p)
;;                (concat (propertize (car (funcall tabbar-buffer-groups-function)) 'face 'font-lock-string-face) " > ")))
;;   ))
(provide 'setup-tabbar)
