# OpenShift clients

This is how I install the OpenShift client on my Fedora 42 laptop.

```shell
URL=https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp
VER=stable-4.18
PKG=openshift-client-linux.tar.gz

OC_TEMP_DIR=$(mktemp -d)
pushd $OC_TEMP_DIR

curl -LO $URL/$VER/$PKG
tar -xzf $PKG
sudo mv oc /usr/local/bin/

popd
rm -rf $OC_TEMP_DIR

oc version --client
```
