@isTest(SeeAllData=true)
global class MockHttpResponseGeneratorManheim implements HttpCalloutMock {
    public static String body {get;set;}
    
    global static HTTPResponse respond(HTTPRequest req) {
        
        body = '<div class="vehicleResultRow even" id="vehicleRow href="vehicleDetails.do?vehicleUniqueId=asdasdasd" onclick';
        body += '<label>Year:</label><span>2010</span><label>Make:</label><span>Mazda</span><label>Model:</label><span>RX</span>';
        body += '<label>Odometer:</label><span>135,2 mi</span><label>Title State:</label><span>IL</span>';
        body += '<dt>Facilitation</dt>  IN - Manheim Indianapolis - Specialty</a><dt>Sale Date</dt><dd>04/06/2016 - 10:00 AM ET</dd><dt>End Date</dt><dd>04/06/2016 04:00 PM EDT</dd>';
        body += '<div style="width: 470px;" id="thumbnails" class="gallery-thumbs"><div id="thumbnail-slider">';
        body += '<a id="image1" onclick="generateOmnitureImgEvent("OVE.WPBA.74089979", 1, 1)" class="gallery_thumb_car selected-image selected">';
        body += '<img src="https://images.cdn.manheim.com/20151201180922-5bbffe8a-d9c2-40c9-9835-f4cd6d37b267.jpg"onerror="javascript:this.src = noSmallImageUrl;" alt="Image 1" title="Image 1" height="62px !important" width="82px !important"></a>';
        body += '<a id="image2" onclick="generateOmnitureImgEvent(OVE.WPBA.74089979, 2, 2)" class="gallery_thumb_car ">';
        body += '<img src="https://images.cdn.manheim.com/20151201180943-032df9dd-c91c-42cf-a38d-5b62b1bf27de.jpg"onerror="javascript:this.src = noSmallImageUrl;" alt="Image 2" title="Image 2" height="62px !important" width="82px !important"></a>';
        body += '<a id="image3" onclick="generateOmnitureImgEvent(OVE.WPBA.74089979, 3, 3)" class="gallery_thumb_car ">';
        body += '<img src="https://images.cdn.manheim.com/20151201181005-e94f05e1-7d79-453f-b7a7-6a32f4387e5a.jpg"onerror="javascript:this.src = noSmallImageUrl;" alt="Image 3" title="Image 3" height="62px !important" width="82px !important"></a>';
        
        HttpResponse res = new HttpResponse();
        res.setBody(body);
        res.setStatusCode(200);
        return res;
    }
}