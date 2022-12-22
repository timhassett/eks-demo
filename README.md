# eks-demo
Demo EKS stack via Terraform


## Steps to deploy

1.  Update tfvars
Update [terraform.tfvars](./terraform.tfvars) to set the desired AWS region to deploy to and the AWS profile to use to deploy

2. Build the dev container
```
docker build -t devops-tools .
```

3. Run installer script to deploy terraform stack
```
docker run -it -v $(PWD):/src -v ~/.aws/credentials:/root/.aws/credentials -w /src devops-tools /src/run.sh
```


## Steps to debug
To debug run:
```
docker run -it --entrypoint bash -v $(PWD):/src -v ~/.aws/credentials:/root/.aws/credentials -w /src devops-tools
```

## Steps to destroy
Run:
```
docker run -it -v $(PWD):/src -v ~/.aws/credentials:/root/.aws/credentials -w /src devops-tools terraform destroy
```