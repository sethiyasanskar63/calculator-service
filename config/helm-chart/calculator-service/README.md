# Calculator Service Helm Chart

This Helm chart deploys the Calculator microservice to Kubernetes.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- Docker image built and pushed to registry

## Installing the Chart

### Install with default values
```bash
helm install my-calculator ./calculator-service
```

### Install with custom values
```bash
helm install my-calculator ./calculator-service -f values-prod.yaml
```

### Install with inline value overrides
```bash
helm install my-calculator ./calculator-service \
  --set replicaCount=5 \
  --set image.tag=v2.0.0
```

## Upgrading the Chart

```bash
# Upgrade with new values
helm upgrade my-calculator ./calculator-service -f values-prod.yaml

# Upgrade with new image version
helm upgrade my-calculator ./calculator-service --set image.tag=v2.0.0
```

## Uninstalling the Chart

```bash
helm uninstall my-calculator
```

## Configuration

The following table lists the configurable parameters of the Calculator Service chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `3` |
| `image.repository` | Image repository | `sethiyasanskar63/calculator-service` |
| `image.tag` | Image tag | `latest` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `service.type` | Service type | `ClusterIP` |
| `service.port` | Service port | `80` |
| `service.targetPort` | Container port | `8080` |
| `ingress.enabled` | Enable ingress | `true` |
| `ingress.className` | Ingress class name | `nginx` |
| `resources.limits.cpu` | CPU limit | `500m` |
| `resources.limits.memory` | Memory limit | `512Mi` |
| `resources.requests.cpu` | CPU request | `250m` |
| `resources.requests.memory` | Memory request | `256Mi` |
| `autoscaling.enabled` | Enable HPA | `false` |
| `autoscaling.minReplicas` | Minimum replicas | `2` |
| `autoscaling.maxReplicas` | Maximum replicas | `10` |

## Examples

### Development Deployment
```bash
helm install calc-dev ./calculator-service -f values-dev.yaml
```

### Production Deployment
```bash
helm install calc-prod ./calculator-service -f values-prod.yaml
```

### Testing Changes (Dry Run)
```bash
helm install my-calculator ./calculator-service --dry-run --debug
```

### Check Deployment Status
```bash
helm status my-calculator
helm list
kubectl get pods -l app.kubernetes.io/name=calculator-service
```

### View Deployment History
```bash
helm history my-calculator
```

### Rollback to Previous Version
```bash
helm rollback my-calculator
```

### Rollback to Specific Revision
```bash
helm rollback my-calculator 2
```

## Accessing the Application

After installation, you can access the application:

### Port Forward (for testing)
```bash
kubectl port-forward svc/calculator-service 8080:80
curl http://localhost:8080/api/calculator/health
```

### Via Ingress (if enabled)
```bash
# Add to /etc/hosts (Windows: C:\Windows\System32\drivers\etc\hosts)
127.0.0.1 calculator.local

# Access via browser
http://calculator.local/api/calculator/health
```

## Troubleshooting

### Check Pod Status
```bash
kubectl get pods -l app.kubernetes.io/instance=my-calculator
```

### View Pod Logs
```bash
kubectl logs -l app.kubernetes.io/instance=my-calculator
```

### Describe Deployment
```bash
kubectl describe deployment -l app.kubernetes.io/instance=my-calculator
```

### Check Helm Release
```bash
helm get values my-calculator
helm get manifest my-calculator
```

## Common Issues

### ImagePullBackOff
- Verify image exists in registry
- Check `imagePullSecrets` if using private registry

### CrashLoopBackOff
- Check pod logs: `kubectl logs <pod-name>`
- Verify resource limits
- Check health probe endpoints

### Pending Pods
- Check node resources: `kubectl describe nodes`
- Verify resource requests are within node capacity
