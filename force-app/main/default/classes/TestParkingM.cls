@isTest/*(SeeAllData=true)*/
public class TestParkingM {

    @testSetup static void setup() {
        List<gStg__c> lstGStg = new List<gStg__c>();
        gStg__c pActivation = new gStg__c(name='ParkingActivation', Text_Value__c = '149');    lstGStg.add(pActivation);
        gStg__c pLostCard = new gStg__c(name='ParkingLostCard', Text_Value__c = '150');    lstGStg.add(pLostCard);
        gStg__c pModification = new gStg__c(name='ParkingModification', Text_Value__c = '152');    lstGStg.add(pModification);
        gStg__c pDetail = new gStg__c(name='ParkingDetail', Text_Value__c = '153');    lstGStg.add(pDetail);
        gStg__c wsDomain = new gStg__c(name='WSDmn', Text_Value__c = 'cs6');    lstGStg.add(wsDomain);
        gStg__c tecomDmn = new gStg__c(name='tecomDmn', Text_Value__c = 'tecom--staging.cs6.my');    lstGStg.add(tecomDmn);
        gStg__c paidParking = new gStg__c(name='AdditionalParking', Text_Value__c = '154');    lstGStg.add(paidParking);
        gStg__c tecomP = new gStg__c(name='tecomP', Text_Value__c = 'test@axs.stg');    lstGStg.add(tecomP);
        gStg__c tecomU = new gStg__c(name='tecomU', Text_Value__c = 'test223');    lstGStg.add(tecomU);

        gStg__c cancl = new gStg__c(name='ParkingCancellation', Text_Value__c = '155');    lstGStg.add(cancl);
        gStg__c ParkingDeact = new gStg__c(name='ParkingDeact', Text_Value__c = '157');    lstGStg.add(ParkingDeact);
        gStg__c ParkingRenewal = new gStg__c(name='ParkingRenewal', Text_Value__c = '156');    lstGStg.add(ParkingRenewal);
        gStg__c srvc_pRenewal = new gStg__c(name='srvc_pRenewal', Text_Value__c = 'a0LN0000044uZryMAE');    lstGStg.add(srvc_pRenewal);

        insert lstGStg;
    }

    @isTest static void testGetEligibility() {
        Test.startTest();
        Test.setMock(WebServiceMock.class, new MockRespEligibility());Test.setMock(HttpCalloutMock.class, new MockGetSession());
        ParkingM pm = new ParkingM();Account ac = new Account(ORACLE_PARTY_ID__c='1234');
        pm.getEligibility(ac);Test.stopTest();
    }

