defmodule Follow.SpotifyArtistFetcherTest do
  use Follow.VCRCase
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    ExVCR.Config.filter_request_headers("Authorization")
    :ok
  end

  test "finds simple match" do
    use_cassette "spotify_artist_fetcher/simple", match_requests_on: [:query] do
      {:ok, artist} = Follow.SpotifyArtistFetcher.artist("Grateful Dead")
      assert "spotify:artist:4TMHGUX5WI7OOm53PqSDAT" == artist.uri
      assert "Grateful Dead" == artist.name
    end
  end

  test "finds case insensitive match" do
    use_cassette "spotify_artist_fetcher/case_insensitive", match_requests_on: [:query] do
      {:ok, artist} = Follow.SpotifyArtistFetcher.artist("mNdSgN")
      assert "spotify:artist:4GcpBLY8g8NrmimWbssM26" == artist.uri
      assert "Mndsgn" == artist.name
    end
  end
end
