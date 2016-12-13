# Load up the Socket and start listening for messages.
# You will probably want this in a process of some sort.
#
# Task.async(fn()->
#    GroupMe.Socket.connect_and_listen("<token>", "<user_id>", fn(d) ->
#        IO.inspect(hd(d)["data"]["alert"])
#    end)
# end)
defmodule GroupMe.Socket do
    require Logger

    def connect_and_listen(access_token, user_id, on_data) do
        {socket, response} = handshake()
        {socket, _} = subscribe(socket, response["clientId"], access_token, user_id)
        # blocks, so do this in a task or something.
        listen(socket, on_data)
    end

    def handshake() do
        socket = Socket.Web.connect!("push.groupme.com", path: "/faye")

        data = %{
            channel: "/meta/handshake",
            version: "1.0",
            supportedConnectionTypes: ["websocket"]
        };

        Socket.Web.send!(socket, {:text, Poison.encode!(data)})

        response = case Socket.Web.recv!(socket) do
        {:text, data} ->
            Logger.debug "handshake #{data}"
            Poison.decode!(data)
            |> hd
        end

        {socket, response}
    end

    def subscribe(socket, client_id, access_token, user_id) do
        data = %{
            channel: "/meta/subscribe",
            clientId: client_id,
            subscription: "/user/#{user_id}",
            ext: %{
                access_token: access_token,
                timestamp: DateTime.utc_now
            }
        };

        Socket.Web.send!(socket, {:text, Poison.encode!(data)})

        # Subscribe
        response = case Socket.Web.recv!(socket) do
        {:text, data} ->
            # process data
            Logger.debug "subscribed: #{data}"
            Poison.decode!(data)
            |> hd
        end

        {socket, response}
    end

    # Pass in your data handler in on_data
    def listen(socket, on_data) do
        case Socket.Web.recv!(socket) do
            {:text, data} ->
                # process data
                Logger.debug "received data: #{data}"
                d = Poison.decode!(data)
                # Some reason we get PINGs here as well.
                if hd(d)["data"]["type"] != "ping" do
                    on_data.(d)
                end
            {:ping, _ } ->
                # Logger.debug "PING"
                Socket.Web.send!(socket, {:pong, ""})
        end

        listen(socket, on_data)
    end
end