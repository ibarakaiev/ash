defmodule Ash.Test.ReactorCreateTest do
  @moduledoc false
  use ExUnit.Case, async: true

  defmodule Post do
    @moduledoc false
    use Ash.Resource, data_layer: Ash.DataLayer.Ets

    ets do
      private? true
    end

    attributes do
      uuid_primary_key :id
      attribute :title, :string, allow_nil?: false
      attribute :sub_title, :string
    end

    actions do
      defaults [:create, :read, :update, :destroy]
    end
  end

  defmodule Api do
    @moduledoc false
    use Ash.Api

    resources do
      resource Post
    end
  end

  defmodule CreatePostReactor do
    @moduledoc false
    use Reactor, extensions: [Ash.Reactor]

    ash_reactor do
      api Api
    end

    input :title
    input :sub_title

    create :create_post, Post, :create do
      attribute :title, input(:title)
      attribute :sub_title, input(:title)
    end

    # step :create_post do
    #   run fn _ -> {:ok, "Hello World"} end
    # end

    return(:create_post)
  end

  test "it can create a post" do
    assert {:ok, :wat} = Reactor.run(CreatePostReactor, %{title: "Title", sub_title: "Sub-title"})
  end
end
