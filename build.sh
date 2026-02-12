#!/bin/bash
set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_PATH="$SCRIPT_DIR/template"

PACKAGE=$1
if [ -z "$PACKAGE" ]; then
    PACKAGE=$(gum input --header "Enter package name" --placeholder "my-awesome-app")
fi

DESCRIPTION=$2
if [ -z "$DESCRIPTION" ]; then
    DESCRIPTION=$(gum input --header "Enter package description" --value "A new project.")
fi

OUTPUT_DIR=$3
if [ -z "$OUTPUT_DIR" ]; then
    OUTPUT_DIR="."
fi

if [ -z "$PACKAGE" ]; then
    echo "Error: Package name is required."
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Full path for the package
PACKAGE_PATH="$OUTPUT_DIR/$PACKAGE"

rm -rf "$PACKAGE_PATH"
uv init --package "$PACKAGE_PATH" \
  --description "$DESCRIPTION" \
  --python 3.14 --lib
cd "$PACKAGE_PATH"

curl -s https://www.toptal.com/developers/gitignore/api/python,flask,node,terraform,macos > .gitignore
cat <<EOF >> .gitignore

# Custom
.idea/
requirements.txt
terraform/.terraform.lock.hcl
*.zip
EOF

uvx copier copy "$TEMPLATE_PATH" . --data "package_name=$PACKAGE" --data "project_description=$DESCRIPTION" --overwrite --trust

uv add arrow 'httpx[http2]' yarl `gum filter aws-wsgi boto3 defusedxml django fastapi flask 'flask[async]' gunicorn uvicorn pydantic python-json-logger stamina sqlalchemy 'sqlalchemy[asyncio]' wireup --no-limit --header 'Select Packages:'`
uv add --dev ruff pytest pyright mockito pyhamcrest mbtest pytest-cov pytest-docker `gum filter brunns-matchers factory-boy faker freezegun pyfakefs pytest-asyncio pytest-mockito respx scripttest --no-limit --header 'Select Test Packages:'`

xc format
xc pc
xc $PACKAGE
