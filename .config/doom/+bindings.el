;;; $DOOMDIR/+bindings.el -*- lexical-binding: t; -*-

(map! :leader
      ;; Change default search to vertico, it gives you a nice preview of the files
      :desc "Search project" "/" #'+vertico/project-search)
