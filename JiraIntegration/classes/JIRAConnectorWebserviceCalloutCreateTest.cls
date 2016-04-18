@isTest private class JIRAConnectorWebserviceCalloutCreateTest {
 
    // Tests createIssue method in JIRAConnectorWebserviceCalloutCreate.
    static testMethod void createIssueTest() {
        Account acc=new Account(Name='TestAcc', AccountNumber='we24234', AccountSource='E-mail',
                    Current_Platform__c='Fry', CurrencyIsoCode='USD'); 
        insert acc;
        Opportunity opp=new Opportunity( Name='Test', 
        BusinessUnit__c='OPCO US', Registration_Date__c=date.today(), AccountId=acc.Id,
        ProjectType__c='Discovery', NewPlatform__c='IBM', StageName='Awaiting Information', Probability=0.00,
        CloseDate=date.today(), CurrencyIsoCode='USD');
        insert opp; 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseJIRAConnector());
        JIRAConnectorWebserviceCalloutCreate.createIssue(TestFixture.baseUrl, TestFixture.systemId,
                TestFixture.objectType, opp.Id, TestFixture.projectKey, TestFixture.issueType);
        Test.stopTest();
    }
 
    // Tests buildRequest method in JIRAConnectorWebserviceCalloutCreate.
    static testMethod void buildRequestTest() {
        HttpRequest req = JIRAConnectorWebserviceCalloutCreate.buildRequest(TestFixture.baseUrl, TestFixture.username,
                TestFixture.password, TestFixture.systemId, TestFixture.objectType, TestFixture.objectId,
                TestFixture.projectKey, TestFixture.issueType);
        System.assertEquals(req.getMethod(), 'POST');
        System.assertEquals(req.getEndpoint(), 'http://jira.com/rest/customware/connector/1.0/1/Opportunity/1/issue/create.json');
    }
 
}