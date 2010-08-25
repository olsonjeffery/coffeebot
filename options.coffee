Options = {
  server: 'irc.freenode.net'		# server to connect to
  nick: 'coffeebot__'			# bot's nickname
  channels: ['#botwar']			# channel(s) to join
  nodeLocation: '/path/to/src/node'
					# path to node.js repo
  csLocation: '/path/to/src/coffee-script'
					# abs path to coffee-script git repo
  coffeeBin: '/path/to/bin/coffee'	# abs path to 'coffee' bin
  gistBin: '/path/to/bin/gist'		# abs path to 'gist' bin
}

module.exports = Options
