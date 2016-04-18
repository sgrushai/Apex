global class ConnectTonpaSalvage {
    public static String cookies {get; set;}
    public static SitesAuth__c data;
    
    webservice static void sendPost() {
        for(SitesAuth__c d: SitesAuth__c.getAll().Values()) {
            if(d.Name == 'npauctionsAuthSalvage') {
                data = d;
            }
        }
        UserAcc acc = new UserAcc(data.Login__c, data.Password__c);
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        //req.setEndpoint(data.Address__c + '/signon.aspx?ReturnUrl=/Home.aspx');
        req.setEndpoint('http://salvage.npauctions.com/Home.aspx');
        req.setMethod('GET');
        req.setHeader('Accept', 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8');
        req.setHeader('Accept-Encoding', 'gzip, deflate');
        req.setHeader('Accept-Language', 'ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3');
        req.setBody('');
        
        HTTPResponse res;
        try {
        	if(!Test.isRunningTest()) {
        		res = http.send(req);
            } else {
                //res = MockHttpResponseGeneratorCopart.respond(req);
            }
        } catch(Exception e) {
            throw new tempException('The site is not available or the connection has expired.');
        }
        cookies = res.getHeader('Set-Cookie');
        String body = res.getBody();

        String viewstate = body.substring(body.indexOf('id="__VIEWSTATE"'));
        viewstate = viewstate.substring(viewstate.indexOf('value="') + 7);
        viewstate = viewstate.substring(0, viewstate.indexOf('" />'));
        String generator = body.substring(body.indexOf('id="__VIEWSTATEGENERATOR"'));
        generator = generator.substring(generator.indexOf('value="') + 7);
        generator = generator.substring(0, generator.indexOf('" />'));
        String eventValid = body.substring(body.indexOf('id="__EVENTVALIDATION"'));
        eventValid = eventValid.substring(eventValid.indexOf('value="') + 7);
        eventValid = eventValid.substring(0, eventValid.indexOf('" />'));
        
        req.setEndpoint('http://salvage.npauctions.com/signon.aspx?ReturnUrl=/Home.aspx');
        req.setMethod('POST');
        req.setBody('__LASTFOCUS=&__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE=' + viewstate + '&__VIEWSTATEGENERATOR=' + generator + '&__EVENTVALIDATION=' + eventValid + '&ctl00$_scriptMgr=&ctl00$MainContent$lgnLogin$UserName=' + acc.user + '&ctl00$MainContent$lgnLogin$Password=' + acc.password + '&ctl00$MainContent$lgnLogin$LoginButton=Login');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setHeader('Content-Length', (req.getBody().length() - 1) + '');
        try {
        	if(!Test.isRunningTest()) {
        		res = http.send(req);
            } else {
                //res = MockHttpResponseGeneratorCopart.respond(req);
            }
        } catch(Exception e) {
            throw new tempException('The site is not available or the connection has expired.');
        }
        for(String t: res.getHeaderKeys()) {
            if(t != null) System.debug(t + ' - ' + res.getHeader(t));
        }
        //cookies = res.getHeader('Set-Cookie');
        //System.debug(cookies);
		System.debug(res.getBody());
        
        if(body.contains('ctl00_MainBody_divLoginError')) {
            String tmp = body.substring(body.indexOf('ctl00_MainBody_divLoginError'));
            tmp = tmp.substring(tmp.indexOf('">') + 2, tmp.indexOf('</'));
            throw new tempException(tmp);
        }
    }
        
    
    
    public class tempException extends Exception {}
    
    
    
    private class UserAcc {
        public String user {get; set;}
        public String password {get; set;}
        
        public UserAcc(String userin, String passwordin) {
            this.user = userin;
            this.password = passwordin;
        }
    }
    
    
    
    webservice static dealer__Deal__c sendGet(dealer__Deal__c sales) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        if(!Test.isRunningTest()) {
        	String itemID = getHelper(sales.dealer__Deal_ID__c);
        
        	req.setEndpoint(data.Address__c + '/Vehicles/VehicleDetails.aspx?itemID=' + itemID + '&RowNumber=0');
        } else {
            req.setEndpoint('https://www.iaai.com/Vehicles/VehicleDetails.aspx?itemID=19450111&RowNumber=0');
        }
        req.setMethod('GET');
        
        req.setHeader('Content-Type', 'text/plain; charset=utf-8');
        req.setHeader('Accept', '*/*');
        req.setHeader('Accept-Encoding', 'gzip, deflate, sdch');
        req.setHeader('Accept-Language', 'uk-UA,uk;q=0.8,ru;q=0.6,en-US;q=0.4,en;q=0.2');
        req.setHeader('Cookie', cookies);
        HTTPResponse res;
        if(!Test.isRunningTest()) {
        	res = http.send(req);
        } else {
            res = MockHttpResponseGeneratorIaai.respond(req);
        }

		String body = res.getBody();
        if(body.contains('<span class="errorinline_VD">')) {
            String tmp = body.substring(body.indexOf('<span class="errorinline_VD">')+29);
            tmp = tmp.substring(0, tmp.indexOf('</span>'));
            throw new tempException(tmp);
        }
        return parser(body, sales);
    }
    
    
    
    public static String getHelper(String lotID) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        if(!Test.isRunningTest()) {
        	req.setEndpoint(data.Address__c + '/MyAuctionCenter/WonVehiclesHistorical.aspx?FAVStockNumber=' + lotID);
        } else {
            req.setEndpoint('https://www.iaai.com/MyAuctionCenter/WonVehiclesHistorical.aspx?FAVStockNumber=' + lotID);
        }
        req.setMethod('GET');
        
        req.setHeader('Content-Type', 'text/plain; charset=utf-8');
        req.setHeader('Accept', '*/*');
        req.setHeader('Accept-Encoding', 'gzip, deflate, sdch');
        req.setHeader('Accept-Language', 'uk-UA,uk;q=0.8,ru;q=0.6,en-US;q=0.4,en;q=0.2');
        req.setHeader('Cookie', cookies);
        HTTPResponse res;
        if(!Test.isRunningTest()) {
        	res = http.send(req);
        } else {
            res = MockHttpResponseGeneratorIaai.respond(req);
        }
        
        String body = res.getBody();
        
        if(!body.contains('name="' + lotID + '" href="../Vehicles/VehicleDetails.aspx?itemID=')) {
            if(!Test.isRunningTest()) {
            	req.setEndpoint(data.Address__c + '/Vehicles/Search.aspx?FAVStockNumber=' + lotID);
            } else {
                req.setEndpoint('https://www.iaai.com/Vehicles/Search.aspx?FAVStockNumber=' + lotID);
            }
            HTTPResponse res1 = http.send(req);
            String temp = res1.getHeader('Location');
            if(temp == null) {
                throw new tempException('Lot no longer exists.');
            }
            temp = temp.substring(temp.indexOf('itemID=')+7);
        	return temp.substring(0, temp.indexOf('&'));  
        } else {
        	String tmp = body.substring(body.indexOf('name="' + lotID + '" href="../Vehicles/VehicleDetails.aspx?itemID='));
        	tmp = tmp.substring(tmp.indexOf('itemID=')+7);
        	return tmp.substring(0, tmp.indexOf('&amp'));
        }
    }
    
    
    
    private static dealer__Deal__c parser(String body, dealer__Deal__c sales) {
        sales.Name = sales.dealer__Deal_ID__c;
        
        sales.dealer__Deal_Type__c = 'Pre-Sale';
        
        String tmp = body.substring(body.indexOf('reports.carsarrive.com/iaa/widget?vin=')+38);
        sales.dealer__VIN__c = tmp.substring(0, tmp.indexOf('&'));
        
        tmp = body.substring(body.indexOf('<span id="ctl00_ContentPlaceHolder1_year"'));
        tmp = tmp.substring(tmp.indexOf('">')+2);
        sales.dealer__Year__c = tmp.substring(0, tmp.indexOf('</span>'));
        
        tmp = body.substring(body.indexOf('<span id="ctl00_ContentPlaceHolder1_make"'));
        tmp = tmp.substring(tmp.indexOf('">')+2);
        sales.dealer__Make__c = tmp.substring(0, tmp.indexOf('</span>'));
        
        tmp = body.substring(body.indexOf('<span id="ctl00_ContentPlaceHolder1_model"'));
        tmp = tmp.substring(tmp.indexOf('">')+2);
        sales.dealer__Model__c = tmp.substring(0, tmp.indexOf('</span>'));
        
        tmp = body.substring(body.indexOf('<span>Odometer:</span>')+22);
        sales.dealer__Mileage__c = double.valueOf(tmp.substring(tmp.indexOf('<span>')+6, tmp.indexOf('</span>')));
        
        tmp = body.substring(body.indexOf('<span>Odometer Status:</span>')+29);
        tmp = tmp.substring(tmp.indexOf('<span>')+6, tmp.indexOf('</span>')).toLowerCase();
        List<String> tl = new List<String>();
        tl = tmp.split(' ');
        if(tl.size() > 1) {
            tmp = '';
            for(String s: tl) {
                tmp = tmp + s.substring(0,1).toUpperCase() + s.substring(1) + ' ';
            }
            tmp = tmp.substring(0, tmp.length() - 1);
        } else {
            tmp = tmp.substring(0,1).toUpperCase() + tmp.substring(1);
        }
        sales.Mileage_Type__c = tmp;

        tmp = body.substring(body.indexOf('<span id="ctl00_ContentPlaceHolder1_SaleDoc"'));
        tmp = tmp.substring(tmp.indexOf('(')+1);
        sales.Title_State__c = stateAbbrev(tmp.substring(0, tmp.indexOf(')')));
        //certificate???
        
        tmp = body.substring(body.indexOf('id="ctl00_ContentPlaceHolder1_topLocationlink"'));
        tmp = tmp.substring(tmp.indexOf('">')+2);
        tmp = tmp.substring(0, tmp.indexOf('</a>'));
        try {
            List<Account> acList = [SELECT id FROM Account WHERE name =: tmp];
            if(acList.size() == 1) {
       			sales.Auction__c = acList.get(0).id;
            }
            //sales.Auction__c = [SELECT id FROM Account WHERE name =: tmp][0].id;
        } catch(Exception e) {
            //throw new tempException('Account type Auction with name ' + tmp + ' does not exist.');
        }
        
        tmp = body.substring(body.indexOf('<span id="ctl00_ContentPlaceHolder1_bidliveValue"'));
        tmp = tmp.substring(tmp.indexOf('">')+2);
        tmp = tmp.substring(tmp.indexOf(', ')+2);
        Map<Integer, String> monthMap = new Map<Integer, String>();
        monthMap.put(1, 'Jan');
		monthMap.put(2, 'Feb');
		monthMap.put(3, 'Mar');
		monthMap.put(4, 'Apr');
		monthMap.put(5, 'May');
		monthMap.put(6, 'Jun');
		monthMap.put(7, 'Jul');
		monthMap.put(8, 'Aug');
		monthMap.put(9, 'Sep');
		monthMap.put(10, 'Oct');
		monthMap.put(11, 'Nov');
		monthMap.put(12, 'Dec');
        tmp = tmp.substring(0, tmp.indexOf(','));
        Datetime current = Datetime.valueOf(system.now());
        for(Integer k: monthMap.keySet()) {
            if(monthMap.get(k) == tmp.substring(0, 3)) {
                if(current.month() > k) {
                    integer y = current.year() + 1;
                    integer m = current.month();
                    integer d = current.day();
                    current = Datetime.valueOf(y + '-' + m + '-' + d + ' 00:00:00');
                }
         		sales.Bid_Request_Date__c = date.valueOf(current.format('yyyy')+ '-' + k + '-' + tmp.substring(4));       
            }
        }
        
        sales.Sales_Price__c = 0;
        sales.Standard_Buyer_Fee__c = 0;
        return sales;
    }
    
    
    
    private static String stateAbbrev(String state) {
        Map<String, String> abbrMap = new Map<String, String>();
        abbrMap.put('AL', 'Alabama');
        abbrMap.put('AK', 'Alaska');
        abbrMap.put('AZ', 'Arizona');
        abbrMap.put('AR', 'Arkansas');
        abbrMap.put('CA', 'California');
        abbrMap.put('CO', 'Colorado');
        abbrMap.put('CT', 'Connecticut');
        abbrMap.put('DE', 'Delaware');
        abbrMap.put('FL', 'Florida');
        abbrMap.put('GA', 'Georgia');
        
        abbrMap.put('HI', 'Hawaii');
        abbrMap.put('ID', 'Idaho');
        abbrMap.put('IL', 'Illinois');
        abbrMap.put('IN', 'Indiana');
        abbrMap.put('IA', 'Iowa');
        abbrMap.put('KS', 'Kansas');
        abbrMap.put('KY', 'Kentucky');
        abbrMap.put('LA', 'Louisiana');
        abbrMap.put('ME', 'Maine');
        abbrMap.put('MD', 'Maryland');
        
        abbrMap.put('MA', 'Massachusetts');
        abbrMap.put('MI', 'Michigan');
        abbrMap.put('MN', 'Minnesota');
        abbrMap.put('MS', 'Mississippi');
        abbrMap.put('MO', 'Missouri');
        abbrMap.put('MT', 'Montana');
        abbrMap.put('NE', 'Nebraska');
        abbrMap.put('NV', 'Nevada');
        abbrMap.put('NH', 'New Hampshire');
        abbrMap.put('NJ', 'New Jersey');
        
        abbrMap.put('NM', 'New Mexico');
        abbrMap.put('NY', 'New York');
        abbrMap.put('NC', 'North Carolina');
        abbrMap.put('ND', 'North Dakota');
        abbrMap.put('OH', 'Ohio');
        abbrMap.put('OK', 'Oklahoma');
        abbrMap.put('OR', 'Oregon');
        abbrMap.put('PA', 'Pennsylvania');
        abbrMap.put('RI', 'Rhode Island');
        abbrMap.put('SC', 'South Carolina');
        
        abbrMap.put('SD', 'South Dakota');
        abbrMap.put('TN', 'Tennessee');
        abbrMap.put('TX', 'Texas');
        abbrMap.put('UT', 'Utah');
        abbrMap.put('VT', 'Vermont');
        abbrMap.put('VA', 'Virginia');
        abbrMap.put('WA', 'Washington');
        abbrMap.put('WV', 'West Virginia');
        abbrMap.put('WI', 'Wisconsin');
        abbrMap.put('WY', 'Wyoming');
        
        for(String s: abbrMap.keySet()) {
            if(abbrMap.get(s) == state) {
                return s;
            }
        }
        return null;
    }
}