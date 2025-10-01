# Task 1: Deploy Containerized Web Application using ECS (EC2 Launch Type)

You are an AWS Cloud Engineer tasked with deploying a containerized web application using Amazon ECS with EC2 launch type to handle varying traffic loads.  

## Requirements
- Deploy a web application using ECS with EC2 instances.  
- Set up an Application Load Balancer (ALB) to distribute traffic.  
- Implement basic EC2 auto-scaling.  
- Monitor container health and log application events using CloudWatch.  

### Questions
- How would you design the ECS cluster with EC2 instances?  
- What instance types would you choose and why?  
- What monitoring metrics would you set up?  
- How would you handle container updates?  

### Answer
1. First, create an ECR repository to upload your Docker image.  
2. Use a simple Dockerfile like this:

   ```dockerfile
   FROM nginx:alpine

   RUN echo "<html><h1>Hello World from Tharun!</h1></html>" > /usr/share/nginx/html/index.html
   ```

3. Enter the AWS access keys and other details using:

   ```bash
   aws configure
   ```

4. Use the push commands provided in the ECR repository to push the Docker image.

5. Create a cluster in the ECS section, select **EC2** type, and enable monitoring if needed.

6. Create a **task definition** and paste the URI of the ECR repository created to use that image.

7. Configure the port, CPU, and storage details.

8. Create a **service** in the cluster using the task definition just created.

9. Set the correct networking options.

10. Use the option to create a **load balancer**, specifying:

    * Load balancer name
    * Target group names
    * Correct port numbers

11. A new task and a new auto-scaling group with the instances and load balancers will be created.

12. You can view the page using the **load balancer DNS**.

---

# Task 2: Design Notification System for E-commerce Platform

You are a Cloud Engineer tasked with designing a notification system for an e-commerce platform to process and track orders.

## Requirements

* Use SNS to send order confirmations to customers.
* Use SQS to process order details in a separate queue.
* Handle failed message delivery.
* Monitor queue performance.

### Questions

* How would you handle message failures?
* What monitoring metrics would you set up?

### Answer

1. Create an **SQS queue** of standard type and test it using the send and receive messages option.

2. Create an **SNS topic** with a subscription to the SQS queue created above and optionally add an email to act as the customer.

3. Publish a test message, for example:

   ```json
   {
       "orderId": "12345",
       "customer": "John Doe",
       "item": "Laptop",
       "price": 1000
   }
   ```

4. The message should now go to the SQS queue.

5. Set up monitoring for both SNS and SQS.

6. Optionally, create a separate **dead-letter queue** to handle message failures so that if a message fails in the main queue, it can be reviewed in the secondary queue.
