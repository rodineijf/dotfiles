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

(use-package! cider
  :config
  (setq cider-reuse-dead-repls nil)
  :hook
  (after-save . (lambda ()
                        (when (and (bound-and-true-p cider-mode)
                                   (not (string-match-p "project.clj" (buffer-file-name))))
                          (cider-load-buffer)
                          ;; fix semantics tokens wrongly highlighted after modifyng the buffer
                          (lsp))))
  :config
  (dolist (char '(?* ?! ?: ?- ?| ?\. ?/ ??))
    (modify-syntax-entry char "w" clojure-mode-syntax-table)))

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
  :when (modulep! :editor evil +everywhere)
  :hook (paredit-mode . evil-cleverparens-mode))

(after! consult 
  (consult-customize
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file
   +default/search-project +default/search-other-project
   +default/search-project-for-symbol-at-point
   +default/search-cwd +default/search-other-cwd
   +default/search-notes-for-symbol-at-point
   +default/search-emacsd
   ;; find-file
   consult--source-recent-file consult--source-project-recent-file consult--source-bookmark
   :preview-key 'any))

(after! paredit
  (define-key paredit-mode-map (kbd "C-<left>") nil)
  (define-key paredit-mode-map (kbd "C-<right>") nil)

  (map! :nvi

        :desc "Forward barf"
        "M-<left>" #'paredit-forward-barf-sexp

        :desc "Forward slurp"
        "M-<right>" #'paredit-forward-slurp-sexp

        :desc "Backward slurp"
        "M-S-<left>" #'paredit-backward-slurp-sexp

        :desc "Backward barf"
        "M-S-<right>" #'paredit-backward-barf-sexp

        :desc "Backward"
        "C-c <left>" #'paredit-backward

        :desc "Forward"
        "C-c <right>" #'paredit-forward))

(use-package! lsp-dart
  :after dart-mode
  :config
  (setq lsp-dart-dap-flutter-hot-reload-on-save t)
  (setq lsp-dart-sdk-dir (expand-file-name "~/sdk-flutter/bin/cache/dart-sdk"))
  (setq lsp-dart-project-root-discovery-strategies '(closest-pubspec lsp-root))
  (set-popup-rule! "\\*LSP Dart tests\\*" :height 0.3))

(load! "+nu")
(load! "+bindings")
