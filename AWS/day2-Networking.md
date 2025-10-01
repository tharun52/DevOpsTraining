# AWS Secure and Scalable Network Design for E-commerce Platform

## Questions
1. **Design a VPC with public, private, and isolated subnets to ensure proper segmentation and security.**  
2. **What routing rules would you configure to provide internet access for public and private subnets while ensuring the isolated subnet remains secure?**  
3. **Deploy VPC A & VPC B and spin up web servers in each VPC. Establish connection from WebServer 1 to WebServer 2.**  
4. **Enable secure AWS service access for isolated subnets. WebServer 1 from Subnet A should be able to access S3 bucket and download/upload objects to S3.**  

---

## VPC Design
- Create a VPC with three subnets: **public**, **private**, and **isolated**.

---

## Public Subnet
- Create an Internet Gateway (IGW) and attach it to the VPC.
- Create a route table for the public subnet:

| Destination | Target |
|-------------|--------|
| 0.0.0.0/0   | igw    |

- Launch an instance in the public subnet with a public IP to allow SSH access. This instance will act as the **bastion host**.

---

## Private Subnet
- Launch an instance in the private subnet and allow SSH access only from the bastion host’s private IP.  
- Create a NAT Gateway in the public subnet.  
- Create a route table for the private subnet:

| Destination | Target      |
|-------------|-------------|
| 0.0.0.0/0   | nat gateway |

- Host an Nginx server on the private instance. From the public instance, ping the private IP of the instance in the private subnet to verify connectivity.

---

## Isolated Subnet
- Launch an instance in the isolated subnet.  
- To provide temporary internet access, add a route to the NAT Gateway in the route table (remove later).  
- Create a **VPC Endpoint** (Gateway type) for S3 and associate it with the isolated subnet’s route table.  
- In the isolated route table, the following rule is added automatically:

| Destination   | Target       |
|---------------|--------------|
| S3 prefix list| VPC endpoint |

- The instance in the isolated subnet can now access S3 securely.

---

## VPC Peering (VPC A & VPC B)
- Create another VPC (VPC B) with a public subnet and launch an instance with internet access through IGW.  
- Create a VPC peering connection between VPC A and VPC B, and accept it.  
- Update route tables:

**VPC A (Private Subnet):**

| Destination             | Target             |
|--------------------------|-------------------|
| Private IP of VPC B EC2 | Peering connection |

**VPC B (Subnet):**

| Destination                | Target             |
|-----------------------------|-------------------|
| CIDR/IP of VPC A Private EC2| Peering connection |

---

