// Creates new invoice obj when user deletes the current one
trigger createNewInvoiceAfterDelete on Invoice__c (after delete) {
     Invoice__c inv = new Invoice__c(Description__c='My new invoice', Status__c='trigger');
// Insert the invoice using DML.
    insert inv;
   
}