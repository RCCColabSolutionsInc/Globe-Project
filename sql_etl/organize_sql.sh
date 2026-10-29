#!/bin/bash

# Script to organize SQL object files into a structured directory hierarchy.
# Usage: ./organize_sql.sh

# Function to organize a single directory
organize_dir() {
    local dir="$1"
    echo "Processing: $dir"

    # Move Tables
    if ls "$dir"/*.Table.sql >/dev/null 2>&1; then
        mkdir -p "$dir/tables"
        mv "$dir"/*.Table.sql "$dir/tables/"
    fi

    # Move Views
    if ls "$dir"/*.View.sql >/dev/null 2>&1; then
        mkdir -p "$dir/views"
        mv "$dir"/*.View.sql "$dir/views/"
    fi

    # Move Stored Procedures
    if ls "$dir"/*.StoredProcedure.sql >/dev/null 2>&1; then
        mkdir -p "$dir/programmability/stored_procedures"
        mv "$dir"/*.StoredProcedure.sql "$dir/programmability/stored_procedures/"
    fi

    # Move Functions
    if ls "$dir"/*.UserDefinedFunction.sql >/dev/null 2>&1 || ls "$dir"/*.Function.sql >/dev/null 2>&1; then
        mkdir -p "$dir/programmability/functions"
        { mv "$dir"/*.UserDefinedFunction.sql "$dir/programmability/functions/" 2>/dev/null || true; }
        { mv "$dir"/*.Function.sql "$dir/programmability/functions/" 2>/dev/null || true; }
    fi

    # Move Triggers
    if ls "$dir"/*.DdlTrigger.sql >/dev/null 2>&1 || ls "$dir"/*.Trigger.sql >/dev/null 2>&1; then
        mkdir -p "$dir/programmability/triggers"
        { mv "$dir"/*.DdlTrigger.sql "$dir/programmability/triggers/" 2>/dev/null || true; }
        { mv "$dir"/*.Trigger.sql "$dir/programmability/triggers/" 2>/dev/null || true; }
    fi
}

# Main loop: Find all top-level directories (excluding hidden ones)
for d in */; do
    # Remove trailing slash
    d=${d%/}
    
    # Skip hidden directories
    [[ "$d" == .* ]] && continue

    organize_dir "$d"
done

echo "Organization complete."
