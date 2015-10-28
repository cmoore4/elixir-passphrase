defmodule Passphrase do
@moduledoc ~S"""
Generates a passphrase from a list of words in a file.  Each word
should be on a single line. The list generated from the file is stored
in an Agent.
"""

  @doc ~S"""
  The main method for generating a secure random passphrase from your worlist.
  The first paramter is how long the passphrase should be, in words.  Default is 6.
  Reads in a file to a list, stores in an Agent, then requests random words from
  the Agent's list.  Also initialized the PRNG with a seed.

  ## Examples (Will not pass tests, since new phrase is created every run)

      iex> Passphrase.makephrase()
      "big typewriter fox logan jump quail"

      iex> Passphrase.makephrase(3)
      "paper sudden seven"

  """
  def makephrase(number_words \\ 6) do
    make_seed |> :random.seed    
    {:ok, wordlist} = load_words
    Agent.start_link(fn -> wordlist end, name: __MODULE__)

    get_words(number_words, []) |> Enum.join " "
  end

  defp get_words(0, words), do: words
  defp get_words(number_words, words) do
    number_words = number_words - 1
    get_words number_words, [get_word|words]
  end


  @doc ~S"""
  Gets a random word from the Agent holding the list of words from the wordlist file.
  """
  def get_word do
    random = get_random
    Agent.get(__MODULE__, 
      fn wordlist -> 
        index = wordlist
         |> Enum.count
         |> mult(random)
         |> Float.ceil
         |> trunc #converts float to int
        Enum.fetch!(wordlist,  index) 
      end)
  end

  # REVIEW: How do you multiply in pipe operators?  This is my workaround
  defp mult(a, b), do: a * b

  @doc ~S"""
  Generates 3 random values to be used as seeds to the PRNG.  Uses Erlang's
  :crypto module, which uses its own PRNG
  """
  def make_seed do
    <<a::32, b::32, c::32>> = :crypto.rand_bytes(12)
    {a, b, c}
  end

  defp get_random, do: :random.uniform

  def load_words do
    {:ok, wordlist_raw} = File.open Application.get_env(:passphrase, :wordlist), [:read]
    wordlist = create_words_list([], wordlist_raw)
    {:ok, wordlist}
  end

  @doc ~S"""
  Recursive function to read in every line from a file, and put that line into a list.
  Returns the list(in original order, which is not necessary, but I like it) when file
  is EOF. 
  """
  def create_words_list(wordlist, wordlist_raw) do
    line = IO.read(wordlist_raw, :line)
    case line do
      :eof -> wordlist |> Enum.uniq |> Enum.reverse 
      contents -> 
        contents 
        |> String.split 
        |> Enum.map(&String.strip(&1))
        |> Enum.concat(wordlist) 
        |> create_words_list(wordlist_raw)
    end
  end

end
