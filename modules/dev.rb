require './includes.rb'

module Modules
  module Dev
    extend Discordrb::Commands::CommandContainer

    command :eval, help_available: false do |event, *code|
      break unless is_owner? event.user.id

      begin
        # Parse the supplied code if it's within a codeblock.
        if code[0].start_with? '```rb'
          code[0] = code[0][5..-1]
          code[-1] = code[-1][0..code[-1].length - 4]
        end
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
