defmodule HangmanImplGameTest do
  use ExUnit.Case
  doctest Hangman

  alias Hangman.Impl.Game
  test "new game" do
    word = "random"
    game = Game.new_game(word)

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
    assert game.letters == word |> String.codepoints()
    assert game.letters == word |> String.downcase(:ascii) |> String.codepoints()
    assert Enum.join(game.letters) |> String.match?(~r/^[[:lower:]]+$/)

  end

  test "state doesn't change if a game is won" do

    game = Game.new_game("random")
    game = Map.put(game, :game_state, :won)
    { new_game, _tally } = Game.make_move(game, "x")
    assert new_game == game
    
  end

  test "state doesn't change if a game is won or lost" do
    for state <- [:won, :lost] do
      game = Game.new_game("random")
      game = Map.put(game, :game_state, state)
      { new_game, _tally } = Game.make_move(game, "x")
      assert new_game == game
    end
  end

end


