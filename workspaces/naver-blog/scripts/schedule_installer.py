import os
import subprocess
import argparse

def install_cron(hour, minute):
    # Get absolute path to the project root and script
    project_root = os.path.expanduser("~/0xhenry.dev")
    script_path = os.path.join(project_root, "workspaces/naver-blog/scripts/autonomous_loop.py")
    python_path = subprocess.check_output(["which", "python3"]).decode().strip()
    
    # Define the cron command
    # Redirect output to a log file for monitoring
    log_path = os.path.join(project_root, "workspaces/naver-blog/logs/cron_loop.log")
    os.makedirs(os.path.dirname(log_path), exist_ok=True)
    
    cron_cmd = f"{minute} {hour} * * * cd {project_root} && {python_path} {script_path} >> {log_path} 2>&1"
    
    # Get current crontab
    try:
        current_cron = subprocess.check_output(["crontab", "-l"], stderr=subprocess.DEVNULL).decode()
    except subprocess.CalledProcessError:
        current_cron = ""
    
    # Check if already exists and update or add
    lines = current_cron.strip().split("\n")
    new_lines = []
    found = False
    
    for line in lines:
        if "autonomous_loop.py" in line:
            new_lines.append(cron_cmd)
            found = True
        elif line.strip():
            new_lines.append(line)
            
    if not found:
        new_lines.append(cron_cmd)
        
    new_cron = "\n".join(new_lines) + "\n"
    
    # Write back to crontab
    process = subprocess.Popen(["crontab", "-"], stdin=subprocess.PIPE)
    process.communicate(input=new_cron.encode())
    
    print(f"✅ Cron job installed: Every day at {hour:02d}:{minute:02d}")
    print(f"📝 Command: {cron_cmd}")
    print(f"📂 Logs: {log_path}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--hour", type=int, default=9, help="Hour (0-23)")
    parser.add_argument("--minute", type=int, default=0, help="Minute (0-59)")
    args = parser.parse_args()
    
    install_cron(args.hour, args.minute)
