#!/bin/bash

if [ ! -d "test_output" ]; then
    mkdir test_output
fi

RESULT_FILE="kefuapi-tickets/RFResult.txt"
JENKINS_HOME=$1

robot -d test_output kefuapi-tickets/1.Agent-Tickets.robot > $RESULT_FILE 2>&1

/usr/bin/python kefuapi-tickets/ParseRFResult.py $RESULT_FILE

zip -r report.zip test_output/*

cp test_output/report.html $JENKINS_HOME/email-templates/report-html.template
