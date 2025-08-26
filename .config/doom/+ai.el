;;; $DOOMDIR/+ai.el -*- lexical-binding: t; -*-

(use-package aider
  :config
  ;; Optional: Set a key binding for the transient menu
  (global-set-key (kbd "C-c a") 'aider-transient-menu) ;; for wider screen
  ;; or use aider-transient-menu-2cols / aider-transient-menu-1col, for narrow screen
  (require 'aider-doom)
  (aider-magit-setup-transients)) ;; add aider magit function to magit menu

(use-package! copilot
  ;; Disable hook to try lsp-copilot
  :hook (prog-mode . copilot-mode)
  :config
  (add-to-list 'copilot-indentation-alist '(prog-mode 2))
  (add-to-list 'copilot-indentation-alist '(emacs-lisp-mode 2)))

(use-package aidermacs
  :bind (("C-c a" . aidermacs-transient-menu))
  ;:config
  ; Set API_KEY in .bashrc, that will automatically picked up by aider or in elisp
  ;; (setenv "ANTHROPIC_API_KEY" "sk-...")
  ; defun my-get-openrouter-api-key yourself elsewhere for security reasons
  ;; (setenv "OPENROUTER_API_KEY" (my-get-openrouter-api-key))
  :custom
  ; See the Configuration section below
  (aidermacs-backend 'vterm)
  ;(aidermacs-default-model "sonnet")
  )
