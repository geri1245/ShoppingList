#!/bin/bash

# From https://stackoverflow.com/a/246128
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

/home/geri/.cargo/bin/cargo build --release || exit 1

mkdir resources
sudo cp ../target/release/shopping_list_backend ./resources/server || exit 1

sudo docker build --tag shopping_list_backend . || exit 1