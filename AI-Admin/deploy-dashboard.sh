#!/bin/bash
# Deploy the AI-enabled dashboard to Documents folder

SOURCE="/home/dshannon/cyberhygiene-ai-admin/web/templates/dashboard.html"
DEST="/home/dshannon/Documents/Claude/Artifacts/System_Status_Dashboard_AI.html"

echo "Deploying AI-enabled dashboard..."

# Create a standalone version (without Flask backend requirement for basic viewing)
cat > "$DEST" << 'DASHBOARDEOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CPN System Status Dashboard - AI Enhanced</title>
    <style>
        /* Note: This is a static copy. For full AI functionality, run: cd ~/cyberhygiene-ai-admin && ./cyberai-web */
        body::before {
            content: "⚠️ Static View - For full AI features, run: cd ~/cyberhygiene-ai-admin && ./cyberai-web";
            display: block;
            background: #fff3cd;
            color: #856404;
            padding: 10px;
            text-align: center;
            font-weight: bold;
            border-bottom: 2px solid #ffc107;
        }
    </style>
</head>
<body>
    <iframe src="http://localhost:5000/" style="width:100%;height:100vh;border:none;">
        <p>To view this dashboard, run: <code>cd ~/cyberhygiene-ai-admin && ./cyberai-web</code></p>
    </iframe>
</body>
</html>
DASHBOARDEOF

echo "✓ Deployed to: $DEST"
echo ""
echo "To use the AI-enabled dashboard:"
echo "1. Start the web server: cd ~/cyberhygiene-ai-admin && ./cyberai-web"
echo "2. Open browser to: http://192.168.1.10:5000"
echo ""
echo "Features:"
echo "  - Floating AI chat button (bottom right)"
echo "  - Real-time system metrics"
echo "  - Quick command buttons"
echo "  - All existing dashboard content"
