This is a development document. To deploy the Xiaozhi server, [click here for the deployment guide](../../README.md#deployment-documentation)

# Project Introduction

manager-api is built on the SpringBoot framework.

When developing with a code editor, select the `manager-api` folder as the project directory when importing the project

# Development Environment
JDK 21
Maven 3.8+
MySQL 8.0+
Redis 5.0+
Vue 3.x

# API Documentation
After startup, open: http://localhost:8002/xiaozhi/doc.html

# Running Tests
There are two kinds of tests: pure unit tests, and integration tests that connect to a real MySQL and Redis (`DeviceTest`, `loginControllerTest`, `ModelConfigPersistenceTest`).

Integration tests need MySQL 8 and Redis 8 to be running first. When they are not running, these test classes are skipped entirely and do not turn the build red; the log states which dependency is missing. CI is different: if a dependency cannot be reached the build fails outright and skipping is not allowed, so the gate is not silently hollowed out.

Start the two dependencies locally with Docker:

```bash
docker run -d --name xiaozhi-mysql -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=123456 -e MYSQL_DATABASE=xiaozhi_esp32_server mysql:8.0
docker run -d --name xiaozhi-redis -p 6379:6379 redis:8.0
```

Run all tests:

```bash
mvn -B test -DskipTests=false
```

Compile only, without running tests:

```bash
mvn -B package -DskipTests=true
```

