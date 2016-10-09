defmodule Follow.SpotifyTopTracksFetcher do
  @moduledoc """
    Finds the top tracks for a given artist spotify URI
  """
  # Limit can be max of 10
  def top_tracks(spotify_artist_id, limit \\ 3) do
    spotify_connection = %{cookies: %{
      "spotify_access_token" => Application.get_env(:follow, :spotify_access_token)
    }}

    {:ok, tracks} =
      Spotify.Artist.get_top_tracks(spotify_connection, spotify_artist_id, country: "US")

    {:ok, Enum.take(tracks, limit)}
  end
end
