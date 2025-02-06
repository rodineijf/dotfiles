;;; $DOOMDIR/+bindings.el -*- lexical-binding: t; -*-

(map! :leader
      (:prefix "s"
       "s" #'+custom/search-src-dir  :desc "Search src dir"
       "t" #'+custom/search-test-dir :desc "Search test dir"))

(map!
 (:map 'override
       "C-h" #'evil-window-left
       "C-l" #'evil-window-right))

(map!
 (:map evil-window-map
       "a" #'ace-window))

(map!
 :nvi "C-)" #'evil-cp->
 :nvi "C-(" #'evil-cp-<)

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
       "<tab>"    #'copilot-accept-completion
       "TAB"      #'copilot-accept-completion
       "C-TAB"    #'copilot-accept-completion-by-word
       "C-<tab>"  #'copilot-accept-completion-by-word))
