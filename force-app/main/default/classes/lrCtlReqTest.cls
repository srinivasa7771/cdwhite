@isTest
private class lrCtlReqTest {
    static testmethod void test1() {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockLicRenewalBatchGen());
        testData.init();

        testData.bRulesReqCrt();
        testData.bRulesItemCrt();
        g_srvc_settings__c stg = testData.stgCrt();
        g_Srvc__c s = testData.srvcCrt(stg.Id);
        s.uid__c = 'ltc';
        s.Milestone_Stage__c = '';
        s.Milestone_SLA__c = '';
        update s;


        User u = testData.createportalUser('pnActUsr');
        insert u;

        System.debug('u====' + u);
        System.debug('u.contactId====' + u.contactId);
        System.debug('u.contact.accountId====' + u.contact.accountId);
        Contact C = [Select Id, Name, AccountId, Photo_ID__c from Contact where Id =: u.contactId];
        System.debug('C====' + C);
        System.debug('C.Account====' + C.AccountId);
        Account A = [Select id, on__c, onar__c, Website, vespe__c, vespex__c, vetemp__c, vbtemp__c, vetst__c, vespst__c, vespstx__c, vbtst__c, vev__c, mxPortalUsers__c, Name, Email__c, lPrk__c, Building_Name__c,
            xcublg__c, Location__c, Location_Cluster__c, xcuzn__c, Phone, Type, Prk__c, adb__c, info__c, bgnr__c, bg__c, bgc__c, bgcabsc__c, bgb__c, vctemp__c, speabsc__c, vctst__c, sncNt__c, vbvv__c, lcidt1__c,
            ec__c, ecidt__c, lctp__c, ecedt__c, lcedt__c, lcsnc__c, lcsncnt__c, Legal_Framework__c, psasnc__c, psasncnt__c, lcsta__c, ecsnc__c, ecsncnt__c, lcrndt__c, cosnc__c, cosncnt__c, licexdt__c, licIdt__c,
            bgsnc__c, bgsncnt__c, snc__c, voep__c, lc__c, ORACLE_PARTY_ID__c, rpa__c, os__c, adob__c, adx__c, adc__c from Account where id =: C.AccountId
        ];
        System.debug('A====' + A);
        List < g_srvc_settings__c > srvcsettings = [select id, reqq__c from g_srvc_settings__c where Name = 'srvcStg'
            LIMIT 1
        ];
        g_Req__c r = testData.reqCrt(A.Id, s.Id, C.Id, 'Open', srvcsettings[0].reqq__c);
        system.Debug('request r' + r);

        //PageReference pageRef = Page.grqdccalcRen;
        PageReference pageRef = new PageReference('/apex/grqdccalcRen');
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(r.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(r);
        lrCtlReq lcr = new lrCtlReq(sc);
        //lcr.LoadAllLocSeg(true);
        lcr.setDCCAReqValues(r);
        //lcr.setNewDCCAReqValues(r);
        lcr.loadSegAct();
        lcr.loadLocations();
        lcr.getSalutations();
        // lcr.getOptions();
        lcr.getMartialStatus();
        lcr.getSpokenLanguages();
        lcr.getAvailableDocs();
        lcr.getSpokenLanguages();
        lcr.renderJs();
        Boolean flg = lcr.nD;
        String str = lcr.selectedEmb;
        String str1 = lcr.lstselectedSegsStr;
        String str2 = lcr.delRecId;
        lcr.nvgStatusPage();
        lcr.getStDate();
        lcr.loadDpdtSec();
        //lcr.makeTrueCopyList();
        lcr.accLocInfo();
        //lcr.getInsTp();
        lcr.paymentPage();
        lcr.getLstSegments();

        //lcr.getCPUDetails('12345');
        //lcr.updateRequestDetails();
        Map < String, String > jsonValue = new Map < String, String > {
            'SignerName' => 'Prateek',
            'SignerEmail' => 'prateek@test.com'
        };
        lcr.getRequestJSON('DigitalSignature', jsonValue, 'TCODE123');
        lcr.updateItemSTA();
        lcr.invokeCourier();
        //lcr.calprem();
        Date pastDate = Date.today().addDays(-1);
        lrCtlReq.isPolicyExpired(pastDate);

        lcr.showCPUWarning = false;
        lcr.isInsurance = false;
        lcr.discount = '100';
        lcr.isDependentApp = false;
        Test.stopTest();



    }
    public class MockLicRenewalBatchGen implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"AttachmentList":[{"Name":"Approval from DM","attachmentBody":"test","messagecode":"0"}]}');
            res.setStatusCode(200);
            return res;
        }
    }

}