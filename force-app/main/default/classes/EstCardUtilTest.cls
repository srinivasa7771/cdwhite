@isTest(SeeAllData=false)
public class EstCardUtilTest {
     public static String dummyResp='';
     @testSetup
    static void setup() {
        testData.init();
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
        Contact c = new Contact(Id=conLst[0].Id, mbs__c=500000, eidid__c='784198774283257', eidedt__c=system.today().addyears(3)); update c;
        List<g_srvc_settings__c> srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];

        Contact emp=testData.conCrt(conLst[0], accLst[0].Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c r=testData.reqCrt(accLst[0].Id, srvcLst[0].Id, emp.Id, 'Open', srvcsettings[0].reqq__c);
        String selectedActs = '[{"name":"Environment", "segId":"a08D000000Zb70DIAR", "allowed":"5", "price":"15000.00", "SegActivities":[{"name":"Research &amp; Development", "actId":"a12D0000001YygKIAS", "price":"15000.00", "docs":[]}]}, {"name":"Specialty Supplies", "segId":"a08D000000Zb6zZIAR", "allowed":"5", "price":"15000.00", "SegActivities":[{"name":"Research &amp; Development", "actId":"a12D0000001Yyd1IAC", "price":"15000.00", "docs":[]}]}]';
        r.xadtx2__c = selectedActs; r.xdccaRq__c='RQ-112233'; update r;

        List<g_srvcitm__c> srvitm = [select id from g_srvcitm__c where srvc__r.Name='Srvc' LIMIT 1];
        List<g_srvcitm_Status__c> stng = [select id from g_srvcitm_Status__c where itm__r.srvc__r.Name='Srvc' LIMIT 1];
        g_reqitem__c rqitem = new g_reqitem__c(Name='License_Registration_Request', RQ__c=r.Id, itm__c=srvitm[0].Id, sta__c=stng[0].Id);
        insert rqitem;

        Courier_Status__c cStat = new Courier_Status__c(srvitm__c=srvitm[0].Id, curSTA__c=stng[0].Id, itmSTA__c=stng[0].Id, Courier_Status__c='Courier Initiated');
        insert cStat;

        g_reqDoc__c rdoc= new g_reqDoc__c(Name='Signed AOA', RQ__c=r.Id, ats__c=1);
        insert rdoc;
        g_reqitemDoc__c rrdocitm = new g_reqitemDoc__c(name='Application Form', lbl__c='Application Form', reqItm__c=rqitem.Id, reqDoc__c=rdoc.Id, mnAts__c=1, Req__c=true, reqAts__c=true);
        insert rrdocitm;
        Attachment att = new Attachment(name='Application Form', parentId=rdoc.Id, body= Blob.valueOf('TEST'));
        insert att;

    }

