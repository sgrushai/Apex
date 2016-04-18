@isTest
private class Test_sendEmail_RVP{

static dealer__Deal__c deal;
static dealer__Deal__c dealt;

static {

deal= new dealer__Deal__c();
Account testAccount = new Account( Name = 'Test Account',dealer__Vendor__c=True );
insert testAccount;
testAccount = [select Id, Name,dealer__Vendor__c from Account where Id = :testAccount.Id];
System.assertEquals(testAccount.Name, 'Test Account'); 
deal= new dealer__Deal__c();

deal.Name='54575554';
deal.dealer__Deal_ID__c=testAccount.id;
deal.dealer__Deal_Type__c='Pre-Sale';
deal.dealer__Buyer__c=testAccount.id;
deal.Affiliate__c=testAccount.id;
deal.Rep__c=testAccount.id;
deal.Bidder__c=testAccount.id;
deal.Proxy_Dealer__c=testAccount.id;
deal.dealer__VIN__c='545454544';
deal.dealer__Year__c='1990';
deal.dealer__Make__c='honda';
deal.dealer__Model__c='dfdff';
deal.dealer__Mileage__c=20;
deal.Mileage_Type__c='Actual';
deal.Title_State__c='PA';
deal.Title_Type__c='Clean Title';
deal.Paid_Auction__c=date.parse('12/27/2009');
deal.Bid_Request_Date__c=date.parse('12/27/2009');
deal.Sales_Price__c=100;
deal.Standard_Buyer_Fee__c=100;
insert deal;
dealt= new dealer__Deal__c();
dealt = [SELECT Name, Mileage_Type__c 
         FROM dealer__Deal__c 
         WHERE Id = :deal.Id];
System.assertEquals('Actual', dealt.Mileage_Type__c);
}

static testmethod void testPdfEmailer() {
    PageReference pref = Page.RetailBillofSale;
    pref.getParameters().put('id',deal.id);
    Test.setCurrentPage(pref);
    System.assertEquals(ApexPages.currentPage().getParameters().get('id'),String.valueOf(deal.Id));
    sendEmail_RVP con = new sendEmail_RVP();
    Test.startTest();
    con.emailaddr='mail@mail.com';
    pref= con.send();
    Test.stopTest(); 
}


}