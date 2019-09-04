module Modules
  module Misc
    extend Discordrb::Commands::CommandContainer

    add_command 'Misc', 'ping', 'Pong!'
    command :ping do |event|
      event.user.mention
    end

    add_command 'Misc', 'invite', 'Returns an invite link for the bot.'
    command :invite do |event|
      event.channel.send_embed do |embed|
        embed.description = "[Invite](#{$config['invite']})"
        embed.colour = $embed_color
      end
    end
  end
end
