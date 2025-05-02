;; -*- lexical-binding: t; -*-

(deftheme default-dark
  "Default Emacs colors on a black background.")

(custom-theme-set-faces
 'default-dark
 '(default ((t (:background "#000000" :foreground "#dadada")))))

(provide-theme 'default-dark)
