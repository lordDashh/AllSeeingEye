# Internal command to check if user is bot owner
def is_owner?(id)
  $config['owners'].include? id
end

# Helper method to add a command into the Command Hash for the help command.
def add_command(mod, name, desc, usage = nil, example = nil)
  $command_map[mod.to_sym] ||= {}
  $command_map[mod.to_sym][name.to_sym] = {
    :desc => desc,
    :usage => usage || name,
    :example => example || name
  }
end
