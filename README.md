# proftpd

![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)

**NTTCom-MS/eyp-proftpd**: [![Build Status](https://travis-ci.org/NTTCom-MS/eyp-proftpd.png?branch=master)](https://travis-ci.org/NTTCom-MS/eyp-proftpd)

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
    * [Contributing](#contributing)

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

proftpd::user { 'user':
  password => 'pa55w0rd',
  home     => '/home/newuser',
}
```

## Usage

### Blind directories

```puppet
class { 'proftpd':
        blind_directories => [ '/tmp/example' ],
}
```

### IP restrictions

```puppet
proftpd::class { 'allowipclass':
  ip => [ '1.2.3.4', '5.6.7.8' ],
}

proftpd::limitlogin { 'test':
  limituser => [ 'caca' ],
  allowclass => 'allowipclass',
}
```

this is automatically added if **proftpd::user::login_ips** is used

## Reference

### classes

#### proftpd

* **port** Set the port for the control socket (default: 21)
* **use_ipv6** Enable/Disable IPv6 support (default: false)
* **servername** Configure the name displayed to connecting users (default: private server)
* **serverident** Set the message displayed on connect (default: undef)
* **deferwelcome** Don't show welcome message until user has authenticated (default: true)
* **require_valid_shell** Allow connections based on /etc/shells (default: false)
* **maxinstances** Sets the maximum number of child processes to be spawned (default: 30)
* **allowoverwrite**  Enable files to be overwritten(default: true)
* **transferlog** Specify the path to the transfer log (default: undef)
* **user** Set the user the daemon will run as (default: proftpd)
* **group** Set the group the server normally runs as (default: nogroup)
* **systemlog**: The filename argument should contain an absolute path, and should not be to a file in a nonexistent directory, in a world-writeable directory, or be a symbolic link (unless AllowLogSymlinks is set to on). Use of this directive overrides any facility set by the SyslogFacility directive. Additionally, the special keyword NONE can be used which disables all syslog style logging for the entire configuration. (default: /var/log/proftpd/proftpd.log)
* **user** Set the user the daemon will run as (default: system-dependent)
* **group** Set the group the server normally runs as (default: system-dependent)
* **umask_files** Set the default Umask for files (022)
* **umask_dirs** Set the default Umask for directories (022)
* **modulepath** Sets the module path (default: system-dependent)
* **blind_directorues** Configure blind directories provided by a list (default: undef)
* **defaultroot** Sets default chroot directory (default: undef)

### defines

#### proftpd::user

* **username**: name of the user to add (default: resource's name)
* **password**: password of the user to add
* **home**: home of the user to add
* **managehome**: Whether to manage the home directory (default: true)
* **allowdupe**: Whether to allow duplicate UIDs (default: false)
* **uid**: user ID; must be specified numerically (default: undef)
* **gid**: primary group ID; must be specified numerically (default: undef)
* **shell**: user's shell (default: /bin/false)
* **chroot**: Whether to chroot to user's home (default: true)
* **disablessh**: Whether to disable ssh login. Requires *eyp-openssh* (default: true)
* **login_ips**: list of IPs allowed to login - **proftpd only** (default: undef)

#### proftpd::class

* **ip**: IP array
* **classname**: (default: resource's name)

#### proftpd::limitlogin

* **limitloginname** (default: resource's name)
* **limituser**: array of users to limit (default: undef)
* **allowclass**: AllowClass (default: undef)
* **defaultaction**: default action to this limitlogin instance (default: **DenyAll**)

## Limitations

Tested on:
* Ubuntu: 14.04

## Development

We are pushing to have acceptance testing in place, so any new feature should
have some test to check both presence and absence of any feature

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
