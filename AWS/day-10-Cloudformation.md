### **Question 1:**

Create a CloudFormation template to deploy a scalable, secure web application on AWS with best practices. Develop separate AWS CloudFormation templates for each component of the application. Create a main CloudFormation template (`main-stack.yaml`) that references all the nested stack templates.

#### **Requirements**

**Networking:**

* Create a VPC with 2 public and 2 private subnets across different Availability Zones.
* Add an Internet Gateway for public subnets and a NAT Gateway for private subnets.
* Configure route tables and subnet associations.

**Compute:**

* Deploy an Auto Scaling Group (ASG) with EC2 instances in private subnets.
* Use an Application Load Balancer (ALB) in public subnets to route traffic to EC2 instances.

**Security:**

* Add Security Groups for ALB and EC2.
* Create an IAM role for EC2 with permissions for S3 and CloudWatch.

---

### **Answer:**

1. Go to the **AWS CloudFormation Console** and choose **Create Stack → With new resources (standard)**.
2. Use the **Infrastructure Composer** (or YAML editor) to write the main template file, named `test.yaml`.
3. In the `test.yaml` file, reference nested templates for:

   * **network.yaml** (for VPC, subnets, gateways, and routes)
   * **security.yaml** (for IAM roles and security groups)
   * **compute.yaml** (for ALB, Launch Template, and Auto Scaling Group)
4. Assign a **Stack Name** (for example, `ScalableWebAppStack`) and click **Create Stack**.
5. Wait for the CloudFormation deployment to complete. This may take several minutes.
6. Once created, navigate to the **Outputs** tab in the CloudFormation stack to find:

   * The **Load Balancer DNS Name** (to test your web application).
   * The **Public IP** of the **Bastion Host** (to SSH into private instances if needed).

After the stack finishes creating, open the Load Balancer DNS URL in your browser to verify that the web application is running successfully.

---

**🔗 Template File:**
You can find the complete `test.yaml` CloudFormation template in the same repository under the following path:
👉 **[`test.yaml`](./test.yaml)**
