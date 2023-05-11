def 'rss' [ ] { 
   let gorssbak = (pwd)
   cd ($nu.config-path | path dirname | path join 'configs/gorss')
   gorss -theme theme.json -config gorss.json -db ($nu.config-path | path dirname | path join 'configs/gorss/gorss.db')
   cd ($gorssbak)
}