;; Straight.el
(setq initial-major-mode 'org-mode)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default python-indent-levels 4)

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
(setq inhibit-startup-message t)
(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room
(global-visual-line-mode t) 
(menu-bar-mode -1)            ; Disable the menu bar
(setq visible-bell t)   ;; Set up the visible bell
(setq efs/default-font-size 120)
(setq efs/default-variable-font-size 100)
(global-set-key (kbd "C-c C-b") 'eval-buffer)

(defun efs/set-font-faces ()
  (message "Setting faces!")
  (set-face-attribute 'default nil :font "Cascadia Code" :height efs/default-font-size)

  ;; Set the fixed pitch face
  (set-face-attribute 'fixed-pitch nil :font "Cascadia Code" :height efs/default-font-size)

  ;; Set the variable pitch face
  (set-face-attribute 'variable-pitch nil :font "Cascadia Code" :height efs/default-variable-font-size :weight 'regular))

(if (daemonp)
    (add-hook 'after-make-frame-functions
              (lambda (frame)
                (setq doom-modeline-icon t)
                (with-selected-frame frame
                  (efs/set-font-faces))))
  (efs/set-font-faces))

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package yasnippet
  :config
  (setq yas-snippet-dirs '("~/.emacs.d/snippets"))
  (yas-global-mode t))

(column-number-mode)

(global-display-line-numbers-mode t)

;; Enable line numbers for some modes
(dolist (mode '(text-mode-hook
                prog-mode-hook
                conf-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 1))))

;; Override some modes which derive from the above
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package undo-fu)
(use-package command-log-mode)

(use-package ligature
 :straight (ligature :type git :host github :repo "mickeynp/ligature.el")
 :config
 ;; Enable the "www" ligature in every possible major mode
 (ligature-set-ligatures 't '("www"))
 ;; Enable traditional ligature support in eww-mode, if the
 ;; `variable-pitch' face supports it
 (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
 ;; Enable all Cascadia Code ligatures in programming modes
 (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                                      ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                                      "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                                      "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                                      "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                                      ;; "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                                      "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                                      "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                                      ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                                      "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                                      "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                                      "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
                                      "\\\\" "://"))
 ;; Enables ligature checks globally in all buffers. You can also do it
 ;; per mode with `ligature-mode'.
 (global-ligature-mode t))

(use-package sudo-edit)

(use-package ivy
  :diminish
  :bind (("C-/" . evilnc-comment-or-uncomment-lines) 
	 ("C-s" . swiper)
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

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1)
  :after counsel)

(use-package ivy-prescient
  :after counsel
  :config
  (ivy-prescient-mode 1))


(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 40)))

(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-molokai t)
  
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-molokai") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package rainbow-delimiters
  :hook ((prog-mode org-mode) . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-symbol] . helpful-symbol)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-command] . helpful-command)
  ([remap describe-key] . helpful-key))

