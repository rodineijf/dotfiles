;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-monokai-octagon)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq
  doom-font                      (font-spec :family "Jetbrains Mono" :size 14.0)
  doom-localleader-key           ","
  read-process-output-max        (* 1024 1024)
  projectile-enable-caching      nil)

;; Fell free to move this to a bindings file you load from config.el

;; (after! paredit

;;   (define-key paredit-mode-map (kbd "C-<left>") nil)

;;   (define-key paredit-mode-map (kbd "C-<right>") nil)

;;   (map! :nvi

;;         :desc "Forward barf"
;;         "M-<left>" #'paredit-forward-barf-sexp

;;         :desc "Forward slurp"
;;         "M-<right>" #'paredit-forward-slurp-sexp

;;         :desc "Backward slurp"
;;         "M-S-<left>" #'paredit-backward-slurp-sexp

;;         :desc "Backward barf"
;;         "M-S-<right>" #'paredit-backward-barf-sexp

;;         :desc "Backward"
;;         "C-c <left>" #'paredit-backward

;;         :desc "Forward"
;;         "C-c <right>" #'paredit-forward

;;         :desc "Expand region"
;;         "s-<up>" #'er/expand-region

;;         :desc "Reverse expand region"
;;         "s-<down>" (lambda () (interactive) (er/expand-region -1))))

(defun my-before-save-hook ()
  (when (or (eq major-mode 'clojure-mode)
            (eq major-mode 'dart-mode))
    (lsp-format-buffer)))

(add-hook 'before-save-hook #'my-before-save-hook)

(require 'cider)

(defun my-cider-load-file-on-save ()
  (when (and (eq major-mode 'clojure-mode) buffer-file-name)
    (cider-load-buffer)))

(add-hook 'after-save-hook #'my-cider-load-file-on-save)

;; Modify syntax table to select words with hyphens on clojure-mode
(modify-syntax-entry ?- "w" clojure-mode-syntax-table)
(modify-syntax-entry ?| "w" clojure-mode-syntax-table)

;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>"   . 'copilot-accept-completion)
              ("TAB"     . 'copilot-accept-completion)
              ("C-TAB"   . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

(add-to-list 'warning-suppress-types '(copilot copilot-no-mode-indent))

(use-package magit-delta
  :hook (magit-mode . magit-delta-mode))

(use-package! lsp-mode
  :commands lsp
  :config
  (setq lsp-semantic-tokens-enable t))

;; set window title "[project] filename"
(setq frame-title-format
      (setq icon-title-format
            '(""
              (:eval
               (format "[%s] " (projectile-project-name)))
              "%b")))

(map! :leader
      ;; Change default search to vertico, it gives you a nice preview of the files
      :desc "Search project" "/" #'+vertico/project-search)

; I had to run this command in order to make the transparent title bar work
; defaults write org.gnu.Emacs TransparentTitleBar DARK
(add-to-list 'default-frame-alist '(ns-appearance . 'light))
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))

(use-package company-box
  :hook (company-mode . company-box-mode))
