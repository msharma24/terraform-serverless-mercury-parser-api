#terraform-serverless-mercury-parser-api

## Description
This project implements the [Mercury Parser API](https://github.com/postlight/mercury-parser-api) with AWS API Gateway and Lambda Function using Terraform.

*Mercury takes any web article and returns only the relevant content — headline, author, body text, relevant images and more*


### Diagram 
![	](https://github.com/msharma24/terraform-serverless-mercury-parser-api/blob/main/img/mercurty-parser-api.png)



### Build and Deploy
4. Git clone the mercury-parser-api `git clone git@github.com:RecastLLC/mercury-parser-api.git`
5. `cd mercury-parser-api`
6. Run `yarn install` inside the `mercury-parser-api` directory.
7. run `yarn build` - This command will build the lambda deployment zip file in the local path `./serverless/mercury.zip`
8. Export the `AWS Access keys` to the environment
9. `terraform init`
10. `terraform plan`
11. `terraform apply [-auto-approve]`

This will deploy the API Gateway REST API resources and the lambda function with the  Mercury Parser API nodejs zip.


### How to Test
1 - Login to AWS Account and access the API Gateway resources 

2 - Make a note of the API Gateway Stage `Execution URL`

3- Make a note of the API Gateway Access Key

Use the `lambda_requestion.html` as the `HTML` file as the payload and run the following command 
