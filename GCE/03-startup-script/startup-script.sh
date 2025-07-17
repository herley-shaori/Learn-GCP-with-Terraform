#!/bin/bash
# Creative Startup Script: System Health Monitoring Dashboard
# This script creates an interactive web-based dashboard showing real-time system stats

# Log startup script execution
echo "[$(date)] Starting creative startup script..." | tee /var/log/startup-script.log

# Update system and install required packages
apt-get update
apt-get install -y nginx python3 python3-pip procps net-tools sysstat

# Install Python packages for system monitoring
pip3 install psutil flask

# Create dashboard directory
mkdir -p /opt/system-dashboard
cd /opt/system-dashboard

# Create the Flask application for system monitoring
cat > app.py << 'PYTHON_APP'
from flask import Flask, render_template, jsonify
import psutil
import platform
import datetime
import socket
import os

app = Flask(__name__)

def get_size(bytes, suffix="B"):
    """Scale bytes to its proper format"""
    factor = 1024
    for unit in ["", "K", "M", "G", "T", "P"]:
        if bytes < factor:
            return f"{bytes:.2f}{unit}{suffix}"
        bytes /= factor

def get_system_info():
    """Collect comprehensive system information"""
    # Basic system info
    uname = platform.uname()
    boot_time = datetime.datetime.fromtimestamp(psutil.boot_time())
    
    # CPU information
    cpu_percent = psutil.cpu_percent(interval=1)
    cpu_count = psutil.cpu_count()
    cpu_freq = psutil.cpu_freq()
    
    # Memory information
    memory = psutil.virtual_memory()
    
    # Disk information
    disk = psutil.disk_usage('/')
    
    # Network information
    hostname = socket.gethostname()
    try:
        external_ip = os.popen('curl -s http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip -H "Metadata-Flavor: Google"').read().strip()
        internal_ip = os.popen('curl -s http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip -H "Metadata-Flavor: Google"').read().strip()
        instance_name = os.popen('curl -s http://metadata.google.internal/computeMetadata/v1/instance/name -H "Metadata-Flavor: Google"').read().strip()
        zone = os.popen('curl -s http://metadata.google.internal/computeMetadata/v1/instance/zone -H "Metadata-Flavor: Google"').read().strip().split('/')[-1]
    except:
        external_ip = "N/A"
        internal_ip = "N/A"
        instance_name = hostname
        zone = "N/A"
    
    # Process information
    processes = len(psutil.pids())
    
    return {
        "timestamp": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "system": {
            "hostname": hostname,
            "instance_name": instance_name,
            "zone": zone,
            "platform": f"{uname.system} {uname.release}",
            "boot_time": boot_time.strftime("%Y-%m-%d %H:%M:%S"),
            "uptime": str(datetime.datetime.now() - boot_time).split('.')[0]
        },
        "cpu": {
            "percent": cpu_percent,
            "count": cpu_count,
            "frequency": f"{cpu_freq.current:.2f} MHz" if cpu_freq else "N/A"
        },
        "memory": {
            "percent": memory.percent,
            "used": get_size(memory.used),
            "total": get_size(memory.total),
            "available": get_size(memory.available)
        },
        "disk": {
            "percent": disk.percent,
            "used": get_size(disk.used),
            "total": get_size(disk.total),
            "free": get_size(disk.free)
        },
        "network": {
            "external_ip": external_ip,
            "internal_ip": internal_ip
        },
        "processes": processes
    }

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/stats')
def stats():
    return jsonify(get_system_info())

@app.route('/health')
def health():
    return jsonify({"status": "healthy", "timestamp": datetime.datetime.now().isoformat()})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=False)
PYTHON_APP

# Create templates directory
mkdir -p templates

