
# Enable line numbers
hook global WinCreate ^[^*]+$ %{
    add-highlighter window/ number_lines -hlcursor
    add-highlighter window/ show_whitespaces -tab '|' -tabpad '-' -spc ' ' -lf ' '
    set-face window Whitespace rgb:333333
    add-highlighter window/ show_matching
    }

# Buffer switching
map global normal <c-n> :buffer-next<ret>
map global normal <c-p> :buffer-previous<ret>

# Indent/dedent with tab
map global insert <tab> '<a-;><gt>'
map global insert <s-tab> '<a-;><lt>'

# Close buffer with ,d
map global user -docstring 'close current buffer' d ':delete-buffer<ret>'

# Switch buffer with ,b
map global user -docstring 'Switch buffer' b ':buffer '

# Clipboard
map global user -docstring 'copy to system clipboard' y '<a-|>xsel --input --clipboard<ret>'
map global user -docstring 'paste from system clipboard' P '!xsel --output --clipboard<ret>'
map global user -docstring 'paste from system clipboard' p '<a-!>xsel --output --clipboard<ret>'

set global tabstop 2
set global indentwidth 2

def plug-install -hidden -params 2 %{
    eval %sh{
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
            else
               ( cd ./$name; git pull > /dev/null )
            fi

            if [ "$1" = "plugins" ]; then
                # Source all .kak files in it
                for file in ./$name/*.kak; do
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

# Language Server
eval %sh{kak-lsp --kakoune -s $kak_session --config $(dirname $kak_source)/kak-lsp.toml}

