trigger CreateIssue on Opportunity (after insert) {
  if (JIRA.currentUserIsNotJiraAgent()) {
        for (Opportunity o : Trigger.new) {

            String objectType ='Opportunity'; 
            String objectId = o.id;
            String projectKey;
            
            if(o.BusinessUnit__c=='OPCO US'){
                projectKey='SEE';
            } else if(o.BusinessUnit__c=='OPCO UK' ){
                 projectKey='SEEEU';
            }else if(o.BusinessUnit__c=='OPCO DACH'){
                projectKey='SEEDACH';
            }
            String issueType = '13500';
            if(o.BusinessUnit__c=='OPCO US'||o.BusinessUnit__c=='OPCO UK' || o.BusinessUnit__c=='OPCO DACH'){
                
                
            JIRAConnectorWebserviceCalloutCreate.createIssue(JIRA.baseUrl, JIRA.systemId, objectType, objectId, projectKey, issueType);
            
                
            }
        }
    }
}