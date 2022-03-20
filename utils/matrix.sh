# Matrix-style screensaver for your terminal
# Either run execute the script directly,
# Or source it in .zshrc, and start with $ matrix

matrix () {
  local lines=$(tput lines)
  cols=$(tput cols)

  awkscript='
  {
    letters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"
    lines=$1
    random_col=$3
    c=$4
    letter=substr(letters,c,1)
    cols[random_col]=0;
    for (col in cols) {
      line=cols[col];
      cols[col]=cols[col]+1;
      printf "\033[%s;%sH\033[2;32m%s", line, col, letter;
      printf "\033[%s;%sH\033[1;37m%s\033[0;0H", cols[col], col, letter;
      if (cols[col] >= lines) {
          cols[col]=0;
      }
    }
  }
  '

  echo -e "\e[1;40m"
  clear

  while :; do
    echo $lines $cols $(( $RANDOM % $cols)) $(( $RANDOM % 72 ))
    sleep 0.05
  done | awk "$awkscript"
}

# Determine if file is being run directly or sourced
([[ -n $ZSH_EVAL_CONTEXT && $ZSH_EVAL_CONTEXT =~ :file$ ]] || 
 [[ -n $KSH_VERSION && $(cd "$(dirname -- "$0")" &&
    printf '%s' "${PWD%/}/")$(basename -- "$0") != "${.sh.file}" ]] || 
 [[ -n $BASH_VERSION ]] && (return 0 2>/dev/null)) && sourced=1 || sourced=0

# If script being called directly, start matrix
if [ $sourced -eq 0 ]; then
  matrix
fi
