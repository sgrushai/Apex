@isTest(SeeAllData=true)
global class MockHttpResponseGeneratorNPAimgs implements HttpCalloutMock {
    public static String headerLocation {get;set;}
    public static String body {get;set;}
    
    global static HTTPResponse respond(HTTPRequest req) {
        body = '<td class="scastDetailImages" align="left" valign="top">';
		body += '<a href="http://www.npauctions.com/ImageCache.aspx?PictureID=ef67d5a3-7da3-4f4f-bf3a-3e1f88a03314&amp;width=0&amp;height=0&amp;quality=95" target="_blank">';
        body += '<img name="Pic0" src="http://www.npauctions.com/AMSProto/temp/Ief67d5a3-7da3-4f4f-bf3a-3e1f88a03314_120_0.JPG" border="0" hspace="3" vspace="3" width="120"></a>';
        body += '<a href="http://www.npauctions.com/ImageCache.aspx?PictureID=fdd96202-9285-4bd9-903e-19f9cedb5042&amp;width=0&amp;height=0&amp;quality=95" target="_blank">';
        body += '<img name="Pic1" src="http://www.npauctions.com/AMSProto/temp/Ifdd96202-9285-4bd9-903e-19f9cedb5042_120_0.JPG" border="0" hspace="3" vspace="3" width="120"></a>';
        body += '<a href="http://www.npauctions.com/ImageCache.aspx?PictureID=250bae78-b63e-4039-9dcb-51fa6cbdba79&amp;width=0&amp;height=0&amp;quality=95" target="_blank">';
        body += '<img name="Pic2" src="http://www.npauctions.com/AMSProto/temp/I250bae78-b63e-4039-9dcb-51fa6cbdba79_120_0.JPG" border="0" hspace="3" vspace="3" width="120"></a>';
         
		headerLocation = '';
        HttpResponse res = new HttpResponse();
        res.setHeader('Location', headerLocation);
        res.setBody(body);
        res.setStatusCode(200);
        return res;
    }
}