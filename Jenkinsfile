pipeline {
    agent any
    stages {
        stage('Login to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-cred', passwordVariable: 'DCK_PWD', usernameVariable: 'DCK_USR')]) {
                        sh '''
                            docker login -u $DCK_USR -p $DCK_PWD
                        '''
                    }
                }
            }
        }
        stage('Pull requried Image') {
            steps {
                script {
                    // Read the list.txt file line by line
                    def imageList = readFile(file: 'images-list.txt').trim().split('\n')

                    // Loop through each image and pull it
                    imageList.each { image ->
                        if (image.trim()) {  // Skip empty lines
                            echo "Pulling image: ${image}"
                            sh "docker pull ${image}"
                        }
                    }
                }
            }
        }
        stage('Pack the images to Tar') {
            steps {
                sh 'docker image save -o pack.tar j007acky/pvt-registry:v1.0'
                script {
                    // Read the list.txt file line by line
                    def imageList = readFile(file: 'images-list.txt').trim().split('\n')

                    // Loop through each image and pull it
                    imageList.each { image ->
                        if (image.trim()) {  // Skip empty lines
                            echo "Packing image: ${image}"
                            sh "docker image save -o pack.tar ${image}"
                        }
                    }
                }
            }
        }
        stage('Building custom Image') {
            steps {
                sh 'docker build -t custom-jenkins-image:rahul .'
            }
        }
    }
    post {
        always {
            sh 'docker logout'
        }
        success {
            sh 'rm pack.tar'
        }
    }
}
