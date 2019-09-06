module Modules
  module Events
    extend Discordrb::EventContainer

    ready do |event|
      event.bot.watching = "over #{event.bot.users.length} people."
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

  end
end