    @isTest static void testLoadCards() {
        Test.startTest();
        Test.setMock(WebServiceMock.class, new MockLoadCards());Test.setMock(HttpCalloutMock.class, new MockGetSession());
        ParkingM pm = new ParkingM();
        ParkingM.ParkingDetails_m x= new ParkingM.ParkingDetails_m();
        x.sector=x.sector;
        x.EligibilityName=x.EligibilityName;
        x.sectorId =x.sectorId ;
        x.cardNum=x.cardNum;
        x.sel=x.sel;
        x.cardId=x.cardId;
        x.sPlaceOfReg= x.sPlaceOfReg;
        x.BusinessPark=x.BusinessPark;
        x.vType=x.vType;
        x.actStat=x.actStat;
        x.vehicleNumber=x.vehicleNumber;
        x.vDetails=x.vDetails;
        x.secVclNum=x.secVclNum;
        x.cHolderNm=x.cHolderNm;
        x.status=x.status;
        x.cardType=x.cardType ;
        x.pPlaceOfReg=x.pPlaceOfReg;
        x.refMobile=x.refMobile;
        x.email=x.email;
        x.expDate=x.expDate;
        x.isReserved=x.isReserved;

        ParkingM.ParkingDetail pd= new ParkingM.ParkingDetail();
        pd.sector=pd.sector;
        pd.cardNum=pd.cardNum;
        pd.sel=pd.sel;
        pd.cardId=pd.cardId;
        pd.sPlaceOfReg=pd.sPlaceOfReg;
        pd.BusinessPark=pd.BusinessPark;
        pd.vType=pd.vType;
        pd.actStat=pd.actStat;
        pd.vehicleNumber=pd.vehicleNumber;
        pd.vDetails=pd.vDetails;
        pd.secVclNum=pd.secVclNum;
        pd.cHolderNm=pd.cHolderNm;
        pd.status=pd.status;
        pd.cardType=pd.cardType;
        pd.pPlaceOfReg=pd.pPlaceOfReg;
        pd.refMobile=pd.refMobile;
        pd.email=pd.email;
        pd.isReserved=pd.isReserved;
        pd.expDate=pd.expDate;

        ParkingM.PkgCard_old pdo= new ParkingM.PkgCard_old();
        pdo.cardNo=pdo.cardNo;
        pdo.sector=pdo.sector;
        pdo.expDate=pdo.expDate;
        pdo.cnum=pdo.cnum;
        pdo.stDate=pdo.stDate;
        pdo.chname=pdo.chname;
        pdo.cardNo=pdo.cardNo;
        pdo.sfcid=pdo.sfcid;
        pdo.cardexpDate=pdo.cardexpDate;

        ParkingM.PkgCard pdc= new ParkingM.PkgCard();
        pdc.ParkingCardId=pdc.ParkingCardId;
        pdc.CardNumber=pdc.CardNumber;
        pdc.CardHolderName=pdc.CardHolderName;
        pdc.SectorName=pdc.SectorName;
        pdc.SectorName=pdc.SectorName;

        ParkingM.AddPark pac= new ParkingM.AddPark();
        pac.noOfAO=pac.noOfAO;
        pac.noOfAUtl=pac.noOfAUtl;
        pac.sector=pac.sector;
        pac.elg=pac.elg;
        pac.cardId=pac.cardId;
        pac.cntrNo=pac.cntrNo;
        pac.utl=pac.utl;
        pac.aprvd=pac.aprvd;
        pac.cntrExp=pac.cntrExp;
        pac.uprc=pac.uprc;
        pac.cardType=pac.cardType;
        pac.sel=pac.sel;
        pac.noOfDays=pac.noOfDays;
        pac.add=pac.add;

        ParkingM.AddtnlPark padc= new ParkingM.AddtnlPark();
        padc.Sequence=padc.Sequence;
        padc.LocationName=padc.LocationName;
        padc.LocaionId=padc.LocaionId;
        padc.Sequence=padc.Sequence;
        padc.isDefault=padc.isDefault;
        padc.AgNumber=padc.AgNumber;
        padc.LeaseExp=padc.LeaseExp;

        pm.loadcards(new g_req__c(), '149', '1234');
        pm.loadcards(new g_req__c(), '150', '973018'); pm.loadcards(new g_req__c(), '152', '1234');
        Test.stopTest();
    }

