//VF
<apex:page standardController="Account" showHeader="true" 
      tabStyle="Account" extensions="redirect"  action="{!redirectme}">
</apex:page>
//Apex Extension Class
public class redirect{
 private final Account acct;

    public redirect(ApexPages.StandardController controller) {
 this.acct = (Account)controller.getRecord();

    }

public pagereference redirectme()
{
Account acc = [select Id, RecordTypeId from Account where Id=:ApexPages.currentPage().getParameters().get('Id')];
String hostname = ApexPages.currentPage().getHeaders().get('Host'); 
     /*If(acc.RecordTypeId == '012i00000016PIxAAM'){
     
           
           String url1= 'https://'+hostname+'/apex/accVFCustom'+'?id='+ApexPages.currentPage().getParameters().get('Id')+'&'+'sfdc.override=1';
           pagereference pageref1 = new pagereference(url1);
           pageref1.setredirect(true);
           return pageref1;
     } else */If(acc.RecordTypeId == '012i00000016PJ2AAM'){
     
           String url2= 'https://'+hostname+'/apex/accVFCustom2'+'?id='+ApexPages.currentPage().getParameters().get('Id')+'&'+'sfdc.override=1';
           pagereference pageref2 = new pagereference(url2);
           pageref2.setredirect(true);
           return pageref2;
     } else return null;
}
}