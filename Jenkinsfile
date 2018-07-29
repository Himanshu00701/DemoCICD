pipeline {
  agent any
  options { 
    skipDefaultCheckout(true)
   // buildDiscarder(logRotator(numToKeepStr: '5')) 
    timeout(time: 30, unit: 'MINUTES')
  }

  stages{
    stage ('Checkout'){
      steps{
        checkout scm
      }
    }

    stage ('Build'){
      steps{      
        sh 'npm install'
      }
    }
//    stage ('Test'){
//      steps{       
//        sh './jenkins/scripts/test.sh'
//      }
//    }
      stage ('Package'){
        steps{       
         	sh 'ng build'
       }
     }

//    stage('SonarQube Analysis') {
//      steps{
//        withSonarQubeEnv('SonarQube Server') {
//          sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.2:sonar'
//        }
//      }
//    }
/*    stage("Quality Gate") {
      steps {
        timeout(time: 1, unit: 'HOURS') {
          waitForQualityGate abortPipeline: true
        }
      }
    }    */

   stage ('Docker Build'){     
     steps{ 
       script{ 
         docker.build("${env.JOB_NAME}:v_${env.BUILD_NUMBER}")
       }
     }
   }  
 
   stage ('Docker Push'){
     steps{       
       sh "chmod 777 ./scripts/docker_push.sh"  
       sh "perl -pi -e 's/\r//' ./scripts/docker_push.sh"
       sh "./scripts/docker_push.sh ${aws_repo} ${env.JOB_NAME} ${env.BUILD_NUMBER}"
     }
   }

   stage ('Deploy'){
     steps{       
       sh "chmod 777 ./scripts/ecs_deploy.sh"  
       sh "perl -pi -e 's/\r//' ./scripts/ecs_deploy.sh"
       sh "./scripts/ecs_deploy.sh -r us-east-1 -c ${cluster_name} -n ${service_name} -i ${aws_repo}:v_${env.BUILD_NUMBER} -m 50 -M 200 -t 600 -D 1"
     }
   } 
//  
//  }
//
//  post {
//    always {
//      deleteDir()
//    }
//    success {
//      mail(charset: 'UTF-8',
//           mimeType: 'text/html', 
//           from: "tfms.jenkins@thomsonreuters.com", 
//           to: "tfms.developers@thomsonreuters.com", 
//           subject: "${env.JOB_NAME} build# ${env.BUILD_NUMBER} passed.",
//           body: "<img alt='${env.JOB_NAME} Build ${env.BUILD_NUMBER} Passed' width='300' src='http://apimeme.com/meme?meme=Leonardo-Dicaprio-Cheers&top=${env.JOB_NAME}+build+${env.BUILD_NUMBER}&bottom=Passed' ></img></br></br>Refer <a href='${env.BUILD_URL}'>build details here</a>")
//           //body: "<font size='5' color='green'>${env.JOB_NAME} Build ${env.BUILD_NUMBER} Passed.</font></br></br>Refer <a href='${env.BUILD_URL}'>build details here</a>")
//    } 
//    failure {
//      mail(charset: 'UTF-8',
//           mimeType: 'text/html', 
//           from: "tfms.jenkins@thomsonreuters.com",  
//           to: "tfms.developers@thomsonreuters.com", 
//           subject: "${env.JOB_NAME} build# ${env.BUILD_NUMBER} failed !", 
//           body: "<img alt='${env.JOB_NAME} Build ${env.BUILD_NUMBER} Failed !' width='300' src='http://apimeme.com/meme?meme=Captain-Picard-Facepalm&top=${env.JOB_NAME}+build+${env.BUILD_NUMBER}&bottom=Failed' ></img></br></br>Check <a href='${env.BUILD_URL}'>build details here</a>")
//           //body: "<font size='5' color='red'>${env.JOB_NAME} Build ${env.BUILD_NUMBER} Failed !</font></br></br>Check <a href='${env.BUILD_URL}'>build details here</a>")
//    }    
  }

}