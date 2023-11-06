defmodule Ash.Reactor.Dsl.Tenant do
  @moduledoc """
  Specify the actor used to execute an action.
  """

  defstruct __identifier__: nil, source: nil, transform: nil

  alias Reactor.Template

  @type t :: %__MODULE__{
          __identifier__: any,
          source: Template.Input.t() | Template.Result.t() | Template.Value.t(),
          transform: nil | (any -> any) | {module, keyword} | mfa
        }

  @doc false
  def __entity__,
    do: %Spark.Dsl.Entity{
      name: :tenant,
      describe: "Specifies the action tenant",
      args: [:source],
      imports: [Reactor.Dsl.Argument],
      identifier: {:auto, :unique_integer},
      schema: [
        source: [
          type:
            {:or,
             [{:struct, Template.Input}, {:struct, Template.Result}, {:struct, Template.Value}]},
          required: true,
          doc: """
          What to use as the source of the tenant.

          See `Reactor.Dsl.Argument` for more information.
          """
        ],
        transform: [
          type: {:or, [{:spark_function_behaviour, Step, {Step.Transform, 1}}, nil]},
          required: false,
          default: nil,
          doc: """
          An optional transformation function which can be used to modify the
          tenant before it is passed to the action.
          """
        ]
      ]
    }
end
