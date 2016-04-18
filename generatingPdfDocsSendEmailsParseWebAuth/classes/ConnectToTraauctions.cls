global class ConnectToTraauctions {
    public static String cookies {get; set;}
    public static SitesAuth__c data {get; set;}
    
    webservice static void sendPost() {
        UserAcc acc;
        if(!Test.isRunningTest()) {
	        acc = new UserAcc(data.Login__c, data.Password__c);
        } else {
            acc = new UserAcc('A', 'B');
        }
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://www.traauctions.com/TraPortal21/');
        req.setMethod('GET');
        req.setHeader('Accept', 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8');
        req.setHeader('Accept-Encoding', 'gzip, deflate, sdch');
        req.setHeader('Accept-Language', 'uk-UA,uk;q=0.8,ru;q=0.6,en-US;q=0.4,en;q=0.2');
        HTTPResponse res;
        try {
            if(!Test.isRunningTest()) {
        		res = http.send(req);
            } else {
                res = MockHttpResponseGeneratorTraauc.respond(req);
            }
        } catch(Exception e) {
            throw new tempException('The site is not available or the connection has expired.');
        }
        String body = res.getBody();
        body = body.substring(body.indexOf('__RequestVerificationToken'));
        String tmpData = '__RequestVerificationToken=';
        body = body.substring(body.indexOf('value="') + 7);
        tmpData = tmpData + body.substring(0, body.indexOf('" />')) + '&returnUrl=/TraPortal21/&userName=' + acc.user + '&password=' + acc.password + '&rememberMe=false';
        req.setHeader('Content-Length', tmpData.length() + '');
        req.setBody(tmpData);

        req.setEndpoint('https://www.traauctions.com/TraPortal21/Account/Login?' + tmpData);
        req.setMethod('POST');
    	req.setHeader('Content-Type', 'text/plain; charset=utf-8');
        req.setHeader('Accept', 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8');
        req.setHeader('Accept-Encoding', 'gzip, deflate, br');
        req.setHeader('Accept-Language', 'ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3');
        try {
            if(!Test.isRunningTest()) {
        		res = http.send(req);
            } else {
                res = MockHttpResponseGeneratorTraauc.respond(req);
            }
        } catch(Exception e) {
            throw new tempException('The site is not available or the connection has expired.');
        }
        cookies = res.getHeader('Set-Cookie');
        
        if(!cookies.contains('ASPXAUTH')) {
            throw new tempException('User Name or Password is not valid.');
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
        if(cookies == null) cookies = '';
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://www.traauctions.com/trarestservices/vehicle/GetSearchResults2?fullText=' + sales.dealer__Deal_ID__c + '&orderBy=lane_run_sort&orderDirection=ASC&pageSize=50&pageNum=1');
        req.setMethod('GET');
        req.setHeader('Content-Type', 'text/plain; charset=utf-8');
        req.setHeader('Accept', 'application/json, text/javascript, */*; q=0.01');
        req.setHeader('Accept-Encoding', 'gzip, deflate, br');
        req.setHeader('Accept-Language', 'ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3');
        req.setHeader('Cookie', cookies);
        HTTPResponse res;
        if(!Test.isRunningTest()) {
        	res = http.send(req);
        } else {
            res = MockHttpResponseGeneratorTraauc.respond(req);
        }
        
        String body = res.getBody();

        return parser(body, sales);
    }
    
    
    
    private static dealer__Deal__c parser(String body, dealer__Deal__c sales) {
        sales.Name = sales.dealer__Deal_ID__c;
        
        sales.dealer__Deal_Type__c = 'Pre-Sale';
        
        Map<String, Object> tempMap = (Map<String, Object>) JSON.deserializeUntyped(body);
        List<Object> tmpList = (List<Object>) tempMap.get('Results');
        if(tmpList == null || tmpList.isEmpty()) {
            throw new tempException('Lot no longer exists.');
        }
        Map<String, Object> tempMap2 = (Map<String, Object>) tmpList.get(0);
        
        sales.dealer__VIN__c = (String) tempMap2.get('FullVIN');
        sales.dealer__Year__c = (String) tempMap2.get('Year');
        sales.dealer__Make__c = (String) tempMap2.get('Make');
        sales.dealer__Model__c = (String) tempMap2.get('Model');
		sales.dealer__Mileage__c = (Integer) tempMap2.get('Mileage');
        
        String tmp = (String) tempMap2.get('MileageTypeDescription');
        if(tmp.containsIgnoreCase('Actual')) {
            sales.Mileage_Type__c = 'Actual';
        } else {
            if(tmp.containsIgnoreCase('Exempt')) {
                sales.Mileage_Type__c = 'Exempt';
            } else {
                sales.Mileage_Type__c = 'Can not Read';
            }
        }
        
        sales.Title_State__c = '';
        //certificate???
        
        try {
        	String tmpForFind = (String) tempMap2.get('YardName');
       		List<String> yardList = tmpForFind.split(' ');
        	for(String tmpYard: yardList) {
            	if(!tmpYard.equalsIgnoreCase('Manheim') && !tmpYard.equalsIgnoreCase('-') && !tmpYard.equalsIgnoreCase('TRA')) {
                	tmpForFind = '%' + tmpYard + '%';
                    break;
            	}
        	}
            List<Account> acList = [SELECT Name FROM Account WHERE name like :tmpForFind];
            if(acList.size() == 1 && acList.get(0).Name.contains(tmp)) {
       			sales.Tracking_Number__c = acList.get(0).Name;
            } else {
                sales.Tracking_Number__c = '';
            }
        } catch(Exception e) {
            sales.Tracking_Number__c = '';
        }
        
        sales.Bid_Request_Date__c = date.parse((String) tempMap2.get('saledate'));
        
        sales.Sales_Price__c = 0;
        sales.Standard_Buyer_Fee__c = 0;
        
        sales = fillUrls((Integer) tempMap2.get('NationalYardID') + '', sales);
        return sales;
    }
    
    private static dealer__Deal__c fillUrls(String yardID, dealer__Deal__c sales) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://www.traauctions.com/trarestservices/vehicle/GetVehicle?nationalYardId=' + yardID + '&stockId=' + sales.dealer__Deal_ID__c);
        req.setMethod('GET');
        req.setHeader('Accept', 'application/json, text/javascript, */*; q=0.01');
        req.setHeader('Accept-Encoding', 'gzip, deflate, br');
        req.setHeader('Accept-Language', 'ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3');
        req.setHeader('Cookie', cookies);
        HTTPResponse res;
        if(!Test.isRunningTest()) {
        	res = http.send(req);
        } else {
            res = MockHttpResponseGeneratorTraauc.respond(req);
        }
        
        String body = res.getBody();

        Map<String, Object> tempMap = (Map<String, Object>) JSON.deserializeUntyped(body);
        List<Object> tmpList = (List<Object>) tempMap.get('Results');
        Map<String, Object> tempMap2 = (Map<String, Object>) tmpList.get(0);
        List<Object> tmpList2 = (List<Object>) tempMap2.get('Photos');

        Map<String, Object> tempMap3 = (Map<String, Object>) tmpList2.get(0);
        
        sales.Pictures_Doc__c = (String) tempMap3.get('FullSize');
        
        Integer i = 2;
        Map<String, Object> salesMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(sales));
        while(i <= 22) {
            String tmpImg = 'Pictures_Doc_' + i + '__c';
            if(tmpList2.size() > i - 1) {
                tempMap3 = (Map<String, Object>) tmpList2.get(i - 1);
                salesMap.remove(tmpImg);
                salesMap.put(tmpImg, (String) tempMap3.get('FullSize'));
            } else {
                salesMap.remove(tmpImg);
                salesMap.put(tmpImg, '');
            }
            i++;
        }

        sales = (dealer__Deal__c) JSON.deserializeStrict(JSON.serialize(salesMap), dealer__Deal__c.class);
        
        return sales;
    }
}