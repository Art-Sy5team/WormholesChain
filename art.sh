#!/bin/bash

# Function to retrieve the block height and number of node connections
function get_info() {
  # Define the localhost IP and port number
  localhost="127.0.0.1:$1"

  # Define the endpoint URL for the whole network
  endpoint="https://api.wormholestest.com"

  # Define the JSON-RPC method for retrieving the block height
  method_block_height="eth_blockNumber"

  # Define the JSON-RPC method for retrieving the number of node connections
  method_peer_count="net_peerCount"

  # Counter for counting the number of seconds passed
  cn=0

  # Loop to continuously retrieve and display the information
  while true; do
    # Print the number of seconds that have passed
    echo "$cn seconds have passed."

    # Retrieve the block height of the whole network
    whole_network_block_height=$(get_block_height $endpoint $method_block_height)

    # Print the block height of the whole network
    echo "Block height of the whole network: $whole_network_block_height"

    # Retrieve the number of node connections
    peer_count=$(get_peer_count $localhost $method_peer_count)

    # Print the number of node connections
    echo "Number of node connections: $peer_count"

    # Retrieve the block height of the current peer
    current_peer_block_height=$(get_block_height $localhost $method_block_height)

    # Print the block height of the current peer
    echo "Block height of the current peer: $current_peer_block_height"

    # Wait for 5 seconds before retrieving the information again
    sleep 5

    # Clear the terminal
    clear

    # Increment the counter
    cn=$((cn + 5))
  done
}

# Function to retrieve the block height using the specified endpoint and method
function get_block_height() {
  # Define the JSON-RPC request data
  data='{"jsonrpc":"2.0","method":"'$2'","id":64}'

  # Retrieve the JSON-RPC response
  response=$(curl -H "Content-Type: application/json" --data "$data" $1 2>/dev/null)

  # Parse the JSON-RPC response to get the block height
  parse_json "$response" "result"
}

# Function to retrieve the number of node connections using the specified endpoint and method
function get_peer_count() {
  # Define the JSON-RPC request data
  data='{"jsonrpc":"2.0","method":"'$2'","id":64}'

  # Retrieve the JSON-RPC response
  response=$(curl -H "Content-Type: application/json" --data "$data" $1 2>/dev/null)

  # Parse the JSON-RPC response to get the number of node connections
  parse_json "$response" "result"
}

# Function to parse the JSON-RPC response to get the desired value
function parse_json
