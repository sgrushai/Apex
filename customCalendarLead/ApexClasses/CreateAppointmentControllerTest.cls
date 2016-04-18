@isTest(SeeAllData=true)
private class CreateAppointmentControllerTest{
static Lead ld;

static {
ld= new Lead();
ld.FirstName='John';
ld.LastName='Sm';
ld.Company='Sms';
ld.Status='Open - Non Contacted';
insert ld;
}

static testmethod void test(){
PageReference pageRef = Page.CreateAppointment;
         Test.setCurrentPage(pageRef);
pageRef.getParameters().put('Id', String.valueOf(ld.Id));

ApexPages.StandardController sc = new ApexPages.standardController(ld);
    CreateAppointmentController e = new CreateAppointmentController(sc);
    e.pageLoad();
CreateAppointmentController.createEv('00Q240000044XGT', '4/3/2016/18/00', 'a@a.com', '222', 'Appointment', 'Busy', 'New York');
}



}