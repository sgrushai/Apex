public with sharing class RecordsMTMController {
  /*  private ApexPages.StandardController std;
    
    public RecordsMTMController(ApexPages.StandardController std) {
        this.std = std;
    }
    
    public void rerenderPharmacy() {
        Cover_Entity_Pharmacy__c obj = (Cover_Entity_Pharmacy__c) std.getRecord();
        if(obj.Pharmacy__c != null) {
            obj.Pharmacy__r = [SELECT Name, Phone, Verification_Status__c, Verification_Stage__c, 
                                    Pharmacy_active_status__c, Wholesaler__c, BillingCountry, BillingState, 
                                    BillingCity, ShippingCountry, ShippingState, ShippingCity 
                               FROM Account WHERE id =: obj.Pharmacy__c];
        }
    }
    
    public void saveChangesInRecord() {
        Cover_Entity_Pharmacy__c obj = (Cover_Entity_Pharmacy__c) std.getRecord();
        Account accPharmacy = obj.Pharmacy__r;
        Account accCoveredEntity = obj.Covered_Entity__r;
        update accPharmacy;
        update accCoveredEntity;
        obj.Phone_P__c = accPharmacy.Phone;
        obj.Verification_Status_P__c = accPharmacy.Verification_Status__c;
        obj.Verification_Stage_P__c = accPharmacy.Verification_Stage__c;
        obj.Pharmacy_active_status_P__c = accPharmacy.Pharmacy_active_status__c;
        obj.Wholesaler_P__c = accPharmacy.Wholesaler__c;
        obj.Billing_Country_P__c = accPharmacy.BillingCountry;
        obj.Billing_State_P__c = accPharmacy.BillingState;
        obj.Billing_City_P__c = accPharmacy.BillingCity;
        obj.Shipping_Country_P__c = accPharmacy.ShippingCountry;
        obj.Shipping_State_P__c = accPharmacy.ShippingState;
        obj.Shipping_City_P__c = accPharmacy.ShippingCity;                       
        update obj;
    }*/
}