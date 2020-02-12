# How to add a segment

-------------------------------------------------------------------------------

This document present how add your own segment if you feel like prompt is
lacking one.

-------------------------------------------------------------------------------

# Table of content

# Description

This document is a little tutorial in which we will add a segment showing the
date. It is a simple one, but can be make dynamic, with colors, etc.

This segment will **never be added** to the main tree, as its aims to be the
support of this tutorial. Moreover, I do not need it, but feel free to keep it
versionned on your own branch/fork ;-) (and ensure that it will be untracked
when proposing a merge request).

This tutorial assumes that you have made a fork of the main repo, i.e. you
already read and applied
[doc/keep_your_configuration.md][keep_your_configuration] and your read file
[doc/developpers_guide.md][developpers_guide].

# Adding the segment date

## Construct segment from template

I provide a simple script called `new_segment.sh` in the root of this repo that
will create a basic segment in folder `segment/` from the templated one called
`segment/segment.tpl`.

To add your `date` segment, you have two possibilities:

* Run the script `./new_segment.sh` without option, you will be asked
  interactively the name of the segment you want to add.
* Run the script with the name of the segment you want to add as first argument,
  for instance `./new_segment.sh date`

This will automatically create the file `segment/date.sh` with the content shown
below:

```bash
#!/bin/bash

# Showing whoami info
local DATE_CHAR="${DATE_CHAR:-"X"}"
local DATE_FG="${DATE_FG:-37}"
local DATE_BG="${DATE_BG:-40}"

_compute_date_info()
{
  echo -e "${DATE_CHAR} segment_content"
}

_compute_date_info_short()
{
  echo -e "${DATE_CHAR}"
}

# Setting array value
_date_info()
{
  # Required method to get segment in long format
  local info=$(_compute_date_info)
  if [[ -n "${info}" ]]
  then
    info_line[$iSegment]="${info}"
    info_line_clr[$iSegment]="${info}"
    info_line_fg[$iSegment]="${DATE_FG}"
    info_line_bg[$iSegment]="${DATE_BG}"
    info_line_clr_switch[$iSegment]="${DATE_BG/4/3}"
  fi
}

_date_info_short()
{
  # Required method to get segment in short format
  local info=$(_compute_date_info_short)
  if [[ -n "${info}" ]]
  then
    info_line_short[$iSegment]="${DATE_CHAR}"
    info_line_clr_short[$iSegment]="${DATE_CHAR}"
  fi
}
# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
```

Before continuing, let us take a quick look at what is it inside.

**REMARK** to make this tutorial some generic, in the fifth following sections,
I'll use `SEGMENT/segment` instead of `date`, for instance `SEGMENT_CHAR`
instead of `DATE_CHAR`, as name of variable and method can change. If you
segment is called, let us say `cpu_usage`, then the variable will be called
`CPU_USAGE_CHAR`.

### The variables `SEGMENT_CHAR`, `SEGMENT_FG` and `SEGMENT_BG`

```bash
# Showing date info
local SEGMENT_CHAR="${SEGMENT_CHAR:-"X"}"
local SEGMENT_FG="${SEGMENT_FG:-"37"}"
local SEGMENT_BG="${SEGMENT_BG:-"40"}"
```

These are the main variables used by all segment which will mainly define the
basic segment character to display in the beginning of the segment or when
shorten, the background and foreground colors.

It also define default value for foreground and background when user does not
set variable `SEGMENT_FG` and `SEGMENT_BG` in file in `hosts` folder.

These variables are mandatory because they are used by main scripts `v1.sh` and
`v2.sh`

### The `_compute_segment_info()` method

```bash
_compute_segment_info()
{
  echo -e "${SEGMENT_CHAR} segment_content"
}
```

This method is here to echo the content of the segment when all information are
shown by the segment. In this basic method, the segment content will simply be
the segment character and the string `segment_content`.

It will mainly be in this method that you will work to make your own segment.

### The `_compute_segment_info_short()` method

```bash
_compute_segment_info_short()
{
  echo -e "${SEGMENT_CHAR}"
}
```

This method is almost like the previous one but will echo the shorten version of
the segment, usually only the segment character as show in this example.

### The `_segment_info()` method