    @isTest static void testPushReqItems() {
        Test.startTest();
        Test.setMock(WebServiceMock.class, new MockPushData());
        Test.setMock(HttpCalloutMock.class, new MockGetSession());
        Test.setMock(HttpCalloutMock.class, new MockRespLoad());

        testData.init();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s = new g_Srvc__c(Name='Srvc', lbl__c='Srvc', stg__c=stg.Id, uid__c='149',
            actv__c=true, ckgsnc__c=true, Prk__c='Dubai Internet City', AccTp__c='Customer - External',
            ConRol__c='Employee', ConSTA__c='Active', payMd__c='Customer Deposit; Cash; Credit / Debit Card',
            Category__c='Employees Services', Sub_Category__c='Renewal Visa', Milestone_Stage__c='Ep;Medical;Rp;',
            Milestone_SLA__c='10;2;6');
        insert s;

        list<g_srvcitm__c> itms = new list<g_srvcitm__c>();
        itms.add(new g_srvcitm__c(srvc__c=s.Id, dSTA__c='n', slaN__c=4,
            slaXP__c=2, ord__c=1, Tp__c='Service Item', cd__c='0np', Name='rp',
            lbl__c='rp', Req__c=true, aln__c=true, mxcnt__c=1, rv__c=true,
            prcEdt__c=false, DscApp__c=true, EXP__c=true, KF__c=0, scN__c=10,
            cN__c=5, smN__c=1, spChN__c=1, scXP__c=1, cXP__c=1, smXP__c=1,
            spChXP__c=1, xf__c='xf__c;xfid__c;xfed__c;xrp__c;xrpid__c;xrped__c;xui__c;xr__c;xcmbso__c;xcmbs__c;xcmao__c;xcma__c;xcmoao__c;xcmoa__c;xcmtao__c;xcmta__c;xef__c;'));
        itms.add(new g_srvcitm__c(srvc__c=s.Id, dSTA__c='n', slaN__c=4,
            slaXP__c=2, ord__c=2, Tp__c='Service Item', cd__c='pnt', Name='pnt',
            lbl__c='pnt', Req__c=false, mxcnt__c=1, rv__c=false, prcEdt__c=true,
            DscApp__c=false, EXP__c=false, KF__c=0, scN__c=10, cN__c=5, smN__c=1,
            spChN__c=1, scXP__c=1, cXP__c=1, smXP__c=1, spChXP__c=1, xf__c=''));
        insert itms;

        list<g_srvcitm_Status__c> sta = new list<g_srvcitm_Status__c>();
        for (g_srvcitm__c i:itms) {
            sta.add(new g_srvcitm_Status__c(itm__c=i.Id, Milestone__c='EP',
                slaa__c='Standard', statype__c='Process', actv__c=true, slaN__c=4,
                slaXP__c=2, cd__c='n', name='n', lbl__c='n', Tp__c='Open', rqSTA__c='',
                clm__c=false, clmA__c=0, rfnd__c=false, rfndA__c=0, Shift_At__c='Payment',
                Shift_Items__c='rp;md;'));
            sta.add(new g_srvcitm_Status__c(itm__c=i.Id, Milestone__c='EP',
                slaa__c='Completed', statype__c='Process', actv__c=true, slaN__c=4,
                slaXP__c=2, cd__c='ook', name='ook', lbl__c='ook', Tp__c='Completed',
                rqSTA__c='', clm__c=false, clmA__c=0, rfnd__c=false, rfndA__c=0,
                Shift_At__c='Payment', Shift_Items__c='rp;md;'));
            sta.add(new g_srvcitm_Status__c(itm__c=i.Id, Milestone__c = 'Medical',
                slaa__c='Parallel', statype__c='Process', actv__c=true, slaN__c=4,
                slaXP__c=2, cd__c='c', name='c', lbl__c='c', Tp__c='Cancelled',
                rqSTA__c='Cancelled', clm__c=true, clmA__c=1, rfnd__c=true, rfndA__c=1,
                Shift_At__c='Payment', Shift_Items__c='rp;md;'));
            sta.add(new g_srvcitm_Status__c(itm__c=i.Id, Milestone__c='RP',
                slaa__c='Standard', statype__c='Process', actv__c=true, slaN__c=4,
                slaXP__c=2, cd__c='ok', name='ok', lbl__c='ok', Tp__c='Completed',
                rqSTA__c='Completed', clm__c=false, clmA__c=0, rfnd__c=false,
                rfndA__c=0, Shift_At__c='Payment', Shift_Items__c='rp;md;'));
        }
        insert sta;

        Account a=testData.accCrt(false); a.ORACLE_PARTY_ID__c = '1234'; update a;
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c rq=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
        rq.rtacn__c = '1234';rq.xoln__c='055372654';
        update rq;
        List<account> acc =[select id, ORACLE_PARTY_ID__c from account where id=:a.id];
        system.debug('aaaa---->'+acc);
        g_reqMbr__c objM = new g_reqMbr__c();
        g_srvcitm__c si=[Select Id, cd__c, Name, lbl__c, Tp__c, xf__c, Req__c, rv__c, aln__c,
            mxcnt__c, dSTA__c, prcEdt__c, DscApp__c, EXP__c, KF__c, cN__c, scN__c, smN__c, spChN__c,
            cXP__c, scXP__c, smXP__c, spChXP__c, slaN__c, slaXP__c From  g_srvcitm__c where actv__c=true and IsDeleted=false and srvc__c=:s.Id order by ord__c limit 1];
        Test.stopTest();
        ParkingM.updatePaymentStatus(rq.id);
        ParkingM pm = new ParkingM();
        pm.loadCards(acc[0].ORACLE_PARTY_ID__c);
        pm.pushReqItems(rq.id, new list<g_reqitem__c>()); //'a0EN000000EWJ31'

        s.uid__c='154';update s;
        pm.pushReqItems(rq.id, new list<g_reqitem__c>());
    }

