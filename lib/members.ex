defmodule GroupMe.Members do
    # https://dev.groupme.com/docs/v3#members
    # MEMBERS
    # Add
    # members
    # array — nickname is required. You must use one of the following identifiers: user_id, phone_number, or email.
    # object
    # nickname (string) required
    # user_id (string)
    # phone_number (string)
    # email (string)
    # guid (string)
    # This is async so users are not going to be added real time.
    def create(nil, _, _), do: {:error, "Token is required"}
    def create(_, nil, _), do: {:error, "Group ID is required"}
    def create(token, group_id, options) do
        url = "https://api.groupme.com/v3/groups/#{group_id}/members/add?token=#{token}"
        case GroupMe.Request.post(url, %{members: options}) do
            {:ok, response} -> GroupMe.Request.handle_response(response)
            {:error, reason} -> {:error, reason}
        end
    end

    def create!(token, group_id, options) do
        case create(token, group_id, options) do
            {:ok, response} -> response
            {:error, reason} -> throw(reason)
        end
    end

    # Results
    # Keep in mind that results are temporary -- they will only be available for 1 hour after the add request.
    # GET /groups/:group_id/members/results/:results_id
    def results(nil, _, _), do: {:error, "Token is required"}
    def results(_, nil, _), do: {:error, "Group ID is required"}
    def results(_, _, nil), do: {:error, "Results ID is required"}
    def results(token, group_id, results_id) do
        url = "https://api.groupme.com/v3/groups/#{group_id}/members/results/#{results_id}?token=#{token}"
        case GroupMe.Request.get(url) do
            {:ok, response} ->
                GroupMe.Request.handle_response(response)
            {:error, reason} -> {:error, reason}
        end
    end

    def results!(token, group_id, results_id) do
        case results(token, group_id, results_id) do
            {:ok, response} -> response
            {:error, reason} -> throw(reason)
        end
    end

    # Remove
    # POST /groups/:group_id/members/:membership_id/remove
    # Parameters
    # membership_id required
    # string — Please note that this isn't the same as the user ID. In the members key in the group JSON, this is the id value, not the user_id.
    def remove(nil, _, _), do: {:error, "Token is required"}
    def remove(_, nil, _), do: {:error, "Group ID is required"}
    def remove(_, _, nil), do: {:error, "Membership ID is required"}
    def remove(token, group_id, membership_id) do
        url = "https://api.groupme.com/v3/groups/#{group_id}/members/#{membership_id}/remove?token=#{token}"
        case GroupMe.Request.post(url, %{}) do
            {:ok, response} ->
                GroupMe.Request.handle_response(response)
            {:error, reason} -> {:error, reason}
        end
    end

    def remove!(token, group_id, membership_id) do
        case remove(token, group_id, membership_id) do
            {:ok, response} -> response
            {:error, reason} -> throw(reason)
        end
    end

    # Update
    # Update your nickname.
    # POST /groups/:group_id/memberships/update
    def update(nil, _, _), do: {:error, "Token is required"}
    def update(_, nil, _), do: {:error, "Group ID is required"}
    def update(token, group_id, options) do
        url = "https://api.groupme.com/v3/groups/#{group_id}/memberships/update?token=#{token}"
        case GroupMe.Request.post(url, %{membership: options}) do
            {:ok, response} ->
                GroupMe.Request.handle_response(response)
            {:error, reason} -> {:error, reason}
        end
    end

    def update!(token, group_id, options) do
        case update(token, group_id, options) do
            {:ok, response} -> response
            {:error, reason} -> throw(reason)
        end
    end
end
