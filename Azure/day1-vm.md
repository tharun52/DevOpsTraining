### **Day 1 Task**

**Objective:**
Create an Azure VM with a custom data script to install the NGINX web server and make sure only the NGINX web service is accessible from the internet.
Additionally, SSH into the VM using Azure Bastion and locate the file path of the custom data script and its execution log file.

---

### **Answer:**

1. **Create a Virtual Network (VNet):**

   * Create a **custom VNet** with one **subnet** (e.g., `web-subnet`).
   * Attach a **Network Security Group (NSG)** to this subnet to control inbound and outbound traffic.

2. **Configure Network Security Group (NSG):**
   Add the following **inbound rules**:

   | Port | Protocol | Source        | Description                 |
   | ---- | -------- | ------------- | --------------------------- |
   | 22   | TCP      | IP of Bastion | Allow SSH from Bastion only |
   | 80   | TCP      | Any           | Allow HTTP (NGINX access)   |

   This ensures that only the Bastion host can SSH into the VM, while port 80 (NGINX) remains accessible to the public.

3. **Create an Azure Bastion Host:**

   * Deploy **Azure Bastion** in the same **VNet**.
   * This allows secure SSH access to the VM without exposing port 22 to the internet.

4. **Create a Virtual Machine (VM):**

   * Create a **Linux VM** (e.g., Ubuntu 22.04 LTS) in the **custom subnet**.
   * Assign a **Public IP** to the VM so it can serve web traffic.
   * In the **Advanced** tab, provide the **custom data script** (User Data):

     ```bash
     #!/bin/bash
     sudo apt update -y
     sudo apt install nginx -y
     echo "<html><h1>Welcome from Tharun</h1></html>" | sudo tee /var/www/html/index.html
     sudo systemctl enable nginx
     sudo systemctl start nginx
     ```

5. **Verify Web Access:**

   * After deployment, open the **Public IP** of the VM in your browser.
   * You should see the custom webpage displaying:

     ```
     Welcome from Tharun
     ```

6. **SSH into the VM via Azure Bastion:**

   * Go to the **VM → Connect → Bastion** tab.
   * Choose **SSH** and upload your **.pem** or **private key** file.
   * Once connected, you can verify the execution of the custom data.

7. **Locate Custom Data Script and Logs:**

   **Custom Data File Path:**

   ```bash
   sudo cat /var/lib/cloud/instance/user-data.txt
   ```

   **Cloud-Init Log File (Execution Log):**

   ```bash
   cat /var/log/cloud-init-output.log
   ```

   The `user-data.txt` file contains your original script, and the `cloud-init-output.log` file shows the output of script execution, including any errors.

---

