;;; winkeys-mode.el --- Keymap for the 21th century 

;; Copyright (C) 2016 Timm Lichte

;; Author: Timm Lichte <lichte@phil.hhu.de>
;; Version: 0.1

;;; Commentary:

;; TODO

;;; Code:


;; (require 'helm)
;; (require 'ace-jump-mode)

(define-minor-mode winkeys-mode
	"Key bindings rouhly following the conventions of the Windows habitat."
	:lighter " wk"
	;; :global "t"
	:init-value t
	:keymap (let ((map (make-keymap)))
						
						;; save
						(define-key map (kbd "C-s") 'save-buffer)
						(define-key map (kbd "C-S-s") 'write-file)

						;; search and replace
						(define-key map (kbd "C-f") 'helm-swoop)
						(define-key map (kbd "C-S-f a") 'helm-multi-swoop-all)
						(define-key map (kbd "C-S-f m") 'helm-multi-swoop-current)
						;; (define-key map (kbd "C-f") 'isearch-search)
						(define-key map (kbd "C-r") 'query-replace)
						(define-key map (kbd "C-S-r") 'query-replace-regexp)
						(define-key map (kbd "C-o") 'helm-find-files)

						;; mark all
						(define-key map (kbd "C-x C-a") 'mark-whole-buffer)
						
						;; quit
						(define-key key-translation-map (kbd "M-q") (kbd "C-g"))

						;; undo/redo
						(define-key map (kbd "C-z") 'undo-tree-undo)
						(define-key map (kbd "C-S-z") 'undo-tree-redo)

						;; press ESC only once
						(define-key map (kbd "<escape>") 'keyboard-escape-quit)
										
						map
						)
	(add-hook 'minibuffer-setup-hook 'winkeys-minibuffer)
	)

(defun winkeys-minibuffer ()
	"Keymap for the minibuffer."
	(let ((map minibuffer-local-map))

		;; undo/redo
		(define-key map (kbd "C-z") 'undo-tree-undo)
		(define-key map (kbd "C-S-z") 'undo-tree-redo)
		
		))

;; FIXME: How to make this a proper part of the mode, i.e., how to disable this when disabeling the mode? 
(with-eval-after-load 'helm-swoop
	(define-key helm-swoop-map (kbd "C-r") 'helm-previous-line)
	(define-key helm-swoop-map (kbd "C-f") 'helm-next-line)
	(define-key helm-multi-swoop-map (kbd "C-r") 'helm-previous-line)
	(define-key helm-multi-swoop-map (kbd "C-f") 'helm-next-line)
	(define-key helm-swoop-map (kbd "C-S-f a") 'helm-multi-swoop-all-from-helm-swoop)
	(define-key helm-swoop-map (kbd "C-S-f m") 'helm-multi-swoop-current-mode-from-helm-swoop))


(provide 'winkeys-mode)

;;; winkeys-mode.el ends here

