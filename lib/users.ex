defmodule GroupMe.Users do
    #     USERS
    #       Me
    def find(token) when token == nil, do: {:error, "Token is required"}
    def find(token) do
        url = "https://api.groupme.com/v3/users/me?token=#{token}"
        case GroupMe.Request.get(url) do
            {:ok, response} ->
                GroupMe.Request.handle_response(response)
            {:error, reason} -> {:error, reason}
        end
    end

    def find!(token) do
        case find(token) do
            {:ok, response} -> response
            {:error, reason} -> throw(reason)
        end
    end

    # Update
    # avatar_url
    # string — URL to valid JPG/PNG/GIF image. URL will be converted into an image service link (http://i.groupme.com/....)
    # name
    # string — Name must be of the form FirstName LastName
    # email
    # string — Email address. Must be in name@domain.com form.
    # zip_code
    # string — Zip code.
    def update(token, _) when token == nil, do: {:error, "Token is required"}
    def update(token, options) do
        url = "https://api.groupme.com/v3/users/update?token=#{token}"
        case GroupMe.Request.post(url, options) do
            {:ok, response} -> GroupMe.Request.handle_response(response)
            {:error, reason} -> {:error, reason}
        end
    end

    def update!(token, options) do
        case update(token, options) do
            {:ok, response} -> response
            {:error, reason} -> throw(reason)
        end
    end

end