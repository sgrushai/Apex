global with sharing class CreateJIRAIssueController {
    
    
    public CreateJIRAIssueController(ApexPages.StandardController stdController){
         Opportunity theOpportunity = (Opportunity)stdController.getRecord();
       
    }    
   public static List<Opportunity> o = new List<Opportunity>([SELECT Id, Probability, StageName,
                                                              BusinessUnit__c, Link_to_OnePoint_Project__c, High_Level_Estimation_Document__c
                                                              FROM Opportunity WHERE Id = :ApexPages.currentPage().getParameters().get('Id')]);
    public static String oppId{ get { return ApexPages.currentPage().getParameters().get('Id');}}
    public static String BusinessUnit{get{ String unit;  if(o[0].BusinessUnit__c=='OPCO US'){ unit='SEE';  }if(o[0].BusinessUnit__c=='OPCO UK'){ unit='SEEEU';  }if(o[0].BusinessUnit__c=='OPCO DACH'){unit='SEEDACH';}return unit;}}
   
     public static String baseUrl{get; set;}
     public static String systemId{get; set;}
     public static String objectType{get; set;}
     public static String objectId=ApexPages.currentPage().getParameters().get('id');
     public static String projectKey{get; set;}
     public static String issueType{get; set;}
    
     public static String status{get; set;}
     public static String body{get; set;} 
     public static Integer statusCode{get; set;} 
    
     public static boolean btn{get{ boolean btnOnePoint=false; if(o[0].Link_to_OnePoint_Project__c!=Null ){ btnOnePoint=true; } return btnOnePoint; }set;}
    
     public static boolean btn2{get{ boolean btnHighLevel=false; if(o[0].High_Level_Estimation_Document__c!=Null ){ btnHighLevel=true; } return btnHighLevel;}set;}
    
     
    @future (callout=true) 
    WebService static void evaluateRequest() {
        try {
            HttpRequest req = buildRequest();
            HttpResponse res = JIRA.sendRequest(req);  resultevaluateRequest(res);
            } catch(System.CalloutException e) {
                sendEmail.send('System.CalloutException' ,e.getMessage());
            System.debug(e);
        }
    }
   @future (callout=true) 
    WebService static void requestOnePoint() {
        try {
            HttpRequest req = buildRequest();
            HttpResponse res = JIRA.sendRequest(req);  resultRequestOnePoint(res);
            } catch(System.CalloutException e) {
                 sendEmail.send('System.CalloutException' ,e.getMessage());
            System.debug(e);
        }
    }
    @future (callout=true) 
    WebService static void requestHighLevel() {
        try {
            HttpRequest req = buildRequest();
            HttpResponse res = JIRA.sendRequest(req); resultRequestHighLevel(res);
            } catch(System.CalloutException e) {
                sendEmail.send('System.CalloutException' ,e.getMessage());
            System.debug(e);
        }
    }
    public static void resultRequestHighLevel(HttpResponse res){ 
            status=res.getStatus();
            body=res.getBody();
            statusCode=res.getStatusCode();
            if(status=='OK'){ String[] issuekey = body.split('"'); o[0].High_Level_Estimation_Document__c=JIRA.browseIssue+issuekey[3];  update o;
            }
            if(status!='OK' && statusCode!=401){
                sendEmail.send(status, body);
            }           
    }
    public static void resultRequestOnePoint(HttpResponse res){ 
            status=res.getStatus();
            body=res.getBody();
            statusCode=res.getStatusCode();
 
             if(status=='OK'){ String[] issuekey = body.split('"'); o[0].Link_to_OnePoint_Project__c=JIRA.browseIssue+issuekey[3]; update o;
            }
            if(status!='OK' && statusCode!=401){
                sendEmail.send(status, body);
            }    
    }
    public static void resultevaluateRequest(HttpResponse res){
        status=res.getStatus();
            body=res.getBody();
            statusCode=res.getStatusCode();
                if(status!='OK' && statusCode!=401){
                    sendEmail.send(status, body);
                }
    }
    @testVisible private static HttpRequest buildRequest() {
        HttpRequest req = new HttpRequest();
        String endpoint = getEndpoint();
        List<sessionId__c> sessionId=new List<sessionId__c>([SELECT id, SessionId__c FROM SessionId__c WHERE name=:userinfo.getuserid()]);
        req.setHeader('Content-Type','application/json');
        req.setHeader('Accept', '*/*');
        req.setHeader('Accept-Encoding', 'gzip, deflate');
        req.setHeader('Accept-Language', ' uk-UA,uk;q=0.8,ru;q=0.6,en-US;q=0.4,en;q=0.2');
        if(sessionId.size()>0){
            req.setHeader('Cookie',sessionId[0].SessionId__c);
                }
        req.setMethod('POST');
        req.setEndpoint(endpoint);
        req.setBody('{"project":"' + projectKey + '", "issueType":"' + issueType + '"}');
        req.setTimeout(120000); 
        return req;
    }

    private static String getEndpoint() {
        return baseUrl + '/rest/customware/connector/1.0/' + systemId + '/' + objectType + '/' + objectId + '/issue/create.json';
    }

}