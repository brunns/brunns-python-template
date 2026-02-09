#!/bin/bash
set -e

PACKAGE=$1
if [ -z "$PACKAGE" ]; then
    PACKAGE=$(gum input --header "Enter package name" --placeholder "my-awesome-app")
fi

DESCRIPTION=$2
if [ -z "$DESCRIPTION" ]; then
    DESCRIPTION=$(gum input --header "Enter package description" --value "A new project.")
fi

if [ -z "$PACKAGE" ]; then
    echo "Error: Package name is required."
    exit 1
fi

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

uvx copier copy `realpath ../template` . --data "package_name=$PACKAGE" --data "project_description=$DESCRIPTION" --overwrite --trust

uv add arrow 'httpx[http2]' yarl `gum filter aws-wsgi defusedxml django fastapi flask 'flask[async]' gunicorn pydantic python-json-logger sqlalchemy 'sqlalchemy[asyncio]' wireup --no-limit --header 'Select Packages:'`
uv add --dev ruff pytest pyright mockito pyhamcrest mbtest pytest-cov pytest-docker `gum filter brunns-matchers freezegun pyfakefs pytest-asyncio pytest-mockito respx scripttest --no-limit --header 'Select Test Packages:'`

xc format
xc pc
xc $PACKAGE
