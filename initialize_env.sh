#!bin/bash

# Replace the values in the .env file
l1_rpc="$(kurtosis port print op-cdk el-1-geth-lighthouse rpc)"
l1_beacon_rpc="$(kurtosis port print op-cdk cl-1-lighthouse-geth http)"
l2_rpc="$(kurtosis port print op-cdk op-el-1-op-geth-op-node-op-kurtosis rpc)"
l2_node_rpc="$(kurtosis port print op-cdk op-cl-1-op-node-op-geth-op-kurtosis http)"

# Fund admin address of L1 in L2 as well
cast send 0x8943545177806ED17B9F23F0a21ee5948eCaa776  --rpc-url $l2_rpc --value 1ether --private-key ac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

sed -i "s|^L1_RPC=\".*\"$|L1_RPC=\"http://$l1_rpc\"|" .env
sed -i "s|^L1_BEACON_RPC=\".*\"$|L1_BEACON_RPC=\"$l1_beacon_rpc\"|" .env
sed -i "s|^L2_RPC=".*"$|L2_RPC=\"$l2_rpc\"|" .env
sed -i "s|^L2_NODE_RPC=".*"$|L2_NODE_RPC=\"$l2_node_rpc\"|" .env

just deploy-mock-verifier

just deploy-oracle

# Clean up after contract deployment
sed -i 's|^L1_RPC=".*"$|L1_RPC=""|' .env
sed -i 's|^L1_BEACON_RPC=".*"$|L1_BEACON_RPC=""|' .env
sed -i 's|^L2_RPC=".*"$|L2_RPC=""|' .env
sed -i 's|^L2_NODE_RPC=".*"$|L2_NODE_RPC=""|' .env