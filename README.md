Passphrase
==========

Passphrase is a very simple module that generates secure passphrases to use as passwords.

## To use

Add Passphrase to your ```mix.exs``` dependencies and applications

```
def application do
  [applications: [:logger, :passphrase]]
end

defp deps do
  [
   {:passphrase, git: "https://github.com/cmoore4/elixir-passphrase.git", tag: "0.0.2"}
  ]
end
```

Then you can call Passphrase.makephrase/1 from inside your application to get a string back with the requested number of words.  The default number of words is 6.

```
iex(1)> Passphrase.makephrase
"swelt coil arpa nepal zloty layup"
```

The words come from a list of words in ```static/wordlist.txt```.  The provided file has 1 word per line, but it will take an text corpus, trim and deduplicate the words (though the performance on a huge corpus will likely be quite bad).

