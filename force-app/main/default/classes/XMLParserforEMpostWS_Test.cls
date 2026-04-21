@isTest
private class XMLParserforEMpostWS_Test {

    private static testMethod void XMLParsertest() {
        try{
            XMLParserforEmpostWebservice.XMLtoApex obj=new XMLParserforEmpostWebservice.XMLtoApex();
            obj.Name=obj.Name;
            obj.Count=obj.Count;
            obj.AIRWAYBILL=obj.AIRWAYBILL;
            obj.StatusReason=obj.StatusReason;
            obj.ContentTypeID=obj.ContentTypeID;
            obj.ContentTypeName=obj.ContentTypeName;
            obj.Status=obj.Status;
            obj.Cancelled=obj.Cancelled;
            obj.CourierName=obj.CourierName;

            XMLParserforEmpostWebservice cs=new XMLParserforEmpostWebservice();
            cs.XMLParser('<xml version="1.0" encoding="UTF-8"><RESPONSE><STATUS>FAILED</STATUS><AIRWAYBILL>0</AIRWAYBILL><StatusReason>ok</StatusReason></RESPONSE></xml>');
        }catch (Exception e) {}
    }

    @IsTest
    private static  void CreateBookingTest() {
        try{
            XMLParserforEmpostWebservice cs=new XMLParserforEmpostWebservice();
            /**cs.CreateBooking(null, null);**/ }catch (Exception e) {}
    }
    @IsTest
    private static  void errorLogTEst() { try{
        XMLParserforEmpostWebservice cs=new XMLParserforEmpostWebservice();
        cs.errorLog(null, null, null, null); }catch (Exception e) {}
    }
    @IsTest
    private static  void GetBookingTypes() { try{
        XMLParserforEmpostWebservice cs=new XMLParserforEmpostWebservice();
        //cs.GetBookingTypes(null, null);
    }catch (Exception e) {}
    }

    @IsTest
    private static  void GetContentTypesTest() { try{
        XMLParserforEmpostWebservice cs=new XMLParserforEmpostWebservice();
        cs.GetContentTypes(null, null); }catch (Exception e) {}
    }
    @IsTest
    private static  void GetUpdatedStatusByAWBTest() { try{
        XMLParserforEmpostWebservice cs=new XMLParserforEmpostWebservice();

        XMLParserforEmpostWebservice.GetUpdatedStatusByAWB(new List<String>{'7000', '12345678'}); }catch (Exception e) {}
    }
    @IsTest
    private static  void CancelBookingTest() { try{
        XMLParserforEmpostWebservice cs=new XMLParserforEmpostWebservice();

    //    XMLParserforEmpostWebservice.CancelBooking( new List<String>{'7000', '12345678'});
    }catch (Exception e) {}
    }
    @IsTest
    private static  void GetStatusSummaryTest() { try{
        XMLParserforEmpostWebservice cs=new XMLParserforEmpostWebservice();

        XMLParserforEmpostWebservice.GetStatusSummary('18-Apr-2016', '18-Apr-2016');}catch (Exception e) {}
    }
     @IsTest
    private static  void BuildXMLforCreateBookingTest() { /*try{*/

        testData.init();
        list < gStg__c > stgs = new list < gStg__c > ();
        stgs.add(new gStg__c(Name = 'Courier_ENDPOINT', Checkbox_Value__c = true, Text_Value__c = 'https://osbtest.epg.gov.ae/', Number_Value__c = 0, Currency_Value__c = 0));
        stgs.add(new gStg__c(Name = 'Courier_AccNo', Checkbox_Value__c = true, Text_Value__c = 'C', Number_Value__c = 0, Currency_Value__c = 0));
        stgs.add(new gStg__c(Name = 'Courier_Pwd', Checkbox_Value__c = true, Text_Value__c ='CD', Number_Value__c = 0, Currency_Value__c = 0));
        insert stgs;
        Account a=testData.accCrt(false);
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);

