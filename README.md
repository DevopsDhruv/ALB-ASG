# Project Overview

This project uses Terraform to create an infrastructure on AWS that includes a Virtual Private Cloud (VPC), an Application Load Balancer (ALB), and an Auto Scaling Group (ASG). The instances within the Auto Scaling Group will automatically install an Apache web server using user data upon creation.

## Architecture Diagram

![Architecture Diagram](https://github.com/DevopsDhruv/ALB-ASG/blob/main/ALB_ASG.drawio.png?raw=true)

The architecture includes the following components:
- **VPC**: A Virtual Private Cloud that provides an isolated network environment.
- **Public Subnets**: Subnets within the VPC where EC2 instances are deployed.
- **Auto Scaling Group (ASG)**: Manages the group of instances across the public subnets.
- **Application Load Balancer (ALB)**: Distributes incoming traffic across the instances in the ASG.

## Prerequisites

- Terraform installed on your local machine.
- An AWS access key and secret key 🗝 

## Usage

1. **Clone the repository**:
    ```bash
    git clone <repository-url>
    ```
2. **Configuration**:

     You can change the ASG and ALB values as per your needs in the `terraform.tfvars` file.

3. **Create an SSH key for the public subnet EC2 instance**:
     ```bash
     ssh-keygen
     ```
     Create the SSH key and name it exactly `instance_key`.

4. **Initialize Terraform**:
     ```bash
     terraform init
     ```
5. **Plan the infrastructure**:
     ```bash
     terraform plan
     ```

6. **Apply the configuration**: 
     ```bash
     terraform apply --auto-approve
     ```

7. **Verify the deployment**:

     After the deployment is complete, navigate to the AWS Management Console.

     Check the VPC, subnets, ALB, and ASG to ensure they are created.

     Access the public IP of the ALB to verify that the Apache web server is running on the instances.

## Cleanup

To destroy the infrastructure created by this project, run:
```bash
terraform destroy
```

## ASG Target Tracking Policies

This project uses target tracking policies for the ASG.

### How Target Tracking Policies Work Together

**Scale-In Policy**: This policy will attempt to scale in (reduce the number of instances) to maintain an average CPU utilization of 30%.

If the CPU utilization is above 30%, this policy will not trigger a scale-in action.

**Scale-Out Policy**: This policy will attempt to scale out (increase the number of instances) to maintain an average CPU utilization of 70%.

If the CPU utilization is below 70%, this policy will not trigger a scale-out action.

**Scenario: CPU Utilization at 50%**

- **Scale-In Policy**: The CPU utilization is above the target value of 30%, so the scale-in policy will not trigger a scale-in action.
- **Scale-Out Policy**: The CPU utilization is below the target value of 70%, so the scale-out policy will not trigger a scale-out action.

## Request Flow

1. **User Request**:

     The user opens a web browser and enters the DNS name of the ALB.

2. **DNS Resolution**:

     The browser resolves the ALB DNS name to an IP address using DNS.

3. **Internet Gateway**:

     The request is sent over the internet and reaches the Internet Gateway (IGW) of your VPC.

4. **Application Load Balancer (ALB)**:

     The IGW forwards the request to the ALB.

     The ALB listens for incoming requests on the specified port (e.g., port 80 for HTTP).

5. **ALB Listener**:

     The ALB listener receives the request and forwards it to the appropriate target group based on the listener rules.

6. **ALB Target Group**:

     The target group contains the EC2 instances that are part of the ASG.

     The ALB performs health checks on the instances and forwards the request to one of the healthy instances.

7. **Auto Scaling Group (ASG) Instances**:

     The request is routed to an EC2 instance in the ASG that is registered with the target group.
     The instance processes the request (e.g., serves a web page or API response).

8. **Instance Response**:

     The EC2 instance generates a response and sends it back to the ALB.

9. **ALB to User**:

     The ALB receives the response from the EC2 instance.

     The ALB forwards the response back to the user's browser through the Internet Gateway.

10. **User Receives Response**:

     The user's browser receives the response and displays the content (e.g., a web page).

## Conclusion

This project demonstrates how to use Terraform to create a scalable and highly available web server infrastructure on AWS. The use of an ALB and ASG ensures that the web server can handle varying levels of traffic and maintain high availability.