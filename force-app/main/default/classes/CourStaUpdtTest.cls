@isTest
global class CourStaUpdtTest {

    @isTest static void testStatusUpdate() {
        testData.init();
        list<gStg__c> stgs=new list<gStg__c>();
        stgs.add(new gStg__c(Name='GDRFAEntryPermitID', Checkbox_Value__c=true, Text_Value__c='Test', Number_Value__c=0, Currency_Value__c=0));
        stgs.add(new gStg__c(Name='GDRFAResidenceID', Checkbox_Value__c=true, Text_Value__c='Test', Number_Value__c=0, Currency_Value__c=0));
        stgs.add(new gStg__c(Name='GDRFARenewResidenceID', Checkbox_Value__c=true, Text_Value__c='Test', Number_Value__c=0, Currency_Value__c=0));
        stgs.add(new gStg__c(Name='GDRFACancelResidenceID', Checkbox_Value__c=true, Text_Value__c='Test', Number_Value__c=0, Currency_Value__c=0));
        stgs.add(new gStg__c(Name='GDRFAAPI', Checkbox_Value__c=true, Text_Value__c='Test', Number_Value__c=0, Currency_Value__c=0));
        stgs.add(new gStg__c(Name='GDRFAAPIKey', Checkbox_Value__c=true, Text_Value__c='Test', Number_Value__c=0, Currency_Value__c=0));
        stgs.add(new gStg__c(Name='OCR_APIKEY', Checkbox_Value__c=true, Text_Value__c='Test', Number_Value__c=0, Currency_Value__c=0));
        stgs.add(new gStg__c(Name='OCR_ENDPOINT', Checkbox_Value__c=true, Text_Value__c='Test', Number_Value__c=0, Currency_Value__c=0));
        insert stgs;
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        Account a=testData.accCrt(false);
        Contact emp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        g_Req__c r= testData.reqCrtOptItems(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c, 'ep, rp');
        List<g_reqitem__c> lst = [select id from g_reqitem__c limit 1];
        ws_call__c ws = new ws_call__c();
        ws.rq_jsn__c = '{"reqs":[{"timeStamp":"2018-05-09 12:28:28", "status":"In Process", "SRN":"43156320180508", "delStatus":"At Dispatcher", "AWB":"0"}]}';
        ws.ws_typ__c = 'Courier Service';
        ws.mtd_nm__c = 'updateCourSta';
        ws.intsts__c = 'Ready for Integration';
        ws.uid__c = '';
        ws.rq_itm__c = lst[0].id;
        insert ws;

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Database.executeBatch(new tecomBatch_CourStaUpdt(), 5);
    }

    global class MockHttpResponseGenerator implements HttpCalloutMock {

        global HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"example":"test"}');
            res.setStatusCode(200);
            return res;
        }
    }

}