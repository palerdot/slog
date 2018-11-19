defmodule Slog.MixProject do
  use Mix.Project

  def project do
    [
      app: :slog,
      version: "0.1.1",
      description: "Print multiple values as string (except functions and binaries) for debugging.",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # ExDoc steps
      # Docs
      name: "Slog",
      source_url: "https://github.com/palerdot/slog",
      homepage_url: "https://github.com/palerdot/slog",
      docs: [main: "readme", # The main page in the docs
          extras: ["README.md"]],

      # mix package stuffs
      package: [
        maintainers: ["Arun Kumar <palerdot@gmail.com>"],
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/palerdot/slog"}
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end
end
