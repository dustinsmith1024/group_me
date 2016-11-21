defmodule GroupMe.Request do
    use HTTPoison.Base

    defp process_response_body(" "), do: " "
    defp process_response_body(body) do
        # TODO: Check the meta prop and parse it
        # If its an error then send that back instead.
        IO.inspect body
        case Poison.decode(body) do
            {:ok, response} ->
                transform_response(response)
            {:error, reason} -> reason
        end
    end

    defp process_request_body(body) when is_map(body) do
        Poison.encode!(body)
    end

    defp process_request_body(body) do
        body
    end

    defp transform_response(response) do
        case response["response"] do
            r when is_list(r) ->
                Enum.map(r, fn(group) ->
                    Enum.map(group, fn({k, v}) -> {String.to_atom(k), v} end)
                end)
            r when is_map(r) ->
                IO.puts "its a map!"
                transform(r)
            r -> r
        end
    end

    defp transform(map) do
        Enum.map(map, fn({k, v}) ->
            if is_map(v) do
                {String.to_atom(k), transform(v)}
            else
                {String.to_atom(k), v}
            end
        end)
    end
    def pik_user_auth_token() do
        Application.get_env(:pik, :groupme)[:token]
    end

    def bot_id() do
        "8f334ddb3045ac6963614c3c02"
    end

    def group_id() do
        "26869951"
    end

    def access_token() do
        "sIvJQp3JTuBLaoAly2PRhQpq7EKsaq8iHwEP5xU1"
    end

end