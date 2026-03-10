set shell := ["nu", "-c"]

# Install (create/update symlinks)
in:
    ./nu/dot in

# Create a new Nushell script in nu/
nu name:
    cp assets/script.nu nu/{{name}}
    chmod +x nu/{{name}}
