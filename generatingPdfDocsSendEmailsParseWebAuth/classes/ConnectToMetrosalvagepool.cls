global class ConnectToMetrosalvagepool {
    public static String cookies {get; set;}
    public static SitesAuth__c data {get; set;}
    
    /*webservice static void sendPost() {
        UserAcc acc;
        if(!Test.isRunningTest()) {
	        acc = new UserAcc(data.Login__c, data.Password__c);
        } else {
            acc = new UserAcc('A', 'B');
        }
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://www.copart.com/us/Account/LogOn?MemberTypeIndex=0&UnmaskedUserName=&UserName=' + acc.user + '&Password=' + acc.password + '&RememberMe=false');
        req.setMethod('POST');
    	req.setHeader('Content-Type', 'text/plain; charset=utf-8');
        req.setHeader('Accept', '**');
        req.setHeader('Accept-Encoding', 'gzip, deflate, sdch');
        req.setHeader('Accept-Language', 'uk-UA,uk;q=0.8,ru;q=0.6,en-US;q=0.4,en;q=0.2');
        req.setBody('');
        HTTPResponse res;
        try {
            if(!Test.isRunningTest()) {
        		res = http.send(req);
            } else {
                res = MockHttpResponseGeneratorCopart.respond(req);
            }
        } catch(Exception e) {
            throw new tempException('The site is not available or the connection has expired.');
        }
        cookies = res.getHeader('Set-Cookie');
        
        String body = res.getBody();
        if(body.contains('errorMessages')) {
            String tmp = body.substring(body.indexOf('":["')+4, body.indexOf('"]}]'));
            throw new tempException(tmp);
        }
    }*/
    
    
    
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
        req.setEndpoint('https://metrosalvagepool.com/');
        req.setMethod('GET');
        req.setHeader('Content-Type', 'text/plain; charset=utf-8');
        req.setHeader('Accept', 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8');
        req.setHeader('Accept-Encoding', 'gzip, deflate, br');
        req.setHeader('Accept-Language', 'ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3');
        req.setHeader('Cookie', cookies);
        HTTPResponse res;
        if(!Test.isRunningTest()) {
        	res = http.send(req);
        } else {
            res = MockHttpResponseGeneratorMetroSP.respond(req);
        }
        
        String body = res.getBody();
        body = body.substring(body.indexOf('Next Sale Date:'));
        body = body.substring(body.indexOf('href=') + 6);
        String bidDate = body.substring(body.indexOf('font'));
        bidDate = bidDate.substring(bidDate.indexOf('>') + 1, bidDate.indexOf('</'));
        sales.Bid_Request_Date__c = Date.parse(bidDate);
        
        req.setEndpoint('https://metrosalvagepool.com/SaleListDetail.asp?StockID=' + sales.dealer__Deal_ID__c);
        if(!Test.isRunningTest()) {
            res = http.send(req);
        } else {
            res = MockHttpResponseGeneratorMetroSP.respond(req);
        }
        
        body = res.getBody();
        if(body.containsIgnoreCase('No detail was found')) {
            throw new tempException('Lot no longer exists.');
        }
        
        return parser(body, sales);
    }
    
    
    
    private static dealer__Deal__c parser(String body, dealer__Deal__c sales) {
        sales.Name = sales.dealer__Deal_ID__c;
        
        sales.dealer__Deal_Type__c = 'Pre-Sale';
        
        String tmp = body.substring(body.indexOf('Vin#:'));
        tmp = tmp.substring(tmp.indexOf('<font'));
        tmp = tmp.substring(tmp.indexOf('>') + 1);
        sales.dealer__VIN__c = tmp.substring(0, tmp.indexOf('</'));
        
        tmp = body.substring(body.indexOf('Year:'));
        tmp = tmp.substring(tmp.indexOf('<font'));
        tmp = tmp.substring(tmp.indexOf('>') + 1);
        sales.dealer__Year__c = tmp.substring(0, tmp.indexOf('</'));
        
        tmp = body.substring(body.indexOf('Make:'));
        tmp = tmp.substring(tmp.indexOf('<font'));
        tmp = tmp.substring(tmp.indexOf('>') + 1);
        sales.dealer__Make__c = tmp.substring(0, tmp.indexOf('</'));

        tmp = body.substring(body.indexOf('Model:'));
        tmp = tmp.substring(tmp.indexOf('<font'));
        tmp = tmp.substring(tmp.indexOf('>') + 1);
        sales.dealer__Model__c = tmp.substring(0, tmp.indexOf('</'));
        
        if(body.containsIgnoreCase('Mileage:')) {
        	tmp = body.substring(body.indexOf('Mileage:'));
        	tmp = tmp.substring(tmp.indexOf('<font'));
        	tmp = tmp.substring(tmp.indexOf('>') + 1);
        	sales.dealer__Mileage__c = double.valueOf(tmp.substring(0, tmp.indexOf('</')));
        } else {
            sales.dealer__Mileage__c = 0;
        }
        
        if(body.containsIgnoreCase('Mileage Type:')) {
            tmp = body.substring(body.indexOf('Mileage Type:'));
            tmp = tmp.substring(tmp.indexOf('<font'));
            tmp = tmp.substring(tmp.indexOf('>') + 1);
            tmp = tmp.substring(0, tmp.indexOf('</'));
            if(tmp.containsIgnoreCase('Mileage')) {
                sales.Mileage_Type__c = tmp.substring(0, tmp.indexOf(' Mileage'));
            } else {
                if(tmp.equalsIgnoreCase('Exempt')) {
                    sales.Mileage_Type__c = tmp;
                } else {
                    sales.Mileage_Type__c = 'Can not Read';
                }
            }
        } else {
            sales.Mileage_Type__c = 'Can not Read';
        }
        
        sales.Title_State__c = 'IA';
        //certificate???
        
        try {
        	String tmpForFind = '%Des Moines%';
            List<Account> acList = [SELECT Name FROM Account WHERE name like :tmpForFind];
            if(acList.size() == 1 && acList.get(0).Name.contains(tmp)) {
       			sales.Tracking_Number__c = acList.get(0).Name;
            } else {
                sales.Tracking_Number__c = '';
            }
        } catch(Exception e) {
            sales.Tracking_Number__c = '';
        }
        
        sales.Sales_Price__c = 0;
        sales.Standard_Buyer_Fee__c = 0;
        
        if(body.containsIgnoreCase('src="photos')) {
			sales = fillUrls(body, sales);
        }
        
        return sales;
    }
    
    private static dealer__Deal__c fillUrls(String body, dealer__Deal__c sales) {
        String tmp = body.substring(body.indexOf('Vin#:'));
        tmp = tmp.substring(tmp.indexOf('<img src="') + 10);
        sales.Pictures_Doc__c = 'https://metrosalvagepool.com/' + tmp.substring(0, tmp.indexOf('" '));
        
        Integer i = 2;
        Map<String, Object> salesMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(sales));
        while(i <= 22) {
            String tmpImg = 'Pictures_Doc_' + i + '__c';
            if(tmp.containsIgnoreCase('<img src="') && body.containsIgnoreCase('src="photos')) {
                tmp = tmp.substring(tmp.indexOf('<img src="') + 10);
                if(tmp.substring(0, tmp.indexOf('" ')).containsIgnoreCase('photos')) {
                	salesMap.remove(tmpImg);
                	salesMap.put(tmpImg, 'https://metrosalvagepool.com/' + tmp.substring(0, tmp.indexOf('" ')));
                } else {
                    salesMap.remove(tmpImg);
                	salesMap.put(tmpImg, '');
                }
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