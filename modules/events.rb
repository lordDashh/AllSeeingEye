require "./timer.rb"

module Modules
  module Events
    extend Discordrb::EventContainer

    ready do |event|
      event.bot.watching = "over #{event.bot.users.length} people."
      status_timer = Timer.new 60 * 15, false, -> {
        event.bot.watching = "over #{event.bot.users.length} people."
      }
      status_timer.start
    end

    # Upon recieving a message, attempt to retrieve the entry of the message author and create one if it doesnt exist
    message do |event|
      server_id = event.server.id
      user_id = event.user.id
      acc = Database.get_db.execute 'SELECT * FROM main_table WHERE server_id = ? AND user_id = ?', server_id, user_id
      if !acc.any?
        Database.get_db.execute 'INSERT INTO main_table VALUES (?, ?, ?)', server_id, user_id, 1
      end
    end

    member_join do |event|
      results = Database.get_db.execute 'SELECT * FROM server_info WHERE server_id = ?', event.server.id
      if results.any? && results[0]['join_msg'] && results[0]['join_channel'] != 0
        ch = event.bot.channel results[0]['join_channel'].to_i
        ch.send_embed do |embed|
          embed.description = results[0]['join_msg'].gsub('%USERNAME%',event.user.name).gsub('%USERMENTION%',event.user.mention).gsub('%SERVERNAME%',event.server.name)
          embed.colour = $embed_color
        end
      end
    end
  end
end
