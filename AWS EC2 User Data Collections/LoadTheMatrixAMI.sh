#!/bin/bash

# Install and start Apache
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# Get Availability Zone (IMDSv2)
EC2AZ=$(TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600") && curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)

aws s3 cp s3://farzins-single-replica-bucket-of-truth/TheMatrix2.html /var/www/html/index.html

# Inject real AZ
sed -i "s|AZ_PLACEHOLDER|$EC2AZ|g" /var/www/html/index.html

# Permissions
chmod 644 /var/www/html/index.html
chown apache:apache /var/www/html/index.html

# Restart Apache
systemctl restart httpd