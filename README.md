The Thinking Cluster

A small personal observability lab built with Docker Compose.

This project runs a lightweight monitoring and logging stack using Prometheus, Grafana, Loki, and Node Exporter. It exists primarily as a learning environment for exploring how metrics, logs, and dashboards interact inside a real system.

The goal is not to simulate production infrastructure, but to understand the mechanics of observability tools by running them together and inspecting the data they produce.

---

📌 Project Overview

The Thinking Cluster is a self-hosted observability stack orchestrated with a single docker-compose.yml.

It currently focuses on two core telemetry signals:

---

📊 Metrics

Collected using Prometheus and Node Exporter.

---

📜 Logs

Collected using Promtail and stored in Loki.

Grafana acts as the visualization layer, allowing both signals to be explored from a single interface.

The stack runs locally in WSL2, and is intentionally small so every component can be understood individually.

---

⚙️ Design Principles

This project prioritizes simplicity and clarity over scale.

• Single Compose File
All services are orchestrated through one docker-compose.yml.

• Clear Service Boundaries
Metrics, logs, and visualization are separated into distinct services.

• Local First
Running locally makes experimentation easier and keeps the system transparent.

• Learning Through Operation
The repository acts as a record of experimenting with observability tooling.

---

🧰 Stack Components

---

📊 Metrics Pipeline

• Prometheus
Collects and stores metrics.

• Node Exporter
Exposes system metrics such as CPU, memory, disk, and network.

• Grafana
Visualizes collected metrics.

---

📜 Logging Pipeline

• Promtail
Collects logs from the host system.

• Loki
Stores and indexes logs.

• Grafana
Provides log exploration via Loki queries.

---

🖥 Deployment Environment

Current environment

• WSL2 (Ubuntu)
• Docker Compose orchestrating all services locally

Possible future direction

• Deploying the stack to a small Azure VM to observe behavior outside WSL.

---

🔎 What This Project Currently Does

• Collects host system metrics
• Aggregates logs from local services
• Visualizes metrics and logs through Grafana dashboards
• Runs the entire stack using Docker Compose

The system is intentionally small so the interactions between services remain easy to understand.

---

⚠️ Known Limitations

This is an experimental observability lab rather than a hardened monitoring system.

Current limitations include:

• Logs are not filtered or sampled
• Alerting exists but remains minimal
• Security and access control are not implemented
• The stack primarily monitors the host itself

These constraints are intentional for now, keeping the system simple while learning how each component behaves.

---

🧪 Why This Exists

Observability tooling becomes easier to understand when running locally.

This repository exists as a place to:

• experiment with Prometheus queries
• build Grafana dashboards
• explore how logs and metrics complement each other
• test small operational scripts for backup and recovery

The stack will likely evolve over time, but the primary goal remains learning how these systems behave in practice.
