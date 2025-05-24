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
- Alertmanager → [http://localhost:9093](http://localhost:9093)  
- Loki (API) → [http://localhost:3100](http://localhost:3100) *(used by Grafana, no UI)*

---

## 🌐 Real-Time Targets

- `WSL_Machine` — local Windows Subsystem for Linux  
- `Azure_VM` — mirrored remote instance of the stack

---

## 🧠 Why This Exists

I wanted to learn DevOps **hands-on** — not from courses or checkboxes, but by breaking real infrastructure, wiring up alerts and logs, and understanding the guts of modern systems.

---

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
