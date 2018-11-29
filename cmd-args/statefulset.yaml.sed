apiVersion: apps/v1beta1
kind: StatefulSet
metadata:
  namespace: {{.namespace}} 
  name: {{.name2}} 
  labels:
    {{.labels.key}}: {{.labels.value}}
spec:
  serviceName: "{{.name2}}"
  podManagementPolicy: Parallel
  replicas: 1
  template:
    metadata:
      labels:
        component: {{.name2}}
        {{.labels.key}}: {{.labels.value}}
    spec:
      terminationGracePeriodSeconds: 10
      initContainers:
        - name: init-{{.name2}}
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
          volumeMounts:
            - name: host-time
              mountPath: /etc/localtime
              readOnly: true
            - name: pics 
              mountPath: {{.mount.path}} 
            - name: {{.name}}-config 
              mountPath: /workspace
              readOnly: true
          command:
            - /workspace/mv.file.sh
          args:
            - -f
            - {{.from}}
            - -t
            - {{.to}}
      containers:
        - name: {{.name2}}
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
            - name: pics 
              mountPath: {{.mount.path}} 
      volumes:
        - name: host-time
          hostPath:
            path: /etc/localtime
        - name: pics 
          persistentVolumeClaim:
            claimName: {{.pvc.name}} 
        - name: {{.name}}-config 
          configMap:
            name: {{.name}}-config
            defaultMode: 0755

