
set PATH $HOME/.cargo/bin $PATH

function update-x11-forwarding --on-event fish_prompt
	if [ -z "$STY" -a -z "$TMUX" -a -n "$DISPLAY" ]
		echo $DISPLAY > ~/.display.txt
	else
		set -gx DISPLAY (cat ~/.display.txt)
	end
end

function segment -a fg bg text -d Add prompt segment
	if [ -n "$__segment_prev_bg" ]
		set_color $__segment_prev_bg -b $bg
		printf '%s' ""
	end

	set -g __segment_prev_bg $bg
	set_color $fg -b $bg
	printf '%s' "$text"
end

function _clear_segment_prev_bg -e fish_prompt
	set -ge __segment_prev_bg
end

function fish_prompt
	set -l prevstatus $status
	if [ "$prevstatus" != "0" ]
		segment brwhite red $prevstatus
	end
	segment brwhite blue $PWD
	segment normal normal ' '
end

