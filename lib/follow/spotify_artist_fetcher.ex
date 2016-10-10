defmodule Follow.SpotifyArtistFetcher do
  @moduledoc """
    Finds the spotify artist for a given name
  """
  def artist(artist_name) do
    spotify_credentials = %Spotify.Credentials{
      access_token: Application.get_env(:follow, :spotify_access_token)
    }
    {:ok, result} = Spotify.Search.query(
      spotify_credentials, q: artist_name, type: "artist"
    )

    # try to find exact match, case insensitive
    {:ok, Enum.find(result.items, fn (a) ->
      String.downcase(a.name) == String.downcase(artist_name)
    end)}
  end
end
