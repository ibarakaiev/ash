defmodule Ash.Reactor.Dsl.ActionArgument do
  @moduledoc """
  An argument to an action.
  """

  defstruct __identifier__: nil, name: nil, source: nil, transform: nil

  alias Reactor.Template

  @type t :: %__MODULE__{
          __identifier__: any,
          name: atom,
          source: Template.Input.t() | Template.Result.t() | Template.Value.t(),
          transform: nil | (any -> any) | {module, keyword} | mfa
        }

  @doc false
  def __entity__,
    do: %Spark.Dsl.Entity{
      name: :argument,
      describe: "Specifies an action argument.",
      args: [:name, {:optional, :source}],
      imports: [Reactor.Dsl.Argument],
      identifier: :name,
      schema: [
        name: [
          type: :atom,
          required: true,
          doc: "The name of the argument."
        ],
        source: [
          type:
            {:or,
             [{:struct, Template.Input}, {:struct, Template.Result}, {:struct, Template.Value}]},
          required: true,
          doc: """
          What to use as the source of the argument.

          See `Reactor.Dsl.Argument` for more information.
          """
        ],
        transform: [
          type: {:or, [{:spark_function_behaviour, Step, {Step.Transform, 1}}, nil]},
          required: false,
          default: nil,
          doc: """
          An optional transformation function which can be used to modify the
          argument before it is passed to the action.
          """
        ]
      ]
    }
end
