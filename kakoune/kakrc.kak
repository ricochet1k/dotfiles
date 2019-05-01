
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
    cd ~/.config/kak/plugins/plug.kak
    git checkout dev
  fi
}

source "%val{config}/plugins/plug.kak/rc/plug.kak"
map global user -docstring 'open file' e ':skim-edit<ret>'
map global user -docstring 'find and open file' f ':skim-find<ret>'

define-command -hidden skim-edit %{
  tmux-terminal-vertical sh -c "echo eval -client %val{client} ""edit $(sk --reverse -c 'fd -t f')"" | kak -p %val{session}"
}

define-command -hidden skim-find %{
  tmux-terminal-vertical sh -c "echo eval -client %val{client} ""edit $(sk --ansi -i --reverse -c 'rg --color=always --line-number {}' | cut -d: -f1,2 --output-delimiter=' ')"" | kak -p %val{session}"
}

define-command -hidden broot-edit %{
  eval %sh{
    tmp=$(mktemp ${TMPDIR:-/tmp}/kak-broot.XXXXX)
    cat << EOF > $tmp
    set +e
    broot --out $tmp.out
    code=\$?
    printf "echo -debug '%s'\n" "return \$code" | kak -p $kak_session
    if [ "\$code" == "0" ] ; then
      printf "echo -debug '%s'\n" "reading $tmp.out" | kak -p $kak_session
      printf "echo -debug '%s'\n" "$(cat $tmp.out)" | kak -p $kak_session
      while read line ; do
        printf "edit '%s'\n" "\$line" | kak -p $kak_session
        printf "echo -debug '%s'\n" "\$line" | kak -p $kak_session
      done < $tmp.out
    fi
    #rm $tmp
    #rm $tmp.out
EOF
    chmod u+x "$tmp"
    printf "tmux-terminal-vertical '%q'\n" "$tmp"
  }
}

declare-option -hidden str powerline_sep '' # options:    
declare-option -hidden str powerline_sep_thin '' # thin:     
declare-option -hidden str-list powerline_colors 
declare-option -hidden str-list powerline_format 

define-command -hidden -params 2 powerline-segment %{
  set -add global powerline_colors %arg{1}
  set -add global powerline_format %arg{2}
}

powerline-segment 'black,yellow' '%val{bufname}'
powerline-segment 'black,bright-blue' '%val{cursor_line}:%val{cursor_char_column}'
powerline-segment 'black,default' '{{context_info}}'
powerline-segment 'black,default' '{{mode_info}}'

hook -group powerline global GlobalSetOption powerline_.* %{
  powerline_render
}

define-command -hidden powerline_render %{
  evaluate-commands %sh{
    eval set -- "$kak_opt_powerline_colors" ; colors=( "$@" )
    eval set -- "$kak_opt_powerline_format" ; format=( "$@" )

    modeline=''
    prev_bg='default'
    for i in "${!colors[@]}"; do
      col="${colors[$i]}"
      fg="${col%%,*}"
      bg="${col#*,}"
      if [[ "$bg" == *+* ]]; then
        col=$bg
        bg="${col%%+*}"
        attrs="+${col#*+}"
      fi
      if [[ "$bg" == "$prev_bg" ]]; then
        modeline="$modeline {$fg,$bg}$kak_opt_powerline_sep_thin{$fg,$bg$attrs} ${format[$i]} "
      else
        modeline="$modeline {$bg,$prev_bg}$kak_opt_powerline_sep{$fg,$bg$attrs} ${format[$i]} "
      fi
      prev_bg=$bg
    done

    echo "set global modelinefmt '$modeline'"
  }
}

powerline_render


#set global modelinefmt '%val{bufname} %val{cursor_line}:%val{cursor_char_column} {{context_info}} {{mode_info}} - %val{client}@[%val{session}]'


plug "andreyorst/plug.kak" branch "dev" noload
plug Delapouite/kakoune-expand-region
plug Delapouite/kakoune-buffers
plug https://gitlab.com/Screwtapello/kakoune-cargo
plug andreyorst/fzf.kak
plug alexherbo2/auto-pairs.kak
#plug-colors alexherbo2/kakoune-dracula-theme
plug "ul/kak-lsp" noload do %{ cargo build --release } %{
  eval %sh{ kak-lsp --kakoune -s $kak_session --config $(dirname $kak_source)/kak-lsp.toml }
  #debug mode
  nop %sh{
    if [[ $KAK_LSP_DEBUG == 1 ]]; then
      ( kak-lsp -s $kak_session -vvv ) > /tmp/kak-lsp.log 2>&1 < /dev/null &
    fi
  }
  lsp-enable
  lsp-auto-hover-enable
  #set global lsp_hover_anchor true
  map global user -docstring 'LSP' l ':enter-user-mode lsp<ret>'
}

colorscheme desertex

