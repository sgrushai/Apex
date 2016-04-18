@isTest(SeeAllData=true)
global class MockHttpResponseGeneratorMetroSP implements HttpCalloutMock {
    public static String body {get;set;}
    
    global static HTTPResponse respond(HTTPRequest req) {
        body = '<td style="white-space: nowrap;" valign="top"><u><b>Next Sale Date:</b></u><br><a href="SaleListPage.asp?SD=4/8/2016&amp;ST=SAL&amp;SID=1&amp;YD=1"><font color="white">4/8/2016</font></a></td>';
		body += '<tbody><tr><td align="left" width="11%">&nbsp;</td><td align="left" width="23%"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2">StockID#:</font></b></td>';
    	body += '<td colspan="2" align="left" width="66%"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">75590</font></td></tr><tr><td width="11%">&nbsp;</td>';
		body += '<td width="23%"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Primary Damage:</font></b></td><td colspan="2" width="66%"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Front</font></td>';
		body += '</tr><tr><td width="11%">&nbsp;</td><td width="23%"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Year:</font></b></td>';
    	body += '<td colspan="2" width="66%"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">2012</font></td></tr><tr><td width="11%">&nbsp;</td>';
    	body += '<td width="23%"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Make:</font></b></td><td colspan="2" width="66%"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">SKI DOO</font></td>';
  		body += '</tr><tr> <td width="11%">&nbsp;</td><td width="23%"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Model:</font></b></td>';
    	body += '<td colspan="2" width="66%"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">MXZ 600 SPORT</font></td></tr><tr> <td width="11%">&nbsp;</td>';
    	body += '<td width="23%"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Color:</font></b></td><td colspan="2" width="66%"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">black and yellow</font></td>';
  		body += '</tr><tr><td width="11%">&nbsp;</td><td width="23%"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Title:</font></b></td>';
    	body += '<td colspan="2" width="66%"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Good Title</font></td></tr><tr><td width="11%">&nbsp;</td>';
    	body += '<td width="23%"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Engine:</font></b></td><td colspan="2" width="66%"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">600cc</font></td>';
  		body += '</tr><tr><td width="11%">&nbsp;</td><td width="23%"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Vin#:</font></b></td>';
    	body += '<td colspan="2" width="66%"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">2BPSBHCB3CV000316</font></td></tr></tbody>';
        body += '<table border="0" width="85%"><tbody><tr><td width="15%">&nbsp;</td><img src="photos/2016/000_75590_001.jpg" onclick="window.open(" height="125" border="0" width="125">';
		body += '<img src="photos/2016/001_75590_001.jpg" onclick="window.open(" height="125" border="0" width="125">';
		body += '<img src="photos/2016/002_75590_001.jpg" onclick="window.open()" height="125" border="0" width="125">';
		body += '<font face="Verdana, Arial, Helvetica, sans-serif" size="2"><img src="media/images/AIMSlogoSmall.jpg" height="34" width="84"></font>';
        body += '<td width="23%"><b><font face="" size="2">Mileage:</font></b></td><td colspan="2" width="66%"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">23653</font>';
        body += '<td width="23%"><b><font face="" size="2">Mileage Type:</font></b></td><td colspan="2" width="66%"><font face="" size="2">Actual Mileage</font></td>';
   		
        HttpResponse res = new HttpResponse();
        res.setBody(body);
        res.setStatusCode(200);
        return res;
    }
}