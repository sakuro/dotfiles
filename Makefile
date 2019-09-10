.config/bat/themes/Nord.tmTheme:
	curl -so $@ https://raw.githubusercontent.com/arcticicestudio/nord-sublime-text/8d01b8860622c81758bba3aa12e0809526c240e1/Nord.tmTheme
	bat cache --build
