#!/bin/sh
helm dep update ../charts/proxy
helm upgrade --install \
  --set nginx-ingress.controller.service.loadBalancerIP=35.234.157.92 proxy ../charts/proxy
helm dep update ../charts/efk
helm upgrade --install efk ../charts/efk
helm dep update ../charts/log
helm upgrade --install log ../charts/log
