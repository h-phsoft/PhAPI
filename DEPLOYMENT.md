# Deploying PhAPI to cPanel

This guide provides step-by-step instructions for deploying this Node.js project (PhAPI) to a cPanel hosting environment using the **Setup Node.js App** feature (powered by Phusion Passenger).

## Step 1: Prepare Your Files
1. On your local machine, create a `.zip` archive of your project files.
2. **Important:** Do not include the `node_modules` folder or the `.git` folder in your `.zip` file to save space and upload time. Make sure `package.json` and `server.js` are in the root of the `.zip`.

## Step 2: Upload to cPanel
1. Log in to your cPanel dashboard.
2. Go to **File Manager**.
3. Navigate to your home directory (`/home/username/`). It is highly recommended to place your app **outside** of `public_html` for security.
4. Create a new folder (e.g., `PhAPI`).
5. Open this folder, click **Upload**, and select the `.zip` file you created.
6. Once uploaded, right-click the `.zip` file and select **Extract** to unpack your files.

## Step 3: Set up the Node.js App
1. Go back to the main cPanel dashboard.
2. Under the **Software** section, click on **Setup Node.js App**.
3. Click the **Create Application** button and fill in the details:
   * **Node.js version:** Select the version of Node you want to run (e.g., 18.x or 20.x).
   * **Application mode:** Select `Production`.
   * **Application root:** Enter the name of the folder you created in Step 2 (e.g., `PhAPI`).
   * **Application URL:** Choose the domain or subdomain where you want your API to be accessible (e.g., `api.yourdomain.com`).
   * **Application startup file:** Enter `server.js`.
4. Click the **Create** button.

## Step 4: Install Dependencies (`node_modules`)
1. Once the application is created, you can simply scroll down on the App settings page in cPanel and click the **Run NPM Install** button. This will read your `package.json` and install all necessary dependencies.
2. *(Optional)* Alternatively, you can use the command shown near the top of the screen (e.g., `source /home/username/nodevenv/PhAPI/18/bin/activate`) to run commands via SSH.

## Step 5: Environment Variables & Database Configuration
1. Your `.env` file should have been uploaded with your `.zip`. It will be read by the `dotenv` package just like on your local machine.
2. Open the `.env` file in cPanel's File Manager and update it with your production database credentials. 
3. *Note on ports:* cPanel assigns a custom port dynamically. Your `server.js` already uses `process.env.PORT || 3000`, which correctly handles cPanel’s dynamically injected port. 

## Step 6: Start/Restart the App
1. Once `npm install` finishes and your environment variables are configured, scroll back to the top of the Node.js App configuration page and click **Restart**.
2. Your API should now be live on the Application URL you selected. You can visit `http://api.yourdomain.com/docs/index.html` to check if your interactive docs page is loading properly.
