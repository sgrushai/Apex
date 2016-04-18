public with sharing class RelatedControllerLoc 
{
 private ApexPages.StandardController stdCtrl;
  
 public RelatedControllerLoc(ApexPages.StandardController std)
 {
  stdCtrl=std;
 }
  
 public void ContactPopulated()
 {
  Location__c cont=(Location__c) stdCtrl.getRecord();
    
    if (cont.Primary_Contact__c!=null)
     {
        cont.Primary_Contact__r=[select Phone, Email, Contact_Type__c  from Contact where id=:cont.Primary_Contact__c]; 
     }
      Location__c cont1=(Location__c) stdCtrl.getRecord();
    
    if (cont1.Principal_Contact__c!=null)
     {
        cont1.Principal_Contact__r=[select Phone, Email, Contact_Type__c  from Contact where id=:cont1.Principal_Contact__c]; 
     }
          Location__c cont2=(Location__c) stdCtrl.getRecord();
    
    if (cont1.Second_Contact__c!=null)
     {
        cont2.Second_Contact__r=[select Phone, Email, Contact_Type__c  from Contact where id=:cont2.Second_Contact__c]; 
     }
  
 }
}