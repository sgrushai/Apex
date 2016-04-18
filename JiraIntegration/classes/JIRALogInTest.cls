@isTest
public class JIRALogInTest {
   
  
    static testMethod void testGetSession() {
  
        JIRALogIn.body='';
        JIRALogIn.JiraSession='';
        JIRALogIn.password='test';
        JIRALogIn.status='OK';
        JIRALogIn.statusCode=200;
        JIRALogIn.username='test';
         Account  acc=new Account(Name='TestAcc', AccountNumber='we24234', AccountSource='E-mail',
                    Current_Platform__c='Fry', CurrencyIsoCode='USD'); 
        insert acc;  
        Opportunity opp=new Opportunity( Name='Test', 
        BusinessUnit__c='OPCO US', Registration_Date__c=date.today(), AccountId=acc.Id,
        ProjectType__c='Discovery', NewPlatform__c='IBM', StageName='Awaiting Information', Probability=0.00,
        CloseDate=date.today(), CurrencyIsoCode='USD');
        insert opp;
        
       

       ApexPages.StandardController con = new ApexPages.StandardController(opp);
       JIRALogIn  ext = new JIRALogIn(con);
   
    
    Test.startTest();
    
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseJIRAConnector());
       
     JIRALogIn.logInJIRA();
    
    Test.stopTest(); 
     
  }
   

}