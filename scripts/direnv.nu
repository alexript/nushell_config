def direnv [] {
    [
        {
            condition: {|before, after| ($before != $after) }
            code: { |before, after|
		if ( ( not ( $before | is-empty ) ) and ($before | path join '.env' | path exists) ) {
		  $before | path join '.env' | open 
		  | lines | parse -r '(?P<k>.+?)=' | reduce -f {} {|x, acc| $acc | upsert $x.k $nothing } | load-env
		}
		if ( ( not ( $after | is-empty ) ) and ($after | path join '.env' | path exists) ) {
                  $after | path join '.env' | open 
                  | lines
                  | parse -r '(?P<k>.+?)=(?P<v>.+)'
                  | reduce -f {} {|x, acc| $acc | upsert $x.k $x.v}
                  | load-env
	        }
            }
        }
    ]
}

export-env {
    let-env config = ( $env.config | upsert hooks.env_change.PWD { |config|
        let o = ($config | get -i hooks.env_change.PWD)
        let val = (direnv)
        if $o == $nothing {
            $val
        } else {
            $o | append $val
        }
    })
}
