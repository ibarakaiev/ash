defimpl Reactor.Argument.Build, for: Ash.Reactor.Dsl.Tenant do
  def build(tenant),
    do: %Reactor.Argument{name: :tenant, source: tenant.source, transform: tenant.transform}
end
