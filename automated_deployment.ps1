$ErrorActionPreference = "Stop"

Write-Output "Rolling out changes..."
kubectl rollout restart deployment kubernetes-assignment

Write-Host "Waiting for deployment rollout..."
$rolloutStatus = kubectl rollout status deployment/kubernetes-assignment --timeout=60s

# Check if rollout was successful
if ($rolloutStatus -match "successfully rolled out") {
    Write-Host "Deployment successful!"
} else {
    Write-Host "Deployment failed! Rolling back..."
    kubectl rollout undo deployment kubernetes-assignment
}

Get-Job | Where-Object { $_.Command -match 'kubectl port-forward' } | Remove-Job -Force

Start-Sleep -Seconds 10

Start-Job -ScriptBlock { kubectl port-forward svc/kubernetes-assignment 8080:8080 }
Write-Output "Port forwarded and reachable."