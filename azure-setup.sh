#!/bin/bash
# ============================================================
# Bookified — Azure App Service Setup Script
# Run once to provision all Azure resources
# Usage: chmod +x azure-setup.sh && ./azure-setup.sh
# ============================================================

set -e

APP_NAME="bookified-prod"
RESOURCE_GROUP="bookified-rg"
PLAN_NAME="bookified-plan"
LOCATION="centralindia"

echo "▶ Logging into Azure..."
az login

echo "▶ Creating Resource Group..."
az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION

echo "▶ Creating App Service Plan (Linux B2)..."
az appservice plan create \
  --name $PLAN_NAME \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --is-linux \
  --sku B2

echo "▶ Creating Web App with Node 22..."
az webapp create \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --plan $PLAN_NAME \
  --runtime "NODE:22-lts"

echo "▶ Configuring startup command..."
az webapp config set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --startup-file "node server.js"

echo "▶ Enabling Always On + HTTP/2 + HTTPS Only..."
az webapp config set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --always-on true \
  --http20-enabled true \
  --min-tls-version "1.2" \
  --ftps-state "FtpsOnly"

az webapp update \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --https-only true

echo "▶ Setting port and base environment..."
az webapp config appsettings set \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --settings \
    NODE_ENV="production" \
    NEXT_TELEMETRY_DISABLED="1" \
    WEBSITES_PORT="8080" \
    PORT="8080"

echo "▶ Enabling application logging..."
az webapp log config \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --application-logging filesystem \
  --level information \
  --web-server-logging filesystem \
  --detailed-error-messages true \
  --failed-request-tracing true

echo "▶ Disabling ARR Affinity (better for stateless Next.js)..."
az webapp update \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --client-affinity-enabled false

echo ""
echo "✅ Azure setup complete!"
echo ""
echo "▶ Downloading publish profile for GitHub Secrets..."
az webapp deployment list-publishing-profiles \
  --name $APP_NAME \
  --resource-group $RESOURCE_GROUP \
  --xml > publish-profile.xml

echo ""
echo "================================================================"
echo "NEXT STEPS:"
echo "1. Open publish-profile.xml, copy ALL content"
echo "2. Add to GitHub Secret: AZURE_WEBAPP_PUBLISH_PROFILE"
echo "3. Add remaining secrets to GitHub (MONGODB_URI, CLERK keys, etc.)"
echo "4. Replace next.config.ts with the provided version (output: standalone)"
echo "5. Copy deploy.yml to .github/workflows/deploy.yml"
echo "6. git add . && git commit -m 'Add Azure deployment' && git push"
echo "================================================================"
echo ""
echo "App URL: https://$APP_NAME.azurewebsites.net"
echo "Kudu URL: https://$APP_NAME.scm.azurewebsites.net"