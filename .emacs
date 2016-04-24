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

(when (fboundp 'package-initialize)
  (package-initialize))

(when (not (boundp 'user-emacs-directory))
  (setq user-emacs-directory "~/.emacs.d/"))

(defun user-file (name)
  "Return an absolute file name for NAME in `user-emacs-directory'."
  (if (fboundp 'locate-user-emacs-file)
      (locate-user-emacs-file name)
      (convert-standard-filename
       (abbreviate-file-name
        (expand-file-name name user-emacs-directory)))))

(defun add-to-load-path (lib-dir)
  "Add LIB-DIR and all subdirectories to `load-path' with
`normal-top-level-add-subdirs-to-load-path' (if available)."
  (add-to-list 'load-path lib-dir t)
  (if (and (fboundp 'normal-top-level-add-subdirs-to-load-path)
           (file-directory-p lib-dir))
      (let ((default-directory lib-dir))
        (normal-top-level-add-subdirs-to-load-path))))

(add-to-load-path (user-file "lisp"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Libraries

(defmacro with-library (symbol &rest body)
  (let ((err (gensym)))
    `(condition-case ,err
         (progn
           (require ',symbol)
           ,@body)
       (error (message (format "with-library: error loading '%s': %S"
                               ',symbol ,err))
              nil))))
(put 'with-library 'lisp-indent-function 1)

;; color theme
(with-library color-theme
  (load (user-file "colors.el"))
  (color-theme-wisniewski))

;; disambiguate buffer names with <dirname>
(with-library uniquify)

;; buffer switching
(with-library ido
  (ido-mode 1))

;; window numbering
(with-library window-numbering
  (window-numbering-mode t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Keybindings

(define-key function-key-map "\eOa" [C-up])
(define-key function-key-map "\eOb" [C-down])
(define-key function-key-map "\eOc" [C-right])
(define-key function-key-map "\eOd" [C-left])
(define-key function-key-map "\e[5^" [C-prior])
(define-key function-key-map "\e[6^" [C-next])

(global-set-key [delete] 'delete-char)
(global-set-key (kbd "C-<next>") 'next-user-buffer)
(global-set-key (kbd "C-<prior>") 'previous-user-buffer)
(global-set-key (kbd "C-<tab>") 'indent-relative)
(global-set-key (kbd "M-]") 'goto-matching-paren)
(global-set-key (kbd "M-g") 'goto-line)
(global-set-key (kbd "M-s") 'next-frame-window)
(global-set-key (kbd "M-S") 'previous-frame-window)
(global-set-key (kbd "M-y") 'yank-to-region)

(global-set-key (kbd "C-x b") 'buffer-menu)
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Miscellaneous functions

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
        (end   (if mark-active (region-end)       (point-max))))
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

(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; clean whitespace when saving
(add-hook 'before-save-hook 'cleanup-whitespace)

;; fuck CPerl mode
(with-library perl-mode
  (defalias 'cperl-mode 'perl-mode)
  (add-to-list 'auto-mode-alist '("\\.pod$" . perl-mode))
  (add-to-list 'auto-mode-alist '("\\.perl-expr$" . perl-mode))
  (add-to-list 'perl-font-lock-keywords-2 '("\\<\\(our\\)\\>" . font-lock-type-face) t)
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
            (font-lock-add-keywords nil
             '(("\\<\\(BUG\\|FIXME\\|TODO\\|XXX\\)" 1 font-lock-warning-face t)))))

(add-hook 'text-mode-hook 'turn-on-font-lock)

;; frame title
(setq frame-title-format
      '(""
        (:eval (cond (buffer-read-only "%%  ")
                     ((buffer-modified-p) "*  ")))
        "%b  (" invocation-name "@" system-name ")"))

;; disabled functions
(dolist (f '(narrow-to-page narrow-to-region upcase-region downcase-region))
  (put f 'disabled nil))

;; use 7x13 on Windows, where .Xresources has no effect
(when (eql system-type 'windows-nt)
  (set-frame-font "7x13-10" nil t))

;; make scratch buffer unkillable
(defun unkillable-scratch-buffer ()
  "Instead of killing *scratch*, just delete its contents and
mark it as unmodified."
  (if (equal (buffer-name (current-buffer)) "*scratch*")
      (progn
        (widen)
        (delete-region (point-min) (point-max))
        (set-buffer-modified-p nil)
        nil)
      t))

(add-hook 'kill-buffer-query-functions 'unkillable-scratch-buffer)

;; wrap lines at fill-column in visual line mode
(with-library visual-fill-column
  (add-hook 'visual-line-mode-hook 'visual-fill-column-mode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Finish up

;; custom file
(setq custom-file (user-file "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

;; per-site settings
(defvar user-local-init-file
  (user-file "local.el")
  "Initializations local to this particular machine.")

(when (file-exists-p user-local-init-file)
  (load user-local-init-file))
