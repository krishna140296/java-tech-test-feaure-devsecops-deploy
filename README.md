# Project Name README

## Prerequisites
Before you begin, ensure you have the following tools installed:

- [Docker](https://docs.docker.com/get-docker/)
- [Terraform](https://www.terraform.io/downloads.html)

## Docker Image Build
1. Clone the repository:
   ```bash
   git clone <repository_url>
2. Navigate to the project
   ```
   cd <project_directory>

3. Build the Docker image:
```
  docker build -t my-docker-image
```
4. Terraform Initialisation  
```
  cd terraform
```
   
5. Modify the tfvars file  


6. Teraform plan and apply
```
    Terraform plan #will crate a plan
    Terraform apply
```

Additional Notes
1. Ensure that you have the necessary AWS credentials configured for Terraform to access your AWS account.
2. Modify variables in terraform.tfvars based on your requirements.
3. Adjust Dockerfile or Terraform files as needed for your specific project.
