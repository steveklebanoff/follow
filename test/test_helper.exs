ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Follow.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Follow.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Follow.Repo)

