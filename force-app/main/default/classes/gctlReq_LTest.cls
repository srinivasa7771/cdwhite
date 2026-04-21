@istest
private class gctlReq_LTest {
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
    }
    static testmethod void test() {
        g_Req__c req=[SELECT id, STA__c, Acc__c, xfpc__c, xanum__c, xaed__c, xtcdl__c, xpmsle__c,
            hpr__c, srvc__r.uid__c, con__r.rol__c, con__r.firstname, con__r.lastname, con__r.emrt__c,
            con__r.p__c, con__r.email, con__r.mobilephone, con__r.salutation, con__r.ms__c, con__r.nc__c,
            con__r.eidid__c, con__r.pobx__c, con__r.mbs__c, con__r.ma__c, con__r.mta__c, con__r.moa__c,
            con__r.birthdate, con__r.rpui__c  FROM g_Req__c limit 1 ];
        req.xaed__c=Date.Today();
        Contact emp =[Select id, mbs__c, ma__c, mta__c, moa__c, luas__c, accountid  from Contact limit 1];
        //PageReference exportPage = Page.grqstatus;

        List<gStg__c> lstGStg = new List<gStg__c>();
        lstGStg.add(new gStg__c(name='ParkingCancellation', Text_Value__c = '159'));
        lstGStg.add(new gStg__c(name='ParkingDeact', Text_Value__c = '157'));
        lstGStg.add(new gStg__c(name='ParkingActivation', Text_Value__c = '149'));
        lstGStg.add(new gStg__c(name='ParkingModification', Text_Value__c = '152'));
        lstGStg.add(new gStg__c(name='INS_STD', Text_Value__c = '198;199;212'));
        lstGStg.add(new gStg__c(name='INS_SPO', Text_Value__c = '045;119;645'));
        lstGStg.add(new gStg__c(name='INS_CHLD', Text_Value__c = '046;120;646'));
        lstGStg.add(new gStg__c(name='Con_SalSrv',
            Text_Value__c = '001;002;020;021;040;078;003;004;303;304;010;015;027;028;080;081;025;026;307;308;103;188;189;190;191;192;193;016;048;105;055;106;305;306;uae;601;620;640;603;903;610;627;680;625;907;788;790;792;616;655;905;'));
         insert lstGStg;

        PageReference exportPage = new PageReference('/apex/grqstatus');
        exportPage.getParameters().put('empid', emp.id);
        exportPage.getParameters().put('enc', '53');
        Test.setCurrentPage(exportPage);
        ApexPages.StandardController sc = new ApexPages.StandardController(req);

        gctlReq_L obj = new gctlReq_L(sc);
        obj.sanc=obj.sanc;
        obj.ddaReqStatus=obj.ddaReqStatus;
        obj.regOfficeDcca=obj.regOfficeDcca;
        obj.regOfficeDcca=obj.regOfficeDcca;
        obj.lc=obj.lc;
        obj.pt=obj.pt;
        obj.pDsc=obj.pDsc;
        obj.exstDpd=obj.exstDpd;
        obj.spInsTp=obj.spInsTp;
        obj.leaseDt=obj.leaseDt;
        obj.price=obj.price;
        obj.brodcastFlag=obj.brodcastFlag;
        obj.fine30amount=obj.fine30amount;
        obj.fine60amount=obj.fine60amount;
        obj.fine90amount=obj.fine90amount;
        obj.strpriceMap=obj.strpriceMap;
        obj.usr=obj.usr;
        obj.actvList=obj.actvList;
        obj.tecomd3LeaseList=obj.tecomd3LeaseList;
        obj.priceMap=obj.priceMap;
        obj.chanTMap=obj.chanTMap;
        obj.addMainOffMap=obj.addMainOffMap;
        obj.agreeNoAmd=obj.agreeNoAmd;
        obj.mapAct=obj.mapAct;
        obj.mapprc=obj.mapprc;
        obj.gctlInsComp=obj.gctlInsComp;
        obj.grsPrem=obj.grsPrem;
        obj.vatAmt=obj.vatAmt;
        obj.fnlPrem=obj.fnlPrem;
        obj.lcl=obj.lcl;
        obj.lst_pd=obj.lst_pd;
        gctlReq_L.searchNum=gctlReq_L.searchNum;
        obj.isCon=obj.isCon;
        obj.selectedLoc=obj.selectedLoc;
        obj.selectedLoc2=obj.selectedLoc2;
        obj.accde();
        obj.dsgu();
       // obj.nD();
        //obj.accLocInfo=obj.accLocInfo;
        obj.CancelRBO();
       // obj.isnw();
       // obj.mbr=obj.mbr;
       // obj.adjust(req);
        obj.el=obj.el;
        obj.lstAddparks=obj.lstAddparks;
        obj.needApproval=obj.needApproval;
        obj.amnt=obj.amnt;
        //obj.pdMsg=obj.pdMsg;
        obj.hdCnt=obj.hdCnt;
        obj.stDt=obj.stDt;
        obj.getStDate();
        obj.getAmntAP();
        obj.lstCards=obj.lstCards;
        //obj.selectedEmb();

        obj.authenticateUser();
        obj.saveDraft();
        obj.srv=req.srvc__r;
        obj.srv.uid__c='ltc';
        obj.assignAccount();
        gctlReq_L.updateArabicName(emp.id);
        gctlReq_L.updateContactDetails(emp);
        obj.CancelR();
        obj.makeTrueCopyList();
        obj.loadLocations();
        obj.getpkgCards();
        obj.conInfo();
        obj.processParking();
        obj.getInsTp();
        obj.assignMngr();
         obj.validateVehicle();
        obj.cancelItms();
        obj.updateEncriptedQRCodeLink(req);
        obj.getCountriesOptions();
        obj.getlstActivities();
        obj.getPrmtReqs();
        obj.getAvailableDocs();
        obj.getOptions('xnld__c');
        obj.getSalutations();
        obj.assignMngr();
        obj.getInsTp();
        obj.loadSegAct();
        //obj.hasSanctions=obj.hasSanctions();
        //obj.accesssOk=onj.accesssOk;
        /*
        obj.loadAccAllLocSeg();
        obj.loadDpdtSec();
        obj.LoadAllLocSeg(true);
        obj.setDCCAReqValues(req);
        obj.loadSegAct(); */

    }
    static testMethod void testbatchSeg() {
        Test.startTest();
        g_Req__c req=[SELECT id, STA__c, Acc__c, xfpc__c, xaed__c, xanum__c, xtcdl__c, xpmsle__c,
            hpr__c, con__r.rol__c, con__r.firstname, con__r.lastname, con__r.emrt__c, con__r.p__c,
            con__r.email, con__r.mobilephone, con__r.salutation, con__r.ms__c, con__r.nc__c,
            con__r.eidid__c, con__r.pobx__c, con__r.mbs__c, con__r.ma__c, con__r.mta__c, con__r.moa__c,
            con__r.birthdate, con__r.rpui__c  FROM g_Req__c limit 1 ];
        Contact emp =[Select id, mbs__c, ma__c, mta__c, moa__c, luas__c, accountid  from Contact limit 1];
        Test.setMock(HttpCalloutMock.class, new MockInsloadAllSeg());
         ApexPages.StandardController sc = new ApexPages.StandardController(req);
        gctlReq_L obj = new gctlReq_L(sc);
           obj.loadAccAllLocSeg();
        Test.stopTest();
    }
    public class MockInsloadAllSeg implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"MethodName":"getActivities", "locationList":null, "LicnseNo":"19299", "errorCode":"0", "error":"", "act":[{"type":"Office", "titleList":null, "StartDate":"2016-03-31", "segName":"Design", "Name":"Consultancy", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a296F000004GUQfQAO", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2016-03-31", "segName":"Design", "Name":"Concept Design", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a296F000004GUQgQAO", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2016-03-31", "segName":"Design", "Name":"Information, Interface and Digital Design", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a296F000004GUQhQAO", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2014-02-24", "segName":"Executive Search", "Name":"Executive Search", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a2990000000h80VAAQ", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2014-02-24", "segName":"Human Resources Consultancy", "Name":"Organizational Restructuring and Reorganizing", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a2990000000h80aAAA", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2014-02-24", "segName":"Human Resources Consultancy", "Name":"Compensation, Benefits & Recognition", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a2990000000h80fAAA", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2014-02-24", "segName":"Human Resources Consultancy", "Name":"Career Development & Management", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a2990000000h80kAAA", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2003-12-22", "segName":"Consultancy", "Name":"Management Consultancy", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NGVIA2", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2009-04-01", "segName":"Software", "Name":"Solution Provider", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NHHIA2", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"IT Service", "Name":"Developer", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NKoIAM", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2003-12-22", "segName":"Regional Head Quarters", "Name":"Administration Office", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NKtIAM", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"IT Service", "Name":"Consultancy", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NKuIAM", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"IT Service", "Name":"Customer Service", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NLBIA2", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2009-04-01", "segName":"IT Service", "Name":"Solution Provider", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NPjIAM", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"IT Service", "Name":"Support Service Provider", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NQuIAM", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"Software", "Name":"Developer", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NSrIAM", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"Software", "Name":"Customer Service", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NStIAM", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"Software", "Name":"Support Service Provider", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NVIIA2", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"Software", "Name":"Consultancy", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NVVIA2", "accName":null}]}');
            res.setStatusCode(200);
            return res;
        }
    }
}