(defun color-theme-wisniewski ()
  "Color theme by jwisniewski, created 2015-12-20.
Mostly standard Emacs colors, but with a few changes for readability."
  (interactive)
  (color-theme-install
   '(color-theme-wisniewski
     ((foreground-color . "white")
      (background-color . "black")
      (background-mode . dark)
      (cursor-color . "green"))
     (default ((t (nil))))
     (cursor ((t (:background "green"))))
     (error ((t (:bold t :foreground "red" :weight bold))))
     (font-lock-builtin-face ((t (:foreground "LightSteelBlue"))))
     (font-lock-comment-delimiter-face ((t (:foreground "red"))))
     (font-lock-comment-face ((t (:foreground "OrangeRed"))))
     (font-lock-constant-face ((t (:foreground "Aquamarine"))))
     (font-lock-doc-face ((t (:foreground "LightSalmon"))))
     (font-lock-function-name-face ((t (:foreground "LightSkyBlue"))))
     (font-lock-keyword-face ((t (:foreground "Cyan1"))))
     (font-lock-negation-char-face ((t (nil))))
     (font-lock-preprocessor-face ((t (:foreground "LightSteelBlue"))))
     (font-lock-regexp-grouping-backslash ((t (:bold t :weight bold))))
     (font-lock-regexp-grouping-construct ((t (:bold t :weight bold))))
     (font-lock-string-face ((t (:foreground "LightSalmon"))))
     (font-lock-type-face ((t (:foreground "PaleGreen"))))
     (font-lock-variable-name-face ((t (:foreground "LightGoldenrod"))))
     (font-lock-warning-face ((t (:bold t :weight bold :foreground "red"))))
     (lazy-highlight ((t (:background "paleturquoise4" :foreground "black"))))
     (link ((t (:foreground "cyan" :underline t))))
     (link-visited ((t (:foreground "violet" :underline t))))
     (isearch ((t (:background "palevioletred2" :foreground "black"))))
     (isearch-fail ((t (:background "red4"))))
     (minibuffer-prompt ((t (:foreground "cyan"))))
     (mode-line ((t (:background "red4" :foreground "white" :box (:line-width -1 :style released-button)))))
     (mode-line-inactive ((t (:background "grey30" :foreground "grey80" :box (:line-width -1 :color "grey40" :style released-button) :weight light))))
     (show-paren-match ((t (:background "steelblue3" :foreground "black"))))
     (show-paren-mismatch ((t (:background "red" :foreground "white"))))
     (trailing-whitespace ((t (:background "grey10" :foreground "aquamarine3")))))))

(add-to-list 'color-themes '(color-theme-wisniewski  "Wisniewski" "Jim Wisniewski <wisnij@gmail.com>"))
