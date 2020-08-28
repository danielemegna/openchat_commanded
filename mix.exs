defmodule Openchat.MixProject do
  use Mix.Project

  def project do
    [
      app: :openchat,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Openchat.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.3"},
      {:jason, "~> 1.2"},
      {:commanded, "~> 1.2"}
    ]
  end
end
