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
                stash includes: 'artifacts/', name: 'artifacts-ubuntu-bionic'
            }
            post {
                always {
                    archiveArtifacts artifacts: 'artifacts/*.deb', fingerprint: true
                }
            }
        }
        stage('Ubuntu 20') {
            agent {
                node {
                    label 'pacur-agent-ubuntu-20.04-v1'
                }
            }
            steps {
                unstash 'project'
                sh 'sudo pacur build ubuntu-focal native'
                sh 'sudo pacur build ubuntu-focal perl'
                stash includes: 'artifacts/', name: 'artifacts-ubuntu-focal'
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
        //         stash includes: 'artifacts/', name: 'artifacts-centos-8'
        //     }
        //     post {
        //         always {
        //             archiveArtifacts artifacts: 'artifacts/*.rpm', fingerprint: true
        //         }
        //     }
        // }
        stage('Upload To Playground') {
            when {
                anyOf {
                    branch 'zextras/*'
                    expression { params.PLAYGROUND == true }
                }
            }
            steps {
                unstash 'artifacts-ubuntu-bionic'
                unstash 'artifacts-ubuntu-focal'
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
                            },
                            {
                                "pattern": "artifacts/*focal*.deb",
                                "target": "ubuntu-playground/pool/",
                                "props": "deb.distribution=focal;deb.component=main;deb.architecture=amd64"
                            }
                        ]
                    }'''
                    server.upload spec: uploadSpec, buildInfo: buildInfo, failNoOp: false
                }
            }
        }
         stage('Upload & Promotion Config') {
            when {
                buildingTag()
            }
            steps {
                unstash 'artifacts-ubuntu-bionic'
                unstash 'artifacts-ubuntu-focal'
                script {
                    def server = Artifactory.server 'zextras-artifactory'
                    def buildInfo
                    def uploadSpec
                    def config

                    //ubuntu
                    buildInfo = Artifactory.newBuildInfo()
                    buildInfo.name += "-ubuntu"
                    uploadSpec = """{
                        "files": [
                            {
                                "pattern": "artifacts/*bionic*.deb",
                                "target": "ubuntu-rc/pool/",
                                "props": "deb.distribution=bionic;deb.component=main;deb.architecture=amd64"
                            },
                            {
                                "pattern": "artifacts/*focal*.deb",
                                "target": "ubuntu-rc/pool/",
                                "props": "deb.distribution=focal;deb.component=main;deb.architecture=amd64"
                            }
                        ]
                    }"""
                    server.upload spec: uploadSpec, buildInfo: buildInfo, failNoOp: false
                    config = [
                            'buildName'          : buildInfo.name,
                            'buildNumber'        : buildInfo.number,
                            'sourceRepo'         : 'ubuntu-rc',
                            'targetRepo'         : 'ubuntu-release',
                            'comment'            : 'Do not change anything! Just press the button',
                            'status'             : 'Released',
                            'includeDependencies': false,
                            'copy'               : true,
                            'failFast'           : true
                    ]
                    Artifactory.addInteractivePromotion server: server, promotionConfig: config, displayName: "Ubuntu Promotion to Release"
                    server.publishBuildInfo buildInfo
                }
            }
        }
    }
}

