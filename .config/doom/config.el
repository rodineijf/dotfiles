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
  (after-save . (lambda ()
                        (when (and (bound-and-true-p cider-mode)
                                   (not (string-match-p "project.clj" (buffer-file-name))))
                          (cider-load-buffer))))
  :config
  (modify-syntax-entry ?: "w" clojure-mode-syntax-table)
  (modify-syntax-entry ?- "w" clojure-mode-syntax-table)
  (modify-syntax-entry ?| "w" clojure-mode-syntax-table)
  (modify-syntax-entry ?. "w" clojure-mode-syntax-table)
  (modify-syntax-entry ?/ "w" clojure-mode-syntax-table))

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
  (magit-mode . magit-delta-mode)
  :config
  (setq
    magit-delta-default-dark-theme "Dracula"
    magit-delta-default-light-theme "Github"
    magit-delta-hide-plus-minus-markers t))

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

(after! paredit
  (define-key paredit-mode-map (kbd "C-<left>") nil)
  (define-key paredit-mode-map (kbd "C-<right>") nil)

  (map! :nvi

        :desc "Forward barf"
        "C-}" #'paredit-forward-barf-sexp

        :desc "Forward slurp"
        "C-)" #'paredit-forward-slurp-sexp

        :desc "Backward slurp"
        "C-(" #'paredit-backward-slurp-sexp

        :desc "Backward barf"
        "C-{" #'paredit-backward-barf-sexp

        :desc "Backward"
        "C-c <left>" #'paredit-backward

        :desc "Forward"
        "C-c <right>" #'paredit-forward))

(load! "+nu")
(load! "+bindings")
