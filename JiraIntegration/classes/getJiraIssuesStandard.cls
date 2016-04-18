public class getJiraIssuesStandard {

   
public  String oppId;
   
     public getJiraIssuesStandard(ApexPages.StandardController stdController) {
          Opportunity theOpportunity = (Opportunity)stdController.getRecord();
         this.oppId = theOpportunity.id;
         
    }
    public static integer GetJIRAIssuesStatusCode{get; set;}
   private static String getResultJson(String objectType, String objectId) {
        try {
            HttpRequest req = buildRequest(JIRA.baseUrl, JIRA.systemId, objectType, objectId);
            HttpResponse res = JIRA.sendRequest(req);
            GetJIRAIssuesStatusCode=res.getStatusCode();
            return res.getBody();
        } catch(System.CalloutException e) {
            System.debug(e);
            return '';
        }
    }
     
    @testVisible private static HttpRequest buildRequest(String baseUrl, String systemId, String objectType, String objectId) {
        HttpRequest req = new HttpRequest();
        
        String endpoint = JIRA.baseUrl+'/rest/api/2/search.json';
       
         List<sessionId__c> sessionId=new List<sessionId__c>([SELECT id, SessionId__c FROM SessionId__c WHERE name=:userinfo.getuserid()]);
       
        req.setHeader('Content-Type','application/json');
        req.setHeader('Accept', '*/*');
        req.setHeader('Accept-Encoding', 'gzip, deflate');
        req.setHeader('Accept-Language', ' uk-UA,uk;q=0.8,ru;q=0.6,en-US;q=0.4,en;q=0.2');
        if(sessionId.size()>0){ req.setHeader('Cookie',sessionId[0].SessionId__c);
                }
        req.setHeader('Content-Type','application/json');                                 
        req.setMethod('POST');
       req.setBody('{"jql":"project=SEE","startAt":0,"maxResults":100,"fields":["summary","key","status","resolution","type","description","priority","subtasks"]}');
        req.setEndpoint(endpoint);                                
        return req;
    }
   
    
    public  String getIssuesJSON() {
       string www = getResultJson('Opportunity', oppId);
        System.debug(www);
        //JSONsubT4 st=JSONsubT4.parse(www);
        return www;   
    }
    
   JSONsubT4.Issues companycontacts = (JSONsubT4.Issues)JSON.deserialize(getIssuesJSON(), JSONsubT4.Issues.class);
    
    
   /* public  List<JIRAIssue> getIssues() {
       JSONsubT4 JsonObj=(JSONsubT4)JSON.deserialize(getIssuesJSON(), JSONsubT4.class);
        System.debug(JsonObj);
        System.debug(JsonObj.issues);
        
        return (List<JIRAIssue>)JSON.deserialize(getIssuesJSON() , List<JIRAIssue>.class);
    }*/
    
    public  List<JSONsubT4.issues> getIssues() {
        JSONsubT4 JsonObj=(JSONsubT4)JSON.deserialize(getIssuesJSON(), JSONsubT4.class);
        return  JsonObj.issues;
    }
    
    
    
    
    
    
     public  List<JSONsubT4.issues> listIssues{get; set;}
     public JSONsubT4 st=JSONsubT4.parse(getIssuesJSON());
     public  void is(){
        try{
        listIssues=new List<JSONsubT4.issues>();
         listIssues.addAll(getIssues());
            }catch(System.JSONException e){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,  e+'' ));
            System.debug(e);
        }
    }

    @testVisible  class JIRAIssue {
        public List<subtasks> subtasks{get; set;}//"summary","project","reporter","key","status","resolution","type","assignee","description","priority"
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
    @testVisible  class subtasks{
        public String key { get; set;}
    }
   
 
}