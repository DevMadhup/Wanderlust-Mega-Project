# How to install ingress controller using manifest file
#
> [!Note]
> In AWS, we use a Network load balancer (NLB) to expose the Ingress-Nginx Controller behind a Service of Type=LoadBalancer.
#

## Steps:
- Go to <a href="https://kubernetes.github.io/ingress-nginx/deploy/#aws"> Nginx Ingress Controller </a> and read more about ingress controller or simply copy paste the below command to setup ingress controller
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.2/deploy/static/provider/aws/deploy.yaml
```
#
- And Done!!!


