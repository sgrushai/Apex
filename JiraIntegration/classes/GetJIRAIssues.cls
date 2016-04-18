public class GetJIRAIssues {

   
public  String oppId;
   
     public GetJIRAIssues(ApexPages.StandardController stdController) {
          Opportunity theOpportunity = (Opportunity)stdController.getRecord();
         this.oppId = theOpportunity.id;
         
    }
    public static integer GetJIRAIssuesStatusCode{get; set;}
   private static String getResultJson(String objectType, String objectId) {
        try {
            HttpRequest req = buildRequest(JIRA.baseUrl, JIRA.usernameHac, JIRA.passwordHac, JIRA.systemId, objectType, objectId);
            HttpResponse res = JIRA.sendRequest(req);
            GetJIRAIssuesStatusCode=res.getStatusCode();
            return res.getBody();
        } catch(System.CalloutException e) {
            System.debug(e);
            return '';
        }
    }
     
    @testVisible private static HttpRequest buildRequest(String baseUrl, String usernameHac, String passwordHac,
                                     String systemId, String objectType, String objectId) {
        HttpRequest req = new HttpRequest();
        
        String endpoint = getEndpoint(baseUrl, systemId, objectType, objectId);
       
         List<sessionId__c> sessionId=new List<sessionId__c>([SELECT id, SessionId__c FROM SessionId__c WHERE name=:userinfo.getuserid()]);
       
        req.setHeader('Content-Type','application/json');
        req.setHeader('Accept', '*/*');
        req.setHeader('Accept-Encoding', 'gzip, deflate');
        req.setHeader('Accept-Language', ' uk-UA,uk;q=0.8,ru;q=0.6,en-US;q=0.4,en;q=0.2');
        if(sessionId.size()>0){ req.setHeader('Cookie',sessionId[0].SessionId__c);
                }
        req.setHeader('Content-Type','application/json');                                 
        req.setMethod('GET');
        req.setEndpoint(endpoint);                                
        return req;
    }

    private static String getEndpoint(String baseUrl, String systemId, String objectType, String objectId) {
        return baseUrl + '/rest/customware/connector/1.0/' + systemId + '/' + objectType + '/' + objectId + '/issue/fetch.json';
    }
    public  String getIssuesJSON() {
        return getResultJson('Opportunity', oppId);   
    }
    public  List<JIRAIssue> getIssues() {
        return (List<JIRAIssue>)JSON.deserialize(getIssuesJSON() , List<JIRAIssue>.class);
    }
     public  List<JIRAIssue> listIssues{get; set;}

     public  void is(){
        try{
        listIssues=new List<JIRAIssue>();
         listIssues.addAll(getIssues());
            }catch(System.JSONException e){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,  e+'' ));
            System.debug(e);
        }
    }

    @testVisible  class JIRAIssue {
 
        public String summary { get; set; }
        public String project { get; set; }
        public String reporter { get; set;}
        public String key { get; set;}
        public String status { get;set;}
        public String resolution { get; set;}
        public String url { get; set;}
        public String type { get; set;}
        public String assignee { get; set;}
        public String description { get; set;}
        public String priority { get; set;}
        public String due_date { get; set;}
        
       
 
    }
 
}