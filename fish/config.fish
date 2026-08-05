#Path added
fish_add_path ~/.local/bin/

if status is-interactive
    # Commands to run in interactive sessions can go here
    function fish_greeting
        echo "fish in a shell"
    end
    # Set Neovim as the default editor
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    oh-my-posh init fish --config ~/batsu-redux/oh-my-posh/hul10-remix.omp.json | source

end

