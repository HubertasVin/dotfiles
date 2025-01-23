function fish_greeting; end

function fish_preexec --on-event fish_preexec
    set -g __start_time (date +%s%N)
end

function fish_postexec --on-event fish_postexec
    set -l usage_color (set_color cyan)
    set -l normal_color (set_color normal)

    set -l end_time (date +%s%N)
    set -l elapsed_ns (math "$end_time - $__start_time")
    set -l elapsed_sec (echo "$elapsed_ns" | awk '{printf "%.3f", $1/1000000000}')
    set -l elapsed_ms (math "$elapsed_ns / 1000000")
    set -l threshold_ms 2000
    
    if test $elapsed_ms -gt $threshold_ms
        echo -s $usage_color " [Took $elapsed_sec seconds]" $normal_color
    end
end

function fish_prompt
    set -l last_status $status
    set -l normal_color (set_color normal)
    set -l status_color (set_color brgreen)
    set -l cwd_color (set_color brred)
    set -l vcs_color (set_color brpurple)
    set -l suffix_color (set_color brblue)
    set -l git_count_color (set_color --bold bryellow)
    set -l prompt_status ""
    set -l git_count (git status --porcelain 2>/dev/null | wc -l | awk '{print ($1 == 0 ? "" : " !" $1)}')

    # Since we display the prompt on a new line allow the directory names to be longer.
    set -q fish_prompt_pwd_dir_length
    or set -lx fish_prompt_pwd_dir_length 0

    # Color the prompt differently when we're root
    set -l suffix '❯'
    if functions -q fish_is_root_user; and fish_is_root_user
        if set -q fish_color_cwd_root
            set cwd_color (set_color $fish_color_cwd_root)
        end
        set suffix '#'
    end

    # Color the prompt in red on error
    if test $last_status -ne 0
        set status_color (set_color $fish_color_error)
        set prompt_status $status_color "[" $last_status "]" $normal_color
    end

    echo -s $cwd_color (prompt_pwd) $git_count_color $git_count $vcs_color (fish_vcs_prompt) $normal_color ' ' $prompt_status
    echo -n -s $suffix_color $suffix ' ' $normal_color
end

