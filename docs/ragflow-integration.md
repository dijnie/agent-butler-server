# RAGFlow Integration Guide

This tutorial has two main parts

- Part 1: How to deploy ragflow
- Part 2: How to configure the ragflow API in the control console

If you are familiar with ragflow and have already deployed it, skip Part 1 and go straight to Part 2. But if you want guidance on deploying ragflow so that it shares the `mysql` and `redis` base services with `xiaozhi-esp32-server` to reduce resource costs, start from Part 1.

# Part 1: How to Deploy ragflow
## Step 1: Confirm that mysql and redis are available

ragflow depends on a `mysql` database. If you have already deployed the `control console`, `mysql` is already installed and you can share it.

On the host machine, try the `telnet` command to see whether the `mysql` `3306` port is reachable.
``` shell
telnet 127.0.0.1 3306

telnet 127.0.0.1 6379
```
If ports `3306` and `6379` are reachable, skip the rest of this step and go straight to Step 2.

If they are not reachable, recall how your `mysql` was installed.

If you installed mysql yourself from an installation package, your `mysql` is network-isolated. You may need to solve the problem of reaching the `mysql` `3306` port first.

If your `mysql` was installed through this project's `docker-compose_all.yml`, find the `docker-compose_all.yml` file you used to create the database and change the following

Before
``` yaml
  xiaozhi-esp32-server-db:
    ...
    networks:
      - default
    expose:
      - "3306:3306"
  xiaozhi-esp32-server-redis:
    ...
    expose:
      - 6379
```

After
``` yaml
  xiaozhi-esp32-server-db:
    ...
    networks:
      - default
    ports:
      - "3306:3306"
  xiaozhi-esp32-server-redis:
    ...
    ports:
      - "6379:6379"
```

Note that you change `expose` to `ports` under `xiaozhi-esp32-server-db` and `xiaozhi-esp32-server-redis`. After the change, restart it. The commands to restart mysql are:

``` shell
# Go to the folder that contains your docker-compose_all.yml, for example mine is xiaozhi-server
cd xiaozhi-server
docker compose -f docker-compose_all.yml down
docker compose -f docker-compose.yml up -d
```

After it starts, use the `telnet` command on the host machine again to check whether the `mysql` `3306` port is reachable.
``` shell
telnet 127.0.0.1 3306

telnet 127.0.0.1 6379
```
Normally it is reachable now.

## Step 2: Create the database and user
If your host machine can reach the mysql database, create a database named `rag_flow` and a user `rag_flow` with the password `infini_rag_flow` in mysql.

``` sql
-- Create the database
CREATE DATABASE IF NOT EXISTS rag_flow CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create the user and grant privileges
CREATE USER IF NOT EXISTS 'rag_flow'@'%' IDENTIFIED BY 'infini_rag_flow';
GRANT ALL PRIVILEGES ON rag_flow.* TO 'rag_flow'@'%';

-- Refresh privileges
FLUSH PRIVILEGES;
```

## Step 3: Download the ragflow project

Pick a folder on your computer to hold the ragflow project. For example, I use the `/home/system/xiaozhi` folder.

You can use `git` to download the ragflow project into this folder. This tutorial installs and deploys version `v0.22.0`.
```
git clone https://ghfast.top/https://github.com/infiniflow/ragflow.git
cd ragflow
git checkout v0.22.0
```
After downloading, go into the `docker` folder.
``` shell
cd docker
```
Edit the `docker-compose.yml` file in the `ragflow/docker` folder and remove the `depends_on` configuration of the `ragflow-cpu` and `ragflow-gpu` services, to remove the dependency of the `ragflow-cpu` service on `mysql`.

Before the change:
``` yaml
  ragflow-cpu:
    depends_on:
      mysql:
        condition: service_healthy
    profiles:
      - cpu
  ...
  ragflow-gpu:
    depends_on:
      mysql:
        condition: service_healthy
    profiles:
      - gpu
```
After the change:
``` yaml
  ragflow-cpu:
    profiles:
      - cpu
  ...
  ragflow-gpu:
    profiles:
      - gpu
```

Next, edit the `docker-compose-base.yml` file in the `ragflow/docker` folder and remove the `mysql` and `redis` configuration.

For example, before deletion:
``` yaml
services:
  minio:
    image: quay.io/minio/minio:RELEASE.2025-06-13T11-33-47Z
    ...
  mysql:
    image: mysql:8.0
    ...
  redis:
    image: redis:6.2-alpine
    ...
```

After deletion
``` yaml
services:
  minio:
    image: quay.io/minio/minio:RELEASE.2025-06-13T11-33-47Z
    ...
```
## Step 4: Modify the environment variable configuration

Edit the `.env` file in the `ragflow/docker` folder, find the following settings, and search and modify them one by one! Search and modify them one by one!

For the `.env` changes below, 60% of people overlook the `MYSQL_USER` setting and ragflow fails to start, so it is stressed three times:

First reminder: if your `.env` file has no `MYSQL_USER` setting, add it to the file!

Second reminder: if your `.env` file has no `MYSQL_USER` setting, add it to the file!

Third reminder: if your `.env` file has no `MYSQL_USER` setting, add it to the file!

