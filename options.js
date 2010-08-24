var Options = {
  server: 'irc.freenode.net',		// server to connect to
  nick: 'coffeebot__',			// bot's nickname
  channels: ['#%botwar'],			// channel(s) to join
  nodeLocation: '/path/to/git/src/node',
					// path to node.js repo
  csLocation: '/path/to/git/coffee-script',	
					// abs path to coffee-script git repo
  coffeeBin: '/path/to/bin/coffee'	// abs path to 'coffee' bin
};

module.exports = Options
