defmodule PassphraseTest do
  use ExUnit.Case, async: true

  test "default passphrase is 6 words long" do
    words = Passphrase.makephrase |> String.split |> Enum.count
    assert words == 6
  end

  test "passphrase of 10 words long" do
    words = Passphrase.makephrase(10) |> String.split |> Enum.count
    assert words == 10
  end

  test "randomized seeds are random" do
    assert Passphrase.make_seed != Passphrase.make_seed
  end

  test "wordlist has a sane length" do
    {:ok, wordlist} = Passphrase.load_words
    assert (wordlist |> Enum.count) > 100
  end

  test "wordlist does not contain duplicates" do
  	{:ok, wordlist} = Passphrase.load_words
    assert (wordlist |> Enum.uniq) == wordlist
  end

  test "minimum length overrides minimum words when it has to" do
  	phrase_length = Passphrase.makephrase(2, 100) |> String.length
    assert phrase_length >= 100
  end

  test "minimum length is properly the minimum, and allows phrases to go over" do
  	phrase_length = Passphrase.makephrase(6, 1) |> String.split |> Enum.count
  	assert phrase_length > 2
  end

end
