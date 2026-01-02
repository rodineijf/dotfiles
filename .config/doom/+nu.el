;;; $DOOMDIR/+nu.el -*- lexical-binding: t; -*-

(let ((nudev-emacs-path "~/dev/nu/nudev/ides/emacs/"))
  (when (file-directory-p nudev-emacs-path)
    (add-to-list 'load-path nudev-emacs-path)
    (require 'nu nil t)))

(add-to-list 'projectile-project-search-path "~/dev/nu/")

(defun +nu/nu-project-clone ()
  (interactive)
  (when-let ((project (read-string "Project Name: ")))
    (let* ((cmd (format "nu proj clone %s" project))
           (buffer (get-buffer-create "*nu-proj-clone*")))
      (pop-to-buffer buffer)
      (async-shell-command cmd buffer)
      (with-current-buffer buffer
        (view-mode 1)))))

(defun +nu/search-web-region-or-prompt (begin end)
  "Search the web for the selected region or prompt
   for input if no region is active."
  (interactive "r")
  (let* ((query (if (use-region-p)
                    (buffer-substring-no-properties begin end)
                  (read-string "Search term: ")))
         (search-url (format "https://github.com/search?q=org:nubank+%s&type=code"
                             (url-hexify-string query))))
    (deactivate-mark)
    (browse-url search-url)))
