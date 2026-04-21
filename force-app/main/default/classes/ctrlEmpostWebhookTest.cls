@isTest
public class ctrlEmpostWebhookTest {

    static testMethod void init1() {
        ctrlEmpostWebhook.ReqData data = new ctrlEmpostWebhook.ReqData();
        RestRequest req = new RestRequest();
        req.requestBody = Blob.valueOf(JSON.serialize(data));
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/courierWebhook/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        ctrlEmpostWebhook.processData();
        Test.stopTest();
    }

    static testMethod void init2() {
        gStg__c st = new gStg__c(Name= 'BH', Text_Value__c= '01m20000000BKEa');
        insert st;
        gStg__c st2 = new gStg__c(Name= 'slaExpiry', Number_Value__c= 50);
        insert st2;

        Account acc = new Account(Name='Testing');
        insert acc;
        g_srvc_settings__c sett = new g_srvc_settings__c(reqbrules__c='Testing', pg__c= 'Testing');
        insert sett;
        g_Srvc__c sr = new g_Srvc__c(stg__c=sett.Id, uid__c='123');
        insert sr;
        g_srvcitm__c sritem = new g_srvcitm__c(srvc__c=sr.Id, cd__c='345', lbl__c='234', ord__c=12);
        insert sritem;
        g_srvcitm_Status__c sritemstatus = new g_srvcitm_Status__c(itm__c=sritem.Id, rqSTA__c='Open', cd__c='234', lbl__c='123');
        insert sritemstatus;
        g_Req__c req1 = new g_Req__c(Acc__c=acc.Id, srvc__c=sr.Id, sta__c='Draft');
        insert req1;
        g_reqitem__c req2 = new g_reqitem__c(RQ__c=req1.Id, sta__c=sritemstatus.Id, itm__c=sritem.Id);
        insert req2;
        g_cmb__c cmb = new g_cmb__c(xawb__c = 12345, itm__c=req2.Id);
        insert cmb;
        Courier_Status__c statu = new Courier_Status__c(srvitm__c=sritem.Id, itmSTA__c=sritemstatus.Id, curSTA__c=sritemstatus.Id, Courier_Status__c= 'Draft');
        insert statu;
        ctrlEmpostWebhook.ReqData data = new ctrlEmpostWebhook.ReqData();
        data.AWB_Number = '12345';
        data.IDExpiry = '01/01/2021 01:00:00 AM';
        data.Status = 'Draft';
        RestRequest req = new RestRequest();
        req.requestBody = Blob.valueOf(JSON.serialize(data));
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/courierWebhook/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        ctrlEmpostWebhook.processData();
        Test.stopTest();
    }
}