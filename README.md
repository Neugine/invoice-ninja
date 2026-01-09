# Invoice Ninja - Railway Deployment

This repository contains the configuration files needed to deploy Invoice Ninja on Railway with MySQL.

## Prerequisites

- Railway account ([sign up here](https://railway.app))
- Railway CLI (optional, for local testing)

## Deployment Methods

### Method 1: Deploy via Railway Dashboard (Recommended)

**IMPORTANT: Create MySQL FIRST, then deploy Invoice Ninja**

1. **Create MySQL Database First**
   - Go to [railway.app](https://railway.app)
   - Click "New Project" → "Provision MySQL"
   - Wait for MySQL to be ready
   - Note: Railway handles volumes automatically, no setup needed

2. **Deploy Invoice Ninja**
   - In the same project, click "+ New" → "GitHub Repo"
   - Connect this repository
   - Railway will auto-detect `railway.toml` and build

3. **Generate APP_KEY**
   ```bash
   docker run --rm invoiceninja/invoiceninja:5 php artisan key:generate --show
   ```
   Copy the key (looks like `base64:xxxxx...`)

4. **Configure Variables**
   - Click on Invoice Ninja service → "Variables"
   - Set `APP_KEY` to the key you generated
   - Verify database variables are linked to MySQL service:
     - `DB_HOST=${{ MySQL.RAILWAY_PRIVATE_DOMAIN }}`
     - `DB_PORT=${{ MySQL.PORT }}`
     - `DB_DATABASE=${{ MySQL.MYSQLDATABASE }}`
     - `DB_USERNAME=${{ MySQL.MYSQLUSER }}`
     - `DB_PASSWORD=${{ MySQL.MYSQLPASSWORD }}`

5. **Deploy & Access**
   - Railway will build and deploy automatically
   - Click "Settings" → "Generate Domain" to get a public URL
   - Visit the URL to complete Invoice Ninja setup

### Method 2: Deploy via Railway CLI

1. **Install Railway CLI**
   ```bash
   npm install -g @railway/cli
   ```

2. **Login to Railway**
   ```bash
   railway login
   ```

3. **Initialize Project**
   ```bash
   railway init
   ```

4. **Link to Project**
   ```bash
   railway link
   ```

5. **Add MySQL**
   ```bash
   railway add --database mysql
   ```

6. **Generate and Set APP_KEY**
   ```bash
   # Generate key
   docker run --rm invoiceninja/invoiceninja php artisan key:generate --show

   # Set it in Railway (replace YOUR_KEY with the generated key)
   railway variables set APP_KEY="base64:YOUR_KEY"
   ```

7. **Deploy**
   ```bash
   railway up
   ```

## Configuration Files

### `Dockerfile`
Uses the official Invoice Ninja v5 image with nginx reverse proxy:
- Installs nginx for serving the application
- Configures nginx to proxy to PHP-FPM
- Custom startup script handles initialization
- Exposes port 80 for HTTP traffic

### `railway.toml`
Config-as-code file that defines:
- Invoice Ninja service configuration
- MySQL service configuration
- Environment variables with automatic service linking
- Build and deployment settings

### `railway.json`
Service-specific configuration for the Invoice Ninja application.

## Environment Variables

The following environment variables are configured in `railway.toml`:

| Variable | Description | Default Value |
|----------|-------------|---------------|
| `APP_ENV` | Application environment | `production` |
| `APP_DEBUG` | Debug mode | `false` |
| `APP_URL` | Application URL | Auto-set by Railway |
| `APP_KEY` | Application encryption key | **Must be generated** |
| `APP_CIPHER` | Encryption cipher | `AES-256-CBC` |
| `DB_CONNECTION` | Database type | `mysql` |
| `DB_HOST` | Database host | Auto-set from MySQL service |
| `DB_PORT` | Database port | Auto-set from MySQL service |
| `DB_DATABASE` | Database name | Auto-set from MySQL service |
| `DB_USERNAME` | Database user | Auto-set from MySQL service |
| `DB_PASSWORD` | Database password | Auto-set from MySQL service |
| `DB_STRICT` | Strict SQL mode | `false` |
| `REQUIRE_HTTPS` | Force HTTPS | `true` |

## Important Notes

1. **APP_KEY Generation**: You must generate a unique APP_KEY before deploying. Use the command:
   ```bash
   docker run --rm invoiceninja/invoiceninja php artisan key:generate --show
   ```

2. **Database Connection**: The MySQL service is automatically linked using Railway's service references (`${{ MySQL.* }}`).

3. **Persistent Storage**: Railway provides persistent volumes automatically for the Invoice Ninja image.

4. **HTTPS**: Railway provides automatic HTTPS for all deployments.

5. **Custom Domain**: You can add a custom domain in the Railway dashboard under your service settings.

## Troubleshooting

### Database Connection Issues
- Verify that the MySQL service is running
- Check that the environment variables are correctly referencing the MySQL service
- Look at the logs: `railway logs`

### APP_KEY Not Set
- If you see an error about APP_KEY, generate one using the command above
- Set it in Railway: `railway variables set APP_KEY="your-generated-key"`

### Port Issues
- The application listens on port 80 (nginx handles requests)
- Railway automatically maps this to a public URL

### Container Restart Loop
- Check Railway logs for specific errors
- Verify all environment variables are set correctly
- Ensure MySQL service is healthy and accessible
- Check that APP_KEY is properly formatted (should start with `base64:`)

## Running Locally

To test the setup locally:

```bash
# Build the image
docker build -t invoice-ninja-local .

# Run with environment variables
docker run -d \
  -e APP_ENV='local' \
  -e APP_DEBUG=1 \
  -e APP_URL='http://localhost:9000' \
  -e APP_KEY='your-generated-key' \
  -e APP_CIPHER='AES-256-CBC' \
  -e DB_CONNECTION='mysql' \
  -e DB_HOST='host.docker.internal' \
  -e DB_PORT='3306' \
  -e DB_DATABASE='ninja' \
  -e DB_USERNAME='ninja' \
  -e DB_PASSWORD='ninja' \
  -p 9000:9000 \
  invoice-ninja-local
```

## Resources

- [Invoice Ninja Documentation](https://invoiceninja.github.io/)
- [Railway Documentation](https://docs.railway.app/)
- [Railway Config-as-Code Guide](https://docs.railway.com/guides/config-as-code)
- [Invoice Ninja Docker Hub](https://hub.docker.com/r/invoiceninja/invoiceninja)

## Support

For issues specific to:
- Invoice Ninja: [GitHub Issues](https://github.com/invoiceninja/invoiceninja/issues)
- Railway Deployment: [Railway Discord](https://discord.gg/railway)

## License

Invoice Ninja is released under the Elastic License. See the [Invoice Ninja repository](https://github.com/invoiceninja/invoiceninja) for details.
