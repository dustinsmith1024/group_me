defmodule GroupMe.Bots do
    # BOTS
    # Create
    # bot[name] required string
    # bot[group_id] required string
    # bot[avatar_url] string
    # bot[callback_url] string
    # bot[dm_notification] boolean
    # Token should the a USER token, not a Bot ID.
    def create(token, _) when token == nil, do: {:error, "Token is required"}
    def create(token, options) do
        if !Map.has_key?(options, :name) || Map.has_key?(options, :group_id) do
            # throw
            {:error, "Required params name and/or group_id not found."}
        else
            url = "https://api.groupme.com/v3/bots?token=#{token}"
            GroupMe.Request.post(url, %{bot: options})
        end
        # %HTTPoison.Response{body: "{\"meta\":{\"code\":201},\"response\":{\"bot\":{\"name\":\"New Piker\",\"bot_id\":\"ba712580bd938ba074a7dcc032\",\"group_id\":\"26869951\",\"group_name\":\"pick one test\",\"avatar_url\":null,\"callback_url\":null,\"dm_notification\":false}}}",
        #  headers: [{"Cache-Control", "max-age=0, private, must-revalidate"},
        #   {"Content-Type", "application/json; charset=utf-8"},
        #   {"Date", "Sun, 20 Nov 2016 18:33:12 GMT"},
        #   {"Etag", "\"db78ee084addda2b71c0a4ebeb124fd0\""}, {"Server", "nginx/1.10.2"},
        #   {"Status", "201 Created"}, {"Strict-Transport-Security", "max-age=31536000"},
        #   {"X-Runtime", "0.025714"}, {"X-Ua-Compatible", "IE=Edge,chrome=1"},
        #   {"Content-Length", "212"}, {"Connection", "keep-alive"}], status_code: 201}
    end

    # Post a Message
    # We want to send bot_id in
    def post_message(bot_id, message) when bot_id==nil, do: {:error, "Bot ID cannot be nil."}
    def post_message(bot_id, message) do
        url = "https://api.groupme.com/v3/bots/post"

        IO.inspect message
        body = %{
            text: message,
            bot_id: bot_id
        }

        {status, resp} = GroupMe.Request.post(url, body)
        IO.inspect resp
        IO.inspect status
        resp
    end

    # Index
    def list(token) when token == nil, do: {:error, "Token is required"}
    def list(token) do
        url = "https://api.groupme.com/v3/bots?token=#{token}"
        case GroupMe.Request.get(url) do
            {:ok, response} -> {:ok, response.body}
            {:error, reason} -> {:error, reason}
        end
    end

    def list!(token) do
        case list(token) do
            {:ok, response} -> response
            {:error, reason} -> throw(reason)
        end
    end

    # Destroy
    def delete() do

    end

    def bot_id() do
        "8f334ddb3045ac6963614c3c02"
    end

    Application.get_env(:pik, :groupme)[:token]
end