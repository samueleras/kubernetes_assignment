$ErrorActionPreference = "Stop"

Write-Output "Stopping port-forward..."
Get-Job | Where-Object { $_.Command -match 'kubectl port-forward' } | Remove-Job -Force

Write-Output "Rolling out changes..."
kubectl rollout restart deployment kubernetes-assignment

Write-Host "Waiting for deployment rollout..."

try {

    $rolloutStatus = kubectl rollout status deployment/kubernetes-assignment --timeout=60s 2>&1

    $rolloutStatusString = $rolloutStatus -join "`n"

    if ($rolloutStatusString -match "successfully rolled out") {
        Write-Host "Deployment successful!"
    } else {
        Write-Host "Deployment failed! Rolling back..."
        kubectl rollout undo deployment kubernetes-assignment
    }
}
catch {
    Write-Host "Deployment error or timeout occurred! Rolling back..."
    kubectl rollout undo deployment kubernetes-assignment
}

Start-Job -ScriptBlock { kubectl port-forward svc/kubernetes-assignment 8080:8080 }
Write-Output "Port-forwarding started in the background."