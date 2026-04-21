@isTest
private class gctlReqTest {
     @testSetup static void setup() {

        List<gStg__c> lstGStg = new List<gStg__c>();
        gStg__c pActivation = new gStg__c(name='ParkingActivation', Text_Value__c = '149');
        lstGStg.add(pActivation);

        gStg__c pLostCard = new gStg__c(name='ParkingLostCard', Text_Value__c = '150');
        lstGStg.add(pLostCard);

        gStg__c pModification = new gStg__c(name='ParkingModification', Text_Value__c = '152');
        lstGStg.add(pModification);

        gStg__c pDetail = new gStg__c(name='ParkingDetail', Text_Value__c = '153');
        lstGStg.add(pDetail);

        gStg__c wsDomain = new gStg__c(name='WSDmn', Text_Value__c = 'cs6');
        lstGStg.add(wsDomain);

        gStg__c tecomDmn = new gStg__c(name='tecomDmn', Text_Value__c = 'tecom--staging.cs6.my');
        lstGStg.add(tecomDmn);

         gStg__c paidParking = new gStg__c(name='AdditionalParking', Text_Value__c = '154');
         lstGStg.add(paidParking);

         gStg__c ParkingCancellation = new gStg__c(name='ParkingCancellation', Text_Value__c = '155');
         lstGStg.add(ParkingCancellation);

         gStg__c ParkingDeact = new gStg__c(name='ParkingDeact', Text_Value__c = '157');
         lstGStg.add(ParkingDeact);
          gStg__c tst1 = new gStg__c(name='INS_STD', Text_Value__c = 'tst;tst;');
         lstGStg.add(tst1);
         gStg__c tst3 = new gStg__c(name='INS_SPO', Text_Value__c = 'tst;tst;');
         lstGStg.add(tst3);
         gStg__c tst2 = new gStg__c(name='INS_CHLD', Text_Value__c = 'tst;tst;');
         lstGStg.add(tst2);
        insert lstGStg;
    }

