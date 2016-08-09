# hanafuda
Play Koi-Koi with multiple people!

It doesn't work yet, sadly, but hopefully it will soon.

## Running the program

### The Server

To run the server, you will need lua installed, including a package called socket. Move into the server folder. Type into the command line: lua server.lua
It should then all magically work.

### The Client

You will need LOVE installed to run the client.
When you are in the client directory, type into the command line: love . and it should all magically work. In particular, you should get a window appear and ask you for your username.

## The Code

This is mostly for my own benefit, but I'll briefly list the files used.

#### Client
* **conf.lua**: Sets up important stuff like window size. It is called by LOVE at the beginning.
* **game-setup.lua**: Contains functions for receiving game data from server and initiating the game on the client.
* **game.lua**: Contains useful functions for all gamestates.
* **main.lua**: The main client file. The callbacks set here are called by LOVE when things happen. Mostly calls functions of whatever gamestate is currently happening.
* **main-old.lua**: The old main client file, not used anymore. Included mostly for entertainment, I guess?
* **menu.lua**: Contains a gamestate that controls logging in at the beginning of the game.
* **tween.lua**: Used for moving cards around smoothly.

#### Server
* **server.lua**: It controls the server and gets it to send and receive messages.

#### Both
* **cards-define.lua**: Defines all cards, their values, months and images.
* **cards-score.lua**: Currently not used. It takes a set of cards collected and scores them according to the rules of Koi-Koi.
* **cards-tests.lua**: Some tests for whether the card scoring actually works.
* **useful.lua**: It has some useful functions for doing stuff like shuffling a deck, copying a table or checking for equality on tables.
