defmodule BaseX.Mixfile do
  use Mix.Project

  def project do
    [
      app: :basex,
      version: "1.3.3",
      elixir: "~> 1.8",
      name: "BaseX",
      source_url: "https://github.com/mwmiller/basex_ex",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  def application do
    []
  end

  defp aliases do
    [
      test: "test --seed 0"
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.23", only: :dev}
    ]
  end

  defp description do
    """
    BaseX - arbitrary alphabet encoding
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Matt Miller"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/mwmiller/basex_ex",
        "Ref" => "https://saltpack.org/armoring"
      }
    ]
  end
end
