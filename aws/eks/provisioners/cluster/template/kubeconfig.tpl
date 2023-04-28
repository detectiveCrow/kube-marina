apiVersion: v1
preferences: {}
kind: Config

clusters:
- cluster:
    server: ${endpoint}
    certificate-authority-data: ${cluster_auth_base64}
  name: ${kubeconfig_name}

contexts:
- context:
    cluster: ${kubeconfig_name}
    user: ${kubeconfig_name}
  name: ${kubeconfig_name}

current-context: ${kubeconfig_name}

users:
- name: ${kubeconfig_name}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      # this apiVersion depending on the aws-cli version. see details below link
      # https://shblue21.github.io/aws/eks%EC%97%90%EC%84%9C-exec-plugin-is-configured-to-use-API-version-%EC%9D%B4%EC%8A%88/
      command: ${user_exec_command}
      args:
%{~ for i in user_exec_args }
        - "${i}"
%{~ endfor ~}
