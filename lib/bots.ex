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
        if !Map.has_key?(options, :name) || !Map.has_key?(options, :group_id) do
            {:error, "Required params name and/or group_id not found."}
        else
            url = "https://api.groupme.com/v3/bots?token=#{token}"
            case GroupMe.Request.post(url, %{bot: options}) do
                {:ok, response} -> GroupMe.Request.handle_response(response)
                {:error, reason} -> {:error, reason}
            end
        end
    end

    def create!(token, options) do
        case create(token, options) do
            {:ok, response} -> response
            {:error, reason} -> throw(reason)
        end
    end

    # Post a Message
    # We want to send bot_id in
    def post_message(bot_id, _) when bot_id==nil, do: {:error, "Bot ID cannot be nil."}
    def post_message(_, message) when message==nil, do: {:error, "Message cannot be nil."}
    def post_message(bot_id, message) do
        url = "https://api.groupme.com/v3/bots/post"

        body = %{
            text: message,
            bot_id: bot_id
        }

        case GroupMe.Request.post(url, body) do
            {:ok, response} -> GroupMe.Request.handle_response(response)
            {:error, reason} -> {:error, reason}
        end
    end

    # Index
    def list(token) when token == nil, do: {:error, "Token is required"}
    def list(token) do
        url = "https://api.groupme.com/v3/bots?token=#{token}"
        case GroupMe.Request.get(url) do
            {:ok, response} ->
                GroupMe.Request.handle_response(response)
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
    def delete(token, bot_id) do
        url = "https://api.groupme.com/v3/bots/destroy?token=#{token}"
        body = %{
            bot_id: bot_id
        }
        case GroupMe.Request.post(url, body) do
            {:ok, response} -> GroupMe.Request.handle_response(response)
            {:error, reason} -> {:error, reason}
        end
    end

    def delete!(token, bot_id) do
        case delete(token, bot_id) do
            {:ok, response} -> response
            {:error, reason} -> throw(reason)
        end
    end

    def bot_id() do
        "8f334ddb3045ac6963614c3c02"
    end

    # Application.get_env(:pik, :groupme)[:token]
end