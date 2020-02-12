# Developpers Guide

# Table of content


# Description

This document will describe mains guidelines for developers who want to
contribute to this repo. It rely on other documentation in this repo for which
link will be provided when needed.

Its aim is to describe how to develop for this repo, what style code I used and
I preferred, and how to properly contribute.

Most of this guidelines are not mandatory, its mainly to make code more
homogenous and help people to understand what is done is the code.

# Development

## Style code

If you want to help developing this repos, here are some code style I used :

  - When using `function` or method, `for`, `while` or `if`, put respectively
    `{`, `do`, `do` and `then` below the condition to test.
  - When using `for` loop, prefer using variable starting with `i` followed by
    an explicit name.
  - Use 4 indentation space when defining a scope (method, loop, if).
  - When using "advanced" bashism, such as string substitution, write a comment
    above describing what you do.
    For more information about what I consider string substitution, see:
    [tldp.org-String Manipulation][tldp_string_manipulaton], this is not
    mandatory but is here to help people not used to these syntax to understand
    what is done.
  - Document your method with a "docstring" like.
  - Do not write more that 80 char lines of code, except when there is no other
    options or when using `echo`. (Why ? Because I often have two or three code
    files open in splitted screen in vim, thus showing only 80 char).
  - All variable shoud be in lowercase exempt for configuration variable that
    can be set in configuration files `host/` folder which are in uppercase.
    Prefer to use `_` between words in variable name.
  - End your code files with a [vim modeline][vim_modeline].


Below is an example using these code style:

```bash
#!/bin/bash

# Description of the script. Which simply print the content of an array but
# replace value "item" of each cells by "toto-item" if item index is pair and
# "tata-item" if index is odd

method()
{
    # Print value of array but replace "item" by toto-item if item is pair and
    # tata-item if item is odd.
    # NO PARAM
    local my_array("item0" "item1" "item2" "item3")
    local idx_item=""

    for iElem in "${my_array[@]}"
    do
        # Extract index of item that is at the of the string
        idx_item=${iElem##item}
        if [[ $(( idx_item % 2 )) -q 0 ]]
        then
            # Replace item by toto-item
            echo "${iElem/item/toto-item}"
        else
            # Replace item by tata-item
            echo "${iElem/item/tata-item}"
        fi
    done
}

# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
```

When proposing a merge request, if adding a segment, this segment
should be documented, in the code and in the files section [Per segment
configuration][per-segment-configuration] in file
[doc/configuration.md][doc_configuration].

## Versionning & Contribution

When developping and mainly commiting, try to make "beautiful" commit, with a
title and a description of what is done. If your modification can be written in
one line title (i.e. less than 50 char), for instance, writing documentation in
the README.md, avoid commit message like "Update README.md", prefer "Update
section XXXX in README.md" or even better :

```text
Update section configuration in README.md

Add/Update section configuration witch describe how to configure your prompt and
link to the related documentation.

```

[gitmoji][gitmoji] in your commit is appreciated but not mandatory.
Moreover, if you use gitmoji, please use them only as describer of what have
been done in the start of your commit/merge request but try to not use more
thant 5 gitmoji. The idea is that if I hide the commit title, just showing the
gitmoji, I should be able to quickly know what have be done on the file.

But I understand that sometime you are not used to do this, thus, above advice
about commit are not mandatory, but merge request MUST follow this guideline.
Merge request with only title "merge `branch` on `develop`" will need to be
updated before being accepted.

Finally, when contributing, i.e. propose a merge request, follow guidelines as
described in [CONTRIBUTING][contributing]

# Tutorials

Well, this is a lots of things to do. Let us do a little tutorial to apply this
guidelines.

