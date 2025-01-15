#sample how to check and validate

To check if the `cAdvisor` DaemonSet and Service have been created successfully and verify the NodePort, you can follow these steps:

### 1. Apply the Configuration

First, apply the 

cadvisor.yaml

 configuration:

```sh
kubectl apply -f path/to/your/cadvisor.yaml
```

### 2. Verify the DaemonSet

Check if the DaemonSet has been created and is running:

```sh
kubectl get daemonset cadvisor -n kube-system
```

You should see output indicating the number of desired, current, and ready pods.

### 3. Verify the Pods

Check the pods created by the DaemonSet:

```sh
kubectl get pods -n kube-system -l app=cadvisor
```

You should see a list of pods running on each node.

### 4. Verify the Service

Check if the Service has been created:

```sh
kubectl get svc cadvisor -n kube-system
```

You should see the service with the specified NodePort.

### 5. Describe the Service

Get detailed information about the Service to verify the NodePort:

```sh
kubectl describe svc cadvisor -n kube-system
```

Look for the `NodePort` field in the output to verify the port.

### 6. Verify NodePort in Node Description

Check the node description to ensure the NodePort is exposed:

```sh
kubectl describe node <node-name>
```

Replace `<node-name>` with the name of one of your nodes. Look for the `Allocated resources` section to see if the NodePort is listed.

### Example Commands

```sh
# Apply the configuration
kubectl apply -f path/to/your/cadvisor.yaml

# Verify the DaemonSet
kubectl get daemonset cadvisor -n kube-system

# Verify the pods
kubectl get pods -n kube-system -l app=cadvisor

# Verify the Service
kubectl get svc cadvisor -n kube-system

# Describe the Service
kubectl describe svc cadvisor -n kube-system

# Describe a node to check NodePort
kubectl describe node <node-name>
```

### Accessing cAdvisor Metrics

To access the cAdvisor metrics from outside the cluster, use the external IP of one of your nodes and the NodePort:

```sh
curl http://<node-ip>:30090/metrics
```

Replace `<node-ip>` with the external IP address of one of your nodes. This should allow you to access the cAdvisor metrics exposed via the NodePort.