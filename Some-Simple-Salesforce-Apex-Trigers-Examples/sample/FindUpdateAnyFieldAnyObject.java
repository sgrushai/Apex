// finds any object taking parameters
// updates any field with any value
trigger FindUpdateAnyFieldAnyObject on Invoice__c (before insert, before update, after insert, after update) {
List<Line_Item__c> line_item_list = [SELECT Id, Name, Stock__c, Units_Sold__c FROM Line_Item__c WHERE ID = 'a02i000000BfwsV' Limit 1];    
    For (Line_Item__c line_item : line_item_list) {
    line_item.Quantity__c = 777;
line_item.Units_Sold__c = 777;  
     }  
update line_item_list;
}