

;;;; INIT
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(setq inhibit-startup-screen t)


;;;; PACKAGES
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(package-initialize)

(defun tel/fn/dopkgs (pkgs)
  (package-refresh-contents)
  (mapc #'(lambda (package)
            (unless (package-installed-p package)
              (package-install package)))
        pkgs))

(setf tel/vars/packages
      '(

	ace-jump-mode
	base16-theme
	browse-kill-ring
	company
	company-ghc
	deft
	dired+
	dropdown-list
	expand-region
	ghc
	gist
	git-commit-mode
	haskell-mode
	helm
	helm-ack
	helm-ghc
	magit
	paredit
	undo-tree

	))

(tel/fn/dopkgs tel/vars/packages)


;;;; MACROS
(defmacro after (mode &rest body)
  "`eval-after-load' MODE evaluate BODY."
  (declare (indent defun))
  `(eval-after-load ,mode
     '(progn ,@body)))


;;;; EXTERNAL LIBS
(progn
  (require 'checkdoc)
  (require 'midnight)
  (require 'misc)
  (require 'recentf)
  (require 'saveplace)
  (require 'uniquify))


;;;; PATH SETUP
(setq tel/vars/paths
      '("~/.cabal/bin/"
        "~/bin/"
        "~/.nix-profile/bin/"
        "/usr/texbin/"
	))

(defun tel/fns/localpaths (the-paths)
  (setenv "PATH"
          (mapconcat
           'identity
           (delete-dups
            (append
             (mapcar (lambda (path)
                       (if (string-match "^~" path)
                           (replace-match (getenv "HOME") nil nil path)
                         path)) the-paths)
             (split-string (getenv "PATH") ":")))
           ":"))
  (mapc (lambda (path) (push path exec-path)) the-paths))

(tel/fns/localpaths tel/vars/paths)

;;;; NIX
(setq load-path
      (append (list "~/.nix-profile/share/emacs/site-lisp"
		    "/run/current-system/sw/share/emacs/site-lisp")
	      load-path))
(require 'nix-mode)

(defun tel/fns/setup-nix-paths ()
  (let ((nix-link "~/.nix-profile/")
	(nix-path (getenv "NIX_PATH")))
    (tel/fns/localpaths
     (list (concat nix-link "bin")
	   (concat nix-link "sbin")))
    (setenv "NIX_PATH"
	    (concat "~/src/nixpkgs:"
		    "nixpkgs=~/.nix-defexpr/channels/nixpkgs"))))
(tel/fns/setup-nix-paths)


;;;; SERVER
(ignore-errors (server-start))


;;;; ALIASES
(progn
  (defalias 'qrr         'query-replace-regexp)
  (defalias 'qr          'query-replace)
  (defalias 'eshell/ff   'find-file)
  (defalias 'eshell/ffow 'find-file-other-window)
  (defalias 'yes-or-no-p 'y-or-n-p))


;;;; REMAPS
(progn
  (define-key key-translation-map (kbd "<C-tab>") (kbd "M-TAB"))
  (define-key key-translation-map (kbd "C-x C-m") (kbd "M-x"))
  (define-key key-translation-map (kbd "C-x C-d") (kbd "C-x d")))


;;;; VARS
(setq

 ring-bell-function 'ignore

 )


;;;; GLOBAL KEY BINDINGS
(defun tel/fns/global-binds (binds)
  (mapc
   (lambda (bind)
     (global-set-key (kbd (car bind)) (cadr bind)))
   binds))

(tel/fns/global-binds
 (list '("s-<return>" ns-toggle-fullscreen)))

(tel/fns/global-binds
 (list '("C-M-SPC" just-one-space)))

(tel/fns/global-binds
 (list
  '("C-x C-k" kill-region)
  '("C-c n"   cleanup-buffer)
  '("M-i"     back-to-indentation)
  '("M-p"     backward-paragraph)
  '("M-n"     forward-paragraph)))

(tel/fns/global-binds
 (list
  '("RET"          newline-and-indent)
  '("M-RET"        open-next-line)
  '("C-o"          open-line-indent)
  '("M-o"          open-previous-line)
  '("C-M-<return>" new-line-in-between)))

(tel/fns/global-binds
 (list
  '("C-x m" point-to-register)
  '("C-x j" jump-to-register)))

(tel/fns/global-binds
 (list
  '("M-l"     comment-dwim-line)
  '("C-c k"   kill-this-buffer)
  '("C-c C-k" kill-this-buffer)
  '("C-c y"   bury-buffer)))

(tel/fns/global-binds
 (list
  '("C-S-k"   kill-and-retry-line)
  '("C-w"     kill-region-or-backward-word)
  '("C-c C-w" kill-to-beginning-of-line)))

(tel/fns/global-binds
 (list
  '("M-w" save-region-or-current-line)
  '("M-W" copy-whole-lines)))

(tel/fns/global-binds
 (list
  '("C-c d" duplicate-current-line-or-region)))

(tel/fns/global-binds
 (list
  '("C-c C-e" eval-and-replace)))

(tel/fns/global-binds
 (list
  '("C-."   repeat)
  '("M-/"   hippie-expand)
  '("C-M-/" hippie-expand-line)))

(tel/fns/global-binds
 (list
  '("C-s" isearch-forward-regexp)
  '("C-r" isearch-backward-regexp)
  '("C-M-s" isearch-forward)
  '("C-M-r" isearch-backward)))

(tel/fns/global-binds
 (list '("C-M-q" unfill-paragraph)))

(tel/fns/global-binds
 (list
  '("M-%"   query-replace-regexp)
  '("C-M-%" query-replace)))

(tel/fns/global-binds
 (list
  '("M-[" align-regexp)))

(tel/fns/global-binds
 (list
  '("C-c o" occur)
  '("M-s m" multi-occur)
  '("M-s M" multi-occur-in-matching-buffers)))

(tel/fns/global-binds
 (list
  '("C-\'" toggle-quotes)))

(tel/fns/global-binds
 (list
  '("C-x -"   toggle-window-split)
  '("C-x C--" rotate-windows)))

(tel/fns/global-binds
 (list
  '("C-x C-r" rename-current-buffer-and-file)))

(define-key 'help-command "a" 'apropos)


;;;; ADVICE
(defadvice kill-line (after kill-line-cleanup-whitespace activate compile)
  "cleanup whitespace on kill-line"
  (if (not (bolp))
      (delete-region (point) (progn (skip-chars-forward " \t") (point)))))


;;;; HOOKS
(add-hook 'write-file-functions 'time-stamp)


;;;; UTF
(progn
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-selection-coding-system 'utf-8)
  (prefer-coding-system 'utf-8))


;;;; GUI SETTINGS
(when (display-graphic-p)

  (setq-default mac-option-modifier  'super)
  (setq-default mac-command-modifier 'meta)
  (global-set-key [kp-delete] 'delete-char)

  (setq-default mac-pass-command-to-system nil)
  
  (set-face-attribute 'default nil
		      :font "PragmataPro"
		      ))


;;;; DIMINISH
(after "diminish-autoloads"
  (after 'paredit   (diminish 'paredit-mode        " pe"))
  (after 'yasnippet (diminish 'yas-minor-mode      " ys"))
  (after 'undo-tree (diminish 'undo-tree-mode      " ut"))
  (after 'checkdoc  (diminish 'checkdoc-minor-mode " cd"))
  (after 'company   (diminish 'company-mode        " c")))


;;;; HELM
(after 'helm
  (require 'helm-config)

  (helm-mode 1)
  
  (setq helm-ff-auto-update-initial-value nil)
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
  (define-key helm-map (kbd "C-h") (kbd "<DEL>"))
  (define-key helm-map (kbd "C-w") 'subword-backward-kill)
  (define-key helm-map (kbd "M-w") 'helm-yank-text-at-point)
  (define-key helm-map (kbd "C-z")  'helm-select-action)
  (setq helm-quick-update t)
  (setq helm-follow-mode-persistent t)

  (when (executable-find "curl")
    (setq helm-google-suggest-use-curl-p t))

  (setq helm-idle-delay           0.0
	helm-input-idle-delay     0.01
	helm-quick-update         t
	helm-M-x-requires-pattern nil
	helm-ff-skip-boring-files t
	helm-semantic-fuzzy-match t
	helm-imenu-fuzzy-match    t)

  (require 'helm-buffers)
  
  (require 'helm-eshell)
  (add-hook 'eshell-mode-hook
	    #'(lambda ()
		(define-key eshell-mode-map (kbd "C-c C-l")  'helm-eshell-history)))
  (define-key shell-mode-map (kbd "C-c C-l") 'helm-comint-input-ring))

(after 'helm-git-grep
  (define-key helm-git-grep-map (kbd "C-w") 'subword-backward-kill))

(semantic-mode 1)

(tel/fns/global-binds
 (list
  '("C-c h"     helm-mini) 
  '("C-h a"     helm-apropos)
  '("C-x C-i"   helm-semantic-or-imenu)
  '("C-x c SPC" helm-all-mark-rings)
  '("C-x c o"   helm-occur)
  '("C-x c s"   helm-swoop)
  '("C-x f"     helm-for-files)
  '("C-x C-f"   helm-find-files)
  '("C-x C-b"   helm-buffers-list)
  '("M-y"       helm-show-kill-ring)
  '("C-x c g"   helm-google-suggest)
  '("M-x"       helm-M-x)))


;;;; EMACS LISP
(defun imenu-elisp-sections ()
  (setq imenu-prev-index-position-function nil)
  (add-to-list 'imenu-generic-expression '("Sections" "^;;;; \\(.+\\)$" 1) t))

(add-hook 'emacs-lisp-mode-hook 'imenu-elisp-sections)


;;;; YAS SNIPPETS
(after 'yasnippet
  (yas/reload-all)
  (setq yas/prompt-functions '(yas/ido-prompt yas/completing-prompt yas/no-prompt)))

(after "yasnippet-autoloads"
  (add-hook 'prog-mode-hook 'yas-minor-mode))


;;;; ACE-JUMP-MODE
(after "ace-jump-mode-autoloads"
  (tel/fns/global-binds
   (list
    '("C-;"       ace-jump-mode)
    '("C-c C-SPC" ace-jump-mode))))


;;;; FLYCHECK
(after "flycheck-autoloads" (add-hook 'after-init-hook #'global-flycheck-mode))
(after 'flycheck '(flycheck-package-setup))


;;;; UNDO-TREE
(after "undo-tree-autoloads"
  (global-undo-tree-mode t)
  (setq undo-tree-visualizer-relative-timestamps t)
  (setq undo-tree-visualizer-timestamps t))


;;;; AUCTEX
(after 'latex
  (add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
  (add-hook 'LaTeX-mode-hook 'variable-pitch-mode)
  (add-hook 'LaTeX-mode-hook 'TeX-fold-mode)

  (setq TeX-source-correlate-method 'synctex)
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq TeX-save-query nil)
  (setq TeX-item-indent 0)
  (setq TeX-newline-function 'reindent-then-newline-and-indent)
  (setq-default TeX-PDF-mode t)
  ;; (setq-default TeX-master nil)
  ;; (setq LaTeX-command "latex")
  (setq TeX-view-program-list
        '(("Skim"
           "/Applications/Skim.app/Contents/SharedSupport/displayline %n %o %b")))
  (setq TeX-view-program-selection '((output-pdf "Skim")))

  ;; (add-hook 'LaTeX-mode-hook 'longlines-mode)
  (add-hook 'LaTeX-mode-hook 'flyspell-mode)
  (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
  (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
  (setq reftex-plug-into-AUCTeX t)
  (define-key TeX-mode-map (kbd "C-M-h") 'mark-paragraph)
  (define-key TeX-mode-map (kbd "C-c C-m") 'TeX-command-master)
  (define-key TeX-mode-map (kbd "C-c C-c") 'TeX-compile))

(after 'reftex
  (add-to-list 'reftex-section-prefixes '(1 . "chap:")))


;;;; MAGIT
(global-set-key (kbd "C-x g") 'magit-status)

(defun magit-toggle-whitespace ()
  (interactive)
  (if (member "-w" magit-diff-options)
      (magit-dont-ignore-whitespace)
    (magit-ignore-whitespace)))

(defun magit-ignore-whitespace ()
  (interactive)
  (add-to-list 'magit-diff-options "-w")
  (magit-refresh))

(defun magit-dont-ignore-whitespace ()
  (interactive)
  (setq magit-diff-options (remove "-w" magit-diff-options))
  (magit-refresh))

(defun magit-quit-session ()
  "Restore the previous window configuration and kill the magit buffer."
  (interactive)
  (kill-buffer)
  (jump-to-register :magit-fullscreen))

(after 'magit
  (define-key magit-status-mode-map (kbd "W") 'magit-toggle-whitespace)
  (define-key magit-status-mode-map (kbd "q") 'magit-quit-session))


;;;; HASKELL
(after "haskell-mode-autoloads"
  (add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
  
  (define-key haskell-mode-map (kbd "C-,") 'haskell-move-nested-left)
  (define-key haskell-mode-map (kbd "C-.") 'haskell-move-nested-right)
  
  (add-hook 'haskell-mode-hook 'turn-on-haskell-decl-scan)

  (define-key haskell-mode-map (kbd "C-c C-c") 'haskell-compile)
  (define-key haskell-mode-map (kbd "C-d")     'company-complete-common)
  
  (progn
    (define-key haskell-mode-map (kbd "C-x C-d") nil)
    (define-key haskell-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
    (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-file)
    (define-key haskell-mode-map (kbd "C-c C-b") 'haskell-interactive-switch)
    (define-key haskell-mode-map (kbd "C-c C-t") 'haskell-process-do-type)
    (define-key haskell-mode-map (kbd "C-c C-i") 'haskell-process-do-info)
    (define-key haskell-mode-map (kbd "C-c M-.") nil)
    (define-key haskell-mode-map (kbd "C-c C-d") nil))

  (progn
    (define-key haskell-mode-map [f8]        'haskell-navigate-imports)
    (define-key haskell-mode-map (kbd "SPC") 'haskell-mode-contextual-space))

  (add-hook 'haskell-mode-hook (lambda () (ghc-init)))

  (custom-set-variables
   '(haskell-process-suggest-remove-import-lines t)
   '(haskell-process-auto-import-loaded-modules  t)
   '(haskell-process-log                         t)
   '(haskell-process-type                        'cabal-repl)
   '(haskell-compile-cabal-build-alt-command
     "cd %s; nix-shell --pure; cabal configure; cabal build --ghc-option=-ferror-spans")))

(after "company-mode-autoloads"
  (add-to-list 'company-backends 'company-ghc)
  (custom-set-variables '(company-ghc-show-info t)))

(after "haskell-cabal-autoloads"
  (define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-compile))


;;;; DEFT
(tel/fns/global-binds
 (list
  '("C-x d" deft)))

(after 'deft
  (setq deft-directory (expand-file-name "~/Dropbox/notes"))
  (setq deft-text-mode 'markdown-mode)
  (setq deft-use-filename-as-title t))


;;;; PAREDIT
(after "paredit-autoloads"

  ;; Enable `paredit-mode' in the minibuffer, during `eval-expression'.
  (defun conditionally-enable-paredit-mode ()
    (if (eq this-command 'eval-expression)
        (paredit-mode 1)))

  (add-hook 'minibuffer-setup-hook 'conditionally-enable-paredit-mode)

  (add-hook 'emacs-lisp-mode-hook 'paredit-mode)
  (add-hook 'clojure-mode-hook 'paredit-mode))


;;;; C MODE
(setq c-cleanup-list '(defun-close-semi
                        list-close-comma
                        scope-operator
                        compact-empty-funcall
                        comment-close-slash)
      c-default-style '((c-mode . "cc-mode")
                        (c++-mode . "cc-mode")
                        (java-mode . "java")
                        (awk-mode . "awk")
                        (other . "gnu"))
      c-offsets-alist '((substatement-open . 0)))

