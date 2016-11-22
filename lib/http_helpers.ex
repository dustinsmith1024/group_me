defmodule GroupMe.Request do
    use HTTPoison.Base

    defp process_response_body(" "), do: nil
    defp process_response_body(body) do
        IO.inspect body
        Poison.decode!(body)
    end

    defp process_request_headers([]), do: Enum.into(default_headers, [])
    defp process_request_headers(headers) when is_map(headers) do
        Enum.into(headers, [])
    end

    defp default_headers do
        %{
            "Content-Type": "application/json",
        }
    end



    def handle_response(%{body: nil}), do: {:ok, nil}
    def handle_response(response) do
        body = response.body
        case response.body["meta"]["code"] do
            code when code < 300 ->
                IO.puts "300"
                {:ok, body["response"]}
            code when code < 500 ->
                IO.puts "500"
                {:error, body["meta"]}
            code ->
                IO.puts "300xxx"
                # TODO: not sure this is correct
                {:error, body["meta"]}
        end
    end

    defp process_request_body(body) when is_map(body) do
        IO.inspect body
        b = Poison.encode!(body)
        IO.inspect b
        b
    end

    defp process_request_body(body) do
        body
    end

    def pik_user_auth_token() do
        Application.get_env(:pik, :groupme)[:token]
    end

    def bot_id() do
        "8f334ddb3045ac6963614c3c02"
        "8e31ae73d8914aac573f60e4c3"
    end

    def group_id() do
        "26869951" # Pick One Test
        "26737213" # Pick One Dev
        # "share_url" => "https://app.groupme.com/join_group/26869951/Ftt6Vd",
    end

    def access_token() do
        "sIvJQp3JTuBLaoAly2PRhQpq7EKsaq8iHwEP5xU1"
    end

end