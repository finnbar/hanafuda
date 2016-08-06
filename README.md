# hanafuda
Play Koi-Koi with multiple people!

It doesn't work yet, sadly, but hopefully it will soon.

## Running the program

### The Server

To run the server, you will need lua installed, including a package called socket. Type into the command line: lua server.lua
It should then all magically work.

### The Client

You will also need LOVE installed to run the client.
When you are in the code directory, type into the command line: love . and it should all magically work. In particular, you should get a window appear and ask you for your username.

## The Code

This is mostly for my own benefit, but I'll briefly list the files used.

* cards-define.lua: Used by both the client and the server. Defines all cards, their values, months and images.
* cards-score.lua: Currently not used. It takes a set of cards collected and scores them according to the rules of Koi-Koi.
* cards-tests.lua: Some tests for whether the card scoring actually works.
* conf.lua: Used by the client. Sets up important stuff like window size. It is called by LOVE at the beginning.
* game.lua: Used by the client. Controls most of what they actually see.
* main-old.lua: The old main client file, not used anymore. Included mostly for entertainment, I guess?
* main.lua: The main client file. The callbacks set here are called by LOVE when things happen. Mostly calls functions from game.lua, which does most of the work.
* menu.lua: Used by the client. It controls logging in at the beginning of the game.
* server.lua: Used by the server. It controls the server and gets it to send and receive messages.
* tween.lua: Used by the client. Used for moving cards around smoothly.
* useful.lua: Used by both the server and the client. It has some useful functions for doing stuff like shuffling a deck, copying a table or checking for equality on tables.
