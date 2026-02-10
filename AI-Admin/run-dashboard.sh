#!/bin/bash
# CPM Dashboard startup script with Ollama integration
cd /opt/cpm-dashboard
exec /usr/bin/python3 -c "
import eventlet
eventlet.monkey_patch()

from app import socketio, app
print('Starting CPM Dashboard with Ollama integration on port 5000')
socketio.run(app, host='127.0.0.1', port=5000, allow_unsafe_werkzeug=True)
"
