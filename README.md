# Carbonio Third-Party Dependencies

This repository contains build configurations and patches for third-party dependencies used by Carbonio.

The repository is organized into two main directories:

- **`native/`** - Build configurations for native system packages including:
  - Mail Transfer Agent (Postfix)
  - Web Server (Nginx)
  - Directory Services (OpenLDAP)
  - Database (MariaDB)
  - Caching (Memcached)
  - Antivirus (ClamAV)
  - Authentication (Cyrus-SASL, Kerberos)
  - Cryptography (OpenSSL, libsodium)
  - And other supporting libraries

- **`perl/`** - Build configurations for Perl modules required by Carbonio components

## Quick Start

### Prerequisites

- Docker or Podman installed
- Make

### Building Packages

```bash
# Build all packages for Ubuntu 22.04
make build TARGET=ubuntu-jammy

# Build only native packages for Rocky Linux 9
make build-native TARGET=rocky-9

# Build only Perl packages for Ubuntu 24.04
make build-perl TARGET=ubuntu-noble
```

### Supported Targets

- `ubuntu-jammy` - Ubuntu 22.04 LTS
- `ubuntu-noble` - Ubuntu 24.04 LTS
- `rocky-8` - Rocky Linux 8
- `rocky-9` - Rocky Linux 9

### Configuration

You can customize the build by setting environment variables:

```bash
# Use a specific container runtime
make build TARGET=ubuntu-jammy CONTAINER_RUNTIME=docker

# Use a different output directory
make build TARGET=rocky-9 OUTPUT_DIR=./my-packages
```

## Installation

These packages are distributed as part of the [Carbonio platform](https://zextras.com/carbonio). To install:

### Ubuntu (Jammy/Noble)

```bash
apt-get install <package-name>
```

### Rocky Linux (8/9)

```bash
yum install <package-name>
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for information on how to contribute to this project.

## License

The build scripts, patches, and configuration files in this repository are licensed under the GNU Affero General Public License v3.0 - see the [LICENSE.md](LICENSE.md) file for details.

This repository does not contain the source code of the third-party projects it packages. The PKGBUILD scripts download upstream sources at build time from their original locations. Each upstream project retains its own license, and the resulting built packages are distributed under those original licenses. Please refer to each component's upstream documentation for specific licensing information.
