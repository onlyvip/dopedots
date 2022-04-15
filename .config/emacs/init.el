#+title: vipul's Config
#+startup: content
* README:
After the first run that installs things, run the following
#+begin_src emacs-lisp :tangle no
  ; code-block not tangled
  (all-the-icons-install-fonts)
  (fira-code-mode-set-font)
#+end_src

* Performance
#+begin_src emacs-lisp
  ;;lsp performance improvement
  (setq gc-cons-threshold-original gc-cons-threshold) 
  (setq gc-cons-threshold (* 1024 1024 100))
  (setq read-process-output-max (* 1024 4024))
#+end_src

* Packaging
Initialize Package sources
#+begin_src emacs-lisp
  (require 'package)

  (setq package-archives '(("melpa" . "https://melpa.org/packages/")
                              ("org" . "https://orgmode.org/elpa/")
                              ("elpa" . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless package-archive-contents
  (package-refresh-contents))

  ;; Initialize use-package on non-Linux platforms
  (unless (package-installed-p 'use-package)
  (package-install 'use-package))
#+end_src

Make sure to download packages if not present
#+begin_src emacs-lisp
  (require 'use-package)
  (setq package-native-compile t)
 (setq use-package-always-ensure t)
#+end_src
straight
#+begin_src emacs-lisp
  (defvar bootstrap-version)
  (let ((bootstrap-file
         (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
        (bootstrap-version 5))
    (unless (file-exists-p bootstrap-file)
      (with-current-buffer
          (url-retrieve-synchronously
           "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
           'silent 'inhibit-cookies)
        (goto-char (point-max))
        (eval-print-last-sexp)))
    (load bootstrap-file nil 'nomessage))

    (straight-use-package 'use-package)
    (setq straight-use-package-by-default t)
#+end_src

remove warning by use-package
#+begin_src emacs-lisp
(custom-set-variables '(warning-suppress-types '((use-package))))
#+end_src

* Basic Configuration
** Better Defaults
#+begin_src emacs-lisp 
  (setq inhibit-startup-message t)
  (scroll-bar-mode -1)              ; Disable visible scrollbar
  (tool-bar-mode -1)                ; Disable the toolbar
  (tooltip-mode -1)                 ; Disable tooltips
  (set-fringe-mode 10)              ; Give some breathing room

  (menu-bar-mode -1)                ; Disable the menu bar
  (winner-mode 1)                   ; Disable the menu bar
  (setq visible-bell nil)           ; Set up the visible bell
  (column-number-mode)              ; Display Column Number in the modline
  (setq use-dialog-box nil)         ; I don't like to confirm anything with a mouse!
  (defalias 'yes-or-no-p 'y-or-n-p) ; I don't want to type 'yes' everytime!, 'y' is enough

  (setq comp-deferred-compilation-deny-list '()) ;; turn off bytecompiler warnings
  (setq native-comp-async-report-warnings-errors nil)

#+end_src
Emacs Backups trashing local dir!
#+begin_src emacs-lisp 
  (setq backup-directory-alist `(("." . "~/.local/share/emacs-backups")))
  (setq make-backup-files t          ; backup of a file the first time it is saved.
      backup-by-copying t          ; don't clobber symlinks
      version-control t            ; version numbers for backup files
      vc-make-backup-files t       ; version control for git/vcs dirs
      delete-old-versions t        ; delete excess backup files silently
      delete-by-moving-to-trash t
      kept-old-versions 6          ; oldest versions to keep when a new numbered backup is made 
      kept-new-versions 9          ; newest versions to keep when a new numbered backup is made 
      auto-save-default t          ; auto-save every buffer that visits a file
      auto-save-timeout 20         ; number of seconds idle time before auto-save (default: 30)
      auto-save-interval 200       ; number of keystrokes between auto-saves (default: 300)
      create-lockfiles nil         ; don't use lockfiles (default: t)
      )
#+end_src
Better Scrolling
#+begin_src emacs-lisp
  (setq scroll-conservatively 10)
  (setq scroll-margin 3)
  (use-package smooth-scrolling
     :custom (smooth-scrolling-mode 1))
#+end_src

** Fonts
Setting fonts here as vars to stay sane
#+begin_src emacs-lisp
  (setq my/ui/monofont "VictorMono Nerd Font")
  (setq my/ui/varfont "Noto Serif")
#+end_src

#+begin_src emacs-lisp
  (set-face-attribute 'default nil :font my/ui/monofont :height 130)
  (set-face-attribute 'fixed-pitch nil :font my/ui/monofont :height 130)
  (set-face-attribute 'variable-pitch nil :font my/ui/varfont :height 130)
  ;; Info has a horrible mono font
  (set-face-attribute 'Info-quoted nil :font my/ui/monofont :height 130)
#+end_src

emacs-client frames don't adhire to the font for some reason, need to
run this hook:
#+begin_src emacs-lisp
  (defun my/ui/font-check ()
    "Do font check, then remove self from `focus-in-hook'; need to run this just once."
    (set-face-attribute 'default nil :font my/ui/monofont :height 130)
    (set-face-attribute 'fixed-pitch nil :font my/ui/monofont :height 130)
    (set-face-attribute 'variable-pitch nil :font my/ui/varfont :height 130)
    ;; Info has a horrible mono font
    (set-face-attribute 'Info-quoted nil :font my/ui/monofont :height 130)
#+end_src
** Theme
Run =M-x= all-the-icons-install-fonts for the first time!
#+begin_src emacs-lisp
  (use-package all-the-icons)
#+end_src

The status line
#+begin_src emacs-lisp
    (use-package doom-modeline
      :ensure t
      :init (doom-modeline-mode 1)
      :config
      (display-battery-mode 1)
      :custom
  ((doom-modeline-height 15) (doom-modeline-icon t)))
#+end_src

buffers with dimmed colors
#+begin_src emacs-lisp
  (use-package solaire-mode
  :init (solaire-global-mode +1))
#+end_src

Actuall Theme:
#+begin_src emacs-lisp
  (use-package doom-themes
    :config
    ;; Global settings (defaults)
    (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
          doom-themes-enable-italic t) ; if nil, italics is universally disabled
    (load-theme 'doom-flatwhite t)
    ;; (load-theme 'doom-one-light t)
    (custom-set-faces
    ;; custom-set-faces was added by Custom.
    ;; If you edit it by hand, you could mess it up, so be careful.
    ;; Your init file should contain only one such instance.
    ;; If there is more than one, they won't work right.
    ;; '(flycheck-warning ((t (:background "#282828" :underline "#fabd2f"))))
    '(org-date ((t (:inherit fixed-pitch))))
    ;; '(ivy-posframe-border ((t (:background "#ffffff")))))

  )

    ;; Enable custom neotree theme (all-the-icons must be installed!)
    (doom-themes-neotree-config)
    ;; or for treemacs users
    (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
    (doom-themes-treemacs-config)
    ;; Corrects (and improves) org-mode's native fontification.
    (doom-themes-org-config))
#+end_src

Transperancy!
#+begin_src emacs-lisp
  ;; for the first frame
  (set-frame-parameter nil 'alpha-background 0.9)
  ;; for other frames
  (add-hook 'server-after-make-frame-hook
      (lambda nil  (set-frame-parameter nil 'alpha-background 0.9)))
#+end_src

Center text in the frame, looks nice ;)
#+begin_src emacs-lisp
  (use-package olivetti
    :diminish
    :hook (text-mode . olivetti-mode)
    :hook (prog-mode . olivetti-mode)
    :hook (Info-mode . olivetti-mode)
    :config
    (setq olivetti-body-width 120))
  
#+end_src

** Line Numbers
 
DEPRECATED Enable Globally
#+begin_src emacs-lisp
  ; this block has ":tangle no"
  (global-display-line-numbers-mode 1)
  (setq display-line-numbers-type 'relative)
#+end_src

DEPRECATED Disable for the following modes
#+begin_src emacs-lisp :tangle no
  (defun disable-line-numbers () "Disables line number" (interactive) (display-line-numbers-mode 0))

  (dolist (mode '(org-mode-hook
                  term-mode-hook
                  treemacs-mode-hook
                  cargo-test-mode-hook
                  shell-mode-hook
                  eshell-mode-hook))
    (add-hook mode #'disable-line-numbers))  

#+end_src
ONLY IN PROG!
#+begin_src emacs-lisp
  ;; (add-hook 'prog-mode-hook 'display-line-numbers-mode)
#+end_src
 
** Undo
Self explanatory
#+begin_src emacs-lisp
  (use-package undo-fu)
#+end_src

** Org roam warning
#+begin_src emacs-lisp
(setq org-roam-v2-ack t) ; anonying startup message
#+end_src

* Help
=helpful-key= and =describe-function=
#+begin_src emacs-lisp
  (use-package helpful
    :commands (helpful-callable helpful-variable helpful-command helpful-key)
    :custom
    (counsel-describe-function-function #'helpful-callable)
    (counsel-describe-variable-function #'helpful-variable)
    :bind
    ([remap describe-function] . counsel-describe-function)
    ([remap describe-command] . helpful-command)
    ([remap describe-variable] . counsel-describe-variable)
    ([remap describe-key] . helpful-key))
#+end_src

* Keybinds
Single Esc to Quit, instead of *three*
#+begin_src emacs-lisp
  (global-set-key (kbd "<escape>") 'keyboard-escape-quit)
#+end_src

** Function keys
#+begin_src emacs-lisp
  (global-set-key (kbd "M-<f8>") '(lambda () (interactive) (org-agenda  nil "n")))
  (global-set-key (kbd "<f8>"  ) '(lambda () (interactive) (org-ql-view "Overview: Agenda-like")))
  (global-set-key (kbd "M-<f6>") 'elfeed-dashboard)
#+end_src

** General.el
Eval First and Last at least block!
Edit: honestly I have no clue wtf that meant, or why I wrote it, but I will keep it
*** use-package
#+begin_src emacs-lisp
  (use-package general
    :after evil
    :defer t
    :preface
#+end_src

*** Helper Functions
#+begin_src emacs-lisp
  (defun my/keybind/config ()
    (interactive)
    (counsel-find-file "emacs" "~/.config/"))

  (defun my/keybind/capture-inbox ()
    (interactive)
    (org-capture  nil "gi"))
  
  (defun my/counsel-insert-file-path ()
    "Insert relative file path using counsel minibuffer"
    (interactive)
    (unless (featurep 'counsel) (require 'counsel))
    (ivy-read "Insert filename: " 'read-file-name-internal
                :matcher #'counsel--find-file-matcher
                :action
                (lambda (x)
                (insert (file-relative-name x)))))

#+end_src

***  leader-keys
**** config head declartion
#+begin_src emacs-lisp
  :config
  (general-create-definer my/leader-keys
    :keymaps 'override
    :states '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

#+end_src

**** Symbols, Spaces, Numbers, u, tabs

#+begin_src emacs-lisp
  (my/leader-keys
  "." '(counsel-find-file :which-key "find file")
  "SPC" '(counsel-projectile-find-file :which-key "projectile find file")
  "/" '(counsel-projectile-rg :which-key "projects")
  "," '(counsel-rg :which-key "rg")
  "u" '(universal-argument :which-key "universal arg")
  ";" '(counsel-M-x :which-key "M-x")
  ":" '(eval-expression :which-key "eval expression")
#+end_src

**** Toggles (t)
#+begin_src emacs-lisp
  "t"  '(:ignore t :which-key "toggles")
#+end_src

**** Help (h)
#+begin_src emacs-lisp 
  "h"  '(:ignore t :which-key "Help")

  "ht" '(counsel-load-theme :which-key "Choose Theme")
  "hk" '(helpful-key :which-key "Describe Key")
  "hf" '(counsel-describe-function :which-key "Describe Function")
  "hv" '(counsel-describe-variable :which-key "Describe Variable")
  "hF" '(counsel-describe-face :which-key "Describe Face")
  "hi" '(info :which-key "info")
  "hm" '(woman :which-key "woman")
#+end_src

**** search (s)
#+begin_src emacs-lisp
  "s"  '(:ignore t :which-key "Search")
  
  "sb" '(swiper :which-key "swiper")
#+end_src

**** Files (f)
#+begin_src emacs-lisp 
  "f"  '(:ignore t :which-key "Files")

  "fr" '(counsel-recentf :which-key "Recent Files")
  "fp" '(my/keybind/config :which-key "Config")
  "fd" '(dired :which-key "dired prompt")
  "fD" '(dired-jump :which-key "dired current")
#+end_src

**** Roam and Org, Capture, Inbox(r/C/I)
#+begin_src emacs-lisp
  "r"  '(:ignore t :which-key "Roam+Org")
  
  "ra"  '(org-agenda :which-key "Agenda")
  
  "rD" '(deft :which-key "Deft")
  "rf" '(org-roam-node-find :which-key "Find Note")
  "rl" '(org-roam-buffer-toggle :which-key "Toggle Sidebar")
  "rr" '(org-roam-db-sync :which-key "Roam Sync")
  "ri" '(org-roam-node-insert :which-key "Node  Insert")
  "rI" '(org-id-get-create :which-key "Org Id get/create")
  "rT" '(counsel-org-tag :which-key "Org Id get/create")
  
  
  ;; Dailies
  "rd"  '(:ignore t :which-key "Dailies")
  "rdT" '(org-roam-dailies-goto-today :which-key "Go To Today")
  "rdt" '(org-roam-dailies-capture-today :which-key "Capture Today")
  "rdY" '(org-roam-dailies-goto-yesterday :which-key "Go To yesterday")
  "rdy" '(org-roam-dailies-capture-yesterday :which-key "Capture yesterday")
  "rdM" '(org-roam-dailies-goto-tomorrow :which-key "Go To tomorrow")
  "rdm" '(org-roam-dailies-capture-tomorrow :which-key "Capture tomorrow")
  
  ;; Clocks
  "rc"  '(:ignore t :which-key "Clocks")
  "rci" '(org-clock-in :which-key "Clock In")
  "rcI" '(org-clock-in-last :which-key "Clock In Last")
  "rco" '(org-clock-out :which-key "Clock Out")
  "rcp" '(org-pomodoro :which-key "Pomodoro")
  "rcR" '(org-clock-report :which-key "Clock Report")
  "rcg" '(org-clock-goto :which-key "Goto Clock")
  
  ;; Anki
  "rn"  '(:ignore t :which-key "AnKi")
  "rnp" '(anki-editor-push-notes :which-key "Clock In")
  "rni" '(anki-editor-insert-notes :which-key "Clock In")
  
  
  ;; Schedules and Deadlines
  ;; TODO!
#+end_src
Capture
#+begin_src emacs-lisp
      "C"  '(org-capture :which-key "Org-Capture")
      "I"  '(my/keybind/capture-inbox :which-key "Capture Inbox")
#+end_src

**** Open (o)
#+begin_src emacs-lisp
  "o"  '(:ignore t :which-key "Open")

  "oT" '(vterm :which-key "Vterm in current window")
  ;"ot" '(vterm-other-window :which-key "Vterm in other window")
  "ob" '(bookmark-jump :which-key "Bookmark Jump")
  "oB" '(bookmark-set :which-key "Bookmark set")
  "op" '(list-processes :which-key "List Proccess")

  "om" '(mu4e :which-key "mu4e")
  "ot" '(telega :which-key "Telega")
  "oc" '(circe :which-key "Circe")

  "oe" '(elfeed-dashboard :which-key "Elfeed Dashboard")
#+end_src

**** Insert (i)
#+begin_src emacs-lisp
  "i"  '(:ignore t :which-key "Insert")
  "ie" '(emoji-insert :which-key "Emoji")
  "if" '(my/counsel-insert-file-path :which-key "Insert Relative path")
  "ik" '(helm-show-kill-ring :which-key "Insert from Kill ring")
#+end_src

**** Buffers (b)
#+begin_src emacs-lisp
  "b"  '(:ignore t :which-key "buffers")

  "bs" '(save-buffer :which-key "Save Buffer")
  "bk" '(kill-current-buffer :which-key "Kill Buffer")
  "bl" '(evil-switch-to-windows-last-buffer :which-key "Last Buffer")
  "bi" '(ibuffer :which-key "Ibuffer")
  "br" '(revert-buffer :which-key "Revert Buffer")
  "bb" '(helm-buffers-list :which-key "Switch to buffer")
  
  "bc" '(my/circe/helm-buffers :which-key "Circe Helm")
  "bt" '(telega-switch-buffer :which-key "Telega buffers")
#+end_src

**** Windows (w)
#+begin_src emacs-lisp
  "w"  '(:ignore t :which-key "Windows")
  
  "wj" '(evil-window-down :which-key "Window Down")
  "wk" '(evil-window-up :which-key "Window Up")
  "wl" '(evil-window-right :which-key "Window Left")
  "wh" '(evil-window-left :which-key "Window Down")
  "wJ" '(evil-window-move-very-bottom :which-key "Move Window Down")
  "wK" '(evil-window-move-very-top :which-key "Move Window Up")
  "wL" '(evil-window-move-far-right :which-key "Move Window Left")
  "wH" '(evil-window-move-far-left :which-key "Move Window Down")
  
  "ws" '(evil-window-split :which-key "Window Split")
  "wv" '(evil-window-vsplit :which-key "Window Vsplit")
  "wd" '(evil-window-delete :which-key "Window delete")
  "wu" '(winner-undo :which-key "Window Undo")
  "wo" '(other-window :which-key "Window Other")
  "wr" '(winner-redo :which-key "Window Redo")
  "wt" '(treemacs :which-key "Treemacs")
#+end_src

**** Code (c)
#+begin_src emacs-lisp
  "c"  '(:ignore t :which-key "code")

  "cE" '(eval-defun :which-key "Eval Function at Point")
  "ce" '(eval-last-sexp :which-key "Eval Function")
  "cb" '(eval-buffer :which-key "Eval Buffer")
  "ca" '(lsp-execute-code-action :which-key "Code Action")
  "cl" '(lsp-avy-lens :which-key "Code Action")
  "ci" '(lsp-ui-imenu :which-key "lsp imenu")
  "cr" '(lsp-rename :which-key "rename")
  "cs" '(lsp-find-refernces :which-key "find refernces")
  "cd" '(lsp-find-definition :which-key "goto defintion")
#+end_src

**** Git (g)
#+begin_src emacs-lisp
  "g"  '(:ignore t :which-key "Git")
  "gg" '(magit-status :which-key "Magit")
#+end_src

**** Projectile (p)
#+begin_src emacs-lisp
  "p"  '(projectile-command-map t :which-key "Projectile")
#+end_src

**** Quit (q)
#+begin_src emacs-lisp
  "q"  '(:ignore t :which-key "Quit and Stuff")
  "qf" '(delete-frame :which-key "Close Frame")
#+end_src

*** Closing Brackets
#+begin_src emacs-lisp
))
#+end_src

** Evil
*** Basic Evil
#+begin_src emacs-lisp
  (use-package evil
    :init
    (setq evil-want-integration t
          evil-want-keybinding nil
          evil-want-C-u-scroll t
          evil-want-C-w-delete t
          evil-want-C-i-jump t
          evil-want-Y-yank-to-eol t
          evil-normal-state-cursor 'box
          evil-emacs-state-cursor  '(box +evil-emacs-cursor-fn); TODO: fix
          evil-insert-state-cursor 'bar
          evil-visual-state-cursor 'hollow
          evil-undo-system 'undo-redo
          )
    :config
    (evil-mode 1)
    (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
    (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
    (define-key evil-normal-state-map "u" 'undo-fu-only-undo)
    (define-key evil-normal-state-map "\C-r" 'undo-fu-only-redo)
    (define-key evil-normal-state-map "\C-e" 'evil-end-of-line)
    (define-key evil-insert-state-map "\C-a" 'evil-beginning-of-line)
    (define-key evil-insert-state-map "\C-e" 'end-of-line)
    (define-key evil-visual-state-map "\C-e" 'evil-end-of-line)
    (define-key evil-motion-state-map "\C-e" 'evil-end-of-line)
    (define-key evil-normal-state-map "\C-f" 'evil-forward-char)
    (define-key evil-insert-state-map "\C-f" 'evil-forward-char)
    (define-key evil-insert-state-map "\C-f" 'evil-forward-char)
    (define-key evil-normal-state-map "\C-b" 'evil-backward-char)
    (define-key evil-insert-state-map "\C-b" 'evil-backward-char)
    (define-key evil-visual-state-map "\C-b" 'evil-backward-char)
  
    (define-key evil-insert-state-map "\C-d" 'evil-delete-char)
  
    (define-key evil-normal-state-map "\C-i" 'evil-jump-forward)
  
    (define-key evil-normal-state-map "\C-n" 'evil-next-line)
    (define-key evil-insert-state-map "\C-n" 'evil-next-line)
    (define-key evil-visual-state-map "\C-n" 'evil-next-line)
    (define-key evil-normal-state-map "\C-p" 'evil-previous-line)
    (define-key evil-insert-state-map "\C-p" 'evil-previous-line)
    (define-key evil-visual-state-map "\C-p" 'evil-previous-line)
    ;; (define-key evil-normal-state-map "\C-w" 'evil-delete);; in custom
    (define-key evil-insert-state-map "\C-w" 'evil-delete-backward-word)
    (define-key evil-visual-state-map "\C-w" 'evil-delete-backward-word)
    (define-key evil-normal-state-map "\C-y" 'yank)
    (define-key evil-insert-state-map "\C-y" 'yank)
    (define-key evil-visual-state-map "\C-y" 'yank)
  
    (define-key evil-normal-state-map "K" 'lsp-ui-doc-glance); TODO: all modes
    (define-key evil-visual-state-map "\C-y" 'yank)
                                          ;(define-key evil-insert-state-map "\C-k" 'kill-line)
    (define-key evil-normal-state-map "Q" 'call-last-kbd-macro)
    (define-key evil-visual-state-map "Q" 'call-last-kbd-macro)
    ;; (define-key evil-normal-state-map (kbd "TAB") 'evil-undefine)
  
    ;; Use visual line motions even outside of visual-line-mode buffers
    (evil-global-set-key 'motion "j" 'evil-next-visual-line)
    (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  
    (evil-set-initial-state 'messages-buffer-mode 'normal)
    (evil-set-initial-state 'dashboard-mode 'normal))
#+end_src
(Not Working) Emacs State Cursor Color
#+begin_src emacs-lisp
  (defun +evil-default-cursor-fn (interactive)
    (evil-set-cursor-color (get 'cursor 'evil-normal-color)))
  (defun +evil-emacs-cursor-fn () (interactive)
    (evil-set-cursor-color (get 'cursor 'evil-emacs-color)))
#+end_src

*** Evil Collection
#+begin_src emacs-lisp
  (use-package evil-collection
    :after evil
    :custom
     (evil-collection-outline-bind-tab-p  t)
    :config
    (evil-collection-init))
#+end_src

*** Evil Escape
#+begin_src emacs-lisp
  (use-package key-chord
  :config
  (key-chord-define evil-insert-state-map "jk" 'evil-normal-state) 
  (key-chord-define evil-replace-state-map "jk" 'evil-normal-state) 
  :init
  (key-chord-mode 1))
  
    ;; (use-package evil-escape
    ;;   :after evil
    ;;   :init
    ;;   (setq  'evil-escape-excluded-major-modes '(magit-status-mode))
    ;;   (evil-escape-mode)
    ;;   :config
    ;;   (setq evil-escape-key-sequence "jk")
    ;;   (setq evil-escape-delay 0.2)
    ;;   (setq evil-escape-unordered-key-sequence t))
  ;; (defun my-jk ()
  ;;   (interactive)
  ;;   (let* ((initial-key ?j)
  ;;          (final-key ?k)
  ;;          (timeout 0.5)
  ;;          (event (read-event nil nil timeout)))
  ;;     (if event
  ;;         ;; timeout met
  ;;         (if (and (characterp event) (= event final-key))
  ;;             (evil-normal-state)
  ;;           (insert initial-key)
  ;;           (push event unread-command-events))
  ;;       ;; timeout exceeded
  ;;       (insert initial-key))))
  
  ;; (define-key evil-insert-state-map (kbd "j") 'my-jk)
  
#+end_src

*** Evil args
[[https://github.com/wcsmith/evil-args][wcsmith/evil-args: Motions and text objects for delimited arguments in Evil.]]
#+begin_src emacs-lisp
  (use-package evil-args
    :config
    ;; bind evil-args text objects
    (define-key evil-inner-text-objects-map "a" 'evil-inner-arg)
    (define-key evil-outer-text-objects-map "a" 'evil-outer-arg)
  
    ;; bind evil-forward/backward-args
    (define-key evil-normal-state-map "L" 'evil-forward-arg)
    (define-key evil-normal-state-map "H" 'evil-backward-arg)
    (define-key evil-motion-state-map "L" 'evil-forward-arg)
    (define-key evil-motion-state-map "H" 'evil-backward-arg)
  
    ;; bind evil-jump-out-args
    ;; (define-key evil-normal-state-map "K" 'evil-jump-out-args))
  )
#+end_src

*** Evil Easy Motion
[[https://github.com/PythonNut/evil-easymotion][PythonNut/evil-easymotion: A port of vim easymotion to Emacs' evil-mode]]
#+begin_src emacs-lisp
  (use-package evil-easymotion
    :config
    (evilem-default-keybindings "SPC"))
  
#+end_src

*** evil-org
#+begin_src emacs-lisp
  (use-package evil-org
  :hook (org-mode . evil-org-mode))
#+end_src

*** Evil snipe
[[https://github.com/hlissner/evil-snipe][hlissner/evil-snipe: 2-char searching ala vim-sneak & vim-seek, for evil-mode]]
#+begin_src emacs-lisp
  (use-package evil-snipe
  :config
  (setq evil-snipe-repeat-scope 'whole-visible)
  (evil-snipe-mode +1))
#+end_src

*** Evil numbers
#+begin_src emacs-lisp
  (use-package evil-numbers
  :config
    (evil-define-key '(normal visual) 'global (kbd "C-c +") 'evil-numbers/inc-at-pt)
    (evil-define-key '(normal visual) 'global (kbd "C-c -") 'evil-numbers/dec-at-pt)
    (evil-define-key '(normal visual) 'global (kbd "C-c C-+") 'evil-numbers/inc-at-pt-incremental)
    (evil-define-key '(normal visual) 'global (kbd "C-c C--") 'evil-numbers/dec-at-pt-incremental)
  )
#+end_src

* Completions
** ivy
Better Completions
#+begin_src emacs-lisp
  (use-package ivy
    :defer t
    :diminish
    :bind (("C-s" . swiper); TODO: move to Keybinds
           :map ivy-minibuffer-map
           ("TAB" . ivy-alt-done)
           ("C-l" . ivy-alt-done)
           ("C-j" . ivy-next-line)
           ("C-k" . ivy-previous-line)
           :map ivy-switch-buffer-map
           ("C-k" . ivy-previous-line)
           ("C-l" . ivy-done)
           ("C-d" . ivy-switch-buffer-kill)
           :map ivy-reverse-i-search-map
           ("C-k" . ivy-previous-line)
           ("C-d" . ivy-reverse-i-search-kill))
    :config
    (ivy-mode 1))
#+end_src
Ivy Rich for having =M-x= description and keybinds
#+begin_src emacs-lisp
  (use-package ivy-rich
    :after counsel
    :init (ivy-rich-mode 1))
#+end_src
Ivy floating
#+begin_src emacs-lisp :tangle no
  (use-package ivy-posframe
    :after ivy
    :diminish
    :custom-face
    (ivy-posframe-border ((t (:background "#ffffff"))))
    :config
    (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-top-center))
          ivy-posframe-height-alist '((t . 20))
          ivy-posframe-parameters '((internal-border-width . 10)))
    (setq ivy-posframe-width 120)
    (setq ivy-posframe-parameters
        '((left-fringe . 8)
            (right-fringe . 8)))
  
    (ivy-posframe-mode +1))
  
#+end_src

** Counsel
#+begin_src emacs-lisp
  (use-package counsel
    :defer t
    :bind (("M-x" . counsel-M-x)
           ;("C-x b" . counsel-ibuffer)
           ("C-x C-f" . counsel-find-file)
           :map minibuffer-local-map
           ("C-r" . 'counsel-minibuffer-history)
           ("C-w" . 'evil-delete-backward-word))
    :config (setq ivy-initial-inputs-alist nil)) ;; Don't start searches with '^'
#+end_src

** Which Key (Shows Next keys)
slow loading! defer it
#+begin_src emacs-lisp
(use-package which-key
  :defer 10
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 1
   which-key-max-display-columns 5))
#+end_src

** Company Mode
#+begin_src emacs-lisp
    (use-package company
      :ensure
      :defer 5
      :diminish company-mode
      :custom
      (global-company-mode t)
      (company-idle-delay 0.3) ;; how long to wait until popup
      (company-minimum-prefix-length 1) ;; The minimum prefix length for idle completion.
      (company-selection-wrap-around t)
      ;; (company-begin-commands nil) ;; uncomment to disable popup
      :bind
      (:map company-active-map
            ("C-n". company-select-next)
            ("C-w". evil-delete-backward-word)
            ("<tab>" . company-complete-common-or-cycle)
            ("RET" . company-complete-selection)
            ("C-p". company-select-previous)
            ("M-<". company-select-first)
            ("M->". company-select-last)))


  ;; (use-package company-lsp)
  (use-package company-box
    :after company
    :hook (company-mode . company-box-mode))
#+end_src

*** lsp + yasnippet
#+begin_src emacs-lisp
(defun my-backends ()
    (set (make-local-variable 'company-backends)
        '((company-capf ;; I think this must come first?
            :with
            company-yasnippet
            company-files
            company-dabbrev-code))))
#+end_src

** Prescient
better sorting for ivy, company..
#+begin_src emacs-lisp
  (use-package prescient
    :defer t
    :diminish
    :config (prescient-persist-mode 1))

  (use-package ivy-prescient
    :after counsel
    :init (ivy-prescient-mode 1))

  (use-package company-prescient
    :after company
    :config
     (company-prescient-mode 1)
     (prescient-persist-mode)
   )
  ;; (use-package selectrum-prescient)
#+end_src

** Yasnippet
#+begin_src emacs-lisp
  (use-package yasnippet
    :defer 9
    :config
    (yas-global-mode))

  (use-package yasnippet-snippets
    :after yasnippet)

#+end_src

** Helm
#+begin_src emacs-lisp
  (use-package helm
      :defer t
      :config (helm-autoresize-mode 1))
#+end_src

* Org-Mode
** Set directories
#+begin_src emacs-lisp
  (setq org-directory "~/Documents/gtd/"
    org-roam-directory "~/Documents/roam/"
    org-agenda-files (list org-directory)
    org-my-anki-file (concat org-roam-directory "anki.org")
    org-refile-targets '((org-agenda-files . (:level . 1)))
  )
#+end_src

** use-package 
Modes To Start
#+begin_src emacs-lisp
  (defun my/org-mode/org-mode-setup ()
  (interactive)
    (flyspell-mode 1)
    (org-indent-mode)
    (variable-pitch-mode 0)
    (visual-line-mode 1))
#+end_src
use-package
#+begin_src emacs-lisp
    (use-package org
      :defer t
      :hook (org-mode . my/org-mode/org-mode-setup)
      (org-mode . my/org-mode/load-prettify-symbols); symbols
      (org-mode . auto-fill-mode)
      :config
      (require 'org-tempo)
      (require 'org-habit)
      (setq geiser-default-implementation  'guile)
      (setq org-ellipsis " ⤵")
      (setq org-agenda-start-with-log-mode t)
      (setq org-highlight-latex-and-related '(latex))
      (setq org-log-done 'time)
      (setq org-log-into-drawer t)
      (dolist (face '((org-document-title . 2.0)
                      (org-level-1 . 1.2)
                      (org-level-2 . 1.1)
                      (org-level-3 . 1.05)
                      (org-level-4 . 1.0)
                      (org-level-5 . 1.1)
                      (org-level-6 . 1.1)
                      (org-level-7 . 1.1)
                      (org-level-8 . 1.1)))
        ;; (set-face-attribute (car face) nil :font my/ui/varfont :weight 'regular :height (cdr face)))
        (set-face-attribute (car face) nil :font my/ui/varfont :weight 'regular :height (cdr face)))
    ;)


    (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))
      ;; Ensure that anything that should be fixed-pitch in Org files appears that way
      (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
      (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
      (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
      (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
      (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
      (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
      (set-face-attribute 'org-todo nil :background "#444527" )
      (set-face-attribute 'org-done nil :strike-through t)
      (set-face-attribute 'org-headline-done nil :strike-through t)
      (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))
#+end_src

Capture Templates
#+begin_src emacs-lisp
(use-package doct
  :ensure t
  ;;recommended: defer until calling doct
  :commands (doct))
#+end_src

** Appearance
*** Symbols
#+begin_src emacs-lisp
  (defun my/org-mode/load-prettify-symbols ()
    (interactive)
    (setq prettify-symbols-alist
          (mapcan (lambda (x) (list x (cons (upcase (car x)) (cdr x))))
                  '(("#+begin_src" . ?)
                    ("#+end_src" . ?)
                    ("#+begin_example" . ?)
                    ("#+end_example" . ?)
                    ("#+header:" . ?)
                    ("#+name:" . ?﮸)
                    ("#+title:" . "")
                    ("#+results:" . ?)
                    ("#+call:" . ?)
                    (":properties:" . ?)
                    (":logbook:" . ?))))
    (prettify-symbols-mode 1))
#+end_src

*** COMMENT Visual Fill (center)
I know use olivetti mode, this code block is ignored!
#+begin_src emacs-lisp :tangle no
  (defun my/org-mode/org-mode-visual-fill ()
  (interactive)
    (setq visual-fill-column-width 110
          visual-fill-column-center-text t
          fill-column 90)
    (visual-fill-column-mode 1))
#+end_src
#+begin_src emacs-lisp :tangle no
  (use-package visual-fill-column; center text
    :hook (org-mode . my/org-mode/org-mode-visual-fill))
#+end_src

*** org-bullets
#+begin_src emacs-lisp
(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))
#+end_src

*** Latex
scale inline
#+begin_src emacs-lisp
;  moved to use -package
; (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))
#+end_src

** Babel
Don't confirm, I know what I am doing!
#+begin_src emacs-lisp
  (setq org-confirm-babel-evaluate nil)
#+end_src

*** Language List
#+begin_src emacs-lisp
  (org-babel-do-load-languages
      'org-babel-load-languages
      '((emacs-lisp . t)
      ;(restclient . t)
      ;(mermaid . t)
      (shell . t)))
#+end_src

*** Structure Templates
Allow fast code insertion
#+begin_src emacs-lisp
  ;; This is needed as of Org 9.2

  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
#+end_src

#+RESULTS:

** Capture 
*** Templates
#+begin_src emacs-lisp
  (setq org-capture-templates
   (doct `(("Consume: Read/watch" :keys "c"
            :file ,(concat org-directory "inbox.org")
            :prepend t
            :template ("* %{todo-state} %^{Description}"
                       ":PROPERTIES:"
                       ":Created: %U"
                       ":END:"
                       "%?")
            :children (("Read"   :keys "r"
                        :headline "Read"
                        :todo-state "TODO")
                       ("Watch" :keys "w"
                          :headline "Watch"
                          :todo-state "TODO")))
           ("Ideas" :keys "i"
            :file ,(concat org-directory "inbox.org")
            :prepend t
            :template ("* %{todo-state} %^{Description}"
                       ":PROPERTIES:"
                       ":Created: %U"
                       ":END:"
                       "%?")
            :children (("Project"   :keys "p"
                        :olp ("Ideas" "Project")
                        :todo-state "")
                       ("Blogs"   :keys "b"
                        :olp ("Ideas" "Blog")
                        :todo-state "")
                       ("placeholder" :keys "w"
                          :headline "Watch"
                          :todo-state "TODO")))
           ("GTD" :keys "g"
            :file ,(concat org-directory "inbox.org")
            :prepend t
            :template ("* %{todo-state} %^{Description}"
                       ":PROPERTIES:"
                       ":Created: %U"
                       ":END:"
                       "%?")
            :children (("Inbox"   :keys "i"
                        :headline "Inbox"
                        :todo-state "")
                       ("placeholder" :keys "w"
                          :headline "Watch"
                          :todo-state "TODO"))))))
#+end_src

*** Utils
launch with =emacsclient -e '(make-orgcapture-frame)'=
From: https://yiufung.net/post/anki-org/
#+begin_src emacs-lisp
  (defun make-orgcapture-frame ()
      "Create a new frame and run org-capture."
      (interactive)
      ;(make-frame '((name . "org-capture") (window-system . x))); window-system breaks for some reason :(
      (make-frame '((name . "org-capture")))
      (select-frame-by-name "org-capture")
      (counsel-org-capture)
      (delete-other-windows)) 
#+end_src

** Agenda
*** T/ODOs
#+begin_src emacs-lisp
   (setq org-todo-keywords '((sequence "TODAY(y)" "TODO(t)" "NOW(o)" "NEXT(n)" "|" "DONE(d)")
                            (sequence "|" "CANCELED(c)")))
#+end_src

*** start on sunday!
#+begin_src emacs-lisp
  (setq org-agenda-start-on-weekday 0 ;0 is sunday
        org-agenda-weekend-days '(5 6))
#+end_src

*** Go EVIL!
#+BEGIN_SRC emacs-lisp
  (eval-after-load 'org-agenda
   '(progn
      (evil-set-initial-state 'org-agenda-mode 'normal)
      (evil-define-key 'normal org-agenda-mode-map
        (kbd "<RET>") 'org-agenda-goto
        ;;;; (kbd "\t") 'org-agenda-goto

        "q" 'org-agenda-quit
        "S" 'org-save-all-org-buffers

        ;;;; Clocking
        "c" nil
        "ci" 'org-agenda-clock-in
        "co" 'org-agenda-clock-out
        "cx" 'org-agenda-clock-cancel
        "cR" 'org-agenda-clockreport-mode

        ;;;; Properties
        "s" 'org-agenda-schedule
        "d" 'org-agenda-deadline
        "p" 'org-agenda-priority
        "t" 'org-agenda-todo
        "T" 'counsel-org-tag
        ":" 'org-agenda-set-tags
        "e" 'org-agenda-set-effort

        ;;;; Movement
        "j"  'org-agenda-next-line
        "k"  'org-agenda-previous-line
        "f" 'org-agenda-later
        "b" 'org-agenda-earlier
        "J" 'org-agenda-next-date-line
        "K" 'org-agenda-previous-date-line
        "." 'org-agenda-goto-today

        ;;;; View toggles
        "vt" 'org-agenda-toggle-time-grid
        "vw" 'org-agenda-week-view
        "vd" 'org-agenda-day-view
        "vl" 'org-agenda-log-mode
        "vr" 'org-agenda-redo
        "r" 'org-agenda-redo;; often used
        "F" 'org-agenda-follow-mode

        ;;;; Other
        "C" 'org-capture
        "R" 'my/org-agenda/process-inbox-item
        "A" 'org-agenda-archive
        "g/" 'org-agenda-filter-by-tag
        "gr" 'org-ql-view-refresh
        "gh" 'helm-org-ql-views
        ;;;; cool but inactive
        ;; "gj" 'org-agenda-goto-date
        ;; "gJ" 'org-agenda-clock-goto
        ;; "gm" 'org-agenda-bulk-mark
        ;; "go" 'org-agenda-open-link
        ;; "+" 'org-agenda-priority-up
        ;; "-" 'org-agenda-priority-down
        ;; "y" 'org-agenda-todo-yesterday
        ;; "n" 'org-agenda-add-note
        ;; ";" 'org-timer-set-timer
        ;; "I" 'helm-org-task-file-headings
        ;; "i" 'org-agenda-clock-in-avy
        ;; "O" 'org-agenda-clock-out-avy
        ;; "u" 'org-agenda-bulk-unmark
        ;; "x" 'org-agenda-exit
        ;; "va" 'org-agenda-archives-mode
        ;;"vc" 'org-agenda-show-clocking-issues
        ;; "o" 'delete-other-windows
        ;; "gh" 'org-agenda-holiday
        ;; "gv" 'org-agenda-view-mode-dispatch
        "n" nil  ; evil-search-next
        ;; "{" 'org-agenda-manipulate-query-add-re
        ;; "}" 'org-agenda-manipulate-query-subtract-re
        ;; "0" 'evil-digit-argument-or-evil-beginning-of-line
        ;; "<" 'org-agenda-filter-by-category
        ;; ">" 'org-agenda-date-prompt
        ;; "H" 'org-agenda-holidays
        ;; "L" 'org-agenda-recenter
        ;; "Z" 'org-agenda-sunrise-sunset
        ;; "T" 'org-agenda-show-tags
        ;; "X" 'org-agenda-clock-cancel
        ;; "[" 'org-agenda-manipulate-query-add
        ;; "g\\" 'org-agenda-filter-by-tag-refine
        ;; "]" 'org-agenda-manipulate-query-subtract
  )))
  ;; TODO check this
#+END_SRC

*** habits
#+begin_src emacs-lisp
  (setq org-habit-graph-column 80   ; prevent overwriting title
        org-habit-show-all-today t) ; show even if DONE
#+end_src

*** org SUPER agenda
#+begin_src emacs-lisp
  (use-package org-super-agenda
   :after org-agenda
   :config
   (setq org-agenda-span 'day); a week is too much
   (setq org-super-agenda-groups
         '((:log t :order 99); logs at bottom
           (:name "Today" ; today is what
                   :time-grid t    ; Items that appear on the time grid
                   :todo "TODAY"
                   :scheduled today)
           (:name "Overdue"
                   :deadline past
                   :scheduled past)
           (:name "Deadlines"
                   :deadline t)
           (:name "To Refile"
                   :tag ("INBOX"))))
  
   (org-super-agenda-mode 1)

  :hook (org-agenda-mode . origami-mode)
        ;(org-agenda-mode . org-super-agenda-mode); need this sadly
        (org-agenda-mode . olivetti-mode)
        (org-agenda-mode . olivetti-mode)
  ;(evil-define-key '(normal visual) 'org-super-agenda-header-map "j" 'org-agenda-next-line)
  ;; evil doesn't work on headers, bruh
   :bind (:map org-super-agenda-header-map
           ([tab] . origami-toggle-node)
           ("j" . org-agenda-next-line)
           ("k" . org-agenda-previous-line)
           ("h" . evil-backward-char)
           ("l" . evil-forward-char)))
#+end_src

*** org-ql
#+begin_src emacs-lisp
(use-package helm-org-ql :after org-ql)
#+end_src

#+begin_src emacs-lisp
  ; TODO: tasks not in inbox, and have no schedule/effort/etc
  (use-package org-ql
   :config
     (setq org-ql-views (list (cons "Overview: Agenda-like"
                               (list :buffers-files #'org-agenda-files
                                     :query '(and (not (done))
                                                  (or (deadline auto)
                                                      (scheduled :to today)
                                                      (ts-active :on today)
                                                      (todo "TODAY")))
                                     :sort '(priority date todo)
                                     :super-groups 'org-super-agenda-groups
                                     :title "Agenda-like"))
                         (cons "To Refile"
                               (list :buffers-files #'org-agenda-files
                                     :query '(parent (tags "INBOX"))
                                     :super-groups 'org-super-agenda-groups
                                     :title "Inbox"))
                         (cons "Goals"
                               (list :buffers-files #'org-agenda-files
                                     :query '(todo "LNOW" "LNEXT")
                                     :super-groups '((:todo "LNOW")
                                                     (:todo "LNEXT"))
                                     :sort '(todo)
                                     :title "Goals"))  
                         (cons "Consoom and Create"
                               (list :buffers-files #'org-agenda-files
                                     :query '(parent (tags "READ" "WATCH" "TO_BLOG"))
                                     :super-groups '((:tag "READ")
                                                     (:tag "WATCH")
                                                     (:tag "TO_BLOG"))
                                     :sort '(todo)
                                     :title "Goals"))  
                         (cons "Quick Picks"
                               (list :buffers-files #'org-agenda-files
                                     :query '(and (not (done))
                                                  (effort <= 10))
                                     :sort '(todo)
                                     :super-groups 'org-super-agenda-groups
                                     :title "Quick Picks")))))


#+end_src

*** Helper functions
Stolen from: [[https://blog.jethro.dev/posts/processing_inbox/][Org-mode Workflow Part 2: Processing the Inbox · Jethro Kuan]]
#+begin_src emacs-lisp
  (defun my/org-agenda/process-inbox-item ()
    "Process a single item in the org-agenda."
    (interactive)
    (org-with-wide-buffer
     (org-agenda-set-tags)
     ;(org-agenda-priority)
     (org-agenda-set-effort)
     (org-agenda-refile nil nil t)))

#+end_src


** org-pomodoro
#+begin_src emacs-lisp
  (use-package org-pomodoro
  :defer t
  :custom
  (org-pomodoro-length 25)
  (org-pomodoro-keep-killed-pomodoro-time t)
  (org-pomodoro-manual-break t))
#+end_src

** org-roam
*** use-package
#+begin_src emacs-lisp
  (use-package org-roam
    :defer t
    :custom
    (org-roam-completion-everywhere t)
    (org-roam-db-gc-threshold most-positive-fixnum) ;; preformance
    (org-roam-capture-ref-templates
    '(("r" "ref" plain "%?" :if-new
        (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}")
      :unnarrowed t)))
    :config
    ;; side window
    ;(require 'org-roam-protocol)
    (add-to-list 'display-buffer-alist
                 '("\\*org-roam\\*"
                   (display-buffer-in-side-window)
                   (side . right)
                   (slot . 0)
                   (window-width . 0.33)
                   (window-parameters . ((no-other-window . t)
                                         (no-delete-other-windows . t))))))
#+end_src

*** org roam server
#+begin_src emacs-lisp
  (use-package websocket
      :after org-roam)
  
  (use-package simple-httpd
      :after org-roam)
  
  (use-package org-roam-ui
      :straight (org-roam-ui
                 :type git
                 :host github
                 :repo "org-roam/org-roam-ui"
                 :files ("*.el" "out"))
      :after org-roam ;; or :after org
      :hook (org-roam . org-roam-ui-mode)
      :config)
  
#+end_src

*** Deft
#+begin_src emacs-lisp
  (use-package deft
    :after org
    :bind
    :custom
    (deft-strip-summary-regexp "\\`\\(.+\n\\)+\n")
    (deft-recursive t)
    (deft-use-filter-string-for-filename t)
    (deft-default-extension "org")
    (deft-directory org-roam-directory))
    (setq deft-recursive t)
  (setq deft-strip-summary-regexp ":PROPERTIES:\n\\(.+\n\\)+:END:\n")
  (setq deft-use-filename-as-title 't)

  
#+end_src

** org-download and clip-link
#+begin_src emacs-lisp
    (use-package org-download
        :after org)
    (use-package org-cliplink
        :after org)
#+end_src

** org-book
#+begin_src emacs-lisp
  (use-package org-books
   :after org
   :config 
  (setq org-books-file "~/Documents/books/list.org"))
#+end_src

**  COMMENT Anki
Stopped using this, I just use Anki like a normal person
#+begin_src emacs-lisp
  (use-package anki-editor
    :after org
    :bind (:map org-mode-map
                ("<f12>" . anki-editor-cloze-region-auto-incr))
    :init
    (setq-default anki-editor-use-math-jax t)

    :config
  
     (setq anki-editor-create-decks nil ;; Allow anki-editor to create a new deck if it doesn't exist
          anki-editor-org-tags-as-anki-tags t)
  
  )
#+end_src

* Development
** General
*** Brackets setup

#+begin_src emacs-lisp
  (use-package rainbow-delimiters
    :hook (prog-mode . rainbow-delimiters-mode)
          (prog-mode . show-paren-mode)
          (prog-mode . electric-pair-mode)
     ) 
#+end_src

#+begin_src emacs-lisp
  ;; (use-package paredit :defer t)
#+end_src

#+begin_src emacs-lisp
  (use-package parinfer-rust-mode
      :hook emacs-lisp-mode scheme-mode clojure-mode
      :init
      (setq parinfer-rust-auto-download t))
#+end_src

*** Projectile
#+begin_src emacs-lisp
  (use-package projectile
    :defer t
    :diminish projectile-mode
    :config (projectile-mode)
    :custom ((projectile-completion-system 'ivy))
    :init
    ;; NOTE: Set this to the folder where you keep your Git repos!
    (when (file-directory-p "~/Projects/Code")
      (setq projectile-project-search-path '("~/Projects/Code")))
    (setq projectile-switch-project-action #'projectile-dired))
#+end_src
Counsel Projectile
#+begin_src emacs-lisp 
  (use-package counsel-projectile
    :defer 9
    :config (counsel-projectile-mode))
#+end_src

*** Recentf
#+begin_src emacs-lisp
  (use-package recentf
    :defer 10
    :config (recentf-mode  1))
#+end_src

*** lsp performance
#+begin_src emacs-lisp :tangle no
  (setq gc-cons-threshold 100000000)           ;; 100 mb
  (setq read-process-output-max (* 1024 4024)) ;; 4mb
#+end_src

*** lsp-mode
#+begin_src emacs-lisp
  (use-package lsp-mode
    :commands (lsp lsp-deferred)
   ;;  :hook
   ;; (lsp-mode . my/lsp/lsp-mode-setup)
    :custom
    (lsp-headerline-breadcrumb-segments '(path-up-to-project file))
    (lsp-rust-analyzer-cargo-watch-command "clippy")
    (lsp-eldoc-render-all t)
    (lsp-eldoc-enable-hover nil)
    (lsp-ui-doc-show-with-mouse nil)
    (lsp-idle-delay 0.6)
    (lsp-completion-provider :none) 
    (lsp-idle-delay 0.6)
    (lsp-rust-analyzer-server-display-inlay-hints t)
    (lsp-rust-analyzer-display-parameter-hints t)
    ;(setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
    :config
    (lsp-enable-which-key-integration t)
    (setq lsp-headerline-breadcrumb-enable nil); anonying tabs
    (lsp-log-io nil) ; if set to true can cause a performance hit
    (add-hook 'lsp-mode-hook 'lsp-ui-mode)
    (lsp-headerline-breadcrumb-mode -1)
    (flycheck-mode 1)
    :bind
      (:map lsp-mode-map
            ;; ("<tab>" . company-indent-or-complete-common); commented cuz tabs for yasnippet!
      )
  ) 
#+end_src

Lsp UI
#+begin_src emacs-lisp
  (use-package lsp-ui
      :ensure
      :commands lsp-ui-mode
      :custom
      (lsp-ui-peek-always-show t)
      (lsp-ui-doc-mode t)
      (lsp-ui-sideline-show-hover nil)
      ;; (lsp-ui-doc-enable nil)
      :bind
          (:map lsp-ui-mode-map
          ("C-c z" . lsp-ui-doc-focus-frame)
      :map lsp-ui-doc-frame-mode-map
          ("C-g" . lsp-ui-doc-unfocus-frame)
          ("C-c z" . lsp-ui-doc-unfocus-frame)
    ))
#+end_src

*** lsp treemacs
#+begin_src emacs-lisp
  ;; (use-package lsp-treemacs
  ;;   :after lsp)
#+end_src

*** Flycheck
#+begin_src emacs-lisp
(use-package flycheck
:custom-face (flycheck-warning ((t (:underline (:color "#fabd2f" :style line :position line)))))
             (flycheck-error ((t (:underline (:color "#fb4934" :style line :position line)))))
             (flycheck-info ((t (:underline (:color "#83a598" :style line :position line))))))
#+end_src

*** Origami Mode (Folding)
#+begin_src emacs-lisp
    (use-package origami
    :hook (prog-mode . origami-mode))
#+end_src

** Git
*** Magit
#+begin_src emacs-lisp
    (use-package magit
      :commands (magit)
      :custom
      (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))
#+end_src

*** TODO Forge
#+begin_src emacs-lisp
  ;(use-package forge)
#+end_src

*** Git gutter
#+begin_src emacs-lisp
  (use-package git-gutter
    :hook (prog-mode . git-gutter-mode)
    :config
    (setq git-gutter:update-interval 0.02))
  
  (use-package git-gutter-fringe
      :config
      (define-fringe-bitmap 'git-gutter-fr:added [224] nil nil '(center repeated))
      (define-fringe-bitmap 'git-gutter-fr:modified [224] nil nil '(center repeated))
      (define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240] nil nil 'bottom)
      :ensure t)


#+end_src

** Treemacs
use-package
#+begin_src emacs-lisp
  (use-package treemacs
    :commands (treemacs)
    :init
    (setq treemacs-follow-after-init t
          treemacs-is-never-other-window t
          treemacs-sorting 'alphabetic-case-insensitive-asc))
#+end_src
fix evil keybinds
#+begin_src emacs-lisp
  (use-package treemacs-evil
   ;:when (package-installed-p 'evil-collection)
   ;:defer t
    :after treemacs
    :init
    :config
  (general-def evil-treemacs-state-map
    [return] #'treemacs-RET-action
    [tab]    #'treemacs-TAB-action
    "TAB"    #'treemacs-TAB-action
    "o v"    #'treemacs-visit-node-horizontal-split
    "o s"    #'treemacs-visit-node-vertical-split))

#+end_src

Get treemacs-lsp
#+begin_src emacs-lisp
  (use-package lsp-treemacs
      :after (treemacs lsp))
  (use-package treemacs-magit
      :after treemacs magit)
  (use-package treemacs-persp
      :after treemacs
      :config (treemacs-set-scope-type 'Perspectives))
#+end_src

** Language
*** COMMENT Arduino
#+begin_src emacs-lisp
  (use-package arduino-mode
     :defer t)
#+end_src

*** COMMENT Clojure
#+begin_src emacs-lisp
  (use-package cider
  :defer t
  :config (require 'flycheck-clj-kondo)
  :hook   (clojure-mode . zprint-format-on-save-mode)
          (clojure-mode . flycheck-mode)
  :bind   (:map cider-mode-map
          ([remap lsp-find-definition] . cider-find-var)
          ([remap eval-defun] . cider-eval-list-at-point)
          ([remap eval-last-sexp] . cider-eval-last-sexp)))
#+end_src

Auto format
#+begin_src emacs-lisp
  (use-package zprint-format
  :after cider)
#+end_src

#+begin_src emacs-lisp
  (use-package flycheck-clj-kondo
   :after cider)
#+end_src

*** Rust
#+begin_src emacs-lisp
  (use-package rustic
    :defer t
    :ensure
    :bind (:map rustic-mode-map
                ("C-c C-c l" . lsp-ui-flycheck-list)
                ("C-c C-c s" . lsp-rust-analyzer-status)
                ("<f5>" . rustic-cargo-test)
                ("C-<f5>" . rustic-cargo-run))
    :config
    ;; uncomment for less flashiness
    ;; (setq lsp-eldoc-hook nil)
    ;; (setq lsp-enable-symbol-highlighting nil)
    ;; (setq lsp-signature-auto-activate nil)

    ;; comment to disable rustfmt on save
    (setq rustic-format-on-save t)
    (add-hook 'rustic-mode-hook 'my/dev/rustic-mode-hook)
    ;; (add-hook 'rustic-mode-hook 'electric-pair-mode)
    ;; (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
    ;; (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
    (add-hook 'rustic-mode-hook 'lsp)
    :custom
    (rustic-rustfmt-config-alist '((edition . "2021"))))

  (defun my/dev/rustic-mode-hook ()
    ;; so that run C-c C-c C-r works without having to confirm, but don't try to
    ;; save rust buffers that are not file visiting. Once
    ;; https://github.com/brotzeit/rustic/issues/253 has been resolved this should
    ;; no longer be necessary.
    (when buffer-file-name
      (setq-local buffer-save-without-query t)))
#+end_src

*** emacs-lisp
#+begin_src emacs-lisp
  ;; (add-hook 'emacs-lisp-mode-hook 'company-mode)
  (add-hook 'emacs-lisp-mode-hook 'flycheck-mode)
#+end_src

*** COMMENT V
#+begin_src emacs-lisp
  (use-package v-mode
    :defer t
    :preface
  (defun my/lsp/v ()
    (interactive)
    (lsp)
    (flycheck-mode 1)
    (company-mode 1))
  :init
    (delete '("\\.[ds]?va?h?\\'" . verilog-mode) auto-mode-alist)
    ;; :straight (v-mode
    ;;            :type git
    ;;            :host github
    ;;            :repo "damon-kwok/v-mode"
    ;;            :files ("tokens" "v-mode.el"))
        (setq auto-mode-alist
            (cons '("\\(\\.v\\|\\.vv\\|\\.vsh\\)$" . v-mode) auto-mode-alist))
    :hook (v-mode . my/lsp/v)
    :config
    (flycheck-define-checker v-checker
        "A v syntax checker using the v fmt."
        :command ("v" "fmt" "-verify" (eval (buffer-file-name)))
        :error-patterns
        ((error line-start (file-name) ":" line ":" column ": error: " (message) line-end))
        :modes v-mode)
    (add-to-list 'flycheck-checkers 'v-checker)
    :bind-keymap
    ("M-z" . v-menu)
    ("<f6>" . v-menu)
    ("C-c C-f" . v-format-buffer)
    :mode ("\\.v\\.vsh\\'" . 'v-mode))
  
#+end_src

*** Haskell
#+begin_src emacs-lisp
  (use-package haskell-mode :defer t)
#+end_src

#+begin_src emacs-lisp
  (use-package lsp-haskell
    :defer t
    :preface
  ;; lambda symbol
    (defun my/font/pretty-lambdas-haskell ()
      (font-lock-add-keywords
       nil `((,(concat "\\(" (regexp-quote "\\") "\\)")
              (0 (progn (compose-region (match-beginning 1) (match-end 1)
                                        ,(make-char 'greek-iso8859-7 107))
                        nil))))))
    :hook (haskell-mode . lsp)
    (haskell-mode . my/font/pretty-lambdas-haskell)
    :config
    (haskell-indentation-mode -1)
    (add-hook 'before-save-hook 'lsp-format-buffer)
    :custom (haskell-stylish-on-save t)
    )
#+end_src

*** yaml
#+begin_src emacs-lisp
  (use-package yaml-mode
    :hook (yaml-mode . lsp))
#+end_src

*** Web
#+begin_src emacs-lisp
  (use-package tide
    :defer t
    :preface
    (defun setup-tide-mode ()
      (interactive)
      (tide-setup)
      (flycheck-mode +1)
      (setq flycheck-check-syntax-automatically '(save mode-enabled))
      (eldoc-mode +1)
      (tide-hl-identifier-mode +1)
      ;; company is an optional dependency. You have to
      ;; install it separately via package-install
      ;; `M-x package-install [ret] company`
      (company-mode +1))
    :config

    ;; aligns annotation to the right hand side
    (setq company-tooltip-align-annotations t)

    ;; formats the buffer before saving
    ;; (add-hook 'before-save-hook 'tide-format-before-save)
    (add-hook 'before-save-hook 'prettier-js)
  :hook(typescript-mode . setup-tide-mode)
  :hook(typescript-mode . lsp))
#+end_src

svelte
#+begin_src emacs-lisp
  (use-package svelte-mode
        :config
        (add-hook 'before-save-hook 'lsp-format-buffer)
      :hook (svelte-mode . lsp))
#+end_src

prettier
#+begin_src emacs-lisp
    (use-package prettier
    :defer t
  )
#+end_src

lsp hooks setups
#+begin_src emacs-lisp
  (add-hook 'html-mode-hook 'lsp)
  (add-hook 'js-mode-hook 'lsp)
#+end_src

*** Markdown
Better Diff in header sizes
#+begin_src emacs-lisp
  (eval-after-load 'markdown-mode
  '(custom-set-faces
   '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 1.7))))
   '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.4))))
   '(markdown-header-face-3 ((t (:inherit markdown-header-face :height 1.3))))
   '(markdown-header-face-4 ((t (:inherit markdown-header-face :height 1.2))))
   '(markdown-header-face-5 ((t (:inherit markdown-header-face :height 1.1))))
   '(markdown-header-face-6 ((t (:inherit markdown-header-face :height 1.0))))
  ))
  ;; (add-hook 'markdown-mode-hook 'my/org-mode/org-mode-visual-fill)
  ;; (add-hook 'markdown-mode-hook 'outline-minor-mode)
#+end_src

*** COMMENT Vue
#+begin_src emacs-lisp
(use-package vue-mode
    :hook (vue-mode . lsp)
    :hook (vue-mode . prettier-js-mode))
#+end_src

*** COMMENT Scheme (guile)
#+begin_src emacs-lisp
  (use-package geiser
    :defer
    ;; :bind ([remap eval-last-sexp] . geiser-eval-last-sexp))
  )

  (use-package geiser-guile)
#+end_src

*** C and cpp
#+begin_src emacs-lisp
  (use-package cc-mode
    :defer t
    :hook (cc-mode . lsp)
    :hook (c-mode . lsp)
          (c-mode . (lambda ()
              (add-hook 'before-save-hook 'lsp-format-buffer nil t)))
    :hook (c++-mode . lsp))
#+end_src

*** COMMENT Ruby
#+begin_src emacs-lisp
  (use-package ruby-mode
    :hook
    (ruby-mode . lsp)
    (ruby-mode . electric-pair-mode)
    (ruby-mode . (lambda ()
           (add-hook 'before-save-hook 'lsp-format-buffer nil t))))
#+end_src

*** COMMENT python
#+begin_src emacs-lisp
    (add-hook 'python-mode-hook 'lsp)
    (add-hook 'python-mode-hook 'prettify-symbols-mode)
#+end_src

*** LaTeX
AucTex
#+begin_src emacs-lisp
  ;; latexmk
  (use-package auctex-latexmk
  :defer t)
  ;; company
  (use-package company-math
      :after company)
  (use-package company-auctex
      :after company)
  (use-package company-reftex
      :after company)


  ;;  use cdlatex
  (use-package cdlatex
  :defer t)

  ;; https://gist.github.com/saevarb/367d3266b3f302ecc896
  ;; https://piotr.is/2010/emacs-as-the-ultimate-latex-editor/

  (use-package latex
    :straight auctex
    :defer t
    :custom
    (olivetti-body-width 120)
    (cdlatex-simplify-sub-super-scripts nil)
    (reftex-default-bibliography
     '("~/Documents/refs.bib"))
    (bibtex-dialect 'biblatex)
    :mode
    ("\\.tex\\'" . latex-mode)
  ;; also see evil-define-key in :config
    :bind (:map LaTeX-mode-map
                ("TAB" . cdlatex-tab)
                ("'" . cdlatex-math-modify)
                ("C-c C-e" . cdlatex-environment))

    :hook
    (LaTeX-mode . flyspell-mode)
    (LaTeX-mode . flycheck-mode)
    (LaTeX-mode . turn-on-reftex)
    (LaTeX-mode . TeX-source-correlate-mode)
    (LaTeX-mode . try/latex-mode-setup)
    (LaTeX-mode . turn-on-cdlatex)
    (LaTeX-mode . origami-mode)
        ;; (LaTeX-mode . TeX-fold-mode)
    (LaTeX-mode . lsp)
        ;; (LaTeX-mode . olivetti-mode);; already set as a text-mode-hook
        ;; (LaTeX-mode . TeX-PDF-mode) ;; what does it do?
        ;; (LaTeX-mode . company-mode) ;; already enabled globaly
        ;; (LaTeX-mode . xenops-mode)  ;; svgs too lagy :(
        ;; (LaTeX-mode . flycheck-mode);; already enabled with lsp
        ;; (LaTeX-mode . LaTeX-math-mode)
    :config

    ;; pressing "$" while selecting text will cycle between \(\) and \[\] environment
    ;; where does \[\] come from? I have no clue! 
    ;;  I only defined \(\) lol
  (setq TeX-electric-math (quote ("\\(" . "\\)")))
  (evil-define-key 'visual 'LaTeX-mode-map
    "$" 'TeX-insert-dollar
    "'" 'cdlatex-math-modify)

    ;; (setq TeX-auto-save t)
    (setq TeX-parse-self t)
    (setq-default TeX-master nil)
    (setq-default TeX-command-default "LatexMK")
    (setq TeX-save-query nil)

    ;; this is becuase i set $out_dir = '/tmp/tex' in `.latexmkrc`
    ;; and I want to enable forward synctex. don't use it if you don't do like me...
    (setq-default TeX-output-dir "/tmp/tex")

    (setq reftex-plug-into-AUCTeX t)

    ;; ;; pdftools
    ;; ;; https://emacs.stackexchange.com/questions/21755/use-pdfview-as-default-auctex-pdf-viewer#21764
    (setq TeX-view-program-selection '((output-pdf "Zathura"))
          ;; TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view))
          TeX-source-correlate-start-server t) ;; not sure if last line is neccessary
  ;; (add-to-list 'TeX-view-program-selection '(output-pdf "Zathura"))

  ;; clean intermdiate tex crap
  (add-to-list 'LaTeX-clean-intermediate-suffixes '"-figure[0-9]*\\.\\(pdf\\|md5\\|log\\|dpth\\|dep\\|run\\.xml\\)")
  (add-to-list 'LaTeX-clean-intermediate-suffixes '".auxlock")


    ;; to have the buffer refresh after compilation,
    ;; very important so that PDFView refesh itself after comilation
    ;; (add-hook 'TeX-after-compilation-finished-functions
    ;;           #'TeX-revert-document-buffer)

    ;; latexmk
    (require 'auctex-latexmk)
    (auctex-latexmk-setup)
    (setq auctex-latexmk-inherit-TeX-PDF-mode t)

  )
#+end_src

Custom functions
#+begin_src emacs-lisp

(defun try/latex-mode-setup ()
  (require 'company-reftex)
        (turn-on-reftex)
        (require 'company-auctex)
        (require 'company-math)
(setq-local company-backends
      
    (append '((company-reftex-labels company-reftex-citations)
              (company-math-symbols-unicode company-math-symbols-latex company-latex-commands)
              (company-auctex-macros company-auctex-symbols company-auctex-environments)
              company-ispell)
            company-backends)))




#+end_src

Folding
#+begin_src emacs-lisp
  (use-package outshine
    :defer t
    :config
  (setq LaTeX-section-list '(
                             ("part" 0)
                             ("chapter" 1)
                             ("section" 2)
                             ("subsection" 3)
                             ("subsubsection" 4)
                             ("paragraph" 5)
                             ("subparagraph" 6)
                             ("begin" 7)
                             )
        )
  (add-hook 'LaTeX-mode-hook #'(lambda ()
                                 (outshine-mode 1)
                                 (setq outline-level #'LaTeX-outline-level)
                                 (setq outline-regexp (LaTeX-outline-regexp t))
                                 (setq outline-heading-alist
                                       (mapcar (lambda (x)
                                                 (cons (concat "\\" (nth 0 x)) (nth 1 x)))
                                               LaTeX-section-list))))

    )

      (general-define-key
        :states '(normal visual)
        :keymaps 'LaTeX-mode-map
        "TAB"  '(outshine-cycle :which-key "outshine-cycle")
    )

#+end_src

ivy bibtex
#+begin_src emacs-lisp
  (use-package ivy-bibtex
    :defer t
    :custom
    (bibtex-completion-bibliography
          '("~/Documents/refs.bib"))
    (bibtex-completion-library-path '("~/papers"))
    (bibtex-completion-cite-prompt-for-optional-arguments nil)
    (bibtex-completion-cite-default-as-initial-input t)
  )
  
#+end_src

*** Verilog
#+begin_src emacs-lisp
(setq verilog-linter "verilator --lint-only")
#+end_src

* Misc
** Restart Emacs
#+begin_src emacs-lisp
  (use-package restart-emacs)
#+end_src

** Server
#+begin_src emacs-lisp
  (unless (server-running-p) (server-start))
  (add-hook 'server-after-make-frame-hook '(lambda () (set-cursor-color "#FFFFFF")))
#+end_src

** Vterm
#+begin_src emacs-lisp
  (use-package vterm
      :commands vterm
      :custom
       ; claimed to be faster: https://teddit.net/r/emacs/comments/tpey9g/making_vterm_snappy_by_setting_vtermtimerdelay_to/
        (vterm-timer-delay nil)
      :ensure t)
#+end_src

** COMMENT ranger
#+begin_src emacs-lisp
  (use-package ranger
  :defer t
  :config (ranger-override-dired-mode t))
#+end_src

** Ligatures
#+begin_src emacs-lisp
  
  (let ((ligatures `((?-  . ,(regexp-opt '("-|" "-~" "---" "-<<" "-<" "--" "->" "->>" "-->")))
                     (?/  . ,(regexp-opt '("/**" "/*" "///" "/=" "/==" "/>" "//")))
                     ;; (?*  . ,(regexp-opt '("*>" "***" "*/")))
                     (?*  . ,(regexp-opt '("*>" "*/")))
                     (?<  . ,(regexp-opt '("<-" "<<-" "<=>" "<=" "<|" "<||" "<|||::=" "<|>" "<:" "<>" "<-<"
                                           "<<<" "<==" "<<=" "<=<" "<==>" "<-|" "<<" "<~>" "<=|" "<~~" "<~"
                                           "<$>" "<$" "<+>" "<+" "</>" "</" "<*" "<*>" "<->" "<!--")))
                     (?:  . ,(regexp-opt '(":>" ":<" ":::" "::" ":?" ":?>" ":=")))
                     (?=  . ,(regexp-opt '("=>>" "==>" "=/=" "=!=" "=>" "===" "=:=" "==")))
                     (?!  . ,(regexp-opt '("!==" "!!" "!=")))
                     (?>  . ,(regexp-opt '(">]" ">:" ">>-" ">>=" ">=>" ">>>" ">-" ">=")))
                     (?&  . ,(regexp-opt '("&&&" "&&")))
                     (?|  . ,(regexp-opt '("|||>" "||>" "|>" "|]" "|}" "|=>" "|->" "|=" "||-" "|-" "||=" "||")))
                     (?.  . ,(regexp-opt '(".." ".?" ".=" ".-" "..<" "...")))
                     (?+  . ,(regexp-opt '("+++" "+>" "++")))
                     (?\[ . ,(regexp-opt '("[||]" "[<" "[|")))
                     (?\{ . ,(regexp-opt '("{|")))
                     (?\? . ,(regexp-opt '("??" "?." "?=" "?:")))
                     (?#  . ,(regexp-opt '("####" "###" "#[" "#{" "#=" "#!" "#:" "#_(" "#_" "#?" "#(" "##")))
                     (?\; . ,(regexp-opt '(";;")))
                     (?_  . ,(regexp-opt '("_|_" "__")))
                     (?\\ . ,(regexp-opt '("\\" "\\/")))
                     (?~  . ,(regexp-opt '("~~" "~~>" "~>" "~=" "~-" "~@")))
                     (?$  . ,(regexp-opt '("$>")))
                     (?^  . ,(regexp-opt '("^=")))
                     (?\] . ,(regexp-opt '("]#"))))))
    (dolist (char-regexp ligatures)
      (set-char-table-range composition-function-table (car char-regexp)
                            `([,(cdr char-regexp) 0 font-shape-gstring]))))
#+end_src

** Key freq
#+begin_src emacs-lisp
  (use-package keyfreq
   :defer 10
   :custom
      (keyfreq-mode 1)
      (keyfreq-autosave-mode 1))
#+end_src

* Buffers and Windows
** COMMENT Workspaces (Persepective
#+begin_src emacs-lisp
(use-package persp-mode
  :defer t
  :config
  (setq persp-keymap-prefix (kbd "SPC <tab>"))
#+end_src


* Startpage
#+begin_src emacs-lisp
  (use-package dashboard
    :after solaire-mode
    :init
    (dashboard-setup-startup-hook)
    :config
    (setq dashboard-startup-banner "~/.wals/34xkv0.jpg")
    ;; Value can be
    ;; 'official which displays the official emacs logo
    ;; 'logo which displays an alternative emacs logo
    ;; 1, 2 or 3 which displays one of the text banners
    ;; "path/to/your/image.png" or "path/to/your/text.txt" which
    ;;   displays whatever image/text you would prefer

    ;; Content is not centered by default. To center, set
    (setq dashboard-center-content t)
    (setq dashboard-set-heading-icons t)
    (setq dashboard-set-file-icons t)
    (setq dashboard-items '((recents  . 5)
                            (bookmarks . 5)
                            (projects . 5)
                            (agenda . 5)))
    (setq dashboard-set-init-info t)
    (setq dashboard-projects-switch-function 'counsel-projectile-switch-project-by-name))
#+end_src

* Beacon
#+begin_src emacs_lisp
(use-package beacon)
(  beacon-mode 1)
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)
#+end_src

* Dired-open
#+begin_src emacs-lisp
(use-package dired-open
  :commands (dired dired-jump)
  :config
  ;; Doesn't work as expected!
  ;; (add-to-list 'dired-open-functions #'dired-open-xdg t)
  (setq dired-open-extensions '(("pdf" . "zathura")
                                ("mkv" . "mpv")))) 
(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode)) 
  #+end_src
  

* tiny
#+begin_src emacs-lisp
(use-package tiny) 
(require 'tiny)
(tiny-setup-default)
#+end_src
