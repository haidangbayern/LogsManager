#!/bin/bash

### Script to install frameworks ###

# Any subsequent(*) commands which fail will cause the shell script to exit immediately
set -e

declare -a tests_frameworks=("github \"Quick\/Nimble\"" "github \"Quick\/Quick\"" "github \"uber\/ios-snapshot-test-case\"" "github \"ashfurrow\/Nimble-Snapshots\"")

disableTestsFramework() {
    previous_cartfile=`cat "Cartfile.resolved"`
    for i in "${tests_frameworks[@]}"; do
        sed -i '' "/$i/d" "Cartfile.resolved"
    done
    trap "enableTestsFramework" ERR
    trap "enableTestsFramework" INT
}

enableTestsFramework() {
    echo "$previous_cartfile" > "Cartfile.resolved"
    trap '' ERR
    trap '' INT
}

# Assume scripts are placed in /Scripts/Carthage dir
base_dir=$(dirname "$0")
cd "$base_dir"

# includes
. ./utils.sh

cd ..
cd ..

applyXcode12Workaround

# Try one level up if didn't find Cartfile.
if [ ! -f "Cartfile" ]; then
    cd ..

    if [ ! -f "Cartfile" ]; then
        printf >&2 "\n${red_color}Unable to locate 'Cartfile'${no_color}\n\n"
        exit 1
    fi
fi

mkdir -p "Carthage"
touch "Carthage/cartSum.txt"
if [ ! -f "Carthage/cartSum.txt" ]; then
    prevSum="null";
else
    prevSum=`cat Carthage/cartSum.txt`;
fi

# Get checksum
cartSum=`{ cat Cartfile.resolved; xcrun swift -version; } | md5`

if [ "$prevSum" != "$cartSum" ] || [ ! -d "Carthage/Build/iOS" ]; then
    echo "Carthage frameworks are outdated. Updating..."
    rm "$cart_sum_file" || :

    # Install main app frameworks. Ignore tests frameworks.
    disableTestsFramework
    carthage bootstrap --use-xcframeworks --platform iOS --cache-builds
    enableTestsFramework
    echo ""

    # Update checksum file
    cartSum=`{ cat Cartfile.resolved; xcrun swift -version; } | md5`
    echo $cartSum > Carthage/cartSum.txt
else
    echo "Carthage frameworks up to date"
fi
