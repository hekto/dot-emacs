(require 'find-file-in-project)

(setq ffip-prefer-ido-mode 1)
(setq ffip-limit 4096)
(add-to-list 'ffip-prune-patterns "node_modules")
(add-to-list 'ffip-prune-patterns "json")

(setq ffip-patterns '("*.html" "*.txt" "*.md" "*.json" "*.el" "*.sh" "*.js" "*.css" "*.glsl"))

(provide 'setup-ffip)
