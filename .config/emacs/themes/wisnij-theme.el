(deftheme wisnij
    "Based on standard graphical Emacs colors, but snapped to 256-color palette.")

(apply #'custom-theme-set-faces 'wisnij
       (let ((black    "#000000")
             (bggray   "#1c1c1c") ;; 10%
             (dkgray   "#303030") ;; 18%
             (dimgray  "#585858") ;; 34%
             (gray     "#808080") ;; 50%
             (midgray  "#a8a8a8") ;; 65%
             (ltgray   "#dadada") ;; 85%
             (white    "#ffffff")
             (bgred    "#5f0000")
             (dkred    "#870000")
             (dimred   "#af0000")
             (red      "#ff0000")
             (dkbrown  "#af5f00")
             (brown    "#d7875f")
             (ltbrown  "#d7af87")
             (dkorange "#d75f00")
             (orange   "#ff5f00")
             (brorange "#ffaf00")
             (ltorange "#ffaf87")
             (dkyellow "#5f5f00")
             (yellow   "#ffd787")
             (ltyellow "#ffffd7")
             (dkgreen  "#005f00")
             (green    "#00ff00")
             (ltgreen  "#87ff87")
             (dkcyan   "#008787")
             (dimcyan  "#00afaf")
             (cyan     "#00ffff")
             (ltcyan   "#87ffd7")
             (dkblue   "#0000af")
             (blue     "#87afff")
             (ltblue   "#afd7ff")
             (magenta  "#ff00ff")
             (violet   "#af87ff"))
         `((default ((t (:foreground ,ltgray :background ,black))))

           ;; basic faces
           (button ((t (:inherit (link)))))
           (cursor ((t (:background ,white))))
           (error ((t (:foreground ,red :weight bold))))
           (escape-glyph ((t (:foreground ,dimcyan :background ,dkgray))))
           (fill-column-indicator ((t (:foreground ,bggray))))
           (fringe ((t (:background ,bggray))))
           (header-line ((t (:inherit (mode-line) :box nil :foreground ,ltgray :background ,dkgray))))
           (header-line-highlight ((t (:inherit (mode-line-highlight)))))
           (highlight ((t (:background ,dkyellow))))
           (homoglyph ((t (:inherit (escape-glyph)))))
           (isearch ((t (:foreground ,black :background ,green))))
           (isearch-fail ((t (:inherit (error)))))
           (lazy-highlight ((t (:foreground ,white :background ,magenta))))
           (line-number ((t (:foreground ,dimgray))))
           (line-number-current-line ((t (:inherit (line-number) :foreground ,dimcyan))))
           (line-number-major-tick ((t (:inherit (line-number)))))
           (line-number-minor-tick ((t (:inherit (line-number)))))
           (link ((t (:foreground ,cyan :underline t))))
           (link-visited ((t (:foreground ,violet :underline t))))
           (match ((t (:background ,ltblue))))
           (minibuffer-prompt ((t (:foreground ,cyan))))
           (mode-line ((t (:foreground ,black :background ,ltgray :box (:line-width -1 :style released-button)))))
           (mode-line-buffer-id ((t (:weight bold))))
           (mode-line-emphasis ((t (:weight bold))))
           (mode-line-highlight ((t (:foreground ,ltgray :background ,gray))))
           (mode-line-inactive ((t (:foreground ,gray :background ,dkgray :box (:line-width -1 :style released-button) :weight light))))
           (next-error ((t (:inherit (region)))))
           (nobreak-space ((t (:inherit (escape-glyph) :underline t))))
           (nobreak-hyphen ((t (:inherit (escape-glyph)))))
           (query-replace ((t (:inherit (isearch)))))
           (region ((t (:background ,dkblue))))
           (secondary-selection ((t (:extend t :background ,ltblue))))
           (shadow ((t (:foreground ,midgray))))
           (show-paren-match ((t (:foreground ,cyan :background ,gray :weight bold))))
           (show-paren-mismatch ((t (:foreground ,white :background ,red :weight bold))))
           (success ((t (:foreground ,green :weight bold))))
           (tooltip ((t (:inherit (variable-pitch) :foreground ,black :background ,ltyellow))))
           (trailing-whitespace ((t (:inherit (escape-glyph)))))
           (warning ((t (:foreground ,brorange :weight bold))))

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
           (font-lock-warning-face ((t (:inherit (warning)))))

           ;; diff mode
           (diff-added ((t (:inherit (diff-changed) :foreground ,dimcyan))))
           (diff-changed ((t (:foreground ,green))))
           (diff-context ((t (:foreground ,gray))))
           (diff-file-header ((t (:inherit (diff-header) :foreground ,white :weight bold))))
           (diff-header ((t (:background ,bggray))))
           (diff-hunk-header ((t (:inherit (diff-header) :foreground ,yellow))))
           (diff-indicator-added ((t (:inherit (diff-changed) :foreground ,dkcyan))))
           (diff-indicator-changed ((t (:foreground ,dkgreen))))
           (diff-indicator-removed ((t (:inherit (diff-changed) :foreground ,dkred))))
           (diff-removed ((t (:inherit (diff-changed) :foreground ,dimred))))
           (diff-refine-added ((t (:background ,dkblue))))
           (diff-refine-changed ((t (:background ,dkgreen))))
           (diff-refine-removed ((t (:background ,bgred))))

           ;; git commit mode
           (git-commit-comment-face ((t (:inherit font-lock-comment-face))))
           (git-commit-overlong-summary-face ((t (:inherit error))))

           ;; markdown mode
           (markdown-code-face ((t (:inherit nil))))

           )))

(provide-theme 'wisnij)
