## "Hungry Panda" Corporation, a prominent entity in the Food Chain Service sector, operates through a network of 15 branch offices across India.

### Requirements:
In response to directives from the company CTO, the decision has been made to implement infrastructure metric monitoring from the Head Office. The chosen approach involves selectively transmitting only the essential metrics to the Head Office.

#### Branch Office Specifics:
Each branch office is equipped with its dedicated local tech infrastructure.
A local server at each office operates a Kubernetes cluster, with an implemented local monitoring system overseeing node performance, incorporating custom metrics.
Additionally, all branch offices have installed the "prometheus-community/kube-prometheus-stack" in their local clusters. The local Prometheus system already gathers metrics related to the local cluster and stores them locally, including:
1. kube-state-metrics
2. node-exporter
3. kubelet

![remote-write](https://github.com/naren4b/monitoring-stack/assets/3488520/cac0fa48-c907-476d-b0f3-7d314e516db9)
