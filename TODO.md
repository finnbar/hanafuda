Here is a list of tasks that will make the game actually work or make it better.

## Coding stuff to do

Other stuff
 - [ ] Allow people to be randomly matched with opponents
 - [ ] Say whose go it is.
 - [ ] Add combinations to the scoring message
 - [ ] Add more tests
 - [ ] Remove the local variable from the scoring
 - [ ] Refactor some code so it is shorter
    - [ ] Check if all local variables are actually local
    - [ ] The client update game functions seem to contain lots of repetition
    - [x] Repeating a lot in update card tweens
 - [ ] Deal with a player quitting without leaving the other player confused
 - [ ] Delete games and matches from the server once they are over
 - [ ] Allow a user to have an account which they can log into
 - [ ] Store a user's statistics
 - [ ] Allow users to view statistics and keep a log
 - [ ] Add special month rules for 12 game matches
 - [ ] Use a sensible structure for messages instead of symbols as we are running out of symbols
 - [ ] Use only alphabetic characters as card symbols
 - [ ] Either allow non alphabetic characters in username or stop it crashing the server
 - [ ] Prevent against the server being crashed by bad messages generally
 - [ ] Add debug output to the server
 - [x] Add something to check message is received.
 - [ ] Add choice of whether it is connecting to proper server or local to client

Allow multiple games as part of a longer matched
 - [ ] Allow match type to be chosen at the beginning by player 1
 - [ ] Move all game initialisation stuff in the client into one function
 - [ ] Add a new gamestate for end of this match
 - [ ] Add match information to the gameover gamestate
 - [ ] Allow both users to choose whether to continue the match
 - [ ] Store matches rather than games in the server
 - [ ] Update match and reset game on server

Weird bugs

##DONE!

Make server work
  - [x] Write code for updating game based on message
     - [x] When in hand mode
     - [x] When in deck mode
  - [x] Write code for sending response messages
  - [x] Write code for dealing a card
  - [x] Add scoring into receiving a card
  - [x] Sort out ending game code
     - [x] Check if player has scored extra
     - [x] Check if next player has run out of cards
     - [x] Send out Koi-Koi messages
     - [x] Receive Koi-Koi response
     - [x] Send out game over messages
     - [x] If continue is chosen but no cards left, send game over draw message

Make client work
  - [x] Different states for the client (split into files):
     - [x] Matching from hand, playing (hp)
     - [x] Matching from hand, not playing (hn)
     - [x] Matching from draw, playing (dp)
     - [x] Matching from draw, not playing? (dn)
     - [x] You score, continue? (sp)
     - [x] They score, continue? (sn)
     - [x] Game finished! (gf)
     - [x] Menu (m)
   - [x] Write code for updating game when moves received from the server
   - [x] Move the cards after they have arrived
   - [x] Implement some method for dropping a card and sending that move
   - [x] Write code for receiving dealt card
   - [x] Write code for displaying scored cards
   - [x] Sort out ending game code
      - [x] Add simple gamestate for scoring and opponent scoring
      - [x] Add simple gamestate for wins, loses and draws
      - [x] Separate game-updates so can be called without full data
      - [x] Return to previous state and process deck flip if required
      - [x] Process draw / end game requests when playing game

Other stuff
  - [x] Get it to shuffle cards *differently* each time
  - [x] Separate client code and server code into folders
  - [x] Rewrite tweens to get them to land more accurately
  - [x] Make the empty card a bit less horrible and ideally transparent in centre
  - [x] Set selected card to nil when game update is received
  - [x] Move all cards in hand along or move arrows to above cards or both
  - [x] Implement multipliers.
  - [x] Split server into different files because it is long
  - [x] Remove arrows from cards when in deck flip mode
  - [x] Change the overlay for scoring to black on white or white on black
  - [x] Move the hand cards along when one is played
  - [x] Get a font that draws question marks, full stops and zeros.
  - [x] Fix issue with one player connected and another not connected (waiting stage?)
  - [x] Change tween implementation to use dictionary-tables instead of list-tables
  - [x] Make moving thing glide on top of the deck instead of under it
  - [x] Make sliding occur before win message appears

Weird bugs
  - [x] Sometimes moves don't seem to be verified, and I'm not yet sure why.
        Examples: `]
  - [x] Deck selection doesn't work.
  - [x] Doesn't seem to like second moves (client) and third moves (server)
  - [x] The scoring thing seems to be annoyed at me for giving insert wrong number of arguments when scoring bigs?
