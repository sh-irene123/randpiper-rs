# Do the setup on the AWS Server

FILE="${1:-/dev/stdin}"
PVT_IP_FILE="scripts/aws/pvt_ips.log"
IPS_FILE=${2:-"scripts/aws/ips_file.log"}
CLI_IPS_FILE=${3:-"scripts/aws/cli_ips.log"}
IPS=()

# Create Private IP files
#bash scripts/aws/get_pvt_ips.sh < $FILE \
#> $PVT_IP_FILE

# Create IP files
bash scripts/aws/make_ip_files.sh $PVT_IP_FILE $IPS_FILE $CLI_IPS_FILE

while IFS= read -r line; do
  IPS+=($line)
done < $FILE

for ip in "${IPS[@]}"
do
    echo $ip
    ssh -i /Users/ireneisaac/node.pem ubuntu@$ip 'bash -ls' < /Users/ireneisaac/randpiper-rs/scripts/aws/setup.sh &
done

wait

for ip in "${IPS[@]}"
do
  ssh -i /Users/ireneisaac/node.pem ubuntu@$ip "cd randpiper-rs; cat > ips_file" < $IPS_FILE
  ssh -i /Users/ireneisaac/node.pem ubuntu@$ip "cd randpiper-rs; cat > cli_ip_file" < $CLI_IPS_FILE
done