```bash
_segment_info()
{
  # Required method to get segment in long format
  local info=$(_compute_segment_info)
  if [[ -z "${info}" ]]
  then
    info_line[$iSegment]="${info}"
    info_line_clr[$iSegment]="${info}"
    info_line_fg[$iSegment]="${SEGMENT_FG}"
    info_line_bg[$iSegment]="${SEGMENT_BG}"
    info_line_clr_switch[$iSegment]="${SEGMENT_BG/4/3}"
  fi
}
```

This is one of the two required method by `v1.sh` and `v2.sh`. This method will
update arrays used by `v1.sh` and `v2.sh` used to construct your prompt.

Normally, you will not have anything to do here, except if your segment have
inner colors (see section [Adding colors][adding_colors]). Just leave this method like
this and especially **DO NOT RENAME IT**, otherwise your segment will not work !

As you can see, this method rely on the method `_compute_segment_info`. You can
rename the method `_compute_segment_info` but do not forget to update the call
of your renamed method.

### The `_segment_info_short()` method

```bash
_date_info_short()
{
  # Required method to get segment in short format
  local info=$(_date_info_short)
  if [[ -n ${info}]]
  then
    info_line_short[$iSegment]="${info}"
    info_line_clr_short[$iSegment]="${info}"
  fi
}
```

This is the second required method by `v1.sh` and `v2.sh`. This method will
update arrays used by `v1.sh` and `v2.sh` used to construct your prompt, mainly
arrays storing shorten version of your segment.

Normally, you will not have anything to do here. Just leave this method like
this and especially **DO NOT RENAME IT**, otherwise your segment will not work !

As you can see, this method rely on the method `_compute_segment_info_short`.
You can rename the method `_compute_segment_info_short` but do not forget to
update the call of your renamed method.

## Showing the date

Now that the untemplated segment script is describe, let us go back to our `date`
segment.

As described above, we will only need to update method `_compute_date_info`

Let us assume we want to show the date in 24h format like this `HH:MM`. The bash
command to do so is :

```bash
date "+%H:%M"
```

So let us update the method `_compute_date_info` as shown below:

```bash
_compute_date_info()
{
  echo -e "${DATE_CHAR} $(date "+%H:%M")"
}
```

Moreover, let us show a clock in from of the date, to do so, replace the `X` in
for the variable `DATE_CHAR` with the character you want, I just this character
` `, as shown below:

```bash
local DATE_CHAR="${DATE_CHAR:-" "}"
```

**REMARK** I assume you have made a fork of this repo following
[doc/keep_your_configuration.md][keep_your_configuration] and you also use the
`common.sh` file in `hosts` folder from the `common.example.sh` as I will use
the content of `common.example.sh` as example for this tutorial. For more
information, see [doc/configuration.md][configuration].

Now, let us update the variable `SEGMENT` and `SEGMENT_PRIORITY` in `common.sh`
to show our segment as shown below:

```bash
local SEGMENT=(
  "tmux, date, pwd, hfill, keepass, username, hostname"
  "vcsh, virtualenv, vcs, hfill, kube, openstack"
)

local SEGMENT_PRIORITY=(
  "tmux, date, username, hostname, keepass, pwd"
  "vcsh, virtualenv, kube, openstack, vcs"
)
```

Normally, your prompt should update from something like :

  * The _v1_, "classic" version

![default_prompt_zsh_v1][default_prompt_zsh_v1]

  * The _v2_, "powerline" version

![default_prompt_zsh_v2][default_prompt_zsh_v2]

To something like this:

  * The _v1_, "classic" version

![default_date_prompt_zsh_v1][default_date_prompt_zsh_v1]

  * The _v2_, "powerline" version

![default_date_prompt_zsh_v2][default_date_prompt_zsh_v2]

**REMARK**: No need to enter any `source` command when working on script in
`segment` folder, because they are reload automatically. You just need to close
the file or type `<Enter>` in your terminal.

This means the default behaviour of your segment is ready to be customized by
the user.

## Add some colors and change segment char.

Now, our basic segment is ready to be customize. As we define variable
`DATE_CHAR`, `DATE_FG` and `DATE_BG` in the beginning of the segment scripts, we
can use them in the file `common.sh` in the `hosts` folder. Let us choose a
magenta background and a yellow foreground. As define in
[doc/configuration.md][configuration], there exists multiple way to define these
color depending on the true colors support of your terminal.

For this tutorial, I choose the following value:

