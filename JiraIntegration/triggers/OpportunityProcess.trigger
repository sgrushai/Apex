trigger OpportunityProcess on Opportunity (before insert, before update) {

    for(Opportunity opp: trigger.new){
        System.Debug('Amount>>>>>>>>>>'+opp.Amount);
        System.Debug('InvAmount>>>>>>>>>>'+opp.InvoiceAmount__c);
        if(opp.Amount!=null && opp.InvoiceAmount__c!=null){
            if(opp.Amount.setScale(2) == opp.InvoiceAmount__c.setScale(2)){opp.Balanced2__c = true;}
        }
        else opp.Balanced2__c = false;
    }
}