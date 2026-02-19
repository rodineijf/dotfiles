;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq
 doom-theme                     'doom-gruvbox ;'doom-monokai-ristretto
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

(use-package! go-mode
  :when (modulep! :lang go)
  :hook (go-mode . (lambda () (setq tab-width 2))))

(defun cider-load-buffer-and-reload-lsp ()
  (when (and (bound-and-true-p cider-mode)
             (when-let ((file (buffer-file-name)))
               (not (string-match-p "project.clj" file))))
    (cider-load-buffer)
    ;; fix semantics tokens wrongly highlighted after modifyng the buffer
    (lsp)))

(use-package! cider
  :config (setq cider-reuse-dead-repls nil)
  :hook   (after-save . cider-load-buffer-and-reload-lsp))

(use-package! magit-delta
  :hook   (magit-mode . magit-delta-mode)
  :config (setq magit-delta-default-dark-theme "DarkNeon"
                magit-delta-default-light-theme "Github"
                magit-delta-hide-plus-minus-markers t))

(use-package! evil-mc
  :config
  (add-to-list 'evil-mc-incompatible-minor-modes 'paredit-mode))

(use-package! lsp-mode
  :commands lsp
  :config   (setq lsp-semantic-tokens-enable t
                  ;; auto completion was not working with the default value
                  lsp-completion-no-cache t))

(use-package! evil-cleverparens
  :when   (modulep! :editor evil +everywhere)
  :init   (setq evil-cleverparens-swap-move-by-word-and-symbol t
                evil-cleverparens-move-skip-delimiters nil)
  :hook   (smartparens-mode . evil-cleverparens-mode)
  :config (setq evil-move-beyond-eol t))

;; This fixes `viw` and `vaw` not working on symbols in evil mode
(after! evil
  (defalias 'forward-evil-word 'forward-evil-symbol))

(after! consult
  (consult-customize
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file
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
  :hook (dart-mode . lsp-inlay-hints-mode)
  :config
  (setq lsp-dart-dap-flutter-hot-reload-on-save t
        lsp-dart-sdk-dir (expand-file-name "~/sdk-flutter/bin/cache/dart-sdk")
        lsp-dart-project-root-discovery-strategies '(closest-pubspec lsp-root))
  (set-popup-rule! "\\*LSP Dart tests\\*" :height 0.3))

(defun +custom/search-test-dir ()
  "Conduct a text search in files under `test-dir'."
  (interactive)
  (let* ((project-root (projectile-project-root))
         (default-directory (expand-file-name "test" project-root)))
    (call-interactively #'+vertico/project-search-from-cwd)))

(defun +custom/search-src-dir ()
  "Conduct a text search in files under `src-dir'."
  (interactive)
  (let* ((project-root (projectile-project-root))
         (default-directory (expand-file-name "src" project-root)))
    (call-interactively #'+vertico/project-search-from-cwd)))

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

(defconst navi-font-lock-keywords
  '((";.*$" . 'font-lock-comment-face)
    ("^%.*$" . 'font-lock-keyword-face)
    ("^#.*$" . 'font-lock-function-name-face)
    ("<.*?>" . 'font-lock-string-face)
    ("^$.*$" . 'font-lock-variable-name-face))
  "Syntax highlighting rules for `navi-mode'.")

(define-derived-mode navi-mode fundamental-mode "Navi Cheatsheet"
  "Major mode for Navi Cheatsheet."
  (setq font-lock-defaults '((navi-font-lock-keywords))))

(add-to-list 'auto-mode-alist '("\\.cheat\\'" . navi-mode))

(defun vterm--kill-vterm-buffer-and-window (process event)
  "Kill buffer and window on vterm process termination."
  (unless (process-live-p process)
    (let ((buf (process-buffer process)))
      (when (buffer-live-p buf)
        (with-current-buffer buf
          (kill-buffer)
          (ignore-errors (delete-window))
          (message "VTerm closed."))))))

(add-hook 'vterm-mode-hook
          (lambda ()
            (add-function
             :after
             (process-sentinel (get-buffer-process (buffer-name)))
             'vterm--kill-vterm-buffer-and-window))
          :append)

(after! flutter
  (defconst flutter--test-case-regexp
    (concat "^[ \t]*\\(?:testWidgets\\|test\\|group\\|testBdc\\)([\n \t]*"
            "\\([\"']\\)\\(.*[^\\]\\(?:\\\\\\\\\\)*\\|\\(?:\\\\\\\\\\)*\\)\\1,")
    "Regexp for finding the string title of a test or test group, including testBdc.
The title will be in match 2."))

(use-package! doom-themes
  :custom
  ;; Global settings (defaults)
  (doom-themes-enable-bold t)          ; if nil, bold is universally disabled
  (doom-themes-enable-italic t)        ; if nil, italics is universally disabled
  ;; for treemacs users
  (doom-themes-treemacs-theme "doom-colors") ; use "doom-colors" for less minimal icon theme
  :config
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (nerd-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  )

(after! json-mode
  (setq js-indent-level 2))

(load! "+nu")
(load! "+bindings")
(load! "+ai")
