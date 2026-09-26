# Blue Panels Tap

Homebrew formulae for [M-Commander](https://github.com/blue-panels/mcommander),
a twin-panel terminal file manager with panel plugins, based on GNU Midnight
Commander.

## How do I install these formulae?

`brew install blue-panels/tap/mcommander`

Or `brew tap blue-panels/tap` and then `brew install mcommander`.

Or, in a `brew bundle` `Brewfile`:

```ruby
tap "blue-panels/tap"
brew "mcommander"
```

The formula installs `mcommander` and the links `mc6`, `mcedit6`, `mview`,
`mdiff`, `mctree` and `mcstruct`. It does not install `mc`, so it can be
installed beside the `midnight-commander` formula.

Bottles are built for Apple Silicon and for x86_64 Linux; on other systems the
formula builds from source.

The formula was called `mc6` before. `brew upgrade` replaces an installed `mc6`
with `mcommander` by itself.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
