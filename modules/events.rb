module Modules
  module Events
    extend Discordrb::EventContainer

    ready do |event|
      event.bot.watching = "everything"
    end

  end
end
