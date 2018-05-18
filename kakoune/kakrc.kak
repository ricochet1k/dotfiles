
# Enable line numbers
hook global WinCreate ^[^*]+$ %{
    add-highlighter window number_lines -hlcursor
    add-highlighter window  show_whitespaces -tab '|' -tabpad '-' -spc ' ' -lf ' '
    set-face window Whitespace rgb:333333
    }

map global normal <c-n> :buffer-next<ret>
map global normal <c-p> :buffer-previous<ret>


map global user -docstring 'close current buffer' d ':delete-buffer<ret>'

# Clipboard
map global user -docstring 'copy to system clipboard' y '<a-|>xsel --input --clipboard<ret>'
map global user -docstring 'paste from system clipboard' P '!xsel --output --clipboard<ret>'
map global user -docstring 'paste from system clipboard' p '<a-!>xsel --output --clipboard<ret>'

def plug-install -hidden -params 2 %{
    %sh{
        (
            set -e
            if [[ ! -d $kak_config/$1 ]]; then
                mkdir $kak_config/$1
            fi
            cd $kak_config/$1

            name=$(basename $2)
            case $2 in
              *://*) url=$2 ;;
              *) url=https://github.com/$2 ;;
            esac

            # Check out the repo to ~/build if it does not exist
            if [[ ! -d ./$name ]]; then
                git clone $url $name
            fi

            if [ "$1" = "plugins" ]; then
                # Source all .kak files in it
                for file in $(echo ./$name/*.kak); do
                    echo source "$PWD/$file"
                done
            fi
        )
    }
}
def plug -hidden -params 1 %{ plug-install plugins %arg{1} }
def plug-colors -hidden -params 1 %{ plug-install colors %arg{1} }


def -docstring 'show a parallel file browser' \
  file-browser %{ %sh{
    
} }

def -docstring 'invoke fzf to open a file' \
  fzf-file %{ %sh{
    if [ -z "$TMUX" ]; then
      echo echo only works inside tmux
    else
      FILE=$(find * -type f | fzf-tmux -d 15)
      if [ -n "$FILE" ]; then
        printf 'eval -client %%{%s} edit %%{%s}\n' "${kak_client}" "${FILE}" | kak -p "${kak_session}"
      fi
    fi
} }

def -docstring 'invoke fzf to select a buffer' \
  fzf-buffer %{ %sh{
    if [ -z "$TMUX" ]; then
      echo echo only works inside tmux
    else
      BUFFER=$(printf %s\\n "${kak_buflist}" | tr : '\n' | fzf-tmux -d 15)
      if [ -n "$BUFFER" ]; then
        echo "eval -client '$kak_client' 'buffer ${BUFFER}'" | kak -p ${kak_session}
      fi
    fi
} }


plug Delapouite/kakoune-expand-region
plug Delapouite/kakoune-buffers
plug https://gitlab.com/Screwtapello/kakoune-cargo
plug-colors alexherbo2/kakoune-dracula-theme

colorscheme desertex
