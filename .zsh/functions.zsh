git-discard-all() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "Not a git repo."; return 1; }
  git reset --hard HEAD && git clean -fdx
}
