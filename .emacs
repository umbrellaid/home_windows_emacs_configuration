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

(use-package package
  :ensure nil
  :config
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
  (when (< emacs-major-version 29)
    (unless (package-installed-p 'use-package)
      (unless package-archive-contents
        (package-refresh-contents))
      (package-install 'use-package))))

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
  (blink-cursor-mode 0))

(use-package modus-themes
  :ensure t
  :config
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
  :config
  (setq fontaine-latest-state-file
        (locate-user-emacs-file "fontaine-latest-state.eld"))
  (setq fontaine-presets
        '((small
           :default-family "Iosevka Comfy Motion Fixed"
           :default-height 80
           :variable-pitch-family "Iosevka Comfy Duo")
          (regular)
          (medium
           :default-weight semilight
           :default-height 115
           :bold-weight extrabold)
          (large
           :inherit medium
           :default-height 150)
          (presentation
           :default-height 180)
          (t
           ;; I keep all properties for didactic purposes, but most can be
           ;; omitted.  See the fontaine manual for the technicalities:
           ;; <https://protesilaos.com/emacs/fontaine>.
           :default-family "Iosevka Comfy Fixed"
           :default-weight regular
           :default-height 100

           :fixed-pitch-family nil ; falls back to :default-family
           :fixed-pitch-weight nil ; falls back to :default-weight
           :fixed-pitch-height 1.0

           :fixed-pitch-serif-family nil ; falls back to :default-family
           :fixed-pitch-serif-weight nil ; falls back to :default-weight
           :fixed-pitch-serif-height 1.0

           :variable-pitch-family "Iosevka Comfy Motion Duo"
           :variable-pitch-weight nil
           :variable-pitch-height 1.0

           :mode-line-active-family nil ; falls back to :default-family
           :mode-line-active-weight nil ; falls back to :default-weight
           :mode-line-active-height 0.9

           :mode-line-inactive-family nil ; falls back to :default-family
           :mode-line-inactive-weight nil ; falls back to :default-weight
           :mode-line-inactive-height 0.9

           :header-line-family nil ; falls back to :default-family
           :header-line-weight nil ; falls back to :default-weight
           :header-line-height 0.9

           :line-number-family nil ; falls back to :default-family
           :line-number-weight nil ; falls back to :default-weight
           :line-number-height 0.9

           :tab-bar-family nil ; falls back to :default-family
           :tab-bar-weight nil ; falls back to :default-weight
           :tab-bar-height 1.0

           :tab-line-family nil ; falls back to :default-family
           :tab-line-weight nil ; falls back to :default-weight
           :tab-line-height 1.0

           :bold-family nil ; use whatever the underlying face has
           :bold-weight bold

           :italic-family nil
           :italic-slant italic

           :line-spacing nil)))
  (fontaine-set-preset (or (fontaine-restore-latest-preset) 'regular))
  (fontaine-mode 1))

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
  (org-capture-templates
   '(("f" "Fleeting note"
      item
      (file+headline org-default-notes-file "Notes")
      "- %?")
     ("p" "Permanent note" plain
      (file denote-last-path)
      #'denote-org-capture
      :no-save t
      :immediate-finish nil
      :kill-buffer t
      :jump-to-captured t)
     ("t" "New task" entry
      (file+headline org-default-notes-file "Tasks")
      "* T
  )
