#!/bin/bash
yum install nano net-tools perl ntp wget -y
yum install java-1.8.0-openjdk.x86_64 java-1.8.0-openjdk-devel.x86_64 -y
cat <<EOT >> ~/.bash_profile
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.141-1.b16.el7_3.x86_64/jre/
export PATH=$JAVA_HOME/bin:$PATH
EOT
source ~/.bash_profile
groupadd tomcat
useradd -s /bin/false -g tomcat  -d /opt/tomcat tomcat
wget http://www-eu.apache.org/dist/tomcat/tomcat-8/v8.5.16/bin/apache-tomcat-8.5.16.tar.gz
tar xvf apache-tomcat-8.5.16.tar.gz
rm -rf /opt/tomcat/
mv apache-tomcat-8.5.16 /opt/tomcat
chown -hR tomcat:tomcat /opt/tomcat
cat <<EOT >> /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat 8 Servlet Container
After=syslog.target network.target

[Service]
User=tomcat
Group=tomcat
Type=forking
Environment=CATALINA_PID=/opt/tomcat/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOT
systemctl daemon-reload
systemctl start tomcat
systemctl enable tomcat
