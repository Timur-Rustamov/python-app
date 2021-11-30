pipeline {
    agent {
        kubernetes {
        defaultContainer 'builder'
        yaml '''
        kind: Pod
        spec:
          containers:
          - name: builder
            image: yobasystems/alpine-docker
            imagePullPolicy: "IfNotPresent"
            command:
            - sleep
            args:
            - 10
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
  stage('check') {
    steps{
        container('builder'){
          sh ''' 
            docker build -t tr94/test:latest .
            docker push tr94/test:latest
        '''
        }
         }
                 }
       }
}