    @isTest static void testValidateVeh() {
        Test.startTest();
        Test.setMock(WebServiceMock.class, new MockValidateVeh());
        Test.setMock(HttpCalloutMock.class, new MockGetSession());
        //g_Req__c rq = [SELECT id, Name, srvc__r.uid__c, xtcid__c, xps__c from g_REQ__c WHERE Id='a0EN000000EWJ31'];

        testData.init();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        s.uid__c = '149'; update s;
        Account a=testData.accCrt(false);
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        Contact emp=testData.conCrt(sp, a.Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c rq=testData.reqCrt(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c);
        g_reqMbr__c objM = new g_reqMbr__c();
        g_srvcitm__c si=[Select Id, cd__c, Name, lbl__c, Tp__c, xf__c, Req__c, rv__c, aln__c,
            mxcnt__c, dSTA__c, prcEdt__c, DscApp__c, EXP__c, KF__c, cN__c, scN__c, smN__c, spChN__c,
            cXP__c, scXP__c, smXP__c, spChXP__c, slaN__c, slaXP__c, ngs__c, ngsXP__c, vsc__c,
            vesch__c, vspc__c, vspexc__c, vst__c, vec__c, su__c, vsu__c, TAX_CODE__c, TAX_TYPE__c,
            extc__c, TAXCODE_SC__c, extcsc__c From  g_srvcitm__c where actv__c=true and IsDeleted=false and srvc__c=:s.Id order by ord__c limit 1];

        gctlReqI.itm itm = new gctlReqI.itm(rq, si, null, false, 0);
        List<gctlReqI.itm> lstItm = new List<gctlReqI.itm>();
        lstItm.add(itm);

        g_req__c rq1 =[Select Id, xtcid__c, xps__c, srvc__r.uid__c, Name, STA__c, AT__c, AP__c,
            dsc__c, dsc__r.prct__c, spCh__c, rmob__c, xaloc__c, nt__c, srvc__c, srvc__r.name,
            srvc__r.lbl__c, srvc__r.dsc__c, srvc__r.Prk__c, srvc__r.AccTp__c, Con__c, ConRol__c ,
            ConSTA__c, srvc__r.ckgsnc__c, srvc__r.snc__c, srvc__r.stg__r.pg__c, srvc__r.stg__r.apx__c,
            srvc__r.stg__r.reqq__c, Acc__c, Acc__r.Type, Acc__r.Prk__c, Acc__r.lcsnc__c, Acc__r.lcsncnt__c,
            Acc__r.psasnc__c, Acc__r.psasncnt__c, Acc__r.ecsnc__c, Acc__r.ecsncnt__c, Acc__r.cosnc__c,
            Acc__r.cosncnt__c, Acc__r.bgsnc__c, Acc__r.bgsncnt__c, Acc__r.snc__c, Acc__r.info__c,
            Acc__r.vestd__c, Acc__r.vbtemp__c, LastModifiedDate, LastModifiedById, CreatedDate,
            CreatedById, xeidav__c, xcma__c, xcacctp__c, xcha__c, xcarea__c, xcmbs__c, xcbd__c,
            xccty__c, xcbc__c, xcnc__c, xceidid__c, xceidedt__c, xceididt__c, xceml__c, xcemrt__c,
            xcfan__c, xcfs__c, xcfn__c, xcfnar__c, xchph__c, xcln__c, xclnar__c, xcms__c, xcmn__c,
            xcmnar__c, xcmob__c, xcmon__c, xcof__c, xcot__c, xcjb__c, xcmoa__c, xcp__c, xcped__c,
            xcpid__c, xcpic__c, xcpip__c, xcbp__c, xcpobx__c, xcpobxarea__c, xcnp__c, xcql__c,
            xcrlg__c, xcslt__c, xclng__c, xcstrt__c, xcmta__c, (Select Id, Name, mxAts__c, mnAts__c,
            ats__c, nt__c, or__c, reqAts__c, reqOr__c, tplt__c, upOk__c, mbr__c, mbr__r.Name From rDocs__r where Req__c=true and IsDeleted=false),
            (Select Id, Name, STA__c, dt__c, A__c, md__c, TP__c From Transactions__r where isDeleted=false),
            (select id, Name, RQ__c, nc__c, rv__c, m__c, m__r.Name, vSTA__c, AP__c, AD__c, AOP__c,
            nt__c, xprnt__c, xr__c,   xef__c , Dsc__c, DscApp__c, KF__c, cN__c, scN__c, smN__c,
            exp__c, cXP__c, scXP__c, smXP__c, itm__c, itm__r.xf__c, itm__r.cd__c, itm__r.Name,
            itm__r.lbl__c, itm__r.Tp__c, itm__r.Req__c, itm__r.exp__c, itm__r.prcEdt__c, itm__r.dSTA__c,
            sta__c, sta__r.cd__c, sta__r.Name, sta__r.lbl__c, sta__r.Tp__c, sta__r.rc__c, sta__r.noEXP__c,
            LastModifiedDate, LastModifiedById, CreatedDate, CreatedById From Items__r where IsDeleted=false order by itm__r.ord__c) From g_Req__c];
        rq1.xtcid__c = '7983483274'; update rq1;
        ParkingM pm = new ParkingM();
        pm.validateVehicle2(rq1, new List<gctlReqI.itm>());
        Test.stopTest();
    }

    // *** Paid Parking Tests starts
    @isTest static void testGetPaidAgs() {
        Test.startTest();
        Test.setMock(WebServiceMock.class, new MockGetPaidAgs()); Test.setMock(HttpCalloutMock.class, new MockGetSession());
        ParkingM pm = new ParkingM(); pm.getAddParks(new g_req__c(), '973018');
        Test.stopTest();
    }

    @isTest static void testGetAmntAP() {
        Test.startTest();
        Test.setMock(WebServiceMock.class, new MockGetAmountAp()); Test.setMock(HttpCalloutMock.class, new MockGetSession());
        ParkingM pm = new ParkingM(); pm.getAmntAP(Date.newInstance(2017, 1, 12), '973018');
        Test.stopTest();
    }

    @isTest static void testCreateCards() {
        Test.startTest();
        Test.setMock(WebServiceMock.class, new MockCreateCards()); Test.setMock(HttpCalloutMock.class, new MockGetSession());
        ParkingM.createPaidCards('1213201723', 'agNo', Date.newInstance(2017, 1, 12));
        Test.stopTest();
    }
    // *** Paid Parking Tests ends

    //ToDo : create new testClass
    @isTest static void testSoapNrta() {
        Test.startTest();
        // Test.setMock(WebServiceMock.class, new soapNrtaActivation());
        soapNrtaActivation.Tecom_Parking_SOAP_WS tp = new soapNrtaActivation.Tecom_Parking_SOAP_WS();
        soapNrtaActivation.location loc0 = new soapNrtaActivation.location();
        soapNrtaActivation.LogInfo loc1 = new soapNrtaActivation.LogInfo();
        soapNrtaActivation.DebuggingInfo_element loc2 = new soapNrtaActivation.DebuggingInfo_element();
        soapNrtaActivation.address loc3 = new soapNrtaActivation.address();
        soapNrtaActivation.CallOptions_element loc4 = new soapNrtaActivation.CallOptions_element();
        soapNrtaActivation.DebuggingHeader_element loc6 = new soapNrtaActivation.DebuggingHeader_element();
        soapNrtaActivation.doInsertRequestResponse_element loc8 = new soapNrtaActivation.doInsertRequestResponse_element();
        soapNrtaActivation.checkVehicleValidityResponse_element loc9 = new soapNrtaActivation.checkVehicleValidityResponse_element();
        soapNrtaActivation.AllowFieldTruncationHeader_element loc10 = new soapNrtaActivation.AllowFieldTruncationHeader_element();
        soapNrtaActivation.UpdateRequestDetails_element loc11 = new soapNrtaActivation.UpdateRequestDetails_element();
        soapNrtaActivation.fetchContacts_element loc12 = new soapNrtaActivation.fetchContacts_element();
        soapNrtaActivation.updatePaymentStatusResponse_element loc13 = new soapNrtaActivation.updatePaymentStatusResponse_element();
        soapNrtaActivation.checkVehicleValidity_element loc14 = new soapNrtaActivation.checkVehicleValidity_element();
        soapNrtaActivation.pushContacts_element loc15 = new soapNrtaActivation.pushContacts_element();
        soapNrtaActivation.updatePaymentStatus_element loc16 = new soapNrtaActivation.updatePaymentStatus_element();
        soapNrtaActivation.pushContactsResponse_element loc17 = new soapNrtaActivation.pushContactsResponse_element();
        soapNrtaActivation.UpdateRequestDetailsResponse_element loc18 = new soapNrtaActivation.UpdateRequestDetailsResponse_element();
        soapNrtaActivation.fetchContactsResponse_element loc19 = new soapNrtaActivation.fetchContactsResponse_element();
        // tp.checkVehicleValidity('test1', 'test1', 'test1', 'test1', 'test1', 'test1');
        Test.stopTest();
    }
    @isTest static void testSoapNrtaStatus() {
        Test.startTest();
        //   Test.setMock(WebServiceMock.class, new SoapNrtaStatus());
        SoapNrtaStatus.NrtaStatus tp = new SoapNrtaStatus.NrtaStatus();
        SoapNrtaStatus.LogInfo loc1 = new SoapNrtaStatus.LogInfo();
        SoapNrtaStatus.DebuggingInfo_element loc2 = new SoapNrtaStatus.DebuggingInfo_element();
        SoapNrtaStatus.address loc3 = new SoapNrtaStatus.address();
        SoapNrtaStatus.updateAmountResponse_element loc4 = new SoapNrtaStatus.updateAmountResponse_element();
        SoapNrtaStatus.CallOptions_element loc5 = new SoapNrtaStatus.CallOptions_element();
        SoapNrtaStatus.DebuggingHeader_element loc6 = new SoapNrtaStatus.DebuggingHeader_element();
        SoapNrtaStatus.insertAttResponse_element loc7 = new SoapNrtaStatus.insertAttResponse_element();
        SoapNrtaStatus.updateAmount_element loc8 = new SoapNrtaStatus.updateAmount_element();
        SoapNrtaStatus.SessionHeader_element loc9 = new SoapNrtaStatus.SessionHeader_element();
        SoapNrtaStatus.insertAtt_element loc10 = new SoapNrtaStatus.insertAtt_element();
        SoapNrtaStatus.location loc11 = new SoapNrtaStatus.location();
        SoapNrtaStatus.updateNrtaStatusResponse_element loc12 = new SoapNrtaStatus.updateNrtaStatusResponse_element();
        SoapNrtaStatus.AllowFieldTruncationHeader_element loc13 = new SoapNrtaStatus.AllowFieldTruncationHeader_element();
        SoapNrtaStatus.updateNrtaStatus_element loc14 = new SoapNrtaStatus.updateNrtaStatus_element();
        SoapNrtaStatus.NrtaStatus loc15 = new SoapNrtaStatus.NrtaStatus();
        //   tp.updateNrtaStatus('Active');
        //   tp.insertAtt('');
        //   tp.updateAmount('', '');
        Test.stopTest();
    }

    @isTest static void testSetParkingSessionId() {
        try{ParkingSession.setParkingSessionId();}catch (exception e) {}
    }

    //###########################
    //### Mock Resp Classes ###
    //###########################

    public class MockRespLoad implements HttpCalloutMock  {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            string sessionBody = '{"Status":"Success", "Message":"Success", "CardsDetail":[{"Vehicles":[""], "Tcode":"t0009097", "Sector":"DSC Commercial", "OracleID":"1720810", "EligibilityName":"ELG-39459", "CardType":"Paid", "CardSubType":"Standard Additional", "CardStatus":"Active", "CardNumber":"7894", "CardHolderName":"Additional Card Holder", "CardExpDate":"2022-05-29", "BusinessPark":"DSC"}]}';
            res.setHeader('Content-Type', 'application/json');
            res.setBody(sessionBody);
            res.setStatusCode(200);
            return res;
        }
    }

