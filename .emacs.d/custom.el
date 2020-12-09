;; -*- Emacs-Lisp -*-

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-for-comint-mode t)
 '(backup-by-copying t)
 '(backward-delete-char-untabify-method nil)
 '(c-default-style "wisnij")
 '(case-fold-search t)
 '(column-number-mode t)
 '(default-input-method "latin-1-prefix")
 '(delete-old-versions t)
 '(eyebrowse-new-workspace t)
 '(eyebrowse-wrap-around t)
 '(fill-column 80)
 '(git-commit-known-pseudo-headers
   '("Signed-off-by" "Acked-by" "Cc" "Reported-by" "Tested-by" "Reviewed-by" "Summary" "Test Plan" "Reviewers" "Subscribers" "JIRA Issues") nil nil "Adding headings used by 'arc diff'")
 '(global-font-lock-mode t nil (font-lock))
 '(groovy-indent-offset 2)
 '(htmlize-css-name-prefix "htmlize-")
 '(htmlize-html-major-mode 'html-mode)
 '(ido-auto-merge-delay-time most-positive-fixnum)
 '(ido-default-buffer-method 'selected-window)
 '(ido-default-file-method 'selected-window)
 '(ido-enable-flex-matching t)
 '(ido-ignore-buffers '("\\` " "^\\*"))
 '(ido-ignore-files
   '("\\`CVS/" "\\`#" "\\`.#" "\\`\\.\\./" "\\`\\./" "\\.bak\\'"))
 '(ido-save-directory-list-file "~/.emacs.d/ido.last")
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(initial-scratch-message nil)
 '(iswitchb-buffer-ignore '("^ " "^\\*"))
 '(kill-read-only-ok t)
 '(kill-whole-line t)
 '(p4-default-diff-options "-dNu")
 '(p4-verbose nil)
 '(python-fill-docstring-style 'pep-257-nn)
 '(read-quoted-char-radix 16)
 '(save-abbrevs 'silently)
 '(scroll-bar-mode 'right)
 '(select-enable-clipboard t)
 '(show-paren-mode t nil (paren))
 '(show-trailing-whitespace t)
 '(size-indication-mode t)
 '(slime-startup-animation nil)
 '(sort-fold-case t)
 '(tool-bar-mode nil nil (tool-bar))
 '(transient-mark-mode t)
 '(truncate-partial-width-windows t)
 '(typopunct-buffer-language 'english)
 '(uniquify-buffer-name-style 'post-forward-angle-brackets nil (uniquify))
 '(version-control t)
 '(x-stretch-cursor t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diff-added ((t (:inherit diff-changed :foreground "cyan"))))
 '(diff-added-face ((t (:inherit diff-changed :foreground "cyan"))))
 '(diff-changed ((nil (:foreground "darkgreen"))))
 '(diff-changed-face ((nil (:foreground "darkgreen"))))
 '(diff-removed ((t (:inherit diff-changed :foreground "red"))))
 '(diff-removed-face ((t (:inherit diff-changed :foreground "red"))))
 '(git-commit-comment-face ((t (:inherit font-lock-comment-face))))
 '(git-commit-overlong-summary-face ((t (:inherit font-lock-warning-face))))
 '(markdown-code-face ((t (:inherit nil)))))
