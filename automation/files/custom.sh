# History settings
export HISTCONTROL=ignoredups:erasedups  # No duplicate entries.
export HISTSIZE=100000                   # Big BIG history.
export HISTFILESIZE=100000               # Big BIG history.
export HISTTIMEFORMAT="%F %r "           # Timestamp.
shopt -s histappend                      # Append to history, don't overwrite it.
# Save and reload the history after each command finishes:
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Prompt settings
__git_branch() {
  git branch 2>/dev/null | grep -e '^*' | sed -E 's/^\* (.+)$/(\1)/'
}
if [ $EUID -eq 0 ]; then
    PS1="\[\e[1;31m\]\u\[\e[1;33m\]@\[\e[1;35m\]\h\[\e[1;33m\]:\[\e[1;34m\]\w\[\e[0;33m\]$(__git_branch)\[\e[0m\] ";
else
    PS1="\[\e[1;32m\]\u\[\e[1;33m\]@\[\e[1;35m\]\h\[\e[1;33m\]:\[\e[1;34m\]\w\[\e[0;33m\]$(__git_branch)\[\e[0m\] ";
fi

# Alias settings
alias ls='ls -h  --group-directories-first --color=auto'
alias la='ls -al'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias hg='history | grep'
alias df='df -h'

# use htop and colordiff
command -v colordiff >/dev/null 2>&1 && alias diff="colordiff -u"
command -v htop >/dev/null 2>&1 && alias top=htop

# Option settings
shopt -s cdspell
shopt -s dirspell
shopt -s autocd
shopt -s checkwinsize #resize output to match window

# extract function
function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz |tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
 else
    for n in $@
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar) tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm| *.udf|*.wim|*.xar) 7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}

