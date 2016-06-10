;; automatically update buffers when files change
(global-auto-revert-mode t)
(setq ring-bell-function (lambda ()
                           (invert-face 'mode-line)
                           (run-with-timer 0.05 nil 'invert-face 'mode-line)))

;; visible bell
(setq visible-bell t)

;; delete marked text on typing
(delete-selection-mode t)

;; use tabs for indent
(setq-default tab-width 2)
(setq-default indent-tabs-mode t)

;; scrolling
(setq scroll-step            1
      scroll-conservatively  10000)

;; auto-complete
(require 'auto-complete)
(require 'auto-complete-auctex)
(global-auto-complete-mode 1)
;; (ac-config-default)
;; (add-to-list 'ac-modes 'latex-mode)     ; activate auto-complete for latex <modes (AUCTeX or Emacs' builtin one).

;; flycheck
(require 'flycheck)
(global-flycheck-mode t)

;; flyspell
(setq ispell-program-name "")

;; smartparens
(require 'smartparens-config)
(setq sp-autoescape-string-quote nil)
(--each '(css-mode-hook
          restclient-mode-hook
          js-mode-hook
          java-mode
          ruby-mode
          markdown-mode
          groovy-mode
          scala-mode)
  (add-hook it 'turn-on-smartparens-mode))

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

;; expand-region (intelligent selction)
(require 'expand-region)
(global-set-key (kbd "C-+") 'er/expand-region)

;; cursor position history
(require 'point-undo)
(global-set-key [M-left] 'point-undo)
(global-set-key [M-right] 'point-redo)

(defun my-markdown-mode-config ()
	"settings for markdown mode"
	(interactive)
	(setq-default tab-width 4)
	(setq-default indent-tabs-mode t))
(add-hook 'markdown-mode 'my-markdown-mode-config)

;; adds support of the windows powershell
(require 'powershell)

;; switching between buffers with C-tab
(require 'iflipb)
(global-set-key (kbd "<C-tab>") 'iflipb-next-buffer)

;; adds ace jump mode
(require 'ace-jump-mode)
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

;;==========================================================
;;      KEYS
;;==========================================================

;; commenting
(global-set-key (kbd "C-;") 'comment-or-uncomment-region-or-line)
(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
    (if (region-active-p)
				(setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)
    (next-line)))




(provide 'setup-buffer)
