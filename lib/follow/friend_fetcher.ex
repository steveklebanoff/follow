defmodule Follow.FriendFetcher do
  @moduledoc """
    Finds 1000 twitter friends of user
  """
  @count 200
  @max_items 1000

  def friends(screen_name, acc \\ [], cursor \\ -1) do
    cursor = fetch_next(screen_name, cursor)
    if Enum.count(cursor.items) == 0 || Enum.count(acc) >= @max_items do
      acc
    else
      friends(screen_name, cursor.items ++ acc, cursor.next_cursor)
    end
  end

  defp fetch_next(screen_name, cursor) do
    ExTwitter.friends(screen_name, count: @count, cursor: cursor)
  end
end
