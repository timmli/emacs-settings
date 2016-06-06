;; don't show startup message
(setq inhibit-startup-message t)

;; set path to settings
(setq settings-dir
      (expand-file-name "settings" user-emacs-directory))
(add-to-list 'load-path settings-dir)

;; load custom file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;; set up appearance early
(require 'appearance)

;; character encodings default to utf-8.
(prefer-coding-system 'utf-8)
(set-language-environment 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)

;; write backup files to own directory
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

;; save point position between sessions
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))


;; package managing
(when (>= emacs-major-version 24)
  (require 'package)
  ;; (add-to-list 'package-archives
	;;        '("melpa-stable" . "http://stable.melpa.org/packages/") t)
  (add-to-list 'package-archives
	       '("melpa" . "http://melpa.org/packages/") t)
  (package-initialize))
;; list the packages you want
(setq package-list '(auctex
                     auto-complete
                     auto-complete-auctex
                     counsel
                     expand-region
                     flycheck
                     flx-ido
                     ido-grid-mode
                     ido-vertical-mode
                     imenu-anywhere
                     imenu-list
                     js2-mode
                     monokai-theme
                     markdown-mode
                     powershell
                     smartparens
                     smex
                     sr-speedbar
                     ;;yasnippets
                     web-mode
                     ))
;; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))
;; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;; (condition-case nil
;;     (init--install-packages)
;;   (error
;;    (package-refresh-contents)
;;       (init--install-packages)))


(require 'web-mode)                  ; for improved html support
(require 'js2-mode)                  ;5u; for improved JavaScript support

(require 'setup-minibuffer)
(require 'setup-buffer)
(require 'setup-speedbar)
(require 'setup-latex)
(require 'setup-frame)

;; map files to modes
(require 'mode-file-associations)
