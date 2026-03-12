set shell := ["nu", "-c"]

# Install (create/update symlinks)
in:
    ./install

# Create a new Nushell script in nu/
nu name:
    cp assets/script.nu nu/{{name}}
    chmod +x nu/{{name}}
