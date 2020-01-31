# Confiuration of the dynamic prompt

-------------------------------------------------------------------------------

This document present how to configure your prompt to feed your need, colors,
chars, etc.

-------------------------------------------------------------------------------

# Table of content

<!-- vim-markdown-toc GitLab -->

* [Global variables](#global-variables)
* [How to configure your workstations](#how-to-configure-your-workstations)
* [Configuring Prompt Line](#configuring-prompt-line)
    * [Variable `SEGMENT`](#variable-segment)
        * [Some other examples](#some-other-examples)
    * [Variable `SEGMENT_PRIORITY`](#variable-segment_priority)
        * [Some other examples](#some-other-examples-1)
* [Remark about character](#remark-about-character)
* [Remark about colors in terminal](#remark-about-colors-in-terminal)
* [Variables descriptions](#variables-descriptions)
    * [Global configuration](#global-configuration)
    * [Per segment configuration](#per-segment-configuration)
        * [hfill](#hfill)
        * [pwd](#pwd)
        * [username](#username)
        * [hostname](#hostname)
        * [tmux](#tmux)
        * [keepass](#keepass)
        * [vcsh](#vcsh)
        * [virtualenv](#virtualenv)
        * [vcs](#vcs)
            * [git specific variable for vcs segment](#git-specific-variable-for-vcs-segment)
        * [kube](#kube)
        * [openstack](#openstack)
* [Additional notes](#additional-notes)

<!-- vim-markdown-toc -->

# Global variables

Before configuring your workstations prompt coloration, chars, etc. and as
quickly described in [README.md][README.md], there are some global variables to
export and some lines that need to be added in your `~/.bashrc` or your
`~/.zshrc` depending on the shell you use.

  * In your `~/.bashrc`:
```
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
```
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

**REMARK** If you use shell framework, like [bash-it][bash-it],
[oh-my-zsh][oh-my-zsh] or [prezto][prezto]. Their support is not tested yet and
can lead to messing your prompt.

If you do not want to mess your prompt, you can first testing it in a docker
container. see section [Testing][Testing] before updating your files
`~/.bashrc` and `~/.zshrc` All other variables desribed in this document should
be put in your configuration in the `hosts` directory. See following section.

# How to configure your workstations

I tried to make my prompt as configurable as possible. It end up by setting
almost all configuration to variables. Variables are :
  * boolean to show or not some section of the prompt
  * colors of these section
  * special character that start a segment

Prompt _v1_ and _v2_ share almost all variables, just some of them are useless
in prompt _v1_.

To setup a configuration for your workstations you have two possibilities:
- create the file `common.sh` from `common.example.sh` which will be loaded if
  the file exists and will allow you to apply some common variables configuration
  to any of your workstations.
- create a file which name is the hostname of your workstation (for instance,
 the file `death-star.sh` is a configuration for one of my workstation which
 hostname is `death-star`).

Finally, you can combine both, create/modify file `common.sh` to set some
default variables for all your workstations and another file with name
`$(hostname).sh` to setup specific configuration.

Alreay in this repo are files:
- `common.example.sh` which is my personnal common configuration for all my
  workstation. It is the one used in all documentation.
- `death-start.sh` which is the specific configuration of my workstation
  `death-start`. In this file, I only overwrite variables that define the default
  background color of my prompt.

All variables in these files are optional. If not set, my scripts will load
default value written as comment in files `common.exemple.sh`.

  * The _v1_ is "classic" as show below for bash and zsh.
    * ``zsh``
![Default_zsh_prompt_v1][default_zsh_prompt_v1]
    * ``bash``
![Default_bash_prompt_v1][default_zsh_prompt_v1]
  * The _v2_ is more "powerline" look alike as show below for bash and zsh.
    * ``zsh``
![Default_zsh_prompt_v2][default_zsh_prompt_v2]
    * ``bash``
![Default_bash_prompt_v2][default_zsh_prompt_v2]

All modifications done in files in `hosts` folder will be loaded dynamically.

# Configuring Prompt Line

Before starting customization of colors, chars, etc., let us configure which
segment you want to activate/deactivate and the order in which they are
compressed.

This is done by two variables:

| Variables           |  Description                                                                                                               |
|:-------------------:|----------------------------------------------------------------------------------------------------------------------------|
| `SEGMENT`           | An array which define lines and segment used for the prompt                                                                |
| `SEGMENT_PRIORITY`  | An array which define in which order segment will be compressed when there is not enough space to print full informations. |

The prompt is able to handle single or multiline with command entry at the end of the
prompt or below the prompt when line use full length of the prompt.

Exemple are better than long explication.

**REMARK** Following example with these variables uses following segments:

  * tmux
  * pwd
  * keepass
  * username
  * hostname
  * vcsh
  * python
  * git
  * openstack
  * kubernetes
  * hfill

Which may be not the full list as segments may be added after the writing of
this documentation. To see the updated full list of segments, see section
[Per segment configuration][per-segment-configuration]

## Variable `SEGMENT`

As this variable is an array, the easiest form is:
```bash
SEGMENT=("first cell" "second cell")
```
You can see this documentation if you want to learn more about arrays in bash
 [Arrays on tldp.org][tldp.org_array]

On this array, each cell will define segments per prompt line. Segment should be
separated by a comma `,`.

For instance, if you want simple line prompt with only username, hostname and
pwd segment with command entry at the end (like default
bash prompt), the variable `SEGMENT` should be:

```bash
SEGMENT=("username, hostname, pwd")
```

**REMARK** For now, there is an issues in this configuration messing with bash
prompt, so the command entry is force to be below the line.

  * The _v1_ is "classic" as show below for bash and zsh.
    * ``zsh``
![mininmal_segment_zsh_prompt_v1][mininmal_segment_zsh_prompt_v1]
    * ``bash``
![mininmal_segment_bash_prompt_v1][mininmal_segment_bash_prompt_v1]
  * The _v2_ is more "powerline" look alike as show below for bash and zsh.
    * ``zsh``
![mininmal_segment_zsh_prompt_v2][mininmal_segment_zsh_prompt_v2]
    * ``bash``
![mininmal_segment_bash_prompt_v2][mininmal_segment_bash_prompt_v2]

For instance, if you want simple line prompt with only username, hostname and
pwd segment but with command entry below the prompt the variable `SEGMENT`
should be:

```bash
SEGMENT=("username, hostname, pwd, hfill")
```
See the special segment called `hfill` (see section [hfill][hfill]) which will
fill the line with empty char to colorize a complete line of your terminal.

  * The _v1_ is "classic" as show below for bash and zsh.
    * ``zsh``
![mininmal_segment_fulline_zsh_prompt_v1][mininmal_segment_fulline_zsh_prompt_v1]
    * ``bash``
![mininmal_segment_fulline_bash_prompt_v1][mininmal_segment_fulline_bash_prompt_v1]
  * The _v2_ is more "powerline" look alike as show below for bash and zsh.
    * ``zsh``
![mininmal_segment_fulline_zsh_prompt_v2][mininmal_segment_fulline_zsh_prompt_v2]
    * ``bash``
![mininmal_segment_fulline_bash_prompt_v2][mininmal_segment_fulline_bash_prompt_v2]

By default, for all exemple showing all segments, the value of `SEGMENT` is:

```bash
SEGMENT=(
    "tmux, pwd, hfill, keepass, username, hostname"
    "vcsh, virtualenv, vcs, kube, openstack, hfill"
)
```

  * The _v1_ is "classic" as show below for bash and zsh.
    * ``zsh``
![default_prompt_zsh_v1][default_prompt_zsh_v1]
    * ``bash``
![default_prompt_bash_v1][default_prompt_bash_v1]
  * The _v2_ is more "powerline" look alike as show below for bash and zsh.
    * ``zsh``
![default_prompt_zsh_v2][default_prompt_zsh_v2]
    * ``bash``
![default_prompt_bash_v2][default_prompt_bash_v2]


**IMPORTANT NOTES**

**If using multine prompt, like the default one, if a line of the prompt as no
information to show, for instance when you are in your home folder and there is
not specific environment loaded, then the line will not be prompt. For instance,
below are shown prompt in my `home` folder and in a work folder where every
segment is loaded, using the default multiline configuration. But using
multiline prompt requires to use hfill, otherwise prompt behaviour is not
ensure (yet ?).**

  * `home` folder, no environment
 _v1_
![default_prompt_zsh_v1_home][default_prompt_zsh_v1_home]

_v2_
![default_prompt_zsh_v2_home][default_prompt_zsh_v2_home]

  * `work` folder, every segment loaded
 _v1_
![default_prompt_zsh_v1_workdir][default_prompt_zsh_v1_workdir]

_v2_
![default_prompt_zsh_v2_workdir][default_prompt_zsh_v2_workdir]

**REMARK** Only the first line of the prompt in multiline configuration will
have a full colored line. So if the first line does not show any information,
you will not have the colored line. See in the examples below the 4 lines
configuration.


### Some other examples

Here are some other exemples show for _v1_ and _v2_ for zsh only.

 * Single line not filling full terminal size with all segment (not recommended):
```bash
SEGMENT=(
    "tmux, vcsh, virtualenv, vcs, kube, openstack, keepass, username, hostname, pwd"
)
```

_v1_
![example1_segment_prompt_v1][example1_segment_prompt_v1]

_v2_
![example1_segment_prompt_v2][example1_segment_prompt_v2]

  * Single line filling full terminal size with all segment (not recommended):
```bash
SEGMENT=(
    "tmux, vcsh, virtualenv, vcs, kube, openstack, keepass, username, hostname, pwd, hfill"
)
```

_v1_
![example2_segment_prompt_v1][example2_segment_prompt_v1]

_v2_
![example2_segment_prompt_v2][example2_segment_prompt_v2]

  * 2 lines filling full terminal size with all segment reparted on the line:
```bash
SEGMENT=(
    "tmux, keepass, username, hostname, pwd, hfill"
    "vcsh, virtualenv, vcs, kube, openstack, hfill"
)
```

_v1_
![example3_segment_prompt_v1][example3_segment_prompt_v1]

_v2_
![example3_segment_prompt_v2][example3_segment_prompt_v2]

  * Let's go crazy, use 4 lines filling full terminal size with all segment
    reparted on the lines and add some comment in the array to remember why each
    segment is on its line:

```bash
SEGMENT=(
    # Virtualization environment
    "tmux, hfill, vcsh"
    # Global variable config environement
    "keepass, hfill, kube, openstack"
    # Programation environment
    "vcsh, hfill, virtualenv"
    # Classic prompt
    "username, hostname, pwd, hfill"
)
```

_v1_
![example4_segment_prompt_v1][example4_segment_prompt_v1]

_v2_
![example4_segment_prompt_v2][example4_segment_prompt_v2]


**REMARK** Only the first line of the prompt in multiline configuration will
have a full colored line. So if the first line does not show any information,
you will not have the colored line as describe above.

## Variable `SEGMENT_PRIORITY`

Finally, let us configure the behaviour of the prompt when it will shrink, when
ther is not enough place to print all segment.

Below is exemple of this behaviour:

  * The v1 is "classic" as show below for bash and zsh.

![shrink_prompt_zsh_v1][shrink_prompt_zsh_v1]

  * The v2 is more "powerline" look alike as show below for bash and zsh.

![shrink_prompt_zsh_v2][shrink_prompt_zsh_v2]


This behaviour is configured through the variable `SEGMENT_PRIORITY` which
defines the order in which segment will be contracted or hidden.

As this variable is an array, the easiest form is:
```bash
SEGMENT_PRIORITY=("first cell" "second cell")
```
You can see this documentation if you want to learn more about arrays in bash:
 [Arrays on tldp.org][tldp.org_array]

On this array, each cell will define segments per prompt line. Segment should be
separated by a comma `,`.

For instance, let us use the default 2 line prompt:
```bash
SEGMENT=(
    "tmux, pwd, hfill, keepass, username, hostname"
    "vcsh, virtualenv, vcs, kube, openstack, hfill"
)
```

By default, the value of `SEGMENT_PRIORITY` is :

```bash
SEGMENT_PRIORITY=(
    "tmux, username, hostname, keepass, pwd"
    "vcsh, virtualenv, kube, openstack, vcs"
)
```

This means that the prompt will shrink as follow:
  - On first line, segment `tmux` will be first to shrink, then this will be
    segment `username`, then `hostname`, then `keepass` and finally `pwd`. When
    none of these segment can be shrink anymore, they will disappear in the same
    order.
  - On parallel, second lines will also shrink when need. First segment `vcsh`
    will shrink, then `virtualenv`, then `kube` then `openstack` and finally
    `vcs`. Finally, when none of these segment can be shrink anymore, they will
    disappear in the same order.

Below is an illustrated example of this behaviour for both version for `zsh`.

  * The _v1_ is "classic" as show below for bash and zsh.

![shrink_prompt_zsh_v1_updated][shrink_prompt_zsh_v1_updated]

  * The _v2_ is more "powerline" look alike as show below for bash and zsh.

![shrink_prompt_zsh_v2_updated][shrink_prompt_zsh_v2_updated]

**REMARK** DO NOT PUT `hfill` SEGMENT AS HFILL WILL **NEVER** SHRINK AND IS USED
TO FULLFILL THE PROMPT LINE BUT ALL OTHER SEGMENT YOU USE MUST BE PRESENT !

If you want to change this behaviour, you just have to change the order of the
segment.

```bash
SEGMENT_PRIORITY=(
    "username, hostname, pwd, tmux, keepass"
    "vcsh, kube, openstack, virtualenv, vcs"
)
```

**REMARK** The variable `SEGMENT_PRIORITY` must be set accordingly to segments
you use as defined in variable `SEGMENT`. For instance, if using simple one line
fill the prompt with only `username`, `hostname` and `pwd`, and you want
`hostname` to shrink first, then `username` and finally `pwd`, values `SEGMENT`
and `SEGMENT_PRIORITY` should be as follow:

```bash
SEGMENT=(
    "username, hostname, pwd, hfill"
)

SEGMENT_PRIORITY=(
    "hostname, username, pwd"
)
```
Here is the illustrated example of this behavoir.

* The _v1_ is "classic" as show below for bash and zsh.

![minimal_shrink_prompt_zsh_v1][minimal_shrink_prompt_zsh_v1]

  * The _v2_ is more "powerline" look alike as show below for bash and zsh.

![minimal_shrink_prompt_zsh_v2][minimal_shrink_prompt_zsh_v2]

### Some other examples

Here are some other examples show for _v1_ and _v2_ for zsh only, recalling
some examples used in previous section about `SEGMENT` variables.


  * Single line not filling full terminal size with all segment (not recommended):

```bash
SEGMENT=(
    "tmux, vcsh, virtualenv, vcs, kube, openstack, keepass, username, hostname, pwd"
)
SEGMENT_PRIORITY=(
    "tmux, vcsh, keepass, kube, openstack, virtualenv, vcs, hostname, username pwd"
)
```

_v1_
![example1_shrink_prompt_zsh_v1][example1_minimal_shrink_prompt_zsh_v1]

_v2_
![example1_shrink_prompt_zsh_v2][example1_minimal_shrink_prompt_zsh_v2]

  * 2 lines filling full terminal size with all segment reparted on the line:

```bash
SEGMENT=(
    "tmux, keepass, username, hostname, pwd, hfill"
    "vcsh, virtualenv, vcs, kube, openstack, hfill"
)
SEGMENT_PRIORITY=(
    "tmux, keepass, hostname, username, pwd"
    "vcsh, kube, openstack, virtualenv, vcs"
)
```

_v1_
![example2_shrink_prompt_zsh_v1][example2_minimal_shrink_prompt_zsh_v1]

_v2_
![example2_shrink_prompt_zsh_v2][example2_minimal_shrink_prompt_zsh_v2]

  * Let's go crazy, use 4 lines filling full terminal size with all segment
    reparted on the lines and add some comment in the array to remember why each
    segment is on its line:

```bash
SEGMENT=(
    # Virtualization environment
    "tmux, hfill, vcsh"
    # Global variable config environement
    "keepass, hfill, kube, openstack"
    # Programation environment
    "vcsh, hfill, virtualenv"
    # Classic prompt
    "username, hostname, pwd, hfill"
)
SEGMENT_PRIORITY=(
    # Virtualization environment
    "tmux, vcsh"
    # Global variable config environement
    "keepass, kube, openstack"
    # Programation environment
    "vcsh, virtualenv"
    # Classic prompt
    "username, hostname, pwd"
)
```

_v1_
![example3_shrink_prompt_zsh_v1][example3_minimal_shrink_prompt_zsh_v1]

_v2_
![example3_shrink_prompt_zsh_v2][example3_minimal_shrink_prompt_zsh_v2]

Now, you are ready to configure each segment, but before going deeper on
variables configuration per segments, some remark about special unicode
character usage and color usage in terminal.

# Remark about character

If you do not see default values or your char are not printed correctly, this
means:
- Your terminal emulator does not support glyphs or unicode encoding
- Your terminal emulator does support glyphs but the font you choose does not
- Your terminal emulator does support glyphs and the font you choose does too,
 but you will have to modify a scripts in this repo.

If it is the first case, unfortunately, you will not be able to print any
unicode character.

If it is the second case, please see the documentation of your terminal emulator
in order to know how to change the font it uses.

If it is the last case, you will have to add your terminal name in the table
`UNICODE_SUPPORTED_TERM` in the file `~/.shell/prompt.sh`, or when testing, you
can manually set variable `SHELL_APP` like this :
```bash
# If your terminal emulator support unicode but not true colors
export SHELL_APP=xterm
# If your terminal emulator support unicode and true colors
export SHELL_APP=st
```

# Remark about colors in terminal

Some terminal emulator support only 8/16 colors, others 256 colors and others
support true colors. Depending on which terminal emulator you use, you might
need to setup colors syntax according to the number of colors supported by your
terminal emulator.

For more information about the syntax for terminal that support up to 16 colors
or up to 256 colors:
  * https://misc.flogisoft.com/bash/tip_colors_and_formatting

To know if your terminal support true colors (i.e. 24 bits colors), and the
syntax to use:
  * https://gist.github.com/XVilka/8346728

Finally, when setting colors variables, you do not need to write the full
syntax, just enter the color code as value as the color code syntax will be set
by my scripts depending on your terminal as shown below:

| Color          | 16 colors | 256 colors | True colors    | Wrong values |
|----------------|-----------|------------|----------------|--------------|
| Red Foreground | 31        | 38;2;196   | 38;2;255;0;0;0 | \e[31m       |
| Red Background | 41        | 48;2;196   | 48;2;255;0;0;0 | \e[41m       |

Set of 256 hexadecimal colors supported by 256 colors terminal are shown at the
end of the file `common.exemple.sh`.

If you know your terminal emulator should support true colors but does not print
them, you will have to add your terminal name in the table `TRUE_COLOR_TERM` in
the file `~/.shell/prompt.sh`, or when testing, you can manually set variable
`SHELL_APP` like this :
```bash
# If your terminal emulator support unicode but not true colors
export SHELL_APP=xterm
# If your terminal emulator support unicode and true colors
export SHELL_APP=st
```

To know the name of the terminal to put in the variables `TRUE_COLOR_TERM` or
`UNICODE_SUPPORTED_TERM`, run the script `which_term.sh`.

# Variables descriptions

Columns _v1_ and _v2_ on the following table show default value depending on
prompt version.
If one of this column contain `N/A` this means that this variable is irrelevant
for the prompt version as it is not used.

Most segment can be deactivate segment easily by not putting segment name in
variables `SEGMENT` and `SEGMENT_PRIORITY`, see section
[Configuring Prompt Line][configuring-prompt-line].


## Global configuration


Below are variables used independently of segments used. They are used to set
main colors background and foreground.

| Variables           | _v1_  | _v2_  |  Description                                                                                                       |
|:-------------------:|:-----:|:-----:|--------------------------------------------------------------------------------------------------------------------|
| `PROMPT_ENV_LEFT`   | `[`   | ` `   | The character on the left of the environment shown for _v1_, <br>The separator for segment on the left for _v2_    |
| `PROMPT_ENV_RIGHT`  | `]`   | ` `   | The character on the right of the environment shown for _v1_, <br> The separator for segment on the right for _v2_ |
| `DEFAULT_FG`        | white | white | Default foreground color, a fallback colors when not defined                                                       |
| `DEFAULT_BG`        | black | black | Default background color, i.e. the color of the horizontal line                                                    |
| `RETURN_CODE_FG`    | white | white | The foreground color of the return code                                                                            |
| `CORRECT_WRONG_FG`  | white | white | If using zsh, the foreground colors of the wrong command when printing correction                                  |
| `CORRECT_RIGHT_FG`  | white | white | If using zsh, the foreground colors of the proposed command when printing correction                               |

## Per segment configuration

Actual list of segments are:

* [hfill][hfill]
* [pwd][pwd]
* [username][username]
* [hostname][hostname]
* [tmux][tmux]
* [keepass][keepass]
* [vcsh][vcsh]
* [virtualenv][virtualenv]
* [vcs][vcs]
    * [git specific variable for vcs segment][git-specific-variable-for-vcs-segment]
* [kube][kube]
* [openstack][openstack]

### hfill

This segment is a special segment used to fulfill the prompt line. It has no
configuration and is always shown if user defines this segment in variable
`SEGMENT`.

### pwd

This segment print the current dir path.

| Variables  | _v1_  | _v2_  | Description                                                |
|:----------:|:-----:|:-----:|------------------------------------------------------------|
| `PWD_CHAR` | ` `  | ` `  | Character to show before the current path                  |
| `PWD_FG`   | white | white | Foreground color of the path information                   |
| `PWD_BG`   | `N/A` | black | Backgroun color of the path information, only used by _v2_ |

### username

This segment print the current username.

| Variables   | _v1_  | _v2_  | Description                                         |
|:-----------:|:-----:|:-----:|-----------------------------------------------------|
| `USER_CHAR` | ` `  | ` `  | Character to show before the username               |
| `USER_FG`   | white | white | Foreground color of the username                    |
| `USER_BG`   | `N/A` | black | Background color of the username, only used by _v2_ |

### hostname

This segment print the hostname of the computer

| Variables   | _v1_  | _v2_  | Description                                         |
|:-----------:|:-----:|:-----:|-----------------------------------------------------|
| `USER_CHAR` | ` `  | ` `  | Character to show before the hostname               |
| `USER_FG`   | white | white | Foreground color of the hostname                    |
| `USER_BG`   | `N/A` | black | Background color of the hostname, only used by _v2_ |

### tmux

This segment inform me when I am in tmux. Because I do no usually look to the
bottom of my terminal which usually is fullscreen on a 24" monitor. But you can
deactivate this segment easily, by not putting this segment name in variables
`SEGMENT` and `SEGMENT_PRIORITY`, see section [Configuring Prompt Line][configuring-prompt-line].

This segment is only shown when global shell environment variable `TMUX` exists
and is not empty.

| Variables   | _v1_   | _v2_   | Description                                             |
|:-----------:|:------:|:------:|---------------------------------------------------------|
| `TMUX_CHAR` | ` `   | ` `   | Character to show at the start of segment tmux          |
| `TMUX_FG`   | white  | white  | Foreground color of the tmux segment                    |
| `TMUX_BG`   | `N/A`  | black  | Background color of the tmux segment, only used by _v2_ |

### keepass

This segment inform me when I have some keepass variables loaded to access my
keepass database from CLI. I have my own wrapper around keepassxc-cli to use these keepass variables.

This segment is only shown when global shell environment variable `KEEPASS_TYPE`
exists and is not empty.

A link will be provided to my wrapper when fully documented, stable and ready to
be relase.

| Variables      | _v1_   | _v2_   | Description                                                |
|:--------------:|:------:|:------:|------------------------------------------------------------|
| `KEEPASS_CHAR` | ` `   | ` `   | Character to show at the start of segment keepass          |
| `KEEPASS_FG`   | white  | white  | Foreground color of the keepass segment                    |
| `KEEPASS_BG`   | `N/A`  | black  | Background color of the keepass segment, only used by _v2_ |

### vcsh

As I use [vcsh][vcsh] to manage my dotfiles, I need to
know when I am in a vcsh shell.

This segment is only shown when in a vcsh shell, i.e. when global shell
environment variable `VCSH_REPO_NAME` exists and is not empty.

| Variables   | _v1_   | _v2_   | Description                                                |
|:-----------:|:------:|:------:|------------------------------------------------------------|
| `VCSH_CHAR` | ` `   | ` `   | Character to show at the start of segment vcsh             |
| `VCSH_FG`   | white  | white  | Foreground color of the vcsh segment                       |
| `VCSH_BG`   | `N/A`  | black  | Background color of the vcsh segment, only used by _v2_    |

### virtualenv

This segment is a "meta-segment" to show virtual environment information. For
now, only `python` is supported. as it is the only one I use. If you want to add
support of another virtual environment, like nix, guix, npm, feel free to
contribute, I'll be glad to help as much as I can.

As it only support `python` for now, this segment is only shown when global
variable `VIRTUAL_ENV` exists and is not empty. For `python`, this usually means
you activate the python virtual environment with command like:

```bash
# If using virtualenv manually
source .venv/bin/activate
# If using pipenv
pipenv shell
```

The virtual environment information is of the form
`python_version:name_of_virtual_env`

| Variables         | _v1_   | _v2_   | Description                                                |
|:-----------------:|:------:|:------:|------------------------------------------------------------|
| `VIRTUALENV_CHAR` | ` `   | ` `   | Character to show at the start of segment kube             |
| `VIRTUALENV_FG`   | white  | white  | Foreground color of the kube segment                       |
| `VIRTUALENV_BG`   | `N/A`  | black  | Background color of the kube segment, only used by _v2_    |

### vcs

This segment is a "meta-segment" to show version control system information. For
now, only `git` is supported. as it is the only one I use. If you want to add
support of another version control system, like mercury, feel free to
contribute, I'll be glad to help as much as I can.

As it only support `git` for now, this segment is only shown when in a git repo.

| Variables             | _v1_    | _v2_    | Description                                                                                              |
|:---------------------:|:-------:|:-------:|----------------------------------------------------------------------------------------------------------|
| `VCS_CHAR`            | ` `    | ` `    | Character to show at the start of segment vcs                                                            |
| `VCS_COLORED`         | `false` | `false` | Boolean, show vcs section with colors                                                                    |
| `VCS_FG`              | white   | white   | The default foreground color of the vcs section                                                          |
| `VCS_BG`              | black   | black   | The default background color of the vcs section                                                          |
| `VCS_PROMPT_DIRTY_FG` | white   | white   | The foreground color when the current versioned repo is dirty                                            |
| `VCS_PROMPT_CLEAN_FG` | white   | white   | The foreground color when the current versioned repo is clean                                            |
| `VCS_BRANCH_FG`       | white   | white   | The foreground color when showing the branch name                                                        |
| `VCS_TAG_FG`          | white   | white   | The foreground color of the tag when the current versioned repo is at a tagged commit                    |
| `VCS_DETACHED_FG`     | white   | white   | The foreground color of the commit when the current versioned repo is detached from HEAD                 |
| `VCS_COMMIT_FG`       | white   | white   | The foreground color of the current commit in the versioned repo                                         |
| `VCS_AHEAD_FG`        | white   | white   | The foreground color when the current versioned repo is ahead of the correspond remote branch on origin  |
| `VCS_BEHIND_FG`       | white   | white   | The foreground color when the current versioned repo is behind of the correspond remote branch on origin |
| `VCS_UNTRACKED_FG`    | white   | white   | The foreground color of the untracked file informations in the current versioned repo                    |
| `VCS_STAGED_FG`       | white   | white   | The foreground color of the staged file informations in the current versioned repo                       |
| `VCS_UNSTAGED_FG`     | white   | white   | The foreground color of the unstaged file informations in the current versioned repo                     |
| `VCS_STASH_FG`        | white   | white   | The foreground color when changes are stahed                                                             |

#### git specific variable for vcs segment

This variables are specific to vcs section when in git folder.

| Variables               | _v1_    | _v2_    | Description                                                                                         |
|:-----------------------:|:-------:|:-------:|-----------------------------------------------------------------------------------------------------|
| `GIT_IGNORE_UNTRACKED ` | `false` | `false` | Boolean, to show untracked files in the prompt                                                      |
| `GIT_PROMPT_DIRTY`      | `✗`     | `✗`     | Character to show that local git repo is dirty                                                      |
| `GIT_PROMPT_CLEAN`      | `✓`     | `✓`     | Character to show that local git repo is clean                                                      |
| `GIT_BRANCH_PREFIX`     | ``     | ``     | Character shown before the branch name                                                              |
| `GIT_TAG_PREFIX`        | `笠[`   | `笠[`   | Characters prefix around tag when repo is at a tagged commit                                        |
| `GIT_TAG_SUFFIX`        | `]`     | `]`     | Characters suffix around tag when repo is at a tagged commit                                        |
| `GIT_DETACHED_PREFIX`   | ` `    | ``     | Characters prefix around commit when repo is detached from HEAD                                     |
| `GIT_DETACHED_SUFFIX`   | `]`     | `]`     | Characters suffix around commit when repo is detached from HEAD                                     |
| `GIT_CHAR`              | ``     | ``     | Character to show at the begining of the section when in git repo                                   |
| `GIT_AHEAD_CHAR`        | `ﰵ`     | `ﰵ`     | Character to show when current repo is ahead of the remote corresponding branch on remote `origin`  |
| `GIT_BEHIND_CHAR`       | `ﰬ`     | `ﰬ`     | Character to show when current repo is behind of the remote corresponding branch on remote `origin` |
| `GIT_UNTRACKED_CHAR`    | ``     | ``     | Charater to show that files are untracked, it will be followed by the number of untracked files     |
| `GIT_UNSTAGED_CHAR`     | ``     | ``     | Charater to show that files are unstaged, it will be followed by the number of untracked files      |
| `GIT_STAGED_CHAR`       | ``     | ``     | Charater to show that files are staged, it will be followed by the number of untracked files        |
| `GIT_STASH_CHAR_PREFIX` | `{`     | `{`     | Charaters prefix when works are stashed                                                             |
| `GIT_STASH_CHAR_SUFFIX` | `}`     | `}`     | Charaters suffix when works are stashed                                                             |

### kube

This segment show kubernetes information of the form `cluster:namespace`.

This segment is shown only when global variable `KUBE_ENV` exists and is not
empty and kubernetes context can be retrive with `kubectl` command.

As I manage multiple kubernetes cluster depending on project, I set variables
`KUBE_ENV` and `KUBECONFIG` by project using [direnv][direnv]

To see how to use `direnv` for your folder, see section
[Using direnv to setup environment-variables][using_direnv]


| Variables   | _v1_   | _v2_   | Description                                                 |
|:-----------:|:------:|:------:|------------------------------------------------------------|
| `KUBE_CHAR` | ` `   | ` `   | Character to show at the start of segment kube             |
| `KUBE_FG`   | white  | white  | Foreground color of the kube segment                       |
| `KUBE_BG`   | `N/A`  | black  | Background color of the kube segment, only used by _v2_    |

### openstack

This segment show openstack information of the form `OS_DOMAIN:OS_PROJECT_NAME`.

This segment is shown only when both variables `OS_PROJECT_NAME` and
`OS_USER_DOMAIN_NAME`, usually done when sourcing `openrc.sh` file.

As I manage multiple OpenStack pool of ressources depending on project, I set
variables OpenStack by project using [direnv][direnv]. Also to
avoid to type `source openrc.sh` command each time I enter the working project
that use OpenStack.

To see how to use `direnv` for your folder, see
[Using direnv to setup environment-variables][using_direnv]

| Variables        | _v1_   | _v2_   | Description                                                 |
|:----------------:|:------:|:------:|------------------------------------------------------------|
| `OPENSTACK_CHAR` | ` `   | ` `   | Character to show at the start of segment openstack             |
| `OPENSTACK_FG`   | white  | white  | Foreground color of the openstack segment                       |
| `OPENSTACK_BG`   | `N/A`  | black  | Background color of the openstack segment, only used by _v2_    |


# Additional notes

If you want a good starting point, I provided the file `common.example.sh` that
I use as base configuration for all my workstations. This file have lots of
comment to help understand what variables stands for. Moreover, in this file, I
alread handled most configuration, such as defining variable for 16 colors
terminal emulator, 256 colors terminal emulator and true colors terminal
emulator. You can copy it to your desire `$(hostname).sh` or simply modify its
value to make it your own.


[Global variables]: #global-variables
[How to configure your workstations]: #how-to-configure-your-workstations
[Configuring Prompt Line]: #configuring-prompt-line
[Variable `SEGMENT`]: #variable-segment
[Some other examples]: #some-other-examples
[Variable `SEGMENT_PRIORITY`]: #variable-segment_priority
[Some other examples]: #some-other-examples-1
[Remark about character]: #remark-about-character
[Remark about colors in terminal]: #remark-about-colors-in-terminal
[Variables descriptions]: #variables-descriptions
[Global configuration]: #global-configuration
[Per segment configuration]: #per-segment-configuration
[hfill]: #hfill
[pwd]: #pwd
[username]: #username
[hostname]: #hostname
[tmux]: #tmux
[keepass]: #keepass
[vcsh]: #vcsh
[virtualenv]: #virtualenv
[vcs]: #vcs
[git specific variable for vcs segment]: #git-specific-variable-for-vcs-segment
[kube]: #kube
[openstack]: #openstack
[Additional notes]: #additional-notes


[README.md]: README.md
[Testing]: README.md#testing
[using_direnv]: doc/direnv.md


[vcsh]: https://github.com/RichiH/vcsh
[bash-it]: https://github.com/Bash-it/bash-it
[oh-my-zsh]: https://github.com/robbyrussell/oh-my-zsh
[prezto]: https://github.com/sorin-ionescu/prezto
[tldp.org_array]: https://www.tldp.org/LDP/abs/html/arrays.html
[color_syntaxt]: https://misc.flogisoft.com/bash/tip_colors_and_formatting
[direnv]: https://direnv.net/


[Default_zsh_prompt_v1]: doc/img/default_zsh_prompt_v1.png
[Default_bash_prompt_v1]: doc/img/default_zsh_prompt_v1.png
[Default_zsh_prompt_v2]: doc/img/default_zsh_prompt_v2.png
[Default_bash_prompt_v2]: doc/img/default_zsh_prompt_v2.png
[mininmal_segment_zsh_prompt_v1]: doc/img/mininmal_segment_zsh_prompt_v1.png
[mininmal_segment_bash_prompt_v1]: doc/img/mininmal_segment_bash_prompt_v1.png
[mininmal_segment_zsh_prompt_v2]: doc/img/mininmal_segment_zsh_prompt_v2.png
[mininmal_segment_bash_prompt_v2]: doc/img/mininmal_segment_bash_prompt_v2.png
[mininmal_segment_fulline_zsh_prompt_v1]: doc/img/mininmal_segment_fulline_zsh_prompt_v1.png
[mininmal_segment_fulline_bash_prompt_v1]: doc/img/mininmal_segment_fulline_bash_prompt_v1.png
[mininmal_segment_fulline_zsh_prompt_v2]: doc/img/mininmal_segment_fulline_zsh_prompt_v2.png
[mininmal_segment_fulline_bash_prompt_v2]: doc/img/mininmal_segment_fulline_bash_prompt_v2.png
[default_prompt_zsh_v1]: doc/img/default_prompt_zsh_v1.png
[default_prompt_bash_v1]: doc/img/default_prompt_bash_v1.png
[default_prompt_zsh_v2]: doc/img/default_prompt_zsh_v2.png
[default_prompt_bash_v2]: doc/img/default_prompt_bash_v2.png
[default_prompt_zsh_v1_home]: doc/img/default_prompt_zsh_v1_home.png
[default_prompt_zsh_v2_home]: doc/img/default_prompt_zsh_v2_home.png
[default_prompt_zsh_v1_workdir]: doc/img/default_prompt_zsh_v1_workdir.png
[default_prompt_zsh_v2_workdir]: doc/img/default_prompt_zsh_v2_workdir.png
[example1_segment_prompt_v1]: doc/img/example1_segment_prompt_v1.png
[example1_segment_prompt_v2]: doc/img/example1_segment_prompt_v2.png
[example2_segment_prompt_v1]: doc/img/example2_segment_prompt_v1.png
[example2_segment_prompt_v2]: doc/img/example2_segment_prompt_v2.png
[example3_segment_prompt_v1]: doc/img/example3_segment_prompt_v1.png
[example3_segment_prompt_v2]: doc/img/example3_segment_prompt_v2.png
[example4_segment_prompt_v1]: doc/img/example4_segment_prompt_v1.png
[example4_segment_prompt_v2]: doc/img/example4_segment_prompt_v2.png
[shrink_prompt_zsh_v1]: doc/img/shrink_prompt_zsh_v1.png
[shrink_prompt_zsh_v2]: doc/img/shrink_prompt_zsh_v2.png
[shrink_prompt_zsh_v1_updated]: doc/img/shrink_prompt_zsh_v1_updated.png
[shrink_prompt_zsh_v2_updated]: doc/img/shrink_prompt_zsh_v2_updated.png
[minimal_shrink_prompt_zsh_v1]: doc/img/minimal_shrink_prompt_zsh_v1.png
[minimal_shrink_prompt_zsh_v2]: doc/img/minimal_shrink_prompt_zsh_v2.png
[example1_shrink_prompt_zsh_v1]: doc/img/example1_minimal_shrink_prompt_zsh_v1.png
[example1_shrink_prompt_zsh_v2]: doc/img/example1_minimal_shrink_prompt_zsh_v2.png
[example2_shrink_prompt_zsh_v1]: doc/img/example2_minimal_shrink_prompt_zsh_v1.png
[example2_shrink_prompt_zsh_v2]: doc/img/example2_minimal_shrink_prompt_zsh_v2.png
[example3_shrink_prompt_zsh_v1]: doc/img/example3_minimal_shrink_prompt_zsh_v1.png
[example3_shrink_prompt_zsh_v2]: doc/img/example3_minimal_shrink_prompt_zsh_v2.png
