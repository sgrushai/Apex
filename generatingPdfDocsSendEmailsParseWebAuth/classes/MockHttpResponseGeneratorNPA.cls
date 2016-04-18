@isTest(SeeAllData=true)
global class MockHttpResponseGeneratorNPA implements HttpCalloutMock {
    public static String headerLocation {get;set;}
    public static String body {get;set;}
    
    global static HTTPResponse respond(HTTPRequest req) {
        Map<String, Object> testMap1 = new Map<String, Object>();
        Map<String, Object> testMap2 = new Map<String, Object>();
        List<Object> cityList = new List<Object>();
        Map<String, Object> testMap3 = new Map<String, Object>();
        testMap3.put('Auction', 'Atlanta 04/06/2016');
        testMap3.put('StartDate', '8:45 AM');
        testMap3.put('AuctionID', 'asdasdasdasdasdasdasd');
        testMap3.put('OnlineAuctionItemID', 'asdasdasdasdasdasdasd');
        testMap3.put('AuctionItem', '9000');
        testMap3.put('OnlineAuctionItem', '215374');
        testMap3.put('VIN', '1HD1LC316FC440277');
        testMap3.put('Year', '2010');
        testMap3.put('VehicleBrand', 'Mazda');
        testMap3.put('VehicleModel', 'RX');
        testMap3.put('MilesHours', '135');
        testMap3.put('DocState', 'IL');
        testMap3.put('Location', 'Atlanta');
        testMap3.put('ServerTime', '/Date(121355684857)/');
        testMap3.put('SecondsRemaining', 120450);
        testMap3.put('temp', 'VIN: ">1HD1LC316FC440277</td>');
        testMap3.put('temp1', ', smallimage: http://www.npauctions.com/AMSProto/temp/I9c059dee-e7a7-4edc-8d99-7caad4d10ecf_600_1200.JPG&, smallimage: http://www.npauctions.com/ImageCache.aspx?PictureID=c40ea8b1-95ff-494f-a122-282d8035b6d6&amp;, smallimage: http://www.npauctions.com/ImageCache.aspx?PictureID=f16bb2f7-48de-4d8a-ab52-683caa248b2a&amp;width=600&amp;');
        
        cityList.add(testMap3);
        testMap2.put('SimulcastPreviewItems', cityList);
        testMap2.put('SimulcastBrowseItems', cityList);
        testMap2.put('BrowseItems', cityList);
        testMap1.put('d', testMap2);
        body = JSON.serialize(testMap1);
        
        HttpResponse res = new HttpResponse();
        res.setBody(body);
        res.setStatusCode(200);
        return res;
    }
}