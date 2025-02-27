;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(require 'ef-themes)

(setq
  doom-theme                     'ef-maris-dark
  doom-font                      (font-spec :family "Jetbrains Mono" :size 14.0)
  doom-localleader-key           ","
  read-process-output-max        (* 1024 1024)
  org-directory                  "~/org/"
  display-line-numbers-type      'absolute
  projectile-project-search-path '("~/dev/")
  projectile-enable-caching      nil
  evil-kill-on-visual-paste      nil
  corfu-preselect                'first)

(add-to-list 'default-frame-alist '(undecorated-round . t))

(defun cider-load-buffer-and-reload-lsp ()
  (when (and (bound-and-true-p cider-mode)
             (not (string-match-p "project.clj" (buffer-file-name))))
    (cider-load-buffer)
    ;; fix semantics tokens wrongly highlighted after modifyng the buffer
    (lsp)))

(use-package go-mode
  :hook (go-mode . (lambda () (setq tab-width 2))))

(use-package! cider
  :config (setq cider-reuse-dead-repls nil)
  :hook   (after-save . cider-load-buffer-and-reload-lsp))

(use-package magit-delta
  :hook   (magit-mode . magit-delta-mode)
  :config (setq magit-delta-default-dark-theme "DarkNeon"
                magit-delta-default-light-theme "Github"
                magit-delta-hide-plus-minus-markers t))

(use-package evil-mc
  :config
  (add-to-list 'evil-mc-incompatible-minor-modes 'paredit-mode))

(use-package! lsp-mode
  :commands lsp
  :config   (setq lsp-semantic-tokens-enable t
                  ;; auto completion was not working with the default value
                  lsp-completion-no-cache t)
  :hook     (before-save . lsp-format-buffer))

(use-package smartparens
  :hook   
  (smartparens-mode . smartparens-strict-mode))

(use-package! evil-cleverparens
  :init   (setq evil-cleverparens-swap-move-by-word-and-symbol t
                evil-cleverparens-move-skip-delimiters nil)
  :when   (modulep! :editor evil +everywhere)
  :hook   (smartparens-mode . evil-cleverparens-mode)
  :config (setq evil-move-beyond-eol t))

(after! evil
  (defalias 'forward-evil-word 'forward-evil-symbol))

(after! consult 
  (consult-customize
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file
   consult--source-recent-file consult--source-project-recent-file consult--source-bookmark
   :preview-key '(:debounce 0.2 any))
  (when (modulep! :config default)
    (consult-customize
     +default/search-project +default/search-other-project
     +default/search-project-for-symbol-at-point
     +default/search-cwd +default/search-other-cwd
     +default/search-notes-for-symbol-at-point
     +default/search-emacsd
     :preview-key '(:debounce 0.2 any))))

(use-package! lsp-dart
  :after dart-mode
  :config
  (setq lsp-dart-dap-flutter-hot-reload-on-save t
        lsp-dart-sdk-dir (expand-file-name "~/sdk-flutter/bin/cache/dart-sdk")
        lsp-dart-project-root-discovery-strategies '(closest-pubspec lsp-root))
  (set-popup-rule! "\\*LSP Dart tests\\*" :height 0.3))

(load! "+nu")
(load! "+bindings")

(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :config
  (add-to-list 'copilot-indentation-alist '(prog-mode 2))
  (add-to-list 'copilot-indentation-alist '(emacs-lisp-mode 2)))

(defun +custom/search-test-dir ()
  "Conduct a text search in files under `test-dir'."
  (interactive)
  (let* ((project-root (projectile-project-root))
         (default-directory (expand-file-name "test" project-root)))
    (call-interactively
     (cond ((modulep! :completion ivy)     #'+ivy/project-search-from-cwd)
           ((modulep! :completion helm)    #'+helm/project-search-from-cwd)
           ((modulep! :completion vertico) #'+vertico/project-search-from-cwd)
           (#'rgrep)))))

(defun +custom/search-src-dir ()
  "Conduct a text search in files under `src-dir'."
  (interactive)
  (let* ((project-root (projectile-project-root))
         (default-directory (expand-file-name "src" project-root)))
    (call-interactively
     (cond ((modulep! :completion ivy)     #'+ivy/project-search-from-cwd)
           ((modulep! :completion helm)    #'+helm/project-search-from-cwd)
           ((modulep! :completion vertico) #'+vertico/project-search-from-cwd)
           (#'rgrep)))))

(use-package aidermacs
  :config
  (setq aidermacs-backend 'vterm)
  (setq aidermacs-default-model "o3-mini")
  (setenv "AIDER_OPENAI_API_KEY" "dummy-key")
  (setenv "AIDER_OPENAI_API_BASE" "http://127.0.0.1:8899/v1")
  (global-set-key (kbd "C-c a") 'aidermacs-transient-menu))

(defun +custom/dap-dart-attach-debug (input)
  (interactive "sEnter VM Service URI: ")
  (dap-debug
   (list :type         "dart"
         :name         "Flutter: Attach"
         :request      "attach"
         :flutterMode  "debug"
         :cwd          (expand-file-name "mini-meta-repo" (getenv "NU_HOME"))
         :args         "-d macos"
         :vmServiceUri input)))

(use-package! dap-mode
  :hook (dap-stopped . (lambda (_) (call-interactively #'dap-hydra))))

(use-package pulsar
  :hook
  (after-init . pulsar-global-mode)
  :config
  (setq pulsar-pulse t)
  (setq pulsar-delay 0.025)
  (setq pulsar-iterations 10)
  (setq pulsar-face 'evil-ex-lazy-highlight)
  (add-to-list 'pulsar-pulse-functions 'flymake-goto-next-error)
  (add-to-list 'pulsar-pulse-functions 'flymake-goto-prev-error) 
  (add-to-list 'pulsar-pulse-functions 'evil-yank)
  (add-to-list 'pulsar-pulse-functions 'evil-yank-line)
  (add-to-list 'pulsar-pulse-functions 'evil-delete)
  (add-to-list 'pulsar-pulse-functions 'evil-delete-line)
  (add-to-list 'pulsar-pulse-functions 'evil-cp-yank)
  (add-to-list 'pulsar-pulse-functions 'evil-cp-yank-line)
  (add-to-list 'pulsar-pulse-functions 'evil-cp-delete)
  (add-to-list 'pulsar-pulse-functions 'evil-cp-delete-line)
  (add-to-list 'pulsar-pulse-functions 'evil-jump-item)
  (add-to-list 'pulsar-pulse-functions 'diff-hl-next-hunk)
  (add-to-list 'pulsar-pulse-functions 'diff-hl-previous-hunk)
  (add-to-list 'pulsar-pulse-functions 'evil-window-left)
  (add-to-list 'pulsar-pulse-functions 'evil-window-right)
  (add-to-list 'pulsar-pulse-functions 'evil-window-up)
  (add-to-list 'pulsar-pulse-functions 'evil-window-bottom)
  (add-to-list 'pulsar-pulse-functions 'ace-window))
