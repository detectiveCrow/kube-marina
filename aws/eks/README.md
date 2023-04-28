# aws EKS

## Build

### prerequirements

- create key for access bastion instance (set `bastion_keyname` at config)

### build sequence

1. vpc
2. cluster
3. instance

## Folder Structure

```
.
├── README.md
├── config
│   ├── example.instance.tfvars
│   ├── example.tfvars
│   └── example.vpc.tfvars
├── provisioners
│   ├── cluster
│   │   ├── aws-auth.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   ├── role.tf
│   │   ├── security-groups.tf
│   │   ├── template
│   │   │   └── kubeconfig.tpl
│   │   ├── terraform.tf
│   │   └── variables.tf
│   ├── instance
│   │   ├── data.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   ├── terraform.tf
│   │   └── variables.tf
│   └── vpc
│       ├── main.tf
│       ├── outputs.tf
│       ├── providers.tf
│       ├── terraform.tf
│       └── variables.tf
└── set-variables.sh
```

## How to access EKS cluster from local machine

- prerequired
  - install kubectl
  - install helm (option)

1. change aws cli credential as terraform runner (which actually created the cluster)
    ```
    # example
    export AWS_DEFAULT_PROFILE=TF_USER
    ```
2. get caller identiry from sts
    ```
    aws sts get-caller-identity
    ```
3. update kubeconfig file
    ```
    aws eks --region $REGION update-kubeconfig --name $CLUSTER_NAME
    ```
4. set kubeconfig context
    ```
    # check current context
    kubectl config current-context

    # list contexts
    kubectl config get-contexts

    # set the default context
    kubectl config use-context $MY_EKS_CLUSTER_CONTEXT
    ```
5. use kubectl command
    ```
    # get node list
    kubectl get node -o wide
    ```
