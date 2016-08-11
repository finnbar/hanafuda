Here is a list of tasks that will make the game actually work or make it better.

Coding stuff to do (in rough order of importance in each list)

Make server work
 - [x] Write code for updating game based on message
    - [x] When in hand mode
    - [x] When in deck mode
 - [x] Write code for sending response messages
 - [x] Write code for dealing a card
 - [ ] Add scoring into receiving a card

Make client work
 - [ ] Different states for the client (split into files):
    - [x] Matching from hand, playing (hp)
    - [x] Matching from hand, not playing (hn)
    - [x] Matching from draw, playing (dp)
    - [x] Matching from draw, not playing? (dn)
    - [ ] You score, continue? (sp)
    - [ ] They score, continue? (sn)
    - [ ] Game finished! (gf)
    - [x] Menu (m)
  - [x] Write code for updating game when moves received from the server
  - [x] Move the cards after they have arrived
  - [x] Implement some method for dropping a card and sending that move
  - [x] Write code for receiving dealt card
  - [ ] Write code for displaying scored cards
  - [ ] Sort out ending game code

Other stuff
 - [x] Get it to shuffle cards *differently* each time
 - [x] Separate client code and server code into folders
 - [ ] Rewrite tweens to get them to land more accurately
 - [ ] Make the empty card a bit less horrible and ideally transparent in centre
 - [ ] Allow people to be randomly matched with opponents
 - [ ] Allow playing multiple games as part of a longer match
 - [ ] Split server into different files because it is getting long
 - [x] Fix issue with one player connected and another not connected (waiting stage?)
 - [ ] Change tween implementation to use dictionary-tables instead of list-tables

Weird bugs
 - [x] Sometimes moves don't seem to be verified, and I'm not yet sure why.
       Examples: `]
 - [x] Deck selection doesn't work.
 - [x] Doesn't seem to like second moves (client) and third moves (server)
