@isTest(SeeAllData=true)
global class MockHttpResponseGeneratorAdesa implements HttpCalloutMock {
    public static String headerLocation {get;set;}
    public static String body {get;set;}
    
    global static HTTPResponse respond(HTTPRequest req) {
        Map<String, Object> testMap1 = new Map<String, Object>();
        Map<String, Object> testMap2 = new Map<String, Object>();
        List<Object> docs = new List<Object>();

        testMap2.put('VIN', '1HD1LC316FC440277');
        testMap2.put('YEAR', '2017');
        testMap2.put('MAKE_NAME', 'Mazda');
        testMap2.put('MODEL_NAME', 'RX');
        testMap2.put('SERIES_NAME', '2');
        testMap2.put('ODOMETER', 135);
        testMap2.put('STATE', 'IL');
        testMap2.put('VEHICLE_ID', 2222);
                
        docs.add(testMap2);
        testMap1.put('docs', docs);
        body = JSON.serialize(testMap1);
        body = '(' + body + ');';
        
        HttpResponse res = new HttpResponse();
        res.setBody(body);
        res.setStatusCode(200);
        return res;
    }
}