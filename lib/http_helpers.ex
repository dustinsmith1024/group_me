defmodule GroupMe.Request do
    use HTTPoison.Base
    require Logger

    defp process_response_body(" "), do: nil
    defp process_response_body(body) do
        Logger.debug"#{inspect body}"
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
                {:ok, body["response"]}
            code when code < 500 ->
                {:error, body["meta"]}
            true ->
                # TODO: not sure this is correct
                {:error, body["meta"]}
        end
    end

    defp process_request_body(body) when is_map(body) do
        Logger.debug"#{inspect body}"
        Poison.encode!(body)
    end

    defp process_request_body(body) do
        Logger.debug"#{inspect body}"
        body
    end

end