defmodule GroupMe.SMSMode do
    # SMS MODE
    # TODO: Couldn't test this as I dont have a push notification ID handy.

    # Create
    # duration required
    # integer
    # registration_id
    # string — The push notification ID/token that should be suppressed during SMS mode. If this is omitted, both SMS and push notifications will be delivered to the device.
    def create(token, _) when token == nil, do: {:error, "Token is required"}
    def create(token, options) do
        if !Map.has_key?(options, :duration) do
            {:error, "Required params duration not found."}
        else
            url = "https://api.groupme.com/v3/users/sms_mode?token=#{token}"
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

    # Delete
    def delete(token, _) when token == nil, do: {:error, "Token is required"}
    def delete(token) do
        url = "https://api.groupme.com/v3/users/sms_mode/delete?token=#{token}"
        case GroupMe.Request.post(url, %{}) do
            {:ok, response} -> GroupMe.Request.handle_response(response)
            {:error, reason} -> {:error, reason}
        end
    end

    def delete!(token, options) do
        case delete(token, options) do
            {:ok, response} -> response
            {:error, reason} -> throw(reason)
        end
    end
end