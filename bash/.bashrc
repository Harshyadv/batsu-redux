# .bashrc
# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi
# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH
# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=
# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# Ruby Pathing
export GEM_HOME="$HOME/.gems"
export PATH="$HOME/.gems/bin:$PATH"

# 1. Git Status Helper
get_git_info() {
    local branch=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
    [[ -z "$branch" ]] && return

    # Green if clean, Red if dirty
    local color="\[\e[32m\]"
    [[ -n $(git status -s 2>/dev/null) ]] && color="\[\e[31m\]"

    # Sync status
    local ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null)
    local behind=$(git rev-list --count HEAD..@{u} 2>/dev/null)
    local sync=""
    [[ "$ahead" -gt 0 ]] && sync+=" ↑$ahead"
    [[ "$behind" -gt 0 ]] && sync+=" ↓$behind"

    echo -e " ${color}(${branch}${sync})\[\e[0m\]"
}

# 2. Final Prompt Construction (All ANSI)
PS1="\[\e[97m\][\t] \
\[\e[32m\]\u@\h \
\[\e[33m\]\w\
\$(get_git_info) \
\[\e[93m\]\$ \
\[\e[0m\]"

