#!/bin/sh

chmod 0400 /etc/ssh/keys/*

exec "$@"
