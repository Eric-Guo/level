defmodule LevelWeb.AcceptInvitationController do
  @moduledoc false

  use LevelWeb, :controller

  alias Level.Spaces
  alias LevelWeb.Auth
  alias LevelWeb.InvitationView

  plug :fetch_space

  def create(conn, %{"id" => id, "user" => user_params}) do
    invitation = Spaces.get_pending_invitation!(conn.assigns[:space], id)

    case Spaces.accept_invitation(invitation, user_params) do
      {:ok, %{user: user}} ->
        conn
        |> Auth.sign_in(invitation.space, user)
        |> redirect(to: cockpit_path(conn, :index))

      {:error, :user, changeset, _} ->
        conn
        |> assign(:changeset, changeset)
        |> assign(:invitation, invitation)
        |> render(InvitationView, "show.html", [])

      _ ->
        conn
        |> put_flash(:error, "Oops! Something went wrong. Please try again.")
        |> redirect(to: invitation_path(conn, :show, invitation))
    end
  end
end
