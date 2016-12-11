# follow.fm
Discover playlists from top influencers

## Config
- Copy config/twitter.exs.example to twitter.exs and fill in keys.
- Copy config/spotify.exs.example to spotify.exs and fill in keys

**NOTE**: This asserts all environments are using the same twitter and
spotfy API keys, should likely change this in the future.


## Phoenix
To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Tests

Use `mix test` to run all tests.  If making any API calls, use `exvcr` to record a cassette.
