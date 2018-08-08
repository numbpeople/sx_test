*** Settings ***
Documentation     Setup Init Data
...               Teardown Data
Suite Setup       Setup Init Data
Suite Teardown    # Teardown Data
Force Tags        appui
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Library           uuid
Resource          ../../commons/CollectionData/Base_Collection.robot
