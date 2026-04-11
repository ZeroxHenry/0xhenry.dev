import os
import subprocess
import socket

def check_ollama_running():
    """Check if Ollama is already running on the standard port."""
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        return s.connect_ex(('localhost', 11434)) == 0

def main():
    print("Checking Ollama status...")
    if check_ollama_running():
        print("✅ Ollama is already running on port 11434.")
    else:
        print("❌ Ollama is not running.")
        print("Please start the Ollama application or run 'ollama serve' in a separate terminal.")
        print("\nTo start it manually from here (Ctrl+C to stop):")
        try:
            # Set environment variable for remote access if needed
            env = os.environ.copy()
            env["OLLAMA_HOST"] = "0.0.0.0:11434"
            subprocess.run(["ollama", "serve"], env=env)
        except KeyboardInterrupt:
            print("\nStopped.")
        except FileNotFoundError:
            print("Error: 'ollama' command not found. Please install it from https://ollama.com")

if __name__ == "__main__":
    main()