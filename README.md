# Template Web Server

## Prequisites

1. pnpm - for installing node packages
2. terraform - cli for deploying terraform
3. aws cli - for s3 uploads and cloudfront invalidations
4. python 3.12 - for development

The server has three components.

1. Backend - this is where the program logic is housed to be deployed as lambda functions.
2. Frontend - the angular web app that will act as the user interface.
3. Terraform - this folder contains the infrastructure as code (IaC) definitions for the entire infrastructure.

## Configuration

1. Please update the fields inside the `variables.tf` file.
2. Updaten the `backend.tf` file to point to correct places.

## Frontend

This could be any framework. But in this example I have put an angular app. When you change this, please update the relevant build commands in the `variables.tf` file.

## Deployment

Make sure you have AWS credentials added to the active terminal window. Then confirm that you are pointing to the correct backend in the `backend.tf` file. This manages the state of the infrastructure deployments.

The infrastructure can be deployed using the following commands.

```bash
terraform init
terraform apply --auto-approve
```

## Linting

Each folder has `.vscode` directory that automates code formatting.
For python we use `black` and `isort`, for typescript `prettier` and for terraform `hcl terraform formatter`. For development you can open new VSCODE window on each of these folders and work. Code formatting happen automatically upon save. Or do so manually. For terrafor, you can run the following command.

```bash
terraform fmt *.tf
```

## Practice

Comments style

```
DOC: documentation
FIX: bug fixes
MAINT: code formatting, import fixing, etc
DEV: development tasks
```
