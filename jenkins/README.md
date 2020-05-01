# Installation

```
sudo apt update
sudo apt upgrade
```

Install java
```
sudo apt install openjdk-11-jre
```

Add Jenkins repository
```
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
```

add the repository into our sources list.
```
sudo nano /etc/apt/sources.list.d/jenkins.list
```
add the link
```
deb https://pkg.jenkins.io/debian binary/
```
Install
```
sudo apt update
sudo apt install jenkins
```
Get the admin password
```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
Open the web browser
```
[JenkinsIP]:8080
```

# Use

Jenkins service

```
sudo systemctl status jenkins
sudo systemctl start jenkins
sudo systemctl stop jenkins
sudo systemctl disable jenkins
sudo systemctl enable jenkins
```

# Use ngrok

In order to access to Jenkins server we use ngrok o something similar:
https://ngrok.com/download

```
unzip /path/to/ngrok.zip
./ngrok authtoken <YOUR_AUTH_TOKEN>
./ngrok http 8080
```

#GitHub weebhook

```
http://dddd.ngrok.io/github-webhook
```