(defun mp-add-c-mode-bindings ()
  (local-set-key (kbd "C-c o") 'ff-find-other-file)
  (local-set-key (kbd "C-c C-m") 'compile-make))

(add-hook 'c-mode-common-hook 'mp-add-c-mode-bindings)


;;;; COMPANY
(after 'company
  (require 'company)
  (add-hook 'after-init-hook 'global-company-mode)
  
  (add-to-list 'company-backends 'company-capf)
  (setq company-frontends '(company-pseudo-tooltip-frontend company-echo-metadata-frontend))
  (setq company-idle-delay 0.1)
  (setq company-begin-commands '(self-insert-command))
  (define-key company-active-map (kbd "C-w") nil))

(tel/fns/global-binds
 (list
  '("C-d" company-complete-common)))

;;;; AUTO-COMPLETE
(after 'auto-complete
  (setq ac-auto-show-menu .1)
  (setq ac-use-menu-map t)
  (setq ac-disable-inline t)
  (setq ac-candidate-menu-min 0)
  (add-to-list 'ac-dictionary-directories "~/.emacs.d/dict"))

(after 'auto-complete-config
  ;; (ac-config-default)
  (add-hook 'ein:notebook-multilang-mode-hook 'auto-complete-mode)
  (setq-default ac-sources (append '(ac-source-yasnippet ac-source-imenu) ac-sources)))

(after "auto-complete-autoloads"
  (require 'auto-complete-config))


;;;; MMM-MODE
(after "mmm-mode-autoloads"
  (require 'mmm-auto)
  (setq mmm-global-mode 'maybe)
  (mmm-add-mode-ext-class 'html-mode "\\.html\\'" 'html-js)
  (mmm-add-mode-ext-class 'html-mode "\\.html\\'" 'embedded-css))


;;;; NXHTML
(after "nxhtml-autoloads"
  (autoload 'django-html-mumamo-mode
    (expand-file-name "autostart.el"
                      (file-name-directory (locate-library "nxhtml-autoloads"))))
  (setq auto-mode-alist
        (append '(("\\.html?$" . django-html-mumamo-mode)) auto-mode-alist))
  (setq mumamo-background-colors nil)
  (add-to-list 'auto-mode-alist '("\\.html$" . django-html-mumamo-mode)))


;;;; DEFUN
(defun untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))

(defun tabify-buffer ()
  (interactive)
  (tabify (point-min) (point-max)))

(defun indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun cleanup-buffer-safe ()
  "Perform a bunch of safe operations on the whitespace content of a buffer.
Does not indent buffer, because it is used for a before-save-hook, and that
might be bad."
  (interactive)
  (untabify-buffer)
  (delete-trailing-whitespace)
  (set-buffer-file-coding-system 'utf-8))

(defun cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer.
Including indent-buffer, which should not be called automatically on save."
  (interactive)
  (cleanup-buffer-safe)
  (indent-buffer))

(defun open-next-line (arg)
  "Move to the next line and then opens a line.
    See also `newline-and-indent'."
  (interactive "p")
  (end-of-line)
  (newline-and-indent))

(defun open-line-indent (n)
  "Insert a new line and leave point before it. With arg N insert N newlines."
  (interactive "*p")
  (save-excursion
    (newline n)
    (indent-according-to-mode)))

(defun open-previous-line (arg)
  "Open a new line before the current one.
     See also `newline-and-indent'."
  (interactive "p")
  (when (eolp)
    (save-excursion
      (delete-region (point)
                     (progn (skip-chars-backward " \t") (point)))))
  (beginning-of-line)
  (open-line arg)
  (indent-according-to-mode))

(defun new-line-in-between ()
  (interactive)
  (newline)
  (save-excursion
    (newline)
    (indent-for-tab-command))
  (indent-for-tab-command))

(defun kill-region-or-backward-word (arg)
  "kill region if active, otherwise kill backward word"
  (interactive "p")
  (if (region-active-p)
      (kill-region (region-beginning) (region-end))
    (call-interactively (key-binding (kbd "M-<DEL>")) t (this-command-keys-vector))))

(defun kill-to-beginning-of-line ()
  (interactive)
  (kill-region (save-excursion (beginning-of-line) (point))
               (point)))

(defun kill-and-retry-line ()
  "Kill the entire current line and reposition point at indentation"
  (interactive)
  (back-to-indentation)
  (kill-line))

(defun copy-to-end-of-line ()
  (interactive)
  (kill-ring-save (point)
                  (line-end-position))
  (message "Copied to end of line"))

(defun copy-whole-lines (arg)
  "Copy ARG lines to the kill ring"
  (interactive "p")
  (kill-ring-save (line-beginning-position)
                  (line-beginning-position (+ 1 arg)))
  (message "%d line%s copied" arg (if (= 1 arg) "" "s")))

(defun copy-line (arg)
  "Copy to end of line, or ARG lines."
  (interactive "P")
  (if (null arg)
      (copy-to-end-of-line)
    (copy-whole-lines (prefix-numeric-value arg))))

(defun save-region-or-current-line (arg)
  (interactive "P")
  (if (region-active-p)
      (kill-ring-save (region-beginning) (region-end))
    (copy-line arg)))

(defun unfill-paragraph ()
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

(defun comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command.
   If no region is selected and current line is not blank and we
   are not at the end of the line, then comment current line.
   Replaces default behaviour of comment-dwim, when it inserts
   comment at the end of the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (not (region-active-p))
      (comment-or-uncomment-region
       (line-beginning-position) (line-end-position))
    (comment-dwim arg)))

(defun duplicate-current-line-or-region (arg)
  "Duplicates the current line or region ARG times.
If there's no region, the current line will be duplicated."
  (interactive "p")
  (save-excursion
    (if (region-active-p)
        (duplicate-region arg)
      (duplicate-current-line arg))))

(defun duplicate-region (num &optional start end)
  "Duplicates the region bounded by START and END NUM times.
If no START and END is provided, the current region-beginning and
region-end is used."
  (interactive "p")
  (let* ((start (or start (region-beginning)))
         (end (or end (region-end)))
         (region (buffer-substring start end)))
    (goto-char start)
    (dotimes (i num)
      (insert region))))

(defun duplicate-current-line (num)
  "Duplicate the current line NUM times."
  (interactive "p")
  (when (eq (point-at-eol) (point-max))
    (goto-char (point-max))
    (newline)
    (forward-char -1))
  (duplicate-region num (point-at-bol) (1+ (point-at-eol))))

(defun eval-and-replace ()
  "Replace the preceding sexp with its value."
  (interactive)
  (backward-kill-sexp)
  (condition-case nil
      (prin1 (eval (read (current-kill 0)))
             (current-buffer))
    (error (message "Invalid expression")
           (insert (current-kill 0)))))

(defun hippie-expand-line ()
  (interactive)
  (let ((hippie-expand-try-functions-list '(try-expand-line
                                            try-expand-line-all-buffers)))
    (hippie-expand nil)))

(defun current-quotes-char ()
  (nth 3 (syntax-ppss)))

(defalias 'point-is-in-string-p 'current-quotes-char)

(defun move-point-forward-out-of-string ()
  (while (point-is-in-string-p) (forward-char)))

(defun move-point-backward-out-of-string ()
  (while (point-is-in-string-p) (backward-char)))

(defun alternate-quotes-char ()
  (if (eq ?' (current-quotes-char)) ?\" ?'))

(defun toggle-quotes ()
  (interactive)
  (if (point-is-in-string-p)
      (let ((old-quotes (char-to-string (current-quotes-char)))
            (new-quotes (char-to-string (alternate-quotes-char)))
            (start (make-marker))
            (end (make-marker)))
        (save-excursion
          (move-point-forward-out-of-string)
          (backward-delete-char 1)
          (set-marker end (point))
          (insert new-quotes)
          (move-point-backward-out-of-string)
          (delete-char 1)
          (insert new-quotes)
          (set-marker start (point))
          (replace-string new-quotes (concat "\\" new-quotes) nil start end)
          (replace-string (concat "\\" old-quotes) old-quotes nil start end)))
    (error "Point isn't in a string")))

(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

(defun rotate-windows ()
  "Rotate your windows"
  (interactive)
  (cond ((not (> (count-windows)1))
         (message "You can't rotate a single window!"))
        (t
         (setq i 1)
         (setq numWindows (count-windows))
         (while  (< i numWindows)
           (let* (
                  (w1 (elt (window-list) i))
                  (w2 (elt (window-list) (+ (% i numWindows) 1)))

                  (b1 (window-buffer w1))
                  (b2 (window-buffer w2))

                  (s1 (window-start w1))
                  (s2 (window-start w2))
                  )
             (set-window-buffer w1  b2)
             (set-window-buffer w2 b1)
             (set-window-start w1 s2)
             (set-window-start w2 s1)
             (setq i (1+ i)))))))
