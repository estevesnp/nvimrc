#!/usr/bin/env bash

# This script prepares bundles for JDTLS
# Check https://github.com/mfussenegger/nvim-jdtls?tab=readme-ov-file#debugger-via-nvim-dap for details

set -euo pipefail

MIN_JAVA_VERSION=21
JAVA_BIN=$JAVA_HOME/bin/java

version_output="$("$JAVA_BIN" -version 2>&1)"

if [[ "$version_output" =~ [[:alnum:]]+[[:space:]]version[[:space:]]\"([0-9]+) ]]; then
    major="${BASH_REMATCH[1]}"
else
    echo "Couldn't parse version: $version_output"
    exit 1
fi

if (( major < MIN_JAVA_VERSION )); then
    echo "Java version $major is not compatible. Make sure JAVA_HOME points to a version >= $MIN_JAVA_VERSION"
    exit 1
fi

jdtls_config="${JDTLS_CONFIG:-$HOME/.jdtls}"

mkdir -p "$jdtls_config"
cd "$jdtls_config"

if [ ! -d java-debug ]; then
    git clone --depth 1 https://github.com/microsoft/java-debug.git
fi
cd java-debug

echo 'installing java-debug...'
./mvnw clean install

cd ..

if [ ! -d vscode-java-test ]; then
    git clone --depth 1 https://github.com/microsoft/vscode-java-test.git
fi
cd vscode-java-test

echo 'installing vscode-java-test...'
npm install
npm run build-plugin

echo
echo 'successfully prepared jdtls bundles!'
