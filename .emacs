;;; init.el --- Emacs Home Configuration init -*- lexical-binding: t; -*-
;; This file is NOT part of GNU Emacs.
;; home windows emacs setup
;; sources
;; https://protesilaos.com/codelog/2025-01-16-emacs-org-todo-agenda-basics/
;; https://protesilaos.com/codelog/2024-11-28-basic-emacs-configuration/
;; Emacs: a basic and capable configuration
;; 2024-11-28
;; Protesilaos Stavrou
;; https://protesilaos.com/about/
;; https://github.com/protesilaos
;; https://github.com/protesilaos/dotfiles
;; YouTube Video
;; https://www.youtube.com/watch?v=9lE45khK3qU&t=917s
;; Properly Installing Emacs on Windows #emacs #windows #coding #programming
;; Raoul Comninos
;; https://www.youtube.com/@raoulcomninos
;; (formely known as Emacs Elements)
;; https://www.reddit.com/r/emacs/comments/1dwjszy/what_happened_to_emacs_elements/
;; https://github.com/gnarledgrip/Emacs-Elements
;; https://github.com/gnarledgrip
;; https://github.com/ggreer/the_silver_searcher
;; https://github.com/pprevos/emacs-writing-studio
;; Peter Prevos
;; https://github.com/pprevos
;; Font Type Information
;; https://protesilaos.com/codelog/2025-02-04-aporetic-fonts-1-0-0/
;; Iosevka Comfy is discontinued hello Aporetic fonts
;; 2025-02-04
;; https://github.com/protesilaos/aporetic
;; Other font options
;; https://www.nerdfonts.com/
;; https://www.nerdfonts.com/font-downloads
;; https://github.com/abo-abo/avy
;; https://github.com/abo-abo
;; Charles Choi
;; https://github.com/kickingvegas
;; https://github.com/kickingvegas/casual-avy
;; https://github.com/kickingvegas/casual
;; https://github.com/kickingvegas/casual-suite
;; https://emacsconf.org/2024/talks/casual/
;; Casual is a project to re-imagine the primary user interface for Emacs using keyboard-driven menus.

