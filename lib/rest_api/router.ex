defmodule RestApi.Router do
  alias RestApi.UseCases.UserQueryUseCase

  # Bring Plug.Router module into scope
  use Plug.Router

  # Attach the Logger to log incoming requests
  plug(Plug.Logger)

  # Tell Plug to match the incoming request with the defined endpoints
  plug(:match)

  # Once there is a match, parse the response body if the content-type
  # is application/json. The order is important here, as we only want to
  # parse the body if there is a matching route.(Using the Jayson parser)
  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  # Dispatch the connection to the matched handler
  plug(:dispatch)

  @identification "identification"
  @firtsName "firtsName"
  @lastName "lastName"
  @age "age"
  @nickName "nickName"

  # Handler for GET request with "/" path
  get "/" do
    conn = fetch_query_params(conn)
    %{@identification => identification} = conn.params
    {value, _} = Integer.parse(identification)
    user = UserQueryUseCase.query_user(value)
    send_resp(
      conn,
      case user do
        nil -> 204
        _ -> 200
      end,
      case user do
        nil -> ""
        _ -> Poison.encode!(user)
      end
    )
  end

  post "/" do
    conn = fetch_query_params(conn)
    user = conn.params
    UserQueryUseCase.add_user(user)

    send_resp(
      conn,
      200,
      Poison.encode!("Ok")
    )
  end

  delete "/" do
    conn = fetch_query_params(conn)
    %{@identification => identification} = conn.params
    {value, _} = Integer.parse(identification)
    UserQueryUseCase.delete_user(value)

    send_resp(
      conn,
      200,
      Poison.encode!("Ok")
    )
  end

  get "/knockknock" do
    case Mongo.command(:mongo, ping: 1) do
      {:ok, _res} -> send_resp(conn, 200, "Who's there?")
      {:error, _err} -> send_resp(conn, 500, "Something went wrong")
    end
  end

  # Fallback handler when there was no match
  match _ do
    send_resp(conn, 404, "Not Found")
  end

end
