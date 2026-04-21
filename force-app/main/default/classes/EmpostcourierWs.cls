public class EmpostcourierWs{
    public  BookingRequest BookingRequest {set;get;}
   public class ResponseCr{
    public  BookingResponse BookingResponse {set;get;}

   }

    public class BookingRequest{
        Public String SenderContactName {set;get;}
        Public String SenderCompanyName {set;get;}
        Public String SenderAddress {set;get;}
        Public Integer SenderCity {set;get;}
        Public String SenderContactMobile {set;get;}
        Public String SenderContactPhone {set;get;}
        Public String SenderEmail {set;get;}
        Public String SenderZipCode {set;get;}
        Public String SenderState {set;get;}
        Public Integer SenderCountry {set;get;}
        Public String ReceiverContactName {set;get;}
        Public String ReceiverCompanyName {set;get;}
        Public String ReceiverAddress {set;get;}
        Public Integer ReceiverCity {set;get;}
        Public String ReceiverContactMobile {set;get;}
        Public String ReceiverContactPhone {set;get;}
        Public String ReceiverEmail {set;get;}
        Public String ReceiverZipCode {set;get;}
        Public String ReceiverState {set;get;}
        Public Integer ReceiverCountry {set;get;}
        Public String ReferenceNo {set;get;}
        Public String ReferenceNo1 {set;get;}
        Public String ReferenceNo2 {set;get;}
        Public String ReferenceNo3 {set;get;}
        Public String ContentTypeCode {set;get;}
        Public Integer NatureType {set;get;}
        Public String Service {set;get;}
        Public String ShipmentType {set;get;}
        Public String DeleiveryType {set;get;}
        Public String Registered {set;get;}
        Public String PaymentType {set;get;}
        Public String CODAmount {set;get;}
        Public String CODCurrency {set;get;}
        Public String CommodityDescription {set;get;}
        Public Integer Pieces {set;get;}
        Public Integer Weight {set;get;}
        Public String WeightUnit {set;get;}
        Public Integer Length {set;get;}
        Public Integer Width {set;get;}
        Public Integer Height {set;get;}
        Public String DimensionUnit {set;get;}
        Public String ItemValue {set;get;}
        Public String ValueCurrency {set;get;}
        Public String ProductCode {set;get;}
        Public Decimal DeliveryInstructionsID {set;get;}
        Public String RequestSource {set;get;}
        Public String SendMailToSender {set;get;}
        Public String SendMailToReceiver {set;get;}
        Public String PreferredPickupDate {set;get;}
        Public String PreferredPickupTimeFrom {set;get;}
        Public String PreferredPickupTimeTo {set;get;}
        Public String Is_Return_Service {set;get;}
        Public String PrintType {set;get;}
        Public String Latitude {set;get;}
        Public String Longitude {set;get;}
        Public String TransactionSource {set;get;}
        Public String AWBType {set;get;}
        Public String RequestType {set;get;}
        Public String Remarks {set;get;}
        Public String SpecialNotes {set;get;}
        Public String SenderRegionId {set;get;}
        Public String ReceiverRegionId {set;get;}
        Public String AWBNumber {set;get;}
    }
    public class  BookingResponse{

        Public String    Status     {set;get;}
        Public String    Description    {set;get;}
        Public String    AWBLabelURL     {set;get;}
        Public String    AWBLabel     {set;get;}
        Public String    ShipperContactName     {set;get;}
        Public String    ShipperCompanyName     {set;get;}
        Public String    ShipperCity     {set;get;}
        Public String    ShipperCountry    {set;get;}
        Public String    ReceiverContactName     {set;get;}
        Public String    ReceiverCompanyName     {set;get;}
        Public String    ReceiverCity     {set;get;}
        Public String    ReceiverCountry     {set;get;}
        Public String    ProductGroup     {set;get;}
        Public String    PaymentType    {set;get;}
        Public String    CODAmount     {set;get;}
        Public String    CODCurrency     {set;get;}
        Public String    ReferenceNo     {set;get;}
        Public String   AWBNumber{set;get;}
       Public serviceResult    serviceResult     {set;get;}

    }
         Public class serviceResult{
        Public String    success {set;get;}
        Public String    ErrorMsg {set;get;}
        }

    public static String createBooking(String requestString) {
        String awbNumber=null;
        try{
        HttpRequest req = New HttpRequest();
        req.setHeader('Content-Type', 'application/json');
        // move API to SETTINGS
        String  endpointUrl=gU.csStr('Courier_ENDPOINT');  /*'https://osbtest.epg.gov.ae/ebs/genericapi/booking/rest/CreateBooking';*/
        req.setHeader('Cache-Control', 'no-cache');
        req.setHeader('AccountNo', gU.csStr('Courier_AccNo'));
        req.setHeader('Password', gU.csStr('Courier_Pwd'));
        req.setTimeout(110000);
        req.setMethod('POST');
        req.setEndpoint('callout:EmpostcourierWs_API');
        //req.setBody('{"BookingRequest":{"SenderContactName":"Mr. John", "SenderCompanyName":null, "SenderAddress":"Some Test Address", "SenderCity":1, "SenderContactMobile":"512354123", "SenderContactPhone":"1234123", "SenderEmail":"sendersemail@gmail.com", "SenderZipCode":"00000", "SenderState":"Dubai", "SenderCountry":971, "ReceiverContactName":"Mr. Sam", "ReceiverCompanyName":null, "ReceiverAddress":"Some Test ReceiverAddress", "ReceiverCity":1, "ReceiverContactMobile":"14222212", "ReceiverContactPhone":"443124", "ReceiverEmail":"sasdf@asdf.com", "ReceiverZipCode":"00000", "ReceiverState":"Dubai", "ReceiverCountry":971, "ReferenceNo":"Ref - 012", "ReferenceNo1":null, "ReferenceNo2":null, "ReferenceNo3":null, "ContentTypeCode":"NonDocument", "NatureType":11, "Service":"Domestic", "ShipmentType":"Express", "DeleiveryType":"Door to Door", "Registered":"No", "PaymentType":"Credit", "CODAmount":"0", "CODCurrency":null, "CommodityDescription":"Any good description", "Pieces":3, "Weight":500, "WeightUnit":"Grams", "Length":12, "Width":12, "Height":12, "DimensionUnit":"Centimetre", "ItemValue":"124", "ValueCurrency":"AED", "ProductCode":null, "DeliveryInstructionsID":null, "RequestSource":null, "SendMailToSender":"No", "SendMailToReceiver":"No", "PreferredPickupDate":"22-Feb-2022", "PreferredPickupTimeFrom":"15:00", "PreferredPickupTimeTo":"18:00", "Is_Return_Service":"No", "PrintType":"AWBOnly", "Latitude":"40.689263", "Longitude":"74.044505", "TransactionSource":null, "AWBType":"EAWB", "RequestType":"Booking", "Remarks":null, "SpecialNotes":"Something to be printed", "SenderRegionId":null, "ReceiverRegionId":null, "AWBNumber":null}}');
        req.setBody(requestString);
        Http http = new Http();
        system.debug('Grant type header set');
        HTTPResponse res = http.send(req);
        system.debug('CB Res:'+res.getBody());

        ResponseCr bresp=(ResponseCr)JSON.deserialize(res.getBody(), ResponseCr.class);
        awbNumber=bresp.BookingResponse.AWBNumber;
        System.debug(bresp.BookingResponse.AWBNumber);
        }catch (Exception e) {system.debug('ex:'+e.getStackTraceString());}
        return awbNumber;
    }

    /*public  static void createBooking() {
    String rid='a0E6D000002fnDUUAY';
    List<g_Req__c> req=[select con__r.middlename, CreatedBy.email, srvc__r.sdg__r.ptype__c,
        srvc__r.stg__r.itmq__c, xoca__c, ias__c, xengt__c, xeng__c, xneng__c, xvown__c, xtr2__c,
        xltr_others__c, print__c, xln__c, xcst__c, xvbr__c, xvch__c, xvn__c, xwdt__c, xbdt__c,
        xvtyp__c, xbtnm__c, xltr__c, xlt__c, xla2__c, xla2d__c, xltp__c, xnld__c, xloc__c,
        xccn__c, srvc__r.stg__r.json__c, xcmonar__c, xcfanar__c, xengp__c, xai__c, xsi__c,
        srvc__r.xoi__c, srvc__r.addonsrv__c, srvc__r.milestone_stage__c, mtc__c, xcjb__r.jtm__c,
        con__r.name, con__r.job_title_formula__c, con__r.bp__c, con__r.ped__c, con__r.personal_photo__c,
        con__c, xard__c, con__r.spon__r.xpmi__c, con__r.spon__r.idtxt__c, con__r.spon__r.name,
        con__r.spon__r.xpno__c, con__r.spon__r.intp__c, con__r.spon__r.birthdate, spr__r.idtxt__c,
        spr__r.xpno__c, con__r.e__c, spr__r.xpmi__c, spr__r.intp__c, spr__r.birthdate, i_sta__c,
        xtpa__c, id, name, sta__c, at__c, ap__c, aop__c, xdtcls__c, dsc__c, dsc__r.prct__c,
        xfpc__c, spch__c, rmob__c, xawb__c, xaloc__c, xbrnd__c, xbn__c, nt__c, srvc__r.uid__c,
        conrol__c , xadh__c, xpgs__c, inschk__c, xintp__c, con__r.rol__c, con__r.firstname,
        con__r.lastname, con__r.emrt__c, con__r.p__c, con__r.email, con__r.mobilephone, con__r.salutation,
        con__r.ms__c, con__r.nc__c, con__r.eidid__c, con__r.pobx__c, con__r.mbs__c, con__r.ma__c,
        con__r.mta__c, con__r.moa__c, con__r.birthdate, con__r.rpui__c, srvc__c, srvc__r.name,
        srvc__r.lbl__c, srvc__r.dsc__c, srvc__r.prk__c, srvc__r.acctp__c, srvc__r.ckgsnc__c,
        srvc__r.snc__c, srvc__r.stg__r.pg__c, srvc__r.stg__r.apx__c, srvc__r.stg__r.reqq__c,
        acc__c, acc__r.name, acc__r.lcedt__c , acc__r.mtc__c, acc__r.type, acc__r.prk__c,
        acc__r.lcsnc__c, acc__r.lcsncnt__c, acc__r.psasnc__c, acc__r.psasncnt__c, acc__r.ecsnc__c,
        acc__r.ecsncnt__c, acc__r.cosnc__c, acc__r.cosncnt__c, acc__r.bgsnc__c, acc__r.bgsncnt__c,
        acc__r.snc__c, acc__r.info__c, acc__r.vestd__c, acc__r.vbtemp__c, acc__r.sncnt__c,
        lastmodifieddate, lastmodifiedbyid, createddate, createdbyid, createdby.name, item_count__c,
        xeidav__c, xcma__c, xcacctp__c, xcha__c, xcarea__c, xcmbs__c, xcbd__c, xccty__c,
        xcbc__c, xcnc__c, xceidid__c, xceidedt__c, xceididt__c, xceml__c, xcemrt__c, xcfan__c,
        xcfs__c, xcfn__c, xcfnar__c, xchph__c, xcln__c, xclnar__c, xcms__c, xcmn__c, xcmnar__c,
        xcmob__c, xcmon__c, xcof__c, xcot__c, xcjb__c, xcmoa__c, xcp__c, xcped__c, xcpid__c,
        xcpic__c, xcpip__c, xcbp__c, xcpobx__c, xcpobxarea__c, xcnp__c, xcql__c, xcrlg__c,
        xcslt__c, xclng__c, xcstrt__c, xcmta__c, xdedc__c, xdedln__c, xosa__c, xphid__c,
        xcs__c, xcn__c, zone__c, full_name__c, amsgs__c, action__c, xspn__c, xinsv__c, xcpobar__c,
        con__r.eid__c, con__r.eed__c, con__r.rp__c, con__r.rpid__c, con__r.rped__c, con__r.eididt__c,
        con__r.eidedt__c, con__r.idtxt__c, con__r.ididt__c, con__r.idedt__c, xcpipoar__c,
        srvc__r.pstg__c, srvc__r.kstp__c, xcddocs__c, xmloc__c, srvc__r.category__c, xcqc__c,
        xcdd__c, xcqemrt__c, aup__c, xcamdt__c, slan__c , srvc__r.sdg__r.skpsd__c , gender__c,
        expcnt__c, noexp__c, aupv__c, expflg__c , nofnm__c, spnm__c, afn__c, xspnar__c, ntk__c,
        ntkar__c , acc__r.Legal_Framework__c , piFlg__c from g_req__c where id=: rid];
    EmpostBookingUtil eutil= new EmpostBookingUtil();
    String bjson=eutil.createBookingJson(req[0], 'Delivery');

    createBooking(bjson);

    }*/

}