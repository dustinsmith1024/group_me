defmodule GroupMe.Request do

    def headers() do
        %{
            "Content-Type": "application/json"
        }
    end

    def parse(response) do
        Poison.decode(response.body)
    end

    def get(url) do
        HTTPoison.start
        HTTPoison.get!(url, headers(), timeout: 600000, recv_timeout: 60000)
    end

    def post(url, body) do
        HTTPoison.start
        body = Poison.encode!(body)
        IO.inspect body

        HTTPoison.post(url, body, headers(), timeout: 600000, recv_timeout: 60000)
    end

    def pik_user_auth_token() do
        Application.get_env(:pik, :groupme)[:token]
    end

    def bot_id() do
        "8f334ddb3045ac6963614c3c02"
    end

end