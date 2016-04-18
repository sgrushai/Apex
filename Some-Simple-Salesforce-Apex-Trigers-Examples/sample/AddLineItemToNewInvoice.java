// adds Line Item to the newly created Invoice
trigger AddLineItemToNewInvoice on Invoice__c (after insert) {

    for (Invoice__c invoiceInLoop : Trigger.new){
Line_Item__c li = new Line_Item__c(Quantity__c=999, Invoice__c=invoiceInLoop.Id, Stock__c='a00i000000F5GfP');
    insert li;
}
}