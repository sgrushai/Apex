global class ConnectToManheim {
	public static String cookies {get; set;}
    public static SitesAuth__c data;
    
    webservice static void sendPost() {
        UserAcc acc = new UserAcc(data.Login__c, data.Password__c);
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://www.manheim.com/login/authenticate_ajax');
        req.setMethod('POST');
    	req.setHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
        req.setHeader('Accept', 'application/json, text/javascript, */*; q=0.01');
        req.setHeader('Accept-Encoding', 'gzip, deflate, br');
        req.setHeader('Accept-Language', 'ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3'); 
        req.setBody('username=' + acc.user + '&password=' + acc.password + '&back=&remember=0');
        HTTPResponse res;
        try {
            if(!Test.isRunningTest()) {
        		res = http.send(req);
            } else {
                res = MockHttpResponseGeneratorManheim.respond(req);
            }
        } catch(Exception e) {
            throw new tempException('The site is not available or the connection has expired.');
        }
        cookies = res.getHeader('Set-Cookie');
        
        String body = res.getBody();
        Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(body);
        Boolean logTrue = (Boolean) m.get('loginSuccess');
        if(!logTrue) {
            throw new tempException('Please enter a valid username and/or password');
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
        req.setEndpoint('https://www.manheim.com/members/powersearch/redirect.do?saveRecentSearch=true&searchTerms=' + sales.dealer__Deal_ID__c);
        req.setMethod('GET');
        req.setHeader('Accept', 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8');
        req.setHeader('Accept-Encoding', 'gzip, deflate, br');
        req.setHeader('Accept-Language', 'ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3');
        req.setHeader('Cookie', cookies);
        HTTPResponse res;
        if(!Test.isRunningTest()) {
        	res = http.send(req);
        } else {
            res = MockHttpResponseGeneratorManheim.respond(req);
        }
        String body = res.getBody();
        if(body.containsIgnoreCase('No results found')) {
            throw new tempException('Lot no longer exists.');
        }
        body = body.substring(body.indexOf('<div class="vehicleResultRow even" id="vehicleRow'));
        body = body.substring(body.indexOf('href="vehicleDetails.do?vehicleUniqueId=') + 6);
        body = body.substring(0, body.indexOf('" onclick'));
        
        req.setEndpoint('https://www.manheim.com/members/powersearch/' + body);
        
        if(!Test.isRunningTest()) {
            res = http.send(req);
        } else {
            res = MockHttpResponseGeneratorManheim.respond(req);
        }
        body = res.getBody();

        return parser(body, sales);
    }
    
    
    
    private static dealer__Deal__c parser(String body, dealer__Deal__c sales) {
        sales.Name = sales.dealer__Deal_ID__c;
        sales.dealer__Deal_Type__c = 'Pre-Sale';
        sales.dealer__VIN__c = sales.dealer__Deal_ID__c;
        
        String tmp = body.substring(body.indexOf('<label>Year:</label>'));
        tmp = tmp.substring(tmp.indexOf('<span>')+6, tmp.indexOf(('</span>')));
        sales.dealer__Year__c = tmp;
        
        tmp = body.substring(body.indexOf('<label>Make:</label>'));
        tmp = tmp.substring(tmp.indexOf('<span>')+6, tmp.indexOf(('</span>')));
        sales.dealer__Make__c = tmp;

        tmp = body.substring(body.indexOf('<label>Model:</label>'));
        tmp = tmp.substring(tmp.indexOf('<span>')+6, tmp.indexOf(('</span>')));
        sales.dealer__Model__c = tmp;
        
        tmp = body.substring(body.indexOf('<label>Odometer:</label>'));
        tmp = tmp.substring(tmp.indexOf('<span>')+6, tmp.indexOf(('</span>')));
        String tmp1 = tmp.substring(0, tmp.indexOf(' mi'));
        List<String> tl = new List<String>();
        if(tmp1.contains(',')) {
        	tl = tmp1.split(',');
        	tmp1 = tl.get(0) + '.' + tl.get(1);
        }
        sales.dealer__Mileage__c = double.valueOf(tmp1);

		tmp = body.substring(body.indexOf('<label>Title State:</label>'));
        tmp = tmp.substring(tmp.indexOf('<span>')+6, tmp.indexOf(('</span>')));
        sales.Title_State__c = tmp;
        
        tmp = body.substring(body.indexOf('<dt>Facilitation</dt>'));
        tmp = tmp.substring(tmp.indexOf('Manheim ')+8);
        tmp = tmp.substring(0, tmp.indexOf(' -'));
        try {
        	String tmpForFind = '%' + tmp + '%';
            List<Account> acList = [SELECT Name FROM Account WHERE name like :tmpForFind];
            if(acList.size() == 1 && acList.get(0).Name.contains(tmp)) {
       			sales.Tracking_Number__c = acList.get(0).Name;
            } else {
                sales.Tracking_Number__c = '';
            }
        } catch(Exception e) {
            sales.Tracking_Number__c = '';
        }

        if(body.contains('<dt>End Date</dt>')) {
        	tmp = body.substring(body.indexOf('<dt>End Date</dt>'));
        	tmp = tmp.substring(tmp.indexOf('<dd>')+4);
        	tmp = tmp.substring(0, tmp.indexOf(' '));
        	tl = tmp.split('/');
        	tmp = tl.get(2) + '-' + tl.get(0) + '-' + tl.get(1);
        	sales.Bid_Request_Date__c = date.valueOf(tmp);
        }
        
        if(body.contains('<dt>Sale Date</dt>')) {
        	tmp = body.substring(body.indexOf('<dt>Sale Date</dt>'));
        	tmp = tmp.substring(tmp.indexOf('<dd>')+4);
        	tmp = tmp.substring(0, tmp.indexOf(' -'));
        	tl = tmp.split('/');
        	tmp = tl.get(2) + '-' + tl.get(0) + '-' + tl.get(1);
        	sales.Bid_Request_Date__c = date.valueOf(tmp);
        }
        sales.Sales_Price__c = 0;
        sales.Standard_Buyer_Fee__c = 0;
        sales = fillUrls(body, sales);

        return sales;
    }
    
    
    
    
    private static dealer__Deal__c fillUrls(String body, dealer__Deal__c sales) {
        String tmpImg = body.substring(body.indexOf('id="thumbnails"'));
        tmpImg = tmpImg.substring(tmpImg.indexOf('<img src="') + 10);
        sales.Pictures_Doc__c = tmpImg.substring(0, tmpImg.indexOf('"onerror'));
        
        Integer i = 2;
        Map<String, Object> salesMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(sales));
        while(i <= 22) {
            String tmp = 'Pictures_Doc_' + i + '__c';
            if(tmpImg.containsIgnoreCase('id="image')) {
                tmpImg = tmpImg.substring(tmpImg.indexOf('<img src="') + 10);
                salesMap.remove(tmp);
                salesMap.put(tmp, tmpImg.substring(0, tmpImg.indexOf('"onerror')));
            } else {
                salesMap.remove(tmp);
                salesMap.put(tmp, '');
            }
            i++;
        }

        sales = (dealer__Deal__c) JSON.deserializeStrict(JSON.serialize(salesMap), dealer__Deal__c.class);
        
        return sales;
    }
}