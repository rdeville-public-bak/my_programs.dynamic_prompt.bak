# Keep your configuration

-------------------------------------------------------------------------------

This document present how to keep your prompt configuration to avoid losting it
when using a new computer.

-------------------------------------------------------------------------------

# Table of content

# Description

In this document, we will see how to do keep your configuration versionned.
There is two main way to do this:

  - Making a fork from the repo on [framagit][framagit_repo]
  - Cloning this repo local, and push it on another platform

The preferred way is by forking it, especially if you want to contribute, this
will ease you merge request process, but it is not mandatory. If you want to
contribute, see [CONTRIBUTING][contributing] and [Developpers
Guide][developpers_guide]

# Make a fork

If you want to make a fork, simply, from the repo on [framagit][framagit_repo],
click on the `fork` button as shown below:

![fork_button][fork_button]

Then, you will be ask where to store the forked repo, as shown below:

![fork_namespace][fork_namespace]

Then, clone your fork on your computer. Make your own modification, commit them
and push them. They will be push on your fork. Thus, if you change computer, you
will just need to clone your fork.

# Make a clone on other platform

For this section, we will assume you already prepared an empty repo on your
other platforms, for this example, we will use `mygitplaform.tld`. As there
exists a lots of different git platforms, please refers to the documentation of
your platforms.

If you want to version your configuration on other platforms, first, you need
to clone this repo :

```bash
git clone https://framagit.org/rdeville/dynamic-prompt.git
```

Then, go to the repo and update the remote, i.e. the URL to which the repo will
be pushed. In this example, we have already create an empty repo on
`mygitplaform.tld/user/my-dynamic-prompt`.

```bash
# Go to the prompt folder
cd dynamic-prompt
# Remove the origin remote that point to https://framagit.org/rdeville/dynamic-prompt.git
git remote remove origin

# Add your own origin remote usic https
git remote add origin https://mygitplaform.tld/user/my-dynamic-prompt.git

# OR

# Add your own origin remote usic ssh
git remote add origin user@mygitplaform.tld:my-dynamic-prompt.git

```

The make your own modification, commit them and push them. They will be push
your own origin remote, i.e. in this exemple
`mygitplatfor.tld/user/my-dynamic-prompt`.


# Resynchronize with the main repo

If you want to update your own repo to have the last version of the prompt, you
will first need to add a remote pointing to the main repo on
[framagit][framagit_repo].

First, list the current remote to ensure that remote `upstream` does not exists
yet:

```bash
git remote -v
> origin <URL_TO_YOUR_ORIGIN_REMOTE> (fetch)
> origin <URL_TO_YOUR_ORIGIN_REMOTE> (push)
```

If there is not upstream, add the `upstream` remote:

```bash
git remote add upstream https://framagit.org/rdeville/dynamic-prompt.git
```

Ensure that the remote upstream is well sets:
```bash
git remote -v
> origin <URL_TO_YOUR_ORIGIN_REMOTE> (fetch)
> origin <URL_TO_YOUR_ORIGIN_REMOTE> (push)
> upstream https://framagit.org/rdeville/dynamic-prompt.git (fetch)
> upstream https://framagit.org/rdeville/dynamic-prompt.git (push)
```

Once done, fetch branches from this `upstream` remote, commit to `master` of
the main repo will be stored in local branch `upstream/master ``:

```bash
git fetch upstream
> remote: Counting objects: 75, done.
> remote: Compressing objects: 100% (53/53), done.
> remote: Total 62 (delta 27), reused 44 (delta 9)
> Unpacking objects: 100% (62/62), done.
> From https://framagit.org/rdeville/dynamic-prompt.git
>  * [new branch]      master     -> upstream/master*
```

Check out your fork's local `master` branch.

```bash
git checkout master
> Switched to branch 'master'
```

Merge the changes from `upstream/master` into your local `master` branch. This
brings your fork's `master` branch into sync with the `upstream` repository,
without losing your local changes.

```bash
git merge upstream/master
> Updating a422352..5fdff0f
> Fast-forward
>  README                    |    9 -------
>  README.md                 |    7 ++++++
>  2 files changed, 7 insertions(+), 9 deletions(-)
>  delete mode 100644 README
>  create mode 100644 README.md
```

If your local branch didn't have any unique commits, Git will instead perform a
"fast-forward":

```bash
git merge upstream/master
> Updating 34e91da..16c56ad
> Fast-forward
>  README.md                 |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
```

Here you are up-to-date with the main repo ;-).


[framagit]: https://framagit.org
[framagit_repo]: https://framagit.org/rdeville/dynamic-prompt
[contributing]: CONTRIBUTING.md
[developpers_guide]: doc/developpers_guide.md

[fork_button]: doc/img/fork_button.png
[fork_namespace]: doc/img/fork_namespace.png
