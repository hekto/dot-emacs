;; Move to trash when deleting stuff
(setq delete-by-moving-to-trash t
      trash-directory "~/.Trash/emacs")

;; Ignore .DS_Store files with ido mode
(add-to-list 'ido-ignore-files "\\.DS_Store")

;; (setenv "PATH" (concat
;;    "/usr/local/bin" ":"
;;    (getenv "PATH")
;;   )
;; )

(provide 'mac)
