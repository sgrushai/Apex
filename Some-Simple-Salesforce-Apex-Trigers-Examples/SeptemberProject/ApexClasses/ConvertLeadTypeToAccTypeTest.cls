@isTest(SeeAllData=true)
public class ConvertLeadTypeToAccTypeTest {

public static testMethod void myUnitTest() {
    
RecordType rt1 = [SELECT Id, Name FROM RecordType where Name ='Pharmacy' limit 1];
Account acc1=new Account(Name='test1',RecordTypeId=rt1.Id, AccountRecord_Type__c='Pharmacy');
insert acc1; 

RecordType rt2 = [SELECT Id, Name FROM RecordType where Name ='Wholesaler' limit 1];
Account acc2=new Account(Name='test2',RecordTypeId=rt2.Id, AccountRecord_Type__c='Wholesaler');
insert acc2; 

RecordType rt3 = [SELECT Id, Name FROM RecordType where Name !='Pharmacy' and Name!='Wholesaler' limit 1];
Account acc3=new Account(Name='test3',RecordTypeId=rt3.Id, AccountRecord_Type__c=null);
insert acc3; 

Account acc4=new Account(Name='test3', AccountRecord_Type__c=null);
insert acc4;

Lead lead=new Lead(LastName='Doe',FirstName='John',Company='Test',Status='Qualified', Lead_Type__c='Pharmacy', Verification_Status__c='Take Over');
insert lead;
Database.LeadConvert lc = new database.LeadConvert();
lc.setLeadId(lead.id);
lc.setDoNotCreateOpportunity(false);
lc.setConvertedStatus('Qualified');
Database.LeadConvertResult lcr = Database.convertLead(lc);
System.assert(lcr.isSuccess());

Lead lead2=new Lead(LastName='Doe',FirstName='John',Company='Test',Status='Qualified', Lead_Type__c='Hospital', Verification_Status__c='Take Over');
insert lead2;
Database.LeadConvert lc2 = new database.LeadConvert();
lc2.setLeadId(lead2.id);
lc2.setDoNotCreateOpportunity(false);
lc2.setConvertedStatus('Qualified');
Database.LeadConvertResult lcr2 = Database.convertLead(lc2);
System.assert(lcr2.isSuccess());


}
}