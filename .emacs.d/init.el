;;; init.el --- Modern Emacs Configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; Modern Emacs configuration for Rust, TypeScript, and Python development
;; Optimized for Emacs 29+ with built-in features (eglot, use-package, tree-sitter)
;; Last updated: 2024-2025

;;; Code:

;; ============================================
;; 1. Package Management
;; ============================================

(require 'package)

;; Configure package archives
(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))

;; Initialize package system
(package-initialize)

;; Refresh package contents if needed
(unless package-archive-contents
  (package-refresh-contents))

;; Install use-package if not present (built-in Emacs 29+, but ensure availability)
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)  ; Automatically install packages

;; ============================================
;; 2. Custom File Configuration
;; ============================================

;; Keep custom settings in separate file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; ============================================
;; 3. Core Emacs Settings
;; ============================================

;; Use setopt for user options (Emacs 29+ - better than setq)
(when (fboundp 'setopt)
  (setopt tab-width 4
          indent-tabs-mode nil
          fill-column 80
          enable-recursive-minibuffers t
          tab-always-indent 'complete))

;; For Emacs 28, use setq
(unless (fboundp 'setopt)
  (setq tab-width 4
        indent-tabs-mode nil
        fill-column 80
        enable-recursive-minibuffers t
        tab-always-indent 'complete))

;; Better defaults
(setq-default
 cursor-type 'bar                          ; Bar cursor
 truncate-lines t                          ; Don't wrap lines
 require-final-newline t                   ; Always end files with newline
 sentence-end-double-space nil             ; Single space after period
 confirm-kill-emacs 'yes-or-no-p)          ; Confirm before exit

;; Improve scrolling behavior
(setq scroll-conservatively 101
      scroll-margin 3
      scroll-preserve-screen-position t)

;; Answer with y/n instead of yes/no
(defalias 'yes-or-no-p 'y-or-n-p)

;; Show matching parentheses
(show-paren-mode 1)

;; Highlight current line
(global-hl-line-mode 1)

;; Column number in mode line
(column-number-mode 1)

;; ============================================
;; 4. UI Configuration
;; ============================================

;; Disable unnecessary UI elements (redundant with early-init, but ensures terminal mode)
(when (fboundp 'menu-bar-mode)   (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode)   (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; Line Numbers (modern approach - Emacs 26+)
;; display-line-numbers-mode is MUCH faster than linum-mode (now obsolete)
(global-display-line-numbers-mode 1)

;; Disable line numbers in certain modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook
                treemacs-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Optional: Use relative line numbers
;; (setq display-line-numbers-type 'relative)

;; Show trailing whitespace
(setq-default show-trailing-whitespace t)

;; Don't show trailing whitespace in certain modes
(dolist (mode '(term-mode-hook
                shell-mode-hook
                eshell-mode-hook
                compilation-mode-hook))
  (add-hook mode (lambda () (setq show-trailing-whitespace nil))))

;; ============================================
;; 5. Theme Configuration
;; ============================================

(use-package gruvbox-theme
  :ensure t
  :config
  ;; Load theme based on GUI vs terminal and daemon mode
  (if (daemonp)
      ;; For daemon mode, load after first frame creation
      (add-hook 'after-make-frame-functions
                (lambda (frame)
                  (with-selected-frame frame
                    (load-theme 'gruvbox-dark-hard t))))
    ;; For regular Emacs, load immediately
    (load-theme 'gruvbox-dark-hard t)))

;; Alternative themes (uncomment to use):
;; Built-in Modus themes (Emacs 28+) - excellent dark/light themes
;; (load-theme 'modus-vivendi t)  ; Dark
;; (load-theme 'modus-operandi t) ; Light

;; ============================================
;; 6. File Handling
;; ============================================

;; Auto-revert files when changed externally
(global-auto-revert-mode 1)
(setq auto-revert-verbose nil              ; Don't spam messages
      auto-revert-avoid-polling t          ; Use file notifications
      auto-revert-use-notify t)

;; Backup files configuration
(setq backup-directory-alist `(("." . ,(expand-file-name "backups" user-emacs-directory)))
      backup-by-copying t                  ; Don't clobber symlinks
      version-control t                    ; Version numbered backups
      delete-old-versions t                ; Delete excess backups
      kept-new-versions 6                  ; Keep 6 newest versions
      kept-old-versions 2)                 ; Keep 2 oldest versions

;; Auto-save configuration
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-save/" user-emacs-directory) t)))

;; Create directories if they don't exist
(let ((backup-dir (expand-file-name "backups" user-emacs-directory))
      (auto-save-dir (expand-file-name "auto-save" user-emacs-directory)))
  (dolist (dir (list backup-dir auto-save-dir))
    (unless (file-directory-p dir)
      (make-directory dir t))))

;; ============================================
;; 7. Tree-sitter Configuration (Emacs 29+)
;; ============================================

;; Tree-sitter provides fast, accurate syntax parsing
(when (and (fboundp 'treesit-available-p) (treesit-available-p))
  ;; Define language grammar sources
  (setq treesit-language-source-alist
        '((rust "https://github.com/tree-sitter/tree-sitter-rust")
          (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "typescript/src")
          (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "tsx/src")
          (python "https://github.com/tree-sitter/tree-sitter-python")
          (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "v0.21.2" "src")))

  ;; Helper function to install grammars
  (defun my/install-treesit-grammars ()
    "Install tree-sitter grammars if not present."
    (interactive)
    (dolist (lang '(rust typescript tsx python javascript))
      (unless (treesit-language-available-p lang)
        (message "Installing tree-sitter grammar for %s" lang)
        (treesit-install-language-grammar lang))))

  ;; Remap modes to use tree-sitter variants
  (setq major-mode-remap-alist
        '((rust-mode . rust-ts-mode)
          (typescript-mode . typescript-ts-mode)
          (python-mode . python-ts-mode)
          (javascript-mode . js-ts-mode)))

  ;; Optionally auto-install grammars on first launch
  ;; (my/install-treesit-grammars)
  )

;; Note: If tree-sitter grammars aren't installed, Emacs will fall back to regular modes
;; To install grammars: M-x treesit-install-language-grammar

;; ============================================
;; 8. Completion Framework (Vertico Ecosystem)
;; ============================================

;; Vertico - vertical completion UI (replaces Ivy/Helm)
(use-package vertico
  :init
  (vertico-mode)
  :config
  (setq vertico-cycle t))  ; Cycle through candidates

;; Orderless - flexible matching style
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; Marginalia - rich completion annotations
(use-package marginalia
  :init
  (marginalia-mode))

;; Consult - enhanced commands with live preview
(use-package consult
  :bind (;; C-c bindings (mode-specific-map)
         ("C-c h" . consult-history)
         ("C-c m" . consult-mode-command)
         ("C-c k" . consult-kmacro)
         ;; C-x bindings (ctl-x-map)
         ("C-x M-:" . consult-complex-command)
         ("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x 5 b" . consult-buffer-other-frame)
         ("C-x r b" . consult-bookmark)
         ;; M-g bindings (goto-map)
         ("M-g e" . consult-compile-error)
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-g o" . consult-outline)
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings (search-map)
         ("M-s d" . consult-find)
         ("M-s D" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s m" . consult-multi-occur)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines))
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :config
  ;; Use ripgrep if available
  (when (executable-find "rg")
    (setq consult-grep-command "rg --null --line-buffered --color=never --max-columns=1000 --path-separator / --smart-case --no-heading --line-number .")))

;; Embark - contextual actions on completion candidates
(use-package embark
  :bind (("C-." . embark-act)
         ("M-." . embark-dwim)
         ("C-h B" . embark-bindings))
  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;; Corfu - in-buffer completion popup (replaces Company)
(use-package corfu
  :custom
  (corfu-auto t)                           ; Enable auto completion
  (corfu-auto-delay 0.2)                   ; Delay before showing popup
  (corfu-auto-prefix 2)                    ; Minimum prefix length
  (corfu-cycle t)                          ; Enable cycling
  (corfu-quit-no-match 'separator)         ; Don't quit if no match
  :bind (:map corfu-map
              ("TAB" . corfu-next)
              ([tab] . corfu-next)
              ("S-TAB" . corfu-previous)
              ([backtab] . corfu-previous))
  :init
  (global-corfu-mode)
  (corfu-history-mode))

;; Add extensions
(use-package cape
  ;; Provides additional completion-at-point backends
  :init
  ;; Add useful backends
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file))

;; ============================================
;; 9. LSP Configuration (Eglot - Built-in)
;; ============================================

(use-package eglot
  :ensure nil  ; Built-in to Emacs 29+
  :hook ((rust-ts-mode . eglot-ensure)
         (rust-mode . eglot-ensure)
         (typescript-ts-mode . eglot-ensure)
         (tsx-ts-mode . eglot-ensure)
         (python-ts-mode . eglot-ensure)
         (python-mode . eglot-ensure))
  :custom
  (eglot-autoshutdown t)                   ; Shutdown server when last buffer is killed
  (eglot-send-changes-idle-time 0.3)       ; Send changes after 0.3s idle
  :config
  ;; Performance optimization: disable event logging
  (setq eglot-events-buffer-size 0)

  ;; Keybindings
  :bind (:map eglot-mode-map
              ("C-c l r" . eglot-rename)
              ("C-c l a" . eglot-code-actions)
              ("C-c l f" . eglot-format)
              ("C-c l d" . eldoc)))

;; ============================================
;; 10. Language-Specific Configuration
;; ============================================

;; -------------------- RUST --------------------

(use-package rustic
  :mode ("\\.rs\\'" . rustic-mode)
  :custom
  (rustic-format-on-save t)                ; Format with rustfmt on save
  (rustic-lsp-client 'eglot)               ; Use eglot for LSP
  :config
  ;; Disable rustic's LSP configuration (we handle it via eglot hook)
  (setq rustic-lsp-server 'rust-analyzer))

;; -------------------- TYPESCRIPT/JAVASCRIPT --------------------

;; TypeScript mode uses tree-sitter by default via major-mode-remap-alist
;; No additional package needed for Emacs 29+ with tree-sitter

;; Optional: Traditional typescript-mode package (fallback for Emacs 28)
(unless (and (fboundp 'treesit-available-p) (treesit-available-p))
  (use-package typescript-mode
    :mode (("\\.ts\\'" . typescript-mode)
           ("\\.tsx\\'" . tsx-ts-mode))))

;; -------------------- PYTHON --------------------

;; Python mode built-in; tree-sitter variant enabled via major-mode-remap-alist

;; Virtual environment handling for macOS/Linux
(use-package pyvenv
  :config
  (pyvenv-mode 1))

;; Alternative: direnv for project-specific environments
(use-package envrc
  :config
  (envrc-global-mode))  ; Automatically load .envrc files

;; ============================================
;; 11. Project Management
;; ============================================

;; Project.el is built-in (Emacs 28+)
(use-package project
  :ensure nil  ; Built-in
  :bind (("C-x p f" . project-find-file)
         ("C-x p g" . project-find-regexp)
         ("C-x p b" . project-switch-to-buffer))
  :config
  (setq project-switch-commands
        '((project-find-file "Find file")
          (project-find-regexp "Find regexp")
          (project-dired "Dired")
          (magit-project-status "Magit" ?g))))

;; ============================================
;; 12. Version Control (Git)
;; ============================================

;; Magit - the best Git interface
(use-package magit
  :bind (("C-x g" . magit-status)
         ("C-c g" . magit-status)
         ("C-c C-g" . magit-file-dispatch))
  :config
  (setq magit-display-buffer-function
        #'magit-display-buffer-same-window-except-diff-v1))

;; diff-hl - show git diff in fringe
(use-package diff-hl
  :hook ((prog-mode . diff-hl-mode)
         (dired-mode . diff-hl-dired-mode)
         (magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config
  (global-diff-hl-mode)
  ;; Use margin instead of fringe in terminal
  (unless (display-graphic-p)
    (diff-hl-margin-mode)))

;; ============================================
;; 13. Whitespace Handling
;; ============================================

;; ws-butler - intelligently trim whitespace (only on edited lines)
(use-package ws-butler
  :hook (prog-mode . ws-butler-mode))

;; ============================================
;; 14. Additional Utilities
;; ============================================

;; which-key - show available keybindings (built-in Emacs 30+)
(use-package which-key
  :init
  (which-key-mode)
  :config
  (setq which-key-idle-delay 0.5           ; Show popup after 0.5s
        which-key-popup-type 'side-window
        which-key-side-window-location 'bottom))

;; helpful - better help buffers
(use-package helpful
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)
         ("C-h x" . helpful-command)
         ("C-c C-d" . helpful-at-point)))

;; rainbow-delimiters - colorful parentheses
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Org-mode enhancements (if using org)
(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

;; Markdown support
(use-package markdown-mode
  :mode ("\\.md\\'" . markdown-mode))

;; YAML support
(use-package yaml-mode
  :mode ("\\.ya?ml\\'" . yaml-mode))

;; JSON support (built-in json-mode in Emacs 29+)
(use-package json-mode
  :mode "\\.json\\'")

;; Dockerfile support
(use-package dockerfile-mode
  :mode "Dockerfile\\'")

;; Snippet expansion
(use-package yasnippet
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :after yasnippet)

;; ============================================
;; 15. Cross-Platform Configuration
;; ============================================

;; macOS-specific configuration
(when (eq system-type 'darwin)
  ;; exec-path-from-shell - critical for macOS GUI Emacs
  (use-package exec-path-from-shell
    :config
    (setq exec-path-from-shell-variables '("PATH" "MANPATH" "GOPATH"))
    (exec-path-from-shell-initialize))

  ;; Better scrolling on macOS
  (setq mouse-wheel-scroll-amount '(1 ((shift) . 1))
        mouse-wheel-progressive-speed nil))

;; Linux-specific configuration
(when (eq system-type 'gnu/linux)
  ;; X clipboard integration
  (setq x-select-enable-clipboard t
        x-select-enable-primary t))

;; Platform-agnostic font configuration
;;(defun my/setup-fonts ()
;;  "Configure fonts based on platform and display type."
;;  (when (display-graphic-p)
;;    (let ((font-family (cond
;;                        ((eq system-type 'darwin) "SF Mono")
;;                        ((eq system-type 'gnu/linux) "DejaVu Sans Mono")
;;                        (t "Consolas")))
;;          (font-size (if (eq system-type 'darwin) 140 120)))
;;      (set-face-attribute 'default nil
;;                          :family font-family
;;                          :height font-size
;;                          :weight 'normal))))

(add-hook 'after-init-hook #'my/setup-fonts)

;; ============================================
;; 16. Security Settings
;; ============================================

;; Network security
(setq network-security-level 'medium       ; Options: low, medium, high, paranoid
      gnutls-verify-error t                ; Error on verification failure
      tls-checktrust t)

;; Safe local variables
(setq enable-local-variables t             ; Ask before loading
      enable-local-eval nil)               ; Don't allow eval in file locals

;; ============================================
;; 17. Performance Monitoring (Optional)
;; ============================================

;; Uncomment to benchmark startup time
;; (use-package benchmark-init
;;   :config
;;   (add-hook 'after-init-hook 'benchmark-init/deactivate))

;; ============================================
;; 18. Startup Optimization
;; ============================================

;; Display startup time
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs loaded in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

;;; init.el ends here
