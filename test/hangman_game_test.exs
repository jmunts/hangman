defmodule HangmanGameTest do
  use ExUnit.Case

  alias Hangman.Game

  test "new_game returns structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
    assert Enum.all? game.letters, &(Regex.match?(~r/[a-z]/, &1))
  end

  test "state isn't changed for :won and :lost game" do
    for state <- [:won, :lost] do
      game = Game.new_game() |> Map.put(:game_state, state)
      assert { ^game, _tally }  = Game.make_move(game, "x")
    end
  end

  test "first occurrence of letter is not already used" do
    game = Game.new_game()
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "second occurrence of letter is already used" do
    game = Game.new_game()
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state != :already_used
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "good guess" do
    game = Game.new_game("test")
    { game, _tally } = Game.make_move(game, "t")
    assert game.game_state == :good_guess
  end

  test ":won" do
    game = Game.new_game("test")
    { game, _tally } = Game.make_move(game, "t")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    { game, _tally } = Game.make_move(game, "e")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    { game, _tally } = Game.make_move(game, "s")
    assert game.game_state == :won
    assert game.turns_left == 7
  end

  test "bad_guess is recognized" do
    game = Game.new_game("test")
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test ":lost" do
    game = Game.new_game("x")

    # TODO: Refactor using Enum.reduce
    { game, _tally } = Game.make_move(game, "a")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
    { game, _tally } = Game.make_move(game, "b")
    assert game.game_state == :bad_guess
    assert game.turns_left == 5
    { game, _tally } = Game.make_move(game, "c")
    assert game.game_state == :bad_guess
    assert game.turns_left == 4
    { game, _tally } = Game.make_move(game, "d")
    assert game.game_state == :bad_guess
    assert game.turns_left == 3
    { game, _tally } = Game.make_move(game, "e")
    assert game.game_state == :bad_guess
    assert game.turns_left == 2
    { game, _tally} = Game.make_move(game, "f")
    assert game.game_state == :bad_guess
    assert game.turns_left == 1
    { game, _tally} = Game.make_move(game, "g")
    assert game.game_state == :lost
  end

end
