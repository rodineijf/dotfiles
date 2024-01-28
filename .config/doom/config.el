;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq
  doom-theme                     'doom-monokai-octagon
  doom-font                      (font-spec :family "Jetbrains Mono" :size 14.0)
  doom-localleader-key           ","
  read-process-output-max        (* 1024 1024)
  org-directory                  "~/org/"
  display-line-numbers-type      'relative
  projectile-project-search-path '("~/dev/")
  projectile-enable-caching      nil)

(use-package! cider
  :hook
  (after-save . cider-load-buffer)
  :config
  (modify-syntax-entry ?- "w" clojure-mode-syntax-table)
  (modify-syntax-entry ?| "w" clojure-mode-syntax-table))

;; accept completion from copilot and fallback to company
(use-package! copilot
  :init
  (add-to-list 'warning-suppress-types '(copilot copilot-no-mode-indent))
  :hook
  (prog-mode . copilot-mode)
  :bind
  (:map copilot-completion-map
        ("<tab>"   . 'copilot-accept-completion)
        ("TAB"     . 'copilot-accept-completion)
        ("C-TAB"   . 'copilot-accept-completion-by-word)
        ("C-<tab>" . 'copilot-accept-completion-by-word)))


(use-package magit-delta
  :hook
  (magit-mode . magit-delta-mode))

(use-package! lsp-mode
  :commands
  lsp
  :config
  (setq lsp-semantic-tokens-enable t)
  :hook
  (before-save . lsp-format-buffer))

; I had to run this command in order to make the transparent title bar work
; defaults write org.gnu.Emacs TransparentTitleBar DARK
(use-package emacs
  :custom
  (frame-title-format '("frame" (:eval (format "[%s] " (projectile-project-name)))  "%b"))
  (icon-title-format '("icon" (:eval (format "[%s] " (projectile-project-name)))  "%b"))
  :config
  (add-to-list 'default-frame-alist '(ns-appearance . 'light))
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t)))
 
(use-package company-box
  :hook (company-mode . company-box-mode))

(load! "+nu")
(load! "+bindings")
