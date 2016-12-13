defmodule GroupMe.Groups do

    # GROUPS
    # Index
    def list(token) when token == nil, do: {:error, "Token is required"}
    def list(token) do
        url = "https://api.groupme.com/v3/groups?token=#{token}"
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
    # Former
    def list_former(token) when token == nil, do: {:error, "Token is required"}
    def list_former(token) do
        url = "https://api.groupme.com/v3/groups/former?token=#{token}"
        case GroupMe.Request.get(url) do
            {:ok, response} ->
                GroupMe.Request.handle_response(response)
            {:error, reason} -> {:error, reason}
        end
    end

    def list_former!(token) do
        case list_former(token) do
            {:ok, response} -> response
            {:error, reason} -> throw(reason)
        end
    end

    # Show
    def find(token, _) when token == nil, do: {:error, "Token is required"}
    def find(_, group_id) when group_id == nil, do: {:error, "Group ID is required"}
    def find(token, group_id) do
        url = "https://api.groupme.com/v3/groups/#{group_id}?token=#{token}"
        case GroupMe.Request.get(url) do
            {:ok, response} ->
                GroupMe.Request.handle_response(response)
            {:error, reason} -> {:error, reason}
        end
    end

    def find!(token, group_id) do
        case find(token, group_id) do
            {:ok, response} -> response
            {:error, reason} -> throw(reason)
        end
    end

    # Create
    # name required
    # string — Primary name of the group. Maximum 140 characters
    # description
    # string — A subheading for the group. Maximum 255 characters
    # image_url
    # string — GroupMe Image Service URL
    # share
    # boolean — If you pass a true value for share, we'll generate a share URL. Anybody with this URL can join the group.
    def create(token, _) when token == nil, do: {:error, "Token is required"}
    def create(token, options) do
        if !Map.has_key?(options, :name) do
            {:error, "Required params name not found."}
        else
            url = "https://api.groupme.com/v3/groups?token=#{token}"
            case GroupMe.Request.post(url, options) do
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

    # Update
    # name - string
    # description - string
    # image_url - string
    # office_mode - boolean
    # share - boolean
    # — If you pass a true value for share, we'll generate a share URL. Anybody with this URL can join the group.
    def update(nil, _, _), do: {:error, "Token is required"}
    def update(_, nil, _), do: {:error, "Group ID is required"}
    def update(token, group_id, options) do
        url = "https://api.groupme.com/v3/groups/#{group_id}/update?token=#{token}"
        case GroupMe.Request.post(url, options) do
            {:ok, response} -> GroupMe.Request.handle_response(response)
            {:error, reason} -> {:error, reason}
        end
    end

    def update!(token, group_id, options) do
        case update(token, group_id, options) do
            {:ok, response} -> response
            {:error, reason} -> throw(reason)
        end
    end

    # Destroy
    def delete(nil, _), do: {:error, "Token is required"}
    def delete(_, nil), do: {:error, "Group ID is required"}
    def delete(token, group_id) do
        url = "https://api.groupme.com/v3/groups/#{group_id}/destroy?token=#{token}"

        case GroupMe.Request.post(url, %{}) do
            {:ok, response} -> GroupMe.Request.handle_response(response)
            {:error, reason} -> {:error, reason}
        end
    end

    def delete!(token, group_id) do
        case delete(token, group_id) do
            {:ok, response} -> response
            {:error, reason} -> throw(reason)
        end
    end

    def join(nil, _, _), do: {:error, "Token is required"}
    def join(_, nil, _), do: {:error, "Group ID is required"}
    def join(_, _, nil), do: {:error, "Share token is required"}
    def join(token, group_id, shared_token) do
        url = "https://api.groupme.com/v3/groups/#{group_id}/join/#{shared_token}?token=#{token}"

        case GroupMe.Request.post(url, %{}) do
            {:ok, response} -> GroupMe.Request.handle_response(response)
            {:error, reason} -> {:error, reason}
        end
    end

    def join!(token, group_id, shared_token) do
        case join(token, group_id, shared_token) do
            {:ok, response} -> response
            {:error, reason} -> throw(reason)
        end
    end

    # Rejoin
    def rejoin(nil, _), do: {:error, "Token is required"}
    def rejoin(_, nil), do: {:error, "Group ID is required"}
    def rejoin(token, group_id) do
        url = "https://api.groupme.com/v3/groups/rejoin?token=#{token}"

        case GroupMe.Request.post(url, %{group_id: group_id}) do
            {:ok, response} -> GroupMe.Request.handle_response(response)
            {:error, reason} -> {:error, reason}
        end
    end

    def rejoin!(token, group_id) do
        case rejoin(token, group_id) do
            {:ok, response} -> response
            {:error, reason} -> throw(reason)
        end
    end
end