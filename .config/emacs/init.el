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
(customize-set-variable 'default-frame-alist
    '(
      (width . 120)
      (height . 40)
      (top . 0)
      (left . 0)
      (font . "-*-Cica-normal-normal-normal-*-16-*-*-*-m-0-iso10646-1")))

(provide 'init)
