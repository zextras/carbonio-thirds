library(
    identifier: 'jenkins-lib-common@test-diff-debug',
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

    parameters {
        booleanParam(
            name: 'FULL_BUILD',
            defaultValue: false,
            description: 'Force a full rebuild of all packages (ignore diff detection)'
        )
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

        stage('Detect Changes') {
            steps {
                unstash 'project'
                script {
                    diffBuildHelper(
                        buildDirs: ['native', 'perl'],
                        fullBuild: params.FULL_BUILD,
                    )
                }
                stash includes: '**', name: 'project'
            }
        }

        stage('Build deb/rpm') {
            when {
                expression { env.DIFF_BUILD != 'no-changes' }
            }
            steps {
                echo 'Building deb/rpm packages'
                withCredentials([
                    usernamePassword(
                        credentialsId: 'artifactory-jenkins-gradle-properties-splitted',
                        passwordVariable: 'SECRET',
                        usernameVariable: 'USERNAME'
                    )
                ]) {
                    script {
                        def buildDirs = (env.DIFF_BUILD == 'true')
                            ? (env.DIFF_BUILD_DIRS ?: '').split(',').findAll { it } as List
                            : ['native', 'perl']

                        buildStage(
                            carbonioRepoCredentialId: 'artifactory-jenkins-gradle-properties-splitted',
                            buildDirs: buildDirs,
                            yapVersion: '1.51',
                            parallelBuilds: false,
                            prepare: true,
                            debugSymbols: true,
                        )
                    }
                }
            }
        }

        stage('Debug Symbols') {
            when {
                expression { env.DIFF_BUILD != 'no-changes' }
            }
            steps {
                debuginfodStage()
            }
        }

        stage('Upload artifacts')
        {
            when {
                expression { env.DIFF_BUILD != 'no-changes' }
            }
            tools {
                jfrog 'jfrog-cli'
            }
            steps {
                uploadStage(
                    packages: yapHelper.resolvePackageNamesFromFiles(
                        diffBuildHelper.resolveYapFiles(
                            ['native/yap.json', 'perl/yap.json'] as Set
                        )
                    ),
                )
            }
        }
    }
}
