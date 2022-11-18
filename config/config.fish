
if status is-interactive
  # Commands to run in interactive sessions can go here
end

# If starship is installed, initialize it
if type -q starship
  starship init fish | source
end
