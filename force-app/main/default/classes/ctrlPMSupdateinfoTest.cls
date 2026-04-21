@istest
public class ctrlPMSupdateinfoTest {

    @testSetup
    static void setup() {
        testData.init();
        Account a=testData.accCrt(false);
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        gStg__c crtstng = testData.createSetting('test', 'testvalue');

        Contact emp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        g_Req__c req=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
        req.xdccaRq__c = 'test';
        update req;
    }

    static testmethod void upsertContractInfoTest() {

        List<ws_call__c> wsList = new List<ws_call__c>();
        list<g_reqitem__c> rqItm =[Select id, xdcca_refId__c, rq__c, RQ__r.Id, itm__c, RQ__r.Acc__c, itm__r.cd__c, xleatp__c, rq__r.Service__c from g_reqitem__c  limit 1];
        List<g_srvcitm__c> lstSrvItem = [select id, cd__c from g_srvcitm__c  limit 1];

        g_srvcitm__c objSrvItem = new g_srvcitm__c(Id = lstSrvItem[0].id,  cd__c= 'la5');
        update objSrvItem;

        rqItm[0].xleatp__c = 'PMS Lease';
        rqItm[0].xlesd__c = Date.today()-1;
        rqItm[0].xleed__c = Date.today()+30;
        rqItm[0].xbldg__c = 'Dubai';
        rqItm[0].xbldgarb__c  = 'Holding';
        rqItm[0].xpreno__c = '010';
        update rqItm;
        ws_call__c ws1 = new ws_call__c();
        ws1.intsts__c= 'Ready for Integration';
        ws1.mtd_nm__c = 'updateCourSta' ;
        ws1.pmid__c ='' ;
        ws1.rq_itm__c=rqItm[0].id;
        ws1.rq_jsn__c='';
        ws1.ws_typ__c='';
        wsList.add(ws1);
        insert wsList;
        List<g_tran__c> tranList = new List<g_tran__c>();
        g_tran__c tr = new g_tran__c();
        tr.RQ__c = rqItm[0].rq__c;
        tr.TP__c = 'Payment';
        tr.sta__c = 'Completed';
        tr.md__c = 'Cash';
        tr.Acc__c = rqItm[0].RQ__r.Acc__c;
        tranList.add(tr);
        insert tranList;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockInsloaddccaLoc());
        ctrlPMSupdateinfo objPMSUpdate = new ctrlPMSupdateinfo();
        ctrlPMSupdateinfo.upsertContractInfo(new list<Id> {wsList[0].Id});
        Test.stopTest();

    }

    static testmethod void upsertContractInfoTest1() {
        List<ws_call__c> wsList = new List<ws_call__c>();
        list<g_reqitem__c> rqItm =[Select id, xdcca_refId__c, rq__c, RQ__r.Id, itm__c, RQ__r.Acc__c, itm__r.cd__c, xleatp__c from g_reqitem__c limit 1];

        rqItm[0].xleatp__c = 'PMS Lease';
        rqItm[0].xlesd__c = Date.today()-1;
        rqItm[0].xleed__c = Date.today()+30;
        rqItm[0].xbldg__c = 'Dubai';
        rqItm[0].xbldgarb__c  = 'Holding';
        rqItm[0].xpreno__c = 'A11';
        update rqItm;
        ws_call__c ws1 = new ws_call__c();
        ws1.intsts__c= 'Ready for Integration';
        ws1.mtd_nm__c = 'updateCourSta' ;
        ws1.pmid__c ='' ;
        ws1.rq_itm__c=rqItm[0].id;
        ws1.rq_jsn__c='';
        ws1.ws_typ__c='';
        wsList.add(ws1);
        insert wsList;
        List<g_tran__c> tranList = new List<g_tran__c>();
        g_tran__c tr = new g_tran__c();
        tr.RQ__c = rqItm[0].rq__c;
        tr.TP__c = 'Payment';
        tr.sta__c = 'Completed';
        tr.md__c = 'Cash';
        tr.Acc__c = rqItm[0].RQ__r.Acc__c;
        tranList.add(tr);
        insert tranList;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockInsloaddccaLoc());
        ctrlPMSupdateinfo objPMSUpdate = new ctrlPMSupdateinfo();
        ctrlPMSupdateinfo.upsertContractInfo(new list<Id> {wsList[0].Id});
        Test.stopTest();
    }

    public class MockInsloaddccaLoc implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"MethodName":"getLocations", "locationList":[{"totalArea":"662", "subleaseCompany":null, "SubCategory":"Office", "Status":"Active", "showOnLicen":false, "regOffFlag":null, "Recordtype":"Tecom CRM Integration", "prodList":[{"UnitNumber":"305", "regOff":false, "ProductName":"DIC-Bldg 05-305", "LineItemName":"a0sA0000000UgkOIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"206", "regOff":false, "ProductName":"DIC-Bldg 05-206", "LineItemName":"a0sA0000000UgkCIAS", "floor":"2", "buildingName":"5"}, {"UnitNumber":"204", "regOff":false, "ProductName":"DIC-Bldg 05-204", "LineItemName":"a0sA0000000UgkAIAS", "floor":"2", "buildingName":"5"}, {"UnitNumber":"202", "regOff":false, "ProductName":"DIC-Bldg 05-202", "LineItemName":"a0sA0000000Ugk8IAC", "floor":"2", "buildingName":"5"}, {"UnitNumber":"203", "regOff":false, "ProductName":"DIC-Bldg 05-203", "LineItemName":"a0sA0000000Ugk9IAC", "floor":"2", "buildingName":"5"}, {"UnitNumber":"201", "regOff":false, "ProductName":"DIC-Bldg 05-201", "LineItemName":"a0sA0000000Ugk7IAC", "floor":"2", "buildingName":"5"}, {"UnitNumber":"205", "regOff":false, "ProductName":"DIC-Bldg 05-205", "LineItemName":"a0sA0000000UgkBIAS", "floor":"2", "buildingName":"5"}, {"UnitNumber":"111", "regOff":false, "ProductName":"DIC-Bldg 05-111", "LineItemName":"a0sA0000000UgjtIAC", "floor":"1", "buildingName":"5"}, {"UnitNumber":"110", "regOff":false, "ProductName":"DIC-Bldg 05-110", "LineItemName":"a0sA0000000UgjsIAC", "floor":"1", "buildingName":"5"}, {"UnitNumber":"109", "regOff":false, "ProductName":"DIC-Bldg 05-109", "LineItemName":"a0sA0000000UgjrIAC", "floor":"1", "buildingName":"5"}, {"UnitNumber":"112", "regOff":false, "ProductName":"DIC-Bldg 05-112", "LineItemName":"a0sA0000000UgjuIAC", "floor":"1", "buildingName":"5"}, {"UnitNumber":"224", "regOff":false, "ProductName":"DIC-Bldg 05-224", "LineItemName":"a0sA0000000UgkJIAS", "floor":"2", "buildingName":"5"}, {"UnitNumber":"316", "regOff":false, "ProductName":"DIC-Bldg 05-316", "LineItemName":"a0sA0000000UgkZIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"317", "regOff":false, "ProductName":"DIC-Bldg 05-317", "LineItemName":"a0sA0000000UgkaIAC", "floor":"3", "buildingName":"5"}, {"UnitNumber":"313", "regOff":false, "ProductName":"DIC-Bldg 05-313", "LineItemName":"a0sA0000000UgkWIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"315", "regOff":false, "ProductName":"DIC-Bldg 05-315", "LineItemName":"a0sA0000000UgkYIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"223", "regOff":false, "ProductName":"DIC-Bldg 05-223", "LineItemName":"a0sA0000000UgkIIAS", "floor":"2", "buildingName":"5"}, {"UnitNumber":"309", "regOff":false, "ProductName":"DIC-Bldg 05-309", "LineItemName":"a0sA0000000UgkSIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"308", "regOff":false, "ProductName":"DIC-Bldg 05-308", "LineItemName":"a0sA0000000UgkRIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"322", "regOff":false, "ProductName":"DIC-Bldg 05-322", "LineItemName":"a0sA0000000UgkfIAC", "floor":"3", "buildingName":"5"}, {"UnitNumber":"220", "regOff":false, "ProductName":"DIC-Bldg 05-220", "LineItemName":"a0sA0000000UgkFIAS", "floor":"2", "buildingName":"5"}, {"UnitNumber":"314", "regOff":false, "ProductName":"DIC-Bldg 05-314", "LineItemName":"a0sA0000000UgkXIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"312", "regOff":false, "ProductName":"DIC-Bldg 05-312", "LineItemName":"a0sA0000000UgkVIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"307", "regOff":false, "ProductName":"DIC-Bldg 05-307", "LineItemName":"a0sA0000000UgkQIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"219", "regOff":false, "ProductName":"DIC-Bldg 05-219", "LineItemName":"a0sA0000000UgkEIAS", "floor":"2", "buildingName":"5"}, {"UnitNumber":"222", "regOff":false, "ProductName":"DIC-Bldg 05-222", "LineItemName":"a0sA0000000UgkHIAS", "floor":"2", "buildingName":"5"}, {"UnitNumber":"221", "regOff":true, "ProductName":"DIC-Bldg 05-221", "LineItemName":"a0sA0000000UgkGIAS", "floor":"2", "buildingName":"5"}, {"UnitNumber":"303", "regOff":false, "ProductName":"DIC-Bldg 05-303", "LineItemName":"a0sA0000000UgkMIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"310", "regOff":false, "ProductName":"DIC-Bldg 05-310", "LineItemName":"a0sA0000000UgkTIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"323", "regOff":false, "ProductName":"DIC-Bldg 05-323", "LineItemName":"a0sA0000000UgkgIAC", "floor":"3", "buildingName":"5"}, {"UnitNumber":"311", "regOff":false, "ProductName":"DIC-Bldg 05-311", "LineItemName":"a0sA0000000UgkUIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"302", "regOff":false, "ProductName":"DIC-Bldg 05-302", "LineItemName":"a0sA0000000UgkLIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"304", "regOff":false, "ProductName":"DIC-Bldg 05-304", "LineItemName":"a0sA0000000UgkNIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"301", "regOff":false, "ProductName":"DIC-Bldg 05-301", "LineItemName":"a0sA0000000UgkKIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"321", "regOff":false, "ProductName":"DIC-Bldg 05-321", "LineItemName":"a0sA0000000UgkeIAC", "floor":"3", "buildingName":"5"}, {"UnitNumber":"324", "regOff":false, "ProductName":"DIC-Bldg 05-324", "LineItemName":"a0sA0000000UgkhIAC", "floor":"3", "buildingName":"5"}, {"UnitNumber":"319", "regOff":false, "ProductName":"DIC-Bldg 05-319", "LineItemName":"a0sA0000000UgkcIAC", "floor":"3", "buildingName":"5"}, {"UnitNumber":"318", "regOff":false, "ProductName":"DIC-Bldg 05-318", "LineItemName":"a0sA0000000UgkbIAC", "floor":"3", "buildingName":"5"}, {"UnitNumber":"320", "regOff":false, "ProductName":"DIC-Bldg 05-320", "LineItemName":"a0sA0000000UgkdIAC", "floor":"3", "buildingName":"5"}, {"UnitNumber":"306", "regOff":false, "ProductName":"DIC-Bldg 05-306", "LineItemName":"a0sA0000000UgkPIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"305", "regOff":false, "ProductName":"DIC-Bldg 05-305", "LineItemName":"a0sA0000000UgkOIAS", "floor":"3", "buildingName":"5"}], "OfficeNo":"305", "masterLocationLicense":"", "LocationId":"a1i5D0000001fhGQAQ", "licenseType":"Commercial License", "LicenseNo":"19299", "IsSubLease":"NO", "IsMainAdd":false, "Floor":"3", "error":"", "ContractStatusReason":null, "ContractStartDate":"2016-09-15", "ContractEnddate":"2021-09-14", "Category":"Office", "BusinessPark":"Dubai Internet City", "BuildingName":"5", "ArabicOfficeNo":"305", "ArabicFloor":"3", "ArabicBusinessUnit":"مدينة دبي للإنترنت", "ArabicBuildingName":"5", "AgreementNo":"AG-117256"}, {"totalArea":"0", "subleaseCompany":null, "SubCategory":null, "Status":"Active", "showOnLicen":false, "regOffFlag":null, "Recordtype":"Tecom CRM Integration", "prodList":[{"UnitNumber":"401", "regOff":false, "ProductName":"Building 08-401", "LineItemName":"a03w000000Ekwt4AAB", "floor":"4", "buildingName":"089"}, {"UnitNumber":"410", "regOff":false, "ProductName":"Building 08-410", "LineItemName":"a03w000000EkwtBAAR", "floor":"4", "buildingName":"089"}, {"UnitNumber":"413", "regOff":false, "ProductName":"Building 08-413", "LineItemName":"a03w000000EkwtCAAR", "floor":"4", "buildingName":"089"}, {"UnitNumber":"414", "regOff":false, "ProductName":"Building 08-414", "LineItemName":"a03w000000EkwtDAAR", "floor":"4", "buildingName":"089"}, {"UnitNumber":"415", "regOff":false, "ProductName":"Building 08-415", "LineItemName":"a03w000000EkwtEAAR", "floor":"4", "buildingName":"089"}], "OfficeNo":"415", "masterLocationLicense":"", "LocationId":"a1i5D0000001TjAQAU", "licenseType":"Commercial License", "LicenseNo":"19299", "IsSubLease":"NO", "IsMainAdd":false, "Floor":"4", "error":"", "ContractStatusReason":null, "ContractStartDate":"2015-08-16", "ContractEnddate":"2020-11-13", "Category":"Office", "BusinessPark":"Dubai Design District", "BuildingName":"089", "ArabicOfficeNo":"415", "ArabicFloor":"4", "ArabicBusinessUnit":"حي دبي للتصميم", "ArabicBuildingName":"089", "AgreementNo":"AG-6849"}], "LicnseNo":"19299", "errorCode":"0", "error":"", "act":null}');
            res.setStatusCode(200);
            return res;
        }
    }

    @isTest static void calloutTest() {

        List<ws_call__c> wsList = new List<ws_call__c>();
        list<g_reqitem__c> rqItm =[Select id, xdcca_refId__c, RQ__r.Acc__r.lc__c , RQ__r.Acc__r.ORACLE_PARTY_ID__c,
            rq__c, RQ__r.Id, itm__c, itm__r.cd__c, xleatp__c, rq__r.Service__c from g_reqitem__c limit 1];
        List<g_srvcitm__c> lstSrvItem = [select id, cd__c from g_srvcitm__c  limit 1];

        g_srvcitm__c objSrvItem = new g_srvcitm__c(Id = lstSrvItem[0].id,  cd__c= 'la5');
        update objSrvItem;

        rqItm[0].xleatp__c = 'PMS Lease';
        rqItm[0].xlesd__c = Date.today()-1;
        rqItm[0].xleed__c = Date.today()+30;
        rqItm[0].xbldg__c = 'Dubai';
        rqItm[0].xbldgarb__c  = 'Holding';
        rqItm[0].xpreno__c = '010';
        update rqItm;
        ws_call__c ws1 = new ws_call__c();
        ws1.intsts__c= 'Ready for Integration';
        ws1.mtd_nm__c = 'updateCourSta' ;
        ws1.pmid__c ='' ;
        ws1.rq_itm__c=rqItm[0].id;
        ws1.rq_jsn__c='';
        ws1.ws_typ__c='';
        wsList.add(ws1);
        insert wsList;
        List<g_tran__c> tranList = new List<g_tran__c>();
        g_tran__c tr = new g_tran__c();
        tr.RQ__c = rqItm[0].rq__c;
        tr.TP__c = 'Payment';
        tr.sta__c = 'Completed';
        tr.md__c = 'Cash';
        tr.Acc__c = rqItm[0].RQ__r.Acc__c;
        tranList.add(tr);
        insert tranList;
        system.debug('--tranList--'+tranList);
        Test.startTest();
        system.debug('MockResponse==='+MockResponse.formMockResponse());
        Test.setMock(HttpCalloutMock.class, MockResponse.formMockResponse());
        ctrlPMSupdateinfo objPMSUpdate = new ctrlPMSupdateinfo();
        ctrlPMSupdateinfo.upsertContractInfo(new list<Id> {wsList[0].Id});
        Test.stopTest();

    }

}