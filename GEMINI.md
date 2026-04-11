# Project Global Rules

## AI Model Routing

Whenever the user explicitly types `@local` in a prompt, the system MUST route the request to the local model.
You must use the following configuration for the local model communications:
- `baseUrl`: `"http://localhost:11434/v1"`
- `model`: `"gemma4:e4b"`

This rule is absolute and ensures that local processing uses the specified Gemma 4.0 instance.
