# Fancy Bash Prompt for Git local repositories

## Content of this repo

* [How to install my custom git prompt - Linux](#how-to-install-it)
* [How to install and configure Oh my Zsh - macOS](#oh-my-zsh-macos)
* [How to install Bash Git Prompt - Linux](#bash-git-prompt-linux)

## **How to install it**
* If you are on the current git repo folder in your machine, copy the `.git-functions.sh` file on `/home/$YOUR-USER` using the file system GUI or using the terminal with:
    ```shell
    $ cp .git-functions.sh ~/.git-functions.sh
    ```

* Now we have to make a backup of your original `~/.bashrc` file, you can make it with:
    ```shell
    $ cp ~/.bashrc ~/.bashrc.backup
    ```

* Open the file `~/.bashrc` with you desired text editor and replace the existing lines with these next:
    ```shell
    ...
    # Adding the git functions
    . ~/.git-functions.sh

    if [ "$color_prompt" = yes ]; then
        GITBASH='$(prompt-timing-right)$(git-status-upstream)$(git-multiline-status-prompt)'
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;35m\]\u:\[\033[01;34m\]\w\[\033[00m\]\'
        PS1=${PS1%?}
        PS1=${PS1%?}\n"\[\033[01;31m\][\[\033[01;33m\]\A \[\033[01;32m\]\D{%F}\[\033[01;37m\]\[\033[01;31m\]]"'\[\033[01;37m\]'
        PS1=${GITBASH}\\n${PS1}'$\[\033[00m\] '
    else
        PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    fi
    ...
    ```
* In order to have updated all the repos that we have in our local machine we need to create a job in `cron` program, for that we need to open that program with the next steps

    * If is the first time you run `cron` you will be prompted as follows:
        ```shell
        $ crontab -e
        no crontab for $YOUR-USER - using an empty one

        Select an editor.  To change later, run 'select-editor'.
        1. /bin/ed
        2. /bin/nano        <---- easiest
        3. /usr/bin/code
        4. /usr/bin/vim.tiny

        Choose 1-4 [2]: 2
        ```
    * Once we selected our prefered CLI text editor we must append this next line:
        ```shell
        */1 *   *   *   *     manuelperez; /usr/bin/find ~ -name ".git" -execdir /usr/bin/git fetch > /home/manuelperez/.log-git-fetcher.log \;
        ```
        That above line will make `git fetch` in all the local repos we have every minute in order to know if we are **behind** or **ahead** from **remote**.

        To store your Github credentials please run the next command:
        ```shell
        $ git config --global credential.helper store
        ```

* Now you will be able to see the fancy bash prompt for local git repositories as follows:

    <img src="./img/img3.png" width=45%>

## **Oh my Zsh [MacOS]**
* I started to use a hackintosh PC, so I tried to use this repo to customize the Terminal with no luck, but I found the [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) project, a framework to configurate and customize the `zsh` Terminal in MacOS.
* I tried to build a new zsh theme based in the already installed theme called `apple`, you can find it [here](manutheme.zsh-theme).
* To "install" it, please go to ` ~/.oh-my-zsh/themes/` folder and capy my theme in that folder, after that we can start use it editing `~/.zshrc` with your preferred text editor and do this next:
    * ````shell
      ...

      # Set name of the theme to load --- if set to "random", it will
      # load a random theme each time oh-my-zsh is loaded, in which case,
      # to know which specific one was loaded, run: echo $RANDOM_THEME
      # See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
      ZSH_THEME="manutheme"
      
      ...
      ````
* The result will be like:

    <img src="./img/img1.png" width="70%">

* Need to fix an issue. When I tried to do autocomplete with tab key I got this next:

    <img src="./img/gif1.gif" width=70%>

* The issue was solved and also added the username. The results are:

    <img src="./img/gif2.gif" width=70%>

* Display arrows in prompt if the repository is ahead, behind or is diverged from remote:

    <img src="./img/img5.png" width=70%>
    <img src="./img/img6.png" width=70%>
    <img src="./img/img7.png" width=70%>

* Display in prompt the count of unstaged, staged, untracked and stashed files in the repository:

    <img src="./img/img4.png" width=70%>

* Display in prompt a brief message if the current local branch is not tracked in remote:

    <img src="./img/img8.png" width=70%>

* **[Added]** Display in prompt the HEAD commit hash given a git repostory:

    <img src="./img/img9.png" width=70%>

## **Bash Git Prompt [Linux]**
* I found a [repo](https://github.com/magicmonty/bash-git-prompt) which has a good looking git prompt, you can take a look at it to how to install it, but I built a shell script to make the installation very easy so please excute the next:

    ```shell
    $ ./bash-git-prompt-installer
    ```
    
* Finally, you should be able to check the prompt like this:

    <img src="./img/img2.png" width=70%>

* **Issue detected**: Trying to navigate with the ***up arrow*** key checking previous commands, if one of those was too large, I got the next issue in prompt that should be fixed:

    <img src="./img/gif3.gif">

* **Issue solved**: The issue previosly detected was solved, you only need to replace the content of [`.my-custom-bash`](.my-custom-bash) into yours, and the result will be:

    <img src="./img/gif4.gif">
    Also the looking of the date and hour was updated !

* **[Added]** Display in prompt the HEAD commit hash given a git repostory:

    <img src="./img/img10.png" width=80%>