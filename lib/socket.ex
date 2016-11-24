# Reverse engineered from here.
defmodule GroupMe.Socket do
    def open(access_token, user_id) do
        socket = Socket.Web.connect!("push.groupme.com", path: "/faye")

        data = %{
            channel: "/meta/handshake",
            version: "1.0",
            supportedConnectionTypes: ["websocket"]
        };

        # this.send([data]);
        r = Socket.Web.send!(socket, {:text, Poison.encode!(data)})
        IO.inspect r

        # Connect
        res = case Socket.Web.recv!(socket) do
        {:text, data} ->
            # process data
            IO.puts "got some data back"
            d = Poison.decode!(data)
            IO.inspect d
            hd(d)
        {:ping, _ } ->
            # TODO Do we need a ping here? Or will that not happen until later
            IO.puts "ping!"
            Socket.Web.send!(socket, {:pong, ""})
        end

        subscribe(socket, res["clientId"], access_token, user_id)
        listen(socket)

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

        r = Socket.Web.send!(socket, {:text, Poison.encode!(data)})
        IO.inspect r

        # Subscribe
        case Socket.Web.recv!(socket) do
        {:text, data} ->
            # process data
            IO.puts "got some data back for subscribing"
            d = Poison.decode!(data)
            IO.inspect d
            d
        {:ping, _ } ->
            IO.puts "ping!"
            Socket.Web.send!(socket, {:pong, ""})
        end
    end
    # TODO: Extract this out somehow?
    # How do listen to multiple users?
    # Move this to a GenSomething and then spawn one per user.
    # We might not even need more than one because 1 can listen to all groups.
    def listen(socket) do
        case Socket.Web.recv!(socket) do
            {:text, data} ->
                # process data
                IO.puts "got some data back for subscribing"
                d = Poison.decode!(data)
                IO.inspect d
                d
            {:ping, _ } ->
                IO.puts "ping!"
                Socket.Web.send!(socket, {:pong, ""})
        end

        listen(socket)
    end
end