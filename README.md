$ rails _8.0_2 new league-system-pro -d=postgresql -c=bootstrap  
$ cd league-system-pro  
$ touch .yarnrc.yml  
(add nodeLinker: node-modules to .yarnrc.yml)  
(Delete the pnp files)  
$ yarn install (node_modules appears)  
$ bundle  
$ rails g scaffold league name:index season:index

```
add null false in migration as needed
eg change:
t.string :name
to
t.string :name, null: false
Rails does not appear to support square bracket options like [null:false,index:true] in generator syntax
so rails g model Testnullfalse date:date[null:false,index:true] or rails g model Testnullfalse date:date:[null:false]:index will fail
```

$ rails db:migrate  
$ bin/dev  

$ rails g scaffold match date:date:index league:references
$ rails g scaffold team name:index  
$ rails g scaffold player first_name:index last_name:index team:references  

```
edit create_players migration from
t.references :team, null: false, foreign_key: true
to
t.references :team, foreign_key: true
ie nil is allowed for team_id, which is consistent with an optional association.
```

$ rails g model participation score:integer match:references participant:references{polymorphic}  

```
the {polymorphic} syntax here doesn't seem to be officially documented, but does work
```

$ rails db:migrate

```
to run system tests ensure chromium-browser installed:
$ chromium-browser --version
$ sudo apt install chromium-chromedriver
```