;; Completion
(use-package company
  :hook (after-init . global-company-mode))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll nil)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (setq evil-undo-system 'undo-fu)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  ;; (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

(use-package evil-nerd-commenter
  :config
  (evilnc-default-hotkeys))

(use-package evil-multiedit
  :config
  (evil-multiedit-default-keybinds))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

;; Key Maps

(global-set-key (kbd "C-c m") #'math-lowercase/body)
(global-set-key (kbd "C-c n") #'math-uppercase/body)

(use-package general
  :config
  (general-create-definer rune/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (rune/leader-keys
    "f"  '(:ignore f :which-key "Files")
    "ff" '(counsel-find-file :which-key "Open file")
    "fr" '(counsel-recentf :which-key "Open file")
    "fp" '(lambda() (interactive) (find-file "~/.emacs.d/init.el"))
    "b"  '(:ignore b :which-key "Buffer")
    "bk" '(kill-current-buffer :which-key "Kill buffer")
    "bn" '(next-buffer :which-key "Next buffer")
    "bp" '(previous-buffer :which-key "Previous buffer")
    ","  '(counsel-switch-buffer :which-key "Switch buffer")
    "w"  '(:ignore w :which-key "Window")
    "wv" '(split-window-right :which-key "Vertical Split")
    "ws" '(split-window-below  :which-key "Horizontal Split")
    "wM" '(maximize-window :which-key "Maximize Window")
    "wm" '(minimize-window :which-key "Minimize Window")
    "wq" '(evil-quit :which-key "Close Window")
    "q"  '(:ignore q :which-key "Quit")
    "qq" '(kill-emacs :which-key "Quit Emacs")
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(Counsel-load-theme :which-key "choose theme")
    "h"  '(:ignore h :which-key "Describe")
    "hv" '(counsel-describe-variable :which-key "variable")
    "hf" '(counsel-describe-function :which-key "function")
    "ts" '(hydra-text-scale/body :which-key "scale text")))
(general-evil-setup)

(unless (string-equal system-type "windows-nt")
  (use-package vterm))

(use-package pdf-tools)

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; Org related

(use-package org
  :straight '(org :type git
		  :repo "https://git.savannah.gnu.org/git/emacs/org-mode.git")
  :config
  (setq org-confirm-babel-evaluate nil)
  (setq org-export-date-timestamp-format "%A, %B %e, %Y")
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))
  (setq org-display-inline-images t)
  (setq org-redisplay-inline-images t)
  (setq org-startup-with-inline-images "inlineimages")
  (setq org-hide-emphasis-markers t)
  (setq org-confirm-elisp-link-function nil)
  (setq org-link-frame-setup '((file . find-file))))
;; ** <<APS journals>>
(add-to-list 'org-latex-classes '("revtex4-2"
				  "\\documentclass{revtex4-2}
 [NO-DEFAULT-PACKAGES]
 [PACKAGES]
 [EXTRA]"
				  ("\\section{%s}" . "\\section*{%s}")
				  ("\\subsection{%s}" . "\\subsection*{%s}")
				  ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
				  ("\\paragraph{%s}" . "\\paragraph*{%s}")
				  ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(use-package org-contrib)

(use-package ivy-bibtex)

(use-package org-ref
  :config
  (setq org-latex-prefer-user-labels t)
  (setq org-ref-default-ref-type "autoref"))


(use-package org-ref-ivy
  :straight org-ref
  :after (org org-ref ivy ivy-bibtex)
  :init (setq org-ref-insert-link-function 'org-ref-insert-link-hydra/body
	      org-ref-insert-cite-function 'org-ref-cite-insert-ivy
	      org-ref-insert-label-function 'org-ref-insert-label-link
	      org-ref-insert-ref-function 'org-ref-insert-ref-link
	      org-ref-cite-onclick-function (lambda (_) (org-ref-citation-hydra/body))))
(use-package org-ref-arxiv :straight org-ref)
(use-package org-ref-scopus :straight org-ref)
(use-package org-ref-wos :straight org-ref)

(define-key org-mode-map (kbd "C-c ]") 'org-ref-insert-link-hydra/body)

(use-package auctex)
(use-package cdlatex :after org :hook (org-mode . org-cdlatex-mode))

(use-package org-superstar :after org :hook (org-mode . org-superstar-mode))

;; Python things

;;(use-package conda
;;  :config
;; (custom-set-variables '(conda-anaconda-home "~/mambaforge/"))
;;  (setq conda-env-home-directory (expand-file-name "~/mambaforge/")))
;;(conda-env-activate "base")
(use-package company-jedi
  :hook (org-mode . jedi:setup)
  :config
  (setq jedi:complete-on-dot t))

(use-package jupyter)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (julia . t)
   (python . t)
   (jupyter . t)))

(add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)

;; HERE BE DRAGONS
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   '("~/Dropbox/URochester/Fall_2021/PHYS_415_Electromagnetic_Theory/final_project/surface_plasmons.org"))
 '(package-selected-packages
   '(org pdf-tools vterm counsel-projectile projectile ligature command-log-mode quelpa-use-package quelpa general hydra evil-nerd-commenter evil-surround evil-collection evil helpful which-key rainbow-delimiters doom-themes doom-modeline))
 '(warning-suppress-types '((use-package) (comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
