;;; basics.el --- Summary
;;;
;;; Commentary:
;;;
;;; Code:

;; don't show startup message
(setq inhibit-startup-message t)

;; brackets
(show-paren-mode 1)
(setq show-paren-delay 0)

;; automatically update buffers when files change
(global-auto-revert-mode t)

;; character encodings default to utf-8.
(prefer-coding-system 'utf-8)
(set-language-environment 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)

;; apply syntax highlighting to all buffers
(global-font-lock-mode t)

;; delete marked text on typing
(delete-selection-mode t)

;; don't use tabs for indent; replace tabs with two spaces.
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)

;; soft-wrap lines
(global-visual-line-mode t)

;; line numbers
(linum-mode t)
(setq linum-format " %4d ")

;; shorten yes/no answers to y/n
(fset 'yes-or-no-p 'y-or-n-p)

;; ido improves buffer switching experience
(ido-mode 1)




;;==========================================================
;;      KEYS
;;==========================================================

;; M-x in minibuffer quits the minibuffer
(add-hook 'minibuffer-setup-hook
          (lambda ()
                        (local-set-key (kbd "M-x") 'abort-recursive-edit)))

;; commenting
(global-set-key "\C-c\C-c" 'comment-or-uncomment-region-or-line)
(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
    (if (region-active-p)
	(setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)
    (next-line)))

;; better keys for switching between windows
;; (when (fboundp 'windmove-default-keybindings)
  ;; (windmove-default-keybindings))
(global-set-key (kbd "M-S-<left>")  'windmove-left)
(global-set-key (kbd "M-S-<right>") 'windmove-right)
(global-set-key (kbd "M-S-<up>")    'windmove-up)
(global-set-key (kbd "M-S-<down>")  'windmove-down)


;;; basics.el ends here