(use-package package
  :ensure nil
  :config
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
  (when (< emacs-major-version 29)
    (unless (package-installed-p 'use-package)
      (unless package-archive-contents
        (package-refresh-contents))
      (package-install 'use-package))))

(use-package avy
  :ensure t
  )

(use-package magit
  :ensure t
  )

(use-package casual-suite
  :ensure t
  :config
  (keymap-set calc-mode-map "C-o" #'casual-calc-tmenu)
  (keymap-set dired-mode-map "C-o" #'casual-dired-tmenu)
  (keymap-set isearch-mode-map "C-o" #'casual-isearch-tmenu)
  (keymap-set ibuffer-mode-map "C-o" #'casual-ibuffer-tmenu)
  (keymap-set ibuffer-mode-map "F" #'casual-ibuffer-filter-tmenu)
  (keymap-set ibuffer-mode-map "s" #'casual-ibuffer-sortby-tmenu)
  (keymap-set Info-mode-map "C-o" #'casual-info-tmenu)
  (keymap-set reb-mode-map "C-o" #'casual-re-builder-tmenu)
  (keymap-set reb-lisp-mode-map "C-o" #'casual-re-builder-tmenu)
  (keymap-set bookmark-bmenu-mode-map "C-o" #'casual-bookmarks-tmenu)
  (keymap-set org-agenda-mode-map "C-o" #'casual-agenda-tmenu)
  (keymap-global-set "M-g" #'casual-avy-tmenu)
  (keymap-set symbol-overlay-map "C-o" #'casual-symbol-overlay-tmenu)
  (keymap-global-set "C-o" #'casual-editkit-main-tmenu))

(use-package delsel
  :ensure nil
  :hook (after-init . delete-selection-mode))

(use-package emacs
  :ensure nil
  :config
  (setq custom-file (locate-user-emacs-file "custom.el"))
  (add-to-list 'display-buffer-alist
               '("\\`\\*\\(Warnings\\|Compile-Log\\)\\*\\'"
                 (display-buffer-no-window)
                 (allow-no-window . t)))
  (defun prot/keyboard-quit-dwim ()
    "Do-What-I-Mean behaviour for a general `keyboard-quit'."
    (interactive)
    (cond
     ((region-active-p)
      (keyboard-quit))
     ((derived-mode-p 'completion-list-mode)
      (delete-completion-window))
     ((> (minibuffer-depth) 0)
      (abort-recursive-edit))
     (t
      (keyboard-quit))))
  (define-key global-map (kbd "C-g") #'prot/keyboard-quit-dwim)
  (setq sentence-end-double-space nil)
  (setq-default fill-column 80)
  (set-default-coding-systems 'utf-8)
  (set-language-environment "UTF-8")
  (recentf-mode t)
  (setq recentf-max-saved-items 65536)
  (setq-default indent-tabs-mode nil)
  (blink-cursor-mode 0))

(use-package modus-themes
  :ensure t
  :config
  (mapc #'disable-theme custom-enabled-themes)
  (load-theme 'modus-vivendi-tinted :no-confirm-loading))

(use-package nerd-icons
  :ensure t)

(use-package nerd-icons-completion
  :ensure t
  :after marginalia
  :config
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-corfu
  :ensure t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package nerd-icons-dired
  :ensure t
  :hook
  (dired-mode . nerd-icons-dired-mode))

(use-package vertico
  :ensure t
  :hook (after-init . vertico-mode))

(use-package marginalia
  :ensure t
  :hook (after-init . marginalia-mode))

(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless basic))
  (setq completion-category-defaults nil)
  (setq completion-category-overrides nil))

(use-package savehist
  :ensure nil
  :hook (after-init . savehist-mode))

(use-package corfu
  :ensure t
  :hook (after-init . global-corfu-mode)
  :bind (:map corfu-map ("<tab>" . corfu-complete))
  :config
  (setq tab-always-indent 'complete)
  (setq corfu-preview-current nil)
  (setq corfu-min-width 20)
  (setq corfu-popupinfo-delay '(1.25 . 0.5))
  (corfu-popupinfo-mode 1)
  (with-eval-after-load 'savehist
    (corfu-history-mode 1)
    (add-to-list 'savehist-additional-variables 'corfu-history)))

(use-package dired
  :ensure nil
  :commands (dired)
  :hook
  ((dired-mode . dired-hide-details-mode)
   (dired-mode . hl-line-mode))
  :config
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'always)
  (setq delete-by-moving-to-trash t)
  (setq dired-dwim-target t))

(use-package dired-subtree
  :ensure t
  :after dired
  :bind
  ( :map dired-mode-map
    ("<tab>" . dired-subtree-toggle)
    ("TAB" . dired-subtree-toggle)
    ("<backtab>" . dired-subtree-remove)
    ("S-TAB" . dired-subtree-remove))
  :config
  (setq dired-subtree-use-backgrounds nil))

(use-package trashed
  :ensure t
  :commands (trashed)
  :config
  (setq trashed-action-confirmer 'y-or-n-p)
  (setq trashed-use-header-line t)
  (setq trashed-sort-key '("Date deleted" . t))
  (setq trashed-date-format "%Y-%m-%d %H:%M:%S"))

(use-package ag
  :ensure t
  :config
  (setq find-program "C:/findutils-4.2.30-5-w64-bin/bin/find.exe"))

(use-package ispell
  :ensure nil
  :config
  (setenv "LANG" "en_US")
  (setenv "DICPATH" "C:/hunspell-1.3.2-3-w32-bin/share/hunspell")
  (setq ispell-program-name "hunspell")
  (setq ispell-dictionary "en_US")
  (setq ispell-hunspell-dict-paths-alist
        '(("en_US" "C:/hunspell-1.3.2-3-w32-bin/share/hunspell/en_US.aff"))))

(use-package fontaine
  :ensure t
  :if (display-graphic-p)
  :demand t
  :bind ("C-c F" . fontaine-set-preset)
  :custom
  (fontaine-presets
   '((small
      :default-height 120)
     (regular
      :default-height 160)
     (large
      :default-family "Aporetic Serif Mono"
      :default-weight semilight
      :default-height 180
      :fixed-pitch-family "Aporetic Serif Mono"
      :variable-pitch-family "Aporetic Sans"
      :bold-weight extrabold)
     (presentation
      :inherit large
      :default-height 260)
     (t
      :default-family "Aporetic Sans Mono"
      :default-weight regular
      :default-slant normal
      :default-width normal
      :default-height 100
      :fixed-pitch-family "Aporetic Sans Mono"
      :variable-pitch-family "Aporetic Serif")
     ))
  :config
  (fontaine-set-preset 'regular))

(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

(use-package embrace
  :ensure t
  )

(use-package spacious-padding
  :ensure t
  :config
  (spacious-padding-mode 1)
  )

(use-package org
  :ensure nil ; do not try to install it as it is built-in
  :config
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

  (setq org-directory "~/my_org_files/")
  (setq org-default-notes-file (concat org-directory "/my_main_notes_file.org"))
  (setq org-agenda-files (list org-directory))

  ;; Learn about the ! and more by reading the relevant section of the
  ;; Org manual.  Evaluate: (info "(org) Tracking TODO state changes")
  (setq org-todo-keywords
        '((sequence "TODO(t)" "WAIT(w!)" "|" "CANCEL(c!)" "DONE(d!)")))
  :custom
  (setq org-capture-templates
        '(("t" "Todo" entry (file+headline (expand-file-name "todo.org" org-directory) "Tasks")
           "* TODO %?\n  %i\n  %a")
          ("w" "Work" entry (file+headline (expand-file-name "work.org" org-directory) "Work")
           "* TODO %?\n  %i\n  %a")
          ("p" "Personal" entry (file+headline (expand-file-name "personal.org" org-directory) "Personal")
           "* TODO %?\n  %i\n  %a")))
  )

;; Custom function for reindenting (kept outside use-package as it's not package-specific)
(defun drr-my-reindent-file ()
  "Reindent the entire file and return to the original cursor position."
  (interactive)
  (let ((original-line (line-number-at-pos))
        (original-column (current-column)))
    (goto-char (point-min))
    (mark-whole-buffer)
    (indent-region (point-min) (point-max))
    (goto-line original-line)
    (move-to-column original-column nil)))

(defun drr-condense-blank-lines ()
  "Condense multiple blank lines into a single blank line in the entire buffer."
  (interactive)
  (goto-char (point-min))
  (while (re-search-forward "\n\n+" nil t)
    (replace-match "\n\n")))

(defun drr-insert-date-stamp-prefix ()
  "Inserts the current date in mm-dd-yyyy format, prefixed with 'Date: '."
  (interactive)
  (insert (format-time-string "Date: %m-%d-%Y")))

(defun drr-insert-date-stamp ()
  "Inserts the current date in mm-dd-yyyy format"
  (interactive)
  (insert (format-time-string "%m-%d-%Y")))
