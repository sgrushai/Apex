@isTest(SeeAllData=true)
global class MockHttpResponseGeneratorTraauc implements HttpCalloutMock {
    public static String headerLocation {get;set;}
    public static String body {get;set;}
    
    global static HTTPResponse respond(HTTPRequest req) {
        Map<String, Object> testMap1 = new Map<String, Object>();
        List<Object> testList1 = new List<Object>();
        Map<String, Object> testMap2 = new Map<String, Object>();
        List<Object> testList2 = new List<Object>();
        Map<String, Object> testMap3 = new Map<String, Object>();
        testMap2.put('FullVIN', 'WAUED64B41N003462');
        testMap2.put('Year', '2001');
        testMap2.put('Make', 'AUDI');
        testMap2.put('Model', 'A6');
        testMap2.put('Mileage', 237325);
        testMap2.put('MileageTypeDescription', 'Exempt');
        testMap2.put('YardName', 'Manheim Littleton - TRA');
        testMap2.put('saledate', '04/13/2016');
        testMap2.put('NationalYardID', 2003);
        
        testMap3.put('FullSize', 'aaa.jpg');
        testList2.add(testMap3);
        
        testMap3.remove('FullSize');
        testMap3.put('FullSize', 'bbb.jpg');
        testList2.add(testMap3);
        
        testMap3.remove('FullSize');
        testMap3.put('FullSize', 'ccc.jpg');
        testList2.add(testMap3);
        
        testMap2.put('Photos', testList2);
        testMap2.put('temp', '__RequestVerificationToken value="abc" />');
        testList1.add(testMap2);
        testMap1.put('Results', testList1);
        body = JSON.serialize(testMap1);
        
        HttpResponse res = new HttpResponse();
        res.setBody(body);
        res.setStatusCode(200);
        return res;
    }
}