| Color               | 16 colors | 256 colors | True colors      |
| --------------------|-----------|------------|------------------|
| Yellow  Foreground  | `33`      | `38;2;201` | `38;2;255;0;255` |
| Magenta Background  | `45`      | `48;2;226` | `48;2;255;225;0` |


For more information about the syntax for terminal that support up to 16 colors
or up to 256 colors:

  * https://misc.flogisoft.com/bash/tip_colors_and_formatting

To know if your terminal support true colors (i.e. 24 bits colors), and the
syntax to use:

  * https://gist.github.com/XVilka/8346728

Moreover, let us say that I want the character ` ` instead of the clock when
terminal support unicode character and just the character `-` when not.

Let us update this file accordingly, (`[...]` means that line of codes have be
hidden):


```bash
# CHARACTER ENVIRONMENT SETUP
# =============================================================================
# Check if terminal emulator support unicode char or glyphs.
if [[ -z "${SHELL_APP}" ]] || ! [[ "${UNICODE_SUPPORTED_TERM[@]}" =~ ${SHELL_APP} ]]
then
  [...]
  local DATE_CHAR="-"
  [...]
else
  [...]
  local DATE_CHAR=" "
  [...]
fi

# Check what kind of terminal we are in.
if [[ "${TRUE_COLOR_TERM[@]}" =~ ${SHELL_APP} ]]
then
  # If terminal emulator is know to support true colors
  if [[ ${PROMPT_VERSION} -eq 1 ]]
  then
    [...]
    local DATE_FG="38;2;225;225;0"
    # No need of DATE_BG when PROMPT_VERSION == 1
    [...]
  else
    [...]
    local DATE_FG="38;2;225;225;0"
    local DATE_FG="48;2;225;0;225"
    [...]
  fi
  [...]
elif ([[ "${SHELL_APP}" != "unkown" ]] && [[ "${SHELL_APP}" != "tty" ]]) && \
  [[ "$(tput colors)" -eq 256 ]]
then
  # If terminal support 256 colors and is not unkown or tty
  if [[ ${PROMPT_VERSION} -eq 1 ]]
  then
    # Prompt colors that support only 256
    local DATE_FG="38;2;201"
    # No need of DATE_BG when PROMPT_VERSION == 1
    [...]
  else
    [...]
    local DATE_FG="38;2;201"
    local DATE_BG="48;2;226"
    [...]
  fi
elif [[ -z "${SHELL_APP}" ]] || [[ "${SHELL_APP}" == "unkown" ]] \
  || [[ "${SHELL_APP}" == "tty" ]] || [[ $(tput colors) -eq 16 ]]
then
  # Default case, shell support a maximum to 16 color or shell_app is unkown or
  # tty
  # Fallback case to ensure working coloration
  if [[ ${PROMPT_VERSION} -eq 1 ]]
  then
    [...]
    local DATE_FG="33"
    # No need of DATE_BG when PROMPT_VERSION == 1
    [...]
  else
    [...]
    local DATE_FG="33"            # Green
    local DATE_BG="45"            # Green
    [...]
  fi
  [...]
fi
[...]
# ******************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# ******************************************************************************
```

Normally, now your prompt should look like this:

  * The _v1_, "classic" version

![default_date_color_prompt_zsh_v1][default_date_color_prompt_zsh_v1]

  * The _v2_, "powerline" version

![default_date_color_prompt_zsh_v2][default_date_color_prompt_zsh_v2]

## Make clock dynamic

### Showing clock only between 8:00 and 20:00

Ok, so for now, the clock is always displayed. Let us make it dynamic to show
the date only between 8:00 and 20:00.

To do so, we will need to update method `_compute_date_info` again.
There is lots of way to do, some most optmize than other, for now,  let us make
if simple as shown below:

```bash
_compute_date_info()
{
  # Get the hour
  local hour=$(date "+%H")
  if [[ ${hour} -ge 8 ]] && [[ ${hour} -lt 20 ]]
  then
    echo -e "${DATE_CHAR} $(date "+%H:%M")"
  fi
}
```

Now date will only be shown between 8:00 and 20:00 as shown below:

  * The _v1_, "classic" version

![default_date_between_color_prompt_zsh_v1][default_date_between_color_prompt_zsh_v1]
![default_date_outside_color_prompt_zsh_v1][default_date_outside_color_prompt_zsh_v1]

  * The _v2_, "powerline" version

