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
                    def imageList = readFile(file: 'images-list.txt').trim().split('\n')

                    imageList.each { image ->
                        if (image.trim()) {
                            echo "Pulling image: ${image}"
                            sh "docker pull ${image.trim()}"
                        }
                    }
                }
            }
        }
        stage('Pack the images to Tar') {
            steps {
                script {

                    def imageList = readFile(file: 'images-list.txt').trim().split('\n')


                    def cleanedImageList = imageList.findAll { it.trim() }.collect { it.trim() }

                    def imageListString = cleanedImageList.join(' ')

                    echo "Packing images: ${imageListString}"
                    sh "docker save -o all_images.tar ${imageListString}"
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
            sh 'rm all_images.tar'
        }
    }
}
