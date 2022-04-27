#!/bin/sh

CLUSTER_NAME=cluster1
TAP_VERSION=1.0.3
NAMESPACE=tap-install
LOCAL_REGISTRY_HOSTNAME=registry.tanzu-lab.com
LOCAL_REGISTRY_PATH_TAP=/tap-packages/tap-${TAP_VERSION}
LOCAL_REGISTRY_USERNAME=admin
LOCAL_REGISTRY_PASSWORD="TanzuTanzu1!"
TANZU_NETWORK_USERNAME=msanderson@vmware.com
TANZU_NETWORK_PASSWORD="2secret4u2NO!"
BINDIR=$(readlink -f $(dirname "$0")) 
DOWNLOAD_DIR=${BINDIR}/../tap-${TAP_VERSION} 
PATH=$PATH:/usr/local/bin
required_plugins="accelerator apps package secret services"
verbose=true

export PATH

set -e

function verbose_echo {
	if $verbose ; then
		echo "$@"
	fi
}

function cli_plugin_installed {
	# This method fails as root but works as an unprivileged user:
	# if tanzu plugin describe "$1" >/dev/null 2>&1 ; then
	if /usr/local/bin/tanzu plugin list -o json | jq ".[] | select(.name == \"$1\") .status" | egrep '"installed"|"update available"' >/dev/null 2>&1 ; then
		return 0
	else
		return 1
	fi
}

function required_plugins_installed {
	ret=0
	for req_plugin in $required_plugins ; do
		if cli_plugin_installed "${req_plugin}" ; then
			verbose_echo "Found required plugin '$req_plugin'" 1>&2
		else
			echo "Missing required plugin '$req_plugin'" 1>&2
			ret=1
		fi
	done
	return $ret
}

function install_cli_plugins {
	if required_plugins_installed ; then
		return 0
	fi
	tmpdir=$(mktemp --directory)
	cd "$tmpdir"
	tar zxf ${DOWNLOAD_DIR}/tanzu-cli-v0.11.1--tanzu-framework-bundle-linux.tar.gz
	export TANZU_CLI_NO_INIT=true
	tanzu plugin install --local cli all
	cd "$tmpdir"/..
	rm -rf "$tmpdir"
}

function relocate_images {
	echo "${LOCAL_REGISTRY_PASSWORD}" | docker login --username "${LOCAL_REGISTRY_USERNAME}" --password-stdin $LOCAL_REGISTRY_HOSTNAME
	echo "${TANZU_NETWORK_PASSWORD}"  | docker login --username "${TANZU_NETWORK_USERNAME}"  --password-stdin registry.tanzu.vmware.com
	imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:${TAP_VERSION} --to-repo ${LOCAL_REGISTRY_HOSTNAME}${LOCAL_REGISTRY_PATH_TAP} 2>&1 | tee /tmp/imgpkg-$$.log
}

function unpack_catalog {
	cd "${DOWNLOAD_DIR}"
	tar zxf tap-gui-yelb-catalog.tgz
	# Apparently this needs to be hosted somewhere via https?
	# imgcopy yelb-catalog --to-repo ${LOCAL_REGISTRY_HOSTNAME}/yelb-catalog
}

function install_tap_package {
	cd "${BINDIR}"
	kubectl apply -f tap/templates/namespace.yaml
	tanzu secret registry add tap-registry \
		--username ${LOCAL_REGISTRY_USERNAME} --password ${LOCAL_REGISTRY_PASSWORD} \
		--server ${LOCAL_REGISTRY_HOSTNAME} \
		--export-to-all-namespaces --yes --namespace "${NAMESPACE}"
	tanzu package repository add tanzu-tap-repository \
		--url ${LOCAL_REGISTRY_HOSTNAME}${LOCAL_REGISTRY_PATH_TAP}:$TAP_VERSION \
		--namespace "${NAMESPACE}"
	tanzu package repository get tanzu-tap-repository --namespace "${NAMESPACE}"
	ytt -f tap-values.yaml -f values.yaml --ignore-unknown-comments > generated/tap-values.yaml
	tanzu package install tap -p tap.tanzu.vmware.com -v $TAP_VERSION --values-file generated/tap-values.yaml -n "${NAMESPACE}"
}

tanzu cluster kubeconfig get "${CLUSTER_NAME}" --admin
kubectl config use-context "${CLUSTER_NAME}-admin@${CLUSTER_NAME}"
# install_cli_plugins
# relocate_images
# unpack_catalog
install_tap_package
