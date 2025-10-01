1. You are a cloud architect for a medium-sized company that has just started migrating its onpremises
infrastructure to AWS. The company has various departments, including Finance,
Development, and Marketing. Each department has a distinct set of users with different
access needs. For example:

    Finance users need access to sensitive financial data stored in Amazon S3 and the ability to run reports using Amazon Athena.

        a) AmazonAthenaFullAccess
        b) AmazonS3ReadOnlyAccess
        c) AmazonS3TablesReadOnlyAccess

    Development users need access to launch and manage EC2 instances, RDS databases, and access source code stored in S3.
        
        a)s3 bucket access : arn:aws:s3:::developmentbucket52
        b)ec2fullaccess
        c)rdsfullaccess
        d)ec2 with condition as resource tag as sourcecode

    Marketing users need access to certain S3 buckets that store customer-facing content and analytics data from Amazon QuickSight.

        a)s3 bucket read only and list access : arn:aws:s3:::developmentbucket52


2.You are working on an application hosted in Account A, but some required resources, like an S3 bucket and a DynamoDB table, are in Account B. To securely access these resources, you will use IAM Assume Role.

Task: Create IAM roles to achieve the above requirement.  The role creation in the same account would suffice, if you don’t have access to two accounts.

{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "Statement1",
			"Effect": "Allow",
			"Action": "sts:AssumeRole",
			"Resource": "arn:aws:iam::783764608670:role/kavya-s3-access"
		}
	]
}


here just paste the arn of the role to get the access


3. You are the cloud architect for a large university that uses AWS for various academic
and research projects. The university has multiple departments (Computer Science,
Biology, Physics, etc.), and each department runs its projects on AWS. Technical staLs,
Non-technical staLs and students in each department already have accounts in the
university’s Central Database system, which is managed by the IT department.
The university wants to integrate the existing Central Database with AWS so that users
from different departments can access the AWS Management Console and other
services. However, there are some strict guidelines:

    Tasks (Describe how will you implement the scenario):
    a) How would you integrate the university's Central Database with AWS so that users can log in with their login credentials?
    


    b) How would you assign different permissions to faculty and students, ensuring they only access resources relevant to their department?
    
        We can create faulty and student roles with the permissions and create dept as groups with the set of permissions
    
    c) How would you enforce MFA for users before they can access AWS?

        identity center - settings - authentication - MFA- configure

    d) How would you configure the system so that users can only access the AWS account assigned to their department, even though all accounts are part of a single AWS Organization?

        By creating groups for each department
        or in a higher level, we ccan create Organizational Units

