defmodule Ash.Reactor.Dsl.Create do
  @moduledoc """
  The `create` entity for the Ash.Reactor reactor extension.
  """

  defstruct __identifier__: nil,
            action: nil,
            api: nil,
            arguments: [],
            description: nil,
            name: nil,
            resource: nil,
            steps: [],
            type: :create,
            upsert_identity: nil,
            upsert?: false

  @type t :: %__MODULE__{
          __identifier__: any,
          action: atom,
          api: Ash.Api.t(),
          arguments: [
            Ash.Reactor.Dsl.ActionArgument.t()
            | Ash.Reactor.Dsl.ActionAttribute.t()
            | Ash.Reactor.Dsl.Actor.t()
            | Ash.Reactor.Dsl.Tenant.t()
            | Reactor.Dsl.WaitFor.t()
          ],
          name: atom,
          resource: module,
          steps: [struct],
          type: :create,
          upsert_identity: nil | atom,
          upsert?: boolean
        }

  @doc false
  def __entity__,
    do: %Spark.Dsl.Entity{
      name: :create,
      describe: "Declares a step that will call a create action on a resource.",
      examples: [
        """
        create :create_post, MyApp.Post, :create do
          attribute :title, input(:post_title)
          argument :author_id, result(:create_user, [:id])
        end
        """
      ],
      no_depend_modules: [:resource],
      target: __MODULE__,
      args: [:name, :resource, :action],
      identifier: :name,
      entities: [
        arguments: [
          Ash.Reactor.Dsl.ActionArgument.__entity__(),
          Ash.Reactor.Dsl.ActionAttribute.__entity__(),
          Ash.Reactor.Dsl.Actor.__entity__(),
          Ash.Reactor.Dsl.Tenant.__entity__(),
          Reactor.Dsl.WaitFor.__entity__()
        ]
      ],
      singleton_entity_keys: [:actor, :tenant],
      recursive_as: :steps,
      schema: [
        name: [
          type: :atom,
          required: true,
          doc: """
          A unique name for the step.

          This is used when choosing the return value of the Reactor and for
          arguments into other steps.
          """
        ],
        resource: [
          type: :module,
          required: true,
          doc: """
          The resource to call the action on.
          """
        ],
        action: [
          type: :atom,
          required: true,
          doc: """
          The name of the action to call on the resource.
          """
        ],
        upsert?: [
          type: :boolean,
          required: false,
          default: false,
          doc: "Whether or not this action should be executed as an upsert."
        ],
        upsert_identity: [
          type: :atom,
          required: false,
          doc: "The identity to use for the upsert"
        ],
        description: [
          type: :string,
          required: false,
          doc: "A description for the step"
        ],
        api: [
          type: {:behaviour, Ash.Api},
          required: false,
          doc:
            "The API to use when calling the action.  Defaults to the API set in the `ash_reactor` section."
        ]
      ]
    }
end
