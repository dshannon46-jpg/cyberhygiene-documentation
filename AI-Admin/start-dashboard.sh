#!/bin/bash
# Wrapper script to start CyberHygiene AI Dashboard

cd /home/dshannon/cyberhygiene-ai-admin
source venv/bin/activate
exec python3 -c "from web.app import main; main(host='0.0.0.0', port=5500, debug=False)"
