defmodule Ash.Reactor do
  @moduledoc """
  `Ash.Reactor` is a [`Reactor`](https://hex.pm/packages/reactor) extension
  which provides steps for working with Ash resources and actions.
  """

  @ash_reactor %Spark.Dsl.Section{
    name: :ash_reactor,
    describe: "Additional configuration for the `Ash.Reactor` extension",
    schema: [
      api: [
        type: {:behaviour, Ash.Api},
        doc: "An API to use by default when calling actions",
        required: false
      ]
    ]
  }

  use Spark.Dsl.Extension,
    sections: [@ash_reactor],
    transformers: [__MODULE__.Dsl.Transformer],
    dsl_patches:
      ~w[Create]
      |> Enum.map(&Module.concat(__MODULE__.Dsl, &1))
      |> Enum.map(&%Spark.Dsl.Patch.AddEntity{section_path: [:reactor], entity: &1.__entity__()})
end
