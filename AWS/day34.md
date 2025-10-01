# AWS Cloud Engineering Tasks and Solutions

---

## 1. High Availability, Data Durability, and Cost Efficiency for EC2 and EBS

**Requirements:**
- Deploy EC2 instances across multiple Availability Zones (AZs) for high availability.
- Automate regular backups of EBS volumes to ensure data recovery.
- Implement cost-control mechanisms to prevent excessive spending on EC2 and EBS services.

**Questions & Answers:**

**Q1:** How would you configure EC2 instances across multiple AZs for high availability?  
**A1:**  
- Create a Data Lifecycle Plan targeting the volume.  
- You can target the volume by setting the tag and value.  
- Set the number of snapshots created and how long each snapshot should last.  
- Since snapshots are independent of AZs, you can create volumes or images in any other AZ.  
- By deleting older snapshots, you are saving money.

**Q2:** What steps would you take to automate regular backups of EBS volumes?  
**A2:** Follow the steps above using Data Lifecycle Plans and tagging volumes.

**Q3:** How would you design a cost-control strategy to optimize EC2 and EBS usage?  
**A3:** Regularly delete older snapshots and only retain a defined number, ensuring cost efficiency.

---

## 2. Deploying a Scalable, Highly Available Web Application with Load Balancer

**Requirements:**
- Distribute traffic evenly across EC2 instances in multiple AZs.
- Redirect HTTP requests to HTTPS for secure communication.
- Monitor instance health and stop traffic to unhealthy instances.
- Implement path-based routing to direct traffic to specific application components or services.
- Integrate Auto Scaling with the load balancer.

**Solution:**
- Create two instances in different AZs.  
- Run an Nginx server on `/api` in one instance and `/web` in another instance.  
- Create two target groups for each instance with health checks for routes `/api` and `/web`, respectively.  
- Create an Application Load Balancer (ALB) in the same VPC as the instances and create a security group that allows HTTP.  
- In the default rule, add a fixed response.  
- Add new rules with the condition for path `/api` and `/web` mapped to their respective target groups.  
- In the security group, allow only HTTP traffic from the ALB for added security.

---

## 3. Configuring an Auto Scaling Group (ASG) Based on CPU Utilization

**Requirements:**
- Operate across multiple Availability Zones for high availability.
- Set minimum, desired, and maximum instance counts.
- Implement scaling policies based on CPU utilization.
- Utilize bootstrap scripts for package installation.

**Solution:**
- Create a custom AMI instead of using a bootstrap script for faster boot time.  
- Create a launch template using the custom AMI and assign the security group.  
- Create an ASG using this launch template and specify the VPC and subnets.  
- Attach an ALB to the ASG.  
- Define the desired, minimum, and maximum number of instances.  
- Create a scaling policy based on average CPU utilization.  
- The ASG will automatically create or terminate instances to maintain the CPU level.  
- Access the website via the ALB DNS.

---

## 4. Using EC2 Instance Roles to Manage AWS Resources

**Requirements:**
- Create an IAM role with policies to:
  - Read objects from a specific S3 bucket.
  - Write logs to CloudWatch.
- Launch an EC2 instance and attach the IAM role.
- Use the AWS CLI to:
  - List objects in the S3 bucket.
  - Upload a log file to CloudWatch.
- Test role-based permissions by disabling the role temporarily and re-enabling it.

**Solution:**
- Create an IAM role with the required permissions.  
- Launch an EC2 instance and attach the role.  
- Perform the AWS CLI commands to list S3 objects and upload logs.  
- Test permissions by temporarily disabling and re-enabling the role.








