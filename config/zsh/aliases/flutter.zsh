
######################################################################
# ZSH aliases for common Flutter + Dart dev commands                 #
# Inspired by ohmyzsh/flutter and hadenlabs/zsh-flutter              #
#                                                                    #
# Licensed under MIT (C) Alicia Sykes 2022 <https://aliciasykes.com> #
######################################################################

# Main fultter command
alias fl="flutter"

# Attaches flutter to a running flutter application with enabled observatory
alias flattach="flutter attach"

# Build flutter application
alias flb="flutter build"

# Switches flutter channel (requires input of desired channel)
alias flchnl="flutter channel"

# Cleans flutter project
alias flc="flutter clean"

# List connected devices (if any)
alias fldvcs="flutter devices"

# Runs flutter doctor
alias fldoc="flutter doctor"

# Shorthand for flutter pub command
alias flpub="flutter pub"

# Installs dependencies
alias flget="flutter pub get"

# Runs flutter app
alias flr="flutter run"

# Runs flutter app in debug mode (default mode)
alias flrd="flutter run --debug"

# Runs flutter app in profile mode
alias flrp="flutter run --profile"

# Runs flutter app in release mode
alias flrr="flutter run --release"

# Upgrades flutter version depending on the current channel
alias flupgrd="flutter upgrade"
