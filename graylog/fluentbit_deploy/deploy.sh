#!/bin/bash
clear

#Caso use repositorio privado, adicione os campos abaixo e altera os campos "image: ":
#repo=
#repo_user=
#repo_pass=

host=$2
port=$3
if [ -z "$1" ] ; then
        echo "Opções aceitas:
                 cria = Cria ambiente de monitoramento
                 delete = Deleta ambiente de monitoramento"

elif [ "$1" = "delete" ] ; then
  echo "[+] Deletando..."
  echo "..."

elif [ -z $2 ] || [ -z $3 ] ; then
  echo "[!!] - Necessario informar opções:"
  echo ""
  echo "OPÇÔES <Informar host e porta do Graylog: "
  echo "$0 $1  <host|ip> <port>             #Porta padrão do GELF: 12201"
  exit 1
elif [ $1 = "delete" ] ; then
  echo "[+] Deletando..."

fi



cria() {

echo
ping=`ping -c 1 $host`
if [ $? -ne 0 ] ; then
        echo "[-] - $host inacessivel..."
        exit 1
fi
"./deploy.sh" 291L, 7029C
        Name record_modifier
        Match *
        Remove_key annotations
        Remove_key labels

  output-graylog.conf: |
    [OUTPUT]
        Name          gelf
        Match         *
        Host          $host
        Port          $port
        Mode          tcp
        Gelf_Short_Message_Key log

  parsers.conf: |
    [PARSER]
        Name   json
        Format json
        Time_Key time
        Time_Format %d/%b/%Y:%H:%M:%S %z

    [PARSER]
        Name        docker
        Format      json
        Time_Key    time
        Time_Format %Y-%m-%dT%H:%M:%S.%L
        # Command      |  Decoder | Field | Optional Action
        # =============|==================|=================
        Decode_Field_As   escaped    log

    [PARSER]
        Name        syslog
        Format      regex
        Regex       ^\<(?<pri>[0-9]+)\>(?<time>[^ ]* {1,2}[^ ]* [^ ]*) (?<host>[^ ]*) (?<ident>[a-zA-Z0-9_\/\.\-]*)(?:\[(?<pid>[0-9]+)\])?(?:[^\:]*\:)? *(?<message
>.*)$
        Time_Key    time
        Time_Format %b %d %H:%M:%S


EOF

cat <<EOF > dp.yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluent-bit
  namespace: monitoring
  labels:
    k8s-app: fluent-bit-logging
    version: v1
    kubernetes.io/cluster-service: "true"
spec:
  selector:
    matchLabels:
      k8s-app: fluent-bit-logging
  template:
    metadata:
      labels:
        k8s-app: fluent-bit-logging
        version: v1
        kubernetes.io/cluster-service: "true"
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "2020"
        prometheus.io/path: /api/v1/metrics/prometheus
    spec:
      imagePullSecrets:
      - name: secret-registry

      containers:
      - name: fluent-bit
        image: fluent/fluent-bit:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 2020
        env:
        Match *
        Remove_key annotations
        Remove_key labels

  output-graylog.conf: |
    [OUTPUT]
        Name          gelf
        Match         *
        Host          $host
        Port          $port
        Mode          tcp
        Gelf_Short_Message_Key log

  parsers.conf: |
    [PARSER]
        Name   json
        Format json
        Time_Key time
        Time_Format %d/%b/%Y:%H:%M:%S %z

    [PARSER]
        Name        docker
        Format      json
        Time_Key    time
        Time_Format %Y-%m-%dT%H:%M:%S.%L
        # Command      |  Decoder | Field | Optional Action
        # =============|==================|=================
        Decode_Field_As   escaped    log

    [PARSER]
        Name        syslog
        Format      regex
        Regex       ^\<(?<pri>[0-9]+)\>(?<time>[^ ]* {1,2}[^ ]* [^ ]*) (?<host>[^ ]*) (?<ident>[a-zA-Z0-9_\/\.\-]*)(?:\[(?<pid>[0-9]+)\])?(?:[^\:]*\:)? *(?<message
>.*)$
        Time_Key    time
        Time_Format %b %d %H:%M:%S


EOF

"./deploy.sh" 291L, 7024C written
[root@srv36XXX fluentbit_graylog]# ls
cm.yaml  cr.yaml  crb.yaml  deploy.sh  dp.yaml  mt.yaml  sa.yaml  static-server.yaml
[root@srv36XXX fluentbit_graylog]# cat deploy.sh
#!/bin/bash
clear

#Caso use repositorio privado, adicione os campos abaixo e altera os campos "image: ":
#repo=
#repo_user=
#repo_pass=

host=$2
port=$3
if [ -z "$1" ] ; then
        echo "Opções aceitas:
                 cria = Cria ambiente de monitoramento
                 delete = Deleta ambiente de monitoramento"

elif [ "$1" = "delete" ] ; then
  echo "[+] Deletando..."
  echo "..."

elif [ -z $2 ] || [ -z $3 ] ; then
  echo "[!!] - Necessario informar opções:"
  echo ""
  echo "OPÇÔES <Informar host e porta do Graylog: "
  echo "$0 $1  <host|ip> <port>             #Porta padrão do GELF: 12201"
  exit 1
elif [ $1 = "delete" ] ; then
  echo "[+] Deletando..."

fi



cria() {

echo
ping=`ping -c 1 $host`
if [ $? -ne 0 ] ; then
        echo "[-] - $host inacessivel..."
        exit 1
fi
pport=`echo exit | nc $host $port`
if [ $? -ne 0 ] ; then
        echo "[-] - $host acessivel, porta $port inacessivel"
        exit 1
fi

echo "[+] - Host: $host"

cat <<EOF > sa.yaml

apiVersion: v1
kind: ServiceAccount
metadata:
  name: fluent-bit
  namespace: monitoring
EOF

#cat metricbeat.yaml |sed -e "s/ES_HOST/https:\/\/$host/g" -e "s/metricsk8sdev/$imet/g" > mt.yaml


cat <<EOF > cr.yaml
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  name: fluent-bit-read
rules:
- apiGroups: [""]
  resources:
  - namespaces
  - pods
  verbs: ["get", "list", "watch"]
EOF

cat <<EOF > crb.yaml
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: fluent-bit-read
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: fluent-bit-read
subjects:
- kind: ServiceAccount
  name: fluent-bit
  namespace: monitoring
EOF

cat <<EOF > cm.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: fluent-bit-config
  namespace: monitoring

  labels:
    k8s-app: fluent-bit
data:
  # Configuration files: server, input, filters and output
  # ======================================================
  fluent-bit.conf: |
    [SERVICE]
        Flush         1
        Log_Level     info
        Daemon        off
        Parsers_File  parsers.conf
        HTTP_Server   On
        HTTP_Listen   0.0.0.0
        HTTP_Port     2020

    @INCLUDE input-kubernetes.conf
    @INCLUDE filter-kubernetes.conf
    @INCLUDE output-graylog.conf

  input-kubernetes.conf: |
    [INPUT]
        Name              tail
        Tag               kube.*
        Path              /var/log/containers/*.log
        Parser            docker
        DB                /var/log/flb_kube.db
        Mem_Buf_Limit     5MB
        Skip_Long_Lines   On
        Refresh_Interval  10

  filter-kubernetes.conf: |
    [FILTER]
        Name                kubernetes
        Match               kube.*
        Kube_URL            https://kubernetes.default.svc.cluster.local:443
        Merge_Log           On
        K8S-Logging.Parser  On

    # ${HOSTNAME} returns the host name.
    # But Fluentbit runs in a container. So, it is not meaningful.
    # Instead, copy the host name from the Kubernetes object.
    [FILTER]
        Name nest
        Match *
        Operation lift
        Nested_under kubernetes

    # Remove offending fields, see: https://github.com/fluent/fluent-bit/issues/1291
    [FILTER]
        Name record_modifier
        Match *
        Remove_key annotations
        Remove_key labels

  output-graylog.conf: |
    [OUTPUT]
        Name          gelf
        Match         *
        Host          $host
        Port          $port
        Mode          tcp
        Gelf_Short_Message_Key log

  parsers.conf: |
    [PARSER]
        Name   json
        Format json
        Time_Key time
        Time_Format %d/%b/%Y:%H:%M:%S %z

    [PARSER]
        Name        docker
        Format      json
        Time_Key    time
        Time_Format %Y-%m-%dT%H:%M:%S.%L
        # Command      |  Decoder | Field | Optional Action
        # =============|==================|=================
        Decode_Field_As   escaped    log

    [PARSER]
        Name        syslog
        Format      regex
        Regex       ^\<(?<pri>[0-9]+)\>(?<time>[^ ]* {1,2}[^ ]* [^ ]*) (?<host>[^ ]*) (?<ident>[a-zA-Z0-9_\/\.\-]*)(?:\[(?<pid>[0-9]+)\])?(?:[^\:]*\:)? *(?<message>.*)$
        Time_Key    time
        Time_Format %b %d %H:%M:%S


EOF

cat <<EOF > dp.yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluent-bit
  namespace: monitoring
  labels:
    k8s-app: fluent-bit-logging
    version: v1
    kubernetes.io/cluster-service: "true"
spec:
  selector:
    matchLabels:
      k8s-app: fluent-bit-logging
  template:
    metadata:
      labels:
        k8s-app: fluent-bit-logging
        version: v1
        kubernetes.io/cluster-service: "true"
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "2020"
        prometheus.io/path: /api/v1/metrics/prometheus
    spec:
      imagePullSecrets:
      - name: secret-registry

      containers:
      - name: fluent-bit
        image: fluent/fluent-bit:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 2020
        env:
        - name: FLUENT_ELASTICSEARCH_HOST
          value: "elasticsearch.default.svc.cluster.local"
        - name: FLUENT_ELASTICSEARCH_PORT
          value: "9200"
        volumeMounts:
        - name: varlog
          mountPath: /var/log
        - name: varlibdockercontainers
          mountPath: /var/lib/containerd/
          readOnly: true
        - name: fluent-bit-config
          mountPath: /fluent-bit/etc/
        - name: mnt
          mountPath: /mnt
          readOnly: true
      terminationGracePeriodSeconds: 10
      volumes:
      - name: varlog
        hostPath:
          path: /var/log
      - name: varlibdockercontainers
        hostPath:
          path: /var/lib/containerd/
      - name: fluent-bit-config
        configMap:
          name: fluent-bit-config
      - name: mnt
        hostPath:
          path: /mnt
      serviceAccountName: fluent-bit
#      tolerations:
#      - key: node-role.kubernetes.io/master
#        operator: Exists
#        effect: NoSchedule
EOF

kubectl create namespace monitoring
#kubectl create secret docker-registry secret-registry --docker-server=$repo --docker-username=$repo_user --docker-password=$repo_pass -n monitoring
kubectl apply -f cm.yaml
kubectl apply -f sa.yaml
kubectl apply -f cr.yaml
kubectl apply -f crb.yaml
kubectl apply -f dp.yaml
kubectl apply -f static-server.yaml
sleep 5

kubectl apply -f mt.yaml


sleep 10
kubectl get pods --namespace=monitoring
}

delete() {
kubectl delete -f cm.yaml
kubectl delete -f sa.yaml
kubectl delete -f cr.yaml
kubectl delete -f crb.yaml
kubectl delete -f dp.yaml
#kubectl delete -f metricbeat.yaml
kubectl delete -f mt.yaml
kubectl delete -f static-server.yaml
kubectl delete namespace monitoring
#for i in `sudo kubectl get node | cut -d " " -f1| grep -v NAME`; do echo $i; ssh $USERNAME@$i "sudo rm -rf /var/lib/metricbeat-data/*lock"; done
}

if [ "$1" = "cria" ] ; then
cria

elif [ "$1" = "delete" ] ; then
delete
fi
