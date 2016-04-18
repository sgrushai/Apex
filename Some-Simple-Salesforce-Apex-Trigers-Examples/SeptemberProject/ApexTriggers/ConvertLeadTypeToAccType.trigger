trigger ConvertLeadTypeToAccType on Account (after insert) {
    
    List<Account> accts = new List<Account>();
    
   
for (Account a: Trigger.new) {
Account acctToUpdate = new Account(); 

List<Account> la = new List<Account>();
la.addAll([SELECT Id,AccountRecord_Type__c from Account where Id =: a.Id]);
    //a.addError(la[0].AccountRecord_Type__c+'');
    
    String tmp = la[0].AccountRecord_Type__c;
    if (tmp!=null && tmp.equalsIgnoreCase('Pharmacy')) {
    	acctToUpdate.Id=la[0].Id;
        RecordType rt = [SELECT Id FROM RecordType 
                       WHERE Name = 'Pharmacy'][0];
        ID myId = rt.Id;
        acctToUpdate.RecordTypeId = myId;
    } else if(tmp!=null) {
    	acctToUpdate.Id=la[0].Id;
        RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'Covered Entity'][0];
        ID myId = rt.Id;
        acctToUpdate.RecordTypeId = myId;
    }
    if(acctToUpdate.id!=null){
    	//a.addError(acctToUpdate.id+'');
    accts.add(acctToUpdate);
    }
}
    if(accts.size()>0){
 update accts;   
    }
    
}