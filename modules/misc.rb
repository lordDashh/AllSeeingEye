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

    add_command 'Misc', 'about', 'Information about the eye.'
    command :about do |event|
      event.channel.send_embed do |embed|
        embed.title = 'About The All Seeing Eye',
        embed.description = "The Eye is an open source multipurpose discord bot programmed in Ruby by lord_dashh#9912 for the sake of fun in his freetime.\nThe source code can be found [here.](https://github.com/lordDashh/AllSeeingEye)"
        embed.colour = $embed_color
      end
    end
  end
end
