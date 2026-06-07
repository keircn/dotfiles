# Git: default branch detection
__git.default_branch() {
  git rev-parse --git-dir &>/dev/null || return
  local default_branch
  default_branch=$(git config --get init.defaultBranch 2>/dev/null)
  if [[ -n "$default_branch" ]] && git show-ref -q --verify "refs/heads/$default_branch" &>/dev/null; then
    echo "$default_branch"
  elif git show-ref -q --verify refs/heads/main &>/dev/null; then
    echo main
  else
    echo master
  fi
}

# Git: delete multiple branches
__git.delete_branches() {
  local delete_flag="-d"
  for arg in "$@"; do
    if [[ "$arg" == "-f" ]] || [[ "$arg" == "--force" ]]; then
      delete_flag="-D"
      shift
    fi
  done
  for branch in "$@"; do
    git branch "$delete_flag" "$branch"
  done
}

# Git: check if branch has --wip-- commit
__git.branch_has_wip() {
  git log -n 1 2>/dev/null | grep -qc "--wip--"
}

# gwip: commit a work-in-progress branch
gwip() {
  git add -A
  git rm $(git ls-files --deleted) 2>/dev/null
  git commit -m "--wip--" --no-verify
}

# gunwip: uncommit the work-in-progress branch
gunwip() {
  if git log -n 1 | grep -q -c "--wip--"; then
    git reset HEAD~1
  fi
}

# gbda: delete all branches merged in current HEAD, including squashed
gbda() {
  local opt_gone=false
  for arg in "$@"; do
    [[ "$arg" == "-g" || "$arg" == "--gone" ]] && opt_gone=true
  done

  local default_branch
  default_branch=$(__git.default_branch)

  if $opt_gone; then
    __git.delete_branches --force \
      $(git for-each-ref refs/heads/ --format="%(refname:short) %(upstream:track)" | awk '$2 == "[gone]" {print $1}')
  fi

  __git.delete_branches \
    $(git branch --merged | grep -vE '^\*|^\+|^\s*(master|main|develop)\s*$' | sed 's/^[ *]*//')

  local branch merge_base
  git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do
    merge_base=$(git merge-base "$default_branch" "$branch" 2>/dev/null)
    local result
    result=$(git cherry "$default_branch" "$(git commit-tree "$(git rev-parse "$branch^{tree}")" -p "$merge_base" -m _)" 2>/dev/null)
    if [[ "$result" == -* ]]; then
      __git.delete_branches --force "$branch"
    fi
  done
}

# gbage: list local branches and display their age
gbage() {
  git for-each-ref --sort=committerdate refs/heads/ \
    --format="%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))"
}

# grename: rename branch locally and on origin
grename() {
  if [[ $# -ne 2 ]]; then
    echo "Usage: grename old_branch new_branch"
    return 1
  fi
  git branch -m "$1" "$2"
  git push origin :"$1" && git push --set-upstream origin "$2"
}

# grt: cd into the top of the current repository
grt() {
  cd "$(git rev-parse --show-toplevel 2>/dev/null || echo .)"
}

# grel: print path relative to repository root
grel() {
  local repo_dir
  repo_dir=$(git rev-parse --show-prefix 2>/dev/null)
  if [[ -n "$repo_dir" ]]; then
    echo "/$repo_dir"
  else
    echo "/"
  fi
}

# glp: git log at requested pretty level
glp() {
  if [[ -n "$1" ]]; then
    git log --pretty="$1"
  fi
}

# gignored: list temporarily ignored files
gignored() {
  git ls-files -v | grep "^[[:lower:]]"
}

# gdv: pipe git diff to view
gdv() {
  git diff -w "$@" | view -
}

# gtest: test command on staged changes only
gtest() {
  git stash push -q --keep-index --include-untracked || return
  "$@"
  local cmdstatus=$?
  git reset -q
  git restore .
  git stash pop -q --index || return $?
  return $cmdstatus
}

# gtl: list tags matching prefix
gtl() {
  git tag --sort=-v:refname -n -l "${1}*"
}
