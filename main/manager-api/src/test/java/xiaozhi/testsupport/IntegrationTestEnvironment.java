package xiaozhi.testsupport;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.time.Duration;

import org.junit.jupiter.api.Assumptions;
import org.springframework.boot.env.YamlPropertySourceLoader;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.PropertySource;
import org.springframework.core.env.PropertySourcesPropertyResolver;
import org.springframework.core.env.StandardEnvironment;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;

import io.lettuce.core.RedisClient;
import io.lettuce.core.RedisURI;
import io.lettuce.core.api.StatefulRedisConnection;
import lombok.extern.slf4j.Slf4j;

/**
 * Several @SpringBootTest classes connect to a real MySQL and Redis. When these two dependencies are not running locally,
 * the whole test class is skipped, so a Spring context that cannot start does not turn into a pile of unreadable errors;
 * in CI the dependencies must really be there, and if they cannot be reached the build goes red directly.
 */
@Slf4j
public final class IntegrationTestEnvironment {

    /** Configuration files used by the integration tests, the same set the application itself reads */
    private static final String[] CONFIG_FILES = {"application.yml", "application-dev.yml"};

    private static Boolean available;
    private static String problem;

    private IntegrationTestEnvironment() {
    }

    /**
     * Put this in the @BeforeAll of test classes that connect to the database.
     * When local dependencies are incomplete the whole class is skipped; when CI dependencies are incomplete it fails directly.
     */
    public static void requireDatabaseAndRedis() {
        String issue = probe();
        if (issue == null) {
            return;
        }
        if (isCi()) {
            throw new IllegalStateException(
                    "In the CI environment, " + issue + "; these integration tests must really run and cannot be skipped");
        }
        log.warn("Skipping integration tests that depend on MySQL and Redis: {}", issue);
        Assumptions.assumeTrue(false, issue);
    }

    /** GitHub Actions sets CI=true */
    public static boolean isCi() {
        String value = System.getenv("CI");
        if (value == null) {
            return false;
        }
        String trimmed = value.trim();
        return !trimmed.isEmpty() && !"false".equalsIgnoreCase(trimmed);
    }

    /** Returns null when all dependencies are present, otherwise what is missing */
    static synchronized String probe() {
        if (available != null) {
            return problem;
        }
        PropertySourcesPropertyResolver resolver = resolver();
        StringBuilder issues = new StringBuilder();

        String url = firstNonBlank(resolver.getProperty("spring.datasource.druid.url", ""),
                resolver.getProperty("spring.datasource.url", ""));
        String username = firstNonBlank(resolver.getProperty("spring.datasource.druid.username", ""),
                resolver.getProperty("spring.datasource.username", ""));
        String password = firstNonBlank(resolver.getProperty("spring.datasource.druid.password", ""),
                resolver.getProperty("spring.datasource.password", ""));
        if (url.isBlank()) {
            issues.append("data source URL not found in the configuration; ");
        } else {
            try {
                DriverManager.setLoginTimeout(5);
                try (Connection connection = DriverManager.getConnection(url, username, password)) {
                    connection.isValid(3);
                }
            } catch (Exception e) {
                issues.append("cannot connect to MySQL (").append(e.getMessage()).append("); ");
            }
        }

        String redisHost = resolver.getProperty("spring.data.redis.host", "localhost");
        int redisPort = resolver.getProperty("spring.data.redis.port", Integer.class, 6379);
        String redisPassword = resolver.getProperty("spring.data.redis.password", "");
        try {
            RedisURI.Builder builder = RedisURI.builder()
                    .withHost(redisHost)
                    .withPort(redisPort)
                    .withTimeout(Duration.ofSeconds(3));
            if (redisPassword != null && !redisPassword.isBlank()) {
                builder.withPassword(redisPassword.toCharArray());
            }
            RedisClient client = RedisClient.create(builder.build());
            try {
                StatefulRedisConnection<String, String> connection = client.connect();
                connection.sync().ping();
                connection.close();
            } finally {
                client.shutdown();
            }
        } catch (Exception e) {
            issues.append("cannot connect to Redis (").append(e.getMessage()).append("); ");
        }

        if (issues.length() == 0) {
            available = Boolean.TRUE;
            problem = null;
        } else {
            available = Boolean.FALSE;
            problem = issues.toString();
        }
        return problem;
    }

    /** Reads the application's own configuration; -D arguments on the command line take priority, consistent with the application */
    private static PropertySourcesPropertyResolver resolver() {
        ConfigurableEnvironment environment = new StandardEnvironment();
        YamlPropertySourceLoader loader = new YamlPropertySourceLoader();
        for (String name : CONFIG_FILES) {
            Resource resource = new ClassPathResource(name);
            if (!resource.exists()) {
                continue;
            }
            try {
                for (PropertySource<?> source : loader.load(name, resource)) {
                    environment.getPropertySources().addLast(source);
                }
            } catch (IOException e) {
                log.warn("Failed to read configuration {}: {}", name, e.getMessage());
            }
        }
        return new PropertySourcesPropertyResolver(environment.getPropertySources());
    }

    private static String firstNonBlank(String first, String second) {
        return first != null && !first.isBlank() ? first : (second == null ? "" : second);
    }
}
