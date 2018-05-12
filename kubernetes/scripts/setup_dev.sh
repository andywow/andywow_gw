helm upgrade --install \
  --set nginx-ingress.controller.service.loadBalancerIP=35.234.123.86 proxy ../charts/proxy
helm upgrade --install log ../charts/log
helm upgrade --install monagent --set baseDomain=dev.andywow.xyz ../charts/monagent
