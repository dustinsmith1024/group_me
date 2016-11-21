defmodule GroupMe.Request do
    use HTTPoison.Base

    def process_response_body(body) do
        # Kill the 'meta' prop
        case Poison.decode(body) do
            {:ok, response} ->
                transform_response(response)
            {:error, reason} -> reason
        end
    end

    defp transform_response(response) do
        case response["response"] do
            r when is_list(r) ->
                Enum.map(r, fn(group) ->
                    Enum.map(group, fn({k, v}) -> {String.to_atom(k), v} end)
                end)
            r when is_map(r) ->
                IO.puts "its a map!"
                Enum.map(r, fn({k, v}) -> {String.to_atom(k), v} end)
            r -> r
        end
    end
    def pik_user_auth_token() do
        Application.get_env(:pik, :groupme)[:token]
    end

    def bot_id() do
        "8f334ddb3045ac6963614c3c02"
    end

    def access_token() do
        "sIvJQp3JTuBLaoAly2PRhQpq7EKsaq8iHwEP5xU1"
    end

end