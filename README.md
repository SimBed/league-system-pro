$ rails _8.0_2 new league-system-pro -d=postgresql -c=bootstrap
$ cd league-system-pro
$ touch .yarnrc.yml
(add nodeLinker: node-modules to .yarnrc.yml)
(Delete the pnp files)
$yarn install (node_modules appears)
$ bundle
$ rails g scaffold league name:index season:index
$ rails db:migrate
$ bin/dev