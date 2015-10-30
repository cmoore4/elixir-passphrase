Passphrase
==========

Passphrase is a very simple module that generates secure passphrases to use as passwords.

## To use

Add Passphrase to your ```mix.exs``` dependencies and applications

```elixir
def application do
  [applications: [:logger, :passphrase]]
end

defp deps do
  [
   {:passphrase, git: "https://github.com/cmoore4/elixir-passphrase.git", tag: "0.0.2"}
  ]
end
```

Then you can call Passphrase.makephrase/2 from inside your application to get a string back with the requested number of words.  The default number of words is 6, and there is no minimum character count.

```elixir
iex(1)> Passphrase.makephrase
"swelt coil arpa nepal zloty layup"

iex(1)> Passphrase.makephrase 10
"trait maria pius nimble stile typo mac gruff agree lang"

iex(2)> Passphrase.makephrase 3, 20
"vessel froze ember ising"
```

The words come from a list of words in ```static/wordlist.txt```.  The provided file has 1 word per line, but it will take an text corpus, trim and deduplicate the words (though the performance on a huge corpus will likely be quite bad).

