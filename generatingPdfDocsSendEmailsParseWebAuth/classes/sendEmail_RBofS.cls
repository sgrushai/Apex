public class sendEmail_RBofS {
    public String subject { get
     {
    if (subject != null) {
            return subject;
        }
    return 'Retail Bill of Sale' + ' ' +  Deal.dealer__Year__c + ' ' + Deal.dealer__Make__c + ' ' + Deal.dealer__Model__c + ' ' + Deal.dealer__VIN__c;
    } set; }
    
    public String body { get; set; }

    public String emailaddr { get
    {
    if (emailaddr != null) {
            return emailaddr;
        }
      
    return Deal.Buyer_Account_Doc2__r.dealer__PersonEmail__c;
    }  set; }
    public final dealer__Deal__c Deal{ get; set; }
    public final String Logo_Url{ get; set; }
    public String DealerImsComLogo{get;set;}
Boolean isSuccess = false;
attachment doc;
Document doc2;
public PageReference redirectUser(){

    PageReference ref = new PageReference('/apex/RetailBillofSale?id=' + ApexPages.currentPage().getParameters().get('id'));
    ref.setRedirect(false);
    return ref;
   
}

    // Create a constructor
    public sendEmail_RBofS() {
 
      Deal = [SELECT dealer__Deal__c.Proxy_Dealer__r.BillingCountry,dealer__Deal__c.Proxy_Dealer__r.BillingPostalCode,dealer__Deal__c.Proxy_Dealer__r.BillingState,dealer__Deal__c.Proxy_Dealer__r.BillingCity,dealer__Deal__c.Proxy_Dealer__r.BillingStreet,dealer__Deal__c.Proxy_Dealer__c,dealer__Deal__c.Title_Type__c,dealer__Deal__c.Title_State__c,dealer__Deal__c.Mileage_Type__c,BUYER_S_ORDER_TERMS_Doc__c,dealer__Deal__c.Taxable_Total_Doc__c,dealer__Deal__c.Taxable_Total_Notes_Doc__c,dealer__Deal__c.Trade_in_Doc__c,dealer__Deal__c.Trade_in_Notes_Doc__c,dealer__Deal__c.Proxy_Dealer_Doc2__r.AccountNumber,dealer__Deal__c.Buyer_Account_Doc2__r.AccountNumber,Lienholder__r.AccountNumber,Lienholder__r.dealer__FirstName__c,Lienholder__r.dealer__LastName__c,Lienholder__r.BillingStreet,Lienholder__r.BillingCity,Lienholder__r.BillingState,Lienholder__r.BillingPostalCode,Lienholder__r.BillingCountry,Lienholder__r.Phone,Lienholder__r.dealer__PersonEmail__c,dealer__Deal__c.Proxy_Dealer_Doc2__r.dealer__PersonEmail__c,Proxy_Dealer_Doc2__r.dealer__LastName__c,Proxy_Dealer_Doc2__r.dealer__FirstName__c,Buyer_Account_Doc2__r.dealer__LastName__c ,dealer__Deal__c.Buyer_Account_Doc2__r.dealer__FirstName__c ,dealer__Deal__c.Buyer_Account_Doc2__c,dealer__Deal__c.Sale_Date_Doc__c,Proxy_Dealer_Doc2__r.Id,Proxy_Dealer_Doc2__r.website,Proxy_Dealer_Doc2__r.Phone,Buyer_Account_Doc2__r.website,Buyer_Account_Doc2__r.Phone,Buyer_Account_Doc2__r.BillingCountry,Buyer_Account_Doc2__r.BillingPostalCode,Buyer_Account_Doc2__r.BillingState,Buyer_Account_Doc2__r.BillingStreet,Proxy_Dealer_Doc2__r.BillingCountry ,Proxy_Dealer_Doc2__r.BillingPostalCode ,Proxy_Dealer_Doc2__r.BillingState ,Proxy_Dealer_Doc2__r.BillingStreet ,dealer__Deal__c.Proxy_Dealer_Doc2__c ,Proxy_Dealer_Doc2__r.BillingAddress,dealer__Deal__c.id,dealer__Deal__c.Refund_Notes_Doc__c ,dealer__Buyer_Contact__r.Email, Buyer_Account_Doc2__r.dealer__PersonEmail__c,Buyer_Account_Doc2__r.Id,Buyer_Account_Doc2__r.BillingCity,Proxy_Dealer_Doc2__r.BillingCity,dealer__Deal__c.Sales_Price_Doc__c ,dealer__Deal__c.Standard_Buyer_Fee_Doc__c  ,dealer__Deal__c.Deposit_Doc__c ,dealer__Deal__c.Refund_Doc__c ,dealer__Deal__c.Shipping_Fee_Doc__c ,dealer__Deal__c.Transaction_Fee_Doc__c  ,dealer__Deal__c.Deposit__c ,dealer__Deal__c.Shipping_Fee__c ,
      dealer__Deal__c.Mailing_Fee__c ,dealer__Deal__c.Export_Fee__c ,dealer__Deal__c.Documentation_Fee__c ,dealer__Deal__c.Adjustment__c ,dealer__Deal__c.Purchase_Date__c ,dealer__Deal__c.Total_Due__c ,dealer__Deal__c.Buyer_Fee_Notes__c ,dealer__Deal__c.Standard_Buyer_Fee__c , dealer__Deal__c.Price_Notes__c ,dealer__Deal__c.Sales_Price__c ,dealer__Deal__c.Transaction_Notes_Doc__c,dealer__Deal__c.Shipping_Notes_Doc__c, dealer__Deal__c.Deposit_Notes_Doc__c, dealer__Deal__c.Buyer_Fee_Notes_Doc__c, dealer__Deal__c.Price_Notes_Doc__c,dealer__Deal__c.dealer__Mileage__c ,dealer__Deal__c.dealer__VIN__c,dealer__Deal__c.dealer__Model__c ,dealer__Deal__c.dealer__Make__c ,dealer__Deal__c.dealer__Deal_ID__c, dealer__Deal__c.dealer__Year__c ,dealer__Deal__c.Customer_Payment__c ,Name,dealer__Deal__c.Late_Fee_Doc__c,dealer__Deal__c.Late_Fee_Notes_Doc__c,dealer__Deal__c.Storage_Fee_Doc__c,dealer__Deal__c.Storage_Fee_Notes_Doc__c,dealer__Deal__c.Mailing_Fee_Doc__c,dealer__Deal__c.Mailing_Notes_Doc__c,dealer__Deal__c.Export_Fee_Doc__c,dealer__Deal__c.Export_Notes_Doc__c,dealer__Deal__c.Documentation_Fee_Doc__c,dealer__Deal__c.Doc_Fee_Notes_Doc__c,dealer__Deal__c.Adjustment_Doc__c,dealer__Deal__c.Adjustment_Notes_Doc__c,dealer__Deal__c.Customer_Payment_Doc__c,dealer__Deal__c.Payment_Notes_Doc__c,dealer__Deal__c.Transfer_From_Doc__c,dealer__Deal__c.Transfer_From_Notes_Doc__c,dealer__Deal__c.Transfer_To_Doc__c,dealer__Deal__c.Transfer_To_Notes_Doc__c,dealer__Deal__c.Sales_Tax_Doc_perc__c,dealer__Deal__c.Sales_Tax_Doc__c,dealer__Deal__c.Total_Due_Doc__c FROM dealer__Deal__c where id = :ApexPages.currentPage().getParameters().get('id')];

try{
      doc = [SELECT Id,parentid FROM Attachment WHERE parentid = :Deal.Proxy_Dealer_Doc2__r.Id and name LIKE 'sellerlogo%' LIMIT 1];
   }catch(QueryException e){}
       if (doc != null){
       Deal.logo_proxy_dealer_doc__c='https://c.cs44.content.force.com/servlet/servlet.FileDownload?file=' + doc.id;
    }else{
    Deal.logo_proxy_dealer_doc__c=null;//default pic
    }
try{
     doc2 = [SELECT id,name FROM document WHERE name LIKE 'DealerImsComLogo%' LIMIT 1];
   }catch(QueryException e){}
       if (doc2 != null){
       DealerImsComLogo='https://c.cs44.content.force.com/servlet/servlet.FileDownload?file=' + doc2.id;
    }else{
    DealerImsComLogo=null;//default pic
 }
    }
   
 
    public PageReference send() {

        // Define the email
Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
PageReference pdf;
pdf = Page.RetailBillofSale;
pdf.getParameters().put('id',(String)Deal.id);
pdf.setRedirect(true);

// Take the PDF content
Blob b ;

if (Test.IsRunningTest())
   {
        b=Blob.valueOf('UNIT.TEST');
   }
   else
   {
        b = pdf.getContent();
   }


// Create the email attachment
Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
efa.setFileName('Retail Bill of Sale ' + ' ' +  Deal.dealer__Year__c + ' ' + Deal.dealer__Make__c + ' ' + Deal.dealer__Model__c + ' ' + Deal.dealer__VIN__c + '.pdf');
efa.setBody(b);
email.setSubject( subject );
email.setPlainTextBody( body );
List <String> toAddrlist=new List<String>{};


for(String emailId:emailaddr.split(';  |; |;|,  |, |,| ', 0)){

            if(emailId != null && emailId !=''&& emailId != ' '){
                toAddrlist.add(emailId.trim());
                
                 
                       email.setToAddresses(toAddrlist); 
                       toAddrlist.remove(0);

                                 
                    Messaging.SendEmailResult [] r = 
       Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});      
            }
      }
       return null;
    }
    public sendEmail_RBofS(ApexPages.StandardController stdController) {
    
      Deal = [SELECT dealer__Deal__c.Proxy_Dealer__r.BillingCountry,dealer__Deal__c.Proxy_Dealer__r.BillingPostalCode,dealer__Deal__c.Proxy_Dealer__r.BillingState,dealer__Deal__c.Proxy_Dealer__r.BillingCity,dealer__Deal__c.Proxy_Dealer__r.BillingStreet,dealer__Deal__c.Proxy_Dealer__c,dealer__Deal__c.Title_Type__c,dealer__Deal__c.Title_State__c,dealer__Deal__c.Mileage_Type__c,BUYER_S_ORDER_TERMS_Doc__c,dealer__Deal__c.Taxable_Total_Doc__c,dealer__Deal__c.Taxable_Total_Notes_Doc__c,dealer__Deal__c.Trade_in_Doc__c,dealer__Deal__c.Trade_in_Notes_Doc__c,dealer__Deal__c.Proxy_Dealer_Doc2__r.AccountNumber,dealer__Deal__c.Buyer_Account_Doc2__r.AccountNumber,Lienholder__r.AccountNumber,Lienholder__r.dealer__FirstName__c,Lienholder__r.dealer__LastName__c,Lienholder__r.BillingStreet,Lienholder__r.BillingCity,Lienholder__r.BillingState,Lienholder__r.BillingPostalCode,Lienholder__r.BillingCountry,Lienholder__r.Phone,Lienholder__r.dealer__PersonEmail__c,dealer__Deal__c.Proxy_Dealer_Doc2__r.dealer__PersonEmail__c,Proxy_Dealer_Doc2__r.dealer__LastName__c,Proxy_Dealer_Doc2__r.dealer__FirstName__c,Buyer_Account_Doc2__r.dealer__LastName__c ,dealer__Deal__c.Buyer_Account_Doc2__r.dealer__FirstName__c ,dealer__Deal__c.Sale_Date_Doc__c,Proxy_Dealer_Doc2__r.Id,Proxy_Dealer_Doc2__r.website,Proxy_Dealer_Doc2__r.Phone,Buyer_Account_Doc2__r.website,Buyer_Account_Doc2__r.Phone,Buyer_Account_Doc2__r.BillingCountry,Buyer_Account_Doc2__r.BillingPostalCode,Buyer_Account_Doc2__r.BillingState,Buyer_Account_Doc2__r.BillingStreet,Proxy_Dealer_Doc2__r.BillingCountry ,Proxy_Dealer_Doc2__r.BillingPostalCode ,Proxy_Dealer_Doc2__r.BillingState ,Proxy_Dealer_Doc2__r.BillingStreet ,dealer__Deal__c.Proxy_Dealer_Doc2__c ,Proxy_Dealer_Doc2__r.BillingAddress,dealer__Deal__c.id,dealer__Deal__c.Refund_Notes_Doc__c ,dealer__Buyer_Contact__r.Email, Buyer_Account_Doc2__r.dealer__PersonEmail__c,Buyer_Account_Doc2__r.Id,Buyer_Account_Doc2__r.BillingCity,Proxy_Dealer_Doc2__r.BillingCity,dealer__Deal__c.Sales_Price_Doc__c ,dealer__Deal__c.Standard_Buyer_Fee_Doc__c  ,dealer__Deal__c.Deposit_Doc__c ,dealer__Deal__c.Refund_Doc__c ,dealer__Deal__c.Shipping_Fee_Doc__c ,dealer__Deal__c.Transaction_Fee_Doc__c  ,dealer__Deal__c.Deposit__c ,dealer__Deal__c.Shipping_Fee__c ,
      dealer__Deal__c.Mailing_Fee__c ,dealer__Deal__c.Export_Fee__c ,dealer__Deal__c.Documentation_Fee__c ,dealer__Deal__c.Adjustment__c ,dealer__Deal__c.Purchase_Date__c ,dealer__Deal__c.Total_Due__c ,dealer__Deal__c.Buyer_Fee_Notes__c ,dealer__Deal__c.Standard_Buyer_Fee__c , dealer__Deal__c.Price_Notes__c ,dealer__Deal__c.Sales_Price__c ,dealer__Deal__c.Transaction_Notes_Doc__c,dealer__Deal__c.Shipping_Notes_Doc__c, dealer__Deal__c.Deposit_Notes_Doc__c, dealer__Deal__c.Buyer_Fee_Notes_Doc__c, dealer__Deal__c.Price_Notes_Doc__c, 
      dealer__Deal__c.dealer__Mileage__c ,dealer__Deal__c.dealer__VIN__c,dealer__Deal__c.dealer__Model__c ,dealer__Deal__c.dealer__Make__c ,dealer__Deal__c.dealer__Deal_ID__c, dealer__Deal__c.dealer__Year__c ,dealer__Deal__c.Customer_Payment__c ,Name,dealer__Deal__c.Late_Fee_Doc__c,dealer__Deal__c.Late_Fee_Notes_Doc__c,dealer__Deal__c.Storage_Fee_Doc__c,dealer__Deal__c.Storage_Fee_Notes_Doc__c,dealer__Deal__c.Mailing_Fee_Doc__c,dealer__Deal__c.Mailing_Notes_Doc__c,
      dealer__Deal__c.Export_Fee_Doc__c,dealer__Deal__c.Export_Notes_Doc__c,dealer__Deal__c.Documentation_Fee_Doc__c,dealer__Deal__c.Doc_Fee_Notes_Doc__c,dealer__Deal__c.Adjustment_Doc__c,dealer__Deal__c.Adjustment_Notes_Doc__c,dealer__Deal__c.Customer_Payment_Doc__c,dealer__Deal__c.Payment_Notes_Doc__c,dealer__Deal__c.Transfer_From_Doc__c,dealer__Deal__c.Transfer_From_Notes_Doc__c,dealer__Deal__c.Transfer_To_Doc__c,dealer__Deal__c.Transfer_To_Notes_Doc__c,dealer__Deal__c.Sales_Tax_Doc_perc__c,dealer__Deal__c.Sales_Tax_Doc__c,dealer__Deal__c.Total_Due_Doc__c FROM dealer__Deal__c where id = :ApexPages.currentPage().getParameters().get('id')];
try{
      doc = [SELECT Id,parentid FROM Attachment WHERE parentid = :Deal.Proxy_Dealer_Doc2__r.Id and name LIKE 'sellerlogo%' LIMIT 1];
   }catch(QueryException e){}
       if (doc != null){
       Deal.logo_proxy_dealer_doc__c='https://c.cs44.content.force.com/servlet/servlet.FileDownload?file=' + doc.id;
    }else{
    Deal.logo_proxy_dealer_doc__c=null;//default pic
 }
          
        
    }
}