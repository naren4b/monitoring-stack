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

### Solution

```bash
git clone https://github.com/naren4b/monitoring-stack.git
cd  monitoring-stack/ho-bo-monitoring/

```

#### At Any Office-Cluster:\*

```bash
cd ofc
bash setup.sh
bash install.sh
cd ..

kubectl port-forward -n monitoring prometheus-kps-kube-prometheus-stack-prometheus-0 9090 --address 0.0.0.0 &>/dev/null &



cd bo/vma
bash setup.sh
bash install.sh $OFC_NAME $OFC_ID $OFC_PINCODE
cd ../..




```

#### AT HO-Cluster

```bash
# Install the above Any Office-Cluster
cd ho/vmc
bash setup.sh
bash install.sh
cd ../..

kubectl port-forward -n vmc svc/vmc-victoria-metrics-cluster-vmselect 8481 --address 0.0.0.0 &>/dev/null &

host_ip=$(hostname -i)
echo open: https://{$host_ip}:8481/select/0/vmui/

```

#### Let's verify

```bash
k get ns monitoring  vmc vma
k get pod -n monitoring
k get pod -n vmc
k get pod -n vma
```

#### AT Prometehus UI & AT VMUI :

```bash
host_ip=$(hostname -i)
echo open: https://{$host_ip}:8481/select/0/vmui/
echo open: https://{$host_ip}:9090
```

#### PROM Query Language :

```bash
    - `count(up) by (job)` # it should have 1 extra
    - `count({rmrw="allowed"})`
    - '{rmrw="allowed"}'
    - '{__name__=~"up|node_cpu_seconds_total|node_memory_MemTotal_bytes|node_memory_MemAvailable_bytes|node_filesystem_free_bytes"}'
    - '{__name__=~"container_cpu_usage_seconds_total|container_memory_usage_bytes|container_memory_working_set_bytes|container_network_receive_bytes_total|container_network_transmit_bytes_total|container_cpu_cfs_throttled_seconds_total"}'
```

- Notes:
  - default OFC_NAME vma

### Ref:

- [Demo Environment](https://killercoda.com/killer-shell-cks/scenario/container-namespaces-docker)
- [monitoring-stack.git](https://github.com/naren4b/monitoring-stack/tree/main/ho-bo-monitoring)

```

```
