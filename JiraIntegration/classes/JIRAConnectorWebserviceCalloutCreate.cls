global class JIRAConnectorWebserviceCalloutCreate {


   @future (callout=true) 
    WebService static void createIssue(String baseUrl, String systemId, String objectType,
                                                              String objectId, String projectKey, String issueType) {
        try {
            HttpRequest req = buildRequest(JIRA.baseUrl, JIRA.usernameHac, JIRA.passwordHac, systemId, objectType, objectId, projectKey, issueType);
            HttpResponse res = JIRA.sendRequest(req);
            String status;
            String body;
            status=res.getStatus();
            body=res.getBody(); 
            Opportunity o=new Opportunity();
            o.Id=objectId;
           
            if(status!='OK'){ sendEmail.send(status, body);
            }
            if(status=='OK') {
                String[] issuekey = body.split('"');
                if (issuekey.size()>3){  o.SEE_Task__c=JIRA.browseIssue+issuekey[3];
                }
                   update o; 
            }
            } catch(System.CalloutException e) { sendEmail.send('JIRA Issue was not created', e+'');
            System.debug(e);
        }
    }
  
    @testVisible private static HttpRequest buildRequest(String baseUrl, String usernameHac, String passwordHac,
                                           String systemId, String objectType, String objectId,
                                           String projectKey, String issueType) {
        HttpRequest req = new HttpRequest();
        String basicAuthHeader = JIRA.authHeader(usernameHac, passwordHac);
        String endpoint = getEndpoint(baseUrl, systemId, objectType, objectId);
        req.setHeader('Authorization', basicAuthHeader);
        req.setHeader('Content-Type','application/json');
        req.setMethod('POST');
        req.setEndpoint(endpoint);
        req.setBody('{"project":"' + projectKey + '", "issueType":"' + issueType + '"}');
        req.setTimeout(120000);                            
        return req;
    }

    private static String getEndpoint(String baseUrl, String systemId, String objectType, String objectId) {
        return baseUrl + '/rest/customware/connector/1.0/' + systemId + '/' + objectType + '/' + objectId + '/issue/create.json';
    }
 
}