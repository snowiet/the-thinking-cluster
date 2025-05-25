# The Thinking Cluster

A comprehensive monitoring stack using Grafana, Prometheus, Loki, and more.

## 🚀 Getting Started

Clone the repo:

```bash
git clone git@github.com:snowiet/the-thinking-cluster.git
cd the-thinking-cluster
```

Bring up the stack:

```bash
docker compose up -d
```

Access services:

- Grafana → [http://localhost:3000](http://localhost:3000)  
- Prometheus → [http://localhost:9090](http://localhost:9090)  
- Node Exporter → [http://localhost:9100](http://localhost:9100)  
- Alertmanager → [http://localhost:9093](http://localhost:9093)  
- Loki (API) → [http://localhost:3100](http://localhost:3100) *(used by Grafana, no UI)*

## 📁 Project Structure

```
.
├── docker-compose.yml          # Main compose file for all services
├── grafana/                    # Grafana configuration
│   ├── provisioning/          # Auto-provisioning configs
│   │   ├── alerting/         # Alert rules and contact points
│   │   ├── dashboards/       # Dashboard definitions
│   │   └── datasources/      # Data source configurations
│   └── dashboards/           # Custom dashboard JSON files
├── prometheus/                # Prometheus configuration
│   ├── alertmanager/         # Alertmanager configs
│   ├── prometheus.yml        # Prometheus main config
│   └── promtail-config.yaml  # Promtail configuration
├── scripts/                   # Utility scripts
│   └── auto_reload_prometheus.sh
├── logs/                     # Application logs
├── config/                   # System configurations
└── backups/                  # Backup storage
```

## 🌐 Real-Time Targets

- `WSL_Machine` — local Windows Subsystem for Linux  
- `Azure_VM` — mirrored remote instance of the stack

## 🛣️ Roadmap

### ✅ Completed
- Grafana dashboards up and running  
- Exporter metrics working on WSL + Azure  
- Alerts with Alertmanager  
- Loki log aggregation (MVP working)

### 🔄 In Progress
- Dashboard provisioning via config  
- Self-healing container logic  
- Promtail filtering logic for logs

## 🔧 Maintenance

### Backup
```bash
./scripts/backup.sh
```

### Restore
```bash
./scripts/restore.sh <backup_date>
```

### Logs
- System logs: `logs/system/`
- Crash logs: `logs/crashes/`
- Kernel logs: `logs/dmesg/`

## 📝 License

MIT License - see LICENSE file for details

---
