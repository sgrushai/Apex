global with sharing class JIRA {
    public JIRA(ApexPages.StandardController stdController){
         Opportunity theOpportunity = (Opportunity)stdController.getRecord();

        
    }    
 

    public static String baseUrl = 'https://jira-stage.ontrq.com';
   // public static String baseUrl = 'https://jira.ontrq.com';
    public static String systemId = '1';
    //public static String usernameHac = 'salesforce_user';
   // public static String passwordHac = ' salesforce_user4473#@!';
    public static String usernameHac = 's.grushai';
    public static String passwordHac = 'Veryeasy4473';
    global static String username{get; set;}
    global static String password {get; set;}
    //public static String browseIssue = 'https://jira.ontrq.com/browse/';
    public static String browseIssue = 'https://jira-stage.ontrq.com/browse/';

    public static String agentProfileName = 'JIRA Agent';
 
    public static String authHeader(String u, String p) {
        Blob headerValue = Blob.valueOf(u + ':' + p);
        return 'Basic ' + EncodingUtil.base64Encode(headerValue);
    }

    public static HttpResponse sendRequest(HttpRequest req) {
        Http http = new Http();
        HttpResponse res=http.send(req);
        System.debug('StatusCode______'+res.getStatusCode()+'');
        System.debug('Status________'+res.getStatus()+'');
        System.debug('Body_____'+res.getBody()+'');
        System.debug(res);
        return res;      
    }

    public static Boolean currentUserIsNotJiraAgent() {
        Boolean allow = false;
        List<Profile> jiraAgentProfile = [SELECT Id FROM Profile WHERE Name=:JIRA.agentProfileName];
        if (!jiraAgentProfile.isEmpty()) {
            String jiraProfileAgentId = String.valueOf(jiraAgentProfile[0].id);
            allow = UserInfo.getProfileId() != jiraProfileAgentId;
        }
        return allow || Test.isRunningTest();
    }
 
}