public class SomeImage {
    public String url {get;set;}
    
    public SomeImage() {
        String imgID = ApexPages.currentPage().getParameters().get('ImgID');
        dealer__Deal__c sales = [SELECT Pictures_Doc__c, Pictures_Doc_2__c, Pictures_Doc_3__c, Pictures_Doc_4__c, Pictures_Doc_5__c, Pictures_Doc_6__c, Pictures_Doc_7__c, Pictures_Doc_8__c, Pictures_Doc_9__c, Pictures_Doc_10__c, Pictures_Doc_11__c, 
                                 Pictures_Doc_12__c, Pictures_Doc_13__c, Pictures_Doc_14__c, Pictures_Doc_15__c, Pictures_Doc_16__c, Pictures_Doc_17__c, Pictures_Doc_18__c, Pictures_Doc_19__c, Pictures_Doc_20__c, Pictures_Doc_21__c, Pictures_Doc_22__c 
                                 FROM dealer__Deal__c WHERE id =: ApexPages.currentPage().getParameters().get('id')];
        if(imgID.equals('0')) {
            url = sales.Pictures_Doc__c;
        } else {
            Map<String, Object> dealMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(sales));
            url = (String) dealMap.get('Pictures_Doc_' + imgID + '__c');
        }
    }
}