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
├── README.md
├── alertmanager
│   └── alertmanager.yml
├── backups
├── docker-compose.yml
├── grafana
│   ├── dashboards
│   │   └── Essentials.json
│   └── provisioning
│       ├── alerting
│       │   ├── contact-points.yml.bak
│       │   ├── notification-policies.yml.bak
│       │   └── notification-templates.yml.bak
│       ├── dashboards
│       │   └── dashboards.yml
│       └── datasources
│           └── datasource.yml
├── logs
│   ├── crashes
│   └── system
├── prometheus
│   ├── alert_rules.yml
│   ├── alertmanager
│   └── prometheus.yml
├── promtail
│   └── promtail-config.yaml
└── scripts
    ├── backup_manager.sh
    └── wsl_crash_handler.sh
```

## 🛠️ Scripts

### `wsl_crash_handler.sh`
- Handles WSL crashes and recovery
- Monitors system stability
- Automatically restarts services if needed

### `backup_manager.sh`
- Manages system backups
- Creates timestamped backups
- Handles backup rotation

### `edit_local_bash.sh`
- Edits local bash configuration
- Updates environment variables
- Manages shell aliases

### `setup_bashrc.sh`
- Sets up bash environment
- Configures shell preferences
- Installs required tools

## ⚠️ Known Issues

### Grafana Alerting
- Alerting system is currently disabled
- Contact points configuration needs to be fixed
- Alert rules provisioning is pending

## 🔄 Maintenance

### Backup
```bash
./scripts/backup_manager.sh
```

### Logs
- System logs: `logs/system/`
- Crash logs: `logs/crashes/`
- Kernel logs: `logs/dmesg/`

## 🛣️ Roadmap

### ✅ Completed
- Grafana dashboards up and running  
- Exporter metrics working on WSL + Azure  
- Loki log aggregation (MVP working)
- Basic monitoring setup

### 🔄 In Progress
- Fix Grafana alerting system
- Implement proper backup rotation
- Enhance WSL crash handling
- Improve log management

### 📋 Planned
- Dashboard provisioning via config  
- Self-healing container logic  
- Promtail filtering logic for logs
- Automated backup testing
