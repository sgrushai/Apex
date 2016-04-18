@isTest(SeeAllData=true)
private class CreateJIRAIssueControllerTest {   
    static CreateJIRAIssueController ext;
    static Account acc;
    static PageReference pref;
   
    private static void init(){
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
        
        CreateJIRAIssueController.status='OK';
        CreateJIRAIssueController.body='';
        CreateJIRAIssueController.statusCode=200;
        CreateJIRAIssueController.oppId=opp1.Id;
        CreateJIRAIssueController.btn=true;
        CreateJIRAIssueController.btn2=false;
        if(oppList[0].BusinessUnit__c=='OPCO US'){
        CreateJIRAIssueController.BusinessUnit='SEE';
        }
        pref = Page.OppB;
        pref.getParameters().put('id',opp1.id);
        Test.setCurrentPage(pref);

       ApexPages.StandardController con = new ApexPages.StandardController(opp1);
       ext = new CreateJIRAIssueController(con);

    }

    // Tests createIssue method in JIRAConnectorWebserviceCalloutCreate.
    static testMethod void createIssueTest() { 
        init();
        CreateJIRAIssueController.baseUrl=  'http://jira.com'; 
          CreateJIRAIssueController.systemId= '1';
          CreateJIRAIssueController.objectType='Opportunity';
          CreateJIRAIssueController.objectId= '1';
          CreateJIRAIssueController.projectKey='salesforce';
          CreateJIRAIssueController.issueType='bug';

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseJIRAConnector()); 
       HttpResponse res = new HttpResponse();       
        CreateJIRAIssueController.evaluateRequest();
          CreateJIRAIssueController.resultRequestHighLevel( res);
           CreateJIRAIssueController.resultRequestOnePoint( res);
        CreateJIRAIssueController.resultevaluateRequest(res);
        CreateJIRAIssueController.requestOnePoint();
        CreateJIRAIssueController.requestHighLevel();
        Test.stopTest();
   
    }
 
    // Tests buildRequest method in JIRAConnectorWebserviceCalloutCreate.
    static testMethod void buildRequestTest() {
          CreateJIRAIssueController.baseUrl=  'http://jira.com'; 
          CreateJIRAIssueController.systemId= '1';
          CreateJIRAIssueController.objectType='Opportunity';
          CreateJIRAIssueController.objectId= '1';
          CreateJIRAIssueController.projectKey='salesforce';
          CreateJIRAIssueController.issueType='bug';
        HttpRequest req =  CreateJIRAIssueController.buildRequest();
        System.assertEquals(req.getMethod(), 'POST');
        System.assertEquals(req.getEndpoint(), 'http://jira.com/rest/customware/connector/1.0/1/Opportunity/1/issue/create.json');
    }
    
}