global class convertStatus {
    webservice static void convert(String lead) { 
        Lead tmpLead = [SELECT id, Status, OwnerId, IsConverted, ConvertedOpportunityId, 
                        ConvertedAccountId FROM Lead WHERE id =: lead][0];
        tmpLead.status = 'Qualified';
        update tmpLead;
    }
}