alias la='ls -A'
alias l='ls -CF'
alias ll='ls -alF'
alias grep='grep --color=auto'
alias ..='cd ..'
alias gs='git status'
alias mv='mv -i'
alias rm='rm -i'
alias cat='bat'

alias dc='docker-compose'
alias account_all='dc run --rm mcapi mc-api create_account --first-name=test --last-name=user --username=test@example.com --password=test --email=test@example.com --phone="555-555-5555" --role=all'
alias account_bed='dc run --rm mcapi mc-api create_account --first-name=test --last-name=bed --username=test-bed@example.com --password=test --email=test-bed@example.com --phone="555-555-5555" --role=bed'
alias account_none='dc run --rm mcapi mc-api create_account --first-name=test --last-name=none --username=test-none@example.com --password=test --email=test-none@example.com --phone="555-555-5555" --role=none'
alias nuke='dc kill && dc rm -vf && dc up --remove-orphans -d && dc run --rm mcapi mc-api create_account --first-name=test --last-name=user --username=test@example.com --password=test --email=test@example.com --phone="555-555-5555" --role=all'

if [[ -f "/Users/eloy/Code/docker-development/.env_docker_development" ]]; then
    source "/Users/eloy/Code/docker-development/.env_docker_development"
fi

if [[ -f "/Users/eloy/Code/decisio/helm/.env" ]]; then
    source "/Users/eloy/Code/decisio/helm/.env"
fi

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

_codefresh_completions()
{
    local cur args type_list

    cur="${COMP_WORDS[COMP_CWORD]}"
    args=("${COMP_WORDS[@]}")

    # ask codefresh to generate completions.
    type_list=$(codefresh --get-yargs-completions "${args[@]}")

    if [[ ${type_list} == '__files_completion__' ]]; then
        _filedir "@(yaml|yml|json)"
    else
        COMPREPLY=( $(compgen -W "${type_list}" -- ${cur}) )
    fi

    return 0
}
complete -F _codefresh_completions cf

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
# Startship cross-shell prompt
eval "$(starship init bash)"
