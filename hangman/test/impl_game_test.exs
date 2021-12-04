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

  test "duplicate letter recorded" do
    game = Game.new_game("")
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state != :already_used
    {game, _tally} = Game.make_move(game, "y")
    assert game.game_state != :already_used
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "record letters used" do
    game = Game.new_game("")
    {game, _tally} = Game.make_move(game, "x")
    {game, _tally} = Game.make_move(game, "y")
    {game, _tally} = Game.make_move(game, "x")
    assert MapSet.equal?(game.used, MapSet.new(["x", "y"])) == true
  end
  
  test "recognise good guesses" do
    game = Game.new_game("random")
    {game, tally} = Game.make_move(game, "r")
    assert tally.game_state == :good_guess
    {_game, tally} = Game.make_move(game, "a")
    assert tally.game_state == :good_guess
  end

  test "recognise bad guesses" do
    game = Game.new_game("random")
    {game, tally} = Game.make_move(game, "x")
    assert tally.game_state == :bad_guess
    {_game, tally} = Game.make_move(game, "y")
    assert tally.game_state == :bad_guess
  end

  test "run a sequence of moves which results in a win" do
    [
      # guess, game_state, turns_left, letters, used
      [ "a", :bad_guess,     6, ["_", "_", "_", "_", "_"],  ["a"] ],
      [ "x", :bad_guess,     5, ["_", "_", "_", "_", "_"],  ["a", "x"] ],
      [ "h", :good_guess,    5, ["h", "_", "_", "_", "_"],  ["a", "h", "x"] ],
      [ "a", :already_used,  5, ["h", "_", "_", "_", "_"],  ["a", "h", "x"] ],
      [ "e", :good_guess,    5, ["h", "e", "_", "_", "_"],  ["a", "e", "h", "x"] ],
      [ "l", :good_guess,    5, ["h", "e", "l", "l", "_"],  ["a", "e", "h", "l", "x"] ],
      [ "z", :bad_guess,     4, ["h", "e", "l", "l", "_"],  ["a", "e", "h", "l", "x", "z"] ],
      [ "o", :won,           4, ["h", "e", "l", "l", "o"],  ["a", "e", "h", "l", "o", "x", "z"] ],
    ]
    |> test_seq_of_moves()
  end

  test "run a sequence of moves which results in a lost" do
    [
      # guess, game_state, turns_left, letters, used
      [ "a", :bad_guess,    6, ["_", "_", "_", "_", "_"],  ["a"] ],
      [ "x", :bad_guess,    5, ["_", "_", "_", "_", "_"],  ["a", "x"] ],
      [ "h", :good_guess,   5, ["h", "_", "_", "_", "_"],  ["a", "h", "x"] ],
      [ "a", :already_used, 5, ["h", "_", "_", "_", "_"],  ["a", "h", "x"] ],
      [ "c", :bad_guess,    4, ["h", "_", "_", "_", "_"],  ["a", "c", "h", "x"] ],
      [ "d", :bad_guess,    3, ["h", "_", "_", "_", "_"],  ["a", "c", "d", "h", "x"] ],
      [ "z", :bad_guess,    2, ["h", "_", "_", "_", "_"],  ["a", "c", "d", "h", "x", "z"] ],
      [ "f", :bad_guess,    1, ["h", "_", "_", "_", "_"],  ["a", "c", "d", "f", "h", "x", "z"] ],
      [ "g", :lost,         0, ["h", "_", "_", "_", "_"],  ["a", "c", "d", "f", "g", "h", "x", "z"] ],
    ]
    |> test_seq_of_moves()
  end

  defp test_seq_of_moves(sequence) do
    game = Game.new_game("hello")
    Enum.reduce(sequence, game, &check_moves/2)
  end

  defp check_moves([ guess, expected_state, expected_turns, expected_letters, expected_used ], game) do
    { game, tally } = Game.make_move(game, guess)
    assert tally.game_state == expected_state
    assert tally.turns_left == expected_turns
    assert tally.letters == expected_letters
    assert tally.used == expected_used
    game
  end

end


