1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
// trigger updates stock quantity

trigger UpdateStockQuantity on Line_Item__c (before update, before insert) {
    for (Line_item__c new_li : Trigger.new) {
        
        If (trigger.isUpdate) {
    Line_Item__c old_li = Trigger.oldMap.get(new_li.id);
        
        if (old_li.Quantity__c != new_li.Quantity__c) {
            
  List<Stock__c> stock_list = [SELECT Id, Name, Quantity__c FROM Stock__c where id = 'a00i000000F5GfP']; 
            
            if (new_li.Quantity__c > old_li.Quantity__c ) { // this part when we increase number of purchased items
                decimal dif = new_li.Quantity__c - old_li.Quantity__c;
 For (Stock__c stock : stock_list) {
     stock.Quantity__c -= dif;
 }
            }
             if (new_li.Quantity__c < old_li.Quantity__c ) {  // this part is when we decrease numer of purchased items
                decimal dif = old_li.Quantity__c - new_li.Quantity__c;
 For (Stock__c stock : stock_list) {
     stock.Quantity__c += dif;
 }
            }
   update stock_list;   
        }
   }

    If (trigger.isInsert) {
     List<Stock__c> stock_list = [SELECT Id, Name, Quantity__c FROM Stock__c where id = 'a00i000000F5GfP'];
        For (Stock__c stock : stock_list) {
     stock.Quantity__c -= new_li.Quantity__c;
 }
        update stock_list;  
    }
    }
   
}