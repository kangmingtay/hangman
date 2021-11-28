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

end


