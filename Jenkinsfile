pipeline {
    parameters {
        booleanParam defaultValue: false, description: 'Whether to upload the packages in playground repositories', name: 'PLAYGROUND'
    }
    options {
        skipDefaultCheckout()
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timeout(time: 3, unit: 'HOURS')
    }
    agent {
        node {
            label 'base-agent-v1'
        }
    }
    environment {
        NETWORK_OPTS = '--network ci_agent'
    }
    stages {
        stage('Checkout & Stash') {
            agent {
                node {
                    label 'base-agent-v1'
                }
            }
            steps {
                checkout scm
                stash includes: '**', name: 'project'
            }
        }        
        stage('Packaging Third Parties') {
            parallel {
                stage('Ubuntu 18') {
                    agent {
                        node {
                            label 'pacur-agent-ubuntu-18.04-v1'
                        }
                    }
                    steps {
                        unstash 'project'
                        sh 'sudo pacur build ubuntu-bionic native'
                        sh 'sudo pacur build ubuntu-bionic perl'
                        sh 'sudo rm artifacts/carbonio-ce-dummy*.deb'
                        stash includes: 'artifacts/', name: 'artifacts-ubuntu-bionic'
                    }
                    post {
                        always {
                            archiveArtifacts artifacts: 'artifacts/*.deb', fingerprint: true
                        }
                    }
                }
                // stage('CentOS 8') {
                //     agent {
                //         node {
                //             label 'pacur-agent-centos-8-v1'
                //         }
                //     }
                //     steps {
                //         unstash 'project'
                //         sh 'sudo pacur build centos-8 native'
                //         sh 'sudo pacur build centos-8 perl'
                //         sh 'sudo rm artifacts/carbonio-ce-dummy*.rpm'
                //         stash includes: 'artifacts/', name: 'artifacts-centos-8'
                //     }
                //     post {
                //         always {
                //             archiveArtifacts artifacts: 'artifacts/*.rpm', fingerprint: true
                //         }
                //     }
                // }
            }
        }
        stage('Upload To Playground') {
            when {
                anyOf {
                    branch 'zextras/*'
                    expression { params.PLAYGROUND == true }
                }
            }
            steps {
                unstash 'artifacts-ubuntu-bionic'
//                unstash 'artifacts-centos-8'
                script {
                    def server = Artifactory.server 'zextras-artifactory'
                    def buildInfo
                    def uploadSpec
                    buildInfo = Artifactory.newBuildInfo()
                    uploadSpec = '''{
                        "files": [
                            {
                                "pattern": "artifacts/*bionic*.deb",
                                "target": "ubuntu-playground/pool/",
                                "props": "deb.distribution=bionic;deb.component=main;deb.architecture=amd64"
                            }
                        ]
                    }'''
                    server.upload spec: uploadSpec, buildInfo: buildInfo, failNoOp: false
                }
            }
        }
    }
}

