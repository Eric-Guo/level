defmodule Level.Rooms.Room do
  @moduledoc """
  The Ecto schema for the rooms table.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :state, :string, read_after_writes: true # room_state
    field :name, :string
    field :description, :string, read_after_writes: true
    field :subscriber_policy, :string, read_after_writes: true # room_subscriber_policy

    belongs_to :space, Level.Spaces.Space
    belongs_to :creator, Level.Spaces.User
    has_many :room_subscriptions, Level.Rooms.RoomSubscription

    timestamps()
  end

  @doc """
  Builds a changeset for creating a room.
  """
  def create_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:space_id, :creator_id, :name, :description, :subscriber_policy])
    |> validate_required([:name])
    |> unique_constraint(:name, name: :rooms_unique_ci_name)
  end
end