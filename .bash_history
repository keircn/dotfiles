wget https://st.suckless.org/patches/scrollback/st-scrollback-float-0.9.2.diff
mv st-scrollback-float-0.9.2.diff 03-st-scrollback-float-0.9.2.diff
ls
wget https://st.suckless.org/patches/scrollback/st-scrollback-mouse-0.9.2.diff
mv st-scrollback-mouse-0.9.2.diff 04-st-scrollback-mouse-0.9.2.diff
ls
wget https://st.suckless.org/patches/scrollback/st-scrollback-mouse-altscreen-20220127-2c5edf2.diff
mv st-scrollback-mouse-altscreen-20220127-2c5edf2.diff 05-st-scrollback-mouse-altscreen-20220127-2c5edf2.diff 
ls
wget https://st.suckless.org/patches/alpha/st-alpha-20240814-a0274bc.diff
mv st-alpha-20240814-a0274bc.diff 06-st-alpha-20240814-a0274bc.diff
ls
wget https://st.suckless.org/patches/boxdraw/st-boxdraw_v2-0.8.5.diff
mv st-boxdraw_v2-0.8.5.diff 07-st-boxdraw_v2-0.8.5.diff
wget https://st.suckless.org/patches/clickurl/st-clickurl-0.8.5.diff
mv st-clickurl-0.8.5.diff 08-st-clickurl-0.8.5.diff
rm 08-st-clickurl-0.8.5.diff 
wget https://st.suckless.org/patches/clickurl-nocontrol/st-clickurl-nocontrol-0.9.2.diff
mv st-clickurl-nocontrol-0.9.2.diff 08st-clickurl-nocontrol-0.9.2.diff
mv 08st-clickurl-nocontrol-0.9.2.diff 08-st-clickurl-nocontrol-0.9.2.diff 
cd ..
git apply patches
git apply patches/01-st-scrollback-ringbuffer-0.9.2.diff 
git apply patches/02-st-scrollback-float-0.9.2.diff 
git apply patches/03-st-scrollback-float-0.9.2.diff 
git apply patches/03-st-scrollback-float-0.9.2.diff --rejecte 
git apply patches/03-st-scrollback-float-0.9.2.diff --reject
vim config.def.h.rej 
vim config.def.h
rm config.def.h.rej 
git status
git apply patches/04-st-scrollback-mouse-0.9.2.diff --reject
git apply patches/05-st-scrollback-mouse-altscreen-20220127-2c5edf2.diff --reject
git apply patches/06-st-alpha-20240814-a0274bc.diff --reject
vim x.c.rej 
vim x.c.rej
vim x.c.rej
vim x.c
vim x.c.rej
vim x.c
rm x.c.rej 
sudo make clean install
git apply patches/07-st-boxdraw_v2-0.8.5.diff --reject
vim st.c.rej 
vim st.c.rej 
vim st.c
vim st.c.rej 
vim st.c
vim st.c.rej 
vim st.c
vim st.c.rej 
rm st.c.rej 
git apply patches/08-st-clickurl-nocontrol-0.9.2.diff --reject
vim x.c.rej 
vim x.c.rej 
vim x.c
vim x.c
vim st.h.rej 
vim st.h
vim st.h.rej 
vim st.h
vim st.h.rej 
vim st.h
vim st.h.rej 
vim st.h
vim st.h
vim st.h.rej 
vim st.h
vim st.h.rej 
vim st.h
vim st.h.rej 
vim st.h
vim st.h.rej 
rm st.h.rej 
git status
vim Makefile.rej 
vim Makefile.rej 
vim Makefile
git status
rm Makefile.rej 
vim st.c.rej 
vim st.c
vim st.c.rej 
vim st.c
vim st.c.rej 
vim st.c
vim st.c.rej 
rm st.c.rej 
vim x.c.rej 
vim x.c
vim x.c.rej 
vim x.c
git status
vim x.c.rej 
rm x.c.rej 
git status
ls patches/
sudo make clean install
sudo xbps-install freetype2
sudo xbps-install freetype
sudo xbps-install opencode
curl -fsSL https://opencode.ai/install | bash
sudo make clean install
opencode
source ~/.bashrc
opencode
vim Makefile 
sudo make clean install
opencode
sudo make clean install
opencode -c
rm config.h
sudo make clean install
opencode -c
sudo make clean install
ls
cat ~/.bash_history 
cd git/st/
ls
vim config.def.h
git status
make clean
git status
rm config.h
git status
cd ..
cd ..
cd git/st/
opencode -c
vim config.def.h
vim ~/.Xresources 
vim config.def.h
sudo make clean install
ls
sudo xbps-query -s mono
sudo xbps-query -s font
ls /usr/local/share/fonts
ls /usr/share/fonts/
ls /usr/share/fonts/TTF/
ls /usr/share/fonts/X11/TTF/
mkdir .local/share/fonts
cd Downloads/
ls
rm gtk*
rm rose-pine-icons.tar.gz 
ls
mv CommitMono.zip ~/.local/share/fonts/
cd ~/.local/share/fonts/
ls
unzip -d CommitMono CommitMono.zip 
sudo xbps-install unzip
unzip -d CommitMono CommitMono.zip 
rm CommitMono.zip 
ls CommitMono/
cd ~
cd git/st/
vim config.def.h 
rm config.h 
sudo make clean install
ls
ls .local/share/fonts/
ls .local/share/fonts/CommitMono/
cd git/st/
vim config.def.h 
sudo make clean install
ls
cd git/st/
rm config.h
sudo make clean install
ls
cd git/st/
opencode- c
opencode -c
cd git/st/
opencode -c
cd git/st/
opencode -c
git status
sudo make clean install
rm config.h st-local
sudo make clean install
git clone https://github.com/keircn/dotfiles.git .dotfiles
cd .dotfiles/
ls
cp git/.gitconfig ~/.gitconfig
vim ~/.gitconfig 
cd ..
cd git/st
git status
make clean
rm config.h
git status
git add .
git commit -m 'add patches'
https://github.com
https://github.com
cd git/st/
opencode -c
./st
opencode -c
vim ~/.xinitrc 
cd git/st/
ls
cat patches/08-st-clickurl-nocontrol-0.9.2.diff 
opencode -c
ls
make clean
git status
rm patches/08-st-clickurl-nocontrol-0.9.2.diff 
rm config.h
git status
sudo make clean install
git add .
git commit -m 'unapply st-clickurl-nocontrol'
cd
ls
sudo xbps-install arrpc-bun
arrpc-bun
fastfetch
arrpc-bun 
sudo xbps-install -Su
ls
btop
htop
to
top
sudo xbps-install btop
btop
btop
btop
btop
btop
cd git/st/
ls
opencode
make clean
rm config.h
sudo make clean install
opencode -c
btop
btop
cd git/st
gdb -ex run -ex bt ./st
sudo xbps-install gdb
gdb -ex run -ex bt ./st
btop
btop
btop
pkill st
cd git/st
./st
make clean && CFLAGS="-g -O0" make
gdb -ex run -ex "bt full" -ex "frame 2" -ex "info locals" ./st
gdb -ex run -ex "bt full" -ex "frame 2" -ex "info locals" ./st 2&>1 > crash.log
cd git/ope
cd git/st/
opencode -c
make clean
vim Makefile 
make clean
sudo make clean install
opencode -c
btop
cd git/st
ls
cat crash.log 
vim crash.log 
cat crash.log 
cat crash.log | xclip -i
opencode -c
cd git/st
cat crash.log 
cat crash.log | xclip -i
cat crash.log | xclip -sel copy
opencode -c
cd git/st
opencode -c
btop
cd git/st/
opencode --help
opencode -c
sudo make clean install
./st
opencode -c
btop
btop
btop
sudo xbps-query electron
sudo xbps-install electron41
sudo xbps-install electron40
sudo xbps-install electron39
sudo xbps-install electron38
sudo xbps-install electron36
sudo xbps-query -s electron
sudo xbps-query electron35
ls
ls git/
exit
ls Downloads/
mkdir /usr/share/backgrounds
sudo mkdir /usr/share/backgrounds
cp Downloads/block-wave-moon.png /usr/share/ba
cp Downloads/block-wave-moon.png /usr/share/backgrounds/
sudo cp Downloads/block-wave-moon.png /usr/share/backgrounds/
sudo xbps-install feh
man feh
feh /usr/share/backgrounds/block-wave-moon.png 
feh /usr/share/backgrounds/block-wave-moon.png --help
feh -b /usr/share/backgrounds/block-wave-moon.png
feh --bg-fill /usr/share/backgrounds/block-wave-moon.png
ls -A
vim ~/.xinitrc
cp Downloads/769151.jpg /usr/share/backgrounds/kurisu-feris.jpg
sudo cp Downloads/769151.jpg /usr/share/backgrounds/kurisu-feris.jpg
feh --bg-fill /usr/share/backgrounds/kurisu-feris.jpg
feh --help | less
feh --bg-scale /usr/share/backgrounds/kurisu-feris.jpg
feh --bg-max /usr/share/backgrounds/kurisu-feris.jpg
sudo cp Downloads/771418.jpg /usr/share/backgrounds/chaos-head-rimi.jpg
feh --bg-fill /usr/share/backgrounds/chaos-head-rimi.jpg 
rm Downloads/769151.jpg Downloads/771418.jpg Downloads/block-wave-moon.png Downloads/image.png 
ls
ssh root@192.168.1.10
startx
startx
startx
startx
startx
startx
startx
startx
startx
startx
startx
startx
startx
fastfetch
sudo xbps-install -Syu
reboot
sudo reboot
sudo xbps-install moonlight
ls
ls Downloads/
cd Downloads/
chmod +x Moonlight-6.1.0-x86_64.AppImage 
./Moonlight-6.1.0-x86_64.AppImage 
sudo xbps-install qt
sudo xbps-install -S libxcb xcb-util-wm xcb-util-image xcb-util-keysyms xcb-util-renderutil
./Moonlight-6.1.0-x86_64.AppImage 
QT_DEBUG_PLUGINS=1 ./Moonlight-6.1.0-x86_64.AppImage
sudo xbps-install -S libgpg-error
./Moonlight-6.1.0-x86_64.AppImage 
startx
ls
startx
wine
sudo pacman -S wine-staging
sudo xbps-install wine-staging
sudo xbps-install wine
ls Downloads/
cd Downloads/
rm Moonlight-6.1.0-x86_64.AppImage 
unzip -l dimension-69-linux.zip 
unzip dimension-69-linux.zip -d dimension-69
ls
rm dimension-69-linux.zip 
cd dimension-69/
ls
./Dimension69.x86_64 
sudo xbps-install v
sudo xbps-query vlang
sudo xbps-query -s vlang
sudo xbps-query -S vlang
sudo xbps-query v
sudo xbps-query c
man xbps-query
sudo xbps-query -s gcc
sudo xbps-query -s v
sudo xbps-query -s vlang
sudo xbps-query -s vc
sudo xbps-query -s v
sudo xbps-install palemoon
sudo xbps-install pale-moon
sudo xbps-query -s pale
sudo xbps-query -s firefox
sudo xbps-query -s "web browser"
sudo xbps-query -s browser
cd Downloads/
ls
tar -xzf palemoon-34.1.0.linux-x86_64-gtk3.tar.xz 
tar -Jf palemoon-34.1.0.linux-x86_64-gtk3.tar.xz 
tar --help
tar --usage
tar --help
tar --help | less
tar -tJf palemoon-34.1.0.linux-x86_64-gtk3.tar.xz 
sudo xbps-install xz
sudo xbps-install -Syu xz
tar -tJf palemoon-34.1.0.linux-x86_64-gtk3.tar.xz 
tar -xJf palemoon-34.1.0.linux-x86_64-gtk3.tar.xz 
ls
rm palemoon-34.1.0.linux-x86_64-gtk3.tar.xz 
ls palemoon/
sudo mv palemoon /opt/
sudo ln /opt/palemoon/palemoon /usr/local/bin/
palemoon
sudo rm /usr/local/bin/palemoon 
sudo vim /usr/local/bin/pale
pale
sudo chmod +x /usr/local/bin/pale 
sudo vim /usr/local/bin/pale
pale
sudo xbps-install dbus
pale
sudo xbps-remove dbus
sudo xbps-install libdbus-glib
sudo xbps-install glib
sudo xbps-query -s glib
sudo xbps-install glib-devel
pale
sudo xbps-remove glib-devel
sudo xbps-install dbus-glib
pale
sudo xbps-install xdg
sudo xbps-install xdg-open
sudo xbps-query -s xdg
sudo xbps-query -s open
open :https://google.com"
open "https://google.com"
cp /usr/share/applications/firefox.desktop ~/.local/share/applications/pale.desktop
vim ~/.local/share/applications/pale.desktop 
sudo vim /usr/local/bin/pale 
ls
cd
ls
cd .local/share/icons
cd .local/sharea
cd .local/share
mkdir icons
ls /usr/share/icons/
ls /usr/share/icons/hicolor/
ls /usr/share/icons/locolor/
ls icons/
cd icons/
mkdir hicolor
cd hicolor/
mkdir 256x256
cd 256x256/
mkdir apps/
cd apps/
mkdir palemoon
cd palemoon/
wget https://repo.palemoon.org/MoonchildProductions/Pale-Moon/raw/branch/master/palemoon/branding/official/default256.png
cd ..
cd ..
cd ..
mkdir 16x16
cd 16x16/
mkdir -p apps/palemoon
cd apps/palemoon/
wget https://repo.palemoon.org/MoonchildProductions/Pale-Moon/raw/branch/master/palemoon/branding/official/default16.png
cd ..
ls
ls palemoon/
cd ..
ls /usr/share/icons/hicolor/256x256/apps/firefox.png 
ls
mv apps/palemoon/default16.png apps/palemoon.png
ls
ls apps/
rmdir apps/palemoon
cd ..
cd 256x256/
ls
mv apps/palemoon/default256.png apps/palemoon.png
rmdir apps/palemoon
ls /usr/share/icons/
ls /usr/share/icons/hicolor/
ls /usr/share/icons/hicolor/scalable/
ls /usr/share/icons/hicolor/scalable/apps/
ls /usr/share/icons/hicolor/
ls /usr/share/icons/hicolor/256x256/
ls /usr/share/icons/hicolor/256x256/apps/
startx
ls
mkdir code
cd code/
l
lsblk
ls
cd Downloads/w
cd Downloads/
ls
dd bs=4M if=archlinux-2026.03.01-x86_64.iso of=/dev/sdb conv=fsync oflag=direct status=progress
sudo dd bs=4M if=archlinux-2026.03.01-x86_64.iso of=/dev/sdb conv=fsync oflag=direct status=progress
sync
sudo sync
exit
startsx
startx
