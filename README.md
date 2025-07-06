# The Thinking Cluster 🧠

> **A Personal Observability & Infrastructure Monitoring Stack**

A minimal, functioning MVP demonstrating growing skills as an Observability Engineer. This containerized monitoring stack provides comprehensive visibility into system health, resource utilization, and operational insights using industry-standard tools.

## 📌 Project Overview

**The Thinking Cluster** is a self-hosted observability platform built with Docker Compose that demonstrates practical understanding of monitoring, logging, and alerting systems. Designed for personal learning and infrastructure visibility, it showcases:

- **Simplicity**: Single `docker-compose.yml` orchestrates the entire stack
- **Modularity**: Each service has a clear, documented purpose and can be independently managed
- **Educational Value**: Real-world observability patterns implemented in a controlled environment

This project serves as a practical demonstration of DevOps/SRE principles, showing not just theoretical knowledge but hands-on implementation of production-grade monitoring tools.

## 🛠️ Key Features

### Core Monitoring Stack
- **Prometheus** - Metrics collection, storage, and alert rule evaluation
- **Node Exporter** - System-level metrics (CPU, memory, disk, network)
- **Grafana** - Visualization platform with pre-configured dashboards
- **Loki** - Log aggregation and storage system
- **Promtail** - Log collection and forwarding agent

### Operational Tools
- **Container Crash Monitoring** - Automated detection of restart loops
- **Backup Management** - Timestamped configuration and data backups
- **WSL Crash Recovery** - System state capture after unexpected shutdowns
- **Alert Rules** - Pre-configured alerting for system health indicators

### Infrastructure
- **Docker Compose** - Container orchestration and service discovery
- **Persistent Storage** - Data retention across container restarts
- **Dynamic Configuration** - Environment-aware path resolution
- **Health Checks** - Service dependency management

## 🧱 Architecture

### Deployment Model
- **Primary**: WSL2 environment with Ubuntu
- **Target**: Azure VM deployment (planned)
- **Abstraction**: Dynamic IP and home path resolution for portability

### Service Relationships
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  Promtail   │──▶|    Loki      │◄──│   Grafana   │
│ (Logs)      │    │ (Storage)   │    │ (UI)        │
└─────────────┘    └─────────────┘    └─────────────┘
                           ▲                    ▲
                           │                    │
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│Node Exporter│──▶│ Prometheus   │──▶│   Grafana   │
│ (Metrics)   │    │ (Storage)   │    │ (Dashboards)│
└─────────────┘    └─────────────┘    └─────────────┘
```

### File Structure
```
the-thinking-cluster/
├── docker-compose.yml          # Service orchestration
├── grafana/                    # Visualization layer
│   ├── dashboards/            # JSON dashboard definitions
│   └── provisioning/          # Auto-configuration
├── prometheus/                # Metrics layer
│   ├── prometheus.yml         # Scrape configuration
│   └── alert_rules.yml        # Alert definitions
├── loki/                      # Logging layer
│   └── local-config.yaml      # Log storage configuration
├── promtail/                  # Log collection
│   └── promtail-config.yaml   # Log shipping rules
├── scripts/                   # Operational automation
│   ├── backup_manager.sh      # Backup orchestration
│   ├── container_crash_monitor.sh
│   └── wsl_crash_handler.sh   # Recovery automation
└── logs/                      # Operational data
    ├── crashes/               # Crash analysis
    └── system/                # System state captures
```

## 🧑‍💻 Setup Instructions

### Prerequisites
- Docker and Docker Compose installed
- WSL2 environment (Ubuntu recommended)
- Git for repository cloning

### Quick Start
```bash
# Clone the repository
git clone <repository-url>
cd the-thinking-cluster

# Start the monitoring stack
docker compose up -d

# Verify all services are running
docker compose ps
```

![Active container list managed via Docker Compose, showing uptime and port exposure for all services.](images/Docker%20Containers.png)

### Access Points
- **Grafana Dashboard**: http://localhost:3000 (admin/admin)
- **Prometheus**: http://localhost:9090
- **Node Exporter**: http://localhost:9100

![Prometheus actively scraping metrics from Loki, Grafana, Promtail, and Node Exporter — all services are healthy and reporting in.](images/Prometheus%20Targets.png)


### Environment Considerations
- **WSL Setup**: Ensure Docker service is running in WSL
- **Bash Configuration**: May require `.bashrc` adjustments for path resolution
- **Permissions**: Services run with appropriate user contexts for WSL compatibility

## 🧠 Monitoring Philosophy

### Why Observability Matters
Modern infrastructure demands more than simple uptime monitoring. True observability provides:

- **Visibility**: Understanding what's happening across your entire system
- **Debugging**: Rapid identification of root causes when issues arise
- **Proactive Management**: Identifying trends before they become problems
- **Capacity Planning**: Data-driven decisions about resource allocation

### What This Stack Reveals
- **Resource Utilization**: CPU, memory, disk, and network patterns
- **Container Health**: Restart patterns, resource consumption, and performance
- **System Stability**: Crash detection and recovery mechanisms
- **Operational Insights**: Log patterns, error rates, and system behavior

![A unified Grafana dashboard visualizing CPU usage, memory allocation, network traffic, and disk space.](images/Grafana%20Dashboard.png)

*Data source-managed alerting rules configured via Prometheus — covering service uptime and resource thresholds.*

![Data source-managed alerting rules configured via Prometheus — covering service uptime and resource thresholds.](images/Prometheus%20Alert%20rules.png)

### Future Intent
This MVP serves as a foundation for more sophisticated observability practices:
- **OpenTelemetry Integration**: Standardized telemetry collection
- **Automated Remediation**: Self-healing container behaviors
- **Advanced Alerting**: Intelligent routing and escalation
- **Distributed Tracing**: End-to-end request flow visibility

## ⚠️ Known Limitations

### 1. Unfiltered Log Storage
**Issue**: Promtail forwards all logs without filtering, potentially causing disk bloat.
**Impact**: Storage costs and performance degradation over time.
**Mitigation**: Implement log filtering rules and retention policies.

### 2. No Real-World Use Case
**Issue**: This is an MVP stack designed for personal learning and visibility.
**Impact**: May not reflect production-scale challenges or requirements.
**Mitigation**: Expand to include real application workloads and traffic patterns.

### 3. WSL Portability Concerns
**Issue**: `.bashrc` setup not secured or abstracted for public use.
**Impact**: Security vulnerabilities and deployment complexity.
**Mitigation**: Implement secure defaults and environment abstraction.

### 4. Permission Issues
**Issue**: Root is overly permissive in current form; access control not properly scoped.
**Impact**: Security risks and potential privilege escalation.
**Mitigation**: Implement least privilege principles and proper user isolation.

## 📈 What's Next

### Immediate Priorities
- **Log Filtering**: Implement relevance-based log collection and storage
- **Security Hardening**: Secure `.bashrc` configuration and explore safe WSL defaults
- **Access Control**: Implement proper user permissions and least privilege principles

### Medium-term Goals
- **Alert Routing**: Intelligent alert distribution and escalation logic
- **Self-Healing**: Automated container recovery and health restoration
- **Performance Optimization**: Resource usage optimization and scaling strategies

### Long-term Vision
- **Distributed Deployment**: Multi-node monitoring across multiple environments
- **Advanced Analytics**: Machine learning for anomaly detection and prediction
- **Integration Ecosystem**: Connect with CI/CD pipelines and deployment tools

---


