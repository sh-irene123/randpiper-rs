killall -9 node-bft
echo "Hello"
timeout 600 ./randpiper-rs/target/release/node-bft -c ./randpiper-rs/test/d100-n3/nodes-$1.dat -d 280 -i ./randpiper-rs/ips_file > output.log
