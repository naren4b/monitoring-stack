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

#### At BO-Cluster:\*

```bash
cd ofc
bash setup.sh
bash install.sh
cd ..

cd bo/vma
bash setup.sh
bash install.sh $OFC_NAME $OFC_ID $OFC_PINCODE
cd ../..

k port-forward -n monitoring prometheus-kps-kube-prometheus-stack-prometheus-0 9090 --address 0.0.0.0 &>/dev/null &
host_ip=$(hostname -i)
echo open: https://{$host_ip}:9090

```

#### AT HO-Cluster

```bash
cd ofc
bash setup.sh
bash install.sh
cd ..

cd bo/vma
bash setup.sh
bash install.sh $OFC_NAME $OFC_ID $OFC_PINCODE
cd ../..

cd ho/vmc
bash setup.sh
bash install.sh
cd ../..

k port-forward -n vmc svc/vmc-victoria-metrics-cluster-vmselect 8481 --address 0.0.0.0 &>/dev/null &

host_ip=$(hostname -i)
echo open: https://{$host_ip}:8481/select/0/vmui/

```

- Notes:

* If you are doing everything in single cluster for testing then ignore instaling ofc/ and vma/ again

### Ref:

- [Demo Environment](https://killercoda.com/killer-shell-cks/scenario/container-namespaces-docker)
- [monitoring-stack.git](https://github.com/naren4b/monitoring-stack/tree/main/ho-bo-monitoring)
