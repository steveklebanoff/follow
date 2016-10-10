defmodule Follow.SpotifyPlaylistCreator do
  @moduledoc """
    Creates a spotify playlist and adds tracks to it
  """
  def create_playlist(name, track_ids) do
    spotify_credentials = %Spotify.Credentials{
      access_token: Application.get_env(:follow, :spotify_access_token)
    }
    spotify_username = Application.get_env(:follow, :spotify_username)
    {:ok, playlist} = Spotify.Playlist.create_playlist(
      spotify_credentials,
      spotify_username,
      Poison.encode!(%{name: name})
    )

    # TODO: better way to add tracks, this will blow
    # up on large requests (using query params)
    # See https://github.com/jsncmgs1/spotify_ex/issues/14
    track_uris = Enum.map(
      track_ids, fn(t) -> "spotify:track:#{t}" end
    )

    Spotify.Playlist.add_tracks(
      spotify_credentials,
      spotify_username,
      playlist.id,
      uris: Enum.join(track_uris, ",")
    )

    playlist
  end
end
