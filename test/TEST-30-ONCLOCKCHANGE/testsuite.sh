#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
set -ex
set -o pipefail

systemd-analyze set-log-level debug
systemd-analyze set-log-target console

systemctl disable --now systemd-timesyncd.service

timedatectl set-timezone Europe/Berlin
timedatectl set-time 1980-10-15

systemd-run --on-timezone-change touch /tmp/timezone-changed
systemd-run --on-clock-change touch /tmp/clock-changed

! test -f /tmp/timezone-changed
! test -f /tmp/clock-changed

timedatectl set-timezone Europe/Kiev

while ! test -f /tmp/timezone-changed ; do sleep .5 ; done

timedatectl set-time 2018-1-1

while ! test -f /tmp/clock-changed ; do sleep .5 ; done

systemd-analyze set-log-level info

echo OK > /testok

exit 0
