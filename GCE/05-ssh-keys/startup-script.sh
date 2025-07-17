#!/bin/bash
# Creative startup script: ASCII Art Welcome Banner with System Info Dashboard

# Log startup script execution
echo "$(date): Starting creative welcome setup..." >> /var/log/startup-script.log

# Create a fancy welcome message with system info
cat > /etc/motd << 'EOF'
 
╔═══════════════════════════════════════════════════════════════════╗
║                    🚀 SSH Keys Demo VM 🚀                         ║
║═══════════════════════════════════════════════════════════════════║
║  Welcome to your secure VM with custom SSH key management!       ║
║                                                                   ║
║  🔐 Security Status: SSH Key Authentication Active               ║
║  🌏 Region: Jakarta (asia-southeast2)                            ║
║  💡 Purpose: Demonstrating secure SSH access patterns            ║
╚═══════════════════════════════════════════════════════════════════╝

EOF

# Create a system info script that runs on login
cat > /etc/profile.d/system-info.sh << 'SCRIPT'
#!/bin/bash
# Display colorful system information dashboard

echo -e "\n\033[1;36m═══ System Information Dashboard ═══\033[0m"
echo -e "\033[1;33m📊 System Stats:\033[0m"
echo -e "  • Hostname: \033[1;32m$(hostname)\033[0m"
echo -e "  • IP Address: \033[1;32m$(curl -s http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip -H "Metadata-Flavor: Google")\033[0m"
echo -e "  • Zone: \033[1;32m$(curl -s http://metadata.google.internal/computeMetadata/v1/instance/zone -H "Metadata-Flavor: Google" | cut -d'/' -f4)\033[0m"
echo -e "  • Machine Type: \033[1;32m$(curl -s http://metadata.google.internal/computeMetadata/v1/instance/machine-type -H "Metadata-Flavor: Google" | cut -d'/' -f4)\033[0m"
echo -e "  • Uptime: \033[1;32m$(uptime -p)\033[0m"
echo -e "  • Memory: \033[1;32m$(free -h | grep Mem | awk '{print $3 " / " $2}')\033[0m"
echo -e "  • Disk Usage: \033[1;32m$(df -h / | tail -1 | awk '{print $3 " / " $2 " (" $5 ")"}')\033[0m"

echo -e "\n\033[1;36m🔑 SSH Key Info:\033[0m"
echo -e "  • Authorized Users: \033[1;32m$(ls /home | wc -l)\033[0m"
echo -e "  • SSH Port: \033[1;32m$(grep -E "^Port" /etc/ssh/sshd_config | awk '{print $2}' || echo "22")\033[0m"
echo -e "  • Last Login: \033[1;32m$(last -1 -R | head -1 | awk '{print $1 " from " $3 " at " $4 " " $5}')\033[0m"

echo -e "\n\033[1;36m🎨 Fun Fact of the Day:\033[0m"
# Array of fun tech facts
facts=(
  "The first computer bug was an actual bug - a moth trapped in Harvard's Mark II computer in 1947!"
  "The password for nuclear missiles was 00000000 for 20 years during the Cold War."
  "The first computer virus was created in 1983 and was called the Elk Cloner."
  "Gmail was originally called 'Caribou' during development at Google."
  "The @ symbol was used in email addresses because it was the least used character on keyboards."
)
# Select random fact
RANDOM_FACT=${facts[$RANDOM % ${#facts[@]}]}
echo -e "  \033[1;35m$RANDOM_FACT\033[0m"

echo -e "\n\033[1;36m═════════════════════════════════════\033[0m\n"
SCRIPT

chmod +x /etc/profile.d/system-info.sh

# Create a simple web server to show SSH key info (for demo purposes)
cat > /home/ssh-info-server.py << 'PYTHON'
#!/usr/bin/env python3
import http.server
import socketserver
import subprocess
import json
from datetime import datetime

class SSHInfoHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        
        # Get SSH key information
        try:
            users = subprocess.check_output(['ls', '/home']).decode().strip().split('\n')
            ssh_keys = {}
            for user in users:
                try:
                    with open(f'/home/{user}/.ssh/authorized_keys', 'r') as f:
                        keys = f.readlines()
                        ssh_keys[user] = len(keys)
                except:
                    ssh_keys[user] = 0
        except:
            ssh_keys = {}
        
        html = f"""
        <html>
        <head>
            <title>SSH Keys Demo VM</title>
            <style>
                body {{ font-family: Arial, sans-serif; margin: 40px; background-color: #f0f0f0; }}
                .container {{ background-color: white; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }}
                h1 {{ color: #333; }}
                .info {{ background-color: #e8f4f8; padding: 15px; border-radius: 5px; margin: 10px 0; }}
                .key-count {{ font-size: 24px; color: #0066cc; font-weight: bold; }}
            </style>
        </head>
        <body>
            <div class="container">
                <h1>🔐 SSH Keys Management Demo</h1>
                <div class="info">
                    <h2>Instance Information</h2>
                    <p><strong>Hostname:</strong> {subprocess.check_output(['hostname']).decode().strip()}</p>
                    <p><strong>Current Time:</strong> {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}</p>
                </div>
                <div class="info">
                    <h2>SSH Key Statistics</h2>
                    <p>Authorized users and their SSH key counts:</p>
                    <ul>
                        {''.join([f"<li>{user}: <span class='key-count'>{count}</span> key(s)</li>" for user, count in ssh_keys.items()])}
                    </ul>
                </div>
                <div class="info">
                    <h2>Security Best Practices</h2>
                    <ul>
                        <li>✅ Use SSH keys instead of passwords</li>
                        <li>✅ Regularly rotate SSH keys</li>
                        <li>✅ Use strong key encryption (ed25519 or rsa 4096-bit)</li>
                        <li>✅ Implement proper key management procedures</li>
                    </ul>
                </div>
            </div>
        </body>
        </html>
        """
        self.wfile.write(html.encode())

# Start the server on port 8080
PORT = 8080
with socketserver.TCPServer(("", PORT), SSHInfoHandler) as httpd:
    print(f"Server running on port {PORT}")
    httpd.serve_forever()
PYTHON

# Make the script executable and create a systemd service
chmod +x /home/ssh-info-server.py

cat > /etc/systemd/system/ssh-info.service << 'SERVICE'
[Unit]
Description=SSH Info Web Server
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 /home/ssh-info-server.py
Restart=always

[Install]
WantedBy=multi-user.target
SERVICE

# Enable and start the service
systemctl daemon-reload
systemctl enable ssh-info.service
systemctl start ssh-info.service

# Log completion
echo "$(date): Startup script completed successfully!" >> /var/log/startup-script.log