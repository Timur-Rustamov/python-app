pipeline {
    agent {
        kubernetes {
        defaultContainer 'builder'
        yaml '''
        kind: Pod
        spec:
          containers:
          - name: builder
            image: gcr.io/kaniko-project/executor:v1.6.0-debug
            imagePullPolicy: "IfNotPresent"
            command:
            - sleep
            args:
            - 100
            volumeMounts:
            - name: kaniko-secret
              mountPath: /kaniko/.docker
          - name: deployer
            image: joshendriks/alpine-k8s
            imagePullPolicy: "IfNotPresent"
            command:
            - sleep
            args:
            - 300
            volumeMounts:
            - name: kubeconf
              mountPath: /.kube
          volumes:
          - name: kaniko-secret
            secret:
              secretName: dockercred
              items:
                - key: .dockerconfigjson
                  path: config.json
          - name: kubeconf
            configMap:
              name: kubeconf
        '''
        }
    }
stages {
  stage('building new image') {
    steps{
        container('builder'){
          sh '/kaniko/executor --context "`pwd`" --destination tr94/testim:1'
        }
         }
}
  stage('deploy to k8s') {
    steps{
        container('deployer'){
          sh 'kubectl apply -f Deployment'
        }
         }
      }
  }
}
