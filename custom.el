(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-ignores (quote ("/" "//" ";")))
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#ad7fa8" "#8cc4ff" "#eeeeec"])
 '(custom-safe-themes
   (quote
    ("08c744b837a78ad03b8e411916daea03c189b7f04d861bbb48632ca2f060da4d" "3fe1a1e20cd0eda22ea1c5c94f17e7a90a7bc7e6e350854f8409fcfe2ea2e74b" "e495d7879e9e62bef677f16278007b1e8f46b0335eced4e1a91f0a1b89c7ffab" "bd484258258801711bc85d8995d68f9a3c17112d8b48523615fd4ddb2c58cf79" default)))
 '(diff-hl-draw-borders nil)
 '(flycheck-checker-error-threshold nil)
 '(fringe-mode (quote (10 . 0)) nil (fringe))
 '(linum-format "%3d  ")
 '(mouse-wheel-progressive-speed nil)
 '(mouse-wheel-scroll-amount (quote (1 ((shift) . 1) ((control)))))
 '(nav-width 15))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diff-hl-change ((t (:background "#443322" :foreground "#999933"))) t)
 '(diff-hl-delete ((t (:inherit diff-removed :background "#332222" :foreground "#993333"))) t)
 '(diff-hl-insert ((t (:inherit diff-added :background "#223322" :foreground "#339933"))) t)
 '(flycheck-error ((t (:background "black"))))
 '(flycheck-warning ((t (:underline "#ffcc00"))))
 '(ido-subdir ((t (:foreground "orange"))))
 '(js2-function-param ((t (:foreground "orange"))))
 '(mode-line ((t (:background "#d3d7cf" :foreground "#2e3436" :box (:line-width -1 :style released-button)))))
 '(popup-tip-face ((t (:background "orange" :foreground "black" :slant italic :height 0.9))) t)
 '(show-paren-match ((t (:background "dark green" :foreground "black"))))
 '(tabbar-button ((t (:inherit tabbar-default :box nil))))
 '(tabbar-button-highlight ((t (:inherit tabbar-button))))
 '(tabbar-default ((t (:inherit default :family "Lucida Grande" :background "#3A312C" :foreground "gray40" :height 0.8))))
 '(tabbar-highlight ((t (:inherit tabbar-default :foreground "red"))))
 '(tabbar-modified ((t (:inherit tabbar-default :foreground "white"))))
 '(tabbar-selected ((t (:inherit tabbar-default :background "#2A211C" :foreground "orange"))))
 '(tabbar-selected-highlight ((t (:inherit tabbar-default :background "green"))) t)
 '(tabbar-selected-modified ((t (:inherit tabbar-default :background "yellow"))) t)
 '(tabbar-separator ((t (:inherit tabbar-default :background "gray40"))))
 '(tabbar-unselected ((t (:inherit tabbar-default :background "#3A312C" :foreground "gray60"))))
 '(tabbar-unselected-highlight ((t (:inherit tabbar-default :background "blue"))) t)
 '(tabbar-unselected-modified ((t (:inherit tabbar-default :background "orange"))) t)
 '(which-func ((t (:foreground "orange"))) t))
(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell
   (replace-regexp-in-string "[[:space:]\n]*$" ""
           (shell-command-to-string "$SHELL -l -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))
(when (equal system-type 'darwin) (set-exec-path-from-shell-PATH))
