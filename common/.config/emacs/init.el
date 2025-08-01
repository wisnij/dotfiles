;; -*- lexical-binding: t; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Basics

;; load time message
(defun startup-echo-area-message ()
  (message "Emacs loaded in %.3fs"
           (- (float-time)
              (float-time emacs-start-time))))

(when (not (boundp 'user-emacs-directory))
  (setq user-emacs-directory "~/.config/emacs/"))

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

(setq custom-theme-directory (user-file "themes/"))
(load-theme 'wisnij :no-confirm)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Libraries

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
  (make-directory-autoloads user-lisp-directory generated-autoload-file)
  (byte-compile-file generated-autoload-file)
  (load generated-autoload-file t))

;; set up package system
(require 'package)
(advice-add 'package--save-selected-packages :override #'ignore)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(dolist (pkg '(gnu-elpa-keyring-update use-package))
  (unless (package-installed-p pkg)
    (package-install pkg))
  (require pkg))

(setq use-package-always-ensure t)
;; fix inexplicable (indent 'defun) in use-package-core.el
(put 'use-package 'lisp-indent-function 1)

;;;; libraries that are part of Emacs

(use-package desktop
  :ensure nil
  :hook (desktop-save . clean-inactive-buffers))

;; auto-paired quotes/parens
(use-package elec-pair
  :ensure nil
  :config
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

(use-package ido
  :ensure nil
  :config
  (ido-mode 1)
  (ido-everywhere 1)
  (define-key ido-file-dir-completion-map (kbd "C-c f")
    (lambda ()
      (interactive)
      (ido-initiate-auto-merge (current-buffer))))
  (defun protect-expandable-mini-window (orig &rest args)
    "Keep Ido from clobbering the mini-window size settings"
    (let ((max-mini-window-height max-mini-window-height)
          (resize-mini-windows resize-mini-windows))
      (apply orig args)))
  (advice-add 'ido-read-internal :around #'protect-expandable-mini-window))

(use-package perl-mode
  :ensure nil
  :config
  (defalias 'cperl-mode 'perl-mode)     ; fuck CPerl mode
  (add-to-list 'auto-mode-alist '("\\.pod$" . perl-mode))
  (add-to-list 'auto-mode-alist '("\\.perl-expr$" . perl-mode))
  (add-to-list 'auto-mode-alist '("\\.psgi$" . perl-mode))
  (add-to-list 'perl-font-lock-keywords-2 '("\\<\\(our\\|state\\)\\>" . font-lock-type-face) t)
  (add-to-list 'perl-font-lock-keywords-2 '("\\<\\(given\\|when\\|default\\)\\>" . font-lock-keyword-face) t)
  (add-to-list 'perl-font-lock-keywords-2 '("\\(\\<not\\>\\|!\\)" . font-lock-negation-char-face) t))

;; window configs
(use-package tab-bar
  :ensure nil
  :config
  (defun tab-bar-new-named-tab ()
    "Create a new tab with `tab-bar-new-tab' and immediately name it
with `tab-bar-rename-tab'."
    (interactive)
    (tab-bar-new-tab)
    (call-interactively #'tab-bar-rename-tab))
  (global-set-key (kbd "C-M-S-t") #'tab-bar-new-named-tab)
  (global-set-key (kbd "C-M-t") #'tab-bar-new-tab)
  (global-set-key (kbd "C-M-w") #'tab-bar-close-tab)
  (global-set-key (kbd "C-S-<prior>") #'tab-bar-move-tab-backward)
  (global-set-key (kbd "C-S-<next>") #'tab-bar-move-tab)
  (when (eq system-type 'darwin)
    ;; use Cmd on Mac
    (global-set-key (kbd "s-T") #'tab-bar-new-named-tab)
    (global-set-key (kbd "s-t") #'tab-bar-new-tab)
    (global-set-key (kbd "s-w") #'tab-bar-close-tab))
  (setq tab-bar-format
        (if (display-graphic-p)
            '(tab-bar-format-menu-bar tab-bar-format-history tab-bar-format-tabs tab-bar-separator)
          '(tab-bar-format-tabs tab-bar-separator)))
  (setq tab-bar-select-tab-modifiers
        (if (eq system-type 'darwin)
            ;; set iTerm-like Cmd-#
            '(super)
          '(control)))
  (when (not (display-graphic-p))
    (setq tab-bar-show 1))
  ;; keep tab-bar-mode from clobbering the Menu button with a hamburger icon
  (let (tab-bar-menu-bar-button)
    (tab-bar-mode 1))
  (tab-bar-history-mode 1)
  ;; save on window space by disabling menu-bar-mode, except on Mac where it
  ;; goes into the OS menu bar anyway
  (when (not (eq system-type 'darwin))
    (menu-bar-mode -1)))

;; disambiguate buffer names with <dirname>
(use-package uniquify
  :ensure nil)

;;;; libraries that need to be installed

(use-package ace-window
  :bind ("M-o" . ace-window)
  :config
  ;; override the default `aw-window-list' to return windows in the same order
  ;; as used by `window-numbering-mode' and `other-window'
  (advice-add 'aw-window-list :override
              (lambda ()
                "Return the list of interesting windows, in the same order as returned by `window-list'."
                (cl-remove-if
                 (lambda (w)
                   (let ((f (window-frame w)))
                     (or (not (and (frame-live-p f)
                                   (frame-visible-p f)))
                         (string= "initial_terminal" (terminal-name f))
                         (aw-ignored-p w))))
                 (cl-case aw-scope
                   (visible (cl-mapcan #'frame-window-list (visible-frame-list)))
                   (global (cl-mapcan #'frame-window-list (frame-list)))
                   (frame (frame-window-list))
                   (t (error "Invalid `aw-scope': %S" aw-scope)))))))

(use-package avy
  :bind (("M-g c" . avy-goto-char-timer)
         ("M-g e" . avy-goto-word-0)
         ("M-g g" . avy-goto-line)
         ("M-g w" . avy-goto-word-1)))

(use-package git-commit
  :ensure nil                     ; from https://github.com/rafl/git-commit-mode
  :config
  (setq auto-mode-alist
        (append '(("new-commit$" . git-commit-mode)
                  ("COMMIT_EDITMSG$" . git-commit-mode)
                  ("NOTES_EDITMSG$" . git-commit-mode)
                  ("MERGE_MSG$" . git-commit-mode)
                  ("TAG_EDITMSG$" . git-commit-mode))
                auto-mode-alist))
  :hook ((git-commit-mode . turn-on-auto-fill)
         (git-commit-mode . (lambda ()
                              (setq fill-column 72)))))

(use-package ido-grid-mode
  :config
  (ido-grid-mode 1))

(use-package popper
  :bind (("C-`" . popper-toggle-latest)
         ("C-M-`" . popper-cycle))
  :config
  (popper-mode 1)
  ;; For echo-area hints
  (popper-echo-mode 1))

(use-package window-numbering
  :config
  (window-numbering-mode t))

(use-package visual-fill-column
  :hook (visual-line-mode
         . (lambda ()
             "Wrap lines at fill-column in visual line mode, rather than window width"
             (visual-fill-column-mode (if visual-line-mode 1 -1)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Miscellaneous functions

(defun chr (num-or-str &optional base)
  "Return a string containing the character represented by NUM-OR-STR.
If the argument is a string, convert it to a number according to Emacs integer
literal syntax if it starts with #, or `string-to-number' in the specified BASE
(16 by default)."
  (char-to-string
   (cond ((characterp num-or-str) num-or-str)
         ((stringp num-or-str)
          (if (eq (string-to-char num-or-str) ?#)
              (read num-or-str)
            (string-to-number num-or-str (or base 16))))
         (t (error "chr: not a number or string: %S" num-or-str)))))

(defmacro incf* (var &optional step init)
  "If VAR is already bound, increment its value by STEP (1 by
default).  Otherwise set VAR to INIT (STEP by default)."
  `(let* ((val (if (boundp ',var) ,var nil))
          (step (or ,step 1))
          (init (or ,init step)))
     (setq ,var (if (null val)
                    init
                  (+ val step)))))

(defun active-buffer-list (&optional exclude-special)
  "Return a list of all buffers currently open in at least one window.
This includes windows in other tabs even if not currently shown.
If EXCLUDE-SPECIAL is true, omits buffers whose names start with
an asterisk or space."
  (message "active-buffer-list:")
  (let (active-buffers)
    (dolist (frame (frame-list))
      (message "  frame %S" frame)
      (with-selected-frame frame
        (dolist (tab (tab-bar-tabs frame))
          (message "    tab %S" (cdr (assq 'name tab)))
          (let ((window-state (if (eq (car tab) 'current-tab)
                                  (window-state-get)
                                (cdr (assq 'ws tab)))))
            (dolist (buffer-or-name (window-state-buffers window-state))
              (let* ((buffer (get-buffer buffer-or-name))
                     (buffer-name (buffer-name buffer)))
                (message "      buffer %S" buffer-name)
                (unless (or (null buffer)
                            (and exclude-special
                                 (or (string-prefix-p " " buffer-name)
                                     (string-prefix-p "*" buffer-name))))
                  (push buffer active-buffers))))))))
    (delete-dups (reverse active-buffers))))

(defun refresh-active-buffer-display-times ()
  "Set `buffer-display-time' to the `current-time' for all buffers
currently open in any window, so they will not be killed by
`clean-buffer-list'."
  (let ((now (current-time)))
    (dolist (buffer (active-buffer-list))
      (with-current-buffer buffer
        (message "Updating %S buffer-display-time to %s"
                 buffer (format-time-string "%F %T" now))
        (setq buffer-display-time now)))))

(defun slugify (str)
  "Convert STR to a filename-safe slug."
  (string-trim (replace-regexp-in-string "[^a-z0-9]+" "-"
                                         (replace-regexp-in-string "[^-_ a-z0-9]+" ""
                                                                   (downcase str)))
               "-" "-"))

(defun parse-srt-time (timestamp)
  "Parse an SRT subtitle timestamp of the form HH:MM:SS,mmm.
Returns the total number of seconds it represents as a float.
For example:

    (parse-srt-time \"01:23:45,678\") => 5025.678"
  (when (string-match "\\([0-9]\\{2\\}\\):\\([0-9]\\{2\\}\\):\\([0-9]\\{2\\}\\),\\([0-9]\\{3\\}\\)" timestamp)
    (let ((hour (string-to-number (match-string 1 timestamp)))
          (min  (string-to-number (match-string 2 timestamp)))
          (sec  (string-to-number (match-string 3 timestamp)))
          (msec (string-to-number (match-string 4 timestamp))))
      (+ (* 60 60 hour)
         (* 60 min)
         sec
         (/ msec 1000.0)))))

(defun format-srt-time (float-seconds)
  "Format a float number of seconds into an SRT subtitle timestamp
of the form HH:MM:SS,mmm.  For example:

    (format-srt-time 5025.678) => \"01:23:45,678\""
  (let* ((s (truncate float-seconds))
         (ms (* 1000 (- float-seconds s))))
    (concat (format-seconds "%.2h:%.2m:%.2s" s)
            ","
            (format "%03d" (round ms)))))

(defun frame-window-list (&optional frame)
  "Return a list of non-minibuffer windows in FRAME, or of the
current frame if null."
  (window-list frame 0 (frame-first-window frame)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Commands

(defun clean-inactive-buffers ()
  "Kill old inactive buffers that have not been displayed recently.
This is a convenience wrapper around `clean-buffer-list' which
will avoid killing any buffer currently open in a window in any
tab (as determined by `active-buffer-list')."
  (interactive)
  (let ((inhibit-message t))
    (refresh-active-buffer-display-times)
    (clean-buffer-list)))

(defun derived-modes (mode)
  "Return a list of the ancestor modes that MODE is derived from.
When called interactively, display a message showing the ancestor
modes."
  (interactive
   ;; TODO: prompt for modes
   ;;(list (completing-read "Mode name: " '("TODO: modes") nil t nil nil major-mode))
   (list major-mode))
  (let ((modes (list mode))
        (parent nil))
    (while (setq parent (get mode 'derived-mode-parent))
      (push parent modes)
      (setq mode parent))
    (setq modes (nreverse modes))
    (when (called-interactively-p 'interactive)
      (message "%S" modes))
    modes))

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

;; Copy and paste
(defun kill-region-if-active ()
  "Kill text with `kill-region' only if the region is active."
  (interactive)
  (when (not mark-active)
    (user-error "%s: The region is not active!" this-command))
  (call-interactively #'kill-region))

(defun kill-ring-save-if-active ()
  "Save text with `kill-ring-save' only if the region is active."
  (interactive)
  (when (not mark-active)
    (user-error "%s: The region is not active!" this-command))
  (call-interactively #'kill-ring-save))

(defun yank-to-region ()
  "Replace the current region with the most recently killed text,
or just `yank' it at point if the mark is not active.  The state
of the kill ring is unchanged."
  (interactive)
  (when mark-active
    (delete-region (point) (mark)))
  (yank))

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

(defun unfill-region (beg end)
  ;; from https://www.emacswiki.org/emacs/UnfillRegion
  "Unfill the region, joining text paragraphs into a single logical line.
This is useful, e.g., for use with `visual-line-mode'."
  (interactive "*r")
  (let ((fill-column (point-max)))
    (fill-region beg end)))

(defun unfill-paragraph (&optional region)
  ;; from https://www.emacswiki.org/emacs/UnfillParagraph
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive (progn (barf-if-buffer-read-only) '(t)))
  (let ((fill-column (point-max))
        (emacs-lisp-docstring-fill-column t))
    (fill-paragraph nil region)))

(defun fill-sentences-in-region (start end)
  ;; from https://stackoverflow.com/a/23469931
  "Fill each of the paragraphs in the region, with a newline after every sentence."
  (interactive "*r")
  (unless (markerp end)
    (setq end (copy-marker end t)))
  (save-mark-and-excursion
    (let ((sentence-start start)
          (fill-prefix (fill-context-prefix start end)))
      (goto-char start)
      (call-interactively 'unfill-region)
      (while (re-search-forward "[.?!][]\"')}]*\\(  \\)" end t)
        (fill-region sentence-start (point))
        (newline)
        (insert fill-prefix)
        (setq sentence-start (point)))
      ;; handle final sentence
      (fill-region sentence-start end))))

(defun fill-sentences-in-paragraph ()
  "Fill the current paragraph, with a newline after every sentence."
  (interactive)
  (save-mark-and-excursion
    (mark-paragraph)
    (call-interactively 'fill-sentences-in-region)))

(defun fill-sentences ()
  "Fill the current region or paragraph, with a newline after every sentence."
  (interactive)
  (if mark-active
      (call-interactively 'fill-sentences-in-region)
    (call-interactively 'fill-sentences-in-paragraph)))

(defun unfill-sentences ()
  "Unfill each sentence in the region or paragraph, but separate them by newlines."
  (interactive)
  (let ((fill-column (point-max)))
    (call-interactively 'fill-sentences)))

(defun sort-words (reverse beg end)
  "Sort words in region alphabetically, in REVERSE if negative.
Prefixed with negative \\[universal-argument], sorts in reverse.

The variable `sort-fold-case' determines whether alphabetic case
affects the sort order.

See `sort-regexp-fields'."
  (interactive "P\nr")
  (sort-regexp-fields reverse "\\w+" "\\&" beg end))

(defun wc nil
  "Count the number of lines, words and characters in the region
or buffer with `wc'."
  (interactive)
  (let ((start (if mark-active (region-beginning) (point-min)))
        (end   (if mark-active (region-end)       (point-max)))
        deactivate-mark)
    (shell-command-on-region start end "wc")))

(defun word-count (&optional start end)
  "Prints number of lines, words and characters in region or whole buffer."
  (interactive)
  (let ((n 0)
        (start (or start (if mark-active (region-beginning) (point-min))))
        (end   (or end   (if mark-active (region-end)       (point-max)))))
    (save-excursion
      (goto-char start)
      (while (< (point) end)
        (if (forward-word 1)
            (setq n (1+ n)))))
    (message "%3d %3d %3d" (count-lines start end) n (- end start))))

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

(defun query-replace-regexp* ()
  "Convenience wrapper for `query-replace-regexp'.

Binds a variable COUNT to nil, which can be used for incrementing
numbers in `\\,()' replacements (see e.g. `incf*')."
  (interactive)
  (let ()
    (defvar count)
    (let (count)
      (call-interactively #'query-replace-regexp))))


(defun split-root-window (size side)
  "Make a new window adjacent to the frame root window.
Arguments SIZE and SIDE are interpreted as for `split-window'."
  (split-window (frame-root-window)
                (and size (prefix-numeric-value size))
                side))

(defun split-root-window-below (&optional size)
  "Split the root window into two windows, one above the other."
  (interactive "P")
  (split-root-window size 'below))

(defun split-root-window-right (&optional size)
  "Split the root window into two side-by-side windows."
  (interactive "P")
  (split-root-window size 'right))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Passive settings

(defmacro call-if-bound (symbol &rest args)
  "If `SYMBOL' is the name of a bound function, call it with the given `ARGS'."
  `(if (fboundp ',symbol)
       (,symbol ,@args)
     (message "call-if-bound: no such function '%s'" ',symbol)))

(call-if-bound set-language-environment "UTF-8")
(call-if-bound prefer-coding-system 'utf-8-unix)
(call-if-bound delete-selection-mode 1)

(add-hook 'text-mode-hook #'flyspell-mode)
(add-hook 'text-mode-hook #'turn-on-auto-fill)

(add-hook 'prog-mode-hook #'flyspell-prog-mode)

;; turn off auto-fill in visual line mode
(add-hook 'visual-line-mode-hook
          (lambda ()
            ;; auto-fill-mode might be enabled or disabled by default depending
            ;; on major mode.  I always want it off when entering visual line
            ;; mode so I don't get hard line breaks, but if I *leave* visual
            ;; line mode (especially temporarily) I probably want to preserve
            ;; the existing long lines, and auto-fill should remain turned off
            (auto-fill-mode -1)))

;; clean whitespace when saving
(defvar auto-cleanup-whitespace t
  "Whether `cleanup-whitespace' runs automatically when saving a buffer.")

(make-variable-buffer-local 'auto-cleanup-whitespace)

(defun toggle-auto-cleanup-whitespace ()
  "Toggle the value of `auto-cleanup-whitespace'."
  (interactive)
  (setq auto-cleanup-whitespace (not auto-cleanup-whitespace))
  (when (called-interactively-p 'interactive)
    (message "Auto cleanup whitespace %s"
             (if auto-cleanup-whitespace "enabled" "disabled"))))

(defun auto-cleanup-whitespace-if-enabled ()
  (when auto-cleanup-whitespace
    (cleanup-whitespace)))
(add-hook 'before-save-hook #'auto-cleanup-whitespace-if-enabled)

(defun disable-auto-cleanup-whitespace ()
  (setq auto-cleanup-whitespace nil))
(dolist (hook '(hexl-mode-hook))
  (add-hook hook #'disable-auto-cleanup-whitespace))

(defun save-buffer-without-cleanup (&optional arg)
  "Save current buffer in visited file if modified. Don't clean
up whitespace even if `auto-cleanup-whitespace' is in effect."
  (interactive "p")
  (let ((auto-cleanup-whitespace nil)
        (require-final-newline nil))
    (save-buffer arg)))

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
                   #'common-lisp-indent-function))))

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
             ?\t (cond ((not (display-graphic-p))  ">\t")
                       ((> emacs-major-version 21) "\xBB\t")
                       (t                          "\x08BB\t")))
            (font-lock-add-keywords nil visible-whitespace-characters)))

;; Highlight comment keywords
(defvar highlight-comment-keywords
  '("BUG" "FIXME" "NOSUBMIT" "NOTE" "TODO" "XXX")
  "Keywords highlighted for extra attention, even inside comments.")

(add-hook 'font-lock-mode-hook
          (lambda ()
            (font-lock-add-keywords
             nil `((,(concat "\\<\\(\\("
                             (string-join highlight-comment-keywords "\\|")
                             "\\)\\(([^)]*)\\)?\\)")
                     1 font-lock-warning-face prepend))
             :append)))

(add-hook 'text-mode-hook #'turn-on-font-lock)

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
(when (display-graphic-p)
  (let ((font (cond
                ;; use Inconsolata on Windows, where .Xresources has no effect
                ((eq system-type 'windows-nt) "Inconsolata-11")
                ;; use Inconsolata on Mac
                ((eq system-type 'darwin) "Inconsolata-11")
                ;; after adjusting for 4k DPI settings
                ((eq system-type 'gnu/linux) "Inconsolata-9")
                )))
    (when font
      (set-frame-font font t t))))

;; don't show menu bar in terminal mode
(when (not (display-graphic-p))
  (menu-bar-mode -1))

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

(add-hook 'kill-buffer-query-functions #'unkillable-scratch-buffer)

;; save custom files with 'foo rather than (quote foo)
(advice-add 'custom-save-all :around
            (lambda (orig)
              (let ((print-quoted t))
                (funcall orig))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Keybindings

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

(global-set-key (kbd "<delete>") #'delete-char)
(global-set-key (kbd "<Multi_key>") #'activate-transient-input-method)
(global-set-key (kbd "C-<backspace>") #'backward-delete-word)
(global-set-key (kbd "C-<delete>") #'delete-word)
(global-set-key (kbd "C-<next>") #'next-user-buffer)
(global-set-key (kbd "C-<prior>") #'previous-user-buffer)
(global-set-key (kbd "C-b") (if (fboundp 'ido-switch-buffer) #'ido-switch-buffer #'buffer-menu))
(global-set-key (kbd "C-c c") #'activate-transient-input-method)
(global-set-key (kbd "C-M-%") #'query-replace-regexp*)
(global-set-key (kbd "C-M-<tab>") #'indent-relative)
(global-set-key (kbd "C-s-m") #'toggle-frame-maximized)
(global-set-key (kbd "C-S-w") #'kill-rectangle)
(global-set-key (kbd "C-S-y") #'yank-rectangle)
(global-set-key (kbd "C-w") #'kill-region-if-active)
(global-set-key (kbd "C-x <backspace>") #'delete-region)
(global-set-key (kbd "C-x C-b") #'buffer-menu)
(global-set-key (kbd "C-x C-l") #'downcase-dwim)
(global-set-key (kbd "C-x C-u") #'upcase-dwim)
(global-set-key (kbd "C-x M-2") #'split-root-window-below)
(global-set-key (kbd "C-x M-3") #'split-root-window-right)
(global-set-key (kbd "C-y") #'yank-to-region)
(global-set-key (kbd "ESC C-<tab>") #'indent-relative)
(global-set-key (kbd "M-<backspace>") #'backward-delete-word)
(global-set-key (kbd "M-<delete>") #'delete-word)
(global-set-key (kbd "M-]") #'goto-matching-paren)
(global-set-key (kbd "M-c") #'capitalize-dwim)
(global-set-key (kbd "M-Q") #'fill-sentences)
(global-set-key (kbd "M-s") #'next-frame-window)
(global-set-key (kbd "M-S") #'previous-frame-window)
(global-set-key (kbd "M-SPC") (lambda () (interactive) (cycle-spacing -1)))
(global-set-key (kbd "M-w") #'kill-ring-save-if-active)
(global-set-key (kbd "s-<down>") #'next-frame-window)
(global-set-key (kbd "s-<left>") (lambda () (interactive) (other-frame -1)))
(global-set-key (kbd "s-<right>") #'other-frame)
(global-set-key (kbd "s-<up>") #'previous-frame-window)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Finish up

;; per-site settings
(defvar user-local-init-file
  (user-file "local.el")
  "Initializations local to this particular machine.")

(when (file-exists-p user-local-init-file)
  (load user-local-init-file))
