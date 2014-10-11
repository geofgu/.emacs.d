((ack status "required" recipe nil)
 (anything status "required" recipe
           (:name anything :website "http://www.emacswiki.org/emacs/Anything" :description "Open anything / QuickSilver-like candidate-selection framework" :type git :url "http://repo.or.cz/r/anything-config.git" :shallow nil :load-path
                  ("." "extensions" "contrib")
                  :features anything))
 (auto-complete status "installed" recipe
                (:name auto-complete :website "https://github.com/auto-complete/auto-complete" :description "The most intelligent auto-completion extension." :type github :pkgname "auto-complete/auto-complete" :depends
                       (popup fuzzy)
                       :features auto-complete-config :post-init
                       (progn
                         (add-to-list 'ac-dictionary-directories
                                      (expand-file-name "dict" default-directory))
                         (ac-config-default))))
 (auto-complete-clang status "installed" recipe
                      (:name auto-complete-clang :after
                             (progn
                               (setq ac-auto-start nil)
                               (setq ac-quick-help-delay 0.5)
                               (define-key ac-mode-map
                                 [(control tab)]
                                 'auto-complete)
                               (defun my-ac-config nil
                                 (setq-default ac-sources
                                               '(ac-source-abbrev ac-source-dictionary ac-source-words-in-same-mode-buffers))
                                 (add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)
                                 (add-hook 'ruby-mode-hook 'ac-ruby-mode-setup)
                                 (add-hook 'css-mode-hook 'ac-css-mode-setup)
                                 (add-hook 'auto-complete-mode-hook 'ac-common-setup)
                                 (global-auto-complete-mode t))
                               (defun my-ac-cc-mode-setup nil
                                 (setq ac-sources
                                       (append
                                        '(ac-source-clang ac-source-yasnippet)
                                        ac-sources)))
                               (add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup)
                               (my-ac-config))
                             :website "https://github.com/brianjcj/auto-complete-clang" :description "Auto-complete sources for Clang. Combine the power of AC, Clang and Yasnippet." :type github :pkgname "brianjcj/auto-complete-clang" :depends auto-complete))
 (buffer-move status "installed" recipe
              (:name buffer-move :after
                     (progn
                       (global-set-key
                        (kbd "<C-S-up>")
                        'buf-move-up)
                       (global-set-key
                        (kbd "<C-S-down>")
                        'buf-move-down)
                       (global-set-key
                        (kbd "<C-S-left>")
                        'buf-move-left)
                       (global-set-key
                        (kbd "<C-S-right>")
                        'buf-move-right))
                     :description "Swap buffers without typing C-x b on each window" :type emacswiki :features buffer-move))
 (cl-lib status "installed" recipe
         (:name cl-lib :builtin "24.3" :type elpa :description "Properly prefixed CL functions and macros" :url "http://elpa.gnu.org/packages/cl-lib.html"))
 (clang-complete-async status "required" recipe nil)
 (clang-format status "required" recipe nil)
 (color-theme status "installed" recipe
              (:name color-theme :description "An Emacs-Lisp package with more than 50 color themes for your use. For questions about color-theme" :website "http://www.nongnu.org/color-theme/" :type http-tar :options
                     ("xzf")
                     :url "http://download.savannah.gnu.org/releases/color-theme/color-theme-6.6.0.tar.gz" :load "color-theme.el" :features "color-theme" :post-init
                     (progn
                       (color-theme-initialize)
                       (setq color-theme-is-global t))))
 (color-theme-tango status "installed" recipe
                    (:name color-theme-tango :after
                           (progn
                             (color-theme-tango))
                           :description "Color theme based on Tango Palette. Created by danranx@gmail.com" :type emacswiki :depends color-theme :prepare
                           (autoload 'color-theme-tango "color-theme-tango" "color-theme: tango" t)))
 (dictionary status "required" recipe
             (:name dictionary :after
                    (progn
                      (global-set-key
                       (kbd "<f8>")
                       'dictionary-lookup-definition))
                    :website "http://www.myrkr.in-berlin.de/dictionary/" :description "Emacs package for talking to a dictionary server" :type http-tar :options
                    ("xzf")
                    :url "http://www.myrkr.in-berlin.de/dictionary/dictionary-1.10.tar.gz" :build
                    `(,(concat "make EMACS=" el-get-emacs))))
 (el-get status "installed" recipe
         (:name el-get :website "https://github.com/dimitri/el-get#readme" :description "Manage the external elisp bits and pieces you depend upon." :type github :branch "master" :pkgname "dimitri/el-get" :info "." :compile
                ("el-get.*\\.el$" "methods/")
                :load "el-get.el"))
 (escreen status "installed" recipe
          (:name escreen :description "Emacs window session manager" :type http :url "http://www.splode.com/~friedman/software/emacs-lisp/src/escreen.el" :prepare
                 (autoload 'escreen-install "escreen" nil t)))
 (expand-region status "installed" recipe
                (:name expand-region :before
                       (global-set-key
                        (kbd "C-@")
                        'er/expand-region)
                       :type github :pkgname "magnars/expand-region.el" :description "Expand region increases the selected region by semantic units. Just keep pressing the key until it selects what you want." :website "https://github.com/magnars/expand-region.el#readme"))
 (fiplr status "installed" recipe
        (:name fiplr :after
               (progn
                 (global-set-key
                  (kbd "C-,")
                  'fiplr-find-file))
               :description "Find in Project for Emacs" :type github :pkgname "d11wtq/fiplr" :depends grizzl))
 (frame-restore status "installed" recipe
                (:name frame-restore :after
                       (progn
                         (frame-restore))
                       :type emacswiki :description "Save/restore frame size & position with desktop-save" :website "https://raw.github.com/emacsmirror/emacswiki.org/master/frame-restore.el" :features frame-restore))
 (fuzzy status "installed" recipe
        (:name fuzzy :website "https://github.com/auto-complete/fuzzy-el" :description "Fuzzy matching utilities for GNU Emacs" :type github :pkgname "auto-complete/fuzzy-el"))
 (git-modes status "installed" recipe
            (:name git-modes :description "GNU Emacs modes for various Git-related files" :type github :pkgname "magit/git-modes"))
 (goto-last-change status "installed" recipe
                   (:name goto-last-change :after
                          (progn
                            (global-set-key
                             (kbd "C-x C-/")
                             'goto-last-change))
                          :description "Move point through buffer-undo-list positions" :type emacswiki :load "goto-last-change.el"))
 (grizzl status "installed" recipe
         (:name grizzl :description "Grizzl is a small utility library to be used in other Elisp code needing fuzzy search behaviour. It is optimized for large data sets, using a special type of lookup table and supporting incremental searches (searches where the result can be narrowed-down by only searching what is already matched)." :type github :pkgname "d11wtq/grizzl"))
 (helm status "required" recipe
       (:name helm :after
              (progn
                (global-set-key
                 (kbd "C-c b")
                 'helm-mini)
                (global-set-key
                 (kbd "C-c g")
                 'helm-find-files))
              :description "Emacs incremental and narrowing framework" :type github :pkgname "emacs-helm/helm" :compile nil))
 (ido-better-flex status "installed" recipe
                  (:name ido-better-flex :description "A better flex (fuzzy) algorithm for Ido" :type github :pkgname "vic/ido-better-flex"))
 (ido-vertical-mode status "installed" recipe
                    (:name ido-vertical-mode :type github :pkgname "rson/ido-vertical-mode.el" :description "makes ido-mode display vertically" :features ido-vertical-mode))
 (imenu-anywhere status "installed" recipe
                 (:name imenu-anywhere :after
                        (progn
                          (global-set-key
                           (kbd "C-.")
                           'imenu-anywhere))
                        :description "Ido/helm imenu tag selection across all buffers with the same mode" :type github :pkgname "vitoshka/imenu-anywhere"))
 (json status "installed" recipe
       (:name json :description "JavaScript Object Notation parser / generator" :type http :builtin "23" :url "http://edward.oconnor.cx/elisp/json.el"))
 (magit status "installed" recipe
        (:name magit :website "https://github.com/magit/magit#readme" :description "It's Magit! An Emacs mode for Git." :type github :pkgname "magit/magit" :depends
               (cl-lib git-modes)
               :info "." :build
               (if
                   (version<= "24.3" emacs-version)
                   `(("make" ,(format "EMACS=%s" el-get-emacs)
                      "all"))
                 `(("make" ,(format "EMACS=%s" el-get-emacs)
                    "docs")))
               :build/berkeley-unix
               (("touch" "`find . -name Makefile`")
                ("gmake"))
               :prepare
               (require 'magit-autoloads)))
 (multiple-cursors status "installed" recipe
                   (:name multiple-cursors :after
                          (progn
                            (global-set-key
                             (kbd "M-SPC")
                             'set-rectangular-region-anchor)
                            (global-set-key
                             (kbd "C->")
                             'mc/mark-next-like-this)
                            (global-set-key
                             (kbd "C-<")
                             'mc/mark-all-like-this))
                          :description "An experiment in adding multiple cursors to emacs" :type github :pkgname "magnars/multiple-cursors.el"))
 (paredit status "required" recipe
          (:name paredit :after
                 (progn
                   (add-hook 'text-mode-hook 'paredit-mode)
                   (add-hook 'prog-mode-hook 'paredit-mode))
                 :description "Minor mode for editing parentheses" :type http :prepare
                 (progn
                   (autoload 'enable-paredit-mode "paredit")
                   (autoload 'disable-paredit-mode "paredit"))
                 :url "http://mumble.net/~campbell/emacs/paredit.el"))
 (php-mode-improved status "required" recipe
                    (:name php-mode-improved :description "Major mode for editing PHP code. This is a version of the php-mode from http://php-mode.sourceforge.net that fixes a few bugs which make using php-mode much more palatable" :type emacswiki :load
                           ("php-mode-improved.el")
                           :features php-mode))
 (popup status "installed" recipe
        (:name popup :website "https://github.com/auto-complete/popup-el" :description "Visual Popup Interface Library for Emacs" :type github :submodule nil :pkgname "auto-complete/popup-el"))
 (session status "installed" recipe
          (:name session :after
                 (progn
                   (add-hook 'after-init-hook 'session-initialize))
                 :description "When you start Emacs, package Session restores various variables (e.g., input histories) from your last session. It also provides a menu containing recently changed/visited files and restores the places (e.g., point) of such a file when you revisit it." :type http-tar :options
                 ("xzf")
                 :load-path
                 ("lisp")
                 :url "http://downloads.sourceforge.net/project/emacs-session/session/session-2.3a.tar.gz"))
 (smex status "installed" recipe
       (:name smex :after
              (progn
                (setq smex-save-file "~/.emacs.d/.smex-items")
                (global-set-key
                 (kbd "M-x")
                 'smex)
                (global-set-key
                 (kbd "M-X")
                 'smex-major-mode-commands))
              :description "M-x interface with Ido-style fuzzy matching." :type github :pkgname "nonsequitur/smex" :features smex :post-init
              (smex-initialize)))
 (smooth-scroll status "required" recipe
                (:name smooth-scroll :description "Minor mode for smooth scrolling." :type emacswiki :features smooth-scroll))
 (smooth-scrolling status "installed" recipe
                   (:name smooth-scrolling :description "Make emacs scroll smoothly, keeping the point away from the top and bottom of the current buffer's window in order to keep lines of context around the point visible as much as possible, whilst avoiding sudden scroll jumps which are visually confusing." :type github :pkgname "aspiers/smooth-scrolling" :features smooth-scrolling))
 (switch-window status "installed" recipe
                (:name switch-window :description "A *visual* way to choose a window to switch to" :type github :pkgname "dimitri/switch-window" :features switch-window))
 (thingatpt+ status "required" recipe nil)
 (vkill status "installed" recipe
        (:name vkill :description "View and kill Unix processes from within Emacs" :type http :url "http://www.splode.com/~friedman/software/emacs-lisp/src/vkill.el" :features vkill))
 (yasnippet status "installed" recipe
            (:name yasnippet :website "https://github.com/capitaomorte/yasnippet.git" :description "YASnippet is a template system for Emacs." :type github :pkgname "capitaomorte/yasnippet" :compile "yasnippet.el" :submodule nil :build
                   (("git" "submodule" "update" "--init" "--" "snippets"))))
 (zencoding-mode status "required" recipe
                 (:name zencoding-mode :description "Unfold CSS-selector-like expressions to markup" :type github :pkgname "rooney/zencoding" :features zencoding-mode)))
