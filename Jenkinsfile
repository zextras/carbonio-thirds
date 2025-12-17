library(
    identifier: 'jenkins-lib-common@1.1.2',
    retriever: modernSCM([
        $class: 'GitSCMSource',
        credentialsId: 'jenkins-integration-with-github-account',
        remote: 'git@github.com:zextras/jenkins-lib-common.git',
    ])
)

properties(defaultPipelineProperties())

pipeline {
    agent {
        node {
            label 'base'
        }
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        skipDefaultCheckout()
        timeout(time: 6, unit: 'HOURS')
    }

    stages {
        stage('Setup') {
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
                    parallelBuilds: false,
                    prepare: true,
                    skipTsOverride: true,
                )
            }
        }

        stage('Upload artifacts')
        {
            tools {
                jfrog 'jfrog-cli'
            }
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
