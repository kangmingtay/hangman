defmodule HangmanImplGameTest do
  use ExUnit.Case
  doctest Hangman

  alias Hangman.Impl.Game
  test "new game" do
    game = Game.new_game("random")

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
    assert game.letters == ["r", "a", "n", "d", "o", "m"]

  end

end


