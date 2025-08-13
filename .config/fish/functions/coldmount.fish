function coldmount
    sudo mount -t cifs //192.168.1.78/cold/ /mnt/cold \
        -o credentials=/home/keiran/.config/smb/credentials,uid=(id -u),gid=(id -g)
end
