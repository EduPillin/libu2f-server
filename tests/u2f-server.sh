#!/bin/sh

# Copyright (c) 2014 Yubico AB
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# # Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#
# # Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following
# disclaimer in the documentation and/or other materials provided
# with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

EXIT_SUCCESS=0
EXIT_FAILURE=99

MKTEMP="/bin/mktemp"
RM="/bin/rm"

ORIGIN="http://yubico.com"
APPID="http://yubico.com"
AUTH_PARAM="authenticate"
REGISTER_PARAM="register"

REG_CHALLENGE1="TVgGf_GfMfVf4L2KiNmLdyIoR59ez4qtmLwwdG4-lkI"
REG_REQUEST1="{ \"challenge\": \"TVgGf_GfMfVf4L2KiNmLdyIoR59ez4qtmLwwdG4-lkI\", \"version\": \"U2F_V2\", \"appId\": \"http:\/\/yubico.com\" }"
REG_RESPONSE1="{ \"registrationData\": \"BQRjk4BrghuG1RR0nIzda230YhTj4\
iMpyFvZpRyZf37eKNAWPmcmPbsouRxw2NUj2Z0kPlbUIaFlAD88Ez_bGyzRQNaWpOywZ1-\
DkgpDiCnej_COzgsEwXO2Cgwyd2IZ_5wK7b4L85-T9DZHBtgNYnsxdYekFvDikKdd5TND-\
WVUn9cwggIbMIIBBaADAgECAgR1o_Z1MAsGCSqGSIb3DQEBCzAuMSwwKgYDVQQDEyNZdWJ\
pY28gVTJGIFJvb3QgQ0EgU2VyaWFsIDQ1NzIwMDYzMTAgFw0xNDA4MDEwMDAwMDBaGA8yM\
DUwMDkwNDAwMDAwMFowKjEoMCYGA1UEAwwfWXViaWNvIFUyRiBFRSBTZXJpYWwgMTk3MzY\
3OTczMzBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABBmjfkNqa2mXzVh2ZxuES5coCvvEN\
xDMDLmfd-0ACG0Fu7wR4ZTjKd9KAuidySpfona5csGmlM0Te_Zu35h_wwujEjAQMA4GCis\
GAQQBgsQKAQIEADALBgkqhkiG9w0BAQsDggEBAb0tuI0-CzSxBg4cAlyD6UyT4cKyJZGVh\
WdtPgj_mWepT3Tu9jXtdgA5F3jfZtTc2eGxuS-PPvqRAkZd40AXgM8A0YaXPwlT4s0RUTY\
9Y8aAQzQZeAHuZk3lKKd_LUCg5077dzdt90lC5eVTEduj6cOnHEqnOr2Cv75FuiQXX7QkG\
QxtoD-otgvhZ2Fjk29o7Iy9ik7ewHGXOfoVw_ruGWi0YfXBTuqEJ6H666vvMN4BZWHtzhC\
0k5ceQslB9Xdntky-GQgDqNkkBf32GKwAFT9JJrkO2BfsB-wfBrTiHr0AABYNTNKTceA5d\
tR3UVpI492VUWQbY3YmWUUfKTI7fM4wRQIhAJnjtf2irhjgUbsdFUft-38T4d70e7Dhsyn\
VR_cy7Y2ZAiByN798SHtk61WmSsGcQ9e7hUW3OKxYGjgvKAwEMDHuKQ==\", \"clientD\
ata\": \"eyAiY2hhbGxlbmdlIjogIlRWZ0dmX0dmTWZWZjRMMktpTm1MZHlJb1I1OWV6N\
HF0bUx3d2RHNC1sa0kiLCAib3JpZ2luIjogImh0dHA6XC9cL3l1Ymljby5jb20iLCAidHl\
wIjogIm5hdmlnYXRvci5pZC5maW5pc2hFbnJvbGxtZW50IiB9\" }"

AUTH_CHALLENGE1="uejb2GF9ICDgPYgJFDqz0C0X-TPLg6twVTf-SOdSyO8"
AUTH_RESPONSE1="{ \"signatureData\": \"AQAAADMwRQIgJ_ugO8pZSxyUh1XX2kg\
KE00zC2Bnen8yhabO79IQmSsCIQChw_psGoSthXVw1drDmjW30fjABJxOZBouSzhsELrLR\
g==\", \"clientData\": \"eyAiY2hhbGxlbmdlIjogInVlamIyR0Y5SUNEZ1BZZ0pGR\
HF6MEMwWC1UUExnNnR3VlRmLVNPZFN5TzgiLCAib3JpZ2luIjogImh0dHA6XC9cL3l1Yml\
jby5jb20iLCAidHlwIjogIm5hdmlnYXRvci5pZC5nZXRBc3NlcnRpb24iIH0=\", \"key\
Handle\": \"1pak7LBnX4OSCkOIKd6P8I7OCwTBc7YKDDJ3Yhn_nArtvgvzn5P0NkcG2A\
1iezF1h6QW8OKQp13lM0P5ZVSf1w\" }"


KEYFILE=$($MKTEMP)
USERFILE=$($MKTEMP)
U2FSBIN="/home/adma/yubico/libu2f-server/src/u2f-server"
echo $REG_RESPONSE1 | $U2FSBIN -a$REGISTER_PARAM -o$ORIGIN -i$APPID -c$REG_CHALLENGE1 -p$USERFILE -k$KEYFILE
RESULT=$?
if [ $RESULT -ne 0 ]; then
    exit $EXIT_FAILURE
fi

echo $AUTH_RESPONSE1 | $U2FSBIN -a$AUTH_PARAM -o$ORIGIN -i$APPID -c$AUTH_CHALLENGE1 -p$USERFILE -k$KEYFILE
RESULT=$?
if [ $RESULT -ne 0 ]; then
    exit $EXIT_FAILURE
fi

$($RM $KEYFILE)
$($RM $USERFILE)

echo $EXIT_FAILURE $EXIT_SUCCESS

exit $EXIT_SUCCESS
