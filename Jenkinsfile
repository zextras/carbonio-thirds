pipeline {
    parameters {
        booleanParam defaultValue: false,
        description: 'Whether to upload the packages in playground repositories',
        name: 'PLAYGROUND'
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
                    archiveArtifacts artifacts: 'artifacts/*.deb',
                    fingerprint: true
                }
            }
        }
        stage('Rocky 8') {
            agent {
                node {
                    label 'pacur-agent-rocky-8-v1'
                }
            }
            steps {
                unstash 'project'
                sh 'sudo pacur build rocky-8 native'
                sh 'sudo pacur build rocky-8 perl'
                stash includes: 'artifacts/', name: 'artifacts-rocky-8'
            }
            post {
                always {
                    archiveArtifacts artifacts: 'artifacts/*.rpm', fingerprint: true
                }
            }
        }
        stage('Upload To Playground') {
            when {
                anyOf {
                    expression { params.PLAYGROUND == true }
                }
            }
            steps {
                unstash 'artifacts-ubuntu-focal'
                unstash 'artifacts-rocky-8'

                script {
                    def server = Artifactory.server 'zextras-artifactory'
                    def buildInfo
                    def uploadSpec
                    buildInfo = Artifactory.newBuildInfo()
                    uploadSpec = '''{
                        "files": [
                            {
                                "pattern": "artifacts/*focal*.deb",
                                "target": "ubuntu-playground/pool/",
                                "props": "deb.distribution=focal;deb.component=main;deb.architecture=amd64"
                            },
                            {
                                "pattern": "artifacts/(carbonio-altermime)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-amavisd)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-bdb)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-clamav)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-curl)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-cyrus-sasl)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-icu)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-jemalloc)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-krb5)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-libbsd)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-libevent)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-libmilter)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-libpng)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-libsodium)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-libtool)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-libxml2)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-mariadb)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-memcached)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-nginx)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-opendkim)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-openjdk)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-openjdk-cacerts)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-openldap)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-openssl)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-postfix)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-rsync)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-archive-zip)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-berkeleydb)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-bit-vector)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-cache-fastmmap)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-canary-stability)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-carp-clan)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-compress-raw-bzip2)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-compress-raw-zlib)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-config-inifiles)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-convert-asn1)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-convert-binhex)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-convert-tnef)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-convert-uulib)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-crypt-openssl-random)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-crypt-openssl-rsa)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-crypt-saltedhash)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-data-uuid)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-date-calc)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-dbd-mysql)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-dbd-sqlite)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-db-file)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-dbi)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-digest-hmac)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-digest-sha1)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-email-date-format)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-encode-locale)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-error)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-exporter-tiny)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-file-grep)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-file-libmagic)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-file-listing)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-filesys-df)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-geography-countries)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-html-parser)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-http-cookies)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-http-daemon)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-http-date)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-http-message)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-http-negotiate)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-innotop)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-io-compress)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-io-html)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-io-socket-inet6)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-io-socket-ip)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-io-socket-ssl)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-io-stringy)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-ip-country)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-jetty-distribution)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-json-pp)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-libwww)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-list-moreutils)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-lwp-mediatypes)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-lwp-protocol-https)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-mail-dkim)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-mail-spamassassin)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-mail-spf)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-mailtools)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-math-bigint)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-mime-tools)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-mime-types)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-mozilla-ca)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-netaddr-ip)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-net-cidr)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-net-cidr-lite)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-net-dns)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-net-dns-resolver-programmable)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-net-http)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-net-ldap)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-net-libidn)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-net-server)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-net-ssleay)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-parent)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-pflogsumm)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-policyd)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-socket)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-spamassassin-rules)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-term-readkey)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-timedate)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-unix-getrusage)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-unix-syslog)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-uri)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-www-robotrules)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-xml-namespacesupport)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-xml-parser)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-xml-parser-lite)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-xml-sax)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-xml-sax-base)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-xml-sax-expat)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-xml-simple)-(*).rpm",
                                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
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
                unstash 'artifacts-ubuntu-focal'
                unstash 'artifacts-rocky-8'
                script {
                    def server = Artifactory.server 'zextras-artifactory'
                    def buildInfo
                    def uploadSpec
                    def config

                    //ubuntu
                    buildInfo = Artifactory.newBuildInfo()
                    buildInfo.name += '-ubuntu'
                    uploadSpec = '''{
                        "files": [
                            {
                                "pattern": "artifacts/*focal*.deb",
                                "target": "ubuntu-rc/pool/",
                                "props": "deb.distribution=focal;deb.component=main;deb.architecture=amd64"
                            }
                        ]
                    }'''
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
                    Artifactory.addInteractivePromotion server: server,
                    promotionConfig: config,
                    displayName: 'Ubuntu Promotion to Release'
                    server.publishBuildInfo buildInfo

                    //rocky8
                    buildInfo = Artifactory.newBuildInfo()
                    buildInfo.name += '-centos8'
                    uploadSpec= '''{
                        "files": [
                            {
                                "pattern": "artifacts/(carbonio-altermime)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-amavisd)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-bdb)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-clamav)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-curl)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-cyrus-sasl)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-icu)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-jemalloc)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-krb5)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-libbsd)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-libevent)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-libmilter)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-libpng)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-libsodium)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-libtool)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-libxml2)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-mariadb)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-memcached)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-nginx)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-opendkim)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-openjdk)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-openjdk-cacerts)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-openldap)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-openssl)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-postfix)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-rsync)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-archive-zip)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-berkeleydb)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-bit-vector)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-cache-fastmmap)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-canary-stability)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-carp-clan)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-compress-raw-bzip2)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-compress-raw-zlib)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-config-inifiles)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-convert-asn1)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-convert-binhex)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-convert-tnef)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-convert-uulib)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-crypt-openssl-random)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-crypt-openssl-rsa)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-crypt-saltedhash)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-data-uuid)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-date-calc)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-dbd-mysql)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-dbd-sqlite)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-db-file)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-dbi)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-digest-hmac)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-digest-sha1)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-email-date-format)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-encode-locale)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-error)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-exporter-tiny)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-file-grep)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-file-libmagic)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-file-listing)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-filesys-df)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-geography-countries)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-html-parser)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-http-cookies)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-http-daemon)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-http-date)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-http-message)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-http-negotiate)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-innotop)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-io-compress)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-io-html)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-io-socket-inet6)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-io-socket-ip)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-io-socket-ssl)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-io-stringy)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-ip-country)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-jetty-distribution)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-json-pp)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-libwww)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-list-moreutils)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-lwp-mediatypes)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-lwp-protocol-https)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-mail-dkim)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-mail-spamassassin)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-mail-spf)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-mailtools)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-math-bigint)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-mime-tools)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-mime-types)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-mozilla-ca)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-netaddr-ip)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-net-cidr)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-net-cidr-lite)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-net-dns)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-net-dns-resolver-programmable)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-net-http)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-net-ldap)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-net-libidn)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-net-server)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-net-ssleay)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-parent)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-pflogsumm)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-policyd)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-socket)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-spamassassin-rules)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-term-readkey)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-timedate)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-unix-getrusage)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-unix-syslog)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-uri)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-www-robotrules)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-xml-namespacesupport)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-xml-parser)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-xml-parser-lite)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-xml-sax)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-xml-sax-base)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-xml-sax-expat)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            },
                            {
                                "pattern": "artifacts/(carbonio-perl-xml-simple)-(*).rpm",
                                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras"
                            }
                        ]
                    }'''
                    server.upload spec: uploadSpec, buildInfo: buildInfo, failNoOp: false
                    config = [
                            'buildName'          : buildInfo.name,
                            'buildNumber'        : buildInfo.number,
                            'sourceRepo'         : 'centos8-rc',
                            'targetRepo'         : 'centos8-release',
                            'comment'            : 'Do not change anything! Just press the button',
                            'status'             : 'Released',
                            'includeDependencies': false,
                            'copy'               : true,
                            'failFast'           : true
                    ]
                    Artifactory.addInteractivePromotion server: server,
                    promotionConfig: config,
                    displayName: 'Centos8 Promotion to Release'
                    server.publishBuildInfo buildInfo
                }
            }
        }
    }
}
