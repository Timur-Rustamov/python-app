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
          volumes:
          - name: kaniko-secret
            secret:
              secretName: dockercred
              items:
                - key: .dockerconfigjson
                  path: config.json
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
       }
}
