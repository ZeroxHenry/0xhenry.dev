#!/bin/bash

# Antigravity Local AI Health Check
# This script verifies the connection to your local Gemma 4.0 model.

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}--- Antigravity Local AI Health Check ---${NC}"

# Check for Ollama Process
if pgrep -x "ollama" > /dev/null
then
    echo -e "[${GREEN}OK${NC}] Ollama service is running."
else
    echo -e "[${RED}FAIL${NC}] Ollama service NOT found. Please start Ollama.app."
    exit 1
fi

# Check for Model
MODEL_CHECK=$(curl -s http://localhost:11434/api/tags | grep "gemma4:e4b")
if [ ! -z "$MODEL_CHECK" ]; then
    echo -e "[${GREEN}OK${NC}] Gemma 4.0 (e4b) model is available localy."
else
    echo -e "[${RED}FAIL${NC}] Gemma 4.0 (e4b) model NOT found in Ollama. Pulling it now might take a while."
    echo -e "      Run: ollama pull gemma4:e4b"
    exit 1
fi

# Check Configuration
CONFIG_PATH="./antigravity.config.json"
if [ -f "$CONFIG_PATH" ]; then
    echo -e "[${GREEN}OK${NC}] Configuration file found."
    DEFAULT_MODEL=$(grep "\"defaultModel\":" "$CONFIG_PATH" | cut -d'"' -f4)
    if [ "$DEFAULT_MODEL" == "local" ]; then
        echo -e "[${GREEN}OK${NC}] Primary model is set to ${CYAN}local${NC} (Gemma 4.0)."
    else
        echo -e "[${RED}WARN${NC}] Primary model is set to ${RED}$DEFAULT_MODEL${NC}. (Expected: local)"
    fi
else
    echo -e "[${RED}FAIL${NC}] antigravity.config.json NOT found in current directory."
    exit 1
fi

echo -e "\n${CYAN}Successfully connected! You can now use @local in the chat.${NC}"
