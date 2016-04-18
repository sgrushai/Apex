public with sharing class AddPharmacy {/*
 public Account account  { get; set; }
    public AddPharmacy() {
        
        String accountId = ApexPages.currentPage().getParameters().get('id');
        account = [SELECT Id, Name, Pharmacy__c FROM Account WHERE Id=:accountId];
    }
    
    public PageReference associate () {
        
        Account acc = new Account ( Id = account.Pharmacy__c, Covered_Entity__c= account.Id);
        //Account acc = new Account ( Id = '00163000002JRHk', Covered_Entity__c= '00163000002KAwl');
        try { 
            Database.update(acc);
        } catch (Exception error) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while associating.' + error.getMessage()));
        }
        
        PageReference page = new PageReference('/' + account.Id);
        
        return page.setRedirect(true);
    }
    
    public PageReference cancel () {
        PageReference page = new PageReference('/' + account.Id);
        return page.setRedirect(true);        
    }*/
    
}