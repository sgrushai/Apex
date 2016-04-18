@isTest(SeeAllData=true)
global class CarDealCustomControllerTests {
    public static testMethod void testCustomController() {
        dealer__Deal__c testDeal = new dealer__Deal__c();
        ApexPages.StandardController sc = new ApexPages.StandardController(testDeal);
        CarDealCustomController controller = new CarDealCustomController(sc);
        dealer__Deal__c getDeal = controller.deal;
		System.assertEquals(testDeal, getDeal);
    }
    
    global static testMethod void testFillForCopart() {
        dealer__Deal__c testDeal = CarDealCustomController.fill('35987535', 'www.copart.com', 'A/B');
    }
    
    global static testMethod void testFillForIaai() {
        dealer__Deal__c testDeal = CarDealCustomController.fill('16462325', 'www.iaai.com', 'A/B');
    }
    
    global static testMethod void testFillForNPA() {
        dealer__Deal__c testDeal = CarDealCustomController.fill('215374', 'www.npauctions.com', 'A/B');
    }
    
    global static testMethod void testFillForManheim() {
        dealer__Deal__c testDeal = CarDealCustomController.fill('1HD1LC316FC440277', 'www.manheim.com', 'A/B');
    }
    
    global static testMethod void testFillForAdesa() {
        dealer__Deal__c testDeal = CarDealCustomController.fill('1306621474', 'www.adesa.com', 'A/B');
    }
    
    global static testMethod void testFillForMetrosalvagepool() {
        dealer__Deal__c testDeal = CarDealCustomController.fill('75590', 'www.metrosalvagepool.com', 'A/B');
    }
    
    global static testMethod void testFillForTraauctions() {
        dealer__Deal__c testDeal = CarDealCustomController.fill('9165359', 'www.traauctions.com', 'A/B');
    }
    
    global static testMethod void testGetCopart() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorCopart());
        dealer__Deal__c sales = new dealer__Deal__c();
        sales.dealer__Deal_ID__c = '35987535';
        ConnectToCopart.cookies = '';
        ConnectToCopart.sendPost();
        dealer__Deal__c readySales = ConnectToCopart.sendGet(sales);
    }
    
    global static testMethod void testGetIaai() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorIaai());
        dealer__Deal__c sales = new dealer__Deal__c();
        sales.dealer__Deal_ID__c = '16462325';
        ConnectToiaai.cookies = '';
        ConnectToiaai.sendPost();
        dealer__Deal__c readySales = ConnectToiaai.sendGet(sales);
        //String itemID = ConnectToiaai.getHelper(sales.dealer__Deal_ID__c);
    }
    
    global static testMethod void testGetNPA() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorNPA());
        dealer__Deal__c sales = new dealer__Deal__c();
        sales.dealer__Deal_ID__c = '9000';
        ConnectTonpauctions.cookies = '';
        dealer__Deal__c readySales = ConnectTonpauctions.sendGet(sales);
    }
    
    global static testMethod void testGetNPASecond() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorNPA());
        dealer__Deal__c sales = new dealer__Deal__c();
        sales.dealer__Deal_ID__c = '215374';
        ConnectTonpauctions.cookies = '';
        dealer__Deal__c readySales = ConnectTonpauctions.sendGet(sales);
    }
    
    global static testMethod void testGetManheim() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorManheim());
        dealer__Deal__c sales = new dealer__Deal__c();
        sales.dealer__Deal_ID__c = '1HD1LC316FC440277';
        ConnectToManheim.cookies = '';
        dealer__Deal__c readySales = ConnectToManheim.sendGet(sales);
    }
    
    global static testMethod void testGetAdesa() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorAdesa());
        dealer__Deal__c sales = new dealer__Deal__c();
        sales.dealer__Deal_ID__c = '1306621474';
        ConnectToAdesa.cookies = '';
        dealer__Deal__c readySales = ConnectToAdesa.sendGet(sales);
    }
    
    global static testMethod void testGetMetrosalvagepool() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorMetroSP());
        dealer__Deal__c sales = new dealer__Deal__c();
        sales.dealer__Deal_ID__c = '75590';
        ConnectToMetrosalvagepool.cookies = '';
        dealer__Deal__c readySales = ConnectToMetrosalvagepool.sendGet(sales);
    }
    
    global static testMethod void testGetTraauctions() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorTraauc());
        dealer__Deal__c sales = new dealer__Deal__c();
        sales.dealer__Deal_ID__c = '9165359';
        ConnectToTraauctions.cookies = '';
        dealer__Deal__c readySales = ConnectToTraauctions.sendGet(sales);
    }
}