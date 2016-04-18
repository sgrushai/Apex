global with sharing class JIRALogIn {
    
  public JIRALogIn(ApexPages.StandardController stdController){
         Opportunity theOpportunity = (Opportunity)stdController.getRecord(); 
    }    
   
   
    public  static String JiraSession{get; set;}
    global static String username {get; set;}
    global  static String password {get; set;}
   
     public static String status{get; set;}
     public static String body{get; set;} 
     public static Integer statusCode{get; set;} 
   
    public  static void logInJIRA(){
        getSession();
         List<sessionId__c> sessionId=new List<sessionId__c>([SELECT id, Name, SessionId__c FROM SessionId__c WHERE name=:userinfo.getuserid()]);
        if(sessionId.size()==0){
           sessionId__c sId=new sessionId__c(Name=userinfo.getuserid(),sessionId__c=JiraSession); 
            insert sId; }else{ sessionId[0].SessionId__c=JiraSession; update sessionId; 
        }
    }
     public static void resulLogIn(HttpResponse httpResponse){ 
            status=httpResponse.getStatus();
            body=httpResponse.getBody();
            statusCode=httpResponse.getStatusCode(); 
    }   
    webService static void getSession(){ 
       
        HttpRequest req = new HttpRequest();
        System.debug(username);
        System.debug(password);
       
        String endpoint = JIRA.baseUrl+'/rest/auth/1/session.json';
        req.setHeader('Content-Type','application/json');
        req.setHeader('Accept', '*/*');
        req.setHeader('Accept-Encoding', 'gzip, deflate');
        req.setHeader('Accept-Language', ' uk-UA,uk;q=0.8,ru;q=0.6,en-US;q=0.4,en;q=0.2');
        req.setMethod('POST');
        req.setEndpoint(endpoint);
        req.setBody('{"username":"' + username + '",  "password":"' + password + '"}');
        
        try{
        HttpResponse httpResponse =JIRA.sendRequest(req);
        resulLogIn(httpResponse);
        System.debug(httpResponse.getBody());
        String cookie=httpResponse.getHeader('Set-Cookie');
        If(cookie!=Null){String[] sId = cookie.split(';'); if (sId.size()>1){  JiraSession=sId[0];}
        }
        for (String key : httpResponse.getHeaderKeys()) { if (key != null) {
                System.debug('API RESPONSE HEADER[' + key +']=' + httpResponse.getHeader(key));
            }
        }
        
        System.debug('API RESPONSE STATUS CODE=' + httpResponse.getStatusCode());
        System.debug('API RESPONSE BODY=' + httpResponse.getBody());
        } catch(System.CalloutException e) {
                
            System.debug(e);
        }
    }  
}