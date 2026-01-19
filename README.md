# Carbonio Third-Party Dependencies

This repository contains build configurations and patches for third-party dependencies used by Carbonio.

## Overview

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

## Building

This repository uses [YAP (Yet Another Packager)](https://github.com/M0RF30/yap) for building packages. Refer to the YAP documentation for build instructions.

## License

The build scripts, patches, and configuration files in this repository are licensed under the GNU Affero General Public License v3.0 - see the [COPYING](COPYING) file for details.

This repository does not contain the source code of the third-party projects it packages. The PKGBUILD scripts download upstream sources at build time from their original locations. Each upstream project retains its own license, and the resulting built packages are distributed under those original licenses. Please refer to each component's upstream documentation for specific licensing information.
