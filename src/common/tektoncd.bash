#!/usr/bin/env bash

# https://cloud.google.com/sdk/docs/install#deb
function _gcloud_cli(){
    pkg="deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main"
    echo "$pkg" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    sudo apt-get install apt-transport-https ca-certificates gnupg
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
    sudo apt-get update && sudo apt-get install google-cloud-sdk
}

function _tektoncd(){
    # Configure kubectl
    kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/previous/v0.20.0/release.yaml
    kubectl apply --filename https://storage.googleapis.com/tekton-releases/dashboard/previous/v0.13.0/tekton-dashboard-release.yaml
}

function _tektoncd_status(){
    kubectl get pods -n tekton-pipelines
    kubectl get svc tekton-dashboard -n tekton-pipelines
}
