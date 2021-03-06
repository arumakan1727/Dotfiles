
#======================================================================================
# Functions
# 参考: https://github.com/yutkat/dotfiles/blob/master/.config/zsh/rc/function.zsh
#======================================================================================

function 256color() {
  for code in {000..255}; do
    print -nP -- "%F{$code}$code %f";
    if [ $((${code} % 16)) -eq 15 ]; then
      echo ""
    fi
  done
}

function ascii_color_code() {
  seq 30 47 | xargs -n 1 -i{} printf "\x1b[%dm#\x1b[0m %d\n" {} {}
}

function find_no_new_line_at_end_of_file() {
  find * -type f -print0 | xargs -0 -L1 bash -c 'test "$(tail -c 1 "$0")" && echo "No new line at end of $0"'
}

function xkb_reload_my_settings() {
  xkbcomp -I${HOME}/.xkb ~/.xkb/keymap/mykbd $DISPLAY 2> /dev/null
}

function rm-trash() {
  readonly local trashRootDir="$HOME/.trash"
  readonly local date=$(date "+%Y/%m/%d")
  readonly local time=$(date "+%H:%M:%S")
  readonly local destDir="$trashRootDir/$date/$time"

  command mkdir -p "$destDir"

  for arg in $@; do
    # '-'(ハイフン) で始まる引数は無視
    if [ "$arg" =~ '^-' ]; then
      echo "Info: ignore option '$arg'" 1>&2
      continue
    fi

    if [ ! -e "$arg" ]; then
      echo "Error: '$arg': not found" 1>&2
      continue
    fi

    # .trash/ 内のファイルは .trash/ に退避せず削除
    if [ "$(realpath "$arg")" =~ "^${trashRootDir}" ]; then
      command rm --verbose -rf "$arg"
      continue
    fi

    # .trash/ に退避
    command mv --verbose "$arg" "$destDir"
  done
}

# Blank lines of half the height of the terminal
function blank-half() {
  local count=10
  if [[ $@ -eq 0 ]]; then
    count=$(($(stty size| cut -d' ' -f1)/2))
  else
    count=$1
  fi
  for i in $(seq $count); do
    echo
  done
}
