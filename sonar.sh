#!/bin/bash
## Downloading SonarQube 
VER=$(curl -s https://binaries.sonarsource.com/Distribution/sonarqube/  | tail -n 10 | awk -F '[<,>]' '{print $5}' | grep zip$ |tail -1)
URL="https://binaries.sonarsource.com/Distribution/sonarqube//$VER"
TFILE="/opt/$VER"
TDIR=$(echo $TFILE|sed -e 's/.zip//')
rm -rf /opt/sonarqube
wget $URL -O $TFILE &>/dev/null
cd /opt
unzip $VER &>/dev/null
mv $TDIR sonarqube 
if [ $? -eq 0 ]; then
	success "Successfully Downloaded and Extracted SonarQube"
else
	error "Error in Downlading and Extracting SonarQube"
	exit 1
fi

## Configure SonarQube
sed -i -e '/^sonar.jdbc.username/ d' -e '/^sonar.jdbc.password/ d' -e '/^sonar.jdbc.url/ d' -e '/^sonar.web.host/ d' -e '/^sonar.web.port/ d' /opt/sonarqube/conf/sonar.properties
sed -i -e '/#sonar.jdbc.username/ a sonar.jdbc.username=sonarqube' -e '/#sonar.jdbc.password/ a sonar.jdbc.password=password' -e '/InnoDB/ a sonar.jdbc.url=jdbc:mysql://localhost:3306/sonarqube?useUnicode=true&amp;characterEncoding=utf8&amp;rewriteBatchedStatements=true&amp;useConfigs=maxPerformance' -e '/#sonar.web.host/ a sonar.web.host=0.0.0.0' /opt/sonarqube/conf/sonar.properties

useradd sonar
chown sonar:sonar /opt/sonarqube -R
sed -i -e '/^#RUN_AS_USER/ c RUN_AS_USER=sonar' /opt/sonarqube/bin/linux-x86-64/sonar.sh
ln -s /opt/sonarqube/bin/linux-x86-64/sonar.sh /etc/init.d/sonar
systemctl enable sonar &>/dev/null 
systemctl start sonar &>/dev/null
if [ $? -eq 0 ]; then
	success "Configured and Started SonarQube Successfully"
else
	error "SonarQube Startup Failed"
	exit 1
fi
