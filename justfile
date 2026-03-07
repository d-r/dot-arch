set shell := ["nu", "-c"]

# Install (create/update symlinks)
in:
    ./bin/dot link

# Create a new Nushell script in bin/
bin name:
    cp assets/script.nu bin/{{name}}
    chmod +x bin/{{name}}
