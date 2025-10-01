# Task 1: CloudFront Optimization for Static Content Delivery

You are an AWS Cloud Engineer optimizing static content delivery for a global media streaming company. Your goal is to enhance performance and reduce latency by leveraging Amazon CloudFront as a CDN.  

## Requirements
- Configure a CloudFront distribution to serve static assets from an S3 bucket or EC2 instance.  
- Ensure S3 or EC2 should be accessible only via CloudFront.  

### Custom Domains
- Create a custom domain for your CDN.  

### Test Delivery
- Test the CloudFront URL using tools like VPNs to confirm content is served from the nearest edge location.  

### Optimize Caching
- Set cache behaviors with appropriate TTLs for different content types (e.g., longer for images, shorter for frequently updated files).  

### Questions
- How does CloudFront improve performance compared to serving content directly from EC2?  
- What measures ensure the CloudFront distribution is secure and uses HTTPS?  
- How would you monitor and optimize CloudFront performance?  
- How would you troubleshoot user-reported slow loading times?  
- CloudFront should be accessible only via specific geolocation (e.g., India, Singapore).  
- Explore cache invalidation and implement a cache strategy.  

### Bonus Challenge
- Enable HTTPS for your CloudFront.  
- Secure content delivery with SSL/TLS.  
- Use AWS Certificate Manager (ACM) to request a certificate and associate it with the distribution.  

---

## Steps
1. Create a bucket with block all public access and upload some files.  
2. Create a distribution for this S3 bucket that was just created.  
3. Make sure to enable **Origin access control settings** so that a policy is created in the S3 bucket to allow CloudFront access.  

   The created policy will look something like:

   ```json
   {
       "Version": "2008-10-17",
       "Id": "PolicyForCloudFrontPrivateContent",
       "Statement": [
           {
               "Sid": "AllowCloudFrontServicePrincipal",
               "Effect": "Allow",
               "Principal": {
                   "Service": "cloudfront.amazonaws.com"
               },
               "Action": "s3:GetObject",
               "Resource": "arn:aws:s3:::tharunstaticfilesbucket/*",
               "Condition": {
                   "ArnLike": {
                       "AWS:SourceArn": "arn:aws:cloudfront::853973692277:distribution/E1K6DYLM2P3P9X"
                   }
               }
           }
       ]
   }
   ```
4. Now you should be able to view the file via the DNS.

5. Create an ACM certificate on a domain you own with DNS validation.

6. Once the certificate is created, add that domain to the distribution by selecting that certificate.

7. Finally, add the DNS of the distribution as a CNAME record in the domain's hosted zone with a simple routing policy.

   You can see the file is accessible through the CDN now:

   ```bash
   $ curl -I https://s3.tharuntest.click/index.html
   HTTP/2 200 
   content-type: text/html
   content-length: 804
   date: Thu, 25 Sep 2025 13:22:28 GMT
   last-modified: Thu, 25 Sep 2025 12:28:20 GMT
   etag: "09d550e536f50c85489ba1dceee81e9b"
   x-amz-server-side-encryption: AES256
   accept-ranges: bytes
   server: AmazonS3
   x-cache: Hit from cloudfront
   via: 1.1 ff2d6deff1b50282a21f4b199088c76e.cloudfront.net (CloudFront)
   x-amz-cf-pop: IAD61-P3
   x-amz-cf-id: fnhIcoHIuMifJN4uuO2kAYuyTrFj1pRj14PEvcdAnM6CPeYVkrF99A==
   age: 100
   ```

8. You can set up cache invalidation when the object changes in the S3 bucket and the TTL of the record is high, so it is like hitting refresh on an object.

9. You can allow or deny the geolocation in the CloudFront geographic restrictions under the security section of CloudFront.

---

# Task 2: Route 53 for DNS Management and Traffic Routing

As an AWS Cloud Engineer managing a global e-commerce platform, you need to ensure low latency, high availability, and fault tolerance using AWS Route 53 for DNS management and traffic routing.

## Requirements

* **DNS Management**: Configure Route 53 hosted zones to manage domain and subdomain records (e.g., A/AAAA records for EC2 or load balancers).
* **Routing Policies**:

  * **Latency-Based**: Route users to the nearest AWS region for the lowest latency.
  * **Weighted**: Distribute traffic across multiple resources with adjustable weights.
  * **Failover**: Redirect traffic to a backup resource if the primary fails using health checks.
  * **Geolocation**: Direct users to region-specific endpoints (e.g., EU users to EU servers).
* **Health Checks**: Monitor backend services and reroute traffic from unhealthy resources.

### Questions

* How would you configure a Route 53 hosted zone and add DNS records for your services?
* How would you set up latency-based routing to improve user experience globally?
* How would you implement and adjust weighted routing policies to balance traffic?
* How would you configure failover routing to ensure service availability during outages?
* How would you set up health checks in Route 53 to detect failures and reroute traffic?

---

## Answer

1. Create two instances that run an NGINX server.
2. Create two health checks for each server.
3. Create each type of routing policy using the instance IP and the health checks if needed.
4. Test the DNS using VPNs when needed.

