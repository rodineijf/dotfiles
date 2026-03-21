;;; $DOOMDIR/+bindings.el -*- lexical-binding: t; -*-

(map! :leader
      "e" #'+treemacs/toggle  :desc "Project sidebar")
(map!
 :leader
 (:prefix ("s" . "search")
  :desc "Github search web" "g" #'+nu/search-web-region-or-prompt
  (:prefix ("c" . "custom")
   :desc "Search src dir"  "s" #'+custom/search-src-dir
   :desc "Search test dir" "t" #'+custom/search-test-dir )))

(map!
 (:map evil-window-map
       "a" #'ace-window)
 :nv "C-h" #'evil-window-left
 :nv "C-l" #'evil-window-right
 :nv "C-j" #'evil-window-down
 :nv "C-k" #'evil-window-up)

(map!
 :nvi "C-)" #'sp-forward-slurp-sexp
 :nvi "C-(" #'sp-forward-barf-sexp)

(map!
 (:when (modulep! :editor multiple-cursors)
   ;; evil-multiedit
   :nv "s-d"        #'evil-mc-make-and-goto-next-match
   :nv "s-D"        #'evil-mc-make-and-goto-prev-match
   :nv "M-s-<up>"   #'evil-mc-make-cursor-move-prev-line
   :nv "M-s-<down>" #'evil-mc-make-cursor-move-next-line
   :ni "s-<up>"     #'er/expand-region
   :ni "C-."        #'er/expand-region
   :ni "C-,"        #'er/contract-region
   (:after evil-multiedit
           (:map evil-multiedit-mode-map
            :nv "s-d" #'evil-multiedit-match-and-next
            :nv "s-D" #'evil-multiedit-match-and-prev
            [return]  #'evil-multiedit-toggle-or-restrict-region))))

(map!
 (:map cider-repl-mode-map
       "<up>"   #'cider-repl-previous-input
       "<down>" #'cider-repl-next-input))

(map!
 (:map copilot-completion-map
       "<right>"    #'copilot-accept-completion-by-word))

(after! dap-mode
  (map!
   :localleader
   :map dart-mode-map
   (:prefix ("d" . "debug")
            (:prefix ("u" . "ui")
                     "b" #'dap-ui-breakpoints
                     "l" #'dap-ui-locals
                     "s" #'dap-ui-sessions)
            "b" #'dap-breakpoint-toggle
            "a" #'+custom/dap-dart-attach-debug
            "h" #'dap-hydra
            "k" #'dap-disconnect)))

;; Make window movement keys work inside Treemacs buffers
(after! treemacs-evil
  (evil-define-key 'treemacs treemacs-mode-map
    (kbd "C-h") #'evil-window-left
    (kbd "C-l") #'evil-window-right
    (kbd "C-j") #'evil-window-down
    (kbd "C-k") #'evil-window-up))

(undefine-key! doom-leader-map "a")

(map!
 :leader
 (:prefix ("a" . "agent")
  :desc "Open shell"   "a" #'agent-shell-anthropic-start-claude-code
  :desc "Toggle shell" "t" #'agent-shell-toggle
  :desc "New shell"    "n" #'agent-shell-new-shell
  :desc "Send file"    "f" #'agent-shell-send-file
  :desc "Send dwim"    "b" #'agent-shell-send-dwim
  :desc "Send region"  "r" #'agent-shell-send-region))

(after! agent-shell
  (map! :localleader
        :map agent-shell-mode-map
        :desc "Interrupt"       "i" #'agent-shell-interrupt
        :desc "Restart session" "R" #'agent-shell-restart
        :desc "Reload session"  "r" #'agent-shell-reload
        :desc "Compose prompt"  "c" #'agent-shell-prompt-compose
        :desc "Other buffer"    "o" #'agent-shell-other-buffer
        :desc "Cycle mode"      "m" #'agent-shell-cycle-session-mode
        :desc "Set model"       "M" #'agent-shell-set-session-model
        :desc "Open transcript" "t" #'agent-shell-open-transcript))

;; In eca-chat buffers, press localleader (",") to open the ECA menu
(after! eca
  (when (boundp 'eca-chat-mode-map)
    (evil-define-key 'normal eca-chat-mode-map (kbd doom-localleader-key) #'eca-transient-menu)
    (evil-define-key 'visual eca-chat-mode-map (kbd doom-localleader-key) #'eca-transient-menu)))
