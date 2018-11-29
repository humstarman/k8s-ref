kind: Deployment 
apiVersion: extensions/v1beta1
metadata:
  namespace: {{.namespace}} 
  name: {{.name1}} 
  labels:
    {{.labels.key}}: {{.labels.value}}
spec:
  replicas: 1
  template:
    metadata:
      labels:
        component: {{.name1}}
        {{.labels.key}}: {{.labels.value}}
    spec:
      containers:
        - name: {{.name1}}
          image: {{.local.registry}}/{{.name}}:{{.tag}}
          imagePullPolicy: {{.image.pull.policy}} 
          env:
            - name: POD_IP
              valueFrom:
                fieldRef:
                  fieldPath: status.podIP
            - name: POD_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
          ports:
            - containerPort: 8080 
              name: http
          livenessProbe:
            httpGet:
              path: /THPBuilder
              port: http
            initialDelaySeconds: 30
            periodSeconds: 10
          volumeMounts:
            - name: host-time
              mountPath: /etc/localtime
              readOnly: true
      volumes:
        - name: host-time
          hostPath:
            path: /etc/localtime
