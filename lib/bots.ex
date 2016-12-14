defmodule GroupMe.Bots do
    @moduledoc """
    Bots are programs that listen and respond to messages.
    You will need to create your own bot and register it before posting messages.

    [Group Me API](https://dev.groupme.com/docs/v3#bots)
    """


    @doc """
    Create a new bot.

    Returns a parsed JSON response.

    ## Options:

        bot[name] required string
        bot[group_id] required string
        bot[avatar_url] string
        bot[callback_url] string - You can only use the same callback once.
        bot[dm_notification] boolean - This makes a bot only respond to direct messages for a specific user.

    Token should the a USER token, not a Bot ID.
    """
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

    @doc """
    Post a Message from your bot.
    """
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

    @doc """
    List all your bots.
    """
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

    @doc """
    Delete/Destroy a bot.
    """
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
end