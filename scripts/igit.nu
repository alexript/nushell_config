def 'igit' [ ] { 
   git-igitt --style round --model ($nu.config-path | path dirname | path join 'configs/git-igitt')
}
