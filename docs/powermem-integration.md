# PowerMem Memory Component Integration Guide

## Introduction

[PowerMem](https://www.powermem.ai/) is an open-source agent memory component from OceanBase. It uses a local LLM for memory summarization and intelligent retrieval, giving AI agents efficient memory management.

Cost: PowerMem itself is open source and free. The actual cost depends on the LLM and database you choose:
- SQLite + a free LLM (such as Zhipu glm-4-flash) = **completely free**
- A cloud LLM or cloud database = billed by the corresponding service

> 💡 **Best performance tip**: PowerMem delivers its best performance with OceanBase. Use SQLite only when resources are limited.

- **GitHub**: https://github.com/oceanbase/powermem
- **Website**: https://www.powermem.ai/
- **Examples**: https://github.com/oceanbase/powermem/tree/main/examples

## Features

- **Local summarization**: summarizes and extracts memories locally through an LLM
- **User profile**: `UserMemory` automatically extracts user information (name, occupation, interests, and so on) and keeps updating the user profile
- **Intelligent forgetting**: based on the Ebbinghaus forgetting curve, automatically "forgets" outdated noise
- **Multiple storage backends**: OceanBase (recommended, best performance), SeekDB (recommended, unified storage for AI applications), PostgreSQL, SQLite (lightweight alternative)
- **Multiple LLMs**: Qwen, Zhipu (glm-4-flash is free), OpenAI, and others
- **Intelligent retrieval**: semantic retrieval based on vector search
- **Private deployment**: fully supports local private deployment
- **Async operation**: efficient asynchronous memory management

## Installation

PowerMem is already included in the project dependencies. To install it manually:

```bash
pip install powermem
```

## Configuration

### Basic configuration

Configure PowerMem in `config.yaml`:

```yaml
selected_module:
  Memory: powermem

Memory:
  powermem:
    type: powermem
    # Whether to enable the user profile feature
    # User profile supports: oceanbase, seekdb, sqlite (powermem 0.3.0+)
    enable_user_profile: true
    
    # ========== LLM configuration ==========
    llm:
      provider: openai  # Options: qwen, openai, zhipu, etc.
      config:
        api_key: your LLM API key
        model: qwen-plus
        # openai_base_url: https://api.openai.com/v1  # Optional, custom service URL
    
    # ========== Embedding configuration ==========
    embedder:
      provider: openai  # Options: qwen, openai, etc.
      config:
        api_key: your embedding model API key
        model: text-embedding-v4
        openai_base_url: https://dashscope.aliyuncs.com/compatible-mode/v1
        # embedding_dims: 1024  # Vector dimension, configure it when it is not 1536
    
    # ========== Database configuration ==========
    vector_store:
      provider: sqlite  # Options: oceanbase (recommended), seekdb (recommended), postgres, sqlite (lightweight)
      config: {}  # SQLite needs no extra configuration
```

### Parameter reference

#### LLM configuration

| Parameter | Description | Options |
|------|------|--------|
| `llm.provider` | LLM provider | `qwen`, `openai`, `zhipu`, etc. |
| `llm.config.api_key` | API key | - |
| `llm.config.model` | Model name | Depends on the provider |
| `llm.config.openai_base_url` | Custom service URL (optional) | - |

#### Embedding configuration

| Parameter | Description | Options |
|------|------|--------|
| `embedder.provider` | Embedding model provider | `qwen`, `openai`, etc. |
| `embedder.config.api_key` | API key | - |
| `embedder.config.model` | Model name | Depends on the provider |
| `embedder.config.openai_base_url` | Custom service URL (optional) | - |

#### Database configuration

| Parameter | Description | Options |
|------|------|--------|
| `vector_store.provider` | Storage backend type | `oceanbase` (recommended), `seekdb` (recommended), `postgres`, `sqlite` (lightweight) |
| `vector_store.config` | Database connection settings | Set according to the provider |

### Memory modes

PowerMem supports two memory modes:

| Mode | Configuration | Function | Storage requirement |
|------|------|------|----------|
| **Plain memory** | `enable_user_profile: false` | Stores and retrieves conversation memory | All databases supported |
| **User profile** | `enable_user_profile: true` | Memory + automatic user profile extraction | oceanbase, seekdb, sqlite |

> 📌 **Version note**: In PowerMem 0.3.0+, the user profile feature supports three storage backends: OceanBase, SeekDB, and SQLite.

### Using Qwen (recommended)

1. Go to the [Alibaba Cloud Bailian platform](https://bailian.console.aliyun.com/) and register an account
2. Get an API key on the [API Key management](https://bailian.console.aliyun.com/?apiKey=1#/api-key) page
3. Configure as follows:

```yaml
Memory:
  powermem:
    type: powermem
    enable_user_profile: true
    llm:
      provider: qwen
      config:
        api_key: sk-xxxxxxxxxxxxxxxx
        model: qwen-plus
    embedder:
      provider: openai
      config:
        api_key: sk-xxxxxxxxxxxxxxxx
        model: text-embedding-v4
        openai_base_url: https://dashscope.aliyuncs.com/compatible-mode/v1
    vector_store:
      provider: sqlite
      config: {}
```

### Using the free Zhipu LLM (completely free setup)

Zhipu offers the free glm-4-flash model. Combined with SQLite, it can be used completely free:

1. Go to the [Zhipu AI open platform](https://bigmodel.cn/) and register an account
2. Get an API key on the [API Keys](https://bigmodel.cn/usercenter/proj-mgmt/apikeys) page
3. Configure as follows:

```yaml
Memory:
  powermem:
    type: powermem
    enable_user_profile: true
    llm:
      provider: openai  # Use the openai-compatible mode
      config:
        api_key: xxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxx
        model: glm-4-flash
        openai_base_url: https://open.bigmodel.cn/api/paas/v4/
    embedder:
      provider: openai
      config:
        api_key: xxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxx
        model: embedding-3
        openai_base_url: https://open.bigmodel.cn/api/paas/v4/
    vector_store:
      provider: sqlite
      config: {}
```

### Using OpenAI

```yaml
Memory:
  powermem:
    type: powermem
    enable_user_profile: true
    llm:
      provider: openai
      config:
        api_key: sk-xxxxxxxxxxxxxxxx
        model: gpt-4o-mini
        openai_base_url: https://api.openai.com/v1
    embedder:
      provider: openai
      config:
        api_key: sk-xxxxxxxxxxxxxxxx
        model: text-embedding-3-small
        openai_base_url: https://api.openai.com/v1
    vector_store:
      provider: sqlite
      config: {}
```

### Using OceanBase (best performance)

OceanBase is the best partner for PowerMem and unlocks its maximum performance:

1. Deploy an OceanBase database (open-source local deployment or a cloud service)
   - Open-source deployment: https://github.com/oceanbase/oceanbase
   - Cloud service: https://www.oceanbase.com/
2. Configure as follows:

```yaml
Memory:
  powermem:
    type: powermem
    enable_user_profile: true
    llm:
      provider: qwen
      config:
        api_key: sk-xxxxxxxxxxxxxxxx
        model: qwen-plus
    embedder:
      provider: openai
      config:
        api_key: sk-xxxxxxxxxxxxxxxx
        model: text-embedding-v4
        openai_base_url: https://dashscope.aliyuncs.com/compatible-mode/v1
    vector_store:
      provider: oceanbase
      config:
        host: 127.0.0.1
        port: 2881
        user: root@test
        password: your_password
        db_name: powermem
        collection_name: memories  # Default value
        embedding_model_dims: 1536  # Embedding vector dimension, required
```

## Per-Device Memory Isolation

PowerMem automatically uses the device ID (`device_id`) as the `user_id` for memory isolation. This means:

- Each device has its own memory space
- Memories of different devices are fully isolated
- Multiple conversations on the same device share the memory context

## User Profile (UserMemory)

PowerMem provides the `UserMemory` class, which automatically extracts user profile information from conversations.

> 📌 **Version note**: In PowerMem 0.3.0+, the user profile feature supports three storage backends: OceanBase, SeekDB, and SQLite.

### Enabling the user profile

Set `enable_user_profile: true` in the configuration:

```yaml
Memory:
  powermem:
    type: powermem
    enable_user_profile: true  # Enable the user profile
    llm:
      provider: qwen
      config:
        api_key: sk-xxxxxxxxxxxxxxxx
        model: qwen-plus
    embedder:
      provider: openai
      config:
        api_key: sk-xxxxxxxxxxxxxxxx
        model: text-embedding-v4
        openai_base_url: https://dashscope.aliyuncs.com/compatible-mode/v1
    vector_store:
      provider: sqlite  # User profile supports: oceanbase, seekdb, sqlite
      config: {}
```

### User profile capabilities

| Capability | Description |
|------|------|
| **Information extraction** | Automatically extracts name, age, occupation, interests, and more from conversations |
| **Continuous updates** | Keeps refining the user profile as conversations continue |
| **Profile retrieval** | Combines the user profile with memory search to improve retrieval relevance |
| **Intelligent forgetting** | Fades outdated information based on the Ebbinghaus forgetting curve |

### How it works

With the user profile enabled, Xiaozhi automatically returns the following when querying memory:
1. **User profile**: the user's basic information, interests, and so on
2. **Relevant memories**: historical memories related to the current conversation

> ✅ **Version note**: In PowerMem 0.3.0+, the user profile feature supports three storage backends: OceanBase, SeekDB, and SQLite.

## Comparison with Other Memory Components

| Feature | PowerMem | mem0ai | mem_local_short |
|------|----------|--------|-----------------|
| How it works | Local summarization | Cloud API | Local summarization |
| Storage location | Local/cloud DB | Cloud | Local YAML |
| Cost | Depends on LLM and DB | 1000 calls/month free | Completely free |
| Intelligent retrieval | ✅ Vector search | ✅ Vector search | ❌ Returns everything |
| User profile | ✅ UserMemory | ❌ | ❌ |
| Intelligent forgetting | ✅ Forgetting curve | ❌ | ❌ |
| Private deployment | ✅ Supported | ❌ Cloud only | ✅ Supported |
| Database support | OceanBase (recommended)/SeekDB/PostgreSQL/SQLite | - | YAML file |

## FAQ

### 1. API key error

If you get an `API key is required` error, check:
- Whether `llm_api_key` and `embedding_api_key` are filled in correctly
- Whether the API keys are valid

### 2. Model does not exist

If you get a model-not-found error, confirm:
- Whether the `llm_model` and `embedding_model` names are correct
- Whether the corresponding model service has been activated

### 3. Connection timeout

If you get a connection timeout, you can try:
- Checking the network connection
- If you use a proxy, configuring `llm_base_url` and `embedding_base_url`

## Testing

You can test whether PowerMem works in the virtual environment:

```bash
# Activate the virtual environment
source .venv/bin/activate

# Test the PowerMem import
python -c "from powermem import AsyncMemory; print('PowerMem imported successfully')"

# Test the UserMemory import (user profile feature)
python -c "from powermem import UserMemory; print('UserMemory imported successfully')"
```

## More Resources

- [PowerMem official documentation](https://www.powermem.ai/)
- [PowerMem GitHub repository](https://github.com/oceanbase/powermem)
- [PowerMem examples](https://github.com/oceanbase/powermem/tree/main/examples)
- [OceanBase website](https://www.oceanbase.com/)
- [OceanBase GitHub](https://github.com/oceanbase/oceanbase)
- [SeekDB GitHub](https://github.com/oceanbase/seekdb) (AI-native search database)
- [Alibaba Cloud Bailian platform](https://bailian.console.aliyun.com/)

