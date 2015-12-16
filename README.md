# proftpd

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

Install and configure proftpd and turns and maintain up the proftpd service.

## Setup

### What proftpd affects

* Installs proftpd-basic.
* Edits the /etc/proftpd/proftpd.conf (It will overridded).
* Ensures the service proftpd is running.
* Creates chrooted users.

### Beginning with proftpd

```puppet
class { 'proftpd':
}

class { 'proftpd::chrootuser':
  username => 'newuser',
  password => 'pa55w0rd',
  home     => '/home/newuser',
```

## Usage

### proftpd

No parameters allowed.

### chrootuser
* username: name of the user to add.
* password: password of the user to add.
* home: home of the user to add.

## Limitations

* Ubuntu: 14.
* Others: unsupported.
