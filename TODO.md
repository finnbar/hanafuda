Here is a list of tasks that will make the game actually work or make it better.

Coding stuff to do (in rough order of importance in each list)

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
 - [ ] Implement multipliers.
 - [ ] Allow people to be randomly matched with opponents
 - [ ] Allow playing multiple games as part of a longer match
 - [ ] Split server into different files because it is long
 - [x] Remove arrows from cards when in deck flip mode
 - [ ] Change the overlay for scoring to black on white or white on black
 - [ ] Move the hand cards along when one is played
 - [ ] Say whose go it is.
 - [ ] Get a font that draws question marks, full stops and zeros.
 - [x] Fix issue with one player connected and another not connected (waiting stage?)
 - [ ] Add combinations to the scoring message
 - [x] Change tween implementation to use dictionary-tables instead of list-tables

Weird bugs
 - [x] Sometimes moves don't seem to be verified, and I'm not yet sure why.
       Examples: `]
 - [x] Deck selection doesn't work.
 - [x] Doesn't seem to like second moves (client) and third moves (server)
 - [x] The scoring thing seems to be annoyed at me for giving insert wrong number of arguments when scoring bigs?
