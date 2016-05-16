defmodule BaseX.Mixfile do
  use Mix.Project

  def project do
    [app: :basex,
     version: "0.2.1",
     elixir: "~> 1.2",
     name: "BaseX",
     source_url: "https://github.com/mwmiller/basex_ex",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: package,
     deps: deps]
  end

  def application do
    []
  end


  defp deps do
    [
      {:power_assert, "~> 0.0.8", only: :test},
      {:earmark, "~> 0.2", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev},
    ]
  end

  defp description do
    """
    BaseX - arbitrary alphabet encoding
    """
  end

  defp package do
    [
     files: ["lib", "mix.exs", "README*", "LICENSE*", ],
     maintainers: ["Matt Miller"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/mwmiller/basex_ex",
              "Ref"   => "https://saltpack.org/armoring",
             }
    ]
  end

end
