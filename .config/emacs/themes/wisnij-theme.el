(deftheme wisnij
    "Based on standard graphical Emacs colors, but snapped to 256-color palette.")

(apply #'custom-theme-set-faces 'wisnij
       (let ((black    "#000000")
             (dkgray   "#262626")
             (gray     "#7f7f7f")
             (ltgray   "#dadada")
             (white    "#ffffff")
             (red      "#ff0000")
             (ltbrown  "#d7af87")
             (brown    "#d7875f")
             (dkbrown  "#af5f00")
             (ltorange "#ffaf87")
             (orange   "#ff5f00")
             (dkorange "#d75f00")
             (ltyellow "#ffffd7")
             (yellow   "#ffd787")
             (dkyellow "#5f5f00")
             (ltgreen  "#87ff87")
             (green    "#00ff00")
             (ltcyan   "#87ffd7")
             (cyan     "#00ffff")
             (dkcyan   "#00cdcd")
             (ltblue   "#afd7ff")
             (blue     "#87afff")
             (dkblue   "#0000af")
             (magenta  "#ff00ff")
             (violet   "#af87ff"))
         `(;; basic faces
           (default ((t (:foreground ,ltgray :background ,black))))
           (button ((t (:inherit (link)))))
           (cursor ((t (:background ,white))))
           (error ((t (:background ,dkgray :foreground ,red :weight bold))))
           (escape-glyph ((t (:background ,dkgray :foreground ,dkcyan))))
           (fill-column-indicator ((t (:foreground ,dkgray))))
           (fringe ((t (:background ,dkgray))))
           (header-line ((t (:inherit (mode-line) :box nil :foreground ,ltgray :background ,dkgray))))
           (header-line-highlight ((t (:inherit mode-line-highlight))))
           (highlight ((t (:background ,dkyellow))))
           (homoglyph ((t (:inherit (escape-glyph)))))
           (isearch ((t (:background ,green :foreground ,white))))
           (isearch-fail ((t (:inherit (error)))))
           (lazy-highlight ((t (:background ,magenta :foreground ,white))))
           (line-number ((t (:inherit (shadow default)))))
           (line-number-current-line ((t (:inherit (line-number) :foreground ,dkcyan))))
           (line-number-major-tick ((t (:inherit (line-number)))))
           (line-number-minor-tick ((t (:inherit (line-number)))))
           (link ((t (:foreground ,cyan :underline t))))
           (link-visited ((t (:foreground ,violet :underline t))))
           (match ((t (:background ,ltblue))))
           (minibuffer-prompt ((t (:foreground ,cyan))))
           (mode-line ((t (:background ,ltgray :foreground ,black :box (:line-width -1 :style released-button)))))
           (mode-line-buffer-id ((t (:weight bold))))
           (mode-line-emphasis ((t (:weight bold))))
           (mode-line-highlight ((t (:foreground ,ltgray :background ,gray))))
           (mode-line-inactive ((t (:background ,dkgray :foreground ,gray :box (:line-width -1 :style released-button) :weight light))))
           (next-error ((t (:inherit (region)))))
           (nobreak-space ((t (:inherit (escape-glyph) :underline t))))
           (nobreak-hyphen ((t (:inherit (escape-glyph)))))
           (query-replace ((t (:inherit (isearch)))))
           (region ((t (:background ,dkblue))))
           (secondary-selection ((t (:extend t :background ,ltblue))))
           (shadow ((t (:foreground ,gray))))
           (show-paren-match ((t (:background ,gray :foreground ,cyan :weight bold))))
           (show-paren-mismatch ((t (:background ,red :foreground ,white :weight bold))))
           (tooltip ((t (:inherit (variable-pitch) :foreground ,black :background ,ltyellow))))
           (trailing-whitespace ((t (:inherit (escape-glyph)))))

           ;; font lock mode
           (font-lock-builtin-face ((t (:foreground ,ltblue))))
           (font-lock-comment-delimiter-face ((t (:foreground ,red))))
           (font-lock-comment-face ((t (:foreground ,orange))))
           (font-lock-constant-face ((t (:foreground ,ltcyan))))
           (font-lock-doc-face ((t (:foreground ,brown))))
           (font-lock-doc-markup-face ((t (:inherit (font-lock-constant-face)))))
           (font-lock-function-name-face ((t (:foreground ,blue))))
           (font-lock-keyword-face ((t (:foreground ,cyan))))
           (font-lock-negation-char-face ((t (:inherit (font-lock-keyword-face)))))
           (font-lock-preprocessor-face ((t (:foreground ,violet))))
           (font-lock-regexp-grouping-backslash ((t (:weight bold))))
           (font-lock-regexp-grouping-construct ((t (:weight bold))))
           (font-lock-string-face ((t (:foreground ,ltorange))))
           (font-lock-type-face ((t (:foreground ,ltgreen))))
           (font-lock-variable-name-face ((t (:foreground ,yellow))))
           (font-lock-warning-face ((t (:inherit (error)))))
           )))

(provide-theme 'wisnij)
