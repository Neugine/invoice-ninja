# Invoice Ninja - Railway Deployment

This repository contains the configuration files needed to deploy Invoice Ninja on Railway with MySQL.

## Prerequisites

- Railway account ([sign up here](https://railway.app))
- Railway CLI (optional, for local testing)

## Deployment Methods

### Method 1: Deploy via Railway Dashboard (Recommended)

1. **Create a new project on Railway**
   - Go to [railway.app](https://railway.app)
   - Click "New Project"
   - Select "Deploy from GitHub repo"
   - Connect this repository

2. **Add MySQL Database**
   - Railway will automatically detect the `railway.toml` file
   - The MySQL service will be created automatically
   - If not, click "+ New" and add "MySQL"

3. **Generate APP_KEY**

   Before deployment, you need to generate an application key. Run this command locally:
   ```bash
   docker run --rm invoiceninja/invoiceninja php artisan key:generate --show
   ```

   Copy the generated key (it will look like `base64:xxxxx...`)

4. **Update Environment Variables**
   - Go to your Invoice Ninja service in Railway
   - Click on "Variables"
   - Update `APP_KEY` with the key you generated above
   - Update `APP_URL` if needed (Railway will set this automatically to your public domain)

5. **Deploy**
   - Railway will automatically build and deploy your application
   - Wait for the build to complete

6. **Access Your Instance**
   - Once deployed, Railway will provide you with a public URL
   - Visit the URL to complete the Invoice Ninja setup wizard

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
Uses the official Invoice Ninja Docker image with custom PHP configuration:
- Increased PHP memory limit to 512M (prevents initialization errors)
- Upload limit set to 100M for large file handling
- Extended execution timeout for long-running operations
- Exposes port 9000 for the application

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
| `PHP_MEMORY_LIMIT` | PHP memory limit | `512M` |
| `PHP_UPLOAD_MAX_FILESIZE` | Maximum upload file size | `100M` |
| `PHP_POST_MAX_SIZE` | Maximum POST request size | `100M` |

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

### PHP Memory Exhausted Error
If you see errors like `PHP Fatal error: Allowed memory size of 134217728 bytes exhausted`:
- The Dockerfile is already configured with 512M memory limit
- If still experiencing issues, you can increase it further in Railway dashboard:
  - Go to Variables
  - Update `PHP_MEMORY_LIMIT` to `1024M` or higher
- Alternatively, edit `Dockerfile` and rebuild:
  ```dockerfile
  RUN echo "memory_limit = 1024M" > /usr/local/etc/php/conf.d/memory-limit.ini
  ```

### Database Connection Issues
- Verify that the MySQL service is running
- Check that the environment variables are correctly referencing the MySQL service
- Look at the logs: `railway logs`

### APP_KEY Not Set
- If you see an error about APP_KEY, generate one using the command above
- Set it in Railway: `railway variables set APP_KEY="your-generated-key"`

### Port Issues
- Railway automatically assigns ports, you don't need to configure them manually
- The application listens on port 9000 internally

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