     static testmethod void testEstCardUtil() {
          Test.startTest();
        Test.setMock(HttpCalloutMock.class, new mockGetResp());
         dummyResp = '{"StatusCode":200, "Status":"Success", "Message":"", "Data":{"resolution":null, "pdfParams":{"OperatingNameEN":"Shweta Kapur", "OperatingNameAR":"شويتا كابور", "ManagerEN":"Shweta Kapur", "ManagerAR":"شويتا  كابور", "LicenseZoneIndex":0, "LicenseSectorEN":null, "LicenseNumberEN":"99473", "LicenseeEN":"Shweta Kapur", "LicenseeAR":"شويتا كابور", "LicensedActivities":{"LicenseInfoItem_type_info":["LicenseInfoItem", "http://tempuri.org/", null, "0", "-1", "true"], "LicenseInfoItem":[{"pobox_type_info":["pobox", "http://tempuri.org/", null, "0", "1", "false"], "pobox":null, "plot_type_info":["plot", "http://tempuri.org/", null, "0", "1", "false"], "plot":null, "ParentItemNameEN_type_info":["ParentItemNameEN", "http://tempuri.org/", null, "0", "1", "false"], "ParentItemNameEN":"", "ParentItemNameAR_type_info":["ParentItemNameAR", "http://tempuri.org/", null, "0", "1", "false"], "ParentItemNameAR":"", "Param4_type_info":["Param4", "http://tempuri.org/", null, "0", "1", "false"], "Param4":"", "Param3_type_info":["Param3", "http://tempuri.org/", null, "0", "1", "false"], "Param3":"", "Param2_type_info":["Param2", "http://tempuri.org/", null, "0", "1", "false"], "Param2":"", "Param1_type_info":["Param1", "http://tempuri.org/", null, "0", "1", "false"], "Param1":"", "officeNO_type_info":["officeNO", "http://tempuri.org/", null, "0", "1", "false"], "officeNO":null, "ItemNameEN_type_info":["ItemNameEN", "http://tempuri.org/", null, "0", "1", "false"], "ItemNameEN":"Fashion Designer", "ItemNameAR_type_info":["ItemNameAR", "http://tempuri.org/", null, "0", "1", "false"], "ItemNameAR":"", "isRegisterAddress_type_info":["isRegisterAddress", "http://tempuri.org/", null, "1", "1", "false"], "isRegisterAddress":false, "HasParentItem_type_info":["HasParentItem", "http://tempuri.org/", null, "1", "1", "false"], "HasParentItem":true, "floorNo_type_info":["floorNo", "http://tempuri.org/", null, "0", "1", "false"], "floorNo":null, "businessUnit_type_info":["businessUnit", "http://tempuri.org/", null, "0", "1", "false"], "businessUnit":null, "building_type_info":["building", "http://tempuri.org/", null, "0", "1", "false"], "building":null, "apobox_type_info":["apobox", "http://tempuri.org/", null, "0", "1", "false"], "apobox":null, "aplot_type_info":["aplot", "http://tempuri.org/", null, "0", "1", "false"], "aplot":null, "apex_schema_type_info":["http://tempuri.org/", "true", "false"], "aOfficeNo_type_info":["aOfficeNo", "http://tempuri.org/", null, "0", "1", "false"], "aOfficeNo":null, "afloorNo_type_info":["afloorNo", "http://tempuri.org/", null, "0", "1", "false"], "afloorNo":null, "abusinessUnit_type_info":["abusinessUnit", "http://tempuri.org/", null, "0", "1", "false"], "abusinessUnit":null, "abuilding_type_info":["abuilding", "http://tempuri.org/", null, "0", "1", "false"], "abuilding":null}], "field_order_type_info":["LicenseInfoItem"], "apex_schema_type_info":["http://tempuri.org/", "true", "false"]}, "LegalStatusEN":"Freelancer", "LegalStatusAR":"ممارس منفرد", "LayoutIndex":1, "isFooter":false, "FirstIssueDate":"2021-12-21T00:00:00.000Z", "ExpiryDate":"2022-12-20T00:00:00.000Z", "CurrentIssueDate":"2021-12-21T00:00:00.000Z", "BusinessUnitEN":"Dubai Design District", "BusinessUnitAR":"حي دبي للتصميم", "BottomDisclaimerEN":"", "BottomDisclaimerAR":"", "Addresses":{"LicenseInfoItem_type_info":["LicenseInfoItem", "http://tempuri.org/", null, "0", "-1", "true"], "LicenseInfoItem":[{"pobox_type_info":["pobox", "http://tempuri.org/", null, "0", "1", "false"], "pobox":null, "plot_type_info":["plot", "http://tempuri.org/", null, "0", "1", "false"], "plot":null, "ParentItemNameEN_type_info":["ParentItemNameEN", "http://tempuri.org/", null, "0", "1", "false"], "ParentItemNameEN":null, "ParentItemNameAR_type_info":["ParentItemNameAR", "http://tempuri.org/", null, "0", "1", "false"], "ParentItemNameAR":null, "Param4_type_info":["Param4", "http://tempuri.org/", null, "0", "1", "false"], "Param4":null, "Param3_type_info":["Param3", "http://tempuri.org/", null, "0", "1", "false"], "Param3":null, "Param2_type_info":["Param2", "http://tempuri.org/", null, "0", "1", "false"], "Param2":null, "Param1_type_info":["Param1", "http://tempuri.org/", null, "0", "1", "false"], "Param1":null, "officeNO_type_info":["officeNO", "http://tempuri.org/", null, "0", "1", "false"], "officeNO":null, "ItemNameEN_type_info":["ItemNameEN", "http://tempuri.org/", null, "0", "1", "false"], "ItemNameEN":null, "ItemNameAR_type_info":["ItemNameAR", "http://tempuri.org/", null, "0", "1", "false"], "ItemNameAR":null, "isRegisterAddress_type_info":["isRegisterAddress", "http://tempuri.org/", null, "1", "1", "false"], "isRegisterAddress":true, "HasParentItem_type_info":["HasParentItem", "http://tempuri.org/", null, "1", "1", "false"], "HasParentItem":false, "floorNo_type_info":["floorNo", "http://tempuri.org/", null, "0", "1", "false"], "floorNo":"3", "businessUnit_type_info":["businessUnit", "http://tempuri.org/", null, "0", "1", "false"], "businessUnit":"Dubai Design District", "building_type_info":["building", "http://tempuri.org/", null, "0", "1", "false"], "building":"3", "apobox_type_info":["apobox", "http://tempuri.org/", null, "0", "1", "false"], "apobox":null, "aplot_type_info":["aplot", "http://tempuri.org/", null, "0", "1", "false"], "aplot":null, "apex_schema_type_info":["http://tempuri.org/", "true", "false"], "aOfficeNo_type_info":["aOfficeNo", "http://tempuri.org/", null, "0", "1", "false"], "aOfficeNo":null, "afloorNo_type_info":["afloorNo", "http://tempuri.org/", null, "0", "1", "false"], "afloorNo":"3", "abusinessUnit_type_info":["abusinessUnit", "http://tempuri.org/", null, "0", "1", "false"], "abusinessUnit":"حي دبي للتصميم", "abuilding_type_info":["abuilding", "http://tempuri.org/", null, "0", "1", "false"], "abuilding":"3"}], "field_order_type_info":["LicenseInfoItem"], "apex_schema_type_info":["http://tempuri.org/", "true", "false"]}, "ActivitiesEN":null, "ActivitiesAR":null}, "documentName":"Commercial License", "body":null, "aoaParams":null}}';
         g_reqitem__c ri = [select id, RQ__r.xcmob__c, RQ__r.xceml__c, RQ__r.Acc__r.lc__c, RQ__r.Acc__r.Legal_Framework__c from g_reqitem__c limit 1];
         EstCardUtil.reqBody(ri, 'New');
         Test.stopTest();
     }
    public class mockGetResp implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(dummyResp);
            res.setStatusCode(200);

            return res;
        }
    }
}