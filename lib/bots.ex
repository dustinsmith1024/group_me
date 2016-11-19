defmodule GroupMe.Bots do
    # BOTS
    # Create
    def create() do

    end

    # Post a Message
    # We want to send bot_id in
    def post_message(bot_id, message) do
        url = "https://api.groupme.com/v3/bots/post"

        IO.inspect message
        body = %{
            "text": message,
            "bot_id": bot_id
        }

        {status, resp} = GroupMe.Request.post(url, body)
        IO.inspect resp
        IO.inspect status
        resp
    end

    # Index
    def list() do

    end

    # Destroy
    def delete() do

    end

    def bot_id() do
        "8f334ddb3045ac6963614c3c02"
    end

    Application.get_env(:pik, :groupme)[:token]
end