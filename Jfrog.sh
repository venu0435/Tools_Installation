##Install in Amazon Ubuntu
sudo usermod -aG docker $USER
docker pull docker.bintray.io/jfrog/artifactory-oss:latest
sudo mkdir -p /jfrog/artifactory
sudo chown -R 1030 /jfrog/
docker run --name artifactory -d -p 8081:8081 -p 8082:8082 -v /jfrog/artifactory:/var/opt/jfrog/artifactory docker.bintray.io/jfrog/artifactory-oss:latest
##Run Artifactory as a service
sudo vi /etc/systemd/system/artifactory.service
##Copy the below code
[Unit]
Description=Setup Systemd script for Artifactory Container
After=network.target
[Service]
Restart=always
ExecStartPre=-/usr/bin/docker kill artifactory
ExecStartPre=-/usr/bin/docker rm artifactory
ExecStart=/usr/bin/docker run --name artifactory -p 8081:8081 -p 8082:8082 \
  -v /jfrog/artifactory:/var/opt/jfrog/artifactory \
  docker.bintray.io/jfrog/artifactory-oss:latest
ExecStop=-/usr/bin/docker kill artifactory
ExecStop=-/usr/bin/docker rm artifactory
[Install]
WantedBy=multi-user.target



#Reload Systemd
sudo systemctl daemon-reload
#Then start Artifactory container with systemd.
sudo systemctl start artifactory
#Enable it to start at system boot.
sudo systemctl enable artifactory
#Check whether Artifactory Service is running
sudo systemctl status artifactory