![default_date_between_color_prompt_zsh_v2][default_date_between_color_prompt_zsh_v2]
![default_date_outside_color_prompt_zsh_v2][default_date_outside_color_prompt_zsh_v2]

### Adding colors

Let us continue and go a little bit more fancy. Let us add colors for hours and
for minutes, for instance, showing hours in green and minutes in red.

To so, we will need:

  * A variable to define the hours color `DATE_FG_HOURS`
  * A variable to define the minutes color `DATE_FG_MINUTES`
  * To create method `_compute_date_info_color`
  * To update method `_date_info`

First, the variables, `DATE_FG_HOURS` and `DATE_FG_MINUTES`, like
other variables like `DATE_FG`, thise variable should be put on top of the
script. Let also configure default value to red and green.

```bash
# Showing date info
local DATE_CHAR="${DATE_CHAR:-"X"}"
local DATE_FG="${DATE_FG:-37}"
local DATE_BG="${DATE_BG:-40}"

local DATE_FG_HOURS="${DATE_FG_HOURS:-32}"
local DATE_FG_MINUTES="${DATE_FG_MINUTES:-31}"
```

Like this, these variable have default value and user can overwrite them in file
in `hosts` folder.

Now, let us update the method `_compute_date_info_color`. We will not need to
update method `_compute_date_info` because this method will print plaintext
content of the segment, i.e. without color, and is need to compute size of
segment rendering and especially special segment `hfill`. The method
`_compute_date_info_color` will print colored text of the segment.

Fortunately, to manage colors in your segment, you will not have to handle
colors prefix like `\e` or `\x1b` as scripts `v1.sh` and `v2.sh` handle it in
variable `CLR_PREFIX` and `CLR_SUFFIX`.

```bash
_compute_date_info_color()
{
  # Get the hour
  local hour=$(date "+%H")
  local minute=$(date "+%M")
  # We will need to reset colors to print separator and the end of the segment
  # in _v1_ correctly
  local reset_color

  if [[ ${hour} -ge 8 ]] && [[ ${hour} -lt 20 ]]
  then
    # Construct the colored hours
    hour=${CLR_PREFIX}${DATE_FG_HOURS}${CLR_SUFFIX}${hour}
    # Construct the colored minute
    minute=${CLR_PREFIX}${DATE_FG_MINUTES}${CLR_SUFFIX}${minute}
    # Construct the resetter color
    reset_color=${CLR_PREFIX}${DATE_FG}${CLR_SUFFIX}
    # Print the color segement
    echo -e "${DATE_CHAR} ${hour}${reset_color}:${minute}${reset_color}"
  fi
}
```

Finally, as our new segment now have inline color, let us update method
`_date_info`:

```bash
_date_info()
{
  # Required method to get segment in long format
  local info=$(_compute_date_info)
  if [[ -n "${info}" ]]
  then
    info_line[$iSegment]="${info}"
    # Call the colored version of the method _compute_date_info
    info_line_clr[$iSegment]="$(_compute_date_info_color)"
    info_line_fg[$iSegment]="${DATE_FG}"
    info_line_bg[$iSegment]="${DATE_BG}"
    info_line_clr_switch[$iSegment]="${DATE_BG/4/3}"
  fi
}
```

Normally, now your segment will only be printed between 8:00 and 20:00 such that
hours are in red, minutes are in green and the rest of the segment is in yellow
as shown below.

  * The _v1_, "classic" version

![default_date_colored_between_color_prompt_zsh_v1][default_date_colored_between_color_prompt_zsh_v1]
![default_date_colored_outside_color_prompt_zsh_v1][default_date_colored_outside_color_prompt_zsh_v1]

  * The _v2_, "powerline" version

![default_date_colored_between_color_prompt_zsh_v2][default_date_colored_between_color_prompt_zsh_v2]
![default_date_colored_outside_color_prompt_zsh_v2][default_date_colored_outside_color_prompt_zsh_v2]

If you are proud of your segment, or you simply think it can be used by other
user, you can submit your segment to be merge on the main repo. Following
sections will describe how to do this.

## Publishing your segment

The first thing to do is to document your segment, in its code and in
[doc/configuration.md][configuration].

### Document the code

As stated in PEP8 of python, code is more often read than write, and so should
be easily understand by a human. But it often is not easy to make it "human
readable" when using bash, especially if your segment is complex and optimized.

