apiVersion: v1
kind: Service
metadata:
  namespace: {{.namespace}}
  labels:
    component: {{.name2}} 
    {{.labels.key}}: {{.labels.value}}
  name: {{.name2}}
spec:
  type: ClusterIP 
  selector:
    component: {{.name2}}
  ports:
    - port: 8080
      targetPort: 8080 
      name: http 
---
apiVersion: v1
kind: Service
metadata:
  namespace: {{.namespace}}
  labels:
    component: {{.name1}} 
    {{.labels.key}}: {{.labels.value}}
  name: {{.name1}}
spec:
  type: ClusterIP 
  selector:
    component: {{.name1}}
  ports:
    - port: 8080
      targetPort: 8080 
      name: http 
