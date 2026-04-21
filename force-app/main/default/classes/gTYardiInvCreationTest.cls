@isTest
public class gTYardiInvCreationTest {

    @testSetup
    static void init() {
        List < gStg__c > sList = new List < gStg__c > ();
        gStg__c s = new gStg__c(Name = 'BH');
        s.Text_Value__c = [SELECT Id FROM BusinessHours].id;
        gStg__c s2 = new gStg__c(Name = 'slaExpiry');
        s2.Number_Value__c = 50;
        sList.add(s);
        sList.add(s2);
        insert sList;
    }

    static testmethod void test1() {

        g_srvc_settings__c stg = testData.stgCrt();
        g_Srvc__c s = testData.srvcCrt(stg.Id);
        Account a = testData.accCrt(false);
        Contact emp = testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        g_Req__c r = testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
        g_reqitem__c item = [Select id from g_reqitem__c where RQ__c =: r.Id and itm__r.cd__c = 'ej'
            limit 1
        ];
        g_Tran__c T = new g_Tran__c(Acc__c = r.Acc__c, RQ__c = r.Id, TP__c = 'Payment', sta__c = 'Completed', dt__c = Date.today());
        insert T;
        g_TranItem__c gt = new g_TranItem__c(T__c = t.Id, itm__c = item.Id);
        insert gt;
        Test.startTest();
        gTYardiInvCreation.yardiInvCreation(t.Id);
        Test.setMock(WebServiceMock.class, new paymentCalloutMock());
        gTYardiInvCreation.yardiInvCreation(t.Id);
        Test.stopTest();
    }

    public class paymentCalloutMock implements WebServiceMock {
        public void doInvoke(Object stub, Object request, Map < String, Object > response, String endpoint,
            String soapAction, String requestName, String responseNS, String responseName, String responseType) {
            //ysiPsgD3MepaymentIntfcYardi.METransaction_Response response_x = new ysiPsgD3MepaymentIntfcYardi.METransaction_Response();
            ysiPsgD3MepaymentIntfcYardi.METransactionImportResponse_element response_x = new ysiPsgD3MepaymentIntfcYardi.METransactionImportResponse_element();
            ysiPsgD3MepaymentIntfcYardi.METransaction_Response r = new ysiPsgD3MepaymentIntfcYardi.METransaction_Response();
            r.Status = 'Success';
            gTYardiInvCreation.yardiInv inv = new gTYardiInvCreation.yardiInv();
            inv.legalname = 'testing';
            inv.axsinvoice = '12345';
            inv.yhInvoice = '67890';
            inv.yardiInvoice = '12345';
            r.Message = json.serialize(inv);
            response_x.METransactionImportResult = r;
            response.put('response_x', response_x);
        }
    }
}