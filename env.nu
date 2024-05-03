# Nushell Environment Config File
#
# version = 0.78.0


# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
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
$env.NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts')
    ($nu.config-path | path dirname | path join 'nu_scripts' )
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
$env.NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# let-env PATH = ($env.PATH | split row (char esep) | prepend '/some/path')

$env.localpathfile = ($nu.config-path|path dirname| path join  'local.path')
if ($nu.os-info.family == 'windows') and ("Path" in $env) {
 $env.Path = ($env.Path | split row (char esep) | prepend ($nu.config-path|path dirname| path join  'bin_portable'))
 if ($env.localpathfile | path exists) {
    $env.Path = ($env.Path | split row (char esep) | prepend ( open $env.localpathfile | lines | str trim ))
 }

} else {
 $env.PATH = ($env.PATH | split row (char esep) | prepend ($nu.config-path|path dirname| path join  'bin_portable'))
 if ($env.localpathfile | path exists) {
    $env.PATH = ($env.PATH | split row (char esep) | prepend ( open $env.localpathfile | lines |str trim ))
 }

}

load-env {
 'FZF_DEFAULT_OPTS':  "--height 80% --layout=reverse --border --inline-info --preview 'cat {}' --color 'bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796,fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6,marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796'",
}

$env.localenvfile = ( $nu.config-path|path dirname | path join  'local.env' )
if ($env.localenvfile | path exists) {
  load-env  ( $env.localenvfile | open | lines | parse -r '(?P<k>.+?)=(?P<v>.+)' | reduce -f {} {|x, acc| $acc | upsert $x.k $x.v} ) 
}


#let localenv = ($nu.config-path|path dirname| path join  'local.env')
#if ($localenv|path exists) {
#        open $localenv | lines | parse "{var} = {val}" |str trim 
#    }

