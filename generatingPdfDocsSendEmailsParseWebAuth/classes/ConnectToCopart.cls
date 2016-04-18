global class ConnectToCopart {
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
        req.setEndpoint('http://www.copart.com/us/Account/LogOn?MemberTypeIndex=0&UnmaskedUserName=&UserName=' + acc.user + '&Password=' + acc.password + '&RememberMe=false');
        req.setMethod('POST');
    	req.setHeader('Content-Type', 'text/plain; charset=utf-8');
        req.setHeader('Accept', '*/*');
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
        req.setEndpoint('http://www.copart.com/us/Lot/' + sales.dealer__Deal_ID__c);
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
            res = MockHttpResponseGeneratorCopart.respond(req);
        }
        String temp = res.getHeader('Location');
        if(temp == '/?aspxerrorpath=/us/Lot/' + sales.dealer__Deal_ID__c) {
            throw new tempException('Lot no longer exists.');
        }
     	String body = res.getBody();   
        if(body.contains('Lot no longer exists.')) {
            throw new tempException('Lot no longer exists.');
        }
        return parser(body, sales);
    }
    
    
    
    private static dealer__Deal__c parser(String body, dealer__Deal__c sales) {
        sales.Name = sales.dealer__Deal_ID__c;
        
        sales.dealer__Deal_Type__c = 'Pre-Sale';
        
        String tmp = body.substring(body.indexOf('<span id="vinDiv">')+18);
        sales.dealer__VIN__c = tmp.substring(0,tmp.indexOf('<'));
        
        tmp = body.substring(body.indexOf('<div id="TitleHead" class="content-header">'));
        tmp = tmp.substring(tmp.indexOf('<h2>')+4, tmp.indexOf(('</h2>')));
        List<String> tmpList = tmp.split(' ');
        sales.dealer__Year__c = tmpList.get(0);
        sales.dealer__Make__c = tmpList.get(1);

        tmp = '';
        for(integer i = 2; i < tmpList.size(); i++) {
        	tmp = tmp + tmpList.get(i) + ' ';
        }
        sales.dealer__Model__c = tmp;
        
        tmp = body.substring(body.indexOf('<label for="Odometer:">Odometer:</label>')+40);
        String tmp1 = tmp.substring(1, tmp.indexOf(' mi.'));
        List<String> tl = new List<String>();
        if(tmp1.contains(',')) {
        	tl = tmp1.split(',');
        	tmp1 = tl.get(0) + '.' + tl.get(1);
        }
        sales.dealer__Mileage__c = double.valueOf(tmp1);
        tmp = tmp.substring(tmp.indexOf('(') + 1, tmp.indexOf(')')).toLowerCase();
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

        tmp = body.substring(body.indexOf('Doc Type:</label>'));
        tmp = tmp.substring(tmp.indexOf('data-tt-content=')+17);
        sales.Title_State__c = tmp.substring(0, 2);
        //certificate???
        
        tmp = body.substring(body.indexOf('<label for="Location:">Location:</label>')+40);
        tmp = tmp.substring(tmp.indexOf('- ')+2);
        tmp = tmp.substring(0, tmp.indexOf('</a>'));
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
        
        tmp = body.substring(body.indexOf('<label for="Sale_Date:">Sale Date:</label>'));
        if(tmp.contains('<span class="converted-time"')) {
        	tmp = tmp.substring(tmp.indexOf('<span class="converted-time"')+30);
        	tl = tmp.substring(tmp.indexOf('"') + 1, tmp.indexOf(' ')).split('/');
        	tmp = tl.get(2) + '-' + tl.get(0) + '-' + tl.get(1);
        	sales.Bid_Request_Date__c = date.valueOf(tmp);
        }
        
        sales.Sales_Price__c = 0;
        sales.Standard_Buyer_Fee__c = 0;
        
		String tmpImages = body.substring(body.indexOf('id="bx-pager"'));
        tmpImages = tmpImages.substring(0, tmpImages.indexOf('</ul>'));
		sales = fillUrls(tmpImages, sales);
        
        return sales;
    }
    
    private static dealer__Deal__c fillUrls(String strImgs, dealer__Deal__c sales) {
        String tmpImg = strImgs.substring(strImgs.indexOf('src=') + 4);
        sales.Pictures_Doc__c = tmpImg.substring(0, tmpImg.indexOf(' width=') - 4) + 'X.JPG';
        
        Integer i = 2;
        Map<String, Object> salesMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(sales));
        while(i <= 22) {
            String tmp = 'Pictures_Doc_' + i + '__c';
            if(tmpImg.containsIgnoreCase('src=')) {
                tmpImg = tmpImg.substring(tmpImg.indexOf('src=') + 4);
                salesMap.remove(tmp);
                salesMap.put(tmp, tmpImg.substring(0, tmpImg.indexOf(' width=') - 4) + 'X.JPG');
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