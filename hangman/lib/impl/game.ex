defmodule Hangman.Impl.Game do 

  alias Hangman.Type

  @type t :: %__MODULE__{
    turns_left: integer,
    game_state: Type.state,
    letters: list(String.t),
    used: MapSet.t(String.t),
  }
  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new(),
  ) 

  @spec new_game() :: t 
  def new_game do 
    new_game(Dictionary.random_word())
  end

  @spec new_game(String.t) :: t
  def new_game(word) do
    %__MODULE__{
      letters: word |> String.codepoints
    }
  end

  @spec make_move(t, String.t) :: { t, Type.tally } 
  def make_move(game = %{ game_state: state }, _guess) 
  when state in [:won, :lost] do
    game
    |> return_with_tally
  end

  def make_move(game = %{ game_state: _state }, guess) do
    accept_guess(game, guess, MapSet.member?(game.used, guess))
    |> return_with_tally
  end

  defp tally(game) do
    %{
      turns_left: game.turns_left, 
      game_state: game.game_state,
      letters: [],
      used: game.used |> MapSet.to_list |> Enum.sort, 
    }
  end

  @spec return_with_tally(t) :: { t, Type.tally }
  defp return_with_tally(game) do
    { game, tally(game) } 
  end

  defp accept_guess(game, _guess, _already_used = true) do
    %{ game | game_state: :already_used }
  end

  defp accept_guess(game, guess, _already_used) do
    %{ game | used: MapSet.put(game.used, guess) }
  end

end
