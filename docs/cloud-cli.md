# Cloud CLIs

Setup is automated by the `cloud` module. It asks which CLIs you want (AWS, Google Cloud, Azure), installs them and runs the login for each one.

## AWS CLI

The module runs `aws configure --profile NAME` (or `aws configure sso`). Credentials go to `~/.aws/credentials`, settings to `~/.aws/config`.

Several accounts: one profile each.

```bash
aws configure --profile work
aws s3 ls --profile work
```

Set a profile for the whole session. Linux:

```bash
export AWS_PROFILE=work
```

Windows:

```powershell
$env:AWS_PROFILE = "work"
```

Useful commands:

```bash
aws sts get-caller-identity
aws configure list
aws s3 ls
aws s3 cp file.txt s3://my-bucket/
aws ec2 describe-instances --query "Reservations[].Instances[].InstanceId"
aws sso login --profile work
```

## Google Cloud CLI

The module runs `gcloud init` (browser login, project, region) and optionally `gcloud auth application-default login` for SDKs and Terraform.

```bash
gcloud config set project PROJECT_ID
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-a
gcloud config list
gcloud projects list
gcloud compute instances list
gcloud auth list
gcloud components update
```

Several setups (accounts or projects): use configurations.

```bash
gcloud config configurations create work
gcloud config configurations activate work
gcloud config configurations list
```

## Azure CLI

The module runs `az login` (or `az login --use-device-code` on machines without a browser).

```bash
az account list --output table
az account set --subscription "NAME_OR_ID"
az account show
az group list --output table
az vm list --output table
az webapp list --output table
az configure
```

## Troubleshooting

- Command not found right after installing: open a new terminal so it picks up the new PATH.
- AWS `Unable to locate credentials`: the profile does not exist. Check `aws configure list` and `AWS_PROFILE`.
- AWS `AccessDenied`: the user or role lacks that IAM permission.
- AWS `You must specify a region`: add `--region us-east-1` or set it in the profile.
- AWS SSO or temporary credentials expired: `aws sso login --profile NAME`.
- gcloud `problem refreshing your current auth tokens`: run `gcloud auth login` again.
- gcloud acting on the wrong project: `gcloud config get-value project`.
- gcloud API disabled: `gcloud services enable NAME.googleapis.com`.
- az login opens the browser but never finishes: use `az login --use-device-code`.
- az acting on the wrong resources: check the active subscription with `az account show`.
