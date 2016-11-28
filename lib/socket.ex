# You might not always need event handles?
# Socket.start()
# Socket.direct(fn(data) ->
#     ...handle data
# end)
# Socket.listen({:direct, fn ->
#     ...handle direct message
# end)
#
# iex(1)> GroupMe.Socket.open("sIvJQp3JTuBLaoAly2PRhQpq7EKsaq8iHwEP5xU1", "44040609", fn(d) -> IO.inspect(hd(d)["data"]["alert"]) end)
defmodule GroupMe.Socket do
    require Logger

    def open(access_token, user_id, on_data) do
        socket = Socket.Web.connect!("push.groupme.com", path: "/faye")

        data = %{
            channel: "/meta/handshake",
            version: "1.0",
            supportedConnectionTypes: ["websocket"]
        };

        Socket.Web.send!(socket, {:text, Poison.encode!(data)})

        # Connect
        res = case Socket.Web.recv!(socket) do
        {:text, data} ->
            # process data
            Logger.debug "handshake #{data}"
            d = Poison.decode!(data)
            hd(d)
        {:ping, _ } ->
            # TODO Do we need a ping here? Or will that not happen until later
            Socket.Web.send!(socket, {:pong, ""})
        end

        subscribe(socket, res["clientId"], access_token, user_id)
        listen(socket, on_data)
    end

    # "sIvJQp3JTuBLaoAly2PRhQpq7EKsaq8iHwEP5xU1"
    #  <> "44040609"
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
        case Socket.Web.recv!(socket) do
        {:text, data} ->
            # process data
            Logger.debug "subscribed: #{data}"
            d = Poison.decode!(data)
            d
        {:ping, _ } ->
            Socket.Web.send!(socket, {:pong, ""})
        end
    end

    # TODO: Extract this out somehow?
    # How do listen to multiple users?
    # Move this to a GenSomething and then spawn one per user.
    # We might not even need more than one because 1 can listen to all groups.
    def listen(socket, on_data) do
        case Socket.Web.recv!(socket) do
            {:text, data} ->
                # process data
                Logger.debug "received data: #{data}"
                d = Poison.decode!(data)
                on_data.(d)
            {:ping, _ } ->
                Logger.debug "PING"
                Socket.Web.send!(socket, {:pong, ""})
        end

        listen(socket, on_data)
    end
end