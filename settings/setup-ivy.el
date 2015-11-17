(ivy-mode)

(setq ivy-re-builders-alist
      '((t . ivy--regex-fuzzy)))

;; fuzzy matching makes it look like a rainbow...
(let ((bg "#2477c1") (fg "black"))
  (set-face-attribute 'ivy-minibuffer-match-face-1 nil :background bg :foreground fg)
  (set-face-attribute 'ivy-minibuffer-match-face-2 nil :background bg :foreground fg)
  (set-face-attribute 'ivy-minibuffer-match-face-3 nil :background bg :foreground fg)
  (set-face-attribute 'ivy-minibuffer-match-face-4 nil :background bg :foreground fg))


(provide 'setup-ivy)
