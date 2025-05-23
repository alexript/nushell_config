alias vi = nvim
alias aliases = vi ($nu.config-path | path dirname | path join 'scripts' | path join 'aliases.nu' )
alias conf = cd ($nu.config-path | path dirname )

alias lua = lua54
alias luac = luac54
alias wlua = wlua54

alias wiki = wiki-tui

alias whereis = which
alias irc = weechat
alias mutt = neomutt
alias mail = neomutt

def 'gh-' [ ] { 
   gh dash -c ($nu.config-path | path dirname | path join 'configs/gh-dash.yaml')
}

alias sc = sc-im

