# Fancy Bash Prompt for Git local repositories

## How to install it

* If you are on the current git repo folder in your machine, copy the `.git-functions.sh` file on `/home/$YOUR-USER` using the file system GUI or using the terminal with:
    ```
    $ cp .git-functions.sh ~/.git-functions.sh
    ```

* Now we have to make a backup of your original `~/.bashrc` file, you can make it with:
    ```
    $ cp ~/.bashrc ~/.bashrc.backup
    ```

* Open the file `~/.bashrc` with you desired text editor and replace the existing lines with these next:
    ```
    ...
    # Adding the git functions
    . ~/.git-functions.sh

    if [ "$color_prompt" = yes ]; then
        BRANCH1='\[\033[01;31m\]$(parse_git_branch)\[\033[00m\]\'
        BRANCH2='$(git-status-upstream)''$(git-multiline-status-prompt)'
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]'
        PS1=${PS1%?}\n
        PS1=${BRANCH2}\\n${PS1}'$ ' 
    else
        PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    fi
    ...
    ```
* Now you will be able to see the fancy bash prompt for local git repositories.