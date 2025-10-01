# Resilient Database Infrastructure for a Global Trading Platform

## Task
Design and implement a resilient database infrastructure for a global trading platform operating in **us-east-1** and **eu-west-1**.

### Requirements
**Database Design:**
- Deploy a secure and highly available database setup with multi-region capabilities.  
- Database choice: Regional RDS.  
- Optimize performance and ensure compliance with data residency laws.  

**Security:**
- Manage and rotate database credentials securely.  
- Enable encryption for data at rest and in transit.  

**Backup & Monitoring:**
- Configure automated backups.  
- Enable detailed monitoring with alerts for critical metrics.  

**Performance & Validation:**
- Ensure low latency for users across regions.  
- Test failover, recovery, and performance under high transaction loads.  

**Success Criteria:**
- Secure credentials  
- Low latency  
- Zero data loss  
- Seamless failover  
- Effective monitoring  

---

## Implementation Steps

1. **Create the Database**
   - Choose **MySQL** as the database engine.  
   - Select **Multi-AZ DB Cluster** for high availability (provides two readable standbys in separate AZs).  
   - Choose the instance type and storage capacity as needed.  
   - In **Networking**, select the VPC with subnets in three different AZs.  
   - In **Monitoring**, enable advanced database insights and select all logs.  
   - Enable **IAM authentication** so that only instances with the appropriate IAM role can log in.  
   - Create the database.  

2. **Configure Security**
   - Add the IP of the instance you want to connect from to the DB security group.  
   - Only that instance will be able to connect.  
   - Attempts from elsewhere will result in:  
     ```bash
     % mysql -h tharundb-read-replication-1.cuukwis7t1js.us-east-1.rds.amazonaws.com -u admin -p
     Enter password: 
     ERROR 2003 (HY000): Can't connect to MySQL server on 'tharundb-read-replication-1.cuukwis7t1js.us-east-1.rds.amazonaws.com:3306' (60)
     ```

3. **Endpoints**
   - You are provided with two endpoints:
     - **Read endpoint** (read replicas).  
     - **Write endpoint** (primary DB).  
   - Writing to the read endpoint will result in:  
     ```sql
     mysql> create table test(id INT);
     ERROR 1290 (HY000): The MySQL server is running with the --read-only option so it cannot execute this statement
     ```

4. **Backups & Monitoring**
   - Check monitoring and backups in their respective tabs.  
   - By default, **1 backup per day** is created with a **7-day retention period**.  

5. **Final Connection**
   - Connect to the DB cluster endpoint:  
     ```bash
     $ mysql -h tharun-db.cluster-cuukwis7t1js.us-east-1.rds.amazonaws.com -u admin -p
     Enter password:
     Welcome to the MySQL monitor.  Commands end with ; or \g.
     Your MySQL connection id is 387
     Server version: 8.0.42 Source distribution
     ```

---
