#!/bin/sh
helm dep update ../charts/proxy
helm upgrade --install \
  --set nginx-ingress.controller.service.loadBalancerIP=35.234.123.86 proxy ../charts/proxy
helm dep update ../charts/log
helm upgrade --install log ../charts/log
helm dep update ../charts/monagent
helm upgrade --install monagent --set baseDomain=dev.andywow.xyz ../charts/monagent
