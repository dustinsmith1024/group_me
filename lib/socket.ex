defmodule GroupMe.Socket do
    def open() do
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
            IO.puts "ping!"
            Socket.Web.send!(socket, {:pong, ""})
        end

        IO.puts res["clientId"]
        data = %{
            channel: "/meta/subscribe",
            clientId: res["clientId"],
            subscription: "/user/" <> "44040609",
            ext: %{
                access_token: "sIvJQp3JTuBLaoAly2PRhQpq7EKsaq8iHwEP5xU1",
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

        listen(socket)

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