> ⚠️ **Note:** This project is currently under active construction as part of a learning initiative.  
> I'm prioritizing building over documentation until it's stable enough to write about.  
> Last update: **29 May 2025**

# The Thinking Cluster

A comprehensive monitoring stack using Grafana, Prometheus, Loki, Promtail, and Alertmanager.

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
- Loki → [http://localhost:3101](http://localhost:3101) (API for Grafana, direct UI available at `/loki/api/v1/status` or similar, depending on version)
- Promtail → (No direct access - ships logs to Loki)

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
│       ├── dashboards
│       │   └── dashboards.yml
│       └── datasources
│           └── datasource.yml
├── loki
│   └── local-config.yaml
├── loki-data
├── logs
│   ├── crashes
│   └── system
├── prometheus
│   ├── alert_rules.yml
│   └── prometheus.yml
├── promtail
│   └── promtail-config.yaml
└── scripts
    ├── backup_manager.sh
    ├── container_crash_monitor.sh
    └── wsl_crash_handler.sh
```

## 🛠️ Scripts

### `wsl_crash_handler.sh`
- Detects whether the system has closed abruptly
- Captures and saves system + wsl logs to the logs directory

### `backup_manager.sh`
- Supports creation of timestamped backups
- Handles both configuration and data backups

### `container_crash_monitor.sh`
- Detects containers in restarting state
- Captures and saves container logs to the logs directory

## ⚠️ Known Issues

### Grafana Alerting
- Contact points configuration may require verification or updates.
- Ensure alert rules are correctly provisioned and tested.

## 🔄 Maintenance

### Backup
To create a backup:
```bash
./scripts/backup_manager.sh
```
Review `backup_manager.sh` for specific backup locations and rotation settings.

### Logs
- System logs: `logs/system/`
- Crash logs: `logs/crashes/`
- Application logs for Loki are stored in the `loki-data` volume.
- Check Promtail configuration (`promtail/promtail-config.yaml`) for log shipping paths.

## 🛣️ Roadmap

### ✅ Completed
- Grafana dashboards operational.
- Node Exporter metrics collection functional (WSL + Azure if applicable).
- Loki log aggregation (basic setup working).
- Core monitoring stack (Prometheus, Grafana, Alertmanager) established.

### 🔄 In Progress
- Implementing robust backup rotation within `backup_manager.sh`.
- Enhancing `wsl_crash_handler.sh` for more comprehensive recovery.
- Improving log management strategies and configurations.

### 📋 Planned
- Dashboard provisioning via config  
- Self-healing container logic  
- Promtail filtering logic for logs
- Automated backup testing