As described in [CONTRIBUTING][contributing], this tutorial with follow in
details the following workflow:

   1. Fork this repo, to do so, first read
      [keep your configuration][keep_your_configuration]
   2. Create a branch corresponding to what you wan to do, for instance, if you
      want to add a segment showing the date, create the branch
      `feature-segment-date`
   3. Work on this branch, make your own modification
   4. Once finished and tested, your can merge this branch to your branch
      `develop` or `master`, you are free of the management of your branches on
      your fork ;-).
   5. Prepare your merge request, i.e. ensure that your configuration files are
      not versionned.
   6. Propose a merge request on the `develop` branch of this repo with a
      complete description of what you have done.

We will work on the `date` segment to add date in your prompt.

## Fork this repo (Optional)

To do so, please read [keep your configuration][keep_your_configuration].

This step is optional, as you can work directly on the main repo by creating
branch corresponding on what you are working `feature-*` or `bugfix-`. But it is
the prefered method if you want to keep your configuration.

## Create your working branch

As in this exemple we will develop a new segment to show the date, it is a new
feature, thus the new branch will be name `feature-segment-date`

```bash
# Create the branch and directly go to it
git checkout -b feature-segment-date
```

## Work on this branch

Then, code the segment `date`, to do so, use the example provided in
[doc/add_segment.md][doc_add_segment]

If when make your own segment or when

## Ensure performance

Before merge on your own repo, ensure your work does not impact the prompt
performance, i.e. prompt should be printed in less than 250 ms in average.

To do so, there is two things to do:

  - export variable `DEBUG=1` to activate the debug mode of the prompt
  - force activation of all segments

This can be done all at once by sourcing file `debug_mode.sh`.

```bash
# Go to where you clone this repo
cd ~/.shell/prompt
# source the file
source debug_mode.sh
```

Normally, your prompt will automatically update as shown below:


If constraint of performance is fulfilled, you can leave debug mode the same way
you enter it, by sourcing file `debug_mode.sh`

```bash
# Go to where you clone this repo
cd ~/.shell/prompt
# source the file
source debug_mode.sh
```

## Once finish, merge on your own repo (optional)

Now you have finish your segment, you can merge this feature into your `develop`
or `master` branch.

```bash
git checkout develop
git merge feature-segment-date
```

## Prepare your merge request

Before proposing your merge request, ensure that :

  - Your files in `hosts/` folder are not versionned, especially
    `hosts/common.sh`
  - Your segment is documented
    - In its code
    - In [doc/configuration.md#per-segment-configuration][per-segment-configuration]
  - Your segment is working for:
    - `bash` and `zsh`
    - _v1_ and _v2_ of the prompt

To do so, not not hesitate to use script `test.sh`, see
[doc/test.sh.md][doc_test_sh] if needed

Do not hesitate to make screenshot (optional) of this segment in prompt line.

## Finally, propose your merge request

Finally, you can propose a merge request. Do to so, go on, if your fork is not
on [framagit.org][framagit], you may need to push it on this platform.

To do so, create an account on [framagit.org][framagit]. Then, create an empty
repo by clicking on the `+` on the top left then new repo as show below:

![framagit_new_repo][framagit_new_repo]

Then, create the remote on your local folder and push your repo:

```bash
git remote add upstream-fork https://framagit.org/<USER>/<REPO_NAME>
# To be sure, push all your branch, or if you know, push only needed branches
git push upstream-fork --all
```

Then propose your merge request on the branch `develop` of the main repo, as
shown below.






[per-segment-configuration]: doc/configuration.md#per-segment-configuration
[doc_configuration]: doc/configuration.md
[contributing]: CONTRIBUTING.md
[doc_add_segment]: doc/add_segment.md
[doc_test_sh]: doc/test.sh.md

[framagit_new_repo]: doc/img/framagit_new_repo.png

[gitmoji]: https://github.com/carloscuesta/gitmoji
[tldp_string_manipulaton]: https://www.tldp.org/LDP/abs/html/string-manipulation.html
[vim_modeline]: https://vim.fandom.com/wiki/Modeline_magic
[framagit]: https://framagit.org
