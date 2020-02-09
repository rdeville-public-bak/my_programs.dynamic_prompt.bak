# Prompt

-------------------------------------------------------------------------------

This folder allow you to easily configure and use a responsive prompt that will
dynamically show information about your current environment.

-------------------------------------------------------------------------------

# Table of content

* [Description](#description)
* [Prompt description](#prompt-description)
* [Files and folders](#files-and-folders)
    * [doc/](#doc)
    * [hosts/](#hosts)
    * [segment/](#segment)
    * [test/](#test)
* [How to use it ?](#how-to-use-it-)
    * [Testing](#testing)
    * [Configuration](#configuration)
    * [Add your own segments](#add-your-own-segments)
* [FAQ](#faq)
* [Know Issues](#know-issues)

# Description

This repo contains scripts allowing to setup a dynamic prompt line. As I live
mainly in terminal and I am mainly do adminsys, I need to know quickly on which
kind of computer I am, personnal, professional, workstation, server, which
OpenStack pool variables are loaded, etc.

Its part of my dotfiles repos which optimize my terminal usage. For now, all my
dotfiles are not yet clean and documented, but once done, a link will be
provided if you want to learn more about how to optimize your terminal usage.

The aim of this prompt are :

  * **Being dynamic**: show information of the current folder, only if there
    exists. For instance, show python environment information or git information
    only when there exists,  k8s cluster namespace only when set, etc.
  * **Being fast**: prompt with all segments must be shown in less than
    250ms in average.
  * **Being responsive**: when terminal emulator is to short, the prompt must
    shrink informations until hiding them completely when there is no space.
  * **Being fully customizable**: as I used multiple computers, I need to be able
    to quickly set a common shared configuration (colors, character, etc) and
    some computer specific configuration. This must be done by modifiying the
    less possible files.
  * **Being extensible**: if user need to add a new segment, it should be
    easy enough to do so.
  * **Support `bash` and `zsh` in a transparent way**: before using this prompt,
    I used shell frameworks [`bash-it`][bash-it] and [`oh-my-zsh`][oh-my-zsh].
    So, when I needed to add something, I needed to work on two prompt
    configuration. I wanted to centralize this to manage both at once. Moreover,
    my personnal computer use `zsh` while most server I work on use `bash`, so I
    must support both with only one repo and the less possible files.

**Why this new prompt while there exists similar project like
[liquidprompt][liquidprompt]**

When I started this prompt, I did not know liquidprompt. After quickly checking
the code, here are some differences I saw (but I may be wrong):

  * Almost all variables used to show this prompt are not exported and so do not
    add useless variables in your shell environment.
  * This prompt allow you to easily add your own segment.
  * This repo propose you two versions, one quite "classic" and one more
    "powerline" lool alike. Choosing which version to use is done simply by
    changing variable `PROMPT_VERSION` (see
    [doc/configuration.md][doc_configuration].

# Prompt description

In the following section, I will describe the prompt with default prompt line,
i.e. default segments organisation, and with the colors provided by the file
`host/common.example.sh`. But you will be able change segment organisation and
colors, this is descibe in [doc/configuration.md][doc_configuration].

First of all, here are some screenshots of both prompt version for both
supported shell:

  * The _v1_ is "classic" as show below for bash and zsh.

``bash``

![default_prompt_bash_v1][default_prompt_bash_v1]

``zsh``

![default_prompt_zsh_v1][default_prompt_zsh_v1]

  * The _v2_ is more "powerline" look alike as show below for bash and zsh.

``bash``

![default_prompt_bash_v2][default_prompt_bash_v2]

``zsh``

![default_prompt_zsh_v2][default_prompt_zsh_v2]

In both case, (almost) all parts (colors, character, which segment to show, in
which order, etc.) are configurable. You can either choose to show only some
informations or change its colors depending on what you what.

The above show my prompt when no "environment" is loaded. The colored horizontal
line is here to help me know quickly on which type of computer I am (for
instance, red for professional workstation, magenta for professional servers,
green for personnal workstation, yellow for personal servers, etc.). All colors
of the prompt (the current directory, the username, etc.) can be easily change
for each computer based on its hostname (see
[doc/configuration.md][doc_configuration]).

Below is what prompt looks like when almost all supported segments are loaded.
Well, all supported segment when writing this README.md. Some segments might not
be shown below if added later on.

  * The _v1_, "classic" version

`bash`

![default_full_option_bash_v1][default_full_option_bash_v1]

`zsh`

![default_full_option_zsh_v1][default_full_option_zsh_v1]

  * The _v2_, "powerline" version

`bash`

![default_full_option_bash_v2][default_full_option_bash_v2]

`zsh`

![default_full_option_zsh_v2][default_full_option_zsh_v2]

Here you can see my prompts when all segments are loaded. Supported
segments/environment are :

  - tmux
  - pwd
  - keepass
  - username
  - hostname
  - vcsh
  - virtualenv (for now only python)
  - vcs (for now only git)
  - openstack
  - kubernetes

Every environment information, colors and character can be configure
individually to be shown or not (see [doc/configuration.md][doc_configuration]).

As you can see, `bash` version and `zsh` version are almost the same, only the
return code has different position (the part in red `130 ↵ ` in `bash` on the
left, and the part in red `130 ↵ ` in the right in `zsh`) . So following
exemples will mainly present prompt when using `zsh`.

Moreover, when logged as `root` all the prompt shift to bold, thus I know
visually that I am `root` and things I do can be dangerous. See below for an
example.

  * The _v1_, "classic" version

![root_default_prompt_zsh_v1][root_default_prompt_zsh_v1]

  * The _v2_, "powerline" version

![root_default_prompt_zsh_v2][root_default_prompt_zsh_v2]


**_REMARK_** When on `tty` or in unsupported terminal emulator, prompt will
automatically fall back to prompt _v1_.

**Environment contraction**

When there is not enough space to show all environment informations completely,
they will be contracted to show only the character of the environment. The more
your terminal will shorten, the less options will be shown. Order on which
segments are contracted are always in the same order, defined by user (see
[doc/configuration.md][doc_configuration]). Finally, if there is really not
enough space, some information will be completely hidden. Exemple of contraction
are shown below for both prompt version.

  * The _v1_, "classic" version

![shrink_prompt_v1][shrink_prompt_v1]

  * The _v2_, "powerline" version

![shrink_prompt_v2][shrink_prompt_v2]

**_DISCLAIMER_**: Gifs above only show contraction behaviour, but as variable
`PS1` for bash and `PROMPT` for zsh are only computed before printing them, when
you resize your terminal emulator, you will need to press `Enter` once to
recompute the size of your prompt. So, when resizing your terminal emulator,
before pressing `Enter`, you prompt might look like shown below:

  * The _v1_, "classic" version, when increasing size of terminal emulator

![resized_terminal_emulator_plus_v1][resized_terminal_emulator_plus_v1]

  * The _v1_, "classic" version, when decreasing size of terminal emulator

![resized_terminal_emulator_minus_v1][resized_terminal_emulator_minus_v1]

  * The _v2_, "classic" version, when increasing size of terminal emulator

![resized_terminal_emulator_plus_v2][resized_terminal_emulator_plus_v2]

  * The _v2_, "classic" version, when decreasing size of terminal emulator

![resized_terminal_emulator_minus_v2][resized_terminal_emulator_minus_v2]

**Default prompt when no colors sets**

By default, if no file exists in folder `hosts/` with the name `$(hostname).sh`
or with the name `common.sh`, no colors will be set, as shown below for both
versions.

  * The v1 is "classic" as show below for bash and zsh.

![base_nocolor_prompt_v1][base_nocolor_prompt_v1]

  * The v2 is more "powerline" look alike as show below for bash and zsh.

![base_nocolor_prompt_v2][base_nocolor_prompt_v2]

# Files and folders

Here I will briefly describe the content of the file of this repo in case you
want to upgrade it for yourself or to help you understand what is done.

## doc/

This folder store the documentation of the prompt, the configuration and
description for each segments.
It also store image shown in documentation.

## hosts/

This folder is here to store your personnal configuration. By default, there is
two files that might interest you:

  * `common.exemple.sh`: An example of variables I use to have some common
   configuration accross my computer (like same colors for environment for each
   computer). This is the file use for the screenshots above. Then for each
   workstation I have, they have their own configuration file in the form
   `$(hostname).sh`. For instance, file `death-star.sh` is the configuration for
   one of my computer which hostname is `death-star`.
  * `death-stat.sh`: The file specific to one of my computer which hostname is
   `death-star` in which I override some commonly shared variables setup in
   `common.sh`.

There is also a subfolder `exemples/` for powerline prompt in which I propose
different powerline character. See TODO: configuration for more informations.

## segment/

This folder store all segments currently supported. If you want to add your own,
you will simply need to add you script in this file and setup your prompt
variable to use it.

## test/

This folder store docker configuration to test your prompt configuration without
messing with your current prompt. Normally, nothing need to be done in this
folder which is automatically used by script `test.sh`

# How to use it ?

This repo is versioned using [git][git]. First install it on
your computer. If your distro is not shown below is because I did not testing
command. Feel free to contribute ;-).

**On debian based (Debian/Ubuntu)**
```bash
$ sudo apt install git
```

Once this is done, you can clone the repo whereever you want, let us say in a
the folder `~/.shell/prompt`

```bash
$ git clone git@framagit.org:rdeville/dotfiles.shell.git ~/.shell/prompt
# or
$ git clone https://framagit.org/rdeville/dotfiles.shell.git ~/.shell/prompt
```
Finally, you will only need to add the following lines:

  * In your `~/.bashrc`:
```bash
# Or whereever you clone this repo
export PROMPT_DIR="${HOME}/.shell/prompt"
# The prompt version you want to use, "1" or "2"
export PROMPT_VERSION="2"
# Not required, but sometimes, the shell emulator variables is not well set
export SHELL="/bin/bash"
# Not required, but you can force to ensure usage of unicode or true colors
export SHELL_APP=<the name of your terminal emulator>

# Source the file that will check if SHELL_APP is supported. If not fall back to
# v1. If supported, will load the user defined prompt
source "${PROMPT_DIR}/prompt.sh"

# Explicitly tell bash to use method precmd before letting user to type command.
if ! [[ "${PROMPT_COMMAND}" =~ precmd ]]
then
  export PROMPT_COMMAND="precmd;${PROMPT_COMMAND}"
fi
```

  * In your `~/.zshrc`
```bash
# Or whereever you clone this repo
export PROMPT_DIR="${HOME}/.shell/prompt"
# The prompt version you want to use, "1" or "2"
export PROMPT_VERSION="2"
# Not required, but sometimes, the shell emulator variables is not well set
export SHELL="/bin/bash"
# Not required, but you can force to ensure usage of unicode or true colors
export SHELL_APP=<the name of your terminal emulator>

# Source the file that will check if SHELL_APP is supported. If not fall back to
# v1. If supported, will load the user defined prompt
source "${PROMPT_DIR}/prompt.sh"

# No need to add PROMPT_COMMAND for zsh, as it use method precmd before letting
user to type command.
```

**_REMARK_** If you use shell framework, like [bash-it][bash-it],
[oh-my-zsh][oh-my-zsh] or [prezto][prezto]. Their support is not tested yet and
can lead to messing your prompt.

If you do not want to mess your prompt, you can first testing it in a docker
container. see section [Testing][testing] before updating your files `~/.bashrc`
and `~/.zshrc`

Finally, you can configure the prompt to your need. To do so, continue to
section [Configuration][configuration]

## Testing

In order to test this prompt or your prompt config, you will just need docker.
To install it, docker provide a documentation for multiple systems:

  * [Debian][docker_Debian]
  * [CentOS][docker_CentOS]
  * [Fedora][docker_Fedora]
  * [Ubuntu][docker_Ubuntu]

Once done, simply go to whereever you cloned this repo and run the `test.sh`:

```bash
cd ~/.shell/prompt
./test.sh
```

By default, `test.sh` will start in interactive mode asking your some information
to configure main variables `SHELL`, `PROMPT_VERSION` and `SHELL_APP` before
building a docker image and starting the docker container to test your prompt
config.
I recommend using interactive mode first, before running the docker you will be
asked confirmation and you will be prompt the command line to avoid passing
through the interactive mode the next time.

To see more option of the script, type the following command :
```bash
./test.sh -h
```
Or read the following documentation [doc/test.sh.md][doc_test]

Once run, you will automatically be in the container. The repo is mounted as
volume in the container, in `~/.prompt`. So every configuration you will made in
the container will be kept outside of the container. Thus, you will be able to
directly use your configuration once finished in the container.

If you want to keep your configuration versionned, please read [Keep your
configuration][keep-your-configuration].


## Configuration

All configuration are done within folder `hosts/`, first, read following
section [hosts][hosts] to know what there is in this folder.

Once done, you can read the complete configuration documentation which is in
[doc/configuration.md][doc_configuration]. In this file is
describe what you can configure and how.

## Add your own segments

If you feel like the prompt lack a segment you can add your own, this can be
done in folder `segment`, see section [segment][segment] first to know what
there is in this folder.

Once done, you can read the complete documentation about adding your own segment
in [doc/add_segment.md][doc_add_segment]. In this file is
describe how to develop your own segment.

Finally, if you want to publish your segment, you can propose a merge request.
To do so, see [CONTRIBUTING.md][contributing].

# FAQ

**Why not using some prompt framework like [bash-it][bash-it]
[oh-my-zsh][oh-my-zsh] or [prezto][prezto] ?**

I used to use bash-it and oh-my-zsh, but I was overhelmed by all their options,
plugins, etc., that I not fully used. Moreover, I had to manage two
configuration, one for bash and one for zsh. So I ended on making my own with
only things I need and I try to unified bash and zsh.

**Why managing both bash and zsh**

I do sysadmin, and I try to not install thing that could upset my coworker
which mainly use bash. Moreover, bash is installed by default on most GNU/Linux
distribution, allowing me to get my own prompt on most GNU/Linux distro.

**Why is there no date segment ?**

It is intended. I do not need date in my terminal, but I have prepared this
segment. It is the tutorial in documentation
[doc/add_segment.md][doc_add_segment] to show how to add your own segment.
This segment is simple to code, so you will need to add it yourself by reading
the documentation [doc/add_segment.md][doc_add_segment].

# Know Issues

  * When using `direnv`, segment that shoudl be shown because global variables
    are set by `direnv` are not shown directly. User must press `<Enter>` once
    again to view them (or enter any command). This is due to the fact that the
    direnv hook is executed after `precmd`.


[testing]: #testing
[configuration]: #configuration
[doc_test]: doc/test.sh.md
[hosts]: #hosts
[doc_configuration]: doc/configuration.md
[segment]: #segment
[doc_add_segment]: doc/add_segment.md
[contributing]: CONTRIBUTING.md
[keep-your-configuration]: doc/keep_your_configuration.md

[bash-it]: https://github.com/Bash-it/bash-it
[oh-my-zsh]: https://github.com/robbyrussell/oh-my-zsh
[prezto]: https://github.com/sorin-ionescu/prezto
[liquidprompt]: https://github.com/nojhan/liquidprompt
[git]: https://git-scm.com/
[docker_Debian]: https://docs.docker.com/install/linux/docker-ce/debian/
[docker_CentOS]: https://docs.docker.com/install/linux/docker-ce/centos/
[docker_Fedora]: https://docs.docker.com/install/linux/docker-ce/fedora/
[docker_Ubuntu]: https://docs.docker.com/install/linux/docker-ce/ubuntu/

[default_prompt_bash_v1]: doc/img/default_prompt_bash_v1.png
[default_prompt_zsh_v1]: doc/img/default_prompt_zsh_v1.png
[default_prompt_bash_v2]: doc/img/default_prompt_bash_v2.png
[default_prompt_zsh_v2]: doc/img/default_prompt_zsh_v2.png

[default_full_option_zsh_v1]: doc/img/default_prompt_full_option_zsh_v1.png
[default_full_option_bash_v1]: doc/img/default_prompt_full_option_bash_v1.png
[default_full_option_zsh_v2]: doc/img/default_prompt_full_option_zsh_v2.png
[default_full_option_bash_v2]: doc/img/default_prompt_full_option_bash_v2.png

[root_default_prompt_bash_v1]: doc/img/root_full_option_bash_v1.png
[root_default_prompt_zsh_v1]: doc/img/root_full_option_zsh_v1.png
[root_default_prompt_bash_v2]: doc/img/root_full_option_bash_v2.png
[root_default_prompt_zsh_v2]: doc/img/root_full_option_zsh_v2.png

[shrink_prompt_v1]: doc/img/shrink_v1.gif
[shrink_prompt_v2]: doc/img/shrink_v2.gif

[resized_terminal_emulator_plus_v1]: doc/img/resize_plus_zsh_v1.png
[resized_terminal_emulator_minus_v1]: doc/img/resize_minus_zsh_v1.png
[resized_terminal_emulator_plus_v2]: doc/img/resize_plus_zsh_v2.png
[resized_terminal_emulator_minus_v2]: doc/img/resize_minus_zsh_v2.png

[base_nocolor_prompt_v1]: doc/img/default_no_color_zsh_v1.png
[base_nocolor_prompt_v2]: doc/img/default_no_color_zsh_v2.png

