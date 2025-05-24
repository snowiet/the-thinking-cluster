# 🧠 The Thinking Cluster

> My evolving DevOps playground. A home-brewed, crash-tolerant, load-balanced monitoring stack built for learning, breaking, and documenting the journey.

---

## 🌟 Overview

**The Thinking Cluster** is a modular observability lab designed to monitor real systems (my WSL and Azure VM) using:

- 🧪 **Prometheus** — metrics scraping  
- 📊 **Grafana** — dashboards and visualization  
- 📢 **Alertmanager** — alert routing  
- 🧾 **Node Exporter** — Linux system metrics  
- ⚙️ **Docker Compose** — reproducible infra setup  
- 💥 **dmesg crash logs** — captured and archived for post-mortem analysis

---

## 📁 Project Structure

```
compose/             # Docker stack configs
scripts/             # Custom boot-time & crash-capture scripts
logs/dmesg/          # Captured crash logs (dmesg)
snapshots/           # Grafana dashboard backups (coming soon)
backups/prometheus/  # Prometheus TSDB snapshots (optional)
```

---

## 🚀 Getting Started

Clone the repo:

```bash
git clone git@github.com:snowiet/the-thinking-cluster.git
cd the-thinking-cluster
```

Bring up the stack:

```bash
docker-compose -f compose/monitoring/docker-compose.yml up -d
```

Access services:

- Grafana → [http://localhost:3000](http://localhost:3000)  
- Prometheus → [http://localhost:9090](http://localhost:9090)  
- Node Exporter → [http://localhost:9100](http://localhost:9100)
- Alert Manager -> [http://localhost:9093](http://localhost:9093)

---

## 🌐 Real-Time Targets

- `WSL_Machine` — your local Windows Subsystem for Linux  
- `Azure_VM` — external cloud machine, same stack mirrored

---

## 🧠 Why This Exists

I wanted to learn DevOps **hands-on** — not from courses or checkboxes, but by breaking real infrastructure, wiring up alerts, and understanding the guts of modern systems.

---

## 🛣️ Roadmap

### ✅ Completed
- Grafana dashboards up and running  
- Exporter metrics working on WSL + Azure
- Alerts with Alertmanager

### 🔄 In Progress
- Loki log aggregation  
- Dashboard provisioning via config  
- Self-healing container logic

---

> 🗣️ *“Show your work.” — Austin Kleon*
