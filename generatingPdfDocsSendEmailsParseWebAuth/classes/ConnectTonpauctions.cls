global class ConnectTonpauctions {
    public static String cookies {get; set;}
    public static SitesAuth__c data;
    private static dealer__Deal__c sales;
    private static List<dealer__Deal__c> salesList = new List<dealer__Deal__c>();
    
    webservice static void sendPost() {
        UserAcc acc = new UserAcc(data.Login__c, data.Password__c);
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://www.npauctions.com/SignonMain.aspx?menuUserName=' + acc.user + '&menuPassword=' + acc.password);
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
                res = MockHttpResponseGeneratorNPA.respond(req);
            }
        } catch(Exception e) {
            throw new tempException('The site is not available or the connection has expired.');
        }
        
        cookies = res.getHeader('Set-Cookie');

        String body = res.getBody();
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
    
    
       
    
    webservice static dealer__Deal__c sendGet(dealer__Deal__c dealer) {
        sales = dealer;
        String aucID;
        String sdSQL;
        boolean myTest = false;
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://www.npauctions.com/Ajax.aspx/GetSimulcastPreviewItems');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json;charset=utf-8');
        req.setHeader('Accept', 'application/json, text/plain, */*');
        req.setHeader('Accept-Encoding', 'gzip, deflate');
        req.setHeader('Accept-Language', 'ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3');
        req.setHeader('Cookie', cookies);
        req.setBody('{"props":{"OBID":"","Unhide":"","AMS_ExclSimulcastLocations":"Columbus, Dummy, Remote","AMS_BypassSimulcastRecording":"0","MinDate":"","MaxDate":"","ExcludePreviewLender":"D6C85D40-1B55-475A-9A72-D6F4C27F916F;F19310CE-CA76-4B0C-878A-846EEA1C815F;51E48D47-27D6-413E-9CAC-5940EA52A053","AccountHold":"False","ContactID":"","HasLiveAuctionBidAccess":"False","IsContact":"False","IsAMSUserOrContact":"False","SimulcastBidderIDHasValue":"False","SimulcastPreviewRefreshTime":"60000","IsSimulcast":"False","CanBid":"False"}}');
        HTTPResponse res;
        if(!Test.isRunningTest()) {
        	res = http.send(req);
        } else {
            res = MockHttpResponseGeneratorNPA.respond(req);
        }
        
        String aucName, bidDate;
        String body = res.getBody();
        Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(body);
        Map<String, Object> m1 = (Map<String, Object>) m.values().get(0);
        List<Object> cityList = (List<Object>) m1.get('SimulcastPreviewItems');
        for(Object tmpObj : cityList) {
            Map<String, Object> tmpMap = (Map<String, Object>) tmpObj;
            aucName = (String) tmpMap.get('Auction');
            bidDate = aucName.substring(aucName.lastIndexOf(' ') + 1);
            sdSQL = bidDate + ' ' + (String) tmpMap.get('StartDate');
            aucID = (String) tmpMap.get('AuctionID');
            getInfo(sendFirstGet(aucID, sdSQL), bidDate);
        }

        for(dealer__Deal__c d : salesList) {
            if(d != null) {
            	sales = d;
                myTest = true;
            }
        }
        
        salesList.clear();
        if (!myTest) {
            getSecondInfo(sendSecondGet());
        	for(dealer__Deal__c d : salesList) {
            	if(d != null) {
            		sales = d; 
                    myTest = true;
           	 	}
        	}
            if (!myTest) {
            	throw new tempException('ID: ' + dealer.dealer__Deal_ID__c + ' does not exist in this Auction.');
            }
        }

        return sales;
    }
    
    

    private static void getInfo(String body, String bidDate) {
        Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(body);
        Map<String, Object> m1 = (Map<String, Object>) m.get('d');
        List<Object> itemList = (List<Object>) m1.get('SimulcastBrowseItems');
        for(Object tmpObj : itemList) {
            Map<String, Object> tmpMap = (Map<String, Object>) tmpObj;
            String aucItem = (String) tmpMap.get('AuctionItem');
            if(aucItem != null && aucItem == sales.dealer__Deal_ID__c) {
                sales.Name = sales.dealer__Deal_ID__c;
                sales.dealer__Deal_Type__c = 'Pre-Sale';
                sales.dealer__VIN__c = (String) tmpMap.get('VIN');
                sales.dealer__Year__c = (String) tmpMap.get('Year');
                sales.dealer__Make__c = (String) tmpMap.get('VehicleBrand');
                String model = (String) tmpMap.get('VehicleModel');
                if(model.length() >= 24) {
                    model = model.substring(0, model.lastIndexOf(' '));
                }
                sales.dealer__Model__c = model;
                try{
                     sales.dealer__Mileage__c = double.valueOf(tmpMap.get('MilesHours'));
                } catch (Exception e) {}
                sales.Title_State__c = (String) tmpMap.get('DocState');
                try {
                    String tmp = (String) tmpMap.get('Location');
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
                sales.Sales_Price__c = 0;
                sales.Standard_Buyer_Fee__c = 0;
                
                List<String> tl = bidDate.split('/');
        		String tmpDate = tl.get(2) + '-' + tl.get(0) + '-' + tl.get(1);
        		sales.Bid_Request_Date__c = date.valueOf(tmpDate);
                firstFillUrls((String) tmpMap.get('VehicleID'), (String) tmpMap.get('AuctionItemID'), (String) tmpMap.get('AuctionLaneID'), (String) tmpMap.get('AuctionID'));
                salesList.add(sales);
                return;
            }
        }
        salesList.add(null);
    }
    
    
    
    private static void getSecondInfo(String body) {
        Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(body);
        Map<String, Object> m1 = (Map<String, Object>) m.get('d');
        List<Object> itemList = (List<Object>) m1.get('BrowseItems');
        for(Object tmpObj : itemList) {
            Map<String, Object> tmpMap = (Map<String, Object>) tmpObj;
            String aucItem = (String) tmpMap.get('OnlineAuctionItem');
            if(aucItem != null && aucItem == sales.dealer__Deal_ID__c) {
                sales.Name = sales.dealer__Deal_ID__c;
                sales.dealer__Deal_Type__c = 'Pre-Sale';
                String aucItemID = (String) tmpMap.get('OnlineAuctionItemID');
                
                Http http = new Http();
        		HttpRequest req = new HttpRequest();
                req.setMethod('GET');
        		req.setHeader('Content-Type', 'application/json;charset=utf-8');
        		req.setHeader('Accept', 'application/json, text/plain, */*');
        		req.setHeader('Accept-Encoding', 'gzip, deflate');
        		req.setHeader('Accept-Language', 'ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3');
        		req.setHeader('Cookie', cookies);
        		req.setBody('');
        		
                HttpResponse res;
                req.setEndpoint('https://www.npauctions.com/eSaleItemDetail.aspx?OnlineAuctionItemID=' + aucItemID + '&OnlineVendorID=');
                res = MockHttpResponseGeneratorNPA.respond(req);

                String vin = res.getBody();
                vin = vin.substring(vin.indexOf('VIN:'));
                vin = vin.substring(vin.indexOf('">') + 2);
                vin = vin.substring(0, vin.indexOf('</td>'));
                sales.dealer__VIN__c = vin;
                secondFillUrls(res.getBody());
                    
                sales.dealer__Year__c = (String) tmpMap.get('Year');
                sales.dealer__Make__c = (String) tmpMap.get('VehicleBrand');
                String model = (String) tmpMap.get('VehicleModel');
                if(model.length() >= 24) {
                    model = model.substring(0, model.lastIndexOf(' '));
                }
                sales.dealer__Model__c = model;
                try{
                    sales.dealer__Mileage__c = double.valueOf(tmpMap.get('MilesHours'));
                } catch (Exception e) {
                    sales.dealer__Mileage__c = 0;
                }
                sales.Title_State__c = (String) tmpMap.get('DocState');
                try {
                    String tmp = (String) tmpMap.get('Location');
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
                sales.Sales_Price__c = 0;
                sales.Standard_Buyer_Fee__c = 0;
                
                String tmpTime = (String) tmpMap.get('ServerTime');
                tmpTime = tmpTime.substring(tmpTime.indexOf('(') + 1, tmpTime.indexOf(')'));
                Long longtime = Long.valueOf(tmpTime);
				DateTime dt = DateTime.newInstance(longtime);
                Integer bidDate = (Integer) tmpMap.get('SecondsRemaining');
                DateTime dt2 = dt.addSeconds(bidDate);
				Date da = Date.newInstance(dt2.year(), dt2.month(), dt2.day());              
                sales.Bid_Request_Date__c = da;
                salesList.add(sales);
                return;
            }
        }
        salesList.add(null);
    }
    
    
    
    private static String sendFirstGet(String aucID, String sdSQL) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json;charset=utf-8');
        req.setHeader('Accept', 'application/json, text/plain, */*');
        req.setHeader('Accept-Encoding', 'gzip, deflate');
        req.setHeader('Accept-Language', 'ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3');
        req.setHeader('Cookie', cookies);
        
        HTTPResponse res;
        
        req.setBody('{"props":{"ScoreMax":0,"PageIndex":1,"PageSize":20,"AuctionID":"' + aucID + '","AuctionLaneID":null,"IncludeCandidates":false,"CanBid":"True","StartDateAsSql":"' + sdSQL + '","IsFactory":false,"VehicleCategoryID":null,"VehicleBrandID":null,"AuctionItem":"' + sales.dealer__Deal_ID__c + '","YearMin":0,"YearMax":0,"VehicleModel":null,"DocState":"","MileageMin":null,"MileageMax":null,"ScoreMin":0,"OnlyProxyBids":false,"SortBy":""}}');
        req.setEndpoint('https://www.npauctions.com/Ajax.aspx/GetSimulcastBrowseItems');
        if(!Test.isRunningTest()) {
        	res = http.send(req);
        } else {
            res = MockHttpResponseGeneratorNPA.respond(req);
        }
        return res.getBody();
    }
    
    
    
    private static String sendSecondGet() {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json;charset=utf-8');
        req.setHeader('Accept', 'application/json, text/plain, */*');
        req.setHeader('Accept-Encoding', 'gzip, deflate');
        req.setHeader('Accept-Language', 'ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3');
        req.setHeader('Cookie', cookies);
        
        HTTPResponse res;
        
        req.setBody('{"props":{"ScoreMax":0,"PageIndex":1,"PageSize":20,"DealerID":"00000000-0000-0000-0000-000000000000","CanBid":"True","VehicleCategoryID":"","IncludeClosed":false,"LocationID":"","VehicleBrandID":"","OnlineAuctionItem":"' + sales.dealer__Deal_ID__c + '","YearMin":0,"YearMax":0,"VehicleModel":"","DocState":"","EndTime":null,"MileageMin":null,"MileageMax":null,"ScoreMin":0,"SortBy":""}}');
        req.setEndpoint('https://www.npauctions.com/ItemBrowseModern.aspx/GetBrowseItems');
        if(!Test.isRunningTest()) {
            res = http.send(req);
        } else {
            res = MockHttpResponseGeneratorNPA.respond(req);
        }
        
        return res.getBody();
    }
    
    
    
    
    private static void firstFillUrls(String vehicleID, String auctionItemID, String auctionLaneID, String auctionID) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://www.npauctions.com/SimulcastItemDetail.aspx?VehicleID=' + vehicleID + '&AuctionItemID=' + auctionItemID + '&AuctionLaneID=' + auctionLaneID + '&AuctionID=' + auctionID);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json;charset=utf-8');
        req.setHeader('Accept', 'application/json, text/plain, */*');
        req.setHeader('Accept-Encoding', 'gzip, deflate');
        req.setHeader('Accept-Language', 'ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3');
        req.setHeader('Cookie', cookies);
        HTTPResponse res;
        if(!Test.isRunningTest()) {
        	res = http.send(req);
        } else {
            res = MockHttpResponseGeneratorNPAimgs.respond(req);
        }
        
        String body = res.getBody();

		String tmpUrl = body.substring(body.indexOf('scastDetailImages'));
        tmpUrl = tmpUrl.substring(tmpUrl.indexOf('href=') + 6);
        String checkImg = tmpUrl.substring(0, tmpUrl.indexOf('&'));
        if(checkImg.containsIgnoreCase('ImageCache')) {
        	checkImg = getBadImg(checkImg);
        }
        sales.Pictures_Doc__c = checkImg;

        Integer i = 2;
        Map<String, Object> salesMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(sales));
        while(i <= 22) {
            String tmp = 'Pictures_Doc_' + i + '__c';
            if(tmpUrl.containsIgnoreCase('href=')) {
                tmpUrl = tmpUrl.substring(tmpUrl.indexOf('href=') + 6);
                checkImg = tmpUrl.substring(0, tmpUrl.indexOf('&'));
        		if(checkImg.containsIgnoreCase('ImageCache')) {
        			checkImg = getBadImg(checkImg);
        		}
                salesMap.remove(tmp);
                salesMap.put(tmp, checkImg);
            } else {
                salesMap.remove(tmp);
                salesMap.put(tmp, '');
            }
            i++;
        }

        sales = (dealer__Deal__c) JSON.deserializeStrict(JSON.serialize(salesMap), dealer__Deal__c.class);
    }
    
    
    
    private static void secondFillUrls(String body) {
        String tmpUrl = body.substring(body.indexOf('smallimage'));
        tmpUrl = tmpUrl.substring(tmpUrl.indexOf('http:'));
        String checkImg = tmpUrl.substring(0, tmpUrl.indexOf('&'));
        if(checkImg.containsIgnoreCase('ImageCache')) {
        	checkImg = getBadImg(checkImg);
        }
        sales.Pictures_Doc__c = checkImg;

        Integer i = 2;
        Map<String, Object> salesMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(sales));
        while(i <= 22) {
            String tmp = 'Pictures_Doc_' + i + '__c';
            if(tmpUrl.containsIgnoreCase('smallimage')) {
                tmpUrl = tmpUrl.substring(tmpUrl.indexOf('smallimage'));
                tmpUrl = tmpUrl.substring(tmpUrl.indexOf('http:'));
                checkImg = tmpUrl.substring(0, tmpUrl.indexOf('&'));
                if(checkImg.containsIgnoreCase('ImageCache')) {
                    checkImg = getBadImg(checkImg);
                }
                salesMap.remove(tmp);
                salesMap.put(tmp, checkImg);
            } else {
                salesMap.remove(tmp);
                salesMap.put(tmp, '');
            }
            i++;
        }

        sales = (dealer__Deal__c) JSON.deserializeStrict(JSON.serialize(salesMap), dealer__Deal__c.class);
    }
    
    
    
    
    
    private static String getBadImg(String check) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint(check + '&width=600&height=1200&quality=95');
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json;charset=utf-8');
        req.setHeader('Accept', 'image/png,image/*;q=0.8,*/*;q=0.5');
        req.setHeader('Accept-Encoding', 'gzip, deflate');
        req.setHeader('Accept-Language', 'ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3');
        req.setHeader('Cookie', cookies);
        HTTPResponse res;
        if(!Test.isRunningTest()) {
        	res = http.send(req);
        } else {
            res = MockHttpResponseGeneratorNPAimgs.respond(req);
        }
        return res.getHeader('Location');
    }
}