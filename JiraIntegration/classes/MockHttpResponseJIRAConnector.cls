@isTest global class MockHttpResponseJIRAConnector implements HttpCalloutMock {
 
    // Mocks respond method for testing.
    global HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
 
        res.setStatus('OK');
        res.setStatusCode(200);
        res.setBody('GREAT');
        String cookie=res.getHeader('Set-Cookie');
      
        return res;
    }
     
}