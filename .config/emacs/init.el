;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Basics

(require 'cl)
(defvar emacs-load-start (current-time)
  "The `current-time' when .emacs started loading.")

;; load time message
(defun startup-echo-area-message ()
  (message "Emacs loaded in %.3fs"
           (- (float-time)
              (float-time emacs-load-start))))

(when (not (boundp 'user-emacs-directory))
  (setq user-emacs-directory "~/.emacs.d/"))

(defun user-file (name)
  "Return an absolute file name for NAME in `user-emacs-directory'."
  (if (fboundp 'locate-user-emacs-file)
      (locate-user-emacs-file name)
      (convert-standard-filename
       (abbreviate-file-name
        (expand-file-name name user-emacs-directory)))))

(defvar user-lisp-directory
  (user-file "lisp/")
  "Directory beneath which per-user Emacs lisp files are placed.")

(defun add-to-load-path (lib-dir)
  "Add LIB-DIR and all subdirectories to `load-path' with
`normal-top-level-add-subdirs-to-load-path' (if available)."
  (add-to-list 'load-path lib-dir t)
  (if (and (fboundp 'normal-top-level-add-subdirs-to-load-path)
           (file-directory-p lib-dir))
      (let ((default-directory lib-dir))
        (normal-top-level-add-subdirs-to-load-path))))

(add-to-load-path user-lisp-directory)

(setq generated-autoload-file
      (expand-file-name "loaddefs.el" user-lisp-directory))

(when (file-exists-p generated-autoload-file)
  (load generated-autoload-file t))

;; custom file
(setq custom-file (user-file "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Libraries

(defun update-my-autoloads ()
  "Call `update-autoloads-from-directories' on `user-lisp-directory' to write
`generated-autoload-file', and load it.  Do this whenever manually adding a new
library to `user-lisp-directory' to ensure its autoloads are picked up."
  (interactive)
  (require 'autoload)
  (when (not (file-exists-p generated-autoload-file))
    (make-directory user-lisp-directory t)
    (with-temp-buffer (write-file generated-autoload-file)))
  ;; TODO: make this recurse into subdirs?
  (update-directory-autoloads user-lisp-directory)
  (byte-compile-file generated-autoload-file)
  (load generated-autoload-file t))

(defmacro with-library (symbol &rest body)
  (declare (indent 1))
  (let ((err (gensym)))
    `(condition-case ,err
         (progn
           (require ',symbol)
           ,@body)
       (error (message "with-library: error loading '%s': %S" ',symbol ,err) nil))))

(with-library package
  (defun package--disable-save-selected-packages (&rest dummy)
    "Don't save package-selected-packages to `custom-file' at all."
    nil)
  (advice-add 'package--save-selected-packages :around #'package--disable-save-selected-packages)
  (add-to-list 'package-archives
               '("melpa" . "https://melpa.org/packages/") t)
  (package-initialize))

;; auto-paired quotes/parens
(with-library elec-pair
  (electric-pair-mode 1)
  (defun my-electric-pair-inhibit (char)
    "Improved version of `electric-pair-default-inhibit' which
won't inhibit a second open paren."
    (or
     ;; don't pair when the same char is next
     (eq char (char-after))
     ;; don't pair next to a word
     (eq (char-syntax (following-char)) ?w)
     ;; don't pair if it would reduce balance
     ;; (NOTE: this test needs to go last because of buffer modification shenanigans)
     (and electric-pair-preserve-balance
          (electric-pair-inhibit-if-helps-balance char))))
  (setq electric-pair-inhibit-predicate #'my-electric-pair-inhibit))

;; color theme
(let ((color-theme-obsolete nil))
  (with-library color-theme
    (load (user-file "colors.el"))
    (color-theme-wisniewski)))

;; window configs
(with-library eyebrowse
  (let ((map eyebrowse-mode-map))
    (define-key map (kbd "C-<tab>") 'eyebrowse-next-window-config)
    (define-key map (kbd "C-S-<tab>") 'eyebrowse-prev-window-config)
    (define-key map (kbd "C-M-S-t") 'eyebrowse-create-named-window-config)
    (define-key map (kbd "C-M-t") 'eyebrowse-create-window-config)
    (define-key map (kbd "C-M-w") 'eyebrowse-close-window-config)
    (dotimes (i 9)
      (let ((n (number-to-string (+ i 1))))
        (define-key map (kbd (concat "C-" n)) (intern (concat "eyebrowse-switch-to-window-config-" n)))))
    (when (equal system-type 'darwin)
      ;; set iTerm-like Cmd-#
      (define-key map (kbd "s-T") 'eyebrowse-create-named-window-config)
      (define-key map (kbd "s-t") 'eyebrowse-create-window-config)
      (define-key map (kbd "s-w") 'eyebrowse-close-window-config)
      (dotimes (i 9)
        (let ((n (number-to-string (+ i 1))))
          (define-key map (kbd (concat "s-" n)) (intern (concat "eyebrowse-switch-to-window-config-" n)))))))
  (eyebrowse-mode 1))

;; For https://github.com/rafl/git-commit-mode
(with-library git-commit
  (setq auto-mode-alist
        (append '(("new-commit$" . git-commit-mode)
                  ("COMMIT_EDITMSG$" . git-commit-mode)
                  ("NOTES_EDITMSG$" . git-commit-mode)
                  ("MERGE_MSG$" . git-commit-mode)
                  ("TAG_EDITMSG$" . git-commit-mode))
                auto-mode-alist))
  (add-hook 'git-commit-mode-hook 'turn-on-auto-fill)
  (add-hook 'git-commit-mode-hook
            (lambda ()
              (setq fill-column 72))))

;; ido
(with-library ido
  (ido-mode 1)
  (ido-everywhere 1)
  (define-key ido-file-dir-completion-map (kbd "C-c f")
    (lambda ()
      (interactive)
      (ido-initiate-auto-merge (current-buffer)))))
(with-library ido-grid-mode
  (ido-grid-mode 1))

(with-library typopunct)

;; disambiguate buffer names with <dirname>
(with-library uniquify)

;; window numbering
(with-library window-numbering
  (window-numbering-mode t))

(with-library visual-fill-column
  ;; wrap lines at fill-column in visual line mode
  (add-hook 'visual-line-mode-hook
            (lambda ()
              (visual-fill-column-mode (if visual-line-mode 1 -1)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Keybindings

;; C-arrow
(define-key function-key-map "\eOa" [C-up])
(define-key function-key-map "\eOb" [C-down])
(define-key function-key-map "\eOc" [C-right])
(define-key function-key-map "\eOd" [C-left])

;; M-arrow
(define-key function-key-map "\e[1;9A" [M-up])
(define-key function-key-map "\e[1;9B" [M-down])
(define-key function-key-map "\e[1;9C" [M-right])
(define-key function-key-map "\e[1;9D" [M-left])

;; C-PgUp/PgDown
(define-key function-key-map "\e[5^" [C-prior])
(define-key function-key-map "\e[6^" [C-next])

;; translate key with leftCmd to rightCmd equivalent
(define-key key-translation-map [C-s-268632077] (kbd "C-s-m"))

(global-set-key (kbd "<delete>") 'delete-char)
(global-set-key (kbd "C-<next>") 'next-user-buffer)
(global-set-key (kbd "C-<prior>") 'previous-user-buffer)
(global-set-key (kbd "C-M-<tab>") 'indent-relative)
(global-set-key (kbd "ESC <tab>") 'indent-relative)
(global-set-key (kbd "M-<tab>") 'indent-relative)
(global-set-key (kbd "C-s-m") 'toggle-frame-maximized)
(global-set-key (kbd "C-S-w") 'kill-rectangle)
(global-set-key (kbd "C-S-y") 'yank-rectangle)
(global-set-key (kbd "C-x <backspace>") 'delete-region)
(global-set-key (kbd "M-<backspace>") 'backward-delete-word)
(global-set-key (kbd "M-<delete>") 'delete-word)
(global-set-key (kbd "C-<backspace>") 'backward-delete-word)
(global-set-key (kbd "C-<delete>") 'delete-word)
(global-set-key (kbd "M-]") 'goto-matching-paren)
(global-set-key (kbd "M-g") 'goto-line)
(global-set-key (kbd "M-Q") 'unfill-paragraph)
(global-set-key (kbd "M-s") 'next-frame-window)
(global-set-key (kbd "M-S") 'previous-frame-window)
(global-set-key (kbd "M-y") 'yank-to-region)
(global-set-key (kbd "s-<down>") 'next-frame-window)
(global-set-key (kbd "s-<left>") (lambda () (interactive) (other-frame -1)))
(global-set-key (kbd "s-<right>") 'other-frame)
(global-set-key (kbd "s-<up>") 'previous-frame-window)

(global-set-key (kbd "C-x C-b") 'buffer-menu)
(global-set-key (kbd "C-b")
                (if (fboundp 'ido-switch-buffer)
                    'ido-switch-buffer
                    'buffer-menu))

;; Keybinding functions
(defun switch-to-buffer-num (arg)
  "Switch to the previous buffer.  With a numeric arg, n, switch to the nth
most recent buffer.  With an arg of 0, buries the current buffer at the
bottom of the buffer stack."
  (interactive "p")
  (when (= arg 0)
    (bury-buffer (current-buffer)))
  (switch-to-buffer
   (if (<= arg 1)
       (other-buffer (current-buffer))
       (nth (1+ arg) (buffer-list)))))

(defun next-user-buffer ()
  "Switch to the next buffer in cyclic order, skipping internal and invisible
buffers."
  (interactive)
  (let ((original-buffer (buffer-name (current-buffer))))
    (while (let ((this-buffer (buffer-name (switch-to-buffer-num 0))))
             (and (string-match "\\`[ *]" this-buffer)
                  (not (string-equal original-buffer this-buffer)))))))

(defun previous-user-buffer ()
  "Switch to the previous buffer in cyclic order, skipping internal and
invisible buffers."
  (interactive)
  (let ((original-buffer (buffer-name (current-buffer))))
    (while (let ((this-buffer (buffer-name (switch-to-buffer-num
                                            (- (length (buffer-list))
                                               2)))))
             (and (string-match "\\`[ *]" this-buffer)
                  (not (string-equal original-buffer this-buffer)))))))

;; Balanced parens
(defun goto-matching-paren ()
  "Go to the matching paren if point is on an opening paren or after a closing
paren."
  (interactive)
  (let ((prev-char (char-to-string (preceding-char)))
        (next-char (char-to-string (following-char))))
    (cond ((string-match "\\s\(" next-char) (forward-sexp))
          ((string-match "\\s\)" prev-char) (backward-sexp)))))

(defun next-frame-window ()
  "Select the next window on the current frame"
  (interactive)
  (select-window (next-window)))

(defun previous-frame-window ()
  "Select the previous window on the current frame"
  (interactive)
  (select-window (previous-window)))

;; Overwrite yank
(defun yank-to-region ()
  "Replace the current region with the text in the kill ring.  The state of the kill ring is unchanged."
  (interactive)
  (progn
    (delete-region (point) (mark))
    (yank)))

;; Delete word backwards without altering the kill ring
(defun delete-word (arg)
  "Delete characters forward until encountering the end of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (forward-word arg) (point))))

(defun backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-word (- arg)))


(defun unfill-paragraph (&optional region)
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive (progn (barf-if-buffer-read-only) '(t)))
  (let ((fill-column (point-max))
        (emacs-lisp-docstring-fill-column t))
    (fill-paragraph nil region)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Miscellaneous functions

(defun chr (num-or-str &optional base)
  "Return a string containing the character represented by NUM-OR-STR.
If the argument is a string, convert it to a number according to Emacs integer
literal syntax if it starts with #, or `string-to-number' in the specified BASE
(16 by default)."
  (char-to-string
   (cond ((numberp num-or-str) num-or-str)
         ((stringp num-or-str)
          (if (eq (string-to-char num-or-str) ?#)
              (read num-or-str)
            (string-to-number num-or-str (or base 16)))))))

(defun sort-words (reverse beg end)
  "Sort words in region alphabetically, in REVERSE if negative.
Prefixed with negative \\[universal-argument], sorts in reverse.

The variable `sort-fold-case' determines whether alphabetic case
affects the sort order.

See `sort-regexp-fields'."
  (interactive "P\nr")
  (sort-regexp-fields reverse "\\w+" "\\&" beg end))

(defun wc nil
  "Count the number of lines, words and characters in the region or buffer with `wc'."
  (interactive)
  (let ((start (if mark-active (region-beginning) (point-min)))
        (end   (if mark-active (region-end)       (point-max)))
        deactivate-mark)
    (shell-command-on-region start end "wc")))

(defun word-count (&optional start end)
  "Prints number of lines, words and characters in region or whole buffer."
  (interactive)
  (let ((n 0)
        (start (if mark-active (region-beginning) (point-min)))
        (end   (if mark-active (region-end)       (point-max))))
    (save-excursion
      (goto-char start)
      (while (< (point) end)
        (if (forward-word 1)
            (setq n (1+ n)))))
    (message "%3d %3d %3d" (count-lines start end) n (- end start))))

(defmacro incf* (var &optional step init)
  "If VAR is already bound, increment its value by STEP (1 by
default).  Otherwise set VAR to INIT (0 by default)."
  `(if (boundp ',var)
       (incf ,var ,(or step 1))
       (setq ,var ,(or init 0))))

(with-library longlines
  (defun longlines-toggle-hard-newlines ()
    "Toggle visibility of hard newlines."
    (interactive)
    (when (bound-and-true-p longlines-mode)
      (longlines-show-hard-newlines longlines-showing))))

(defun untabify-buffer ()
  "Convert all tabs in buffer to multiple spaces, preserving columns."
  (interactive)
  (save-excursion
    (save-restriction
      (widen)
      (untabify (point-min) (point-max)))))

(defun cleanup-whitespace ()
  "Delete trailing whitespace and remove blank lines at the end of the buffer."
  (interactive)
  (save-excursion
    (save-restriction
      (widen)
      (delete-trailing-whitespace)
      (goto-char (point-max))
      (delete-blank-lines))))

(defun uniquify-lines (start end)
  "Find duplicate lines in region START to END keeping first occurrence."
  (interactive "*r")
  (save-excursion
    (let ((end (copy-marker end)))
      (while
          (progn
            (goto-char start)
            (re-search-forward "^\\(.*\\)\n\\(\\(.*\n\\)*\\)\\1\n" end t))
        (replace-match "\\1\n\\2")))))

(defun uniquify-buffer ()
  "Delete duplicate lines in buffer and keep first occurrence."
  (interactive "*")
  (uniquify-lines (point-min) (point-max)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Passive settings

(defmacro call-if-bound (symbol &rest args)
  "If `SYMBOL' is the name of a bound function, call it with the given `ARGS'."
  `(if (fboundp ',symbol)
       (,symbol ,@args)
     (message "call-if-bound: no such function '%s'" ',symbol)))

(call-if-bound set-language-environment "UTF-8")
(call-if-bound prefer-coding-system 'utf-8-unix)
(call-if-bound delete-selection-mode 1)

(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; clean whitespace when saving
(defvar auto-cleanup-whitespace t
  "Whether `cleanup-whitespace' runs automatically when saving a buffer.")

(make-variable-buffer-local 'auto-cleanup-whitespace)

(defun toggle-auto-cleanup-whitespace ()
  "Toggle the value of `auto-cleanup-whitespace'."
  (interactive)
  (setq auto-cleanup-whitespace (not auto-cleanup-whitespace))
  (message "Auto cleanup whitespace %s"
           (if auto-cleanup-whitespace "enabled" "disabled")))

(add-hook 'before-save-hook (lambda ()
                              (when auto-cleanup-whitespace
                                (cleanup-whitespace))))

(defun save-buffer-without-cleanup (&optional arg)
  "Save current buffer in visited file if modified. Don't clean
up whitespace even if `auto-cleanup-whitespace' is in effect."
  (interactive "p")
  (let ((auto-cleanup-whitespace nil)
        (require-final-newline nil))
    (save-buffer arg)))

;; fuck CPerl mode
(with-library perl-mode
  (defalias 'cperl-mode 'perl-mode)
  (add-to-list 'auto-mode-alist '("\\.pod$" . perl-mode))
  (add-to-list 'auto-mode-alist '("\\.perl-expr$" . perl-mode))
  (add-to-list 'auto-mode-alist '("\\.psgi$" . perl-mode))
  (add-to-list 'perl-font-lock-keywords-2 '("\\<\\(our\\|state\\)\\>" . font-lock-type-face) t)
  (add-to-list 'perl-font-lock-keywords-2 '("\\<\\(given\\|when\\|default\\)\\>" . font-lock-keyword-face) t)
  (add-to-list 'perl-font-lock-keywords-2 '("\\(\\<not\\>\\|!\\)" . font-lock-negation-char-face) t))

;; fix POD highlighting
(setq perl-font-lock-syntactic-keywords
      `((,(concat "^\\(=\\)"
                  (regexp-opt '("head1" "head2" "head3" "head4" "over"
                                "item" "back" "pod" "begin" "end" "for") t)
                  "\\([ \t]\\|$\\)")
         (1 "< b"))
        ("^=cut[ \t]*\\(\n\\)" (1 "> b"))
        ("\\(\\$\\)[{']" (1 "."))))

;; indent style
(c-add-style "wisnij"
             '((c-hanging-braces-alist . ((substatement-open before after)))
               (indent-tabs-mode . nil)
               (c-basic-offset . 4)
               (c-offsets-alist . ((access-label         . /)
                                   (case-label           . *)
                                   (statement-case-intro . *)
                                   (statement-case-open  . *)
                                   (func-decl-cont       . +)
                                   (inclass              . +)
                                   (inline-open          . 0)
                                   (label                . *)
                                   (substatement         . +)
                                   (substatement-open    . 0)))))

;; Common Lisp-style indentation
(dolist (h '(lisp-mode-hook emacs-lisp-mode-hook))
  (add-hook h
            (lambda ()
              (set (make-local-variable lisp-indent-function)
                   'common-lisp-indent-function))))

;; Visible tabs
(defface visible-whitespace-face
    '((t (:inherit escape-glyph)))
  "Face used to visualize TAB.")

(defvar visible-whitespace-characters
  '(("\t" . 'visible-whitespace-face))
  "Characters shown as visible whitespace in `visible-whitespace-face'.  The
value should be a list in the format accepted by `font-lock-add-keywords'.")

(add-hook 'font-lock-mode-hook
          (lambda ()
            (standard-display-ascii
             ?\t (cond ((null window-system)       ">\t")
                       ((> emacs-major-version 21) "\xBB\t")
                       (t                          "\x08BB\t")))
            (font-lock-add-keywords nil visible-whitespace-characters)))

;; Highlight comment keywords
(add-hook 'font-lock-mode-hook
          (lambda ()
            (font-lock-add-keywords
             nil '(("\\<\\(\\(BUG\\|FIXME\\|NOSUBMIT\\|TODO\\|XXX\\)\\(([^)]*)\\)?\\)" 1 font-lock-warning-face t)))))

(add-hook 'text-mode-hook 'turn-on-font-lock)

;; frame title
(setq frame-title-format
      '(""
        (:eval (cond (buffer-read-only "%%  ")
                     ((buffer-modified-p) "*  ")))
        "%b"))

;; disabled functions
(dolist (f '(narrow-to-page narrow-to-region upcase-region downcase-region))
  (put f 'disabled nil))

;; GUI frame settings
(setq default-frame-alist
      '((vertical-scroll-bars . right)
        (background-mode . dark)))

(setq window-system-default-frame-alist
      '(;; macOS
        (ns . ((ns-appearance . dark)
               (ns-transparent-titlebar . nil)))))

;; set default GUI font
(when window-system
  (let ((font (case system-type
                ;; use Inconsolata on Windows, where .Xresources has no effect
                (windows-nt "Inconsolata-11")
                ;; use Inconsolata on Mac
                (darwin "Inconsolata-11")
                ;; after adjusting for 4k DPI settings
                (gnu/linux "Inconsolata-9")
                )))
    (set-frame-font font t t)))

;; only show menu bar in GUI
(menu-bar-mode (if window-system 1 0))

;; make scratch buffer unkillable
(defun unkillable-scratch-buffer ()
  "Instead of killing *scratch*, just delete its contents and
mark it as unmodified."
  (if (equal (buffer-name (current-buffer)) "*scratch*")
      (progn
        (widen)
        (delete-region (point-min) (point-max))
        (set-buffer-modified-p nil)
        (fundamental-mode)
        nil)
      t))

(add-hook 'kill-buffer-query-functions 'unkillable-scratch-buffer)

;; save custom files with 'foo rather than (quote foo)
(advice-add 'custom-save-all :around
            (lambda (orig)
              (let ((print-quoted t))
                (funcall orig))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Finish up

;; per-site settings
(defvar user-local-init-file
  (user-file "local.el")
  "Initializations local to this particular machine.")

(when (file-exists-p user-local-init-file)
  (load user-local-init-file))
