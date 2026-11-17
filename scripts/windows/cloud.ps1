# Cloud CLIs: AWS, Google Cloud and Azure. Each one is optional.
. "$PSScriptRoot\..\lib\common.ps1"

if (Confirm-Choice 'Set up AWS CLI?' -DefaultNo) {
    Install-WingetPackage -Id 'Amazon.AWSCLI' -Name 'AWS CLI'
    if (Confirm-Choice 'Configure AWS credentials now?') {
        $profileName = Read-Value 'Profile name' -Default 'default'
        if (Confirm-Choice 'Does this account use SSO (IAM Identity Center)?' -DefaultNo) {
            aws configure sso --profile $profileName
        } else {
            Write-Step 'You will be asked for Access Key ID, Secret Access Key, region (e.g. us-east-1) and output (json)'
            aws configure --profile $profileName
        }
        aws sts get-caller-identity --profile $profileName
        if ($LASTEXITCODE -ne 0) { Write-Note 'Credentials did not work; rerun this module.' }
    }
}

if (Confirm-Choice 'Set up Google Cloud CLI?' -DefaultNo) {
    Install-WingetPackage -Id 'Google.CloudSDK' -Name 'Google Cloud CLI'
    if (Confirm-Choice 'Run gcloud init (log in, choose project and region)?') { gcloud init }
    if (Confirm-Choice 'Create application-default credentials (SDKs, Terraform)?' -DefaultNo) {
        gcloud auth application-default login
    }
}

if (Confirm-Choice 'Set up Azure CLI?' -DefaultNo) {
    Install-WingetPackage -Id 'Microsoft.AzureCLI' -Name 'Azure CLI'
    if (Confirm-Choice 'Log in to Azure now?') {
        if (Confirm-Choice 'Is this machine without a browser (use device code)?' -DefaultNo) {
            az login --use-device-code
        } else {
            az login
        }
        az account show --output table
    }
}

Write-Ok 'Cloud CLIs setup done'
