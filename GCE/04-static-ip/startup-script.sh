#!/bin/bash
# Creative Startup Script: IP Information Service
# This script creates a service that demonstrates static IP persistence

# Log startup script execution
echo "[$(date)] Starting IP information service setup..." | tee /var/log/startup-script.log

# Update system and install required packages
apt-get update
apt-get install -y nginx python3 python3-pip curl jq

# Install Python packages
pip3 install flask requests

# Create service directory
mkdir -p /opt/ip-info-service
cd /opt/ip-info-service

# Create the Flask application
cat > app.py << 'PYTHON_APP'
from flask import Flask, render_template, jsonify
import requests
import datetime
import socket
import os
import json

app = Flask(__name__)

def get_instance_metadata():
    """Get GCP instance metadata"""
    headers = {'Metadata-Flavor': 'Google'}
    base_url = 'http://metadata.google.internal/computeMetadata/v1/instance'
    
    try:
        # Get various metadata
        external_ip = requests.get(f'{base_url}/network-interfaces/0/access-configs/0/external-ip', headers=headers).text
        internal_ip = requests.get(f'{base_url}/network-interfaces/0/ip', headers=headers).text
        instance_name = requests.get(f'{base_url}/name', headers=headers).text
        zone = requests.get(f'{base_url}/zone', headers=headers).text.split('/')[-1]
        machine_type = requests.get(f'{base_url}/machine-type', headers=headers).text.split('/')[-1]
        
        # Check if this is a static IP
        access_configs = requests.get(f'{base_url}/network-interfaces/0/access-configs/0/?recursive=true', headers=headers).text
        access_config = json.loads(access_configs)
        ip_type = "Static (Reserved)" if access_config.get('type') == 'ONE_TO_ONE_NAT' and 'natIP' in access_config else "Ephemeral"
        
        return {
            'external_ip': external_ip,
            'internal_ip': internal_ip,
            'instance_name': instance_name,
            'zone': zone,
            'machine_type': machine_type,
            'ip_type': ip_type,
            'hostname': socket.gethostname()
        }
    except Exception as e:
        return {
            'error': str(e),
            'external_ip': 'Unable to fetch',
            'internal_ip': 'Unable to fetch',
            'instance_name': socket.gethostname(),
            'zone': 'Unknown',
            'machine_type': 'Unknown',
            'ip_type': 'Unknown'
        }

def get_ip_persistence_info():
    """Get information about IP persistence"""
    try:
        # Read startup timestamp if exists
        startup_file = '/var/ip-service-started'
        if os.path.exists(startup_file):
            with open(startup_file, 'r') as f:
                first_startup = f.read().strip()
        else:
            first_startup = datetime.datetime.now().isoformat()
            with open(startup_file, 'w') as f:
                f.write(first_startup)
        
        # Calculate uptime
        boot_time_str = os.popen('uptime -s').read().strip()
        boot_time = datetime.datetime.strptime(boot_time_str, '%Y-%m-%d %H:%M:%S')
        uptime = str(datetime.datetime.now() - boot_time).split('.')[0]
        
        return {
            'first_startup': first_startup,
            'current_time': datetime.datetime.now().isoformat(),
            'boot_time': boot_time.isoformat(),
            'uptime': uptime
        }
    except Exception as e:
        return {
            'error': str(e),
            'first_startup': 'Unknown',
            'current_time': datetime.datetime.now().isoformat(),
            'boot_time': 'Unknown',
            'uptime': 'Unknown'
        }

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/info')
def api_info():
    metadata = get_instance_metadata()
    persistence = get_ip_persistence_info()
    
    return jsonify({
        'instance': metadata,
        'persistence': persistence,
        'message': 'This demonstrates static IP reservation in GCP'
    })

