import urllib.request
import json
import socket

def check_local_model():
    url = "http://localhost:11434/api/generate"
    payload = {
        "model": "gemma4:e4b",
        "prompt": "Say 'hello from gemma 4' if you are working.",
        "stream": False
    }
    
    print(f"Testing connection to Ollama at {url}...")
    try:
        data = json.dumps(payload).encode('utf-8')
        req = urllib.request.Request(url, data=data, headers={'Content-Type': 'application/json'}, method='POST')
        # Setting a 60 second timeout because 4B models can take a while to load on some systems
        with urllib.request.urlopen(req, timeout=60) as response:
            if response.getcode() == 200:
                result = json.loads(response.read().decode('utf-8'))
                print("SUCCESS: Model responded:")
                print("-" * 20)
                print(result.get('response', 'No response field found.'))
                print("-" * 20)
                return True
            else:
                print(f"FAILURE: Failed with status code: {response.getcode()}")
    except socket.timeout:
        print("TIMEOUT: Request timed out. The model might be loading or the 4B variant is too slow for 60s.")
    except Exception as e:
        print(f"ERROR: {e}")
    return False

if __name__ == "__main__":
    check_local_model()
