;; emacs kicker --- kick start emacs setup
;; Copyright (C) 2010 Dimitri Fontaine
;;
;; Author: Dimitri Fontaine <dim@tapoueh.org>
;; URL: https://github.com/dimitri/emacs-kicker
;; Created: 2011-04-15
;; Keywords: emacs setup el-get kick-start starter-kit
;; Licence: WTFPL, grab your copy here: http://sam.zoy.org/wtfpl/
;;
;; This file is NOT part of GNU Emacs.

(require 'cl) ;; common lib

;; custom lisp
(add-to-list 'load-path "~/.emacs.d/site-lisp")

(require 'windows-path)
(windows-path-activate)

(require 'better-defaults)

;; el-get
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil t)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://github.com/dimitri/el-get/raw/master/el-get-install.el")
    (end-of-buffer)
    (eval-print-last-sexp)))

;; now either el-get is `require'd already, or have been `load'ed by the
;; el-get installer.

;; set local recipes
(setq
 el-get-sources
 '((:name buffer-move
	  :after (progn
		   (global-set-key (kbd "<C-S-up>")     'buf-move-up)
		   (global-set-key (kbd "<C-S-down>")   'buf-move-down)
		   (global-set-key (kbd "<C-S-left>")   'buf-move-left)
		   (global-set-key (kbd "<C-S-right>")  'buf-move-right)))

   (:name smex
	  :after (progn
		   (setq smex-save-file "~/.emacs.d/.smex-items")
		   (global-set-key (kbd "M-x") 'smex)
		   (global-set-key (kbd "M-X") 'smex-major-mode-commands)))

   (:name imenu-anywhere
	  :after (progn
		   (global-set-key (kbd "C-.") 'imenu-anywhere)))

   (:name fiplr
	  :after (progn
		   (global-set-key (kbd "C-,") 'fiplr-find-file)))

   (:name color-theme-tango
	  :after (progn
		   (color-theme-tango)))

   (:name frame-restore
	  :after (progn
		   (frame-restore)))

   (:name session
	  :after (progn
		   (add-hook 'after-init-hook 'session-initialize)))

   (:name multiple-cursors
	  :after (progn
		   (global-set-key (kbd "M-SPC") 'set-rectangular-region-anchor)
		   (global-set-key (kbd "C->") 'mc/mark-next-like-this)
		   (global-set-key (kbd "C-<") 'mc/mark-all-like-this)))

   (:name auto-complete-clang
	  :after (progn
		   (setq ac-auto-start nil)
                   (setq ac-quick-help-delay 0.5)
                   ;; (ac-set-trigger-key "TAB")
                   ;; (define-key ac-mode-map  [(control tab)] 'auto-complete)
                   (define-key ac-mode-map  [(control tab)] 'auto-complete)
                   (defun my-ac-config ()
                     (setq-default ac-sources '(ac-source-abbrev ac-source-dictionary ac-source-words-in-same-mode-buffers))
                     (add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)
                     ;; (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
                     (add-hook 'ruby-mode-hook 'ac-ruby-mode-setup)
                     (add-hook 'css-mode-hook 'ac-css-mode-setup)
                     (add-hook 'auto-complete-mode-hook 'ac-common-setup)
                     (global-auto-complete-mode t))
                   (defun my-ac-cc-mode-setup ()
                     (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources)))
                   (add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup)
                   ;; ac-source-gtags
                   (my-ac-config)))

   (:name goto-last-change
	  :after (progn
		   (global-set-key (kbd "C-x C-/") 'goto-last-change)))))

;; now set our own packages
(setq
 my:el-get-packages
 '(el-get
   magit
   auto-complete
   switch-window
   yasnippet
   ;;clang-complete-async
   ;;auto-complete-clang
   multiple-cursors
   smooth-scrolling
   color-theme))

;;
;; Some recipes require extra tools to be installed
;;
;; Note: el-get-install requires git, so we know we have at least that.
;;
(when (ignore-errors (el-get-executable-find "cvs"))
  (add-to-list 'my:el-get-packages 'emacs-goodies-el)) ; the debian addons for emacs

(when (ignore-errors (el-get-executable-find "svn"))
  (loop for p in '(psvn    		; M-x svn-status
		   )
	do (add-to-list 'my:el-get-packages p)))

(setq my:el-get-packages
      (append
       my:el-get-packages
       (loop for src in el-get-sources collect (el-get-source-name src))))

;; install new packages and init already installed packages
(el-get 'sync my:el-get-packages)

;; on to the visual settings
(setq inhibit-splash-screen t)		; no splash screen, thanks
(line-number-mode 1)			; have line numbers and
(column-number-mode 1)			; column numbers in the mode line

;;(tool-bar-mode -1)			; no tool bar with icons
;;(scroll-bar-mode -1)			; no scroll bars
;;(unless (string-match "apple-darwin" system-configuration)
;;  (menu-bar-mode -1))

;; choose your own fonts, in a system dependant way
(if (string-match "apple-darwin" system-configuration)
    (set-face-font 'default "Monaco-13")
  (set-face-font 'default "Consolas-11"))

;;(global-hl-line-mode)			; highlight current line
(global-linum-mode 1)			; add line numbers on the left

;; avoid compiz manager rendering bugs
(add-to-list 'default-frame-alist '(alpha . 100))

;; copy/paste with C-c and C-v and C-x, check out C-RET too
;;(cua-mode)

;; under mac, have Command as Meta and keep Option for localized input
(when (string-match "apple-darwin" system-configuration)
  (setq mac-allow-anti-aliasing t)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'none))

;; Use the clipboard, pretty please, so that copy/paste "works"
(setq x-select-enable-clipboard t)

;; Navigate windows with M-<arrows>
(windmove-default-keybindings 'meta)
(setq windmove-wrap-around t)

;; winner-mode provides C-<left> to get back to previous window layout
(winner-mode 1)

;; whenever an external process changes a file underneath emacs, and there
;; was no unsaved changes in the corresponding buffer, just revert its
;; content to reflect what's on-disk.
(global-auto-revert-mode 1)

;; M-x shell is a nice shell interface to use, let's make it colorful.  If
;; you need a terminal emulator rather than just a shell, consider M-x term
;; instead.
;;(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
;;(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; Use bash in cygwin emacs shell. You need to add cygwin/bin in PATH and
;; reset prompt in .bashrc with export PS1="\w\\$ "
(setq explicit-shell-file-name "bash.exe")

;; If you do use M-x term, you will notice there's line mode that acts like
;; emacs buffers, and there's the default char mode that will send your
;; input char-by-char, so that curses application see each of your key
;; strokes.
;;
;; The default way to toggle between them is C-c C-j and C-c C-k, let's
;; better use just one key to do the same.
;;(require 'term)
;;(define-key term-raw-map  (kbd "C-'") 'term-line-mode)
;;(define-key term-mode-map (kbd "C-'") 'term-char-mode)

;; Have C-y act as usual in term-mode, to avoid C-' C-y C-'
;; Well the real default would be C-c C-j C-y C-c C-k.
;;(define-key term-raw-map  (kbd "C-y") 'term-paste)

;; use ido for minibuffer completion
;;(require 'ido)
;;(ido-mode t)
;;(setq ido-save-directory-list-file "~/.emacs.d/.ido.last")
;;(setq ido-enable-flex-matching t)
;;(setq ido-use-filename-at-point 'guess)
;;(setq ido-show-dot-for-dired t)
;;(setq ido-default-buffer-method 'selected-window)
;;
;; default key to switch buffer is C-x b, but that's not easy enough
;;
;; when you do that, to kill emacs either close its frame from the window
;; manager or do M-x kill-emacs.  Don't need a nice shortcut for a once a
;; week (or day) action.
;;(global-set-key (kbd "C-x C-b") 'ido-switch-buffer)
;;(global-set-key (kbd "C-x C-c") 'ido-switch-buffer)
;;(global-set-key (kbd "C-x B") 'ibuffer)

;; have vertical ido completion lists
(setq ido-decorations
      '("\n-> " "" "\n   " "\n   ..." "[" "]"
	" [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]"))

;; C-x C-j opens dired with the cursor right on the file you're editing
(require 'dired-x)

;; full screen
;;(defun fullscreen ()
;;  (interactive)
;;  (set-frame-parameter nil 'fullscreen
;;		       (if (frame-parameter nil 'fullscreen) nil 'fullboth)))
;;(global-set-key [f11] 'fullscreen)

;; disable backup
;;(setq make-backup-files nil) 

;; enable emacsclient
(require 'server)
(unless (server-running-p)
  (server-start))

;; enable spell check
;;(add-hook 'text-mode-hook 'flyspell-mode)
;;(add-hook 'prog-mode-hook 'flyspell-prog-mode)
;;(add-hook 'flyspcell-mode-hook 'flyspell-buffer)
(defun flyspell-emacs-popup-textual (event poss word)
  "A textual flyspell popup menu."
  (require 'popup)
  (let* ((corrects (if flyspell-sort-corrections
		       (sort (car (cdr (cdr poss))) 'string<)
		     (car (cdr (cdr poss)))))
	 (cor-menu (if (consp corrects)
		       (mapcar (lambda (correct)
				 (list correct correct))
			       corrects)
		     '()))
	 (affix (car (cdr (cdr (cdr poss)))))
	 show-affix-info
	 (base-menu  (let ((save (if (and (consp affix) show-affix-info)
				     (list
				      (list (concat "Save affix: " (car affix))
					    'save)
				      '("Accept (session)" session)
				      '("Accept (buffer)" buffer))
				   '(("Save word" save)
				     ("Accept (session)" session)
				     ("Accept (buffer)" buffer)))))
		       (if (consp cor-menu)
			   (append cor-menu (cons "" save))
			 save)))
	 (menu (mapcar
		(lambda (arg) (if (consp arg) (car arg) arg))
		base-menu)))
    (cadr (assoc (popup-menu* menu :scroll-bar t) base-menu))))
(eval-after-load "flyspell"
  '(progn
     (fset 'flyspell-emacs-popup 'flyspell-emacs-popup-textual)))
(global-set-key (kbd "C-c c") 'flyspell-buffer)
(global-set-key (kbd "C-c s") 'flyspell-correct-word-before-point)

;; disable truncate lines
(global-visual-line-mode t)

;; show paren
;;(show-paren-mode 1)

;; change some basic bindings
(require 'misc)
(defvar my-keys-minor-mode-map ;; this will override all major bindings
  (make-keymap)
  "my-keys-minor-mode keymap.")
(define-key my-keys-minor-mode-map (kbd "M-j") 'next-line)
(define-key my-keys-minor-mode-map (kbd "M-k") 'previous-line)
(define-key my-keys-minor-mode-map (kbd "M-h") 'backward-char)
(define-key my-keys-minor-mode-map (kbd "M-e") 'forward-same-syntax)
(define-key my-keys-minor-mode-map (kbd "M-l") 'forward-char)
(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  t " B" 'my-keys-minor-mode-map)
(defun my-minibuffer-setup-hook ()
  (my-keys-minor-mode 0))
(add-hook 'minibuffer-setup-hook 'my-minibuffer-setup-hook)
(defadvice load (after give-my-keybindings-priority)
  "Try to ensure that my keybindings always have priority."
  (if (not (eq (car (car minor-mode-map-alist)) 'my-keys-minor-mode))
      (let ((mykeys (assq 'my-keys-minor-mode minor-mode-map-alist)))
        (assq-delete-all 'my-keys-minor-mode minor-mode-map-alist)
        (add-to-list 'minor-mode-map-alist mykeys))))
(ad-activate 'load)

;; save desktop
(desktop-save-mode 1)

;; astyle
(defun astyle-buffer ()
  "Format current buffer with astyle"
  (interactive)
  (let* ((astyle-current-line (line-number-at-pos)))
    (shell-command-on-region (point-min) (point-max)
                             "astyle" ;; add options here...
                             (current-buffer) t 
                             (get-buffer-create "*Astyle Errors*") t)
    (goto-char (point-min)) (forward-line (1- astyle-current-line))))
(global-set-key (kbd "C-c q") 'astyle-buffer)

;; jump to matching parenthesis
(defun goto-match-paren (arg)
  "Go to the matching parenthesis if on parenthesis, otherwise insert %.
vi style of % jumping to matching brace."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))
(global-set-key (kbd "C-%") 'goto-match-paren)

;; replace grep with ack
(defvar ack-history nil
  "History for the `ack' command.")
(defun ack (command-args)
  (interactive
   (let ((ack-command "ack --nogroup --with-filename "))
     (list (read-shell-command "Run ack (like this): "
                               ack-command
                               'ack-history))))
  (let ((compilation-disable-input t))
    (compilation-start (concat command-args " < " null-device)
                       'grep-mode)))
