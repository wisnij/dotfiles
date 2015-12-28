(defvar color-theme-wisniewski--colors
  ;; name      256        8        bold
  '((black    "#000000"  "black"   nil)
    (dkgray   "#262626"  "black"   t)
    (gray     "#7f7f7f"  "white"   nil)
    (ltgray   "#dadada"  "white"   nil)
    (white    "#ffffff"  "white"   t)
    (red      "#ff0000"  "red"     t)
    (orange   "#ff5f00"  "red"     nil)
    (ltorange "#ffaf87"  "yellow"  nil)
    (yellow   "#ffd787"  "yellow"  t)
    (green    "#00ff00"  "green"   nil)
    (ltgreen  "#87ff87"  "green"   t)
    (dkcyan   "#00cdcd"  "cyan"    nil)
    (cyan     "#00ffff"  "cyan"    t)
    (ltcyan   "#87ffd7"  "cyan"    t)
    (dkblue   "#0000af"  "blue"    nil)
    (blue     "#87afff"  "blue"    t)
    (ltblue   "#afd7ff"  "blue"    t)
    (magenta  "#ff00ff"  "magenta" t)
    (violet   "#af87ff"  "magenta" nil))
  "An alist of color definitions for color-theme-wisniewski.")

(defvar color-theme-wisniewski--faces
  '(;; basics
    (default (:foreground ltgray :background black))
    (cursor (:background white))
    (error (:background dkgray :foreground red :weight bold))
    (fringe (:background dkgray))
    (isearch (:background green :foreground white))
    (isearch-fail (:inherit error))
    (lazy-highlight (:background magenta :foreground white))
    (link (:foreground cyan :underline t))
    (link-visited (:foreground violet :underline t))
    (minibuffer-prompt (:foreground cyan))
    (mode-line (:background ltgray :foreground black :box (:line-width -1 :style released-button)))
    (mode-line-inactive (:background dkgray :foreground gray :box (:line-width -1 :style released-button) :weight light))
    (region (:background dkblue :foreground nil))
    (show-paren-match (:background gray :foreground cyan :weight bold))
    (show-paren-mismatch (:background red :foreground white :weight bold))
    (trailing-whitespace (:background dkgray :foreground dkcyan))
    ;; font lock
    (font-lock-builtin-face (:foreground ltblue))
    (font-lock-comment-delimiter-face (:foreground red))
    (font-lock-comment-face (:foreground orange))
    (font-lock-constant-face (:foreground ltcyan))
    (font-lock-doc-face (:inherit font-lock-comment-face))
    (font-lock-function-name-face (:foreground blue))
    (font-lock-keyword-face (:foreground cyan))
    (font-lock-negation-char-face (:inherit font-lock-keyword-face))
    (font-lock-preprocessor-face (:foreground violet))
    (font-lock-regexp-grouping-backslash (:weight bold))
    (font-lock-regexp-grouping-construct (:weight bold))
    (font-lock-string-face (:foreground ltorange))
    (font-lock-type-face (:foreground ltgreen))
    (font-lock-variable-name-face (:foreground yellow))
    (font-lock-warning-face (:inherit error)))
  "An alist of face definitions for color-theme-wisniewski.")

(defun color-theme-wisniewski--face-for-depth (orig-spec color-depth)
  (let ((spec (copy-sequence orig-spec))
        (index (if (>= color-depth 256) 1 2)))
    (dolist (property '(:foreground :background))
      (let ((color-name (plist-get spec property)))
        (when color-name
          (let* ((color-data (assoc color-name color-theme-wisniewski--colors))
                 (color-value (nth index color-data))
                 (bold-attr (nth 3 color-data)))
            ;; in 16-color mode, use bright colors for "bold"
            (when (and (= color-depth 16)
                       bold-attr)
              (setq color-value (concat "bright" color-value)))
            (plist-put spec property color-value)
            ;; in 8-color mode, bold with :weight property
            (when (and (eq property :foreground)
                       (= color-depth 8)
                       bold-attr)
              (plist-put spec :weight 'bold))))))
    spec))

(defun color-theme-wisniewski--create-facespec (name spec)
  (let* ((depth (case system-type
                  ('darwin 8)
                  (t 256)))
         (face (color-theme-wisniewski--face-for-depth spec depth)))
    `(,name ((t ,face)))))

(defun color-theme-wisniewski ()
  "Color theme by jwisniewski, created 2015-12-20.
Based on standard graphical Emacs colors, but snapped to 256-color palette so
it'll look the same in a terminal, plus a few changes for readability."
  (interactive)
  (color-theme-install
   `(color-theme-wisniewski
     ((background-mode . dark))
     ()
     ,@(mapcar (lambda (face)
                 (apply 'color-theme-wisniewski--create-facespec face))
               color-theme-wisniewski--faces))))

(add-to-list 'color-themes '(color-theme-wisniewski  "Wisniewski" "Jim Wisniewski <wisnij@gmail.com>"))