``` env
# Port settings
SVR_WEB_HTTP_PORT=8008           # HTTP port
SVR_WEB_HTTPS_PORT=8009          # HTTPS port
# MySQL configuration - change to your local MySQL information
MYSQL_HOST=host.docker.internal  # Use host.docker.internal so the container can reach host services
MYSQL_PORT=3306                  # Local MySQL port
MYSQL_USER=rag_flow              # The user name created above; add this entry if it is missing
MYSQL_PASSWORD=infini_rag_flow   # The password set above
MYSQL_DBNAME=rag_flow            # Database name

# Redis configuration - change to your local Redis information
REDIS_HOST=host.docker.internal  # Use host.docker.internal so the container can reach host services
REDIS_PORT=6379                  # Local Redis port
REDIS_PASSWORD=                  # If your Redis has no password, leave it like this; otherwise enter the password
```

Note: if your Redis has no password, also edit `service_conf.yaml.template` in the `ragflow/docker` folder and replace `infini_rag_flow` with an empty string.

Before
``` shell
redis:
  db: 1
  password: '${REDIS_PASSWORD:-infini_rag_flow}'
  host: '${REDIS_HOST:-redis}:6379'
```
After
``` shell
redis:
  db: 1
  password: '${REDIS_PASSWORD:-}'
  host: '${REDIS_HOST:-redis}:6379'
```

## Step 5: Start the ragflow service
Run the command:
``` shell
docker-compose -f docker-compose.yml up -d
```
After it succeeds, you can use the `docker logs -n 20 -f docker-ragflow-cpu-1` command to view the logs of the `docker-ragflow-cpu-1` service.

If there are no errors in the logs, the ragflow service started successfully.

# Step 5: Register an account
Open `http://127.0.0.1:8008` in a browser and click `Sign Up` to register an account.

After registering, click `Sign In` to log in to the ragflow service. If you want to turn off registration so that others cannot register accounts, set `REGISTER_ENABLED` to `0` in the `.env` file in the `ragflow/docker` folder.

``` dotenv
REGISTER_ENABLED=0
```
After the change, restart the ragflow service.
``` shell
docker-compose -f docker-compose.yml down
docker-compose -f docker-compose.yml up -d
```

# Step 6: Configure the models of the ragflow service
Open `http://127.0.0.1:8008` in a browser and click `Sign In` to log in to the ragflow service. Click the `avatar` at the top right of the page to enter the settings page.
First, in the left navigation bar, click `Model providers` to enter the model configuration page. Under the `Available models` search box on the right, select `LLM`, choose the model provider you use from the list, click `Add`, and enter your key;
then select `TEXT EMBEDDING`, choose the model provider you use from the list, click `Add`, and enter your key.
Finally, refresh the page, click LLM and Embedding in the `Set default models` list one by one, and choose the models you use. Make sure your key has the corresponding services enabled. For example, if my Embedding model is from provider xxx, I need to check on that provider's website whether the model requires buying a resource package before it can be used.


# Part 2: Configure the ragflow Service

# Step 1: Log in to the ragflow service
Open `http://127.0.0.1:8008` in a browser and click `Sign In` to log in to the ragflow service.

Then click the `avatar` at the top right to enter the settings page. In the left navigation bar, click the `API` function, then click the "API Key" button. A dialog appears.

In the dialog, click the "Create new Key" button to generate an API Key. Copy this `API Key`; you will need it later.

# Step 2: Configure it in the control console
Make sure your control console version is `0.8.7` or above. Log in to the control console with a super administrator account.

First, enable the knowledge base feature. In the top navigation bar, click `More`, then click the `System Feature Management` page in the drop-down menu. On the page, check `Knowledge Base` and click `Save Configuration`. You will then see the `Knowledge` function in the navigation bar.

In the top navigation bar, click `Models`, then click `RAG` in the left navigation bar. Find `RAG_RAGFlow` in the list and click the `Edit` button.

In `Service URL`, enter `http://LAN IP of your ragflow service:8008`. For example, if the LAN IP of my ragflow service is `192.168.1.100`, I enter `http://192.168.1.100:8008`.

In `API Key`, enter the `API Key` copied earlier.

Finally, click the save button.

# Step 2: Create a knowledge base
Log in to the control console with a super administrator account. In the top navigation bar, click `Knowledge`, then click the `Add` button at the bottom left of the list. Enter a name and description for the knowledge base and click save.

To improve the large model's understanding and recall of the knowledge base, enter a meaningful name and description when creating it. For example, if you create a knowledge base about `Company Introduction`, the name can be `Company Introduction`, and the description can be `Information about the company, such as basic company information, services, contact phone numbers, and addresses.`.

After saving, you can see the knowledge base in the knowledge base list. Click the `Manage Files` button of the knowledge base you just created to enter the knowledge base details page.

On the knowledge base details page, click the `Add` button at the bottom left to upload documents to the knowledge base.

After uploading, you can see the uploaded documents on the knowledge base details page. You can then click the `Parse` button of a document to parse it.

After parsing, you can view the resulting slice information. On the knowledge base details page, click the `Retrieval Test` button to test the recall/retrieval function of the knowledge base.

# Step 3: Let Xiaozhi use the ragflow knowledge base
Log in to the control console. In the top navigation bar, click `Agents`, find the agent you want to configure, and click the `Config Role` button.

To the left of Intent Recognition, click the `Edit Functions` button and a dialog pops up. In the dialog, select the knowledge bases you want to add. Then save.
