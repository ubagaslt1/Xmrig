#!/bin/sh

# Generate config file
cat > /app/config/config.json << EOF
{
    "autosave": true,
    "cpu": true,
    "opencl": false,
    "cuda": false,
    "pools": [{
        "url": "${POOL_URL}",
        "user": "${WALLET_ADDRESS}",
        "pass": "${POOL_PASS}",
        "tls": true,
        "keepalive": true,
        "nicehash": false
    }],
    "api": {
        "port": 8080,
        "access-token": null,
        "worker-id": "umbrel",
        "ipv6": false,
        "restricted": false
    },
    "background": ${BACKGROUND_MINING},
    "max-cpu-usage": ${MAX_CPU_USAGE},
    "safe": false,
    "av": 0,
    "donate-level": ${DONATE_LEVEL},
    "log-file": "/app/logs/xmrig.log"
}
EOF

# Start XMRig with config
exec xmrig --config=/app/config/config.json
