;;; early-init.el --- Early initialization -*- lexical-binding: t; -*-

;;; Commentary:
;; Emacs 27+ early initialization file for performance optimization
;; Loaded before package system and GUI initialization

;;; Code:

;; ============================================
;; Performance Optimization
;; ============================================

;; Increase garbage collection threshold during startup
;; Significantly speeds up initialization
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Restore reasonable GC settings after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 100 1024 1024)  ; 100MB
                  gc-cons-percentage 0.1)
            (garbage-collect))
          t)

;; Increase data read from processes (important for LSP)
(setq read-process-output-max (* 10 1024 1024))  ; 10MB

;; ============================================
;; Native Compilation Settings (Emacs 28+)
;; ============================================

;; Suppress native-comp warnings
(setq native-comp-async-report-warnings-errors 'silent)

;; Set native-comp cache directory
(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache
   (expand-file-name "var/eln-cache/" user-emacs-directory)))

;; ============================================
;; UI Optimization
;; ============================================

;; Disable UI elements early to prevent flickering
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(push '(horizontal-scroll-bars) default-frame-alist)

;; Prevent frame resize when adding UI elements
(setq frame-inhibit-implied-resize t)

;; Disable startup screen
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message user-login-name)

;; ============================================
;; File Handler Optimization
;; ============================================

;; Temporarily disable file-name-handler-alist during startup
(defvar file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq file-name-handler-alist file-name-handler-alist-original))
          t)

;; ============================================
;; Package System
;; ============================================

;; Prefer loading newer compiled files
(setq load-prefer-newer t)

;; Don't load default package activation (we'll do it explicitly)
;; Uncomment if using straight.el or elpaca:
;; (setq package-enable-at-startup nil)

;;; early-init.el ends here
