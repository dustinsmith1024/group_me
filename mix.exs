defmodule GroupMe.Mixfile do
  use Mix.Project

  def project do
    [app: :group_me,
     version: "0.1.1",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     description: description(),
     package: package()
    ]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp description do
    """
    A library for interacting with the GroupMe API.
    """
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
      # This override is in place because of a bug in hackney SSL handshakes
      {:hackney, "1.6.1", override: true},
      {:httpoison, ">= 0.9.2"},
      {:plug, "~> 1.1"},
      {:poison, "~> 2.2.0"},
      {:socket, "~> 0.3"},
      {:uuid, "~> 1.1.0"}
    ]
  end

  defp package do
    [
      maintainers: ["Dustin Smith"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/dustinsmith1024/group_me"}
    ]
  end
end
