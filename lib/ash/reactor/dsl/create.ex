defmodule Ash.Reactor.Dsl.Create do
  @moduledoc """
  The `create` entity for the `Ash.Reactor` reactor extension.
  """

  defstruct __identifier__: nil,
            action: nil,
            actor: [],
            api: nil,
            async?: true,
            description: nil,
            inputs: [],
            name: nil,
            resource: nil,
            tenant: [],
            transform: nil,
            type: :create,
            wait_for: [],
            upsert_identity: nil,
            upsert?: false

  @type t :: %__MODULE__{
          __identifier__: any,
          action: atom,
          actor: [Ash.Reactor.Dsl.Actor.t()],
          api: Ash.Api.t(),
          async?: boolean,
          name: atom,
          inputs: [Ash.Reactor.Dsl.Inputs.t()],
          resource: module,
          tenant: [Ash.Reactor.Dsl.Tenant.t()],
          type: :create,
          wait_for: [Reactor.Dsl.WaitFor.t()],
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
          inputs %{
            title: input(:post_title),
            author_id: result(:get_user, [:id])
          }
          actor result(:get_user)
          tenant result(:get_organisation)
        end
        """
      ],
      no_depend_modules: [:api, :resource],
      target: __MODULE__,
      args: [:name, :resource, {:optional, :action}],
      identifier: :name,
      imports: [Reactor.Dsl.Argument],
      entities: [
        actor: [Ash.Reactor.Dsl.Actor.__entity__()],
        inputs: [Ash.Reactor.Dsl.Inputs.__entity__()],
        tenant: [Ash.Reactor.Dsl.Tenant.__entity__()],
        wait_for: [Reactor.Dsl.WaitFor.__entity__()]
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
          type: {:spark, Ash.Resource},
          required: true,
          doc: """
          The resource to call the action on.
          """
        ],
        action: [
          type: :atom,
          required: false,
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
          type: {:spark, Ash.Api},
          required: false,
          doc:
            "The API to use when calling the action.  Defaults to the API set in the `ash` section."
        ],
        async?: [
          type: :boolean,
          required: false,
          default: true
        ]
      ]
    }
end
