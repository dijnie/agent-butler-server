# Request Library

The project uses Alova as its only HTTP request library:

## Usage

- **Alova HTTP**: path (src/http/request/alova.ts)
- **Sample code**: src/api/foo-alova.ts and src/api/foo.ts
- **API docs**: https://alova.js.org/

## Configuration

The Alova instance is configured with:
- Automatic token authentication and refresh
- Unified error handling and prompts
- Dynamic domain switching
- Built-in request/response interceptors

## Usage Example

```typescript
import { http } from '@/http/request/alova'

// GET request
http.Get<ResponseType>('/api/path', {
  params: { id: 1 },
  headers: { 'Custom-Header': 'value' },
  meta: { toast: false } // Disable the error toast
})

// POST request  
http.Post<ResponseType>('/api/path', data, {
  params: { query: 'param' },
  headers: { 'Content-Type': 'application/json' }
})
```