# wacom tablet icon for eww

![Bash Script](https://img.shields.io/badge/bash_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)

Wacom plugin for eww

Requires aur/wacom-settings-git for the tablet configuration panel, don't forget to install it from paru or yay .

To install, run: 

```bash
git clone --depth 1 https://github.com/miauware/wacom-eww.git
cd wacom-eww
chmod +x install.sh
./install.sh install 
```

add in your yuck eww configuration file:


```lisp
(defvar wacom_connected false)
;; INFO: Display PNG icon for Wacom tablet connection status
(defwidget wacom_widget []
  (box :orientation "v" :halign "center"
       :visible wacom_connected
    (button :class "trayicon wacom-icon"
            :style "background-image: url('/opt/wacom-eww/wacom.png'); background-size: contain; background-repeat: no-repeat;"
            :tooltip "Wacom tablet connected"
            :onrightclick "wacom-settings &")))
```

and call the function in the part of the bar where you want the icon to appear with :
```lisp
(wacom_widget)
```
