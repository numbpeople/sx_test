*** Settings ***
Suite Setup       Setup Init Data
Suite Teardown    Teardown Data
Force Tags        base
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Library           uuid
Resource          ../../commons/CollectionData/Base_Collection.robot
