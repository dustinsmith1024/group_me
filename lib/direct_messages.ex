defmodule GroupMe.DirectMessages do
    alias Plug.Conn.Query
    alias UUID

    # DIRECT MESSAGES

    # Doens't look like there is a way to get these realtime.
    # We could use a Twilio number and put a web hook to POST to our server.
    # Then respond to the user from their.
    # We would have to look up by name though, which wouldn't be ideal.

    # Index
    # GET /direct_messages
    # other_user_id required
    # string — The other participant in the conversation.
    # before_id
    # string — Returns 20 messages created before the given message ID
    # since_id
    # string — Returns 20 messages created after the given message ID
    # List groups, grab an ID
    # GroupMe.Groups.list("<token>")
    # GroupMe.DirectMessages.list("<token>", %{other_user_id: "<user_id>"})
    def list(token), do: list(token, %{})
    def list(nil, _), do: {:error, "Token is required"}
    def list(token, options) do
        if !Map.has_key?(options, :other_user_id) do
            {:error, "other_user_id is required in message"}
        else
            query = Query.encode(Map.put(options, "token", token))
            url = "https://api.groupme.com/v3/direct_messages?#{query}"
            case GroupMe.Request.get(url) do
                {:ok, response} ->
                    GroupMe.Request.handle_response(response)
                {:error, reason} -> {:error, reason}
            end
        end
    end

    def list!(token, options) do
        case list(token, options) do
            {:ok, response} -> response
            {:error, reason} -> throw(reason)
        end
    end

    # Create
    # source_guid required
    # string — This is used for client-side deduplication.
    # recipient_id required
    # string — The GroupMe user ID of the recipient of this message.
    # text required
    # string — This can be omitted if at least one attachment is present.
    # attachments
    # array — A polymorphic list of attachments (locations, images, etc). You may have You may have more than one of any type of attachment, provided clients can display it.
    # object
    # type (string) — “image” required
    # url (string) required — Must be an image service (i.groupme.com) URL
    # object
    # type (string) — “location” required
    # name (string) required
    # lat (string) required
    # lng (string) required
    # object
    # type (string) — “emoji” required
    # placeholder (string) — “☃” required
    # charmap (array) — “[{pack_id},{offset}]” required
    # POST /direct_messages
    def create(nil, _), do: {:error, "Token is required"}
    def create(_, nil), do: {:error, "Message is required"}
    def create(token, message) do
        if !Map.has_key?(message, :recipient_id) do
            {:error, "recipient_id is required in message"}
        else
            message = case Map.has_key?(message, :source_guid) do
                false ->
                    Map.put(message, :source_guid, UUID.uuid4)
                true ->
                    message
            end

            url = "https://api.groupme.com/v3/direct_messages?token=#{token}"
            case GroupMe.Request.post(url, %{direct_message: message}) do
                {:ok, response} -> GroupMe.Request.handle_response(response)
                {:error, reason} -> {:error, reason}
            end
        end
    end

    def create!(token, message) do
        case create(token, message) do
            {:ok, response} -> response
            {:error, reason} -> throw(reason)
        end
    end
end
