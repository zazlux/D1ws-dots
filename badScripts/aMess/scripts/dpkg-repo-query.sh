#!/usr/bin/env bash

# ------------------------------------------------------------------
# Script Name:   dpkg-repo-query.sh
# Description:   Checks the availability of a package in official 
#                Debian and Ubuntu repositories via their websites.
# Website:       https://gist.github.com/ostechnix
# Version:       1.0
# Usage:         chmod +x dpkg-repo-query.sh
#                ./dpkg-repo-query.sh
# ------------------------------------------------------------------

# Function to print table header
print_header() {
    echo "+----------------+----------------+----------------+----------------+"
    echo "| Package Name   | Distribution   | Version        | Status         |"
    echo "+----------------+----------------+----------------+----------------+"
}

# Map Ubuntu and Debian version numbers to codenames
declare -A ubuntu_versions
declare -A debian_versions

ubuntu_versions=( ["23.10"]="mantic" ["23.04"]="lunar" ["22.04"]="jammy" ["20.04"]="focal" ["18.04"]="bionic" ["16.04"]="xenial" ["14.04"]="trusty" )
debian_versions=( ["12"]="bookworm" ["11"]="bullseye" ["10"]="buster" ["9"]="stretch" ["8"]="jessie" ["7"]="wheezy" ["6"]="squeeze" )

# Prompt for package name, distribution, and version
read -p "Enter the package name: " pkg_name
read -p "Enter the distribution (debian/ubuntu): " dist
read -p "Enter the distribution version (e.g., buster, jammy, 22.04, 11, etc.): " dist_version

# Convert version numbers to codenames for Ubuntu and Debian
if [[ "$dist" == "ubuntu" && ${ubuntu_versions[$dist_version]} ]]; then
    dist_version=${ubuntu_versions[$dist_version]}
elif [[ "$dist" == "debian" && ${debian_versions[$dist_version]} ]]; then
    dist_version=${debian_versions[$dist_version]}
fi

print_header

# Check Debian or Ubuntu repositories
if [[ "$dist" == "debian" ]]; then
    url="https://packages.debian.org/$dist_version/$pkg_name"
    result=$(curl -s $url | grep "Package: $pkg_name")
elif [[ "$dist" == "ubuntu" ]]; then
    url="https://packages.ubuntu.com/search?keywords=$pkg_name&searchon=names&suite=$dist_version&section=all"
    result=$(curl -s $url | grep -E "Package $pkg_name(<| )")
else
    echo "Invalid distribution. Please choose either 'debian' or 'ubuntu'."
    exit 1
fi

if [[ -n "$result" ]]; then
    status="Available"
else
    status="Not Available"
fi

printf "| %-14s | %-14s | %-14s | %-14s |\n" "$pkg_name" "$dist" "$dist_version" "$status"
echo "+----------------+----------------+----------------+----------------+"