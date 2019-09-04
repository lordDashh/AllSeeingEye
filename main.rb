require_relative 'includes.rb'

# Load config
$config = JsonLoader.load "data/config.json"
$prefix = $config['globalPrefix']

# Initialize bot
$bot = Discordrb::Commands::CommandBot.new(
  token:       $config['token'],
  client_id:   $config['clientId'],
  prefix:      $prefix,
  help_command: false,
  advanced_functionality: true,
  ignore_bots: false
)

# Globals
$embed_color = 0xa01b09 # Default embed color

# Information about commands will be stored in this.
$command_map = {
  :Misc => {
    :help => {
      :desc => 'Displays the help message. Type a command name to view information regarding that command',
      :usage => 'help',
      :example => 'help ping'
    }
  }
}

# Re-designed help command
$bot.command :help, max_args: 1 do |event, cmd_name|
  # Check if the user typed a command name in.
  if cmd_name
    cmd = nil
    $command_map.each do |k, v|
      v.each do |vk, vv|
        if vk == cmd_name.downcase.to_sym
          cmd = vv
          break
        end
      end
    end

    # Command doesn't exist
    "That command is out of existence." unless cmd

    # It exists, send info about it.
    event.channel.send_embed do |embed|
      embed.title = cmd_name.capitalize + ' - Help'
      embed.description = cmd[:desc]
      embed.add_field name: 'Usage', value: "`#{$prefix}#{cmd[:usage]}`", inline: true
      embed.add_field name: 'Example', value: "`#{$prefix}#{cmd[:example]}`", inline: true
      embed.colour = 0xa01b09
    end
    break
  end

  # List out all commands if the user didn't type a command name in.
  cmds = {}

  $command_map.each do |k, v|
    cmds_real = ''
    v.each do |vk, vv|
      cmds_real += "`#{vk}`, "
    end
    cmds[k] = cmds_real
  end

  event.channel.send_embed do |embed|
    embed.title = 'Help'
    embed.description = "Listing all modules and commands.```css\n<> = Required parameter\n[] = Optional parameter```"

    $command_map.each do |k, v|
      embed.add_field name: k, value: "```go\n#{cmds[k]}```", inline: true
    end

    embed.colour = 0xa01b09
  end
end

# Add containers
Dir.glob('modules/*.rb') do |file|
  require_relative file
  container = file.gsub('modules/', '').gsub('.rb', '').capitalize
  $bot.include! Object.const_get('Modules::' + container)
end

$bot.run
