#!/bin/bash

# All intermediate functions are defined in utils.sh
source scripts/utils.sh

version=${PORTAL_VERSION}
accessType=${ACCESS_TYPE}
namespace=${NAMESPACE}
installation_mode=${INSTALLATION_MODE}
personal_access_token=${PAT}

license=${LICENSE}

echo "$license" | base64 --decode > Cypress/cypress/fixtures/cn-license.txt

# echo -e "\n-----------Cloning CLE Repository------------------\n"
# git clone https://${personal_access_token}@github.com/chaosnative/cle.git


function install_portal_cs_mode() {

    echo -e "\n---------------Installing CLE in Cluster Scope----------\n"

    # manifest_image_update $version ./manifests/cluster-k8s-manifest.yml

    kubectl apply -f ./manifests/cluster-k8s-manifest.yml
}

function install_portal_ns_mode(){

    echo -e "\n---------------Installing CLE in Namespaced Scope----------\n"

    kubectl create ns ${namespace}

    # Installing CRD's, required for namespaced mode
    kubectl apply -f https://raw.githubusercontent.com/litmuschaos/litmus/master/litmus-portal/litmus-portal-crds.yml

    # Exporting namespace variable to update `namespaced-k8s-template.yml` manifest
    export LITMUS_PORTAL_NAMESPACE=${namespace}

    # Replacing ${LITMUS_PORTAL_NAMESPACE}
    envsubst '${LITMUS_PORTAL_NAMESPACE}' < ./manifests/ns-k8s-manifest.yml > ${namespace}-ns-scoped-litmus-portal-manifest.yml
    # manifest_image_update $version ${namespace}-ns-scoped-litmus-portal-manifest.yml

    # Applying the manifest
    kubectl apply -f ${namespace}-ns-scoped-litmus-portal-manifest.yml -n ${namespace}
}


function wait_for_portal_to_be_ready(){

    echo -e "\n---------------Pods running in ${namespace} Namespace---------------\n"
    kubectl get pods -n ${namespace}

    echo -e "\n---------------Waiting for all pods to be ready---------------\n"
    # Waiting for pods to be ready (timeout - 360s)
    wait_for_pods ${namespace} 360

    echo -e "\n------------- Verifying Namespace, Deployments, pods and Images for Litmus-Portal ------------------\n"
    # Namespace verification
    verify_namespace ${namespace}

    # Deployments verification
    verify_all_components litmusportal-frontend,litmusportal-server ${namespace}

    # Pods verification
    verify_pod litmusportal-frontend ${namespace}
    verify_pod litmusportal-server ${namespace}
    verify_pod mongo ${namespace}

    # # Images verification
    # verify_deployment_image $version litmusportal-frontend ${namespace}
    # verify_deployment_image $version litmusportal-server ${namespace}
}

if [[ "$installation_mode" == "CS-MODE" ]];then
    install_portal_cs_mode
elif [[ "$installation_mode" == "NS-MODE" ]];then
    install_portal_ns_mode
else
    echo "Selected Mode Not Found"
    exit 1
fi

wait_for_portal_to_be_ready
get_access_point ${namespace} ${accessType}