# Create the HTML template with a beautiful dashboard
cat > templates/index.html << 'HTML_TEMPLATE'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🚀 GCP Instance Health Dashboard</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #333;
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        h1 {
            text-align: center;
            color: white;
            margin-bottom: 30px;
            font-size: 2.5em;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .dashboard {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }
        
        .card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            transition: transform 0.3s ease;
        }
        
        .card:hover {
            transform: translateY(-5px);
        }
        
        .card-header {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
            font-size: 1.3em;
            font-weight: bold;
            color: #667eea;
        }
        
        .icon {
            font-size: 1.5em;
            margin-right: 10px;
        }
        
        .metric {
            margin: 10px 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .metric-label {
            color: #666;
        }
        
        .metric-value {
            font-weight: bold;
            color: #333;
        }
        
        .progress-bar {
            width: 100%;
            height: 20px;
            background: #f0f0f0;
            border-radius: 10px;
            overflow: hidden;
            margin: 10px 0;
        }
        
        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #667eea, #764ba2);
            transition: width 0.5s ease;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            padding-right: 10px;
            color: white;
            font-size: 0.9em;
            font-weight: bold;
        }
        
        .status-good { color: #10b981; }
        .status-warning { color: #f59e0b; }
        .status-critical { color: #ef4444; }
        
        .refresh-info {
            text-align: center;
            color: white;
            margin-top: 20px;
            font-size: 0.9em;
        }
        
        .pulse {
            display: inline-block;
            width: 10px;
            height: 10px;
            background: #10b981;
            border-radius: 50%;
            margin-right: 5px;
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); opacity: 1; }
            50% { transform: scale(1.2); opacity: 0.7; }
            100% { transform: scale(1); opacity: 1; }
        }
        
        .startup-message {
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 15px;
            border-radius: 10px;
            text-align: center;
            margin-bottom: 20px;
            backdrop-filter: blur(10px);
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 GCP Instance Health Dashboard</h1>
        
        <div class="startup-message">
            <p>✨ This dashboard was automatically created by the startup script!</p>
            <p>📊 Real-time system monitoring with automatic refresh every 5 seconds</p>
        </div>
        
        <div class="dashboard" id="dashboard">
            <!-- Cards will be dynamically inserted here -->
        </div>
        
        <div class="refresh-info">
            <span class="pulse"></span>
            <span id="last-update">Waiting for data...</span>
        </div>
    </div>

    <script>
        function getStatusClass(percent) {
            if (percent < 70) return 'status-good';
            if (percent < 85) return 'status-warning';
            return 'status-critical';
        }
        
        function updateDashboard() {
            fetch('/api/stats')
                .then(response => response.json())
                .then(data => {
                    const dashboard = document.getElementById('dashboard');
                    dashboard.innerHTML = `
                        <!-- System Info Card -->
                        <div class="card">
                            <div class="card-header">
                                <span class="icon">💻</span>
                                System Information
                            </div>
                            <div class="metric">
                                <span class="metric-label">Instance:</span>
                                <span class="metric-value">${data.system.instance_name}</span>
                            </div>
                            <div class="metric">
                                <span class="metric-label">Zone:</span>
                                <span class="metric-value">${data.system.zone}</span>
                            </div>
                            <div class="metric">
                                <span class="metric-label">Platform:</span>
                                <span class="metric-value">${data.system.platform}</span>
                            </div>
                            <div class="metric">
                                <span class="metric-label">Uptime:</span>
                                <span class="metric-value">${data.system.uptime}</span>
                            </div>
                        </div>
                        
                        <!-- CPU Card -->
                        <div class="card">
                            <div class="card-header">
                                <span class="icon">⚡</span>
                                CPU Usage
                            </div>
                            <div class="metric">
                                <span class="metric-label">Cores:</span>
                                <span class="metric-value">${data.cpu.count}</span>
                            </div>
                            <div class="metric">
                                <span class="metric-label">Frequency:</span>
                                <span class="metric-value">${data.cpu.frequency}</span>
                            </div>
                            <div class="metric">
                                <span class="metric-label">Usage:</span>
                                <span class="metric-value ${getStatusClass(data.cpu.percent)}">${data.cpu.percent}%</span>
                            </div>
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: ${data.cpu.percent}%">
                                    ${data.cpu.percent}%
                                </div>
                            </div>
                        </div>
                        
                        <!-- Memory Card -->
                        <div class="card">
                            <div class="card-header">
                                <span class="icon">🧠</span>
                                Memory Usage
                            </div>
                            <div class="metric">
                                <span class="metric-label">Total:</span>
                                <span class="metric-value">${data.memory.total}</span>
                            </div>
                            <div class="metric">
                                <span class="metric-label">Used:</span>
                                <span class="metric-value">${data.memory.used}</span>
                            </div>
                            <div class="metric">
                                <span class="metric-label">Available:</span>
                                <span class="metric-value">${data.memory.available}</span>
                            </div>
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: ${data.memory.percent}%">
                                    ${data.memory.percent}%
                                </div>
                            </div>
                        </div>
                        
                        <!-- Disk Card -->
                        <div class="card">
                            <div class="card-header">
                                <span class="icon">💾</span>
                                Disk Usage
                            </div>
                            <div class="metric">
                                <span class="metric-label">Total:</span>
                                <span class="metric-value">${data.disk.total}</span>
                            </div>
                            <div class="metric">
                                <span class="metric-label">Used:</span>
                                <span class="metric-value">${data.disk.used}</span>
                            </div>
                            <div class="metric">
                                <span class="metric-label">Free:</span>
                                <span class="metric-value">${data.disk.free}</span>
                            </div>
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: ${data.disk.percent}%">
                                    ${data.disk.percent}%
                                </div>
                            </div>
                        </div>
                        
                        <!-- Network Card -->
                        <div class="card">
                            <div class="card-header">
                                <span class="icon">🌐</span>
                                Network Information
                            </div>
                            <div class="metric">
                                <span class="metric-label">External IP:</span>
                                <span class="metric-value">${data.network.external_ip}</span>
                            </div>
                            <div class="metric">
                                <span class="metric-label">Internal IP:</span>
                                <span class="metric-value">${data.network.internal_ip}</span>
                            </div>
                            <div class="metric">
                                <span class="metric-label">Hostname:</span>
                                <span class="metric-value">${data.system.hostname}</span>
                            </div>
                        </div>
                        
                        <!-- Process Card -->
                        <div class="card">
                            <div class="card-header">
                                <span class="icon">📊</span>
                                Process Information
                            </div>
                            <div class="metric">
                                <span class="metric-label">Active Processes:</span>
                                <span class="metric-value">${data.processes}</span>
                            </div>
                            <div class="metric">
                                <span class="metric-label">Boot Time:</span>
                                <span class="metric-value">${data.system.boot_time}</span>
                            </div>
                            <div class="metric">
                                <span class="metric-label">Last Update:</span>
                                <span class="metric-value">${data.timestamp}</span>
                            </div>
                        </div>
                    `;
                    
                    document.getElementById('last-update').textContent = `Last updated: ${data.timestamp}`;
                })
                .catch(error => console.error('Error fetching stats:', error));
        }
        
        // Initial load
        updateDashboard();
        
        // Refresh every 5 seconds
        setInterval(updateDashboard, 5000);
    </script>
</body>
</html>
HTML_TEMPLATE

# Create systemd service for the dashboard
cat > /etc/systemd/system/system-dashboard.service << 'SYSTEMD_SERVICE'
[Unit]
Description=System Health Monitoring Dashboard
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/system-dashboard
ExecStart=/usr/bin/python3 /opt/system-dashboard/app.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
SYSTEMD_SERVICE

# Enable and start the dashboard service
systemctl daemon-reload
systemctl enable system-dashboard.service
systemctl start system-dashboard.service

# Create a simple nginx configuration to proxy the dashboard
cat > /etc/nginx/sites-available/dashboard << 'NGINX_CONFIG'
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    
    server_name _;
    
    location / {
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
NGINX_CONFIG

# Enable the nginx configuration
rm -f /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/dashboard /etc/nginx/sites-enabled/
nginx -t && systemctl restart nginx

# Create a welcome message file
cat > /var/www/startup-complete.txt << 'WELCOME'
========================================
🎉 STARTUP SCRIPT COMPLETED SUCCESSFULLY! 🎉
========================================

📊 System Health Dashboard is now running!

Access the dashboard at:
- http://[EXTERNAL_IP]
- http://[EXTERNAL_IP]:8080

Features:
✅ Real-time CPU monitoring
✅ Memory usage tracking
✅ Disk space monitoring
✅ Network information display
✅ Process statistics
✅ Auto-refresh every 5 seconds

The dashboard was automatically created and
configured by the startup script!

========================================
WELCOME

# Log completion
echo "[$(date)] Startup script completed successfully!" | tee -a /var/log/startup-script.log
echo "Dashboard is accessible at port 80 and 8080" | tee -a /var/log/startup-script.log

# Create a marker file to indicate successful completion
touch /var/startup-script-completed