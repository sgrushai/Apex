@isTest
private class TestTriggers {
    static testMethod void myUnitTest() {
                
        Account acc=new Account(Name='Test');
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'test opp';
        opp.StageName = 'Awaiting Information';
        opp.CloseDate = Date.Today();
        opp.Amount = 100;
       
        insert opp;
        
        Invoice__c inv = new Invoice__c();
        inv.AccountId__c = acc.Id;
        inv.OpportunityId__c = opp.Id;
        inv.Amount__c = 100;
        inv.Status__c = 'Prospect';
        insert inv;
        
    }
}