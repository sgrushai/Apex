global class ConnectToAdesa {
	public static String cookies {get; set;}
    public static SitesAuth__c data;
    
    webservice static void sendPost() {
        UserAcc acc = new UserAcc(data.Login__c, data.Password__c);
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://login.adesa.com/ssoserver/auth');
        req.setMethod('POST');
    	req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setHeader('Accept', 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8');
        req.setHeader('Accept-Encoding', 'gzip, deflate, br');
        req.setHeader('Accept-Language', 'ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3');
        req.setBody('accountName=' + acc.user + '&password=' + acc.password);
        HTTPResponse res;
        try {
            if(!Test.isRunningTest()) {
        		res = http.send(req);
            } else {
                res = MockHttpResponseGeneratorAdesa.respond(req);
            }
        } catch(Exception e) {
            throw new tempException('The site is not available or the connection has expired.');
        }
        
        cookies = res.getHeader('Set-Cookie');
        String body = res.getBody();

        if(body.containsIgnoreCase('AUTH_USR_UNKNOWN')) {
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
        req.setEndpoint('https://search.openlane.com/auctionsearch/api/rest/1.0/vehicles?callback=OpenlaneSearchEngine.callback1&_jstate=JVZhDyE8jIYV1wGJTuMC9584X5FMxVbg58Fio5Rzo6M29ABQ_JpxiFLtRx1RzT2z&coid=378744&fldMsk=1:1940096935&fldMsk=2:2147265823&fldMsk=3:16383&fldMsk=4:587727&fldMsk=5:1009909888&fldMsk=6:1024&scMsk=23&ast=1&nh=T&txt=' + sales.dealer__Deal_ID__c + '&sz=50&st=0&mk.cnt=&trm.cnt=&sl.cnt=&sl2.cnt=0:32_&div.cnt=&cle.cnt=&sp.cnt=&md.cnt=&slc.cnt=&vt.cnt=&slo.cnt=&pat.cnt=&pao.cnt=&ast.cnt=&rlad.cnt=&lbln.cnt=&rlet.cnt=&slt.cnt=&auch.cnt=&lbEId.cnt=&grd.cnt=&sort=im+asc,auchPr+asc,et+asc,bp+desc');
        req.setMethod('GET');
        req.setHeader('Accept', '*/*');
        req.setHeader('Accept-Encoding', 'gzip, deflate, br');
        req.setHeader('Accept-Language', 'ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3');
        req.setHeader('Cookie', cookies);
        HTTPResponse res;
        if(!Test.isRunningTest()) {
        	res = http.send(req);
        } else {
            res = MockHttpResponseGeneratorAdesa.respond(req);
        }
        String body = res.getBody();

        return parser(body, sales);
    }
    
    
    
    private static dealer__Deal__c parser(String body, dealer__Deal__c sales) {
        body = body.substring(body.indexOf('(') + 1, body.indexOf(');'));
		Map<String, Object> tempMap = (Map<String, Object>) JSON.deserializeUntyped(body);
        List<Object> tmpList = (List<Object>) tempMap.get('docs');
        if(tmpList == null || tmpList.isEmpty()) {
            throw new tempException('Lot no longer exists.');
        }
        Map<String, Object> tempMap2 = (Map<String, Object>) tmpList.get(0);

        sales.Name = sales.dealer__Deal_ID__c;
        sales.dealer__Deal_Type__c = 'Pre-Sale';
        sales.dealer__VIN__c = (String) tempMap2.get('VIN');
        sales.dealer__Year__c = (String) tempMap2.get('YEAR');
        sales.dealer__Make__c = (String) tempMap2.get('MAKE_NAME');
        sales.dealer__Model__c = (String) tempMap2.get('MODEL_NAME') + ' ' + (String) tempMap2.get('SERIES_NAME');
        sales.dealer__Mileage__c = (Integer) tempMap2.get('ODOMETER');
        sales.Title_State__c = (String) tempMap2.get('STATE');
        
        sales = fillUrls((integer) tempMap2.get('VEHICLE_ID'), sales);
        
        sales.Sales_Price__c = 0;
        sales.Standard_Buyer_Fee__c = 0;
        return sales;
    }
    
    
    
    
    webservice static dealer__Deal__c fillUrls(integer vid, dealer__Deal__c sales) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://imola.adesa.com/auction-engine-web-api/salesvenue/vehicleDetail.json?vid=' + vid + '&markViewed=true&fetchServices=true&abpo=undefined&defOrgId=378744&localeStr=en&t=1459930634500&fromSI=false&isFromLAIBidContainer=false&callback=OPENLANE.initVehicleDetailsContext.contextCallback&_jstate=JVZhDyE8jIYV1wGJTuMC9584X5FMxVbg58Fio5Rzo6M29ABQ_JpxiFLtRx1RzT2z');
        req.setMethod('GET');
        req.setHeader('Accept', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8');
        req.setHeader('Accept-Encoding', 'gzip, deflate, sdch');
        req.setHeader('Accept-Language', 'uk-UA,uk;q=0.8,ru;q=0.6,en-US;q=0.4,en;q=0.2');
        
        req.setHeader('Cookie', cookies);
        HTTPResponse res;
        if(!Test.isRunningTest()) {
        	res = http.send(req);
        } else {
            res = MockHttpResponseGeneratorAdesaimgs.respond(req);
        }
        
        req.setEndpoint(res.getHeader('Location'));
        if(!Test.isRunningTest()) {
        	res = http.send(req);
        } else {
            res = MockHttpResponseGeneratorAdesaimgs.respond(req);
        }
        
        cookies = cookies.substring(0, cookies.indexOf(';') + 1) + res.getHeader('Set-Cookie');
        req.setEndpoint(res.getHeader('Location'));
        if(!Test.isRunningTest()) {
        	res = http.send(req);
        } else {
            res = MockHttpResponseGeneratorAdesaimgs.respond(req);
        }
        
        String body = res.getBody();

        body = body.substring(body.indexOf('"SUCCESS",') + 10, body.indexOf('_jstate') - 1);
        body = body.substring(0, body.lastIndexOf(',')) + '}';

		Map<String, Object> tempMap = (Map<String, Object>) JSON.deserializeUntyped(body);
        String tmp = (String) tempMap.get('location');
        tmp = tmp.substring(0, tmp.indexOf(','));
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
        
        Map<String, Object> tempMap2 = (Map<String, Object>) tempMap.get('auctionChannelsInfo');
        Map<String, Object> tempMap3 = (Map<String, Object>) tempMap2.get('purchaseInfo');
        
        String t = (String) tempMap3.get('auctionEndTime');
		List<String> tmpList = t.split(' ');
        
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

        for(Integer k: monthMap.keySet()) {
            if(monthMap.get(k) == tmpList.get(1)) {
         		t = k + '/' + tmpList.get(2) + '/' + tmpList.get(5);      
            }
        }
		
		sales.Bid_Request_Date__c = Date.parse(t);

		List<Object> picList = (List<Object>) tempMap.get('pictures');
        
        Map<String, Object> urlObj = (Map<String, Object>) picList.get(0);
        sales.Pictures_Doc__c = (String) urlObj.get('pathToImage') + (String) urlObj.get('filePath');
        
        Integer i = 2;
        Map<String, Object> salesMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(sales));
        while(i <= 22) {
            String tmp1 = 'Pictures_Doc_' + i + '__c';
            if(i - 1 < picList.size()) {
                urlObj = (Map<String, Object>) picList.get(i - 1);
        		String tmpImg = (String) urlObj.get('pathToImage') + (String) urlObj.get('filePath');
                
                salesMap.remove(tmp1);
                salesMap.put(tmp1, tmpImg);
            } else {
                salesMap.remove(tmp1);
                salesMap.put(tmp1, '');
            }
            i++;
        }

        sales = (dealer__Deal__c) JSON.deserializeStrict(JSON.serialize(salesMap), dealer__Deal__c.class);
        
        return sales;
    }
}