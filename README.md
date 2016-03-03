# proftpd

![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)

**AtlasIT-AM/eyp-proftpd**: [![Build Status](https://travis-ci.org/AtlasIT-AM/eyp-proftpd.png?branch=master)](https://travis-ci.org/AtlasIT-AM/eyp-proftpd)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What proftpd affects](#what-proftpd-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with proftpd](#beginning-with-proftpd)
4. [Usage](#usage)
5. [Reference](#reference)
5. [Limitations](#limitations)
6. [Development](#development)

## Overview

Install and configure proftpd and turns and maintain up the proftpd service

## Setup

### What proftpd affects

* Installs proftpd
* Edits the /etc/proftpd/proftpd.conf (It will overridded)
* Ensures the service proftpd is running
* Creates users

### Beginning with proftpd

```puppet
class { 'proftpd': }

class { 'proftpd::user':
  username => 'newuser',
  password => 'pa55w0rd',
  home     => '/home/newuser',
}
```

## Usage

### proftpd

* **systemlog**: The filename argument should contain an absolute path, and should not be to a file in a nonexistent directory, in a world-writeable directory, or be a symbolic link (unless AllowLogSymlinks is set to on). Use of this directive overrides any facility set by the SyslogFacility directive. Additionally, the special keyword NONE can be used which disables all syslog style logging for the entire configuration.

### user
* username: name of the user to add.
* password: password of the user to add.
* home: home of the user to add.

## Limitations

* Ubuntu: 14.04
