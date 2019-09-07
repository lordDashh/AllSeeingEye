module Modules
  module Administration
      extend Discordrb::Commands::CommandContainer

      add_command 'Administration', 'welcome_message', "Sets the welcome message for when a user joins. Leave empty to view the current message. Type 'remove' to remove the welcome message.\n%USERNAME%: name of the user\n%USERMENTON%: mention of the user\n%SERVERNAME%: name of the server",
      'welcome_message [message]', 'welcome_message Greetings %USERNAME%, The All Seeing Eye greets you to %SERVERNAME%.'
      command :welcome_message do |event, *welcome_msg|
        return 'You cannot perform that.' unless event.user.permission? :administrato
        
        results = Database.get_db.execute 'SELECT * FROM server_info WHERE server_id = ?;', event.server.id

        if welcome_msg && welcome_msg.any?
          message = welcome_msg.join(' ')
          # Check if the user wants to remove the welcome message
          if message.downcase == 'remove'
              Database.get_db.execute 'UPDATE server_info SET join_msg = NULL WHERE server_id = ?;', event.server.id
              return 'Done.'
          end

          # Set or update the welcome message
          if results.any?
            Database.get_db.execute 'UPDATE server_info SET join_msg = ? WHERE server_id = ?;', message, event.server.id
          else
            Database.get_db.execute 'INSERT INTO server_info(server_id, join_msg, join_channel) VALUES (?, ?, 0);', event.server.id, message
          end
          return 'Done.'
        end

        # Show the welcome message
        return 'There is no welcome message configured for this server yet.' unless results.any?

        event.channel.send_embed do |embed|
          embed.title = 'Welcome Message'
          embed.description = results[0]['join_msg']
          embed.colour = $embed_color

          ch_id = results[0]['join_channel']

          embed.add_field name: 'Preview', value: results[0]['join_msg'].gsub('%USERNAME%',event.user.name).gsub('%USERMENTION%',event.user.mention).gsub('%SERVERNAME%',event.server.name)
          embed.add_field name: 'Will be sent in', value: ch_id != 0 ? "<##{ch_id}>" : 'Nowhere (Welcome channel not set).'
        end
      end

      add_command 'Administration', 'welcome_channel', 'Sets the channel where the welcome messages will be sent in. Leave empty to view. Type "remove" to remove the current welcome channel.', 'welcome_channel <channel>', 'welcome_channel #joins'
      command :welcome_channel do |event, channel|
        return 'You cannot perform that.' unless event.user.permission? :administrator

        results = Database.get_db.execute 'SELECT * FROM server_info WHERE server_id = ?;', event.server.id

        # Check if the user wants to add or remove the welcome channel.
        if channel
          if channel == 'remove'
            Database.get_db.execute 'UPDATE server_info SET join_channel = 0 WHERE server_id = ?;', event.server.id
            return 'Done.'
          end

          ch = event.bot.channel channel.gsub('<','').gsub('#','').gsub('>','')
          return 'Channel does not exist' unless ch

          if results.any?
            Database.get_db.execute 'UPDATE server_info SET join_channel = ? WHERE server_id = ?;', ch.id, event.server.id
          else
            Database.get_db.execute 'INSERT INTO server_info(server_id, join_msg, join_channel) VALUES (?, NULL, ?);', event.server.id, ch.id
          end
          return 'Done.'
        end

        # Send current config.
        return 'There is currently no welcome channel configured.' unless results.any? && results[0]['join_channel'] != 0
        event.channel.send_embed do |embed|
          embed.description = "The welcome channel is <##{results[0]['join_channel']}>."
          embed.colour = $embed_color
        end
      end
  end
end
