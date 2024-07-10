# Source this file.
#
# Detects any changed Cargo manifests.

detect_changed_manifests() {
  local changed_manifests=()
  local all_manifests=$(find . -name "Cargo.toml" -not -path "*/target/*")

  for file in $all_manifests; do
    # Get the current version from the Cargo.toml.
    local current_version=$(grep '^version\s*=' "$file" | awk -F'\"' '{print $2}')

    # Get the previous version from the last committed Cargo.toml.
    local previous_version=$(git show HEAD~1:"$file" | grep '^version\s*=' | awk -F'\"' '{print $2}')

    # Compare the versions and add the path to the list if they are different.
    if [ "$current_version" != "$previous_version" ]; then
      changed_manifests+=("$file")
    fi
  done

  echo "${changed_manifests[@]}"
}