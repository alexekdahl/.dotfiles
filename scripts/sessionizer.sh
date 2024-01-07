#!/usr/bin/env bash
select_project() {
  local work_root="$HOME/dev/axis/repo"
  local personal_root="$HOME/dev/personal"
  local dotfiles_root="$HOME/.dotfiles"

  local personal_root_color="\033[32m"
  local work_root_color="\033[33m"
  local dotfiles_root_color="\033[35m"
  local reset_color="\033[0m"

  local fzf_height="50%"
  local dir

  dir=$( (find $work_root $personal_root -mindepth 1 -maxdepth 1 -type d; echo $dotfiles_root;) \
      | awk -v work="$work_root" -v personal="$personal_root" -v dotfiles="$dotfiles_root" -v workColor="$work_root_color" -v personalColor="$personal_root_color" -v dotfilesColor="$dotfiles_root_color" -v downloadsColor="$dotfiles_root_color" -vreset="$reset_color" '
          { if ($0 == dotfiles)
              printf dotfilesColor "%s" reset "\n", $0
            else if (index($0, work) > 0)
              printf workColor "%s" reset "\n", $0
            else if (index($0, personal) > 0)
              printf personalColor "%s" reset "\n", $0
          }' \
      | fzf --ansi --print0 -m -1 --border=rounded --height $fzf_height)

  [[ -n "$dir" ]] && echo "$dir"
}

get_session_name() {
    project_dir=$1
    provided_session_name=$2

    directory=$(basename "$project_dir")
    session_name=""
    if [ "$provided_session_name" = "" ]; then
        session_name=$(echo "$directory" | tr ' .:' '_')
    else
        session_name="$provided_session_name"
    fi
    echo "$session_name"
}


project_dir=$(select_project)

if [ "$project_dir" = "" ]; then
    exit 0
fi

session_name=$(get_session_name "$project_dir" "$1")

# If we outside of zellij initialize session and attach to it, or just attach to it
if [[ -z $ZELLIJ ]]; then
    session=$(zellij list-sessions | grep "$session_name")

    cd $project_dir

    if [ "$session" = "" ]; then
        zellij -s $session_name --layout code options --default-cwd $project_dir
        exit 0
    fi

    zellij a $session_name 
    exit 0
fi


zellij action new-tab --layout default --name $session_name --cwd $project_dir
zellij action go-to-tab-name $session_name
