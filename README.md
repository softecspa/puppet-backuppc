puppet-backuppc
===============

manage backuppc server and client config

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with [Modulename]](#setup)
 * [Server Side](#server-side)
 * [Client Side](#client-side)
4. [Limitations - OS compatibility, etc.](#limitations)

##Overview
This module actually manage installation of backuppc and authentication through keypair between server and clients.

##Module Description
On server side this module:
 * install backuppc
 * if enabled, generate a keypair for user backuppc
 * use a custom fact to export publick key as ssh\_authorized\_key resource tagging the resource

on client side:
 * create a local user used by server to connect to the clients
 * using a tag, import public key of backuppc server's user in authorized\_key of local user created above

## TODO
Management of backup directory configuration

##Setup
###Server Side
    include backuppc::server

if you want to enable export of the public\_key:
    class {'backuppc::server':
      server_tag => 'foo'
    }

###Client Side
    include backuppc::client

if you want to enable import of server's user public\_key:

    class {'backuppc::client':
      server_tag => 'foo'
    }

## Limitations
You cannot modify username on server side if you want to use ssk\_key exchange.
