# Auto-Upgrade Method for Full-Module Source Deployment

This tutorial is for enthusiasts running the full-module source deployment. It shows how to use automated commands to pull the source code, compile, and start the services on their ports, giving the most efficient way to upgrade the system.

This project's test platform `https://2662r3426b.vicp.fun` has used this method since it opened, with good results.

You can also refer to the video tutorial by the Bilibili creator `毕乐labs` (Bile Labs): ["Open-source Xiaozhi server xiaozhi-server auto-update and latest MCP endpoint configuration, step-by-step tutorial"](https://www.bilibili.com/video/BV15H37zHE7Q) (in Chinese)

# Prerequisites
- Your computer/server runs Linux
- You have already got the whole process running
- You like to follow the latest features, but find manual deployment each time a bit tedious, and want an automatic update method

The second condition is required, because some files in this tutorial, the JDK, the Node.js environment, the Conda environment, and so on, only exist after you have got the whole process running. If you have not, you may not understand what a file is when I mention it.

# What this tutorial achieves
- Solves the problem that the latest project source code cannot be pulled from within China
- Automatically pulls the code and compiles the frontend files
- Automatically pulls the code and compiles the Java files, kills the process on port 8002, and starts it again on port 8002
- Automatically pulls the Python code, kills the process on port 8000, and starts it again on port 8000

# Step 1: Choose your project directory

For example, my planned project directory is the following. It is a newly created empty directory; if you want to avoid mistakes, use the same one as I do
```
/home/system/xiaozhi
```

# Step 2: Clone this project
First run the following commands to pull the source code. They work for servers and computers on a network inside China, with no VPN needed

```
cd /home/system/xiaozhi
git clone https://ghproxy.net/https://github.com/xinnan-tech/xiaozhi-esp32-server.git
```

After it finishes, your project directory has a new folder `xiaozhi-esp32-server`, which is the project source code

# Step 3: Copy the base files

If you have already got the whole process running, you will be familiar with the funasr model file `xiaozhi-server/models/SenseVoiceSmall/model.pt` and your private config file `xiaozhi-server/data/.config.yaml`.

Now you need to copy the `model.pt` file to the new directory. You can do it like this
```
# Create the required directory
mkdir -p /home/system/xiaozhi/xiaozhi-esp32-server/main/xiaozhi-server/data/

cp full-path-of-your-original-.config.yaml /home/system/xiaozhi/xiaozhi-esp32-server/main/xiaozhi-server/data/.config.yaml
cp full-path-of-your-original-model.pt /home/system/xiaozhi/xiaozhi-esp32-server/main/xiaozhi-server/models/SenseVoiceSmall/model.pt
```

# Step 4: Create three auto-build scripts

## 4.1 Auto-build the manager-web module
In the `/home/system/xiaozhi/` directory, create a file named `update_8001.sh` with the following content

```
cd /home/system/xiaozhi/xiaozhi-esp32-server
git fetch --all
git reset --hard
git pull origin main


cd /home/system/xiaozhi/xiaozhi-esp32-server/main/manager-web
npm install
npm run build
rm -rf /home/system/xiaozhi/manager-web
mv /home/system/xiaozhi/xiaozhi-esp32-server/main/manager-web/dist /home/system/xiaozhi/manager-web
```

After saving, run the permission command
```
chmod 777 update_8001.sh
```
After it finishes, continue

## 4.2 Auto-build and run the manager-api module
In the `/home/system/xiaozhi/` directory, create a file named `update_8002.sh` with the following content

```
cd /home/system/xiaozhi/xiaozhi-esp32-server
git pull origin main


cd /home/system/xiaozhi/xiaozhi-esp32-server/main/manager-api
rm -rf target
mvn clean package -Dmaven.test.skip=true
cd /home/system/xiaozhi/

# Find the PID of the process using port 8002
PID=$(sudo netstat -tulnp | grep 8002 | awk '{print $7}' | cut -d'/' -f1)

rm -rf /home/system/xiaozhi/xiaozhi-esp32-api.jar
mv /home/system/xiaozhi/xiaozhi-esp32-server/main/manager-api/target/xiaozhi-esp32-api.jar /home/system/xiaozhi/xiaozhi-esp32-api.jar

# Check whether a PID was found
if [ -z "$PID" ]; then
  echo "No process found using port 8002"
else
  echo "Found a process using port 8002, PID: $PID"
  # Kill the process
  kill -9 $PID
  kill -9 $PID
  echo "Killed process $PID"
fi

nohup java -jar xiaozhi-esp32-api.jar --spring.profiles.active=dev &

tail -f nohup.out
```

After saving, run the permission command
```
chmod 777 update_8002.sh
```
After it finishes, continue

## 4.3 Auto-build and run the Python project
In the `/home/system/xiaozhi/` directory, create a file named `update_8000.sh` with the following content

```
cd /home/system/xiaozhi/xiaozhi-esp32-server
git pull origin main

# Find the PID of the process using port 8000
PID=$(sudo netstat -tulnp | grep 8000 | awk '{print $7}' | cut -d'/' -f1)

# Check whether a PID was found
if [ -z "$PID" ]; then
  echo "No process found using port 8000"
else
  echo "Found a process using port 8000, PID: $PID"
  # Kill the process
  kill -9 $PID
  kill -9 $PID
  echo "Killed process $PID"
fi
cd main/xiaozhi-server
# Initialize the conda environment
source ~/.bashrc
conda activate xiaozhi-esp32-server
pip install -r requirements.txt
nohup python app.py >/dev/null &
tail -f /home/system/xiaozhi/xiaozhi-esp32-server/main/xiaozhi-server/tmp/server.log
```

After saving, run the permission command
```
chmod 777 update_8000.sh
```
After it finishes, continue

# Daily updates

Once all the scripts above are created, for daily updates just run the following commands in order to update and start automatically

```
cd /home/system/xiaozhi
# Update and start the Java program
./update_8001.sh
# Update the web program
./update_8002.sh
# Update and start the Python program
./update_8000.sh


# To view the Java log later, run the following command
tail -f nohup.out
# To view the Python log later, run the following command
tail -f /home/system/xiaozhi/xiaozhi-esp32-server/main/xiaozhi-server/tmp/server.log
```

# Notes
The test platform `https://2662r3426b.vicp.fun` uses nginx as a reverse proxy. For the detailed nginx.conf configuration, [see here](https://github.com/xinnan-tech/xiaozhi-esp32-server/issues/791)

## FAQ

### 1. Why don't I see port 8001?
Answer: 8001 is used in the development environment to run the frontend. If you deploy on a server, we do not recommend starting the frontend on port 8001 with `npm run serve`. Instead, compile it into HTML files as in this tutorial, and then use nginx to manage access.

### 2. Do I need to run SQL statements manually on every update?
Answer: No. The project uses **Liquibase** to manage database versions, which runs new SQL scripts automatically.