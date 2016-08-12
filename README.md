# hanafuda
Play Koi-Koi with multiple people!

It actually works! Multipliers don't work yet, but apart from that you can play it and everything.

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
* **card-coordinates.lua**: Contains code for deciding coordinates of cards (e.g. for playArea)
* **card-draw.lua**: Contains code for drawing cards used in all gamestates.
* **conf.lua**: Sets up important stuff like window size. It is called by LOVE at the beginning.
* **game-setup.lua**: Contains functions for receiving game data from server and initiating the game on the client.
* **game-updates**: Contains code for receiving game updates from server in any of the four game modes.
* **game-deck-play.lua**: Contains the gamestate for the flip part of the game, when it is your go.
* **game-deck-wait.lua**: Contains the gamestate for the flip part of the game, when it is not your go.
* **game-hand-play.lua**: Contains the gamestate for the hand part of the game, when it is your go.
* **game-hand-wait.lua**: Contains the gamestate for the hand part of the game, when it is not your go.
* **gameover.lua**: Contains the gamestate for when the game has finished, either when someone stops continuing or cards run out.
* **main.lua**: The main client file. The callbacks set here are called by LOVE when things happen. Mostly calls functions of whatever gamestate is currently happening and moves to the next gamestate.
* **main-old.lua**: The old main client file, not used anymore. Included mostly for entertainment, I guess?
* **menu.lua**: Contains a gamestate that controls logging in at the beginning of the game.
* **they-score.lua**: Contains a gamestate for when the other player scores.
* **tween.lua**: Used for moving cards around smoothly.
* **waiting.lua**: Contains a gamestate for waiting for another player to arrive.
* **you-score.lua**: Contains a gamestate for when you score and decide whether to continue.

#### Server
* **cards-score.lua**: It takes a set of cards collected and scores them according to the rules of Koi-Koi.
* **game-end-updates.lua**: Controls the game near the end, with sending and receiving Koi-Koi updates and sending the score when the game ends.
* **game-updates.lua**: Controls normal play updates in all modes and sends out messages.
* **server.lua**: It controls the server and gets it to send and receive messages.
* **set-up-game.lua**: Contains code for setting up a new game and sending it out.

#### Both
* **cards-define.lua**: Defines all cards, their values, months and images.
* **useful.lua**: It has some useful functions for doing stuff like shuffling a deck, copying a table or checking for equality on tables.

#### Tests
* **cards-tests.lua**: Some tests for whether the card scoring actually works.
