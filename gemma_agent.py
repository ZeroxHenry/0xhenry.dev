import urllib.request
import json
import os
import sys

# Constants
OLLAMA_URL = "http://localhost:11434/api/chat"
MODEL_NAME = "gemma4:e4b"

# --- Tools Implementation ---

def list_dir(path="."):
    """Lists files and directories in a given path."""
    try:
        items = os.listdir(path)
        return {"items": items, "status": "success"}
    except Exception as e:
        return {"error": str(e), "status": "failed"}

def read_file(path):
    """Reads the content of a specific file."""
    try:
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read(1000) # Read first 1000 chars for safety
            return {"content": content, "status": "success", "truncated": len(content) >= 1000}
    except Exception as e:
        return {"error": str(e), "status": "failed"}

# Tool definitions for Ollama
TOOLS = [
    {
        "type": "function",
        "function": {
            "name": "list_dir",
            "description": "List files and directories in a workspace path",
            "parameters": {
                "type": "object",
                "properties": {
                    "path": {"type": "string", "description": "The directory path to list"}
                }
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "read_file",
            "description": "Read the content of a file",
            "parameters": {
                "type": "object",
                "properties": {
                    "path": {"type": "string", "description": "The file path to read"}
                },
                "required": ["path"]
            }
        }
    }
]

def execute_tool(name, arguments):
    if name == "list_dir":
        return list_dir(**arguments)
    elif name == "read_file":
        return read_file(**arguments)
    else:
        return {"error": f"Tool {name} not found"}

# --- Agent Loop ---

def run_agent(user_prompt):
    messages = [
        {
            "role": "system", 
            "content": "You are '0xHenry ResearchBot', an advanced Edge AI Agent. You help manage the 0xhenry.dev blog. Use the provided tools to research the workspace before answering."
        },
        {"role": "user", "content": user_prompt}
    ]

    print(f"\n[Agent]: Target Model -> {MODEL_NAME}")
    print(f"[User]: {user_prompt}\n")

    step = 0
    while step < 5: # Max 5 steps to prevent loops
        step += 1
        payload = {
            "model": MODEL_NAME,
            "messages": messages,
            "tools": TOOLS,
            "stream": False
        }

        try:
            req = urllib.request.Request(
                OLLAMA_URL, 
                data=json.dumps(payload).encode('utf-8'),
                headers={'Content-Type': 'application/json'},
                method='POST'
            )
            
            with urllib.request.urlopen(req, timeout=120) as response:
                result = json.loads(response.read().decode('utf-8'))
                message = result.get('message', {})
                
                # Check for tool calls
                tool_calls = message.get('tool_calls')
                if tool_calls:
                    messages.append(message) # Add assistant's tool call to history
                    
                    for call in tool_calls:
                        tool_name = call['function']['name']
                        tool_args = call['function']['arguments']
                        
                        print(f"--- Step {step}: Calling Tool [{tool_name}] ---")
                        tool_result = execute_tool(tool_name, tool_args)
                        # Ensuring we don't crash on print if result has unicode
                        result_str = str(tool_result)[:100].encode('ascii', 'ignore').decode('ascii')
                        print(f"--- Tool Result: {result_str}... ---\n")
                        
                        messages.append({
                            "role": "tool",
                            "content": json.dumps(tool_result)
                        })
                    continue # Continue loop to let model reason on tool results
                
                # Final text response
                content = message.get('content')
                if content:
                    # Encoding safe print for Windows
                    safe_content = content.encode(sys.stdout.encoding, errors='replace').decode(sys.stdout.encoding)
                    print(f"\n[Final Response]:\n{safe_content}")
                    return content
                
        except Exception as e:
            print(f"Error in Agent Loop: {e}")
            break

    print("Max steps reached or error occurred.")

if __name__ == "__main__":
    prompt = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else "What are the main files in this project?"
    run_agent(prompt)
