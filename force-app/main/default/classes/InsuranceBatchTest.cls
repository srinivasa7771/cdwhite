@isTest(SeeAllData=false)
public class InsuranceBatchTest {

 static testMethod void testbatch() {
      testData.init();

       List<adnicWS__c> lstGStg = new List<adnicWS__c>();
        //Endpoint__c; PartnerID__c
        adnicWS__c CalPrem = new adnicWS__c(Name='CalPrem', Endpoint__c='https://online.adnic.ae/MedicalAppTest/api/medical/CalcPremium', PartnerID__c='TECOM');    lstGStg.add(CalPrem);
        adnicWS__c jsnCre = new adnicWS__c(Name='Json Creation', Endpoint__c='https://online.adnic.ae/MedicalAppTest/api/medical/CalcPremium', PartnerID__c='TECOM');lstGStg.add(jsnCre);
        adnicWS__c plCre = new adnicWS__c(Name='PolicyGen', Endpoint__c='https://online.adnic.ae/MedicalAppTest/api/medical/GeneratePolicy', PartnerID__c='TECOM');lstGStg.add(plCre);
        insert lstGStg;

         g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
        Account a=testData.accCrt(false);
        a.ORACLE_PARTY_ID__c = '1234';  a.lc__c='999999';
        update a;
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c rq=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
        rq.rtacn__c = '1234';rq.xoln__c='055372654'; rq.rmob__c='0512341234';
        rq.xceml__c='a@b.com'; rq.xintp__c = 'SILVER'; rq.xcp__c = 'P98989876';
        update rq;
       List<g_reqitem__c> riItmLst = [select id, AD__c, name from g_reqitem__c where itm__r.cd__c ='md'];
    system.debug('riItmLst'+riItmLst);
        g_reqitem__c ritm = new g_reqitem__c(id=riItmLst[0].Id, exp__c=true, dcXP__c=0.00,
            dc__c=0.00, Dsc__c=0.00, KF__c=0.00, scXP__c=0.00, scN__c=1.00, cXP__c=0.00, cN__c=0.00,
            smXP__c=0.00, smN__c=0.00, su__c=0.00, vec__c=0.00, vesch__c=0.00, vsc__c=0.00, vst__c=0.00);
        update ritm;
     g_Tran__c gt= new g_Tran__c(Acc__c=a.id, RQ__c=rq.id);
     insert gt;
     g_TranItem__c gtm = new g_TranItem__c(itm__c=ritm.id, T__c=gt.id, A__c=1.00, STA__c='Completed', Tp__c='Payment');
     insert gtm;
      g_TranItem__c gtm1 = new g_TranItem__c(itm__c=ritm.id, T__c=gt.id, A__c=0.00, STA__c='Completed', Tp__c='Payment');
     insert gtm1;
     List<g_reqitem__c> rqItm =[Select id, rq__c, AP__c, AD__c from g_reqitem__c where id=:ritm.id limit 1];
       system.debug('rqItm====>'+rqItm);
     List<ws_call__c> wsList = new  List<ws_call__c>();
     ws_call__c ws = new ws_call__c();
     ws.intsts__c= 'Ready for Integration';
     ws.mtd_nm__c = 'generatePolicy' ;
     ws.pmid__c ='' ;
     ws.ws_typ__c='Insurance1';
     ws.rq_itm__c=ritm.id;
     ws.rq_jsn__c='{"SponsorInfo":{"VATRegNo":"J123567", "TradeLicenseNo":"16201", "POBoxNo":"123123", "PhoneNo":"+97144294700", "Name":"Al-Futtaim Willis Co. (L.L.C)", "MobileNo":"50000000", "EmailId":"mari@gmail.com", "DOB":null, "City":"DUBAI", "Address":"DOZ, Building 06, qweqweqweq"}, "QuoteInfo":{"VisaEmirate":"Dubai", "SalaryBand":"ABOVE 4000", "RefNo":"Mari1232331012018", "QuotationNo":"5MED00007609", "PolicyType":"E", "PlanType":"GOLD", "NoOfPersonsToInsure":"1", "IncludingSponsor":"NO"}, "PremiumInfo":null, "PolicyInfo":{"PolicyStartDate":"31-01-2018", "PolicyNo":null, "PolicyEndDate":"30-01-2019", "PaymentType":"ON ACCOUNT", "PaymentRefNo":"42967520180131", "FinalPremiumAmt":"5424.30", "DebitNoteNo":null, "CommissionAmtCreditNoteNo":null}, "PolicyDocumentInfo":null, "PartnerInfo":{"PartnerId":"TECOM"}, "InsuredInfo":[{"WorkLocation":"AL SAFA SECOND", "UIDNo":"23445435345", "Relationship":"E", "PreviouslyCovered":"NO", "PregnantStatus":"NO", "PassportNo":"MARI12323", "OccupationalIndustry":"OTHER SERVICES & ACTIVITIES", "Nationality":"AFGHAN", "Name":"Mari Vari", "MobileNo":"50000000", "MemberId":null, "MemberGrossPremiumAmt":null, "MaritalStatus":"SINGLE", "Gender":"MALE", "EmiratesIdApplicationNo":"800220180125025002884", "EmiratesId":null, "DOB":"31-01-1989"}], "errorInfo":null, "DocumentInfo":null}';
      wsList.add(ws);
         Insert wsList;
        List<ws_call__c> wsListUpdate = [select id, intsts__c, rq_itm__r.AP__c, rq_itm__r.AD__c from ws_call__c WHERE ws_typ__c In('Insurance1')];
     system.debug('wsListUpdate====>'+wsListUpdate);
         for (ws_call__c wsupdate : wsListUpdate) {
             wsupdate.intsts__c = 'Ready for Integration';
             wsupdate.ws_typ__c='Insurance';
         }
         update wsListUpdate;
      system.debug('wsListUpdate2====>'+wsListUpdate);
     Test.startTest();
     Test.setMock(HttpCalloutMock.class, new MockInsBatchGen());
     InsuranceBatch obj = new InsuranceBatch();
     DataBase.executeBatch(obj, 5);

     InsuranceBatchSchedul ins = new InsuranceBatchSchedul();

     Test.stopTest();
 }

