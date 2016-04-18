trigger setStatus on dealer__Deal__c (before insert, before update) {
   	public integer ts = Trigger.size;
    if(ts==1) {
         
        for(dealer__Deal__c d : Trigger.new) {
            
            Integer step = 0;
            Boolean newRecord = true;
            dealer__Deal__c oldDeal = new dealer__Deal__c();
            
            if(d.Id!=null) {
	            oldDeal = Trigger.oldMap.get(d.Id);
                newRecord = false;
                if(d.Master_Affilliate__c!=null) {
	                d.OwnerId = d.Master_Affilliate__c;
                }
            }
           	
            if(d.Bid_Request_Date__c!=null) { d.dealer__Status__c = 'New Bid Request'; step=1; }
            if(d.Deposit_Date__c!=null ) { d.dealer__Status__c = 'Deposit Received'; step=2; }
            if(d.Purchase_Date__c!=null) { d.dealer__Status__c = 'Purchased'; step=3; }
            // Skipping 3.1, 3.2 (Refund Requested) seperate logic
            
            if(d.Bill_of_Sale_Date__c!=null) { d.dealer__Status__c = 'Bill of Sale Sent'; step=4; }
            if(d.Payment_Received_Date__c!=null) { d.dealer__Status__c = 'Payment Received'; step=5; }
            if(d.Paid_Auction__c!=null) {  d.dealer__Status__c = 'Paid at Auction'; step=6; }
            if(d.Picked_Up_Date__c!=null) { d.dealer__Status__c = 'Picked up from Auction'; step=7; }
            if(d.Delivery_Date__c!=null) { d.dealer__Status__c = 'Delivered to Client'; step=8; }
            if(d.Title_Received_Date__c!=null) { d.dealer__Status__c = 'Title Received'; step=9; }
            if(d.NMVTIS_Date__c!=null) { d.dealer__Status__c = 'NMVTIS Reported'; step=10; }
            if(d.Title_Sent_Date__c!=null) { d.dealer__Status__c = 'Title Sent to Client'; step=11; }
            
            // Check OldNew Values for Sale Date
            if(d.Sales_Complete_Date__c == null && step==11) {
                d.dealer__Deal_Date__c=Date.today();
                d.Sales_Complete_Date__c=Date.today();
                d.dealer__Status__c = 'Sale Completed';
            }
            
            // Perform Steps 3.1, 3.2 checks
            if(d.Refund_Request_Date__c!=null && d.Refund_Date__c!=null) {
             	d.dealer__Status__c='No Sale';
                d.No_Sale_Date__c=Date.today();
                    d.Bill_of_Sale_Date__c=null;
                    d.Payment_Received_Date__c=null;
                    d.Paid_Auction__c=null;
                    d.Picked_Up_Date__c=null;
                    d.Delivery_Date__c=null;
                    d.Title_Received_Date__c=null;
                    d.NMVTIS_Date__c=null;
                    d.Title_Sent_Date__c=null;
            }
            
            // Check for Deletions 
            if(newRecord==false) {
                if(oldDeal.Bid_Request_Date__c!=null && d.Bid_Request_Date__c==null) { d.dealer__Status__c = ''; step=0; }
                if(oldDeal.Deposit_Date__c!=null && d.Deposit_Date__c==null) { d.dealer__Status__c='New Bid Request'; step=1; } 
                if(oldDeal.Purchase_Date__c!=null && d.Purchase_Date__c==null) { d.dealer__Status__c='Deposit Received'; step=2; } 
                if(oldDeal.Bill_of_Sale_Date__c!=null && d.Bill_of_Sale_Date__c==null) { d.dealer__Status__c='Purchased'; step=3; }
                if(oldDeal.Payment_Received_Date__c!=null && d.Payment_Received_Date__c==null) { d.dealer__Status__c='Bill of Sale Sent'; step=4; }
                if(oldDeal.Paid_Auction__c!=null && d.Paid_Auction__c==null) { d.dealer__Status__c='Payment Received'; step=5; }
                if(oldDeal.Picked_Up_Date__c!=null && d.Picked_Up_Date__c==null) { d.dealer__Status__c='Paid at Auction'; step=6; }
                if(oldDeal.Delivery_Date__c!=null && d.Delivery_Date__c==null) { d.dealer__Status__c='Picked up from Auction'; step=6; }
                if(oldDeal.Title_Received_Date__c!=null && d.Title_Received_Date__c==null) { d.dealer__Status__c='Delivered to Client'; step=7; }
                if(oldDeal.NMVTIS_Date__c!=null && d.NMVTIS_Date__c==null) { d.dealer__Status__c='Title Received'; step=8; }
                if(oldDeal.Title_Sent_Date__c!=null && d.Title_Received_Date__c==null) { d.dealer__Status__c='NMVTIS Reported'; step=9; }
            }
            
            if(step<=9) {
            	d.dealer__Deal_Date__c=null;
                d.dealer__Deal_Date__c=null;
            }
        }
    }
}