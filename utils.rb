# Internal command to check if user is bot owner
def is_owner?(id)
  id == 339475044172431360 || id == 152844642809937920
end

# Helper method to add a command into the Command Hash for the help command.
def add_command(mod, name, desc, usage = nil, example = nil)
  usage ||= name
  example ||= name
  $command_map[mod.to_sym][name.to_sym] = {
    :desc => desc,
    :usage => usage,
    :example => example
  }
end
