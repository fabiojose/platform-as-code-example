Feature: Replication Controller
    As a user of Openshift PaaS
    I want to query Pods managed by a replication controller
    So I will get all of then running and with a right setup

    Scenario: All pods are running
	Given I am logged in Openshift as "developer"
	  And access to "oss-uat" namespace
	When query the pods of "apigateway" replication controller
	Then all pods managed by "apigateway" replication controller should have the status equals to "running"
