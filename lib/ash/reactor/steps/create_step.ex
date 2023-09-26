defmodule Ash.Reactor.CreateStep do
  @moduledoc """
  The Reactor step which is used to execute create actions.
  """
  use Reactor.Step

  alias Ash.Changeset

  def run(arguments, context, options) do
    create_options =
      options
      |> Keyword.take(~w[upsert? upsert_identity authorize?]a)

    options[:resource]
    |> Changeset.for_create(options[:action], arguments[:input])
    |> maybe_set_tenant(arguments[:tenant])
    |> maybe_set_actor(arguments[:actor])
    |> options[:api].create(create_options)
  end

  defp maybe_set_tenant(changeset, nil), do: changeset
  defp maybe_set_tenant(changeset, tenant), do: Changeset.set_tenant(changeset, tenant)

  defp maybe_set_actor(changeset, nil), do: changeset
  defp maybe_set_actor(changeset, actor), do: Changeset.set_actor(changeset, actor)
end
