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

(when window-system
  (set-face-attribute 'default nil :font "-apple-Monaco-medium-normal-normal-*-14-*-*-*-m-0-iso10646-1"))


(provide 'mac)
