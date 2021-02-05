# Script that shows a welcome message and prints system info for user
# Licensed under MIT, (C) Alicia Sykes 2021: https://aliciasykes.com


# Make nice welcome message, with a first-letter capitalized username
WELCOME_MSG="Welcome $(echo "$USER" | sed 's/.*/\u&/') !"

# Print welcome message, using figlet & lolcat if availible
if hash lolcat 2>/dev/null && hash figlet 2>/dev/null; then
  echo "${WELCOME_MSG}" | figlet | lolcat
else
  echo "${WELCOME_MSG}"
fi

# Print system information with neofetch, if it's installed
if hash neofetch 2>/dev/null; then
  neofetch --shell_version off \
    --disable shell resolution de wm wm_theme theme icons terminal \
    --backend off \
    --colors 4 8 4 4 8 6 \
    --color_blocks off \
    --memory_display info
fi

# EOF
