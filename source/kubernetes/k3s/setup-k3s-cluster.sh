#!/bin/bash

# Stop and delete existing VMs
multipass stop k3s-control-plane k3s-worker-1 k3s-worker-2
multipass delete k3s-control-plane k3s-worker-1 k3s-worker-2
multipass purge

# Setup k3s cluster with 1 control plane and 2 worker nodes

# Launch the control plane node
multipass launch -n k3s-control-plane -c 2 -m 4G --cloud-init - <<EOF
#cloud-config
runcmd:
  - curl -sfL https://get.k3s.io | sh -
EOF

# Get the K3s token from the control plane node
K3S_TOKEN=$(multipass exec k3s-control-plane -- sudo cat /var/lib/rancher/k3s/server/node-token)

# Get the IP address of the control plane node
CONTROL_PLANE_IP=$(multipass info k3s-control-plane | grep IPv4 | awk '{print $2}')

# Launch the first worker node
multipass launch -n k3s-worker-1 -c 2 -m 4G --cloud-init - <<EOF
#cloud-config
runcmd:
  - curl -sfL https://get.k3s.io | K3S_URL=https://${CONTROL_PLANE_IP}:6443 K3S_TOKEN=${K3S_TOKEN} sh -
EOF

# Launch the second worker node
multipass launch -n k3s-worker-2 -c 2 -m 4G --cloud-init - <<EOF
#cloud-config
runcmd:
  - curl -sfL https://get.k3s.io | K3S_URL=https://${CONTROL_PLANE_IP}:6443 K3S_TOKEN=${K3S_TOKEN} sh -
EOF

# Retrieve the Kubeconfig file from the control plane node
multipass exec k3s-control-plane -- sudo cat /etc/rancher/k3s/k3s.yaml > k3s.yaml

# Update the server field in the Kubeconfig file
sed -i "s|https://127.0.0.1:6443|https://${CONTROL_PLANE_IP}:6443|g" k3s.yaml

# Set the KUBECONFIG environment variable
export KUBECONFIG=$PWD/k3s.yaml

# Output the status of the nodes
echo "K3s cluster with 1 control plane and 2 worker nodes is ready! You can now use kubectl to access your cluster."
kubectl get nodes