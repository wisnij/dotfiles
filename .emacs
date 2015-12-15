;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Basics

(require 'cl)
(defvar emacs-load-start (current-time)
  "The `current-time' when .emacs started loading.")

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

(require 'uniquify)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Keybindings

(global-set-key [delete] 'delete-char)
(global-set-key (kbd "C-<next>") 'next-user-buffer)
(global-set-key (kbd "C-<prior>") 'previous-user-buffer)
(global-set-key (kbd "C-<tab>") 'indent-relative)
(global-set-key (kbd "C-b") 'buffer-menu)
(global-set-key (kbd "M-[") 'goto-matching-paren)
(global-set-key (kbd "M-g") 'goto-line)
(global-set-key (kbd "M-s") 'next-frame-window)
(global-set-key (kbd "M-S") 'previous-frame-window)
(global-set-key (kbd "M-y") 'yank-to-region)


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

(defun word-count nil
  "Count the number of words in the current buffer."
  (interactive)
  (shell-command-on-region (point-min) (point-max) "wc -w"))

(defun wc (&optional start end)
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Passive settings

(defun startup-echo-area-message () nil)

(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; fuck CPerl mode
(defalias 'cperl-mode 'perl-mode)
(add-to-list 'auto-mode-alist '("\\.pod$" . perl-mode))
(add-to-list 'auto-mode-alist '("\\.perl-expr$" . perl-mode))

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
    '((((class color) (background dark))
       (:background "grey10" :foreground "aquamarine3"))
      (((class color) (background light))
       (:background "beige"  :foreground "aquamarine3"))
      (t (:foreground "aquamarine3")))
  "Face used to visualize TAB.")

(defvar visible-whitespace-characters
  '(("\t" . 'visible-whitespace-face))
  "Characters shown as visible whitespace in `visible-whitespace-face'.  The
value should be a list in the format accepted by `font-lock-add-keywords'.")

(add-hook 'font-lock-mode-hook
          (lambda ()
            (font-lock-add-keywords nil visible-whitespace-characters)))

;; Highlight comment keywords
(add-hook 'font-lock-mode-hook
          (lambda ()
            (font-lock-add-keywords nil
             '(("\\<\\(BUG\\|FIXME\\|TODO\\|XXX\\)" 1 font-lock-warning-face t)))))

(add-hook 'text-mode-hook 'turn-on-font-lock)

(standard-display-ascii
 ?\t (cond ((null window-system)       ">\t")
           ((> emacs-major-version 21) "\xBB\t")
           (t                          "\x08BB\t")))

;; frame title
(setq frame-title-format
      '(""
        (:eval (cond (buffer-read-only "%%  ")
                     ((buffer-modified-p) "*  ")))
        "%b  (" invocation-name "@" system-name ")"))

;; disabled functions
(dolist (f '(narrow-to-page narrow-to-region upcase-region downcase-region))
  (put f 'disabled nil))

;; buffer switching
(iswitchb-mode)

(defun iswitchb-local-keys ()
  (mapc (lambda (K) 
          (let* ((key (car K)) (fun (cdr K)))
            (define-key iswitchb-mode-map (edmacro-parse-keys key) fun)))
        '(("<right>" . iswitchb-next-match)
          ("<left>"  . iswitchb-prev-match)
          ("<down>"  . iswitchb-next-match)
          ("<up>"    . iswitchb-prev-match))))

(add-hook 'iswitchb-define-mode-map-hook 'iswitchb-local-keys)



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

;; load time message
(message "Loaded .emacs in %ds"
         (destructuring-bind (hi lo &rest) (current-time)
           (- (+ hi lo)
              (+ (first emacs-load-start) (second emacs-load-start)))))
