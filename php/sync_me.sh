#!/bin/bash

# Source the .env file to load environment variables
if [ -f .env ]; then
    source .env
fi

echo "Starting Installation"
echo "======================="
echo "Setting necessary permissions for Private Key"

# Ensure that the SSH private key exists
if [ ! -f "/root/.ssh/id_rsa" ]; then
    echo "Error: SSH private key not found."
    exit 1
fi

# Set permissions for the private key
chmod 400 /root/.ssh/id_rsa

# Check if the host key already exists in known_hosts
if ! ssh-keygen -F "${REPOSITORY_HOST}" >/dev/null 2>&1; then
    echo "Adding host to known hosts"
    # Add host to known_hosts if it doesn't already exist
    ssh-keyscan "${REPOSITORY_HOST}" >> /root/.ssh/known_hosts
fi

# Initialize Git if not already initialized
if [ ! -d .git ]; then
    echo "Initializing Git repository"
    git init
    git config --global init.defaultBranch main
    git branch -m "${REPOSITORY_BRANCH}"

    git config --global user.email "server@${VIRTUAL_HOST}"
    git config --global user.name "${VIRTUAL_HOST}"
    git config --global --add safe.directory "${VIRTUAL_HOST}"
fi

git config --global pull.rebase true

# Check if origin doesn't exist before adding
if ! git remote get-url origin >/dev/null 2>&1; then
    echo "Adding Git remote origin"
    git remote add origin "${REPOSITORY_URL}"
fi

# Pull from the remote repository
echo "Pulling from remote repository"
git pull origin "${REPOSITORY_BRANCH}"

# Create assets directory if it doesn't exist
echo "Creating assets directory"
mkdir -p "${APP_DIRECTORY}/assets"
chmod 0777 -R "${APP_DIRECTORY}/assets"

# Set ownership for application directory
echo "Setting ownership for application directory"
chown -R www-data:www-data "${APP_DIRECTORY}"

echo "Installation complete"
composer install \
    --ignore-platform-reqs \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --prefer-dist
composer vendor-expose
# Exit with success status code
exit 0
