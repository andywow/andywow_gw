helm upgrade --install \
  --set nginx-ingress.controller.service.loadBalancerIP=35.234.157.92 proxy ../charts/proxy
helm upgrade --install efk ../charts/efk
helm upgrade --install log ../charts/log