    static testMethod void doTest() {
        boolean blV;String sV;

            testData.init();
            g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
            Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
            g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
            g_reqMbr__c objM = new g_reqMbr__c();
            //-----------------------------------------------
            gctlReq.mbr m = new gctlReq.mbr(objM);
            m.m=m.m;
            blV=m.isnw;
            m.adjust(r);

            gStg__c stg1 = new gStg__c();
            stg1.name = 'guprfl';
            stg1.Checkbox_Value__c = true;
            stg1.Currency_Value__c = 12;
            stg1.Number_Value__c = 43;
            stg1.Text_Value__c = '00e20000001Ak2YAAS';
            insert stg1;
            //------------------------------------------------
            //

            Contact c = new Contact();
            c.idtxt__c = '2730';
            c.rp__c = 'qwdqwed';
            c.lastName = 'khan';
            insert c;

            Contact c1 = new Contact();
            c1.rp__c = 'qwdqwed';
            c1.lastName = 'khan';
            c1.Spon__c = c.id;
            c1.rol__c = 'Spouse';
            insert c1;

             Test.startTest();

            Test.setCurrentPageReference(new PageReference('Page.myPage'));
            System.currentPageReference().getParameters().put('id', '2730');
            System.currentPageReference().getParameters().put('enc', '27301111');

            gctlReq obj=new gctlReq(new ApexPages.StandardController(r));
            obj.rq=obj.rq;obj.srv=obj.srv;obj.Acc=obj.Acc;obj.md=obj.md;
            obj.pt=obj.pt;obj.pDsc=obj.pDsc;
            obj.pg=obj.pg;obj.pgHide=obj.pgHide;obj.ispu=obj.ispu;
            sV=obj.lcl;
            obj.mbrs=obj.mbrs;obj.mbrCnt=obj.mbrCnt;
            obj.saveDraft();
            //obj.saveOpen();
            obj.save();
            obj.CancelR();
            g_Req__c rqNew = new g_Req__c();
            obj=new gctlReq(new ApexPages.StandardController(rqNew));
            ApexPages.CurrentPage().getParameters().put('sid', s.Id);
            obj=new gctlReq(new ApexPages.StandardController(rqNew));

            obj.authenticateUser();
            gctlReq.DEG_Checksum('test', 'test');

            obj.loadCards();
           obj.rq.Acc__c = a.id;

            obj.CancelRBO();

        Test.stopTest();
    }
    static testMethod void doTest1() {
        boolean blV;String sV;

            testData.init();
            g_srvc_settings__c stg=testData.stgCrt();
            g_Srvc__c s=testData.srvcCrt(stg.Id);
            Account a=testData.accCrt(false);
            Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
            Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
            g_Req__c r=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
            g_reqMbr__c objM = new g_reqMbr__c();
            //-----------------------------------------------
            gctlReq.mbr m = new gctlReq.mbr(objM);
            m.m=m.m;
            blV=m.isnw;
            m.adjust(r);

            gStg__c stg1 = new gStg__c();
            stg1.name = 'guprfl';
            stg1.Checkbox_Value__c = true;
            stg1.Currency_Value__c = 12;
            stg1.Number_Value__c = 43;
            stg1.Text_Value__c = '00e20000001Ak2YAAS';
            insert stg1;
            //------------------------------------------------
            //

            Contact c = new Contact();
            c.idtxt__c = '2730';
            c.rp__c = 'qwdqwed';
            c.lastName = 'khan';
            insert c;

            Contact c1 = new Contact();
            c1.rp__c = 'qwdqwed';
            c1.lastName = 'khan';
            c1.Spon__c = c.id;
            c1.rol__c = 'Spouse';
            insert c1;
            loc__c loc = new loc__c();
        loc.acc__c = a.id;
        loc.ls_end__c = date.today().addDays(10);
        loc.ls_std__c = date.today(); loc.isregof__c = true; loc.IsActive__c = true;
        insert loc;

          Test.startTest();

         Test.setMock(HttpCalloutMock.class, new MockInsloadAllSeg());
        gctlReq obj=new gctlReq();
        obj.rq = new g_Req__c();
        obj.rq.Acc__c = a.id;
            obj.loadAccAllLocSeg();

        obj.getParkings();

        obj.getStDate();
        obj.srv = s;
        obj.getpkgCards();obj.getInsTp();obj.assignMngr();
        List<String> lst = obj.lstPrmtReq;
        obj.getAcc2();
        obj.Acc = [select id, dedlic__c, lcsta__c, Name, Legal_Framework__c, lrd__c, onar__c,
            Phone, adb__c, bgb__c, bgnr__c, bg__c, lc__c, ORACLE_PARTY_ID__c, loc__c, Type, Prk__c,
            lcsnc__c, lcsncnt__c, psasnc__c, psasncnt__c, ecsnc__c, ecsncnt__c, cosnc__c, cosncnt__c,
            bgsnc__c, bgsncnt__c, snc__c, info__c, vestd__c, vbtemp__c, vbvv__c, lcedt__c, vbtst__c,
            (Select Id , acct__c, act__c, act_type__c, bus_unit__c, dcca_id__c, lic__c, or_prty__c,
            seg__c, sDate__c from aseg__r), (Select Id, Loc__c, agrno__c, acc__c, bu__c, IsMain__c,
            IsSub__c, ls_end__c, ls_std__c, active__c, rpi__c, Is_frzn__c from aloc__r where Is_frzn__c=true  ) from Account where id=: a.id limit 1];
        obj.loadLocations();
        obj.loadSegAct();obj.accde(); gctlReq.lostDocWrap lostwrp = new gctlReq.lostDocWrap('test', 2, false);
        try{
             obj.getAmntAP();
        }catch (Exception ex) {}
        obj.lc = null;obj.exstDpd=false;obj.spInsTp = 'test';obj.price = 'tst';obj.gctlInsComp=null;obj.grsPrem='tst';obj.vatAmt='tst';obj.fnlPrem='tst';
        obj.lst_pd = null; gctlReq.searchNum= 'tst'; obj.isCon= false; obj.selectedLoc= 'tst';obj.selectedLoc2= 'tst';
       obj.loadDpdtSec();obj.lstAddparks=null;obj.needApproval='tst';obj.amnt=200;
        try{
            obj.processParking();
        }
        catch (Exception e) {}
        try{obj.makeTrueCopyList();}catch (Exception e) {}  try{ obj.dsgu();}catch (Exception e) {}
        obj.rq.Con__c = c.id;
        obj.conInfo();
        Test.stopTest();
    }
    public class MockInsloadAllSeg implements HttpCalloutMock {
           public HTTPResponse respond(HTTPRequest req) {
               HttpResponse res = new HttpResponse();
               res.setHeader('Content-Type', 'application/json');
               if (req.getEndpoint().contains('callout:tecom_Courier'))
                 res.setBody('{"ResponseData":{"AgNo":"AG-110743", "Success":true, "Source":"TBP", "Error":"", "ResponseCode":"200", "Records":[{"AgNo":"AG-110743", "Units":[{"UnitName":"DMC-Bldg 14-Full Building", "UnitNameArabic":"", "UnitNoArabic":"مبنى كامل", "UnitNoEnglish":"Full Building", "UnitNumber":"Full Building", "FloorArabic":"الأرضي", "FloorEnglish":"Ground", "FloorName":"Ground 0", "BuildingName":"14", "BuildingNameArabic":"14", "CommercialName":"DMC Bldg 14", "BusinessPark":"DMC", "UniqueKey":"DMCBldg 14", "Category":"Office", "SubCategory":"Office", "SendToDCCA":true}]}]}}');
               else if (req.getEndpoint().contains('callout:tecom_Courier'))
               res.setBody(' {"ResponseData":{"PartyId":"1475811", "Success":true, "Source":"TBP", "Error":"", "ResponseCode":"200", "Records":[{"StageName":"Lease Renewal", "AgNo":"AG-131986", "LeaseType":"Tecom / PMLA", "BusinessPark":"DSC", "ContractStartDate":"2021-01-01", "ContractEndDate":"2021-12-31", "Category":"Office", "SubCategory":"Office", "ContractStatus":"In Progress", "ContractStatusReason":"Customer Signed", "IsDownsize":false, "RenewalOpp":"", "Products":[{"LineItemName":"Renewal: 2021 : Camouflage Productions FZ-LLC- DSC-Bldg 04-203", "ProductName":"DSC-Bldg 04-203", "UnitNumber":"203"}]}, {"StageName":"Closed Won", "AgNo":"AG-126889", "LeaseType":"Tecom / PMLA", "BusinessPark":"DSC", "ContractStartDate":"2018-01-01", "ContractEndDate":"2020-12-31", "Category":"Office", "SubCategory":"Office", "ContractStatus":"Active", "ContractStatusReason":"Active", "IsDownsize":false, "RenewalOpp":"AG-131986", "Products":[{"LineItemName":"Camouflage Productions FZ-LLC- DSC-Bldg 04-203", "ProductName":"DSC-Bldg 04-203", "UnitNumber":"203"}]}]}}');
               else if (req.getEndpoint().contains('callout:D3_NC'))
                 res.setBody('{"ResponseData":{"PartyId":"32023", "Success":true, "Source":"TBP", "Error":"", "ResponseCode":"200", "Records":[{"StageName":"Closed Won", "AgNo":"AG-119902", "LeaseType":"Tecom / PMLA", "BusinessPark":"DKP", "ContractStartDate":"2017-02-01", "ContractEndDate":"2019-01-31", "Category":"Office", "SubCategory":"Premium Fitted-out Office", "ContractStatus":"Active", "ContractStatusReason":"Active", "IsDownsize":true, "RenewalOpp":"", "Products":[{"LineItemName":"Downsize: IBM Middle East FZ-LLC- DKV-B02 DKP-B02-FL1C1", "ProductName":"DKP-B02-FL1C1", "UnitNumber":"FL1C1"}, {"LineItemName":"Downsize: IBM Middle East FZ-LLC- DKV-B02 DKP-B02-163A", "ProductName":"DKP-B02-163A", "UnitNumber":"163A"}, {"LineItemName":"Downsize: IBM Middle East FZ-LLC- DKV-B02 DKP-B02-162", "ProductName":"DKP-B02-162", "UnitNumber":"162"}, {"LineItemName":"Downsize: IBM Middle East FZ-LLC- DKV-B02 DKP-B02-161", "ProductName":"DKP-B02-161", "UnitNumber":"161"}, {"LineItemName":"Downsize: IBM Middle East FZ-LLC- DKV-B02 DKP-B02-160", "ProductName":"DKP-B02-160", "UnitNumber":"160"}, {"LineItemName":"Downsize: IBM Middle East FZ-LLC- DKV-B02 DKP-B02-159", "ProductName":"DKP-B02-159", "UnitNumber":"159"}]}, {"StageName":"Closed Won", "AgNo":"AG-117256", "LeaseType":"Tecom / PMLA", "BusinessPark":"DIC", "ContractStartDate":"2016-09-15", "ContractEndDate":"2021-09-14", "Category":"Common Area", "SubCategory":"Corridor", "ContractStatus":"Active", "ContractStatusReason":"Active", "IsDownsize":false, "RenewalOpp":"", "Products":[{"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-305", "ProductName":"DIC-Bldg 05-305", "UnitNumber":"305"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-306", "ProductName":"DIC-Bldg 05-306", "UnitNumber":"306"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-320", "ProductName":"DIC-Bldg 05-320", "UnitNumber":"320"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-318", "ProductName":"DIC-Bldg 05-318", "UnitNumber":"318"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-319", "ProductName":"DIC-Bldg 05-319", "UnitNumber":"319"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-324", "ProductName":"DIC-Bldg 05-324", "UnitNumber":"324"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-321", "ProductName":"DIC-Bldg 05-321", "UnitNumber":"321"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-301", "ProductName":"DIC-Bldg 05-301", "UnitNumber":"301"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-304", "ProductName":"DIC-Bldg 05-304", "UnitNumber":"304"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-302", "ProductName":"DIC-Bldg 05-302", "UnitNumber":"302"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-311", "ProductName":"DIC-Bldg 05-311", "UnitNumber":"311"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-C", "ProductName":"DIC-Bldg 05-C", "UnitNumber":"C"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-323", "ProductName":"DIC-Bldg 05-323", "UnitNumber":"323"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-310", "ProductName":"DIC-Bldg 05-310", "UnitNumber":"310"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-303", "ProductName":"DIC-Bldg 05-303", "UnitNumber":"303"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-221", "ProductName":"DIC-Bldg 05-221", "UnitNumber":"221"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-222", "ProductName":"DIC-Bldg 05-222", "UnitNumber":"222"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-219", "ProductName":"DIC-Bldg 05-219", "UnitNumber":"219"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-307", "ProductName":"DIC-Bldg 05-307", "UnitNumber":"307"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-312", "ProductName":"DIC-Bldg 05-312", "UnitNumber":"312"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-314", "ProductName":"DIC-Bldg 05-314", "UnitNumber":"314"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-220", "ProductName":"DIC-Bldg 05-220", "UnitNumber":"220"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-322", "ProductName":"DIC-Bldg 05-322", "UnitNumber":"322"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-308", "ProductName":"DIC-Bldg 05-308", "UnitNumber":"308"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-309", "ProductName":"DIC-Bldg 05-309", "UnitNumber":"309"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-223", "ProductName":"DIC-Bldg 05-223", "UnitNumber":"223"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-315", "ProductName":"DIC-Bldg 05-315", "UnitNumber":"315"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-313", "ProductName":"DIC-Bldg 05-313", "UnitNumber":"313"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-317", "ProductName":"DIC-Bldg 05-317", "UnitNumber":"317"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-316", "ProductName":"DIC-Bldg 05-316", "UnitNumber":"316"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-224", "ProductName":"DIC-Bldg 05-224", "UnitNumber":"224"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-112", "ProductName":"DIC-Bldg 05-112", "UnitNumber":"112"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-109", "ProductName":"DIC-Bldg 05-109", "UnitNumber":"109"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-110", "ProductName":"DIC-Bldg 05-110", "UnitNumber":"110"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-111", "ProductName":"DIC-Bldg 05-111", "UnitNumber":"111"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-205", "ProductName":"DIC-Bldg 05-205", "UnitNumber":"205"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-201", "ProductName":"DIC-Bldg 05-201", "UnitNumber":"201"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-203", "ProductName":"DIC-Bldg 05-203", "UnitNumber":"203"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-202", "ProductName":"DIC-Bldg 05-202", "UnitNumber":"202"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-204", "ProductName":"DIC-Bldg 05-204", "UnitNumber":"204"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-206", "ProductName":"DIC-Bldg 05-206", "UnitNumber":"206"}, {"LineItemName":"Renewal:  IBM Middle East - Bldg 5  (5 years) DIC-Bldg 05-FL2C1", "ProductName":"DIC-Bldg 05-FL2C1", "UnitNumber":"FL2C1"}]}]}} ');
               else if (req.getEndpoint().contains('callout:DCCA_Auth'))
                res.setBody('{"MethodName":"getLocations", "locationList":[{"totalArea":"662", "subleaseCompany":null, "SubCategory":"Office", "Status":"Active", "showOnLicen":false, "regOffFlag":null, "Recordtype":"Tecom CRM Integration", "prodList":[{"UnitNumber":"305", "regOff":false, "ProductName":"DIC-Bldg 05-305", "LineItemName":"a0sA0000000UgkOIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"206", "regOff":false, "ProductName":"DIC-Bldg 05-206", "LineItemName":"a0sA0000000UgkCIAS", "floor":"2", "buildingName":"5"}, {"UnitNumber":"204", "regOff":false, "ProductName":"DIC-Bldg 05-204", "LineItemName":"a0sA0000000UgkAIAS", "floor":"2", "buildingName":"5"}, {"UnitNumber":"202", "regOff":false, "ProductName":"DIC-Bldg 05-202", "LineItemName":"a0sA0000000Ugk8IAC", "floor":"2", "buildingName":"5"}, {"UnitNumber":"203", "regOff":false, "ProductName":"DIC-Bldg 05-203", "LineItemName":"a0sA0000000Ugk9IAC", "floor":"2", "buildingName":"5"}, {"UnitNumber":"201", "regOff":false, "ProductName":"DIC-Bldg 05-201", "LineItemName":"a0sA0000000Ugk7IAC", "floor":"2", "buildingName":"5"}, {"UnitNumber":"205", "regOff":false, "ProductName":"DIC-Bldg 05-205", "LineItemName":"a0sA0000000UgkBIAS", "floor":"2", "buildingName":"5"}, {"UnitNumber":"111", "regOff":false, "ProductName":"DIC-Bldg 05-111", "LineItemName":"a0sA0000000UgjtIAC", "floor":"1", "buildingName":"5"}, {"UnitNumber":"110", "regOff":false, "ProductName":"DIC-Bldg 05-110", "LineItemName":"a0sA0000000UgjsIAC", "floor":"1", "buildingName":"5"}, {"UnitNumber":"109", "regOff":false, "ProductName":"DIC-Bldg 05-109", "LineItemName":"a0sA0000000UgjrIAC", "floor":"1", "buildingName":"5"}, {"UnitNumber":"112", "regOff":false, "ProductName":"DIC-Bldg 05-112", "LineItemName":"a0sA0000000UgjuIAC", "floor":"1", "buildingName":"5"}, {"UnitNumber":"224", "regOff":false, "ProductName":"DIC-Bldg 05-224", "LineItemName":"a0sA0000000UgkJIAS", "floor":"2", "buildingName":"5"}, {"UnitNumber":"316", "regOff":false, "ProductName":"DIC-Bldg 05-316", "LineItemName":"a0sA0000000UgkZIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"317", "regOff":false, "ProductName":"DIC-Bldg 05-317", "LineItemName":"a0sA0000000UgkaIAC", "floor":"3", "buildingName":"5"}, {"UnitNumber":"313", "regOff":false, "ProductName":"DIC-Bldg 05-313", "LineItemName":"a0sA0000000UgkWIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"315", "regOff":false, "ProductName":"DIC-Bldg 05-315", "LineItemName":"a0sA0000000UgkYIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"223", "regOff":false, "ProductName":"DIC-Bldg 05-223", "LineItemName":"a0sA0000000UgkIIAS", "floor":"2", "buildingName":"5"}, {"UnitNumber":"309", "regOff":false, "ProductName":"DIC-Bldg 05-309", "LineItemName":"a0sA0000000UgkSIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"308", "regOff":false, "ProductName":"DIC-Bldg 05-308", "LineItemName":"a0sA0000000UgkRIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"322", "regOff":false, "ProductName":"DIC-Bldg 05-322", "LineItemName":"a0sA0000000UgkfIAC", "floor":"3", "buildingName":"5"}, {"UnitNumber":"220", "regOff":false, "ProductName":"DIC-Bldg 05-220", "LineItemName":"a0sA0000000UgkFIAS", "floor":"2", "buildingName":"5"}, {"UnitNumber":"314", "regOff":false, "ProductName":"DIC-Bldg 05-314", "LineItemName":"a0sA0000000UgkXIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"312", "regOff":false, "ProductName":"DIC-Bldg 05-312", "LineItemName":"a0sA0000000UgkVIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"307", "regOff":false, "ProductName":"DIC-Bldg 05-307", "LineItemName":"a0sA0000000UgkQIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"219", "regOff":false, "ProductName":"DIC-Bldg 05-219", "LineItemName":"a0sA0000000UgkEIAS", "floor":"2", "buildingName":"5"}, {"UnitNumber":"222", "regOff":false, "ProductName":"DIC-Bldg 05-222", "LineItemName":"a0sA0000000UgkHIAS", "floor":"2", "buildingName":"5"}, {"UnitNumber":"221", "regOff":true, "ProductName":"DIC-Bldg 05-221", "LineItemName":"a0sA0000000UgkGIAS", "floor":"2", "buildingName":"5"}, {"UnitNumber":"303", "regOff":false, "ProductName":"DIC-Bldg 05-303", "LineItemName":"a0sA0000000UgkMIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"310", "regOff":false, "ProductName":"DIC-Bldg 05-310", "LineItemName":"a0sA0000000UgkTIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"323", "regOff":false, "ProductName":"DIC-Bldg 05-323", "LineItemName":"a0sA0000000UgkgIAC", "floor":"3", "buildingName":"5"}, {"UnitNumber":"311", "regOff":false, "ProductName":"DIC-Bldg 05-311", "LineItemName":"a0sA0000000UgkUIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"302", "regOff":false, "ProductName":"DIC-Bldg 05-302", "LineItemName":"a0sA0000000UgkLIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"304", "regOff":false, "ProductName":"DIC-Bldg 05-304", "LineItemName":"a0sA0000000UgkNIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"301", "regOff":false, "ProductName":"DIC-Bldg 05-301", "LineItemName":"a0sA0000000UgkKIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"321", "regOff":false, "ProductName":"DIC-Bldg 05-321", "LineItemName":"a0sA0000000UgkeIAC", "floor":"3", "buildingName":"5"}, {"UnitNumber":"324", "regOff":false, "ProductName":"DIC-Bldg 05-324", "LineItemName":"a0sA0000000UgkhIAC", "floor":"3", "buildingName":"5"}, {"UnitNumber":"319", "regOff":false, "ProductName":"DIC-Bldg 05-319", "LineItemName":"a0sA0000000UgkcIAC", "floor":"3", "buildingName":"5"}, {"UnitNumber":"318", "regOff":false, "ProductName":"DIC-Bldg 05-318", "LineItemName":"a0sA0000000UgkbIAC", "floor":"3", "buildingName":"5"}, {"UnitNumber":"320", "regOff":false, "ProductName":"DIC-Bldg 05-320", "LineItemName":"a0sA0000000UgkdIAC", "floor":"3", "buildingName":"5"}, {"UnitNumber":"306", "regOff":false, "ProductName":"DIC-Bldg 05-306", "LineItemName":"a0sA0000000UgkPIAS", "floor":"3", "buildingName":"5"}, {"UnitNumber":"305", "regOff":false, "ProductName":"DIC-Bldg 05-305", "LineItemName":"a0sA0000000UgkOIAS", "floor":"3", "buildingName":"5"}], "OfficeNo":"305", "masterLocationLicense":"", "LocationId":"a1i5D0000001fhGQAQ", "licenseType":"Commercial License", "LicenseNo":"19299", "IsSubLease":"NO", "IsMainAdd":false, "Floor":"3", "error":"", "ContractStatusReason":null, "ContractStartDate":"2016-09-15", "ContractEnddate":"2021-09-14", "Category":"Office", "BusinessPark":"Dubai Internet City", "BuildingName":"5", "ArabicOfficeNo":"305", "ArabicFloor":"3", "ArabicBusinessUnit":"مدينة دبي للإنترنت", "ArabicBuildingName":"5", "AgreementNo":"AG-117256"}, {"totalArea":"0", "subleaseCompany":null, "SubCategory":null, "Status":"Active", "showOnLicen":false, "regOffFlag":null, "Recordtype":"Tecom CRM Integration", "prodList":[{"UnitNumber":"401", "regOff":false, "ProductName":"Building 08-401", "LineItemName":"a03w000000Ekwt4AAB", "floor":"4", "buildingName":"089"}, {"UnitNumber":"410", "regOff":false, "ProductName":"Building 08-410", "LineItemName":"a03w000000EkwtBAAR", "floor":"4", "buildingName":"089"}, {"UnitNumber":"413", "regOff":false, "ProductName":"Building 08-413", "LineItemName":"a03w000000EkwtCAAR", "floor":"4", "buildingName":"089"}, {"UnitNumber":"414", "regOff":false, "ProductName":"Building 08-414", "LineItemName":"a03w000000EkwtDAAR", "floor":"4", "buildingName":"089"}, {"UnitNumber":"415", "regOff":false, "ProductName":"Building 08-415", "LineItemName":"a03w000000EkwtEAAR", "floor":"4", "buildingName":"089"}], "OfficeNo":"415", "masterLocationLicense":"", "LocationId":"a1i5D0000001TjAQAU", "licenseType":"Commercial License", "LicenseNo":"19299", "IsSubLease":"NO", "IsMainAdd":false, "Floor":"4", "error":"", "ContractStatusReason":null, "ContractStartDate":"2015-08-16", "ContractEnddate":"2020-11-13", "Category":"Office", "BusinessPark":"Dubai Design District", "BuildingName":"089", "ArabicOfficeNo":"415", "ArabicFloor":"4", "ArabicBusinessUnit":"حي دبي للتصميم", "ArabicBuildingName":"089", "AgreementNo":"AG-6849"}], "LicnseNo":"19299", "errorCode":"0", "error":"", "act":[{"type":"Office", "titleList":null, "StartDate":"2016-03-31", "segName":"Design", "Name":"Consultancy", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a296F000004GUQfQAO", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2016-03-31", "segName":"Design", "Name":"Concept Design", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a296F000004GUQgQAO", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2016-03-31", "segName":"Design", "Name":"Information, Interface and Digital Design", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a296F000004GUQhQAO", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2014-02-24", "segName":"Executive Search", "Name":"Executive Search", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a2990000000h80VAAQ", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2014-02-24", "segName":"Human Resources Consultancy", "Name":"Organizational Restructuring and Reorganizing", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a2990000000h80aAAA", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2014-02-24", "segName":"Human Resources Consultancy", "Name":"Compensation, Benefits & Recognition", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a2990000000h80fAAA", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2014-02-24", "segName":"Human Resources Consultancy", "Name":"Career Development & Management", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a2990000000h80kAAA", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2003-12-22", "segName":"Consultancy", "Name":"Management Consultancy", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NGVIA2", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2009-04-01", "segName":"Software", "Name":"Solution Provider", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NHHIA2", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"IT Service", "Name":"Developer", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NKoIAM", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2003-12-22", "segName":"Regional Head Quarters", "Name":"Administration Office", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NKtIAM", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"IT Service", "Name":"Consultancy", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NKuIAM", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"IT Service", "Name":"Customer Service", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NLBIA2", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2009-04-01", "segName":"IT Service", "Name":"Solution Provider", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NPjIAM", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"IT Service", "Name":"Support Service Provider", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NQuIAM", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"Software", "Name":"Developer", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NSrIAM", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"Software", "Name":"Customer Service", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NStIAM", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"Software", "Name":"Support Service Provider", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NVIIA2", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"Software", "Name":"Consultancy", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NVVIA2", "accName":null}]}');
                else
                res.setBody('{"MethodName":"getActivities", "locationList":null, "LicnseNo":"19299", "errorCode":"0", "error":"", "act":[{"type":"Office", "titleList":null, "StartDate":"2016-03-31", "segName":"Design", "Name":"Consultancy", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a296F000004GUQfQAO", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2016-03-31", "segName":"Design", "Name":"Concept Design", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a296F000004GUQgQAO", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2016-03-31", "segName":"Design", "Name":"Information, Interface and Digital Design", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a296F000004GUQhQAO", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2014-02-24", "segName":"Executive Search", "Name":"Executive Search", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a2990000000h80VAAQ", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2014-02-24", "segName":"Human Resources Consultancy", "Name":"Organizational Restructuring and Reorganizing", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a2990000000h80aAAA", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2014-02-24", "segName":"Human Resources Consultancy", "Name":"Compensation, Benefits & Recognition", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a2990000000h80fAAA", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2014-02-24", "segName":"Human Resources Consultancy", "Name":"Career Development & Management", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a2990000000h80kAAA", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2003-12-22", "segName":"Consultancy", "Name":"Management Consultancy", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NGVIA2", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2009-04-01", "segName":"Software", "Name":"Solution Provider", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NHHIA2", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"IT Service", "Name":"Developer", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NKoIAM", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2003-12-22", "segName":"Regional Head Quarters", "Name":"Administration Office", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NKtIAM", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"IT Service", "Name":"Consultancy", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NKuIAM", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"IT Service", "Name":"Customer Service", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NLBIA2", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2009-04-01", "segName":"IT Service", "Name":"Solution Provider", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NPjIAM", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"IT Service", "Name":"Support Service Provider", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NQuIAM", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"Software", "Name":"Developer", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NSrIAM", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"Software", "Name":"Customer Service", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NStIAM", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"Software", "Name":"Support Service Provider", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NVIIA2", "accName":null}, {"type":"Office", "titleList":null, "StartDate":"2008-04-01", "segName":"Software", "Name":"Consultancy", "LicenseNo":"19299", "error":"", "chanList":null, "ActivityId":"a29D00000004NVVIA2", "accName":null}]}');
               res.setStatusCode(200);
               return res;
           }
        }
}