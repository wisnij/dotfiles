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
 '(current-language-environment "Latin-1")
 '(default-input-method "latin-1-prefix")
 '(delete-old-versions t)
 '(fill-column 80)
 '(global-font-lock-mode t nil (font-lock))
 '(htmlize-css-name-prefix "htmlize-")
 '(htmlize-html-major-mode (quote html-mode))
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(initial-scratch-message nil)
 '(iswitchb-buffer-ignore (quote ("^ " "^\\*")))
 '(kill-read-only-ok t)
 '(kill-whole-line t)
 '(p4-default-diff-options "-dNu")
 '(p4-verbose nil)
 '(package-archives (quote (("gnu" . "http://elpa.gnu.org/packages/") ("melpa" . "http://melpa.org/packages/"))))
 '(save-abbrevs (quote silently))
 '(scroll-bar-mode (quote right))
 '(show-paren-mode t nil (paren))
 '(size-indication-mode t)
 '(slime-startup-animation nil)
 '(sql-product (quote mysql))
 '(tool-bar-mode nil nil (tool-bar))
 '(transient-mark-mode t)
 '(truncate-partial-width-windows t)
 '(uniquify-buffer-name-style (quote post-forward-angle-brackets) nil (uniquify))
 '(version-control t)
 '(x-select-enable-clipboard t)
 '(x-stretch-cursor t))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(diff-added ((t (:inherit diff-changed :foreground "blue"))))
 '(diff-added-face ((t (:inherit diff-changed :foreground "blue"))))
 '(diff-changed ((nil (:foreground "darkgreen"))))
 '(diff-changed-face ((nil (:foreground "darkgreen"))))
 '(diff-removed ((t (:inherit diff-changed :foreground "red"))))
 '(diff-removed-face ((t (:inherit diff-changed :foreground "red"))))
 '(font-lock-comment-face ((nil (:foreground "red")))))
