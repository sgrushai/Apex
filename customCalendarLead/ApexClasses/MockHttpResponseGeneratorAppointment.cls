@isTest(SeeAllData=true)
global class MockHttpResponseGeneratorAppointment implements HttpCalloutMock {
    public static String body {get;set;}
    
    global static HTTPResponse respond(HTTPRequest req) {
        body = '{"destination_addresses":["Kyiv,Ukraine,02000"],"origin_addresses":["Lviv,Ukraine"],"rows":[{"elements":[{"distance":{"text":"540 ??","value":540472},"duration":{"text":"0 h 19 m","value":60},"status":"OK"}]}],"status":"OK"}';
        
        HttpResponse res = new HttpResponse();
        res.setBody(body);
        res.setStatusCode(200);
        return res;
    }
}