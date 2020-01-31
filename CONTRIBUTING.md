# CONTRIBUTING

This documents describe the process to follow if you want to contribute.

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
  * know that [framasoft][framasoft] server are in France and so are submit
    under the french law.

## How to contribute ?

Exept for the main developpers, `master`, `develop`, `release-*`, `hotfix-*` are
protected. You will not be able to push directly on these branches.

For now, main developpers are:

  - @rdeville











[git_branching_model]: https://nvie.com/posts/a-successful-git-branching-model/
[git_flow]: https://github.com/nvie/gitflow/wiki/Installation
[git_flow_cheatsheet]: https://danielkummer.github.io/git-flow-cheatsheet/
[framagit_dynamic_prompt]: https://framagit.org/rdeville/dynamic-prompt
[framasoft]: https://framasoft.org