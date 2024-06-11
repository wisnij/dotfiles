;; -*- lexical-binding: t; -*-

(defconst emacs-start-time (current-time)
  "The `current-time' when Emacs started up.")

;; Give the frame basic coloring while waiting for the theme to load.
(set-face-attribute 'default nil :background "#000000" :foreground "#cccccc")

;; Resizing the Emacs frame can be a terribly expensive part of changing the
;; font. By inhibiting this, we easily halve startup times with fonts that are
;; larger than the system default.
(setq frame-inhibit-implied-resize t
      frame-resize-pixelwise t)

;; Ignore X resources; its settings would be redundant with the other settings
;; in this file and can conflict with later config (particularly where the
;; cursor color is concerned).
(advice-add #'x-apply-session-resources :override #'ignore)

;; Unset `file-name-handler-alist' too (temporarily). Every file opened and
;; loaded by Emacs will run through this list to check for a proper handler for
;; the file, but during startup, it won’t need any of them.
(defvar file-name-handler-alist/orig file-name-handler-alist)
(setq file-name-handler-alist nil)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq file-name-handler-alist file-name-handler-alist/orig)))

;; Only load packages when requested later by use-package
(setq package-enable-at-startup nil)

(provide 'early-init)
