;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq
  doom-theme                     'doom-monokai-pro
  doom-font                      (font-spec :family "Jetbrains Mono" :size 14.0)
  doom-localleader-key           ","
  read-process-output-max        (* 1024 1024)
  org-directory                  "~/org/"
  display-line-numbers-type      'absolute
  projectile-project-search-path '("~/dev/")
  projectile-enable-caching      nil
  evil-kill-on-visual-paste      nil
  corfu-preselect                'first)

; (add-hook 'dart-mode-hook #'tree-sitter-hl-mode)

(defun cider-load-buffer-and-reload-lsp ()
  (when (and (bound-and-true-p cider-mode)
             (not (string-match-p "project.clj" (buffer-file-name))))
    (cider-load-buffer)
    ;; fix semantics tokens wrongly highlighted after modifyng the buffer
    (lsp)))

(use-package go-mode
  :hook
  (go-mode . (lambda () (setq tab-width 2))))

(use-package! cider
  :config
  (setq cider-reuse-dead-repls nil)
  :hook
  (after-save . cider-load-buffer-and-reload-lsp))

(use-package magit-delta
  :hook
  (magit-mode . magit-delta-mode)
  :config
  (setq
    magit-delta-default-dark-theme "DarkNeon"
    magit-delta-default-light-theme "Github"
    magit-delta-hide-plus-minus-markers t))

(use-package! lsp-mode
  :commands
  lsp
  :config
  (setq lsp-semantic-tokens-enable t
        ;; auto completion was not working with the default value
        lsp-completion-no-cache t)
  :hook
  (before-save . lsp-format-buffer))

(add-to-list 'default-frame-alist '(undecorated-round . t))

(use-package! paredit
  :hook ((clojure-mode . paredit-mode)
         (emacs-lisp-mode . paredit-mode)))

(use-package! evil-cleverparens
  :init   (setq evil-cleverparens-swap-move-by-word-and-symbol t)
  :when   (modulep! :editor evil +everywhere)
  :hook   (paredit-mode . evil-cleverparens-mode)
  :config
  (setq evil-move-beyond-eol t))

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
     :preview-key '(:debounce 0.2 any)))
  (consult-customize
   consult-theme
   :preview-key '("C-SPC" :debounce 0.5 'any)))

(use-package! lsp-dart
  :after dart-mode
  :config
  (setq lsp-dart-dap-flutter-hot-reload-on-save t)
  (setq lsp-dart-sdk-dir (expand-file-name "~/sdk-flutter/bin/cache/dart-sdk"))
  (setq lsp-dart-project-root-discovery-strategies '(closest-pubspec lsp-root))
  (set-popup-rule! "\\*LSP Dart tests\\*" :height 0.3))

(load! "+nu")
(load! "+bindings")

(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>"   . 'copilot-accept-completion)
              ("TAB"     . 'copilot-accept-completion)
              ("C-TAB"   . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word))
  :config
  (add-to-list 'copilot-indentation-alist '(prog-mode 2))
  (add-to-list 'copilot-indentation-alist '(emacs-lisp-mode 2)))

