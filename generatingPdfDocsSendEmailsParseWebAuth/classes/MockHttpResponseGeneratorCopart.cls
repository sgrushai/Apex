@isTest(SeeAllData=true)
global class MockHttpResponseGeneratorCopart implements HttpCalloutMock {
    public static String headerLocation {get;set;}
    public static String body {get;set;}
    
    global static HTTPResponse respond(HTTPRequest req) {
        body = '<div id="TitleHead" class="content-header"><!--AUR-5198 Language header weired characters conversion into proper text -Naveen, Vijay- Aug-19-2013--><h2>2011 FORD FIESTA SE</h2>';
		body += '<div class="details_module lot-display-value"><h5 class="details_header">Lot #35987535 Details<a class="details_header2" href="/Content/us/en/Support/FAQ-Topics/Common-Terms" target="_blank">Glossary</a>';
   		body += '</h5><div class="lot-display-list"><div><label for="SaleTitleDescription">Doc Type:</label><div class="details_content downloads">';
        body += 'SC-NON-REB &amp; REM SALVAGE TITLE<a href="#" class="tooltipimg lottooltip" data-tt-title="" data-tt-content="SC - CERTIFICATE OF TITLE OF A SALVAGE NON-REBUILDABLE VEHICLE branded SALVAGE-NON REB and SALVAGE NON REM. This title states &quot;SCRAP VEHICLE.  CANNOT BE REGISTERED OR RETITLED. THIS VEHICLE CAN ONLY BE USED FOR PARTS OR    SCRAP METAL.&quot;"></a>';
        body += '</div></div><div><label for="Odometer:">Odometer:</label>61,789 mi. (ACTUAL)<a class="tooltipimg" data-event-name="click" data-highlighturl="/us/LotCodes/MileageTypesTip" data-icon-code="" href="#" title="MILEAGE TYPES"></a>      </div>';
        body += '<div><label for="Highlights:">Highlights:</label><div class="downloads">Enhanced Vehicles<a class="tooltipimg" data-event-name="click" data-highlighturl="/us/Cms/Fragment?pageName=_LotIcons%2FLot-Icon-List&amp;fragmentName=CERT-E" data-icon-code="CERT-E" href="#" title="Enhanced Vehicles"></a>                  <br>';
		body += '</div></div><div><label for="Seller:">Seller:</label>State Farm Insurance</div><div><label>Primary Damage:</label>WATER/FLOOD</div><div><label>Secondary Damage:</label></div>';
      	body += '<div><label>Est. Retail Value:</label>$9,764 USD</div><div><label>Repair Est:</label>$9,764 USD</div><div><label for="VIN:">VIN:</label><span id="vinDiv">3FADP4BJ0BM231867</span>';
        body += '</div><div><label>Body Style:</label>SEDAN 4DR</div><div><label>Color:</label>GREEN</div><div><label>Engine Type:</label>1.6L  4</div><div><label>Drive:</label>FRONT-WHEEL DRIVE</div>';
      	body += '<div><label>Cylinder:</label>4</div><div><label>Fuel:</label>GAS</div><div><label for="Keys:">Keys:</label>YES</div><div><label for="Notes:">Notes:</label>';
        body += '<div class="lotnotes special-notes">VEH LOC @ STH GASTON SUBLOT</div></div></div></div>';
        body += '<div class="lot-display-list"><div class="noborder"><label for="Location:">Location:</label><a href="/us/Locations/56">SC - COLUMBIA</a></div><div class="note">';
        body += '<a href="/us/Services/Inspectors?locationId=56" class="link">Inspection Services</a></div><div><label>Lane/Item / Grid/Row:</label>C/ 3104/ 2SC07</div>      <div class="noborder">';
        body += '<label for="Sale_Date:">Sale Date:</label><!--Auction Date--><span class="converted-time" data-original-time="1/29/2016 10:00:00 AM -05:00" title="1/29/2016 10:00:00 AM -05:00">Fri. Jan 29, 2016</span>';
      	body += '</div><div class="note"><span class="converted-time" data-original-time="1/29/2016 10:00:00 AM -05:00" title="1/29/2016 10:00:00 AM -05:00">10:00 AM EST</span>';
        body += '</div><div class="addressBlock"><label for="Sublot_Location_:">Sublot Location :</label><a href="#" class="tooltipimg lottooltip" data-tt-title="" data-tt-content="This vehicle is located at the address listed. Sublot vehicles are not physically stored at the main facility." title="Sublot Location"></a>';
        body += '<div class="note"><span class="address">700 SOUTH BOUND ROADGASTON,SC,29053</span></div></div></div><ul id="bx-pager"><a data-slide-index="0" href="" class="active"><li><img class="lazyLoadt" ';
        body += 'src="https://images.copart.com/website/data/pix/20160317/20055586_01.JPG" width="86" height="72" alt="image" data-bind="click:imgClick"></li></a><a data-slide-index="1" href=""><li>';
        body += '<img class="lazyLoadt" src="https://images.copart.com/website/data/pix/20160317/20055586_02.JPG" width="86" height="72" alt="image" data-bind="click:imgClick"></li></a>';
        body += '<a data-slide-index="2" href=""><li><img class="lazyLoadt" src="https://images.copart.com/website/data/pix/20160317/20055586_03.JPG" width="86" height="72" alt="image" data-bind="click:imgClick"></li></a></ul>';
        
        headerLocation = '';
        HttpResponse res = new HttpResponse();
        res.setHeader('Location', headerLocation);
        res.setBody(body);
        res.setStatusCode(200);
        return res;
    }
}