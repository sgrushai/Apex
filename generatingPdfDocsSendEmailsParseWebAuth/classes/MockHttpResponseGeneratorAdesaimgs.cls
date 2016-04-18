@isTest(SeeAllData=true)
global class MockHttpResponseGeneratorAdesaimgs implements HttpCalloutMock {
    public static String headerLocation {get;set;}
    public static String body {get;set;}
    
    global static HTTPResponse respond(HTTPRequest req) {
        Map<String, Object> testMap1 = new Map<String, Object>();
        Map<String, Object> testMap2 = new Map<String, Object>();
        Map<String, Object> testMap3 = new Map<String, Object>();
        
        Map<String, Object> testMap4 = new Map<String, Object>();
        Map<String, Object> testMap5 = new Map<String, Object>();
        Map<String, Object> testMap6 = new Map<String, Object>();
        List<Object> pic = new List<Object>();

        testMap3.put('auctionEndTime', 'Wed Apr 06 13:00:00 PDT 2016');
        testMap2.put('purchaseInfo', testMap3);
        testMap1.put('auctionChannelsInfo', testMap2);
        testMap1.put('location', 'Alaska, AL');
        
        testMap4.put('pathToImage', 'https://www.adesa.com/');
        testMap4.put('filePath', 'aaa.jpg');
        testMap5.putAll(testMap4);
        testMap6.putAll(testMap4);
        pic.add(testMap4);
        pic.add(testMap5);
        pic.add(testMap6);
        testMap1.put('pictures', pic);

        body = JSON.serialize(testMap1);
        body = '"SUCCESS",' + body.substring(0, body.length() - 1) + ',"_jstate';
        
        
        HttpResponse res = new HttpResponse();
        res.setBody(body);
        res.setHeader('Set-Cookie', '');
        res.setHeader('Location', 'https://www.adesa.com/auction-engine-web-api');
        res.setStatusCode(200);
        return res;
    }
}