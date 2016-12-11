# TODO: delete when no longer used
defmodule Follow.SynchronousExample do
  @moduledoc """
  Example of full flow
  """
  def run(username \\ "steveklbnf") do
    artist_spotify_ids = username
      |> Follow.FriendFetcher.friends
      |> Enum.take(40) # Articial limit for rate limiting
      |> Enum.filter(&(&1.verified)) # only get verified users
      |> Enum.map(&(&1.name))
      |> Enum.map(fn(username) ->
        IO.puts "Searching spotify for #{username}"

        {:ok, spotify_object} = Follow.SpotifyArtistFetcher.artist(username)
        # ehh pattern matching might nicer, but whatever
        if spotify_object == nil do
          IO.puts "no match"
          nil
        else
          IO.puts "got: #{spotify_object.name} | #{spotify_object.id}"
          spotify_object.id
        end
      end)
      |> Enum.reject(&(Kernel.is_nil &1))

      IO.inspect(artist_spotify_ids)
      spotify_track_ids = artist_spotify_ids
        |> Enum.flat_map(fn(spotify_id) ->
          # TODO: better way to do this?
          {:ok, tracks} = Follow.SpotifyTopTracksFetcher.top_tracks(spotify_id, 1)
          tracks
        end)
        |> Enum.map(&(&1.id))

      IO.inspect(spotify_track_ids)
      Follow.SpotifyPlaylistCreator.create_playlist(
        "Playlist for #{username}", spotify_track_ids
      )
  end
end
