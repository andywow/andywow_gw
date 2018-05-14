#!/bin/sh
helm dep update ../charts/cicd
helm upgrade --install gitlab ../charts/cicd
