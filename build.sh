#!/bin/bash
set -e

PACKAGE="${1:-package_name}"
DESCRIPTION="${2:-Package description.}"
TEMPLATE_REPO="${3:-template}"

rm -rf "$PACKAGE"
uv init --package "$PACKAGE" \
  --description "$DESCRIPTION" \
  --python 3.14 --lib
cd "$PACKAGE"

curl -s https://www.toptal.com/developers/gitignore/api/python,flask,node,terraform,macos > .gitignore
cat <<EOF >> .gitignore

# Custom
.idea/
requirements.txt
terraform/.terraform.lock.hcl
*.zip
EOF

uvx copier copy "$TEMPLATE_REPO" . \
  --data "package_name=$PACKAGE" \
  --data "project_description=$DESCRIPTION" \
  --overwrite --trust

uv sync
uv add "flask[async]" httpx yarl defusedxml python-json-logger aws-wsgi wireup arrow
uv add ruff pyright pytest pytest-asyncio pytest-cov pytest-docker feedparser pyhamcrest mbtest respx brunns-matchers pyfakefs --dev

xc format
xc pc
xc $PACKAGE
