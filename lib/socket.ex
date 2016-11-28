# Load up the Socket and start listening for messages.
#
# GroupMe.Socket.connect_and_listen("sIvJQp3JTuBLaoAly2PRhQpq7EKsaq8iHwEP5xU1", "44040609", fn(d) -> IO.inspect(hd(d)["data"]["alert"]) end)
#
# You will probably want this in a process of some sort.
#
# Task.async(fn()->  GroupMe.Socket.connect_and_listen("sIvJQp3JTuBLaoAly2PRhQpq7EKsaq8iHwEP5xU1", "44040609", fn(d) -> IO.inspect(hd(d)["data"]["alert"]) end)    end)
defmodule GroupMe.Socket do
    require Logger

    def connect_and_listen(access_token, user_id, on_data) do
        {socket, response} = handshake()
        {socket, response} = subscribe(socket, response["clientId"], access_token, user_id)
        # blocks
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

    # TODO: Extract this out somehow?
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