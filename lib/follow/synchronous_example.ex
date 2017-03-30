# TODO: delete when no longer used
defmodule Follow.SynchronousExample do
  @moduledoc """
  Example of full flow
  """
  def run(username \\ "steveklbnf") do
    spotify_tracks = username
      |> get_twitter_friends
      |> get_spotify_artists
      |> get_spotify_tracks

      Follow.SpotifyPlaylistCreator.create_playlist(
        "Playlist for #{username}",
        Enum.map(spotify_tracks, &(&1.id))
      )
  end

  defp get_twitter_friends(username) do
    username
      |> Follow.FriendFetcher.friends
      |> Enum.filter(&(&1.verified)) # only get verified users
      |> Enum.take(40) # Articial limit for rate limiting
  end

  defp get_spotify_artists(twitter_friends) do
    spotify_artists = twitter_friends
      |> Enum.map(&(&1.name))
      |> Enum.map(fn(twitter_name) ->
        {:ok, spotify_object} = Follow.SpotifyArtistFetcher.artist(twitter_name)
        log_spotify_attempt(twitter_name, spotify_object)
        spotify_object
      end)
      |> Enum.reject(fn (spotify_artist) ->
        # more obscure results are often not real matches
        # may want to tweak number popularity number
        Kernel.is_nil(spotify_artist) || spotify_artist.popularity < 30
      end)
  end

  defp get_spotify_tracks(spotify_artists) do
    Enum.flat_map(spotify_artists, fn(spotify_artist) ->
      {:ok, tracks} = Follow.SpotifyTopTracksFetcher.top_tracks(
        spotify_artist.id, 1
      )
      tracks
    end)
  end

  defp log_spotify_attempt(name, nil) do
    IO.puts "Spotify #{name}: nothing found"
  end

  defp log_spotify_attempt(name, spotify_object) do
    IO.puts "Spotify #{name}: #{spotify_object.name}\t (#{spotify_object.id})\t #{spotify_object.popularity}"
  end
end
