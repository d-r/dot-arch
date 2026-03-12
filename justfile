set shell := ["nu", "-c"]

# Install (create/update symlinks)
in:
    ./install

# Create a new Nushell script in bin/
bin name:
    cp assets/script.nu bin/{{name}}
    chmod +x bin/{{name}}
