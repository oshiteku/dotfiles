;; -*- lexical-binding: t; -*-


;;
;; leaf.el

(eval-and-compile
  (customize-set-variable
   'package-archives '(("org" . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("gnu" . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf blackout :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))


;;
;; Builtin package config
;; from https://emacs-jp.github.io/tips/emacs-in-2020


(leaf cus-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :tag "builtin" "faces" "help"
  :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))


(leaf cus-start
  :doc "define customization properties of builtins"
  :tag "builtin" "internal"
  :preface
  (defun c/redraw-frame nil
    (interactive)
    (redraw-frame))

  :bind (("M-ESC ESC" . c/redraw-frame))
  :custom '((create-lockfiles . nil)
            (debug-on-error . t)
            (init-file-debug . t)
            (frame-resize-pixelwise . t)
            (enable-recursive-minibuffers . t)
            (history-length . 1000)
            (history-delete-duplicates . t)
            (scroll-preserve-screen-position . t)
            (scroll-conservatively . 100)
            (mouse-wheel-scroll-amount . '(1 ((control) . 5)))
            (ring-bell-function . 'ignore)
            (text-quoting-style . 'straight)
            (truncate-lines . t)
            (use-dialog-box . nil)
            (use-file-dialog . nil)
            (menu-bar-mode . nil)
            (tool-bar-mode . nil)
            (scroll-bar-mode . nil)
            (indent-tabs-mode . nil))
  :config
  (defalias 'yes-or-no-p 'y-or-n-p))


(leaf autorevert
  :doc "revert buffers when files on disk change"
  :tag "builtin"
  :custom ((auto-revert-interval . 1))
  :global-minor-mode global-auto-revert-mode)


(leaf cc-mode
  :doc "major mode for editing C and similar languages"
  :tag "builtin"
  :defvar (c-basic-offset)
  :bind (c-mode-base-map
         ("C-c c" . compile))
  :mode-hook
  (c-mode-hook . ((c-set-style "bsd")
                  (setq c-basic-offset 4)))
  (c++-mode-hook . ((c-set-style "bsd")
                    (setq c-basic-offset 4))))


(leaf delsel
  :doc "delete selection if you insert"
  :tag "builtin"
  :global-minor-mode delete-selection-mode)


(leaf paren
  :doc "highlight matching paren"
  :tag "builtin"
  :custom ((show-paren-delay . 0.1))
  :global-minor-mode show-paren-mode)


(leaf simple
  :doc "basic editing commands for Emacs"
  :tag "builtin" "internal"
  :custom ((kill-ring-max . 100)
           (kill-read-only-ok . t)
           (kill-whole-line . t)
           (eval-expression-print-length . nil)
           (eval-expression-print-level . nil)))


(leaf files
  :doc "file input and output commands for Emacs"
  :tag "builtin"
  :custom `((auto-save-timeout . 15)
            (auto-save-interval . 60)
            (auto-save-file-name-transforms . '((".*" ,(locate-user-emacs-file "backup/") t)))
            (backup-directory-alist . '((".*" . ,(locate-user-emacs-file "backup"))
                                        (,tramp-file-name-regexp . nil)))
            (version-control . t)
            (delete-old-versions . t)))


(leaf startup
  :doc "process Emacs shell arguments"
  :tag "builtin" "internal"
  :custom `((auto-save-list-file-prefix . ,(locate-user-emacs-file "backup/.saves-"))))


;;
;; Style, UI

(leaf modus-themes
  :ensure t
  :config
  (load-theme 'modus-operandi-tinted :no-confirm))

(leaf spacious-padding
  :ensure t
  :global-minor-mode t
  :custom
  ((spacious-padding-widths
    '( :internal-border-width 15
       :header-line-width 4
       :mode-line-width 6
       :tab-width 4
       :right-divider-width 30
       :scroll-bar-width 8
       :fringe-width 8))
   (spacious-padding-subtle-mode-line . `( :mode-line-active 'default
                                           :mode-line-inactive vertical-border))))

(leaf golden-ratio
  :ensure t
  :global-minor-mode t)

(leaf solaire-mode
  :ensure t
  :global-minor-mode t)

(leaf font
  :config
  (set-language-environment "Japanese")
  (set-face-attribute 'default nil :family "UDEV Gothic 35NF" :height 120))

;; ここに全角スペース → 　

(leaf minimap
  :ensure t
  :bind (("C-x m" . minimap-mode))
  :custom
  (minimap-window-location . 'right)
  (minimap-minimum-width . 20))

(leaf treemacs
  :ensure t)


;;
;;
;; Dashboard

(leaf dashboard
  :ensure t
  :custom
  ((dashboard-startup-banner . 'logo))
  :config
  (dashboard-setup-startup-hook))


;;
;; Mode Line

(leaf doom-modeline
  :ensure t
  :global-minor-mode t)

(leaf display-battery
  :global-minor-mode t)

(leaf nyan-mode
  :ensure t
  :global-minor-mode t
  :custom
  (nyan-animate-nyancat . t)
  (nyan-wavy-trail . t))


;;
;; Minibuffer

(leaf vertico
  :ensure t
  :custom
  (vertico-count . 20)
  (vertico-resize . t)
  :global-minor-mode t)

(leaf savehist
  :ensure t
  :global-minor-mode t)

(leaf marginalia
  :ensure t
  :config
  (marginalia-mode))

(leaf orderless
  :ensure t
  :init
  (icomplete-mode)
  :custom
  (completion-styles . '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion)))))

(leaf which-key
  :global-minor-mode t)


;;
;; keymap

;; なぜか leaf.el 側の設定が有効にならないのでベタ書き
(keyboard-translate ?\C-h ?\C-?)

(when (equal system-type 'darwin)
  (setq mac-command-modifier 'meta))

;;
;; Input Method

;; SKK (https://emacs-jp.github.io/packages/ddskk-posframe)
(leaf skk
  :ensure ddskk
  :custom ((default-input-method . "japanese-skk"))
  :bind (("C-x C-j" . skk-mode))
  :config
  (leaf ddskk-posframe
    :ensure t
    :global-minor-mode t))

(leaf emojify
  :ensure t
  :global-minor-mode t)


;;
;; migemo

(leaf migemo
  :ensure t
  :require t
  :defun
  (migemo-init)
  :custom
  `(migemo-dictionary . ,(seq-find #'file-exists-p
                                   '( "/usr/share/cmigemo/utf-8/migemo-dict"
                                      "/usr/share/migemo/utf-8/migemo-dict"
                                      "/opt/homebrew/share/migemo/utf-8/migemo-dict")))
  (migemo-user-dictionary . nil)
  (migemo-regex-dictionary . nil)
  (migemo-coding-system . 'utf-8-unix)
  :config
  (migemo-init))


;;
;; git

(leaf magit
  :ensure t)

(leaf git-gutter
  :ensure t
  :custom
  ;; (git-gutter:modified-sign . "=")
  ;; (git-gutter:added-sign . "+")
  ;; (git-gutter:deleted-sign . "-")
  :config
  (global-git-gutter-mode +1)
  (set-face-background 'git-gutter:modified "purple")
  (set-face-background 'git-gutter:added "green")
  (set-face-background 'git-gutter:deleted "red"))

;;
;;
;; Projectile

(leaf projectile
  :ensure t
  :global-minor-mode t)


;;
;; Terminal Emulator

(leaf vterm
  :ensure t)


;;
;; Coding

(leaf undo-tree
  :ensure t
  :global-minor-mode global-undo-tree-mode)

(leaf markdown-mode
  :ensure t
  :mode ("\\.md\\'" . gfm-mode)
  :custom
  (markdown-fontify-code-blocks-natively . t)
  (markdown-header-scaling . t))

(leaf rust-mode
  :ensure t
  :custom
  (rust-format-on-save . t)
  :config
  (add-hook 'rust-mode-hook
            (lambda () (prettify-symbols-mode))))

(leaf writeroom-mode
  :ensure t
  :bind (("C-x w" . writeroom-mode)))


;;
;; LLM

(leaf gptel
  :ensure t)


;;
;; end of init.el

(provide 'init)
