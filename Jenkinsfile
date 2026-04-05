@Library('shared') _
pipeline {
    agent any
    
    environment{
        SONAR_HOME = tool "Sonarqube"
    }
    
    stages {
        
        stage("Workspace cleanup"){
            steps{
                script{
                    cleanWs()
                }
                 sh "docker system prune -a -f"
            }
        }
        
        stage('Git: Code Checkout') {
            steps {
                script{
                    code_clone("https://github.com/Mr-Dusara/Wanderlust-Mega-Project.git","master")
                }
            }
        }
        
         stage("Trivy: Filesystem scan"){
             steps{
                 script{
                     trivy_scan()
                 }
             }
         }
        //       stage("OWASP: Dependency check"){
        //     steps{
        //         script{
        //             owasp_dependency()
        //         }
        //     }
        // }
        
        stage("SonarQube: Code Analysis"){
            steps{
                script{
                    sonar_analysis("Sonar","wanderlust","wanderlust")
                }
            }
        }
         stage("SonarQube: Code Quality Gates"){
            steps{
                script{
                    code_quality()
                }
            }
        }
        stage('Exporting environment variables') {
            parallel{
                stage("Backend env setup"){
                    steps {
                        script{
                            dir("Automations"){
                                sh "bash updatebackendnew.sh"
                            }
                        }
                    }
                }
                
                stage("Frontend env setup"){
                    steps {
                        script{
                            dir("Automations"){
                                sh "bash updatefrontendnew.sh"
                            }
                        }
                    }
                }
            }
        }
         stage("Docker: Build Images"){
            steps{
                script{
                        dir('backend'){
                            image_build("wanderlust-backend","$BUILD_NUMBER","dooms002") 
                        }
                    
                        dir('frontend'){
                            image_build("wanderlust-frontend","$BUILD_NUMBER","dooms002")
                   }
                }
            }
        }
        stage("Docker: Push to DockerHub"){
            steps{
                script{
                    docker_push("wanderlust-backend","$BUILD_NUMBER","dooms002") 
                    docker_push("wanderlust-frontend","$BUILD_NUMBER","dooms002")
                }
            }
        }
    }
    //     post{
    //     success{
    //         archiveArtifacts artifacts: '*.xml', followSymlinks: false
    //         // build job: "Wanderlust-CD", parameters: [
    //         //     string(name: 'FRONTEND_DOCKER_TAG', value: "$BUILD_NUMBER"),
    //         //     string(name: 'BACKEND_DOCKER_TAG', value: "$BUILD_NUMBER")
    //         // ]
    //     }
    //  }
  }