

;;==========================================================
;;      GENERAL CONFIGURATION
;;==========================================================

;; automatically update buffers when files change
(global-auto-revert-mode t)

;; visible bell
(setq visible-bell t)
(setq ring-bell-function (lambda ()
                           (invert-face 'mode-line)
                           (run-with-timer 0.05 nil 'invert-face 'mode-line)))

;; delete marked text on typing
(delete-selection-mode t)

;; use tabs for indent
(setq-default tab-width 2)
(setq-default indent-tabs-mode t)

;; scrolling
(setq scroll-step            1
      scroll-conservatively  10000)

;; show vertical line per indentation level (BUG: highlight-indent-guides-mode: Wrong number of arguments: (2 . &rest), 1)
(use-package highlight-indent-guides
	:ensure t
	:config
	(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
	(setq highlight-indent-guides-method 'character)
	)


;;==========================================================
;;      AUTOCOMPLETE
;;==========================================================

;; yasnippet (before auto-complete)
(use-package yasnippet
	:ensure t
	:config (yas-global-mode 1))

;; ;; auto-complete, sequence is important
;; (require 'auto-complete)
;; (require 'auto-complete-auctex)
;; (require 'auto-complete-config)
;; (ac-config-default)
;; (setq ac-auto-show-menu t)
;; (setq ac-auto-show-menu 1)
;; (global-auto-complete-mode 1)
;; ;; (add-to-list 'ac-modes 'latex-mode)     ; activate auto-complete for latex <modes (AUCTeX or Emacs' builtin one).
;; (add-hook 'latex-mode-hook (function (lambda ()
;; 																					(ac-source-yasnippet))))

;; company
(use-package company
	:ensure t
	:config
	(use-package company-auctex
		:ensure t
		:config (company-auctex-init))
	(add-hook 'after-init-hook 'global-company-mode)
	;; yasnippet integration
	(defvar company-mode/enable-yas t
		"Enable yasnippet for all backends.")
	(defun company-mode/backend-with-yas (backend)
		(if (or (not company-mode/enable-yas)
						(and (listp backend) (member 'company-yasnippet backend)))
				backend
			(append (if (consp backend) backend (list backend))
							'(:with company-yasnippet))))
	(setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))
	;; some general variables
	(setq company-idle-delay 0.3
				company-minimum-prefix-length 1
				company-selection-wrap-around t
				;; company-show-numbers t
				company-dabbrev-downcase nil
				company-auto-complete nil
				company-transformers '(company-sort-by-occurrence))
	;; (eval-after-load 'company
	;;   '(progn
	;;      (define-key company-active-map (kbd "TAB") 'company-select-next)
	;;      (define-key company-active-map [tab] 'company-select-next)))
	(use-package company-flx
		:ensure t)
	(with-eval-after-load 'company (company-flx-mode +1))
	;; add company to org-mode
 	(add-to-list 'company-backends 'company-capf)
	(defun add-pcomplete-to-capf ()
		(add-hook 'completion-at-point-functions 'pcomplete-completions-at-point nil t))
	(add-hook 'org-mode-hook #'add-pcomplete-to-capf)
	)


;;==========================================================
;;      SYNTAX CHECK
;;==========================================================

;; flycheck
(use-package flycheck
	:ensure t
	:config
	(global-flycheck-mode t)
	)

;; flyspell
(require 'setup-flyspell)


;;==========================================================
;;      PAREN HANDLING
;;==========================================================

;; smartparens
(use-package smartparens
	:ensure t
	:config
	(require 'smartparens-config)
	(setq sp-autoescape-string-quote nil)
	(--each '(css-mode-hook
						restclient-mode-hook
						js-mode-hook
						java-mode-hook
						ruby-mode-hook
						emacs-lisp-mode-hook
						LaTeX-mode-hook
						bibtex-mode-hook
						shell-mode-hook
						TeX-mode-hook
						markdown-mode
						org-mode
						groovy-mode-hook
						scala-mode-hook)
		(add-hook it #'smartparens-mode))
	(require 'smartparens-latex)
	)

;; jump to matching paren
(defun goto-match-paren (arg)
  "Go to the matching  if on (){}[], similar to vi style of % "
  (interactive "p")
  ;; first, check for "outside of bracket" positions expected by forward-sexp, etc.
  (cond ((looking-at "[\[\(\{]") (forward-sexp))
        ((looking-back "[\]\)\}]" 1) (backward-sexp))
        ;; now, try to succeed from inside of a bracket
        ((looking-at "[\]\)\}]") (forward-char) (backward-sexp))
        ((looking-back "[\[\(\{]" 1) (backward-char) (forward-sexp))
        (t nil)))
(global-set-key (kbd "C-M-m") 'goto-match-paren)
(global-set-key (kbd "M-(") 'sp-backward-sexp)
(global-set-key (kbd "M-)") 'sp-forward-sexp)
(global-set-key (kbd "M-m") 'goto-match-paren)
(global-set-key (kbd "M-[") 'sp-beginning-of-sexp)
(global-set-key (kbd "M-]") 'sp-end-of-sexp)
(global-set-key (kbd "M-DEL") nil)
(global-set-key (kbd "M-DEL M-[") 'sp-unwrap-sexp)

;; https://ebzzry.github.io/emacs-pairs.html
;; (defmacro def-pairs (pairs)
;;   `(progn
;;      ,@(loop for (key . val) in pairs
;;           collect
;;             `(defun ,(read (concat
;;                             "wrap-with-"
;;                             (prin1-to-string key)
;;                             "s"))
;;                  (&optional arg)
;;                (interactive "p")
;;                (sp-wrap-with-pair ,val)))))
;; (def-pairs ((paren        . "(")
;;             (bracket      . "[")
;;             (brace        . "{")
;;             (single-quote . "'")
;;             (double-quote . "\"")
;;             (back-quote   . "`")))
;; (global-set-key (kbd "C-[") 'wrap-with-brackets) ; TODO: find nice key bindings
;; (global-set-key (kbd "C-(") 'wrap-with-parens)
;; (global-set-key (kbd "C-{") 'wrap-with-braces)


;;==========================================================
;;      INDENTATION
;;==========================================================

;; auto-indent when yanking
;; https://www.emacswiki.org/emacs/AutoIndentation
(dolist (command '(yank yank-pop))
	(eval `(defadvice ,command (after indent-region activate)
					 (and (not current-prefix-arg)
								(member major-mode '(emacs-lisp-mode lisp-mode
																										 clojure-mode    scheme-mode
																										 haskell-mode    ruby-mode
																										 rspec-mode      python-mode
																										 c-mode          c++-mode
																										 objc-mode       latex-mode
																										 plain-tex-mode))
								(let ((mark-even-if-inactive transient-mark-mode))
									(indent-region (region-beginning) (region-end) nil))))))


;;==========================================================
;;      SELECTION
;;==========================================================

;; expand-region (intelligent selection)
(use-package expand-region
	:ensure t
	:bind ("C-+" . er/expand-region)
	)


;;==========================================================
;;      CURSOR PLACEMENT 
;;==========================================================

;; adds ace jump mode
(use-package ace-jump-mode
	:ensure t
	:bind 
	("C-c SPC" . ace-jump-mode))

;; multiple cursors
(use-package multiple-cursors
	:ensure t
	:bind
	("C-S-c C-S-c" . mc/edit-lines)
	("C->" . mc/mark-next-like-this)
	("C-<" . mc/mark-previous-like-this)
	("C-c C-<" . mc/mark-all-like-this)
	)

;; cursor position history (LOCAL)
(require 'point-undo)
(global-set-key [M-left] 'point-undo)
(global-set-key [M-right] 'point-redo)

;; cursor position undo history
(use-package goto-last-change
	:ensure t
	:bind
	("M-_" . goto-last-change))


;;==========================================================
;;      UNDO
;;==========================================================

;; visualize the undo history
(use-package undo-tree
	:ensure t
  :diminish undo-tree-mode
  :config
  (progn
    (global-undo-tree-mode)
    (setq undo-tree-visualizer-timestamps t)
    (setq undo-tree-visualizer-diff t)))

;; critical markup
(use-package cm-mode
	:ensure t
	:config
	(setq-default cm-author "TL"))


;;==========================================================
;;     SWITCH BETWEEN BUFFERS
;;==========================================================

;; switching between buffers with C-tab
(use-package iflipb
	:ensure t
	:config
	(setq iflipb-wrap-around t)
	:bind
	("<C-tab>" . iflipb-next-buffer))


;;==========================================================
;;      FILE BROWSER
;;==========================================================

;; use deer instead plain directory listing
(use-package ranger
	:ensure t
	:bind
	("C-x C-d" . deer))


;;==========================================================
;;      KEYS
;;==========================================================

;; commenting
(global-set-key (kbd "C-;") 'comment-or-uncomment-region-or-line)
(eval-after-load "LaTeX-mode"
	'(define-key LaTeX-mode-map (kbd "C-;") 'comment-or-uncomment-region-or-line))
(eval-after-load "markdown-mode"
	'(define-key LaTeX-mode-map (kbd "C-;") 'comment-or-uncomment-region-or-line))
(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
    (if (region-active-p)
				(setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)
    (next-line)))

;; delete line
(global-set-key (kbd "C-S-o") 'delete-blank-lines)
(global-set-key (kbd "C-S-k") 'kill-whole-line)
(global-set-key (kbd "C-S-d") 'kill-word)


;; center line
(global-set-key (kbd "C-S-l") 'recenter-top-bottom)

;; open untitiled new buffer
(defun xah-new-empty-buffer ()
  "Open a new empty buffer.
URL `http://ergoemacs.org/emacs/emacs_new_empty_buffer.html'
Version 2015-06-12"
  (interactive)
  (let ((buf (generate-new-buffer "untitled")))
    (switch-to-buffer buf)
    (funcall (and initial-major-mode))
    (setq buffer-offer-save t)))
(global-set-key (kbd "<f7>") 'xah-new-empty-buffer)

(provide 'setup-buffer)
