执行顺序：先执行docker.yml和registry.yml，然后上传镜像到私有仓库，再执行k8s.yml配置master节点，最后执行node.yml配置docker节点。
