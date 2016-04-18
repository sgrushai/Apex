global class CreateAppointmentController {
    public Lead myLead {get;set;}
    public list<calEvent> events {get;set;}
    //public static id LeadOwnerId;
    
    //The calendar plugin is expecting dates is a certain format. We can use this string to get it formated correctly
    // String dtFormat = 'EEE, d MMM yyyy HH:mm:ss u';
    //3/31/2016 5:00 PM
    //'EEE, d MMM yyyy HH:mm:ss z';
    static String dtFormat = 'yyyy-MM-dd HH:mm';
    //String dtFormat = 'MM/dd/yyyy HH:mm:ss';
    
    //String dtFormat = 'EEE, d MMM yyyy HH:mm:ss z';//standard
    
    public CreateAppointmentController(ApexPages.StandardController controller) {
        myLead = (Lead)controller.getRecord();
        pageLoad();
    }
    
    public void pageLoad() {
        events = new list<calEvent>();
        
        for(Event evnt: [select Id, Subject, isAllDayEvent, StartDateTime, EndDateTime, Location from Event where OwnerID = :UserInfo.getUserId()]){ //where OwnerID = :UserInfo.getUserId()]){
            DateTime startDT = evnt.StartDateTime;
            DateTime endDT = evnt.EndDateTime;
            calEvent myEvent = new calEvent();
            
            myEvent.title = evnt.Subject;
            myEvent.allDay = evnt.isAllDayEvent;
            myEvent.startString = startDT.format(dtFormat);
            myEvent.endString = endDT.format(dtFormat);
            myEvent.url = '/' + evnt.Id;
            myEvent.location = evnt.Location;
            myEvent.className = 'event-personal';
            events.add(myEvent);
        }
    }
   
    
    public class calEvent{
        public String title {get;set;}
        public Boolean allDay {get;set;}
        public String startString {get;set;}
        public String endString {get;set;}
        public String url {get;set;}
        public String className {get;set;}
        public String location {get;set;}
    }
    
    @RemoteAction
    global static Object createEv(String leadId, String eventStartDateTime, String eventEmail, String eventPhone, String eventSubject, String eventShowTime, String eventLocation) {
        Event newEvent;
        Lead thisLead = [Select id, Phone, Email, Address, OwnerId, isConverted, FirstName, LastName From Lead Where id =: leadId];
        thisLead.ErrorMessages__c = '';
        List<Event> eventList = [Select id, StartDateTime, EndDateTime, Location From Event];
        List<String> tmpDates = eventStartDateTime.split('/');
        Datetime startdt = Datetime.newInstance(Integer.valueOf(tmpDates.get(2)), Integer.valueOf(tmpDates.get(0)), Integer.valueOf(tmpDates.get(1)), Integer.valueOf(tmpDates.get(3)), Integer.valueOf(tmpDates.get(4)), 0);
        Datetime enddt = Datetime.newInstance(Integer.valueOf(tmpDates.get(2)), Integer.valueOf(tmpDates.get(0)), Integer.valueOf(tmpDates.get(1)), Integer.valueOf(tmpDates.get(3))+1, Integer.valueOf(tmpDates.get(4)), 0);
        integer startNewEvent = (startdt.hour()*60) + startdt.minute();
        integer endNewEvent = (enddt.hour()*60) + enddt.minute();
        
        for(Event tmpEv: eventList) {
            if(tmpEv.StartDateTime.date() == startdt.date()) {
                integer startMin = (Integer.valueOf(tmpEv.StartDateTime.hour())*60) + Integer.valueOf(tmpEv.StartDateTime.minute());
                integer endMin = (Integer.valueOf(tmpEv.EndDateTime.hour())*60) + Integer.valueOf(tmpEv.EndDateTime.minute());

                if(startMin < endNewEvent && startMin > startNewEvent) {
                    thisLead.ErrorMessages__c = 'You have double booking. You can choose to continue double book.';
                    return thisLead;
                }
                if(endMin < endNewEvent && endMin > startNewEvent) {
                    thisLead.ErrorMessages__c = 'You have double booking. You can choose to continue double book.';
                    return thisLead;
                }
                if(startMin <= startNewEvent && endMin >= endNewEvent) {
                    thisLead.ErrorMessages__c = 'You have double booking. You can choose to continue double book.';
                    return thisLead;
                }
                
                integer distanceTime = sendGet(eventLocation, tmpEv.Location);
                if(endMin + distanceTime > startNewEvent) {
                    thisLead.ErrorMessages__c = 'Time your move for ' + distanceTime + ' minutes, you do not have time for the scheduled appointment.';
                    return thisLead;
                }
                if(endNewEvent + distanceTime > startMin) {
                    thisLead.ErrorMessages__c = 'Time your move for ' + distanceTime + ' minutes, you do not have time for the scheduled business time.';
                    return thisLead;
                }
            }
        }
        
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(leadId);
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        
        Contact con = new Contact(id=lcr.getContactId());  
        Opportunity opp = new Opportunity(id=lcr.getOpportunityId());
        update con;
        update opp;
        
        newEvent = new Event(
            IsAllDayEvent = false,
            OwnerId = thisLead.OwnerId,
            StartDateTime = startdt,
            EndDateTime = enddt,
            Subject = eventSubject,
            ShowAs = eventShowTime,
            Location = eventLocation,
            WhoId = lcr.getContactId(),
            WhatId = lcr.getOpportunityId());
        insert newEvent;

        thisLead.ErrorMessages__c = '';
        thisLead.Description = lcr.getOpportunityId();
        return thisLead;
    }
    
    
    webservice static Integer sendGet(String firstCity, String secondCity) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint('https://maps.googleapis.com/maps/api/distancematrix/json?origins=' + firstCity + '&destinations=' + secondCity);
        req.setMethod('GET');
        req.setHeader('Accept', '*/*');

        HTTPResponse res;
        if(!Test.isRunningTest()) {
            res = http.send(req);
        } else {
            res = MockHttpResponseGeneratorAppointment.respond(req);
        }
   
        Map<String, Object> body = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        List<Object> rows = (List<Object>) body.get('rows');
        Map<String, Object> elements = (Map<String, Object>) rows.get(0);
        List<Object> elementsList = (List<Object>) elements.get('elements');
        Map<String, Object> elementMap = (Map<String, Object>) elementsList.get(0);
        Map<String, Object> duration = (Map<String, Object>) elementMap.get('duration');
        Integer distance = integer.valueOf(duration.get('value'));
        distance = distance/60;
        distance += 30;
        return distance;
    }
}