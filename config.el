;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Duy Le"
      user-mail-address "")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;; search project in path non-recursively, only show folder inside "Code" 1 level
;; (setq projectile-project-search-path '("~/Code/")
;;
;; search project in path recursively, show all folder inside "Code" multiple levels
(setq projectile-project-search-path (cddr (directory-files "~/Code" t)))

(use-package! lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-idle-delay 0.2
        lsp-enable-file-watchers nil)
  )

(use-package! lsp-ui
  :commands lsp-ui-mode
  :config
  (setq lsp-headerline-breadcrumb-enable t ; Hiển thị đường dẫn file
        lsp-lens-enable t
        )
  :bind (:map lsp-ui-mode-map
         ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
         ([remap xref-find-references] . lsp-ui-peek-find-references)
         ([remap xref-pop-marker-stack] . lsp-ui-peek-jump-backward)
         ))

(use-package! go-mode)
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; Start LSP Mode and YASnippet mode
(add-hook 'go-mode-hook #'lsp-deferred)
(add-hook 'go-mode-hook #'yas-minor-mode)

(use-package! typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))

(defun lsp-typescript-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'typescript-mode-hook #'lsp-typescript-install-save-hooks)

(use-package! js2-mode
  :mode "\\.js\\'"
  :hook (js2-mode . lsp-deferred))

(use-package! python-mode
  :hook (python-mode . lsp-deferred)
  :custom
  (python-shell-interpreter "python3")
  (dap-python-executable "python3")
  (dap-python-debugger 'debugpy)
  :config
  (require 'dap-python))

(use-package! pyvenv
  :config
  (pyvenv-mode 1))

(use-package! protobuf-mode)

;; config for dap mode
(use-package! dap-mode
  :config
  (dap-ui-mode 1)
  (dap-ui-many-windows-mode 1)
  (dap-tooltip-mode 1)
  (require 'dap-go)
  ;; (dap-go-setup 1)
  (require 'dap-node)
  ;; (dap-node-setup 1)
  ;; (require 'dap-python)
  ;; (dap-python-setup 1)
  )

(use-package! org
  :config
  (setq org-ellipsis " ▾"))

(use-package! org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

;; Treemacs
(defface custom-line-highlight '((t (:background "#f2f2f2" :extend t))) "")
(add-hook
 'treemacs-mode-hook
 (defun channge-hl-line-mode ()
   (setq-local hl-line-face 'custom-line-highlight)
   (overlay-put hl-line-overlay 'face hl-line-face)
   (treemacs--setup-icon-background-colors)))


;; Engine mode
(use-package! engine-mode
  :config
  (engine/set-keymap-prefix (kbd "C-c s"))
  (setq ;; browse-url-browser-function 'browse-url-default-macosx-browser ;; for macosx
        ;; engine/browser-function 'browse-url-default-macosx-browser ;; for macosx
        engine/browser-function 'browse-url-chrome
        )

  ;; Code Overflow
  (defengine github
    "https://github.com/search?ref=simplesearch&q=%s"
    :keybinding "h")
  (defengine stack-overflow
    "https://stackoverflow.com/search?q=%s"
    :keybinding "s")

  ;; Node Package Manager
  (defengine npm
    "https://www.npmjs.com/search?q=%s"
    :keybinding "n")

  ;; Rust Package Management
  (defengine crates
    "https://crates.io/search?q=%s"
    :docstring "Crates Package Management for Rust"
    :keybinding "cc")
  (defengine rust-std
    "https://doc.rust-lang.org/std/?search=%s"
    :keybinding "cs")

  ;; Languages
  (defengine translate
    "https://translate.google.com/?sl=en&tl=vi&text=%s&op=translate"
    :keybinding "t")
  (defengine cambridge
    "https://dictionary.cambridge.org/vi/dictionary/english/%s"
    :keybinding "e")


  ;; Social
  (defengine youtube
    "http://www.youtube.com/results?aq=f&oq=&search_query=%s"
    :keybinding "y")

  ;; Search
  (defengine google
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q=%s"
    :keybinding "g")
  (defengine duckduckgo
    "https://duckduckgo.com/?q=%s"
    :keybinding "d")

  (engine-mode 1))
