
# Enable line numbers
hook global WinCreate ^[^*]+$ %{
    add-highlighter window/ number-lines -hlcursor
    add-highlighter window/ show-whitespaces -tab '|' -tabpad '-' -spc ' ' -lf ' '
    set-face window Whitespace rgb:333333
    add-highlighter window/ show-matching
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

nop %sh{
  if [[ ! -d $kak_config/plugins/plug.kak ]]; then
    mkdir -p $kak_config/plugins/
    git clone https://github.com/andreyorst/plug.kak.git ~/.config/kak/plugins/plug.kak
  fi
}

source "%val{config}/plugins/plug.kak/rc/plug.kak"


plug "andreyorst/plug.kak" "branch: kakoune-git" noload
plug Delapouite/kakoune-expand-region
plug Delapouite/kakoune-buffers
plug https://gitlab.com/Screwtapello/kakoune-cargo.git
#plug-colors alexherbo2/kakoune-dracula-theme
plug "ul/kak-lsp" noload do %{ cargo build --release } %{
    evaluate-commands %sh{ kak-lsp --kakoune -s $kak_session --config $(dirname $kak_source)/kak-lsp.toml }
}

colorscheme desertex
