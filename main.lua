-- requires all files, including actual main.lua

requires = {"both/cards-define","both/useful", "client/card-coordinates", "client/card-draw", "client/card-tween-updates", "client/game-setup", "client/game-updates", "client/game-deck-play", "client/game-deck-wait", "client/game-hand-play", "client/game-hand-wait", "client/gameOver", "client/menu", "client/something-wrong", "client/they-score", "client/they-quit", "client/tween", "client/waiting", "client/you-score", "client/main"}
for i,j in pairs(requires) do
  require(j)
end