@app.route('/health')
def health():
    return jsonify({
        'status': 'healthy',
        'service': 'IP Information Service',
        'timestamp': datetime.datetime.now().isoformat()
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=False)
PYTHON_APP

# Create templates directory
mkdir -p templates

# Create the HTML template
cat > templates/index.html << 'HTML_TEMPLATE'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🌐 Static IP Information Service</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: #333;
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1000px;
            margin: 0 auto;
        }
        
        h1 {
            text-align: center;
            color: white;
            margin-bottom: 10px;
            font-size: 2.5em;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .subtitle {
            text-align: center;
            color: #e0e0e0;
            margin-bottom: 30px;
            font-size: 1.2em;
        }
        
        .main-card {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            margin-bottom: 20px;
        }
        
        .ip-display {
            text-align: center;
            margin: 30px 0;
            padding: 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            color: white;
        }
        
        .ip-address {
            font-size: 3em;
            font-weight: bold;
            margin: 10px 0;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }
        
        .ip-type {
            font-size: 1.5em;
            margin-top: 10px;
            padding: 10px 20px;
            background: rgba(255,255,255,0.2);
            border-radius: 25px;
            display: inline-block;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }
        
        .info-item {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            border-left: 4px solid #667eea;
        }
        
        .info-label {
            color: #666;
            font-size: 0.9em;
            margin-bottom: 5px;
        }
        
        .info-value {
            font-size: 1.2em;
            font-weight: bold;
            color: #333;
        }
        
        .persistence-info {
            background: #e8f4f8;
            padding: 25px;
            border-radius: 10px;
            margin: 20px 0;
            border: 2px dashed #4a90e2;
        }
        
        .refresh-btn {
            background: #667eea;
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 25px;
            font-size: 1.1em;
            cursor: pointer;
            display: block;
            margin: 20px auto;
            transition: all 0.3s ease;
        }
        
        .refresh-btn:hover {
            background: #764ba2;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .loading {
            text-align: center;
            padding: 40px;
            font-size: 1.2em;
            color: #666;
        }
        
        .static-ip-benefits {
            background: #f0f7ff;
            padding: 20px;
            border-radius: 10px;
            margin-top: 20px;
        }
        
        .benefit-list {
            list-style: none;
            padding: 0;
        }
        
        .benefit-list li {
            padding: 10px 0;
            padding-left: 30px;
            position: relative;
        }
        
        .benefit-list li:before {
            content: "✅";
            position: absolute;
            left: 0;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        
        .pulse {
            animation: pulse 2s infinite;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🌐 Static IP Information Service</h1>
        <p class="subtitle">Demonstrating GCP Reserved Static IP Address</p>
        
        <div class="main-card">
            <div id="loading" class="loading">Loading IP information...</div>
            <div id="content" style="display: none;">
                <div class="ip-display pulse">
                    <div class="info-label" style="color: white;">External IP Address</div>
                    <div class="ip-address" id="external-ip">-</div>
                    <div class="ip-type" id="ip-type">-</div>
                </div>
                
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">Instance Name</div>
                        <div class="info-value" id="instance-name">-</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Internal IP</div>
                        <div class="info-value" id="internal-ip">-</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Zone</div>
                        <div class="info-value" id="zone">-</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Machine Type</div>
                        <div class="info-value" id="machine-type">-</div>
                    </div>
                </div>
                
                <div class="persistence-info">
                    <h3>📌 IP Persistence Information</h3>
                    <p style="margin-top: 15px;">
                        <strong>Service First Started:</strong> <span id="first-startup">-</span><br>
                        <strong>Current Instance Uptime:</strong> <span id="uptime">-</span><br>
                        <strong>Current Time:</strong> <span id="current-time">-</span>
                    </p>
                    <p style="margin-top: 15px; font-style: italic;">
                        💡 With a static IP, this address remains the same even if you stop/start or recreate the instance!
                    </p>
                </div>
                
                <div class="static-ip-benefits">
                    <h3>🎯 Benefits of Static IP Reservation</h3>
                    <ul class="benefit-list">
                        <li>IP address persists across instance restarts</li>
                        <li>DNS records remain valid</li>
                        <li>Firewall rules don't need updates</li>
                        <li>API integrations stay consistent</li>
                        <li>SSL certificates remain valid</li>
                    </ul>
                </div>
                
                <button class="refresh-btn" onclick="loadInfo()">🔄 Refresh Information</button>
            </div>
        </div>
    </div>

    <script>
        function loadInfo() {
            document.getElementById('loading').style.display = 'block';
            document.getElementById('content').style.display = 'none';
            
            fetch('/api/info')
                .then(response => response.json())
                .then(data => {
                    // Update instance information
                    document.getElementById('external-ip').textContent = data.instance.external_ip;
                    document.getElementById('ip-type').textContent = data.instance.ip_type;
                    document.getElementById('instance-name').textContent = data.instance.instance_name;
                    document.getElementById('internal-ip').textContent = data.instance.internal_ip;
                    document.getElementById('zone').textContent = data.instance.zone;
                    document.getElementById('machine-type').textContent = data.instance.machine_type;
                    
                    // Update persistence information
                    document.getElementById('first-startup').textContent = 
                        new Date(data.persistence.first_startup).toLocaleString();
                    document.getElementById('uptime').textContent = data.persistence.uptime;
                    document.getElementById('current-time').textContent = 
                        new Date(data.persistence.current_time).toLocaleString();
                    
                    // Show content
                    document.getElementById('loading').style.display = 'none';
                    document.getElementById('content').style.display = 'block';
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('loading').textContent = 'Error loading information';
                });
        }
        
        // Load information on page load
        window.onload = loadInfo;
        
        // Auto-refresh every 30 seconds
        setInterval(loadInfo, 30000);
    </script>
</body>
</html>
HTML_TEMPLATE

# Create systemd service
cat > /etc/systemd/system/ip-info-service.service << 'SYSTEMD_SERVICE'
[Unit]
Description=IP Information Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/ip-info-service
ExecStart=/usr/bin/python3 /opt/ip-info-service/app.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
SYSTEMD_SERVICE

# Enable and start the service
systemctl daemon-reload
systemctl enable ip-info-service.service
systemctl start ip-info-service.service

# Configure nginx to proxy the service
cat > /etc/nginx/sites-available/ip-info << 'NGINX_CONFIG'
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
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
NGINX_CONFIG

# Enable nginx configuration
rm -f /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/ip-info /etc/nginx/sites-enabled/
nginx -t && systemctl restart nginx

# Create a marker file
touch /var/startup-script-completed

# Log completion
echo "[$(date)] IP Information Service setup completed!" | tee -a /var/log/startup-script.log
echo "Service is accessible at port 80 and 8080" | tee -a /var/log/startup-script.log