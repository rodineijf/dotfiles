;;; $DOOMDIR/+ai.el -*- lexical-binding: t; -*-

(use-package aidermacs
  :bind (("C-c a" . aidermacs-transient-menu))
  :config
  (setenv "AIDER_OPENAI_API_KEY" "dummy-key")
  (setenv "AIDER_OPENAI_API_BASE" "http://127.0.0.1:8899/v1")
  :custom
  (aidermacs-backend 'vterm)
  (aidermacs-auto-accept-architect t)
  (aidermacs-exit-kills-buffer t)
  (aidermacs-use-architect-mode t)
  (aidermacs-default-model "gpt-4.1"))

(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :config
  (add-to-list 'copilot-indentation-alist '(prog-mode 2))
  (add-to-list 'copilot-indentation-alist '(emacs-lisp-mode 2)))
