# GroupMe

An Elixir library for working with the GroupMe API.
Supports basic HTTP client and the Socket/Faye streaming protocols.

## Usage

Check the code for now.
The Socket handler is the best for consuming messages, and the messages module is best for sending them.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `group_me` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:group_me, "~> 0.1.0"}]
    end
    ```

  2. Ensure `group_me` is started before your application:

    ```elixir
    def application do
      [applications: [:group_me]]
    end
    ```

