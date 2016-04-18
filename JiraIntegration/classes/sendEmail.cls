global class sendEmail {
    
	//public sendEmail(String subject, String body) {
	//}

	WebService static void send(String subject, String body) {
		 
		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
        List <User> adminEmail;
        List <profile> profileId;
        String[] toAddresses = new String[] {'grushai.sergii@gmail.com'};
          //  'grushai.sergii@gmail.com'
        profileId=[select id, name from profile where name='System Administrator' LIMIT 1];
		adminEmail = [select Id, Email from User where Profileid =: profileId[0].Id AND isactive=true];
       
        //for(User m: adminEmail){
           // toAddresses.add(m.Email);
       // }
        try{
		email.setSubject( subject );
        System.debug(toAddresses);
		email.setToAddresses(toAddresses);
		email.setPlainTextBody( body );
        email.setBccSender(false);

		Messaging.SendEmailResult [] r = 
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
        }catch(Exception e){
            System.debug(e);
        }
	}
}