So, we will document the methods `_compute_date_info`,
`_compute_date_info_color` and `_compute_date_info_short`. No need to document
methods `_date_info` and `_date_info_short` as these method are already
documented from the template segment and normally you do not have made huge
modification in there behaviour.

Moreover, unfortunately, there is no docstring in bash, we will use comment like
this :

```bash
method()
{
  # Description humanly readable
  # *PARAM $1: Type, description of expected required variable
  # PARAM $2: Type, description of expected optional variable
  # NO PARAM when there is not parameter expected.
}
```

So apply to our methods, this will give:

```bash
_compute_date_info()
{
  # Print the date in HH:MM format when date is between 8:00 and 20:00 without
  # colors
  # NO PARAM
  [...]
}

_compute_date_info_color()
{
  # Print the date in HH:MM format when date is between 8:00 and 20:00, such
  # that hours is in color defined by DATE_FG_HOURS and minutes is in colors
  # defined by DATE_FG_MINUTES
  # NO PARAM
  [...]
}

_compute_date_info_short()
{
  # Print short version of date, which is only the DATE_CHAR
  # NO PARAM
  [...]
}
```

Let us update the short description generated from the template segment:

```bash
#!/bin/bash

# Showing date in HH:MM format with colored hours and minutes
[...]
```

Alright, now, we will do update the documentation describing configuration of
all segment.

### Document the [doc/configuration.md][configuration]

You will also need to update the file [doc/configuration.md][configuration] to
add your segment with the centralized segment documentation.

You will need to add the following section in
[doc/configuration.md#per-segment-configuration][per-segment-configuration]:

```text
### date

This segment show date in HH:MM format with colored hours and minutes.

This segment is shown only when date is between 8:00 and 20:00.

| Variables         | _v1_    | _v2_    | Description                                                  |
| :-----------:     | :-----: | :-----: | ------------------------------------------------------------ |
| `DATE_CHAR`       | ` `    | ` `    | Character to show before the current path                    |
| `DATE_FG`         | white   | white   | Foreground color of the path information                     |
| `DATE_BG`         | `N/A`   | black   | Background color of the path information, only used by _v2_  |
| `DATE_FG_HOURS`   | red     | red     | Color of the hours                                           |
| `DATE_FG_MINUTES` | green   | green   | Color of th minutes                                          |
```

You will also need to add an anchor of your segment section in the list in the
top of the section
[doc/configuration.md#per-segment-configuration][per-segment-configuration].

```text
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
* [date][date]
```

And add the anchor at the end of this file:

```text
[configuring-prompt-line]: #configuring-prompt-line
[per-segment-configuration]:#per-segment-configuration
[hfill]: #hfill
[pwd]: #pwd
[username]: #username
[hostname]: #hostname
[tmux]: #tmux
[keepass]: #keepass
[vcsh]: #vcsh
[virtualenv]: #virtualenv
[vcs]: #vcs
[git-specific-variable-for-vcs-segment]: #git-specific-variable-for-vcs-segment
[kube]: #kube
[openstack]: #openstack
[Additional notes]: #additional-notes
[date]: #date
```

**REMARK** This formalism to define link/anchor in markdown can be seen as odd
when never seen. I use it reuse link/anchor in markdown and centralize them to
more easily update links/anchors.

See : https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#links

### Ready to publish

Once eveything done, you can now propose a merge request on the branch `develop`
on the main repo to propose your segment as described in
[doc/developpers_guide.md#prepare-your-merge-request][prepare_merge_request].
and
[doc/developpers_guide.md#finally-propose-your-merge-request][propose_merge_request].


[adding_colors]: #adding-colors
[per-segment-configuration]: doc/configuration.md#per-segment-configuration
[propose_merge_request]: doc/developpers_guide.md#finally-propose-your-merge-request
[prepare_merge_request]: doc/developpers_guide.md#prepare-your-merge-request
[developpers_guide]: doc/developpers_guide.md

[configuration]: doc/configuration.md
[keep_your_configuration]: doc/keep_your_configuration.md

[default_prompt_zsh_v1]: doc/img/default_prompt_zsh_v1.png
[default_prompt_zsh_v2]: doc/img/default_prompt_zsh_v2.png

[default_date_prompt_zsh_v1]: doc/img/default_date_prompt_zsh_v1.png
[default_date_prompt_zsh_v2]: doc/img/default_date_prompt_zsh_v2.png
