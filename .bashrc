export EDITOR=vim
export HISTSIZE=1000000
export HISTIGNORE="&:ls:[bf]g:exit"
export HISTCONTROL=erasedups
shopt -s histappend  # Append to, rather than overwite, to history on disk
PROMPT_COMMAND='history -a' # Write the history to disk whenever you display the prompt
