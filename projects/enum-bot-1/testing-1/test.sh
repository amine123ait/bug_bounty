#!/bin/bash

echo "hello :))"

function ignore_ctrlc() {
        echo "ignored"
}
domain=test.com
trap ignore_ctrlc SIGINT SIGTERM
echo "Target : $domain ✅"
sleep 1
echo "Target : $domain ✅"
sleep 1
echo "Target : $domain ✅"
sleep 1
echo "Target : $domain ✅"
sleep 1
echo "Target : $domain ✅"
sleep 1
echo "Target : $domain ✅"
sleep 1
echo "Target : $domain ✅"
sleep 1
echo "Target : $domain ✅"
sleep 1
echo "Target : $domain ✅"
sleep 1
echo "Target : $domain ✅"
sleep 1
echo "Target : $domain ✅"
sleep 1
echo "Target : $domain ✅"
sleep 1
echo "Target : $domain ✅"
sleep 1
echo "Target : $domain ✅"
sleep 1
echo "Target : $domain ✅"
sleep 1
echo "Target : $domain ✅"
