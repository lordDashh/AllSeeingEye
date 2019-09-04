require './includes.rb'

module Modules
  module Dev
    extend Discordrb::Commands::CommandContainer

    command :eval, help_available: false do |event, *code|
      break unless is_owner? event.user.id

      begin
        eval code.join(' ')
      rescue => e
        event.channel.send_embed do |embed|
          embed.title = "Runtime error"
          embed.description = "```rb\n#{e}```"
          embed.colour = 0xff000
        end
      end
    end
  end
end
