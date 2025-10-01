# Task 1: Highly Available and Scalable Web Application with Auto Scaling

Your company is launching a new web application and requires a highly available and scalable infrastructure on AWS. The goal is to automatically handle traffic spikes by scaling EC2 instances up or down, distribute incoming traffic evenly across instances, and monitor the system's performance. Additionally, the system should notify the operations team via email when instances are added or removed based on CPU utilization.  

## Requirements
- Set up an EC2 instance running a web application that serves a "Hello World" page.  
- Set up an Auto Scaling Group (ASG) with a minimum of 1 and a maximum of 3 instances to manage EC2 instances for web traffic.  
- Create an Elastic Load Balancer (ELB) to evenly distribute incoming traffic.  
- Configure CloudWatch Alarms to monitor CPU utilization for scaling events:  
  - Scale out when CPU utilization exceeds 70% for 5 minutes.  
  - Scale in when CPU utilization drops below 30% for 5 minutes.  
- Ensure the infrastructure automatically scales to handle varying traffic loads.  

### Answer
1. Create a **launch template** that runs NGINX on `/` with the message "/". You can use user data or a custom AMI.  
2. Create an **ASG** with this launch template.  
   - Set the correct VPC and subnets.  
   - Select **attach to new load balancer** and create a load balancer.  
   - Set desired = 1, min = 1, and max = 3.  
   - Do not create a scaling policy here.  
   - Add notifications to an SNS topic for instance creation, deletion, and other events.  
3. Test the setup using the **load balancer DNS**.  
4. Under **Automatic Scaling**, create a **dynamic policy** with a **step scaling policy**:  
   - Create a CloudWatch alarm for **scale out**: CPU utilization > 70% for 5 minutes.  
   - Set the policy to **add 1 capacity unit**.  
   - Create a CloudWatch alarm for **scale in**: CPU utilization < 30% for 5 minutes.  
   - Set the policy to **remove 1 capacity unit**.  
5. Connect to an instance in the ASG and stress test it using:

   ```bash
   sudo apt-get install stress-ng -y
   stress-ng --cpu 4 --cpu-load 80 --timeout 300s
   ```
6. Verify that the scale-out alarm triggers, a new instance is created, and an SNS notification is sent.
7. After the stress test ends, ensure instances scale in and SNS notifications are sent accordingly.

---

# Task 2: EC2 Monitoring with CloudWatch Agent and Custom Metrics

Your company is developing a custom web application that requires hosting on AWS using EC2. To ensure effective monitoring and troubleshooting, the application needs to push its logs to CloudWatch. Additionally, you want to capture and monitor custom metrics from the application to gain insights into its performance.

## Requirements

* Set up an EC2 instance running a custom web application.
* Install and configure the **CloudWatch Agent** to push application logs to CloudWatch.
* Modify the application to send custom metrics (e.g., Memory utilization and errors) to CloudWatch.
* Set up CloudWatch Alarms to monitor custom metrics and trigger alerts for any issues or if thresholds are exceeded.
* Optional: Implement SNS notifications to alert the team when alarms are triggered.
* Validate that logs and metrics are correctly displayed in CloudWatch.
* Ensure CloudWatch logs are encrypted and set to auto-expire after 7 days.

### Answer

1. Create an EC2 instance, install NGINX, and write an `index.html` file.
2. Go to **System Manager → Quick Setup** and create a host manager to install the SSM agent.

   * Tick **Install and configure the CloudWatch Agent**.
   * Select the instance ID under **Manual Target Group**.
3. Wait for the SSM agent installation to complete.
4. On the instance, navigate to **Settings → Monitor and Troubleshoot → Configure CloudWatch Agent**.
5. Create an **IAM role** with the following policies:

   * `AmazonSSMManagedInstanceCore`
   * `CloudWatchAgentServerPolicy`
   * Attach the IAM role to the instance.
6. Continue setting up the CloudWatch Agent configuration and select the required metrics.
7. Once complete, the monitoring tab should display all metrics.
8. Check the CloudWatch logs by SSH into the machine and running:

   ```bash
   cat /opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log
   ```
