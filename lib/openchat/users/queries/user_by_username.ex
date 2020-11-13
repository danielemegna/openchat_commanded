defmodule Openchat.Users.Queries.UserByUsername do

  alias Openchat.Repositories.AgentUserRepository, as: UserRepository

  def run(username) do
    UserRepository.get_by_username(username)
  end
end
