defmodule Botter.Bot do
    use GenServer
    use Hound.Helpers

    def start_link(params) do
        GenServer.start_link(
            __MODULE__, 
            params
        )
    end
  

    @impl true
    def init(state) do
        # start a Hound session
        hound = Hound.Helpers.Session.start_session() 
        state = Map.put_new(state, :hound, hound)
        # start the game
        schedule_next_move()
        {:ok, state}
    end


    @impl true
    def handle_info(:play, state) do

        state = cond do
            is_signed_in?(state) == false -> signin(state)
            looking_at_mailbox?() == true -> pick_message(state)
            looking_at_clickable_message?() == true -> decide(state)
            looking_at_exit_page?() == true -> shutdown(state)
            true -> state
        end
        
        schedule_next_move()
        { :noreply, state }
    end


    def shutdown(state) do
        Hound.Helpers.Session.end_session(state[:hound])
        GenServer.stop(__MODULE__, :normal)
    end


    defp pick_message(state) do
        { success, message_link } = search_element(:css, "ul#undecided-messages-list li.message a", 3)
        if success != :error do
            click(message_link)
        end
        state
    end


    defp decide(state) do
        decision = Enum.random(["share", "discard"])
        decision = "share"
        button = find_element(:css, "div.#{decision} button")
        click(button)
        state
    end


    defp signin(state) do
        %{ access_token: access_token, ideology: ideology, delay: delay, env: env } = state
        # delay
        :timer.sleep(delay * 500)

        if env == "local" do
            navigate_to("http://localhost:4000/welcome?g=#{ideology}&access_token=#{access_token}")
        else
            navigate_to("https://networklab.onrender.com/welcome?g=#{ideology}&access_token=#{access_token}")
        end

        tos1 = find_element(:id, "terms_of_service_1")
        click(tos1)

        tos2 = find_element(:id, "terms_of_service_2")
        click(tos2)

        ideology = find_element(:id, "user_current_ideology_#{ideology}")
        click(ideology)

        go_button = find_element(:id, "go")
        click(go_button)

        Map.put_new(state, :signed_in, true)

    end


    defp is_signed_in?(state) do
        Map.get(state, :signed_in, false)
    end


    defp looking_at_mailbox?() do
        { success, _ } = search_element(:css, "ul#undecided-messages-list", 2)
        success != :error
    end

    defp looking_at_clickable_message?() do
        { success, button } = search_element(:css, "section#message-decision button.decision-button", 2)

        if success == :error do
            false
        else
            element_enabled?(button)
        end
    end


    defp looking_at_exit_page?() do
        { success, _ } = search_element(:css, "section.exit", 2)
        success != :error
    end


    def schedule_next_move() do
        # play every half a second
        Process.send_after(self(), :play, 250)
    end
  

  end