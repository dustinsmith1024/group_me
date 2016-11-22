defmodule GroupMe.Request do
    use HTTPoison.Base

    defp process_response_body(" "), do: nil
    defp process_response_body(body) do
        IO.inspect body
        Poison.decode!(body)
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
        Poison.encode!(body)
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

    # Pick One Test
    def group_id() do
        "26869951"
        # "share_url" => "https://app.groupme.com/join_group/26869951/Ftt6Vd",
    end

    # Pick One Dev
    def group_id() do
        "26737213"
    end

    def access_token() do
        "sIvJQp3JTuBLaoAly2PRhQpq7EKsaq8iHwEP5xU1"
    end

end