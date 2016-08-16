defmodule Follow.FriendFetcherTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Httpc

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    ExVCR.Config.filter_sensitive_data("oauth_nonce=.+&", "oauth_nonce=*&")
    ExVCR.Config.filter_sensitive_data("oauth_signature=.+?&", "oauth_signature=*&")
    :ok
  end

  test "fetch limited friends" do
    use_cassette "friend_fetcher/limited", match_requests_on: [:query] do
      steves_friends = Follow.FriendFetcher.friends("steveklbnf")
      assert 396 == Enum.count(steves_friends)

      screen_names = Enum.map(steves_friends, fn(f) -> f.screen_name end)
      assert Enum.member?(screen_names, "ximoes")
      assert Enum.member?(screen_names, "thisisMAILAN")
    end
  end
end
