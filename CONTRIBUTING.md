# CONTRIBUTING

-------------------------------------------------------------------------------

This documents describe the process to follow if you want to contribute.

-------------------------------------------------------------------------------

## Workflow

### Branching model

The repo use git flow branching model, for more information see:

  * [A successful git branching model][git_branching_model].

To help you following this branching model, you can use `git flow` command. To
install this command, see:

  * [git flow][git_flow] to install package
  * [git flow cheatsheet][git_flow_cheatsheet]

Branches must start with prefix `feature-`, `bugfix-`, `release-` and`hotfix-`.

**The main repo is hosted on
[framagit.org/rdeville/dynamic-prompt][framagit_dynamic_prompt], issues, merge
request, etc will not be considered if posted on other plaforms. Moreover, only
branch `master` is available on other platforms.**

Why ? Because I :

  * prefer to use self-hosted git solution even if I use other platform as mirror
  * prefer to use solution for which I know that people behind defend same
   motivation as mine
  * am french, so I want to use "local" plateform
  * know that [framasoft][framasoft] servers are in France and so are submit
    under the french law.

## How to contribute ?

Exept for the main developpers, `master`, `develop`, `release-*`, `hotfix-*`
branches are protected. You will not be able to push directly on these branches.

For now, main developpers are:

  - @rdeville

Yeah, only me, but if you are intersted to invest in this project, you are
welcome ;-).

The best way to contribute, as well as also keeping your configuration is to
fork this repos, make modification on your own repos, test it, make your own
configuration, etc. then open issues if you find some bugs, to propose
improvement, new features, etc., propose a merge request on the `develop`
branch.

But it is not an obligation to fork this repo, you can directly work on it if
you want, but branches that are pushed on this repo and that will not follow the
branching model as well as not following prefix described above will be deleted.

Here is a little workflow describing how to do:

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

For more information, you can check [Developpers Guide][developpers_guide] which
provide you guidelines and a tutorial following in details this workflow. It
also describe how to raise an issues, etc.


[developpers_guide]: doc/developpers_guide.md
[keep_your_configuration]: doc/keep_your_configuration.md
[doc_configuration]: doc/configuration.md
[per-segment-configuration]: doc/configuration.md#per-segment-configuration

[git_branching_model]: https://nvie.com/posts/a-successful-git-branching-model/
[git_flow]: https://github.com/nvie/gitflow/wiki/Installation
[git_flow_cheatsheet]: https://danielkummer.github.io/git-flow-cheatsheet/
[framagit_dynamic_prompt]: https://framagit.org/rdeville/dynamic-prompt
[framasoft]: https://framasoft.org
[gitmoji]: https://github.com/carloscuesta/gitmoji