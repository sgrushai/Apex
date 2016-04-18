# customCalendarLead

Overview:
This Project is a simple project to test your ability in following specification documents, creating apex & visualforce pages, create unit test, and use material design systems to create great look and feel page.
This project shouldn’t take more than 20 hours to complete.

Specification:
1.	Create a new visualforce page called: CreateAppointment
2.	Create a new controller class called: CreateAppointmentController
3.	Create a new unit test class called: CreateAppointmentTest
4.	Choose one of these three design frameworks to create the visualforce page:
a.	materialize
b.	lightning design system
c.	angular material
5.	Page Functionality (see mockup for layout)
a.	Create a new button on Lead Detail Page called: Create Appointment
b.	Button click opens up a new browser tab with CreateAppointment visualforce page
c.	Customer Information - pulls data from lead we saved from the lead page
i.	Display First Name, Last Name, Street Address, City, State, Zipcode
d.	Lead Owner:
i.	This is the Lead Owner information
ii.	Display Owner First Name, Last Name, Email, Phone
e.	Estimator Calendar (use a week view calendar that allows clicking into the day and auto populate the time it’s clicked) 
i.	Show the current week view of the lead owner for the calendar (use an opensource calendar of your choice)
ii.	Only display lead owner’s current events from 6am - 8pm
1.	display event subject
2.	event location
3.	event start and end datetime
iii.	When user click on the calendar, create the appointment for that time where user clicked.
iv.	Appointment Information:
1.	Event Duration: 1 hours long
2.	Start/End Datetime: based on where user clicked on the calendar (make this editable picklists (1 picklist for hours, 1 for minutes, and 1 for ampm)
3.	Event Date: based on where user clicked on the calendar
4.	Event Owner = Lead OwnerId
5.	Show Time As: Default to Busy (popup picklist like salesforce)
6.	Email = Lead Email
7.	Subject: Default to Appointment (popup picklist like salesforce)
8.	Location = Lead Address
9.	Phone = Lead Phone
10.	WhatId = OpportunityId (see below)
11.	WhoId = ContactId (see below)
v.	When user click on Save Appointment, convert lead and create opportunity.
1.	then check to see if user manually edited the start datetime to a timeslot that’s unavailable to user or set the time beyond the 6am-8pm period. 
a.	If user booked appointment over a busy period, display dialog box to alert user that they are double booking. They can choose to continue double book.
b.	if appointment is booked beyond 6am-8pm, do not allow it.
2.	Convert Lead with create opportunity
3.	assign converted opportunity id to whatid
4.	assign converted contact id to whoId
5.	insert Event
6.	go to the regular salesforce opportunity page


BONUS: If you can complete this bonus item, it will be a big plus for the interview consideration:
1.	when user decide to save lead. determine if user has enough time to travel to the next appointment destination through google travel
a.	Get the lead address from the previous appointment on the same day
b.	Get the lead address of the new appointment
c.	Get the lead address of the next appointment (if there is any)
d.	Check google map to find the approximate travel time (including traffic) between the two addresses, show the travel time on the popup dialog box. use this: https://developers.google.com/maps/documentation/distance-matrix/intro
e.	If the travel time is greater than the gap between the appointments + 30 minutes, alert the user
f.	Do the same thing for the new appointment and the next appointment on the same day
