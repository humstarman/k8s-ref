apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: {{.name}} 
  namespace: {{.namespace}} 
  labels:
    {{.labels.key}}: {{.labels.value}}
spec:
  rules:
  - host: {{.url1}} 
    http:
      paths:
      - path: /
        backend:
          serviceName: {{.name1}} 
          servicePort: 8080 
  - host: {{.url2}} 
    http:
      paths:
      - path: /
        backend:
          serviceName: {{.name2}} 
          servicePort: 8080 
