#!/bin/bash

NOTES_FOLDER="/path/to/markdown/folder"

find "$NOTES_FOLDER" -name "*.md" | while read file; do
    # Convert Markdown to plain text
    TEXT=$(pandoc "$file" -t plain)

    # Replace newlines with '\n' for AppleScript
    TEXT_FOR_APPLESCRIPT=$(echo "$TEXT" | awk '{printf "%s\\n", $0}')
    osascript <<EOF
tell application "Notes"
    tell account "iCloud"
        tell folder "Notes"
            make new note with properties {name:"$(basename "$file" .md)", body:"$TEXT_FOR_APPLESCRIPT"}
        end tell
    end tell
end application
EOF
done