        g_srvc_definition__c sd= new g_srvc_definition__c(Name='test', ptype__c='Normal:10 Days;Express:3 Days;',
            cv__c='NewVisa', sd__c='Apply for new employment visa. Based on the information you provide, you will be either taken to the ‘New Visa’ or ‘Visa Transfer’ process. <br/><br/><strong>The new visa includes:</strong><ul class="ul-style"><li> Entry Permit</li><li> Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li><li> In-country status change (if required)</li></ul><strong>Visa transfer includes:</strong><br/><ul class="ul-style"><li>Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li></u>',
            docslbl__c='Passport - first page;Passport - last page (if applicable);Recent passport size photo (white background);Attested educational certificate (occupation dependent);Emirates ID - front (if available);Emirates ID - back (if available);Existing residence visa page (for transfers only);NOC from the releasing sponsor (for transfers only);Final settlement (for transfers within free zone only);Employment contract (conditional);Valid nationality identity card (for Pakistan, Afghanistan & Iraqi nationals - conditional);Medical Certificate from Origin Country Sri Lankan, Indonesian and Ethiopian nationalities (conditional) ;Good Contact Certificate for Kenyan nationalities (conditional);Health insurance card or certificate or opt for ADNIC Insurance during the application (for transfers only)');
        insert sd;
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
        Contact c = new Contact(Id=conLst[0].Id, mbs__c=5000, eidid__c='784198774283257', eidedt__c=system.today().addyears(3)); update c;
        List<g_srvc_settings__c> srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];

        Contact emp=testData.conCrt(conLst[0], accLst[0].Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c r=testData.reqCrt(accLst[0].Id, srvcLst[0].Id, emp.Id, 'Open', srvcsettings[0].reqq__c);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new mockCourierBk());
        XMLParserforEmpostWebservice cs=new XMLParserforEmpostWebservice();
        List<g_req__c> rq=[Select xcnc__c, Id, Name, STA__c, AT__c, AP__c, AOP__c, dsc__c,
            dsc__r.prct__c, spCh__c, rmob__c, xaloc__c, xbrnd__c, xbn__c, nt__c, xfpc__c, srvc__c,
            srvc__r.name, srvc__r.lbl__c, srvc__r.dsc__c, srvc__r.Prk__c, srvc__r.AccTp__c, srvc__r.ckgsnc__c,
            srvc__r.snc__c, srvc__r.stg__r.pg__c, srvc__r.stg__r.apx__c, srvc__r.stg__r.reqq__c,
            srvc__r.payMd__c, Acc__r.Name, Acc__r.lc__c, Acc__c, Acc__r.Type, Acc__r.Prk__c,
            Acc__r.lcsnc__c, Acc__r.lcsncnt__c, Acc__r.psasnc__c, Acc__r.psasncnt__c, Acc__r.ecsnc__c,
            Acc__r.ecsncnt__c, Acc__r.cosnc__c, Acc__r.cosncnt__c, Acc__r.bgsnc__c, Acc__r.bg__c,
            Acc__r.bgsncnt__c, Acc__r.snc__c, Acc__r.info__c, Acc__r.vestd__c, Acc__r.vbtemp__c,
            LastModifiedDate, LastModifiedById, CreatedDate, CreatedById, Acc__r.adb__c, Acc__r.bgb__c,
            Acc__r.bgnr__c, xtpa__c, srvc__r.uid__c , Zone__c, Full_Name__c, CreatedBy.Name From g_Req__c limit 1];
        cs.CreateBooking(rq[0], 'DELIVERY');
         String dummyResp = '{"BookingResponse":{"Status":"Shipment Delivered", "AWBNumber":"10000032435", "Description":""}}';
        EmpostcourierWs.BookingResponse res = new EmpostcourierWs.BookingResponse();
        res.Status = '';res.Description = '';res.AWBLabelURL = '';res.AWBLabel = '';res.ShipperContactName = '';res.ShipperCompanyName = '';
        res.ShipperCity = '';res.ShipperCountry = '';res.ReceiverContactName = '';res.ReceiverCompanyName = '';res.ReceiverCity = '';res.ReceiverCountry = '';
        res.ProductGroup = '';res.PaymentType = '';res.CODAmount = '';res.CODCurrency = '';
        Test.stopTest();
       /*}catch (Exception e) {}*/
    }
     @IsTest
    private static  void GetCourierInfoTest() { try{
        XMLParserforEmpostWebservice cs=new XMLParserforEmpostWebservice();

        XMLParserforEmpostWebservice.GetCourierInfo('DHCC', '45');}Catch(Exception e) {}
    }

     @IsTest
    private static  void courierBookingTest() { try{
         testData.init();
        list < gStg__c > stgs = new list < gStg__c > ();
        stgs.add(new gStg__c(Name = 'Courier_ENDPOINT', Checkbox_Value__c = true, Text_Value__c = 'https://osbtest.epg.gov.ae/', Number_Value__c = 0, Currency_Value__c = 0));
        stgs.add(new gStg__c(Name = 'Courier_AccNo', Checkbox_Value__c = true, Text_Value__c = 'C', Number_Value__c = 0, Currency_Value__c = 0));
        stgs.add(new gStg__c(Name = 'Courier_Pwd', Checkbox_Value__c = true, Text_Value__c ='CD', Number_Value__c = 0, Currency_Value__c = 0));
        insert stgs;
        Account a=testData.accCrt(false);
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);

        g_srvc_definition__c sd= new g_srvc_definition__c(Name='test', ptype__c='Normal:10 Days;Express:3 Days;',
            cv__c='NewVisa', sd__c='Apply for new employment visa. Based on the information you provide, you will be either taken to the ‘New Visa’ or ‘Visa Transfer’ process. <br/><br/><strong>The new visa includes:</strong><ul class="ul-style"><li> Entry Permit</li><li> Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li><li> In-country status change (if required)</li></ul><strong>Visa transfer includes:</strong><br/><ul class="ul-style"><li>Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li></u>',
            docslbl__c='Passport - first page;Passport - last page (if applicable);Recent passport size photo (white background);Attested educational certificate (occupation dependent);Emirates ID - front (if available);Emirates ID - back (if available);Existing residence visa page (for transfers only);NOC from the releasing sponsor (for transfers only);Final settlement (for transfers within free zone only);Employment contract (conditional);Valid nationality identity card (for Pakistan, Afghanistan & Iraqi nationals - conditional);Medical Certificate from Origin Country Sri Lankan, Indonesian and Ethiopian nationalities (conditional) ;Good Contact Certificate for Kenyan nationalities (conditional);Health insurance card or certificate or opt for ADNIC Insurance during the application (for transfers only)');
        insert sd;
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
        Contact c = new Contact(Id=conLst[0].Id, mbs__c=5000, eidid__c='784198774283257', eidedt__c=system.today().addyears(3)); update c;
        List<g_srvc_settings__c> srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];

        Contact emp=testData.conCrt(conLst[0], accLst[0].Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c rqNew=testData.reqCrt(accLst[0].Id, srvcLst[0].Id, emp.Id, 'Open', srvcsettings[0].reqq__c);
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, new mockCourierBk());
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
             ntkar__c , acc__r.Legal_Framework__c , piFlg__c from g_req__c where id=:rqNew.id];

        XMLParserforEmpostWebservice cs=new XMLParserforEmpostWebservice();
        g_reqitem__c ri = new g_reqitem__c();
        ri.xcub__c = 'Collection';
          cs.ctype='Collection';
          cs.courierBooking(ri, req[0], false, 'At Office');
        Test.stopTest();
    }Catch(Exception e) {}
    }

   /** @IsTest
    private static  void skipTestcaseTest() { try{  XMLParserforEmpostWebservice cs=new XMLParserforEmpostWebservice();

                   String x= cs.skipTestcase(2);
                  system.assertEquals('3', x);
    }Catch(Exception e) {}
    }

    @IsTest
    private static  void TestCaseTest() { try{  XMLParserforEmpostWebservice cs=new XMLParserforEmpostWebservice();

                   String x= cs.TestCase(2);
                  system.assertEquals('4', x);
    }Catch(Exception e) {}
    }

@IsTest
    private static  void caseTestTest() { try{  XMLParserforEmpostWebservice cs=new XMLParserforEmpostWebservice();

                   String x= cs.caseTest(2);
                  system.assertEquals('5', x);
    }Catch(Exception e) {}
    }

@IsTest
    private static  void xmlCasetstTest() { try{  XMLParserforEmpostWebservice cs=new XMLParserforEmpostWebservice();

                   String x= cs.xmlCasetst(2);
                  system.assertEquals('6', x);
    }Catch(Exception e) {}
    }
    **/

    @IsTest
    private static  void jsonToListTest() { try{

        XMLParserforEmpostWebservice cs=new XMLParserforEmpostWebservice();
        cs.jsonToList('{"Summary":[{"status":"Cancelled", "count":"1"}, {"status":"Delivered", "count":"766"}, {"status":"Cancelled", "count":"26"}, {"status":"At Hub", "count":"108"}]}');
    }Catch(Exception e) {}
    }
    public class mockCourierBk implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String dummyResp = '{"BookingResponse":{"Status":"Shipment Delivered", "AWBNumber":"10000032435", "Description":""}}';
            res.setBody(dummyResp);
            res.setStatusCode(200);
            return res;
        }
    }
}