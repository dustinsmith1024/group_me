defmodule GroupMe.Messages do
    # https://dev.groupme.com/docs/v3#messages
    # TODO: Setup websockets
    # https://dev.groupme.com/tutorials/push
    alias Plug.Conn.Query
    alias UUID
    # MESSAGES
    # Index
    # GET /groups/:group_id/messages
    # Parameters

    # before_id
    # string — Returns messages created before the given message ID
    # since_id
    # string — Returns most recent messages created after the given message ID
    # after_id
    # string — Returns messages created immediately after the given message ID
    # limit
    # integer — Number of messages returned. Default is 20. Max is 100.
    def list(nil, _, _), do: {:error, "Token is required"}
    def list(token, group_id, options) do
        query = Query.encode(Map.put(options, "token", token))
        url = "https://api.groupme.com/v3/groups/#{group_id}/messages?#{query}"
        IO.puts url
        case GroupMe.Request.get(url) do
            {:ok, response} ->
                GroupMe.Request.handle_response(response)
            {:error, reason} -> {:error, reason}
        end
    end

    def list!(token, group_id, options) do
        case list(token, group_id, options) do
            {:ok, response} -> response
            {:error, reason} -> throw(reason)
        end
    end

    # Create
    # source_guid required
    # string — Client-side IDs for messages. This can be used by clients to set their own identifiers on messages, but the server also scans these for de-duplication. That is, if two messages are sent with the same source_guid within one minute of each other, the second message will fail with a 409 Conflict response. So it's important to set this to a unique value for each message.
    # text required
    # string — This can be omitted if at least one attachment is present. The maximum length is 1,000 characters.
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
    # type (string) — “split” required
    # token (string) required
    # object
    # type (string) — “emoji” required
    # placeholder (string) — “☃” required
    # charmap (array) — “[{pack_id},{offset}]” required
    # POST /groups/:group_id/messages
    # GroupMe.Messages.create("sIvJQp3JTuBLaoAly2PRhQpq7EKsaq8iHwEP5xU1", "26869951", %{text: "this better work..."})
    def create(nil, _, _), do: {:error, "Token is required"}
    def create(_, nil, _), do: {:error, "Group ID is required"}
    def create(token, group_id, message) do
        message = case Map.has_key?(message, :source_guid) do
            false ->
                Map.put(message, :source_guid, UUID.uuid4)
            true ->
                message
        end

        url = "https://api.groupme.com/v3/groups/#{group_id}/messages?token=#{token}"
        case GroupMe.Request.post(url, %{message: message}) do
            {:ok, response} -> GroupMe.Request.handle_response(response)
            {:error, reason} -> {:error, reason}
        end
    end

    def create!(token, group_id, message) do
        case create(token, group_id, message) do
            {:ok, response} -> response
            {:error, reason} -> throw(reason)
        end
    end

end