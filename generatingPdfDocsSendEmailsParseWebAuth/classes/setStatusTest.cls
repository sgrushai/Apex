@isTest
private class setStatusTest {
    static testmethod void testCarDealStatus() {
        dealer__Deal__c deal = new dealer__Deal__c();
        deal.Name='10191';
        deal.dealer__Deal_ID__c='AA:10191';
      	
        insert deal;
        
        update deal;
        
        deal.Title_Sent_Date__c = Date.today();
        
        update deal;
        
        deal.Refund_Date__c = Date.today();
        deal.Refund_Request_Date__c = Date.today();
        
        update deal;
    }
}