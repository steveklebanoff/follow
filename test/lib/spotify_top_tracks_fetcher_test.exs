defmodule Follow.SpotifyTopTracksFetcherTest do
  use Follow.VCRCase
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    ExVCR.Config.filter_request_headers("Authorization")
    :ok
  end

  test "finds correctly with default limit 3" do
    use_cassette "spotify_top_tracks_fetcher", match_requests_on: [:query] do
      {:ok, tracks} = Follow.SpotifyTopTracksFetcher.top_tracks(
        "4TMHGUX5WI7OOm53PqSDAT"
      )
      assert 3 == Enum.count(tracks)

      assert [
        ["Casey Jones (Remastered Album Version)", "15mlPrdH10GLQJafz07Q8X"],
        ["Friend Of The Devil - Remastered Version", "1kMmDBfMsOrtIkKKzRIBA3"],
        ["Touch Of Grey", "5YzzWlWfAVNvtduNDHKhHc"]
      ] == Enum.map(tracks, fn(t) -> [t.name, t.id] end)
    end
  end

  test "finds correctly with limit of 5" do
    use_cassette "spotify_top_tracks_fetcher", match_requests_on: [:query] do
      {:ok, tracks} = Follow.SpotifyTopTracksFetcher.top_tracks(
        "4TMHGUX5WI7OOm53PqSDAT", 5
      )
      assert 5 == Enum.count(tracks)

      assert [
        ["Casey Jones (Remastered Album Version)", "15mlPrdH10GLQJafz07Q8X"],
        ["Friend Of The Devil - Remastered Version", "1kMmDBfMsOrtIkKKzRIBA3"],
        ["Touch Of Grey", "5YzzWlWfAVNvtduNDHKhHc"],
        ["Truckin' (Remastered Album Version)", "7cer0SfbnGwmwJGu6lF2BB"],
        ["Sugar Magnolia (Remastered Album Version)", "2GLxvCiSUGu94wJFbojwWg"],
      ] == Enum.map(tracks, fn(t) -> [t.name, t.id] end)
    end
  end
end
