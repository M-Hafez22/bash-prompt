# .bashrc

# get current status of git repo
function parse_git_dirty {
   STATUS="$(git status 2>/dev/null)"
   if [[ $? -ne 0 ]]; then
      printf "!"
      return
   else printf ""; fi
   if echo ${STATUS} | grep -c "renamed:" &>/dev/null; then printf "\e[1;96m󰑕 \e[0m"; else printf ""; fi
   if echo ${STATUS} | grep -c "branch is ahead:" &>/dev/null; then printf "\e[1;96m! \e[0m"; else printf ""; fi
   if echo ${STATUS} | grep -c "new file::" &>/dev/null; then printf "\e[1;96m \e[0m"; else printf ""; fi
   if echo ${STATUS} | grep -c "Untracked files:" &>/dev/null; then printf "\e[1;96m? \e[0m"; else printf ""; fi
   if echo ${STATUS} | grep -c "modified:" &>/dev/null; then printf "\e[1;96m \e[0m"; else printf ""; fi
   if echo ${STATUS} | grep -c "deleted:" &>/dev/null; then printf "\e[1;96m \e[0m"; else printf ""; fi
   printf ""
}

# List programming language used in the current folder
function lang {
   LANG="$(ls 2>/dev/null)"
   if [[ $? -ne 0 ]]; then
      printf ""
      return
   else printf ""; fi
   if echo ${LANG} | grep -c "*.sh" &>/dev/null; then printf "\e[32m \e[0m"; else printf ""; fi
   if echo ${LANG} | grep -c "*.md" &>/dev/null; then printf "\e[0m \e[0m"; else printf ""; fi
   if echo ${LANG} | grep -c "*.js" &>/dev/null; then printf "\e[33m \e[0m"; else printf ""; fi
   if echo ${LANG} | grep -c "*.ts" &>/dev/null; then printf "\e[34m \e[0m"; else printf ""; fi
   if echo ${LANG} | grep -c "*.html" &>/dev/null; then printf "\e[33m \e[0m"; else printf ""; fi
   if echo ${LANG} | grep -c "*.css" &>/dev/null; then printf "\e[34m \e[0m"; else printf ""; fi
   if echo ${LANG} | grep -c "*.py" &>/dev/null; then printf "\e[34m󰌠 \e[0m"; else printf ""; fi
   printf ""
}

# Check the host  or 
function git_repo {
   REPO="$(git remote -v 2>/dev/null)"
   if [[ $? -ne 0 ]]; then
      printf ""
      return
   else printf ""; fi
   if echo ${REPO} | grep -c "github" &>/dev/null; then printf "\e[97m  \e[0m"; else printf ""; fi
   if echo ${REPO} | grep -c "gitlab" &>/dev/null; then printf "\e[33m  \e[0m"; else printf ""; fi
   printf ""
}

parse_git_branch() {
   # Long form
   # git rev-parse --abbrev-ref HEAD 2> /dev/null
   # Short form
   git rev-parse --abbrev-ref HEAD 2>/dev/null | sed -e 's/.*\/\(.*\)/\1/'
}

battery_state_capacity() {
   BATTERY=/sys/class/power_supply/BAT0

   CAPACITY=$(cat $BATTERY/capacity)
   STATE=$(cat $BATTERY/status)

   COLOR="\e[0m"

   case "${STATE}" in
   'Full')
      STATE="\e[1;36m󰁹 "
      ;;
   'Charging')
      STATE="\e[1;36m󰚥 "
      ;;
   'Discharging')
      STATE="\e[1;31m󰚦 "
      ;;
   esac

   # color code capacity
   if [ "$CAPACITY" -gt "5" ]; then
      COLOR="\e[1;5;31m󱚞󰁺"
   fi
   if [ "$CAPACITY" -gt "10" ]; then
      COLOR="\e[1;5;31m󰁺"
   fi
   if [ "$CAPACITY" -gt "20" ]; then
      COLOR="\e[1;31m󰁻"
   fi
   if [ "$CAPACITY" -gt "30" ]; then
      COLOR="\e[1;35m󰁼"
   fi
   if [ "$CAPACITY" -gt "40" ]; then
      COLOR="\e[1;35m󰁽"
   fi
   if [ "$CAPACITY" -gt "50" ]; then
      COLOR="\e[1;32m󰁾"
   fi
   if [ "$CAPACITY" -gt "60" ]; then
      COLOR="\e[1;32m󰁿"
   fi
   if [ "$CAPACITY" -gt "70" ]; then
      COLOR="\e[1;32m󰂀"
   fi
   if [ "$CAPACITY" -gt "80" ]; then
      COLOR="\e[1;34m󰂁"
   fi
   if [ "$CAPACITY" -gt "90" ]; then
      COLOR="\e[1;34m󰂂"
   fi
   if [ "$CAPACITY" -gt "99" ]; then
      COLOR="\e[1;36m󰁹"
   fi

   echo -e "${STATE}${COLOR}${CAPACITY}\e[0m"
}

__export_ps1() {
   export PS1="\n\e[1;31m  \e[0m[$(battery_state_capacity)]-\e[0m[\e[1;33m \W\e[0m]-\e[0m[\e[33m\$(parse_git_branch)\e[31m \$(parse_git_dirty)\$(git_repo)\e[0m]-[\$(lang)]\e[0m\n "
}
__export_ps1
PROMPT_COMMAND='__export_ps1'

bind -s 'set completion-ignore-case on'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