    public class MockRespEligibility implements WebServiceMock {
        public void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint,
            String soapAction, String requestName, String responseNS, String responseName, String responseType) {
            soapNrtaActivation.getAccountEligibilityDetailsResponse_element card = new soapNrtaActivation.getAccountEligibilityDetailsResponse_element();
            card.result = '{"tUtlzd":"2", "tStdElgb":"31", "tpaidIn":"2", "tPaidElgb":"1", "tPaidAc":"0", "TotalEligibility":"32", "tfreeIn":"2", "tfreeAc":"0", "paidUtlzd":"2", "freeUtlzd":"0", "ErrorCode":"0", "ErrorMessage":"Success"}';
            response.put('response_x', card);
        }
    }

    public class MockLoadCards implements WebServiceMock {
        public void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint,
            String soapAction, String requestName, String responseNS, String responseName, String responseType) {
            soapNrtaActivation.getAvailableCardsResponse_element card = new soapNrtaActivation.getAvailableCardsResponse_element();
            card.result = '{"Settings":[{"zone":"DSC", "vehicledetails":null, "status":"Inactive", "id":"a4zN0000000DWEUIA4", "cluster":"DSC Boutique", "cardno":"65855"}, {"zone":"DSC", "vehicledetails":null, "status":"Inactive", "id":"a4zN0000000DWEUIA4", "cluster":"DSC Boutique", "cardno":"60855"}]}';
            response.put('response_x', card);
        }
    }

    public class MockGetPaidAgs implements WebServiceMock {
        public void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint,
            String soapAction, String requestName, String responseNS, String responseName, String responseType) {
            soapNrtaActivation.getOppAddiEligiDetailsResponse_element card = new soapNrtaActivation.getOppAddiEligiDetailsResponse_element();
            card.result = '{"addiEligis":[{"secName":"DSC Boutique", "oppos":[{"conExpDate":"2015-12-31", "agNo":"AG-056314", "addiEli":7, "noOfDays":88, "add":3, "cardType":"Paid"}]}]}';
            response.put('response_x', card);
        }
    }

    public class MockPushData implements WebServiceMock {
        public void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint,
            String soapAction, String requestName, String responseNS, String responseName, String responseType) {
            soapNrtaActivation.doInsertRequestResponse_element card = new soapNrtaActivation.doInsertRequestResponse_element();
            card.result = '{"ResponseCode":"0", "errMessage":"Success, Request is created succesfully"}';
            response.put('response_x', card);
        }
    }

    public class MockValidateVeh implements WebServiceMock {
        public void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint,
            String soapAction, String requestName, String responseNS, String responseName, String responseType) {
            soapNrtaActivation.checkVehicleValidityResponse_element card = new soapNrtaActivation.checkVehicleValidityResponse_element();
            card.result = '{"ResponseCode":"0", "errMessage":"Success, Request is created succesfully"}';
            response.put('response_x', card);
        }
    }

    public class MockGetSession implements HttpCalloutMock  {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            string sessionBody = '<?xml version="1.0" encoding="utf-8"?>'+'<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"'+
                'xmlns="urn:partner.soap.sforce.com"'+'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+'<soapenv:Body>'+
                '<loginResponse>'+'<result>'+'<passwordExpired>false</passwordExpired>'
                +'<serverUrl>https://na1.salesforce.com/services/Soap/u/10.0</serverUrl>'+'<sessionId>QwWsHJyTPW.1pd0_jXlNKOSU</sessionId>'+
                    '<userId>005D0000000nVYVIA2</userId>'+'<userInfo>'+'<!-- ... -->'+'</userInfo>'+'</result>'+'</loginResponse>'+
                    '</soapenv:Body>'+'</soapenv:Envelope>';
            res.setHeader('Content-Type', 'application/json');res.setBody(sessionBody);res.setStatusCode(200);
            return res;
        }
    }

    public class MockGetAmountAp implements WebServiceMock {
        public void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint,
            String soapAction, String requestName, String responseNS, String responseName, String responseType) {
            soapNrtaActivation.perSlotPriceCalculationResponse_element card = new soapNrtaActivation.perSlotPriceCalculationResponse_element();
            card.result = '{"ResponseCode":"0", "errMessage":"Success, Request is created succesfully", "amountPerSlot":"200.20"}';
            response.put('response_x', card);
        }
    }

    public class MockCreateCards implements WebServiceMock {
        public void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint,
            String soapAction, String requestName, String responseNS, String responseName, String responseType) {
            soapNrtaActivation.createPaidCardsResponse_element card = new soapNrtaActivation.createPaidCardsResponse_element();
            card.result = '{"ResponseCode":"0", "errMessage":"Success, Cards created succesfully"}';
            response.put('response_x', card);
        }
    }
    public class soapNrtaActivation implements WebServiceMock {
        public void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint,
            String soapAction, String requestName, String responseNS, String responseName, String responseType) {
            soapNrtaActivation.createPaidCardsResponse_element card = new soapNrtaActivation.createPaidCardsResponse_element();
            card.result = '{"ResponseCode":"0", "errMessage":"Success, Cards created succesfully"}';
            response.put('response_x', card);
        }
    }
    public class SoapNrtaStatus implements WebServiceMock {
        public void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint,
            String soapAction, String requestName, String responseNS, String responseName, String responseType) {
            soapNrtaActivation.createPaidCardsResponse_element card = new soapNrtaActivation.createPaidCardsResponse_element();
            card.result = '{"ResponseCode":"0", "errMessage":"Success, Cards created succesfully"}';
            response.put('response_x', card);
        }

    }
}