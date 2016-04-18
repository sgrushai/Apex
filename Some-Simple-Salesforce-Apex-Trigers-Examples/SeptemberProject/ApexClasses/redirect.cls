public with sharing class redirect {
    private final Account acct;
    
    public redirect(ApexPages.StandardController controller) {
        this.acct = (Account)controller.getRecord();
        this.wholesalerList = new List<Account>();
    }
    
    public pagereference redirectme() {
        Account acc = [select Id, RecordTypeId from Account where Id=:ApexPages.currentPage().getParameters().get('Id')];
        String hostname = ApexPages.currentPage().getHeaders().get('Host'); 
        
        RecordType rtPharm = [SELECT Id, Name FROM RecordType where Name ='Pharmacy' limit 1];
        RecordType rtWhol = [SELECT Id, Name FROM RecordType where Name ='Wholesaler' limit 1];
        
        If (acc.RecordTypeId == rtPharm.Id) {
            String url2= 'https://'+hostname+'/apex/AccountsPharVF'+'?id='+ApexPages.currentPage().getParameters().get('Id')+'&'+'sfdc.override=1';
            pagereference pageref2 = new pagereference(url2);
            pageref2.setredirect(true);
            return pageref2;
        } else If (acc.RecordTypeId == rtWhol.Id) {
            String url3= 'https://'+hostname+'/apex/AccountsWholeVF'+'?id='+ApexPages.currentPage().getParameters().get('Id')+'&'+'sfdc.override=1';
            pagereference pageref3 = new pagereference(url3);
            pageref3.setredirect(true);
            return pageref3;
        } else return null;
    }
    
    
    
    public class CoverPharmacy {
        public String editURL {get; set;}
        public String objId {get; set;}
        public String recordName {get; set;}
        public String accId {get; set;}
        public String Name {get; set;} 
        public String BillingCountry {get; set;}
        public String BillingState {get; set;}
        public String BillingCity {get; set;}
        public String Verification_Stage {get; set;}
        public String Verification_Status {get; set;}
        public String LastModifiedDate {get; set;}
        public String CreatedByDate {get; set;}
        public String userName {get; set;}
        public String userId {get; set;}
        public String wholesaler {get;set;}
        public Decimal Overall_Progress {get;set;}
        public String Type {get;set;}
        public String EMR_Vendor {get;set;}
        public Decimal  Quantity_of_Pharmacies {get;set;}
        
        
        
    }
    
    private List<Account> wholesalerList;
    
    public List<Account> getWholesalerList() {
        if (this.wholesalerList.size() == 0) {
            return null;
        }
        return this.wholesalerList;
    }
    
    public void setWholesalerList(List<Account> acList) {
        this.wholesalerList = acList;
    }
    
    public list<CoverPharmacy> getCoverPharmacies() {
        RecordType rtPharm = [SELECT Id, Name FROM RecordType where Name ='Pharmacy' limit 1];
        
        list<Cover_Entity_Pharmacy__c> listObj = new list<Cover_Entity_Pharmacy__c>();
        if (acct.RecordTypeId != rtPharm.id) {
            listObj = [SELECT id, Name, Pharmacy__c, Covered_Entity__c, LastModifiedDate, CreatedById, CreatedDate
                       FROM Cover_Entity_Pharmacy__c WHERE Covered_Entity__c =: acct.id];
        } else {
            listObj = [SELECT id, Name, Pharmacy__c, Covered_Entity__c, LastModifiedDate, CreatedById, CreatedDate 
                       FROM Cover_Entity_Pharmacy__c WHERE Pharmacy__c =: acct.id];
        }
        
        list<CoverPharmacy> pharmList = new list<CoverPharmacy>();
        for(Cover_Entity_Pharmacy__c tmp: listObj) {
            CoverPharmacy p = new CoverPharmacy();
            Account a = new Account();
            
            if (acct.Id == tmp.Covered_Entity__c) {
                a = [SELECT Name, BillingCountry, BillingState, BillingCity, 
                     Verification_Stage__c, Verification_Status__c, Wholesaler__c 
                     FROM Account WHERE id =: tmp.Pharmacy__c][0];
                
                if (a.Wholesaler__c != null) {
                    Account temp = [SELECT Id, Name, Phone, Fax, BillingCountry, BillingState, BillingCity,
                                    LastModifiedDate, CreatedBy.Name, CreatedDate
                                    FROM Account WHERE id =: a.Wholesaler__c];
                     p.wholesaler=temp.Name;
                    if (!wholesalerList.isEmpty()) {
                        for (integer i = 0; i < wholesalerList.size(); i++) {
                            if (wholesalerList.get(i).id == temp.id) {
                                temp = null;
                                break;
                            }
                        }
                    }
                    if(temp != null) {
                        wholesalerList.add(temp);
                    }
                }
            } else {
                a = [SELECT Name, BillingCountry, BillingState, BillingCity, 
                     Verification_Stage__c, Verification_Status__c, Overall_Progress__c, Type, EMR_Vendor__c, Quantity_of_Pharmacies__c 
                     FROM Account WHERE id =: tmp.Covered_Entity__c][0];
                p.Overall_Progress=a.Overall_Progress__c;
                p.Type=a.Type;
                p.EMR_Vendor=a.EMR_Vendor__c;
                p.Quantity_of_Pharmacies=a.Quantity_of_Pharmacies__c;
            }
            
            p.editURL = '/' + tmp.id + '/e?retURL=%2F' + tmp.id;
            p.objId = tmp.id;
            p.recordName = tmp.Name;
            p.Name = a.Name;
            p.accId = a.Id;
            p.BillingCountry = a.BillingCountry;
            p.BillingState = a.BillingState;
            p.BillingCity = a.BillingCity;
            p.Verification_Stage = a.Verification_Stage__c;
            p.Verification_Status = a.Verification_Status__c;
            Datetime dt = tmp.LastModifiedDate;
            p.LastModifiedDate = dt.format('MM/dd/yyyy');
            User u = [SELECT Name FROM User WHERE id =: tmp.CreatedById];
            dt = tmp.CreatedDate;
            p.CreatedByDate = '' + dt.format('MM/dd/yyyy hh:mm a');
            p.userName = u.Name;
            p.userId = u.id;
           
         
            pharmList.add(p);
        }
        
        if (pharmList.size() == 0) {
            return null;
        }
        return pharmList;
    }
    
    public void deletingRecord() {
        String phId = ApexPages.CurrentPage().getParameters().get('phId');
        Cover_Entity_Pharmacy__c ph = [SELECT id FROM Cover_Entity_Pharmacy__c WHERE id =: phId];
        delete ph;
    }
}