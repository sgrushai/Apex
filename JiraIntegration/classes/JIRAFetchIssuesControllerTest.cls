@isTest
private class JIRAFetchIssuesControllerTest {
 

    static testMethod void buildRequestTest() {
        HttpRequest req = GetJIRAIssues.buildRequest(TestFixture.baseUrl, TestFixture.username,
            TestFixture.password, TestFixture.systemId, TestFixture.objectType, TestFixture.objectId);
        System.assertEquals(req.getMethod(), 'GET');
        System.assertEquals(req.getEndpoint(), 'http://jira.com/rest/customware/connector/1.0/1/Opportunity/1/issue/fetch.json');
    }
   
 

    static testMethod void getIssuesJSONTest() {
        Account acc=new Account(Name='TestAcc', AccountNumber='we24234', AccountSource='E-mail',
                    Current_Platform__c='Fry', CurrencyIsoCode='USD'); 
        insert acc;
        Opportunity opp=new Opportunity( Name='Test', 
        BusinessUnit__c='OPCO US', Registration_Date__c=date.today(), AccountId=acc.Id,
        ProjectType__c='Discovery', NewPlatform__c='IBM', StageName='Awaiting Information', Probability=0.00,
        CloseDate=date.today(), CurrencyIsoCode='USD');
        insert opp; 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseFetchJIRAIssue());
        GetJIRAIssues controller = new GetJIRAIssues(new ApexPages.StandardController(opp));
        controller.getIssuesJSON();
        controller.is();  
      GetJIRAIssues.JIRAIssue j= new GetJIRAIssues.JIRAIssue();
        j.summary='';
        j.project='';
        j.reporter='';
        j.key='';
        j.status='';
        j.resolution='';
        j.url='';
        j.type='';
        j.assignee='';
        j.description='';
        j.priority='';
        j.due_date='';
        Test.stopTest();       
    }
   
    
    
 
}