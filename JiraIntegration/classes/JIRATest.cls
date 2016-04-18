@isTest private class JIRATest {
 static JIRA ext;
    static Account acc;
    static PageReference pref;
   
     static void init(){
    acc=new Account(Name='TestAcc', AccountNumber='we24234', AccountSource='E-mail',
                    Current_Platform__c='Fry', CurrencyIsoCode='USD'); 
        insert acc;
        Opportunity opp1=new Opportunity( Name='Test', 
        BusinessUnit__c='OPCO US', Registration_Date__c=date.today(), AccountId=acc.Id,
        ProjectType__c='Discovery', NewPlatform__c='IBM', StageName='Awaiting Information', Probability=0.00,
        CloseDate=date.today(), CurrencyIsoCode='USD');
        Opportunity opp2=new Opportunity( Name='Test2',
        BusinessUnit__c='OPCO UK', Registration_Date__c=date.today(), AccountId=acc.Id,
        ProjectType__c='Discovery', NewPlatform__c='IBM', StageName='On Hold', Probability=0.00,
        CloseDate=date.today(), CurrencyIsoCode='USD');
        Opportunity opp3=new Opportunity( Name='Test3',
        BusinessUnit__c='OPCO DACH', Registration_Date__c=date.today(), AccountId=acc.Id,
        ProjectType__c='Discovery', NewPlatform__c='IBM', StageName='On Hold', Probability=0.00,
        CloseDate=date.today(), CurrencyIsoCode='USD');
        List<Opportunity> oppList=new List<Opportunity>();
        oppList.add(opp1);
        oppList.add(opp2);
        oppList.add(opp3);
        insert oppList; 
        oppList[0].High_Level_Estimation_Document__c='https://jira-stage.ontrq.com/browse/issuekey';
        oppList[1].Link_to_OnePoint_Project__c='https://jira-stage.ontrq.com/browse/issuekey[3]';
        update oppList;
        
 
        
        pref = Page.OppB;
        pref.getParameters().put('id',opp1.id);
        Test.setCurrentPage(pref);

       ApexPages.StandardController con = new ApexPages.StandardController(opp1);
       ext = new JIRA(con);

    }
    // Tests authHeader method in JIRA class.
    static testMethod void authHeaderTest() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseJIRAConnector());
        init();
        String authHeader = JIRA.authHeader(TestFixture.username, TestFixture.password);
        System.assertEquals(authHeader, 'Basic eW91ckpJUkF1c2VybmFtZTp5b3VySklSQXBhc3N3b3Jk');
    }
     
    // Tests sendRequest method in JIRA class.
    static testMethod void sendRequestTest() {
       
        JIRA.password='test';
        JIRA.username='test';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseJIRAConnector());
       
        HttpRequest req = new HttpRequest();
        HttpResponse res = JIRA.sendRequest(req);
        System.assertEquals(res.getStatusCode(), 200);
    }
   
    // Tests currentUserIsNotJiraAgent method in JIRA class.
    static testMethod void currentUserIsNotJiraAgentTest() {
        
        System.assert(JIRA.currentUserIsNotJiraAgent());
               
           }
 
}