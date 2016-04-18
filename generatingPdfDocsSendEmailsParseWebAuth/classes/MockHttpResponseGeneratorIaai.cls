@isTest(SeeAllData=true)
global class MockHttpResponseGeneratorIaai implements HttpCalloutMock {
    public static String body {get;set;}
    
    global static HTTPResponse respond(HTTPRequest req) {
        body = '<div class="topLocationLinkDiv left"><a href="#SaleinfoDiv" id="ctl00_ContentPlaceHolder1_topLocationlink" class="salesStatus_STTL" style="margin-left:0px;">Columbia1</a></div>';
        body += '<span id="ctl00_ContentPlaceHolder1_bidliveValue" class="salesStatus_bidliveValue" style="display:inline">Thu, Mar 3, 8:00 AM CST</span>';
        body += '<div class="option left" id="displaydiv" style="margin-top: 2px; margin-bottom: 2px; margin-left: 10px;"><span id="ctl00_ContentPlaceHolder1_year" style="font-size: 18px; font-weight: bold">2015</span>';
        body += '&nbsp;&nbsp;<span id="ctl00_ContentPlaceHolder1_make" style="font-size: 18px; font-weight: bold">Volkswagen</span>&nbsp;&nbsp;<span id="ctl00_ContentPlaceHolder1_model" style="font-size: 18px; font-weight: bold">Beetle</span></div>';
        body += '<div class="borderDetail borderDetailTop"><ul class="vehicle-auction-details"><li><dl><dt><span id="ctl00_ContentPlaceHolder1_lblStockNumber" class="vehicle-stock-details tip_stocknumber glossaryLink">Stock#</span>';
        body += ':</dt><dd><span id="ctl00_ContentPlaceHolder1_stockNumber" class="vehicle-stocknumber-details">16462325</span></dd></dl></li><li><dl><dt><span id="ctl00_ContentPlaceHolder1_lblSaleDoc" class="vehicle-stock-details tip_saleDocument glossaryLink">Sale Document</span>';
        body += ':</dt><dd><span id="ctl00_ContentPlaceHolder1_SaleDoc" class="vehicle-stock-details">SALVAGE(South Carolina)</span></dd></dl></li><li id="ctl00_ContentPlaceHolder1_liVehicleHistoryReport"><dl>';
        body += '<a onclick="return LaunchVHRReport();" id="ctl00_ContentPlaceHolder1_lbVehicleHistoryReport" onmouseover="VINTipInit(; return false;" onmouseout="VINTipInit(); return false;" href="javascript:__doPostBack()" style="font-size:1.2em;">Premium Vehicle Report</a>';
        body += '</dl></li></ul></div><div id="ctl00_ContentPlaceHolder1_DivStaticConditionsPlaceHolder" class="borderDetail"><dl class="vehicle-stats"><li><dt><span>Loss:</span></dt><dd><span>COLLISION</span></dd></li><li><dt><span>Primary:';
        body += '</span></dt><dd><span>FRONT END</span></dd></li><li><dt><span>Secondary:</span></dt><dd><span>UNKNOWN</span></dd></li><li><dt><span>Key:</span></dt><dd><span>Present</span></dd></li><li><dt><span>Start Code:</span></dt><dd><span>WONT START</span></dd></li><li><dt><span>Odometer</span></dt><dd><span>2754</span></dd></li><li><dt><span>Odometer Status</span></dt><dd><span>ACTUAL</span></dd></li></dl></div>';
        body += '<dd class="tip_vehicleStats"><span id="ctl00_ContentPlaceHolder1_VINc_VINLabel" class="tip_VIN" onmouseover="VINTipInit();" onmouseout="VINTipInit();">3VW517AT8FM821676</span></dd>"IN":1,""K":"222~SID';
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Location', '/Vehicles/VehicleDetails.aspx?itemID=21634682&RowNumber=0&loadRecent=True');
        res.setHeader('Set-Cookie', 'IAAIAUTH=');
        res.setBody(body);
        res.setStatusCode(200);
        return res;
    }
}