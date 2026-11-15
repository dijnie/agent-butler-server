# Voiceprint Recognition Setup Guide

This tutorial has 3 parts
- 1. How to deploy the voiceprint recognition service
- 2. How to configure the voiceprint recognition API in a full-module deployment
- 3. How to configure voiceprint recognition in a minimal deployment

# 1. How to Deploy the Voiceprint Recognition Service

## Step 1: Download the voiceprint recognition project source

Open the [voiceprint recognition project](https://github.com/xinnan-tech/voiceprint-api) in a browser.

On the page, find the green `Code` button, click it, and you will see the `Download ZIP` button.

Click it to download the project source archive. After it is downloaded to your computer, extract it. The folder may be named `voiceprint-api-main`,
and you need to rename it to `voiceprint-api`.

## Step 2: Confirm that MySQL is reachable

Voiceprint recognition depends on a `mysql` database. If you have already deployed the `control console`, `mysql` is already installed and you can share it.

On the host machine, try the `telnet` command to see whether the `mysql` `3306` port is reachable.
```
telnet 127.0.0.1 3306
```
If port 3306 is reachable, skip the rest of this step and go straight to Step 3.

If it is not reachable, recall how your `mysql` was installed.

If you installed mysql yourself from an installation package, your `mysql` is network-isolated. You may need to solve the problem of reaching the `mysql` `3306` port first.

If your `mysql` was installed through this project's `docker-compose_all.yml`, find the `docker-compose_all.yml` file you used to create the database and change the following

Before
```
  xiaozhi-esp32-server-db:
    ...
    networks:
      - default
    expose:
      - 3306
```

After
```
  xiaozhi-esp32-server-db:
    ...
    networks:
      - default
    ports:
      - "3306:3306"
```

Note that you change `expose` to `ports` under `xiaozhi-esp32-server-db`. After the change, restart it. The commands to restart mysql are:

```
# Go to the folder that contains your docker-compose_all.yml, for example mine is xiaozhi-server
cd xiaozhi-server
docker compose -f docker-compose_all.yml down
docker compose -f docker-compose_all.yml up -d
```
The database service `xiaozhi-esp32-server-db` is in `docker-compose_all.yml`. The minimal `docker-compose.yml` contains only the server itself, so both commands use `docker-compose_all.yml`.

After it starts, use the `telnet` command on the host machine again to check whether the `mysql` `3306` port is reachable.
```
telnet 127.0.0.1 3306
```
Normally it is reachable now.

## Step 3: Create the database and table
If your host machine can reach the mysql database, create a database named `voiceprint_db` and a `voiceprints` table in mysql.

```
CREATE DATABASE voiceprint_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE voiceprint_db;

CREATE TABLE voiceprints (
    id INT AUTO_INCREMENT PRIMARY KEY,
    speaker_id VARCHAR(255) NOT NULL UNIQUE,
    feature_vector LONGBLOB NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_speaker_id (speaker_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

## Step 4: Configure the database connection

Go into the `voiceprint-api` folder and create a folder named `data`.

Copy `voiceprint.yaml` from the `voiceprint-api` root directory into the `data` folder and rename it to `.voiceprint.yaml`.

Next, configure the database connection in `.voiceprint.yaml` carefully.

```
mysql:
  host: "127.0.0.1"
  port: 3306
  user: "root"
  password: "your_password"
  database: "voiceprint_db"
```

Note! Because your voiceprint recognition service is deployed with docker, `host` must be the `LAN IP of the machine where mysql runs`.

Note! Because your voiceprint recognition service is deployed with docker, `host` must be the `LAN IP of the machine where mysql runs`.

Note! Because your voiceprint recognition service is deployed with docker, `host` must be the `LAN IP of the machine where mysql runs`.

## Step 5: Start the program
This is a very simple project and running it with docker is recommended. If you do not want to use docker, see [this page](https://github.com/xinnan-tech/voiceprint-api/blob/main/README.md) to run from source. Here is how to run it with docker

```
# Go to the project source root directory
cd voiceprint-api

# Clear the cache
docker compose -f docker-compose.yml down
docker stop voiceprint-api
docker rm voiceprint-api
docker rmi ghcr.nju.edu.cn/xinnan-tech/voiceprint-api:latest

# Start the docker container
docker compose -f docker-compose.yml up -d
# View the logs
docker logs -f voiceprint-api
```

The logs will now show output similar to the following
```
250711 INFO-🚀 Start: production server starting (Uvicorn), listening on: 0.0.0.0:8005
250711 INFO-============================================================
250711 INFO-Voiceprint API URL: http://127.0.0.1:8005/voiceprint/health?key=abcd
250711 INFO-============================================================
```

Copy out the voiceprint API URL:

Because you deployed with docker, never use the address above directly!

Because you deployed with docker, never use the address above directly!

Because you deployed with docker, never use the address above directly!

Copy the address into a scratch note. You need to know your computer's LAN IP. For example, if my computer's LAN IP is `192.168.1.25`, then
my original API URL
```
http://127.0.0.1:8005/voiceprint/health?key=abcd

```
must be changed to
```
http://192.168.1.25:8005/voiceprint/health?key=abcd
```

After changing it, open the `voiceprint API URL` directly in a browser. If the browser shows something like the following, it worked.
```
{"total_voiceprints":0,"status":"healthy"}
```

Keep the modified `voiceprint API URL`; you will need it in the next step.

# 2. How to Configure Voiceprint Recognition in a Full-Module Deployment

## Step 1: Configure the API
First, enable the voiceprint recognition feature. In the control console, click `More` at the top, then click the `System Feature Management` page in the drop-down menu. On the page, check `Voiceprint Recognition` and click `Save Configuration`. You will then see the `Voiceprint` button on the card of a newly created agent.

If you use a full-module deployment, log in to the control console with an administrator account, click `More` at the top, and choose the `Params Management` function.

Then search for the parameter `server.voice_print`; its value should be `null` at this point.
Click the edit button, paste the `voiceprint API URL` from the previous part into `Parameter Value`, and save.

The voiceprint similarity threshold is another system parameter, `server.voiceprint_similarity_threshold` (default 0.4, range 0.0-1.0, higher is stricter). To adjust it, change it on the same `Params Management` page.

If it saves successfully, everything is fine and you can go to the agent to see the result. If it fails, the control console cannot reach voiceprint recognition, most likely because of a network firewall or an incorrect LAN IP.

## Step 2: Set the agent memory mode

Go to your agent's role configuration and set memory to `Local short memory`. Be sure to enable `Text & Voice` reporting.

## Step 3: Chat with your agent

Power on your device and chat with it at a normal speaking speed and tone.

## Step 4: Set up a voiceprint

In the control console, on the `Agents` page, the agent's panel has a `Voiceprint` button. Click it. There is an `Add` button at the bottom, which lets you register a voiceprint from what a person says.
In the dialog that pops up, filling in the `Description` field is recommended. It can be the person's occupation, personality, or hobbies, so the agent can analyze and get to know the speaker.

## Step 5: Verify the result

Power on your device and ask it, "Do you know who I am?" If it can answer, voiceprint recognition works.

# 3. How to Configure Voiceprint Recognition in a Minimal Deployment

## Step 1: Configure the API
Open the `xiaozhi-server/data/.config.yaml` file (create it if it does not exist), then add or modify the following:

```
# Voiceprint recognition configuration
voiceprint:
  # Voiceprint API URL
  url: your voiceprint API URL
  # Speaker configuration: speaker_id,name,description
  speakers:
    - "test1,Zhang San,Zhang San is a programmer"
    - "test2,Li Si,Li Si is a product manager"
    - "test3,Wang Wu,Wang Wu is a designer"
  # Voiceprint similarity threshold, range 0.0-1.0, default 0.4
  # Higher is stricter: fewer false matches but possibly more rejections
  similarity_threshold: 0.4
```

Paste the `voiceprint API URL` from the previous part into `url`, then save.

Add `speakers` entries as needed. Note the `speaker_id` parameter here; it is used later when registering voiceprints.

## Step 2: Register a voiceprint
If the voiceprint service is already running, open `http://localhost:8005/voiceprint/docs` in a local browser to view the API documentation. Only how to use the voiceprint registration API is described here.

The voiceprint registration API URL is `http://localhost:8005/voiceprint/register`, and the request method is POST.

The request header must include Bearer Token authentication. The token is the part after `?key=` in the `voiceprint API URL`. For example, if my voiceprint API URL is `http://127.0.0.1:8005/voiceprint/health?key=abcd`, my token is `abcd`.

The request body contains the speaker ID (speaker_id) and a WAV audio file (file). An example request:

```
curl -X POST \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -F "speaker_id=your_speaker_id_here" \
  -F "file=@/path/to/your/file" \
  http://localhost:8005/voiceprint/register
```

 Here `file` is an audio file of the speaker to register speaking, and `speaker_id` must match the `speaker_id` configured in Step 1. For example, if I need to register Zhang San's voiceprint and Zhang San's `speaker_id` in `.config.yaml` is `test1`, then when registering Zhang San's voiceprint the `speaker_id` in the request body is `test1`, and `file` is an audio file of Zhang San saying a few sentences.

 ## Step 3: Start the services

Start the Xiaozhi server and the voiceprint service, and you can use it normally.