    public class MockInsBatchGen implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            //  res.setBody('udhjcbhjeuy67dwdgshgcuwe');
            // res.setBody('Insurance:[DocumentInfo=null, InsuredInfo=(InsuredInfo:[DOB=31-01-1989, EmiratesId=null, EmiratesIdApplicationNo=null, Gender=MALE, MaritalStatus=null, MemberGrossPremiumAmt=5166, MemberId=901031-1-A, MobileNo=null, Name=MARI VARI, Nationality=null, OccupationalIndustry=null, PassportNo=MARI12323, PregnantStatus=null, PreviouslyCovered=null, Relationship=null, UIDNo=null, WorkLocation=null]), PartnerInfo=null, PolicyDocumentInfo=PolicyDocumentInfo:[creditNoteDoc=https://online.adnic.ae/MedicalAppTest/api/medical/getDocument?docInfo=HsPZoKU6delneM2_yhx9ctz6UJ_-b2y_XM7AKC3YFSeFijeOhum6qk3Pn-VsmmlCtMlMKoY2TR5rE8BFPnIyKQ, invoiceDoc=https://online.adnic.ae/MedicalAppTest/api/medical/getDocument?docInfo=NcwaluwJM7UsGaNQ2qpwP3aYCH_7McZqVSn_y3WqbIgdhSZ7XJp65HERFV1fx5R9OohHKHKguLwKex54IovKAQ, policyDoc=https://online.adnic.ae/MedicalAppTest/api/medical/getDocument?docInfo=sYjeOeaqVapd8qtqIr2FNOm8bBGwvDy3sDN7YTMW4xUUfIassuGaAkKZEikDoO2p], PolicyInfo=PolicyInfo:[CommissionAmtCreditNoteNo=null, DebitNoteNo=DN-18-901031, FinalPremiumAmt=5424.3, PaymentRefNo=42967520180131, PaymentType=ON ACCOUNT, PolicyEndDate=30-01-2019, PolicyNo=901031, PolicyStartDate=31-01-2018], PremiumInfo=null, QuoteInfo=QuoteInfo:[IncludingSponsor=null, NoOfPersonsToInsure=1, PlanType=GOLD, PolicyType=E, QuotationNo=5MED00007609, RefNo=Mari1232331012018, SalaryBand=ABOVE 4000, VisaEmirate=Dubai], SponsorInfo=SponsorInfo:[Address=null, City=null, DOB=null, EmailId=null, MobileNo=null, Name=Al-Futtaim Willis Co. (L.L.C), POBoxNo=null, PhoneNo=null, TradeLicenseNo=16201, VATRegNo=J123567], errorInfo=()]');
            String dummyResp = '{"QuoteInfo":{"RefNo":"R13333455", "QuotationNo":"9002000034151", "VisaEmirate":"DUBAI", "SalaryBand":"BELOW 4000", "PolicyType":"E", "PlanType":"Silver", "NoOfPersonsToInsure":"2"}, "InsuredInfo":[{"Name":"MOHAMMAD KHAN KHAQAN MOHAMMAD", "DOB":"15-03-1970", "Gender":"MALE", "MemberGrossPremiumAmt":"9593", "PassportNo":"EP4761866", "MemberId":"802717-1-A", "DhaMemberId":"I017-000-921920957-01"}, {"Name":"CHARAN HASSAN CHANNAKESHAVA", "DOB":"04-11-1987", "Gender":"MALE", "MemberGrossPremiumAmt":"3925", "PassportNo":"P0130402B", "MemberId":"802717-2-A", "DhaMemberId":"I017-000-92192097-01"}], "ErrorInfo":[], "SponsorInfo":{"Name":"ABC PRIVATE LIMITED", "TradeLicenseNo":"TL12345", "VATRegNo":""}, "PolicyInfo":{"PolicyStartDate":"", "PolicyEndDate":"", "FinalPremiumAmt":"14271.6", "PaymentType":"ON ACCOUNT", "PaymentRefNo":"PAYREF093245", "PolicyNo":"802717", "DebitNoteNo":"", "CommissionAmt":"747.56", "CreditNoteNo":""}, "PolicyDocumentInfo":{"invoiceDoc":"https://online.adnic.ae/MedicalAppTest/api/medical/getDocument?docInfo=UIczR1A32wutEFFlX9zwXFPZcl-MrTy0wpgscjfEzVB6gjM0-00AuQb5ZgWyfP5oeW2GmBAOujGjlsQa9I6ySQ", "policyDoc":"https://online.adnic.ae/MedicalAppTest/api/medical/getDocument?docInfo=i1f3Odj5Q0Ew5fjVHp4HjHw06KHTAJURBRxIsAefxJdeP0KrFigkgma5eJVBbYf8rS46Fl5QbvHjAJanQZNzsw", "creditNoteDoc":"https://online.adnic.ae/MedicalAppTest/api/medical/getDocument?docInfo=lEWZfCO_hpzgy6GxdCZ_he2lWJbYB-OHuDxYeJPhdifl7V4DOacn_yqHTF9HioV2ojzz_5MCgdmBSYyn20TUkw"}}';

            //'{"QuoteInfo":{"RefNo":"20201028085424", "QuotationNo":"9002000050777", "VisaEmirate":"Dubai", "SalaryBand":"BELOW 4000", "PolicyType":"E", "PlanType":"EBP", "NoOfPersonsToInsure":"1"}, "InsuredInfo":[{"Name":"MR. SUPER AXS", "DOB":"06-11-1980", "Gender":"MALE", "MemberGrossPremiumAmt":"550", "MemberBasmahFund":"37"}], "PremiumInfo":{"GrossPremiumAmt":"550", "BasmahFund":"37", "VATAmt":"29.35", "FinalPremiumAmt":"616.35", "DiscountAmt":"0"}, "ErrorInfo":[]}';
            Integer z = Integer.valueOf(Math.floor(Math.random() * (6) + 1));
            res.setBody(gctlInsHelper.encryptStr(dummyResp, z));
            res.setStatusCode(200);
            return res;
        }
    }

 }