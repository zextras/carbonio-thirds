library(
    identifier: 'jenkins-packages-build-library@1.0.3',
    retriever: modernSCM([
        $class: 'GitSCMSource',
        remote: 'git@github.com:zextras/jenkins-packages-build-library.git',
        credentialsId: 'jenkins-integration-with-github-account'
    ])
)

pipeline {
    agent {
        node {
            label 'base'
        }
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        parallelsAlwaysFailFast()
        skipDefaultCheckout()
        timeout(time: 6, unit: 'HOURS')
    }

    parameters {
        booleanParam defaultValue: false,
            description: 'Whether to upload the packages in playground repositories',
            name: 'PLAYGROUND'
    }

    tools {
        jfrog 'jfrog-cli'
    }

    stages {
        stage('Checkout & Stash') {
            steps {
                checkout scm
                script {
                    gitMetadata()
                }
                stash includes: '**', name: 'project'
            }
        }

        stage('SonarQube analysis') {
            steps {
                unstash 'project'
                script {
                    scannerHome = tool 'SonarScanner'
                }
                withSonarQubeEnv(credentialsId: 'sonarqube-user-token',
                    installationName: 'SonarQube instance') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }

        stage('Build deb/rpm') {
            steps {
                echo 'Building deb/rpm packages'
                buildStage(
                    buildDirs: ['native', 'perl'],
                    prepare: true,
                    skipTsOverride: true,
                )
            }
        }

        stage('Upload artifacts')
        {
            steps {
                uploadStage(
                    packages: yapHelper.getPackageNamesFromFiles(
                        ['native/yap.json', 'perl/yap.json'] as Set
                    ),
                    exclusionMap: [
                        'carbonio-perl-xml-parser': ['*xml-parser-lite*.rpm'],
                        'carbonio-perl-xml-sax'   : ['*xml-sax-base*.rpm', '*xml-sax-expat*.rp']
                    ]
                )
            }
        }
    }
}
