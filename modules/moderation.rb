require 'securerandom'

module Modules
  module Moderation
    extend Discordrb::Commands::CommandContainer

    # Returns a sassy message if the user doesn't have permissions to execute commands such as warn, kick, ban, etc otherwise nil.
    def self.check_perms(victim, moderator, bot)
      if victim.owner?
        return 'You think any of us can do that?'
      end
      if !moderator.permission? :kick_members
        return "You do not hold such power to perform this action."
      end

      mod_role = moderator.highest_role ? moderator.highest_role.position : 0
      vic_role = victim.highest_role ? victim.highest_role.position : 0
      bot_role = bot.highest_role ? bot.highest_role.position : 0

      if mod_role < vic_role
        return 'You do not pose such strength to perform that to someone higher than you.'
      end
      if bot_role < vic_role
        return 'Unfortunately... I... can\'t do that'
      end

      return nil
    end

    # NOTE: apparently the command doesn't capture anything after 'user' but i'm too lazy to try to fix this right now.
    add_command 'Moderation', 'warn', 'Warns the specified user and logs it.', 'warn <user> [reason]', 'warn @lord_dashh#9912 stupid'
    command :warn, min_args: 1 do |event, user, *reason|
      reason_str = reason.join(' ')
      reason_str ||= 'No reason given.'
      victim = event.server.member user.gsub('<','').gsub('>','').gsub('@','').gsub('!', '')
      unless victim
        return 'Specified user does not exist.'
      end
      bot = event.server.member $config['botId']
      perm_result = check_perms victim, bot, event.user
      return perm_result if perm_result

      # Register the warning into the db.
      warn_id = SecureRandom.hex 2
      Database.get_db.execute 'INSERT INTO warns_table(server_id, user_id, warn_id, warn_reason, warn_mod) VALUES (?, ?, ?, ?, ?);', event.server.id, victim.id, warn_id, reason_str, event.user.id

      # Notify the channel about the operation.
      event.channel.send_embed do |embed|
        embed.title = 'Warn user'
        embed.description = "Successfully warned #{victim.mention}."
        embed.colour = $embed_color
      end
    end

    add_command 'Moderation', 'view_warns', 'View all warnings the specified user has.', 'view_warns <user>', 'view_warns @lord_dashh#9912'
    command :view_warns, min_args: 1 do |event, user|
      victim = event.server.member user.gsub('<','').gsub('>','').gsub('@','').gsub('!', '')
      unless victim
        return 'Specified user does not exist.'
      end

      if victim.owner?
        return 'Ha, nice joke.'
      end
      unless event.user.permission? :kick_members
        return 'You know you cannot do that.'
      end

      results = Database.get_db.execute 'SELECT * FROM warns_table WHERE server_id = ? AND user_id = ?', event.server.id, victim.id
      return 'This user has got no warns.' unless results.any?

      event.channel.send_embed do |embed|
        embed.title = victim.name + '\'s warns'
        embed.colour = $embed_color

        results.each do |row|
          mod = event.server.member row['warn_mod'].to_i
          embed.add_field name: "`[#{row['warn_id'].upcase}]`", value: row['warn_reason'] + ' -' + mod.mention
        end
      end
    end

    add_command 'Moderation', 'revoke_warn', 'Revokes a warning from the specified user.', 'revoke_warn <warn_id> <user>', 'revoke_warn 1b8f @lord_dashh#9912'
    command :revoke_warn, min_args: 2 do |event, warn_id, user|
      victim = event.server.member user.gsub('<','').gsub('>','').gsub('@','').gsub('!', '')
      if !victim
        return 'Specified user does not exist.'
      end

      if victim.owner?
        return 'Ha, nice joke.'
      end
      if !event.user.permission? :kick_members
        return 'You know you cannot do that.'
      end

      Database.get_db.execute 'DELETE FROM warns_table WHERE server_id = ? AND user_id = ? AND warn_id = ?', event.server.id, victim.id, warn_id
      return 'Done.'
    end
  end
end
