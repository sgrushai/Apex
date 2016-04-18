// the trigger updates any field of the oject, 
// we can ad conditiona here as well
trigger UpdateAnyFieldOnAnObject on Stock__c (before insert, before update) {

      for (Stock__c goodInLoop : Trigger.new){
          if (goodInLoop.Price__c==Null) {
         goodInLoop.Price__c=1000;
          }
          if (goodInLoop.Name=='trigger') {
         goodInLoop.Name='filled by triger';
          }
         goodInLoop.Price__c *= 0.9;
         goodInLoop.Description__c = 'discount applied'; 
         goodInLoop.Quantity__c = 10;
         goodInLoop.weight__c = 0.5;
                 
      }

   }