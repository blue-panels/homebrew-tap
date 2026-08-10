# Blue Panels Tap

Homebrew formulae for [mc6](https://github.com/ilia-maslakov/mcdev), a Midnight
Commander fork with panel plugins.

## How do I install these formulae?

`brew install blue-panels/tap/mc6`

Or `brew tap blue-panels/tap` and then `brew install mc6`.

Or, in a `brew bundle` `Brewfile`:

```ruby
tap "blue-panels/tap"
brew "mc6"
```

`mc6` installs a binary named `mc`, so it conflicts with the `midnight-commander`
and `minio-mc` formulae. Only one of them can be linked at a time.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
