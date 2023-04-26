# Nushell Environment Config File
#
# version = 0.78.0

def create_left_prompt [] {
    mut home = ""
    try {
        if $nu.os-info.name == "windows" {
            $home = $env.USERPROFILE
        } else {
            $home = $env.HOME
        }
    }

    let dir = ([
        ($env.PWD | str substring 0..($home | str length) | str replace -s $home "~"),
        ($env.PWD | str substring ($home | str length)..)
    ] | str join)

    let path_segment = if (is-admin) {
        $"(ansi red_bold)($dir)"
    } else {
        $"(ansi green_bold)($dir)"
    }

    $path_segment
}

def create_right_prompt [] {
    let time_segment = ([
        (date now | date format '%m/%d/%Y %r')
    ] | str join)

    $time_segment
}

# Use nushell functions to define your right and left prompt
#let-env PROMPT_COMMAND = {|| create_left_prompt }
#let-env PROMPT_COMMAND = { oh-my-posh --config ($nu.config-path | path dirname | path join 'agnosterplus.omp.json') }
#let-env PROMPT_COMMAND_RIGHT = {|| create_right_prompt }


# The prompt indicators are environmental variables that represent
# the state of the prompt
#let-env PROMPT_INDICATOR = {|| "> " }
#let-env PROMPT_INDICATOR_VI_INSERT = {|| ": " }
#let-env PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
#let-env PROMPT_MULTILINE_INDICATOR = {|| "::: " }

let-env POWERLINE_COMMAND = 'oh-my-posh'
let-env POSH_THEME = ($nu.config-path | path dirname | path join 'agnosterplus.omp.json')
let-env PROMPT_INDICATOR = ""
let-env POSH_PID = (random uuid)
# By default displays the right prompt on the first line
# making it annoying when you have a multiline prompt
# making the behavior different compared to other shells
let-env PROMPT_COMMAND_RIGHT = ''
let-env POSH_SHELL_VERSION = (version | get version)
# PROMPTS
let-env PROMPT_MULTILINE_INDICATOR = (^"oh-my-posh" print secondary $"--config=($env.POSH_THEME)" --shell=nu $"--shell-version=($env.POSH_SHELL_VERSION)")
let-env PROMPT_COMMAND = { ||
# We have to do this because the initial value of `$env.CMD_DURATION_MS` is always `0823`,
# which is an official setting.
# See https://github.com/nushell/nushell/discussions/6402#discussioncomment-3466687.
let cmd_duration = if $env.CMD_DURATION_MS == "0823" { 0 } else { $env.CMD_DURATION_MS }
# hack to set the cursor line to 1 when the user clears the screen
# this obviously isn't bulletproof, but it's a start
let clear = (history | last 1 | get 0.command) == "clear"
let width = ((term size).columns | into string)
^"oh-my-posh" print primary $"--config=($env.POSH_THEME)" --shell=nu $"--shell-version=($env.POSH_SHELL_VERSION)" $"--execution-time=($cmd_duration)" $"--error=($env.LAST_EXIT_CODE)" $"--terminal-width=($width)" $"--cleared=($clear)"
}

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
let-env ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) | path expand -n }
    to_string: { |v| $v | path expand -n | str join (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) | path expand -n }
    to_string: { |v| $v | path expand -n | str join (char esep) }
  }
}

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
let-env NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
let-env NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# let-env PATH = ($env.PATH | split row (char esep) | prepend '/some/path')

load-env {
 'FZF_DEFAULT_OPTS':  "--height 80% --layout=reverse --border --inline-info --preview 'cat {}' --color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899'",
}
