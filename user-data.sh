#!/bin/bash
set -e

apt-get update -y
apt-get install -y nginx

# Get IMDSv2 token
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
-H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Fetch metadata
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s \
http://169.254.169.254/latest/meta-data/instance-id)

AZ=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s \
http://169.254.169.254/latest/meta-data/placement/availability-zone)

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
<title>Hello World</title>
</head>

<body style="text-align:center;font-family:Arial;margin-top:100px;">
<h1>Hello World!</h1>
<p>Instance ID: <strong>$INSTANCE_ID</strong></p>
<p>Availability Zone: <strong>$AZ</strong></p>
<p>Served by: <strong>Nginx</strong></p>
</body>
</html>
EOF

systemctl enable nginx
systemctl restart nginx
