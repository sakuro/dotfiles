(customize-set-variable
 'package-archives '(("gnu"   . "https://elpa.gnu.org/packages/")
                     ("melpa" . "https://melpa.org/packages/")
                     ("org"   . "https://orgmode.org/elpa/")))


(package-initialize)
(unless (package-installed-p 'leaf)
  (package-refresh-contents)
  (package-install 'leaf))

(leaf leaf-keywords
  :ensure t
  :init
  :config
  (leaf-keywords-init))

(customize-set-variable 'custom-file (locate-user-emacs-file "custom.el"))
(customize-set-variable 'inhibit-startup-message t)

(provide 'init)
