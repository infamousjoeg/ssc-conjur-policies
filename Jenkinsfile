pipeline {
    agent any

    triggers {
        pollSCM '* * * * *'
    }

    stages {
        stage('Load Conjur Policies') {
            steps {
                withCredentials([
                    conjurSecretCredential(credentialsId: 'ci-jenkins-conjur-policies-api_key', variable: 'CONJUR_API_KEY'),
                ]) {
                    sh './load_policies.sh > output'
                }
            }
        }
    }
    post {
        always {
            sh '''
                echo "Output from Load Policies script:"
                cat ./output
            '''
        }
    }
}