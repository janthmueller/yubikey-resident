#!/bin/bash
set -e

echo "Starting interactive ssh-keygen for ed25519-sk key creation."
echo "Press enter to accept defaults if desired."

# Set default filename
DEFAULT_FILENAME="/root/.ssh/id_ed25519_sk"

# Prompt for comment (optional; if left empty, no -C flag will be used)
read -p "Enter comment (optional, leave empty for none): " COMMENT

# Show existing FIDO credentials before asking for a UID
echo "Current FIDO credentials:"
ykman fido credentials list || echo "No credentials found"

# Prompt for UID (optional)
read -p "Enter UID for resident key (optional, default: none): " KEY_UID

# Determine the filename: if a UID is provided, append it to the default filename.
if [ -n "$KEY_UID" ]; then
    FILENAME="${DEFAULT_FILENAME}_${KEY_UID}"
else
    FILENAME="$DEFAULT_FILENAME"
fi

# Construct the ssh-keygen command with the -f option to set the file location,
# no passphrase, and the resident key options.
CMD="ssh-keygen -t ed25519-sk -f \"$FILENAME\" -N \"\" -O resident -O verify-required"

# Append the comment flag only if COMMENT is non-empty
if [ -n "$COMMENT" ]; then
    CMD="$CMD -C \"$COMMENT\""
fi

# Append the UID option if provided
if [ -n "$KEY_UID" ]; then
    CMD="$CMD -O application=ssh:$KEY_UID"
fi

echo "Generating key with command:"
echo "$CMD"

# Execute the command interactively
eval $CMD

echo "Key generation complete."

# Ask if the user wants to exit. If not, drop to an interactive shell.
read -p "Do you want to exit? [y/n]: " EXIT_CHOICE
if [[ "$EXIT_CHOICE" =~ ^[Yy]$ ]]; then
    exit 0
fi

exec bash