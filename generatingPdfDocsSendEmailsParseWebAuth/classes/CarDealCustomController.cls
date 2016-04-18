public class CarDealCustomController {
    public dealer__Deal__c deal {get;set;}
    
    public CarDealCustomController(ApexPages.StandardController stdController) {
        this.deal = (dealer__Deal__c)stdController.getRecord();
    }
    
    @RemoteAction 
    public static dealer__Deal__c fill(String dealID, String addr, String user, String pass) {
        dealer__Deal__c sales = new dealer__Deal__c();
        sales.ErrorMessages__c = '';
        sales.dealer__Deal_ID__c = dealID;
        sales.Site_address__c = addr;
        SitesAuth__c dataAuth = new SitesAuth__c();
        dataAuth.Login__c = user;
        dataAuth.Password__c = pass;
        try {
            if(sales.Site_address__c == 'www.copart.com') {
                ConnectToCopart.data = dataAuth;
                //ConnectToCopart.sendPost();
                sales = ConnectToCopart.sendGet(sales);
            }
            if(sales.Site_address__c == 'www.iaai.com') {
                ConnectToiaai.data = dataAuth;
                //ConnectToiaai.sendPost();
                sales = ConnectToiaai.sendGet(sales);
            }
            if(sales.Site_address__c == 'www.npauctions.com') {
                ConnectTonpauctions.data = dataAuth;
                ConnectTonpauctions.sendPost();
                sales = ConnectTonpauctions.sendGet(sales);
            }
            if(sales.Site_address__c == 'www.manheim.com') {
                ConnectToManheim.data = dataAuth;
                ConnectToManheim.sendPost();
                sales = ConnectToManheim.sendGet(sales);
            }
            if(sales.Site_address__c == 'www.adesa.com') {
                ConnectToAdesa.data = dataAuth;
                ConnectToAdesa.sendPost();
                sales = ConnectToAdesa.sendGet(sales);
            }
            if(sales.Site_address__c == 'www.metrosalvagepool.com') {
                ConnectToMetrosalvagepool.data = dataAuth;
                //ConnectToMetrosalvagepool.sendPost();
                sales = ConnectToMetrosalvagepool.sendGet(sales);
            }
            if(sales.Site_address__c == 'www.traauctions.com') {
                ConnectToTraauctions.data = dataAuth;
                ConnectToTraauctions.sendPost();
                sales = ConnectToTraauctions.sendGet(sales);
            }

            return sales;
        } catch (Exception e) {
            //sales.ErrorMessages__c = e.getMessage();
            return sales;
        }
    }
    
    @RemoteAction 
    public static SitesAuth__c auth(String addr) {
        for(SitesAuth__c tmpAuth : SitesAuth__c.getAll().values()) {
            if(tmpAuth.Address__c.containsIgnoreCase(addr)) return tmpAuth;
        }
    	return null;
    }
}