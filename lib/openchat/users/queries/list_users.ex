defmodule Openchat.Users.Queries.ListUsers do

  alias Openchat.Repositories.AgentUserRepository, as: UserRepository

  def run() do
    UserRepository.get_all()
  end
end
