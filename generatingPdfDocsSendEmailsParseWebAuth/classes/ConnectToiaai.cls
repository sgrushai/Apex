global class ConnectToiaai {
    public static String cookies {get; set;}
    public static SitesAuth__c data {get; set;}
    
    webservice static void sendPost() {
        UserAcc acc;
        if(!Test.isRunningTest()) {
            acc = new UserAcc(data.Login__c, data.Password__c, 'ReturnUrl%3D%2FDashboard%2FOverview', '%2FLogin%2FLoginPage%3FReturnUrl%3D%2FDashboard%2FOverview');
        } else {
            acc = new UserAcc('A', 'B', 'ReturnUrl%3D%2FDashboard%2FOverview', '%2FLogin%2FLoginPage%3FReturnUrl%3D%2FDashboard%2FOverview');
        }
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://www.iaai.com/Login/LoginPageSubmit?user=' + acc.user + '&password=' + acc.password + '&remMe=false&queryString=' + acc.queryString + '&source=' + acc.source);
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
                res = MockHttpResponseGeneratorIaai.respond(req);
            }
        } catch(Exception e) {
            throw new tempException('The site is not available or the connection has expired.');
        }
        
        cookies = res.getHeader('Set-Cookie');
        
        if(!cookies.contains('IAAIAUTH=')) {
             throw new tempException('Please enter a valid username and/or password');
        }
    }
    
    
    
    public class tempException extends Exception {}
    
    
    
    private class UserAcc {
        public String user {get; set;}
        public String password {get; set;}
        public String queryString {get; set;}
        public String source {get; set;}
        
        public UserAcc(String userin, String passwordin, String queryStringin, String sourcein) {
            this.user = userin;
            this.password = passwordin;
            this.queryString = queryStringin;
            this.source = sourcein;
        }
    }
    
    
    
    webservice static dealer__Deal__c sendGet(dealer__Deal__c sales) {
        if(cookies == null) cookies = '';
        Http http = new Http();
        HttpRequest req = new HttpRequest();

        String url = getUrl(sales);

        req.setEndpoint('https://www.iaai.com' + url);
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
    
    
    
    public static String getURL(dealer__Deal__c sales) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://www.iaai.com/Vehicles/Search.aspx?SearchStockNum=' + sales.dealer__Deal_ID__c);
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

        String url = res.getHeader('Location');
        return url;
    }
    
    
    
    /*public static String getHelper(String lotID) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://www.iaai.com/MyAuctionCenter/WonVehiclesHistorical.aspx?FAVStockNumber=' + lotID);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'text/plain; charset=utf-8');
        req.setHeader('Accept', '**');
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
            req.setEndpoint('https://www.iaai.com/Vehicles/Search.aspx?FAVStockNumber=' + lotID);
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
    }*/
    
    
    
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
        
        tmp = body.substring(body.indexOf('<span>Odometer')+14);
        tmp = tmp.substring(tmp.indexOf('<span>')+6);
        sales.dealer__Mileage__c = double.valueOf(tmp.substring(0, tmp.indexOf('</span>')));
        
        tmp = body.substring(body.indexOf('<span>Odometer Status')+21);
        tmp = tmp.substring(tmp.indexOf('<span>')+6);
        tmp = tmp.substring(0, tmp.indexOf('</span>')).toLowerCase();
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
                    current = Datetime.valueOf(y + '-' + m + '-' + tmp.substring(4) + ' 00:00:00');
                }
         		sales.Bid_Request_Date__c = date.valueOf(current.format('yyyy')+ '-' + k + '-' + tmp.substring(4));       
            }
        }
        
        sales.Sales_Price__c = 0;
        sales.Standard_Buyer_Fee__c = 0;
        
		sales = fillUrls(sales);
        
        return sales;
    }
    
    
    
    private static dealer__Deal__c fillUrls(dealer__Deal__c sales) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://www.iaai.com/Images/EnlargeImages?stockNumber=' + sales.dealer__Deal_ID__c);
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
        String key = body.substring(body.indexOf('"K":"') + 5);
        key = key.substring(0, key.indexOf('~SID'));
        String tmpImg = body.substring(body.indexOf('"IN":') + 5);
		String tmpUrl = 'https://vis.iaai.com/resizer?imageKeys=' + key + '~SID~I' + tmpImg.substring(0, tmpImg.indexOf(',"')) + '&width=640&height=480';
        sales.Pictures_Doc__c = tmpUrl;

        Integer i = 2;
        Map<String, Object> salesMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(sales));
        while(i <= 22) {
            String tmp = 'Pictures_Doc_' + i + '__c';
            if(tmpImg.containsIgnoreCase('"IN":')) {
                tmpImg = tmpImg.substring(tmpImg.indexOf('"IN":') + 5);
                tmpUrl = 'https://vis.iaai.com/resizer?imageKeys=' + key + '~SID~I' + tmpImg.substring(0, tmpImg.indexOf(',"')) + '&width=640&height=480';
                salesMap.remove(tmp);
                salesMap.put(tmp, tmpUrl);
            } else {
                salesMap.remove(tmp);
                salesMap.put(tmp, '');
            }
            i++;
        }

        sales = (dealer__Deal__c) JSON.deserializeStrict(JSON.serialize(salesMap), dealer__Deal__c.class);

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