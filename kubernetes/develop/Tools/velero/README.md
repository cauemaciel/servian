export BUCKET="tidas-velero-backup-homolog"
export REGION="us-central1"
export PROJECT_ID="upheld-dragon-237812"

gcloud config set project $PROJECT_ID
gcloud iam service-accounts create velero-homolog --display-name "Velero service account"
gcloud iam service-accounts list

gsutil mb gs://$BUCKET/

export SERVICE_ACCOUNT_EMAIL=$(gcloud iam service-accounts list \
  --filter="displayName:Velero service account" \
  --format 'value(email)')

export ROLE_PERMISSIONS=(
    compute.disks.get
    compute.disks.create
    compute.disks.createSnapshot
    compute.snapshots.get
    compute.snapshots.create
    compute.snapshots.useReadOnly
    compute.snapshots.delete
    compute.zones.get
)

gcloud iam roles create velero.server \
    --project $PROJECT_ID \
    --title "Velero Server" \
    --permissions "$(IFS=","; echo "${ROLE_PERMISSIONS[*]}")"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member serviceAccount:$SERVICE_ACCOUNT_EMAIL \
    --role projects/$PROJECT_ID/roles/velero.server

gsutil iam ch serviceAccount:$SERVICE_ACCOUNT_EMAIL:objectAdmin gs://${BUCKET}

gcloud iam service-accounts keys create credentials-velero --iam-account $SERVICE_ACCOUNT_EMAIL


velero install \
    --provider gcp \
    --plugins velero/velero-plugin-for-gcp:v1.2.0 \
    --bucket $BUCKET \
    --secret-file credentials-velero


kubectl -n velero get pods
kubectl logs deployment/velero -n velero

# velero backup create temp-backup --include-namespaces escriba-production

# velero create restore restore-workloads --from-backup temp-backup-1-180322
