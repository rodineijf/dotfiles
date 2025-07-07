;;; $DOOMDIR/+ai.el -*- lexical-binding: t; -*-

;; (use-package aidermacs
;;   :bind (("C-c a" . aidermacs-transient-menu))
;;   :config
;;   (setenv "AIDER_OPENAI_API_KEY" "dummy-key")
;;   (setenv "AIDER_OPENAI_API_BASE" "http://127.0.0.1:8899/v1")
;;   :custom
;;   (aidermacs-extra-args '("--no-attribute-author" "--no-attribute-committer"))
;;   (aidermacs-backend 'vterm)
;;   (aidermacs-auto-accept-architect t)
;;   (aidermacs-exit-kills-buffer t)
;;   (aidermacs-default-chat-mode 'code)
;;   (aidermacs-auto-commits nil)
;;   (aidermacs-default-model "gpt-4.1"))
;;   

(use-package aider
  :config
  ;; For latest claude sonnet model
  (setq aider-args '("--model" "gpt-4.1" "--no-auto-accept-architect")) ;; add --no-auto-commits if you don't want it

  (setenv "AIDER_OPENAI_API_KEY" "dummy-key")
  (setenv "AIDER_OPENAI_API_BASE" "http://127.0.0.1:8899/v1")
  ;; ;;;;;;;;;; (setenv "ANTHROPIC_API_KEY" anthropic-api-key)
  ;; Or chatgpt model
  ;; (setq aider-args '("--model" "o4-mini"))
  ;; (setenv "OPENAI_API_KEY" <your-openai-api-key>)
  ;; Or use your personal config file
  ;; (setq aider-args `("--config" ,(expand-file-name "~/.aider.conf.yml")))
  ;; ;;
  ;; Optional: Set a key binding for the transient menu
  (global-set-key (kbd "C-c a") 'aider-transient-menu) ;; for wider screen
  ;; or use aider-transient-menu-2cols / aider-transient-menu-1col, for narrow screen
  (aider-magit-setup-transients)) ;; add aider magit function to magit menu

(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :config
  (add-to-list 'copilot-indentation-alist '(prog-mode 2))
  (add-to-list 'copilot-indentation-alist '(emacs-lisp-mode 2)))
