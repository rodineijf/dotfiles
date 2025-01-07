;;; $DOOMDIR/+bindings.el -*- lexical-binding: t; -*-

(map! :leader
      ;; Change default search to vertico, it gives you a nice preview of the files
      :desc "Search project" "/" #'+vertico/project-search)

;;; :editor
(map!
 (:map evil-window-map
       "a" #'ace-window)
 (:when (modulep! :editor multiple-cursors)
   ;; evil-multiedit
   :nv "s-d"        #'evil-mc-make-and-goto-next-match
   :nv "s-D"        #'evil-mc-make-and-goto-prev-match
   :nv "M-s-<up>"   #'evil-mc-make-cursor-move-prev-line
   :nv "M-s-<down>" #'evil-mc-make-cursor-move-next-line
   (:after evil-multiedit
           (:map evil-multiedit-mode-map
            :nv "s-d" #'evil-multiedit-match-and-next
            :nv "s-D" #'evil-multiedit-match-and-prev
            [return]  #'evil-multiedit-toggle-or-restrict-region)))
      :ni "s-<up>"   #'er/expand-region)

