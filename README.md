# Eight-Eight-Two

Eight-Eight-Two (named for one of the original DNS RFCs) is DNS server framework. By itself it runs and listens for queries. You provide code for the backend. This allows for building of any sort of DNS zone, dynamically or otherwise.

## Installation

Install it yourself as:

    gem install eight-eight-two

## Usage

Install the gem as above. Run 'eet' from the command-line to start up the server. You'll need a config file to describe which backends you want to use, where to find them, and what port to run them on.

====================================================================
Copyright (c) 2014 Tony Doan <tdoan@tdoan.com>.  All rights reserved.

This software is licensed as described in the file LICENSE.txt, which
you should have received as part of this distribution.  The terms
are also available at http://github.com/tdoan/eight-eight-two/tree/master/LICENSE.txt.
If newer versions of this license are posted there, you may use a
newer version instead, at your option.
====================================================================
