#!/bin/sh -e

# This script uses the gen-crd-api-reference-docs tool to generate a markdown
# document for the CSI CRD API.
#
# It clones the gen-crd-reference-docs and external-snapshotter repositories
# into two separate temporary folders. The references of the repositories are
# defaulted to master. They can be overwritten by using the:
# - CSI_REF
# - GEN_CRD_REF
# variables.
#
# The tool parses the Go files in the external-snapshotter's CRD package and
# writes the content to the book/src/api.md file. The configuration of the tool
# can be found in the hack/gen-api.json file.

GEN_TOOL_REF=${GEN_TOOL_REF:-master}
CSI_REF=${CSI_REF:-master}

curr_dir=$(pwd)
gen_tool_dir=$(mktemp -d)
csi_dir=$(mktemp -d)
# trap 'rm -rf "$gen_tool_dir" "$csi_dir"' EXIT

config_path=$(find . -iname "*gen-api.json")

git clone git@github.com:ahmetb/gen-crd-api-reference-docs.git "$gen_tool_dir"
git clone git@github.com:kubernetes-csi/external-snapshotter.git "$csi_dir"

cd "$gen_tool_dir"
git co "$GEN_TOOL_REF"
go build "$gen_tool_dir"

cd "$csi_dir"
git co "$CSI_REF"
$gen_tool_dir/gen-crd-api-reference-docs \
  -config="$curr_dir/$config_path" \
  -api-dir="./client/apis/volumesnapshot/v1" \
  -template-dir="$gen_tool_dir/template" \
  -out-file="out.html"

# add title to page
printf "# API Documentation\n\n%s" "$(cat out.html)" > "$curr_dir"/book/src/api.md
