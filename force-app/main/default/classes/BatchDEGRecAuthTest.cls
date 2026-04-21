@isTest
public class BatchDEGRecAuthTest {
   @IsTest
    private static  void checkTrnTest() {
          testData.init();
            g_srvc_settings__c stg=testData.stgCrt();
            stg.payq__c = 'Select xcnc__c, Id, Name, STA__c, AT__c, AP__c, AOP__c, dsc__c, dsc__r.prct__c, spCh__c, rmob__c, xaloc__c, xbrnd__c, xbn__c, nt__c, xfpc__c, srvc__c, srvc__r.name, srvc__r.lbl__c, srvc__r.dsc__c, srvc__r.Prk__c, srvc__r.AccTp__c, srvc__r.ckgsnc__c, srvc__r.stg__r.payq__c, srvc__r.snc__c, srvc__r.stg__r.pg__c, srvc__r.pstg__c, srvc__r.stg__r.apx__c, srvc__r.stg__r.reqq__c, srvc__r.payMd__c, Acc__r.Name, Acc__r.lc__c, Acc__c, Acc__r.Type, Acc__r.bgrfi__c, Acc__r.adrfi__c, Acc__r.Prk__c, Acc__r.lcsnc__c, Acc__r.lcsncnt__c, Acc__r.psasnc__c, Acc__r.psasncnt__c, Acc__r.ecsnc__c, Acc__r.ecsncnt__c, Acc__r.cosnc__c, Acc__r.cosncnt__c, Acc__r.bgsnc__c, Acc__r.bg__c, Acc__r.bgsncnt__c, Acc__r.snc__c, Acc__r.info__c, Acc__r.vestd__c, Acc__r.vbtemp__c, LastModifiedDate, LastModifiedById, CreatedDate, CreatedById, Item_Count__c, srvc__r.kstp__c,  Acc__r.adb__c, Acc__r.bgb__c, Acc__r.bgnr__c, xtpa__c, srvc__r.uid__c, xltr__c, (Select Id, Name From reqMbrs__r where isDeleted=false), (Select Id, Name, mxAts__c, mnAts__c, ats__c, nt__c, or__c, reqAts__c, reqOr__c, tplt__c, upOk__c, mbr__c, mbr__r.Name From rDocs__r where Req__c=true and IsDeleted=false), (Select Id, Name, STA__c, dt__c, A__c, md__c, TP__c From Transactions__r where isDeleted=false), (select id, Name, RQ__c, nc__c, rv__c, m__c, m__r.Name, vSTA__c, AP__c, AD__c, AOP__c, nt__c, xprnt__c, xr__c, Dsc__c, DscApp__c, KF__c, cN__c, scN__c, smN__c, exp__c, cXP__c, scXP__c, smXP__c, itm__c, itm__r.xf__c, itm__r.cd__c, itm__r.Name, itm__r.lbl__c, itm__r.Tp__c, itm__r.Req__c, itm__r.exp__c, itm__r.prcEdt__c, itm__r.dSTA__c, sta__c, sta__r.cd__c, sta__r.Name, sta__r.lbl__c, sta__r.Tp__c, sta__r.rc__c, sta__r.noEXP__c, sta__r.Courier_Stage__c, xcawb__c, xcnopro__c , xcub__c , xcco__c, xcasc__c, LastModifiedDate, LastModifiedById, CreatedDate, CreatedById, AV__c, su__c, vsu__c, TAX_CODE__c, extc__c, TAXCODE_SC__c, extcsc__c, vsc__c, vesch__c, vst__c, vec__c, ngs__c, ngsXP__c, tvatp__c, tgop__c, tngop__c, tgovp__c, tvngp__c From Items__r where IsDeleted=false order by itm__r.ord__c), Zone__c, Full_Name__c, CreatedBy.Name , srvc__r.Category__c, xadh__c, xcmob__c , xceml__c From g_Req__c';
            update stg;
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
            Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
            g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
        g_Tran__c T = new g_Tran__c(Acc__c=r.Acc__c, RQ__c=r.Id, TP__c='Payment', md__c='Credit / Debit Card', sta__c='Completed', gwrf__c='4354354353');
        insert T;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockApplicationProcess());
         BatchDEGRecAuth obj = new BatchDEGRecAuth();
         Database.executeBatch(obj, 1);
        Test.stopTest();

  }
     @IsTest
    private static  void checkTrnTest1() {
          testData.init();
            g_srvc_settings__c stg=testData.stgCrt();
            stg.payq__c = 'Select xcnc__c, Id, Name, STA__c, AT__c, AP__c, AOP__c, dsc__c, dsc__r.prct__c, spCh__c, rmob__c, xaloc__c, xbrnd__c, xbn__c, nt__c, xfpc__c, srvc__c, srvc__r.name, srvc__r.lbl__c, srvc__r.dsc__c, srvc__r.Prk__c, srvc__r.AccTp__c, srvc__r.ckgsnc__c, srvc__r.stg__r.payq__c, srvc__r.snc__c, srvc__r.stg__r.pg__c, srvc__r.pstg__c, srvc__r.stg__r.apx__c, srvc__r.stg__r.reqq__c, srvc__r.payMd__c, Acc__r.Name, Acc__r.lc__c, Acc__c, Acc__r.Type, Acc__r.bgrfi__c, Acc__r.adrfi__c, Acc__r.Prk__c, Acc__r.lcsnc__c, Acc__r.lcsncnt__c, Acc__r.psasnc__c, Acc__r.psasncnt__c, Acc__r.ecsnc__c, Acc__r.ecsncnt__c, Acc__r.cosnc__c, Acc__r.cosncnt__c, Acc__r.bgsnc__c, Acc__r.bg__c, Acc__r.bgsncnt__c, Acc__r.snc__c, Acc__r.info__c, Acc__r.vestd__c, Acc__r.vbtemp__c, LastModifiedDate, LastModifiedById, CreatedDate, CreatedById, Item_Count__c, srvc__r.kstp__c,  Acc__r.adb__c, Acc__r.bgb__c, Acc__r.bgnr__c, xtpa__c, srvc__r.uid__c, xltr__c, (Select Id, Name From reqMbrs__r where isDeleted=false), (Select Id, Name, mxAts__c, mnAts__c, ats__c, nt__c, or__c, reqAts__c, reqOr__c, tplt__c, upOk__c, mbr__c, mbr__r.Name From rDocs__r where Req__c=true and IsDeleted=false), (Select Id, Name, STA__c, dt__c, A__c, md__c, TP__c From Transactions__r where isDeleted=false), (select id, Name, RQ__c, nc__c, rv__c, m__c, m__r.Name, vSTA__c, AP__c, AD__c, AOP__c, nt__c, xprnt__c, xr__c, Dsc__c, DscApp__c, KF__c, cN__c, scN__c, smN__c, exp__c, cXP__c, scXP__c, smXP__c, itm__c, itm__r.xf__c, itm__r.cd__c, itm__r.Name, itm__r.lbl__c, itm__r.Tp__c, itm__r.Req__c, itm__r.exp__c, itm__r.prcEdt__c, itm__r.dSTA__c, sta__c, sta__r.cd__c, sta__r.Name, sta__r.lbl__c, sta__r.Tp__c, sta__r.rc__c, sta__r.noEXP__c, sta__r.Courier_Stage__c, xcawb__c, xcnopro__c , xcub__c , xcco__c, xcasc__c, LastModifiedDate, LastModifiedById, CreatedDate, CreatedById, AV__c, su__c, vsu__c, TAX_CODE__c, extc__c, TAXCODE_SC__c, extcsc__c, vsc__c, vesch__c, vst__c, vec__c, ngs__c, ngsXP__c, tvatp__c, tgop__c, tngop__c, tgovp__c, tvngp__c From Items__r where IsDeleted=false order by itm__r.ord__c), Zone__c, Full_Name__c, CreatedBy.Name , srvc__r.Category__c, xadh__c, xcmob__c , xceml__c From g_Req__c';
            update stg;
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
            Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
            g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
        g_Tran__c T = new g_Tran__c(Acc__c=r.Acc__c, RQ__c=r.Id, TP__c='Payment', md__c='Credit / Debit Card', sta__c='Completed', gwrf__c='4354354353');
        insert T;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockApplicationProcess());
         T =  [select id, name from g_Tran__c where id=:T.id];
         BatchDEGRecAuth obj = new BatchDEGRecAuth(T.name);
         Database.executeBatch(obj, 1);
        Test.stopTest();

  }

     public class MockApplicationProcess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"access_token":"tst", "_id":"urn:order:28c58a82-1828-44e4-bb9f-48d6812cd27b", "_links":{"self":{"href":"https://api-gateway.ngenius-payments.com/transactions/outlets/0313c75d-e644-4114-a067-026a6976dd99/orders/28c58a82-1828-44e4-bb9f-48d6812cd27b"}, "tenant-brand":{"href":"http://config-service/config/outlets/0313c75d-e644-4114-a067-026a6976dd99/configs/tenant-brand"}, "merchant-brand":{"href":"http://config-service/config/outlets/0313c75d-e644-4114-a067-026a6976dd99/configs/merchant-brand"}}, "type":"SINGLE", "merchantDefinedData":{}, "action":"SALE", "amount":{"currencyCode":"AED", "value":45000}, "language":"en", "merchantAttributes":{"skipConfirmationPage":"true", "redirectUrl":"https://axs.force.com/grqpyc"}, "emailAddress":"zeeshan.aftab@10pearls.com", "reference":"28c58a82-1828-44e4-bb9f-48d6812cd27b", "outletId":"0313c75d-e644-4114-a067-026a6976dd99", "createDateTime":"2019-12-12T12:16:13.404Z", "paymentMethods":{"card":["VISA", "MASTERCARD", "DINERS_CLUB_INTERNATIONAL"]}, "referrer":"urn:Ecom:28c58a82-1828-44e4-bb9f-48d6812cd27b", "formattedAmount":"د.إ.‏ 450", "formattedOrderSummary":{}, "_embedded":{"payment":[{"_id":"urn:payment:d49e95b2-6e3a-42cc-bfcc-e0d2d2d04d1e", "_links":{"self":{"href":"https://api-gateway.ngenius-payments.com/transactions/outlets/0313c75d-e644-4114-a067-026a6976dd99/orders/28c58a82-1828-44e4-bb9f-48d6812cd27b/payments/d49e95b2-6e3a-42cc-bfcc-e0d2d2d04d1e"}, "curies":[{"name":"cnp", "href":"https://api-gateway.ngenius-payments.com/docs/rels/{rel}", "templated":true}]}, "paymentMethod":{"expiry":"2022-04", "cardholderName":"Zeeshan Aftab", "name":"MASTERCARD", "pan":"552778******4018"}, "state":"POST_AUTH_REVIEW", "amount":{"currencyCode":"AED", "value":45000}, "updateDateTime":"2019-12-12T12:19:20.309Z", "outletId":"0313c75d-e644-4114-a067-026a6976dd99", "orderReference":"28c58a82-1828-44e4-bb9f-48d6812cd27b", "authResponse":{"authorizationCode":"093412", "success":true, "resultCode":"00", "resultMessage":"Successful approval/completion or that VIP PIN verification is valid"}, "3ds":{"status":"SUCCESS"}}]}}');
            res.setStatusCode(200);
            return res;
        }
    }

}