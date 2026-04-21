@isTest
private class GDRFAUtilTest {
    static g_reqitem__c reqIm;
    static void loadData(String app) {
        testData.init();
        list < gStg__c > stgs = new list < gStg__c > ();
        stgs.add(new gStg__c(Name = 'GDRFAEntryPermitID', Checkbox_Value__c = true, Text_Value__c = 'Test', Number_Value__c = 0, Currency_Value__c = 0));
        stgs.add(new gStg__c(Name = 'GDRFAResidenceID', Checkbox_Value__c = true, Text_Value__c = 'Test', Number_Value__c = 0, Currency_Value__c = 0));
        stgs.add(new gStg__c(Name = 'GDRFARenewResidenceID', Checkbox_Value__c = true, Text_Value__c = 'Test', Number_Value__c = 0, Currency_Value__c = 0));
        stgs.add(new gStg__c(Name = 'GDRFACancelResidenceID', Checkbox_Value__c = true, Text_Value__c = 'Test', Number_Value__c = 0, Currency_Value__c = 0));
        stgs.add(new gStg__c(Name = 'GDRFAAPI', Checkbox_Value__c = true, Text_Value__c = 'Test', Number_Value__c = 0, Currency_Value__c = 0));
        stgs.add(new gStg__c(Name = 'GDRFAAPIKey', Checkbox_Value__c = true, Text_Value__c = 'Test', Number_Value__c = 0, Currency_Value__c = 0));
        stgs.add(new gStg__c(Name = 'OCR_APIKEY', Checkbox_Value__c = true, Text_Value__c = 'Test', Number_Value__c = 0, Currency_Value__c = 0));
        stgs.add(new gStg__c(Name = 'OCR_ENDPOINT', Checkbox_Value__c = true, Text_Value__c = 'Test', Number_Value__c = 0, Currency_Value__c = 0));
        insert stgs;
        g_srvc_settings__c stg = testData.stgCrt();
        stg.Name = 'Employment Visa';
        stg.pg__c = 'grqev';
        //stg.iapx__c='grqI.evI';
        stg.json__c = 'json_ev';
        stg.reqbrules__c = 'evRQ';
        stg.itmbrules__c = 'evITM';
        stg.reqq__c = 'Select Con__c,xard__c,Con__r.Spon__r.xpmi__c,Con__r.Spon__r.pobx__c,Con__r.Spon__r.idtxt__c,Con__r.Spon__r.Name,Con__r.Spon__r.xpno__c,Con__r.Spon__r.intp__c,Con__r.Spon__r.Birthdate,Spr__r.idtxt__c,Spr__r.xpno__c,Spr__r.xpmi__c,Spr__r.intp__c,Spr__r.Birthdate,i_STA__c,xtpa__c,Id,Name,STA__c,AT__c,AP__c,AOP__c,xdtcls__c,dsc__c,dsc__r.prct__c,xfpc__c,spCh__c,rmob__c,xawb__c,xaloc__c,xbrnd__c,xbn__c,nt__c,srvc__r.uid__c, ConRol__c ,xadh__c,xpgs__c,InsChk__c,xintp__c,Con__r.rol__c,Con__r.firstname,con__r.LastName,con__r.emrt__c,con__r.p__c,Con__r.Email,Con__r.MobilePhone,Con__r.Salutation,Con__r.ms__c,Con__r.nc__c,Con__r.eidid__c,Con__r.pobx__c,Con__r.mbs__c,Con__r.ma__c,Con__r.mta__c,Con__r.moa__c,Con__r.Birthdate,Con__r.rpui__c,srvc__c,srvc__r.name,srvc__r.lbl__c,srvc__r.dsc__c,srvc__r.Prk__c,srvc__r.AccTp__c, srvc__r.ckgsnc__c,srvc__r.snc__c,srvc__r.stg__r.pg__c,srvc__r.stg__r.apx__c,srvc__r.stg__r.reqq__c, Acc__c,Acc__r.Name,Acc__r.lcedt__c ,Acc__r.mtc__c,Acc__r.Type,Acc__r.Prk__c,Acc__r.lcsnc__c,Acc__r.lcsncnt__c,Acc__r.psasnc__c,Acc__r.psasncnt__c,Acc__r.ecsnc__c,Acc__r.ecsncnt__c, Acc__r.cosnc__c,Acc__r.cosncnt__c,Acc__r.bgsnc__c,Acc__r.bgsncnt__c,Acc__r.snc__c,Acc__r.info__c,Acc__r.vestd__c,Acc__r.vbtemp__c,Acc__r.sncNt__c,LastModifiedDate,LastModifiedById,CreatedDate,CreatedById,CreatedBy.Name, xeidav__c,xcma__c,xcacctp__c,xcha__c,xcarea__c,xcmbs__c,xcbd__c,xccty__c,xcbc__c,xcnc__c,xceidid__c,xceidedt__c,xceididt__c, xceml__c,xcemrt__c,xcfan__c,xcfs__c,xcfn__c,xcfnar__c,xchph__c,xcln__c,xclnar__c,xcms__c,xcmn__c,xcmnar__c,xcmob__c,xcmon__c, xcof__c,xcot__c,xcjb__c,xcmoa__c,xcp__c, xcped__c,xcpid__c,xcpic__c,xcpip__c,xcbp__c,xcpobx__c,xcpobxarea__c,xcnp__c,xcql__c, xcrlg__c,xcslt__c,xclng__c,xcstrt__c,xcmta__c,xdedc__c,xdedln__c,xosa__c, xphid__c,xcs__c,xcn__c,Zone__c,Full_Name__c,amsgs__c,action__c,xspn__c,xinsv__c,xppsfv__c,(select id,Name,estE__c,actE__c,kstp__c,sla__c,acts__c,itm__c,itm__r.exp__c,itm__r.itm__r.exp__c,itm__r.itm__r.Name,itm__r.itm__r.lbl__c,f__c,f__r.Name,f__r.lbl__c,f__r.Tp__c,t__c ,t__r.Name,t__r.lbl__c,t__r.Tp__c ,CreatedBy.Name,CreatedById,vf__c,vt__c,Duration__c,to__c,xawb__c ,Activity__c,cd__c,Within_SLA__c from Status_History__r where isDeleted=false order by itm__r.itm__r.ord__c,CreatedDate limit 10), (Select Id,Name,mxAts__c,mnAts__c,ats__c,nt__c,or__c,reqAts__c,reqOr__c,tplt__c,upOk__c,mbr__c,mbr__r.Name From rDocs__r where Req__c=true and IsDeleted=false ), (Select Id,Name,STA__c,dt__c,A__c,md__c,TP__c ,fwf__c From Transactions__r where isDeleted=false order by tp__c),(select Name,Status__c,Summary__c,Request__c,More_Details__c,Type__c,createddate from Requests__r where isDeleted=false ORDER BY createddate DESC), (select id,Name,RQ__c,nc__c,rv__c,m__c,m__r.Name,vSTA__c, AP__c,AOP__c,AD__c,nt__c,xprnt__c,xr__c, xef__c , Dsc__c,DscApp__c,KF__c,cN__c,scN__c,smN__c,exp__c,cXP__c,scXP__c,smXP__c, xean__c,itm__c,itm__r.xf__c,itm__r.cd__c,itm__r.Name,itm__r.lbl__c,itm__r.Tp__c,itm__r.Req__c,itm__r.exp__c,itm__r.prcEdt__c,itm__r.dSTA__c, sta__c,sta__r.cd__c,sta__r.staown__c ,sta__r.statype__c,sta__r.Name,sta__r.lbl__c,sta__r.Tp__c,sta__r.rc__c,sta__r.noEXP__c,sta__r.amsgs__c,sta__r.Next_Status__c,sta__r.next_status__r.rqSTA__c,sta__r.next_status__r.Courier_Stage__c,sta__r.Courier_Stage__c,sta__r.rqSTA__c,sta__r.imsgs__c,sta__r.action__c,LastModifiedDate,LastModifiedById,CreatedDate,CreatedById,xhact__c,xhmsgs__c,xcnotes__c,xcdocs__c,xcdf__c,xceididt__c,xfld__c,xpdl__c,xpidl__c,xpno__c,xpsd__c,xped__c From Items__r where IsDeleted=false order by itm__r.ord__c) ,(SELECT id,AWB_Number__c,Courier_Booking_Log__c,Courier_req__c,Duration__c,End_Date__c,From_Courier_Status__c,Start_Date__c,To_Courier_Status__c,AWB_No__c,Activity__c,Item_Name__c,CreatedBy.name ,tp__c FROM Courier_Histories__r limit 10),(Select Id,CaseNumber,Origin,Type,Subject,Status,Category__c,Sub_Category__c,CreatedDate,ClosedDate from Cases__r Order By IsClosed,CreatedDate Desc) ,con__r.xpno__c,con__r.intp__c From g_Req__c';
        update stg;
        g_Srvc__c s = testData.srvcCrt(stg.Id);
        s.uid__c = '001';
        s.Name = 'Employee Visa (2 Years)';
        update s;
        /*g_srvcitm__c srcvItm = new g_srvcitm__c(srvc__c=s.Id,dSTA__c='rv',slaN__c=4,slaXP__c=2,ord__c=2,Tp__c='Service Item',cd__c='ep',Name='Entry Permit',lbl__c='Entry Permit',Req__c=false,mxcnt__c=1,rv__c=false,prcEdt__c=true,DscApp__c=false,EXP__c=false,KF__c=0,scN__c=10,cN__c=5,smN__c=1,spChN__c=1,scXP__c=1,cXP__c=1,smXP__c=1,spChXP__c=1,xf__c='',Dsbl__c=true);
        insert srcvItm;
        g_srvcitm_Status__c srcvcItmStatus = new g_srvcitm_Status__c(itm__c=srcvItm.Id,Milestone__c='EP',slaa__c='Standard',statype__c='Process',actv__c=true,slaN__c=4,slaXP__c=2,cd__c='ii',name='ii',lbl__c='ii',Tp__c='Open',rqSTA__c='',clm__c=false,clmA__c=0,rfnd__c=false,rfndA__c=0,Shift_At__c='Payment',Shift_Items__c='rp;md;');
        insert srcvcItmStatus;
        */
        Account a = testData.accCrt(false);
        a.ec__c = '22000064';
        update a;
        Contact emp = testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        emp.Email = 'test@gmail.com';
        update emp;
        g_jb__c jb = new g_jb__c(Name = 'SENIOR ENGINEER', cd__c = '1210002', jtar__c = 'مدير', uid__c = 'SENIOR ENGINEER');
        insert jb;
        g_Req__c r = testData.reqCrtOptItems(a.Id, s.Id, emp.Id, 'Open', stg.reqq__c, 'ep,rp');
        r.xcfn__c = 'first';
        r.xcmn__c = 'middle';
        r.xcln__c = 'last';
        r.xcfan__c = 'Father Name';
        r.xcmon__c = 'Mother Name';
        r.xcnp__c = 'Egypt';
        r.xcbd__c = System.today().addYears(-30);
        r.xcbc__c = 'Egypt';
        r.xcbp__c = 'Birth Place';
        r.xcms__c = 'Single';
        r.xcrlg__c = 'Muslim';
        r.xcql__c = 'University Degree';
        r.xcjb__c = jb.Id;
        r.xcpid__c = System.today().addYears(-3);
        r.xcped__c = System.today().addYears(7);
        r.xcpip__c = 'Egypt';
        r.xcpic__c = 'Egypt';
        r.xcitn__c = 'Incountry';
        r.xcha__c = 'Cairo, Egypt';
        r.xchph__c = '0523456789';
        r.xcstrt__c = 'cairo';
        r.xbn__c = 'Building 01';
        r.xcmob__c = '0523456789';
        r.rmob__c = '0523456780';
        update r;
        System.assertNotEquals(r, null);
        System.assertNotEquals(r.Items__r[0], null);
        g_reqDoc__c rDoc1 = new g_reqDoc__c();
        rDoc1.Name = 'Entry Permit Copy';
        rDoc1.RQ__c = r.id;
        rDoc1.ats__c = 1;
        insert rDoc1;
        g_reqDoc__c rDoc2 = new g_reqDoc__c();
        rDoc2.Name = 'Passport First Page';
        rDoc2.RQ__c = r.id;
        rDoc2.ats__c = 1;
        insert rDoc2;
        List < ws_call__c > wsCallLst = new List < ws_call__c > ();
        g_reqitemDoc__c riDoc1 = new g_reqitemDoc__c();
        g_reqitemDoc__c riDoc2 = new g_reqitemDoc__c();
        for (g_reqitem__c ritm: r.Items__r) {
            if (ritm.itm__r.Name == 'ep') {
                ritm.xf__c = '21920100619313';
                ritm.xi__c = '2010513913';
                ritm.exp__c = true;
                ritm.sta__c = [SELECT Id FROM g_srvcitm_Status__c WHERE itm__c =: ritm.itm__c limit 1].Id; //AND cd__c='if'
                System.assertNotEquals([SELECT Id FROM g_srvcitm_Status__c WHERE itm__c =: ritm.itm__c limit 1].Id, null);
                g_Tran__c T = new g_Tran__c(Acc__c = r.Acc__c, RQ__c = r.Id, TP__c = 'Payment', STA__c = 'Completed', dt__c = System.today());
                insert T;
                g_TranItem__c ti = new g_TranItem__c(A__c = 6.00, STA__c = 'Completed', Tp__c = 'Payment', T__c = T.Id, itm__c = ritm.id);
                insert ti;
                reqIm = ritm;
            }
            if ((ritm.itm__r.Name == 'ep') && (app == 'Application' || app == '')) {
                ws_call__c wc = new ws_call__c();
                wc.rq_itm__c = ritm.id;
                wc.ws_typ__c = 'Immigration EVEP';
                wc.mtd_nm__c = 'createApplication';
                wc.intsts__c = 'Ready for Integration';
                wsCallLst.add(wc);
                ws_call__c wc1 = new ws_call__c();
                wc1.rq_itm__c = ritm.id;
                wc1.rq_jsn__c = '{"applicationId":"09383747457"}';
                wc1.ws_typ__c = 'Immigration EVEP';
                wc1.mtd_nm__c = 'createApplication';
                wc1.intsts__c = 'Ready for Integration';
                wsCallLst.add(wc1);
            }
            if (ritm.itm__r.Name == 'ep' && (app == 'Document' || app == '')) {
                ws_call__c wcd = new ws_call__c();
                wcd.rq_itm__c = ritm.id;
                wcd.rq_jsn__c = 'ecc3f127-b631-4b14-9529-8d6c9c401aca__Passport First Page';
                wcd.ws_typ__c = 'Immigration EVEP';
                wcd.mtd_nm__c = 'uploadSingleDocument';
                wcd.intsts__c = 'Ready for Integration';
                wsCallLst.add(wcd);
                ws_call__c wcd1 = new ws_call__c();
                wcd1.rq_itm__c = ritm.id;
                wcd1.rq_jsn__c = 'ecc3f127-b631-4b14-9529-8d6c9cn01aca__Passport Last Page';
                wcd1.ws_typ__c = 'Immigration EVEP';
                wcd1.mtd_nm__c = 'uploadSingleDocument';
                wcd1.intsts__c = 'Ready for Integration';
                wsCallLst.add(wcd1);
                riDoc1.reqItm__c = ritm.id;
                riDoc1.Name = 'Entry Permit Copy';
                riDoc1.lbl__c = 'Entry Permit Copy';
                riDoc1.mxAts__c = 1;
                riDoc1.mnAts__c = 1;
                riDoc1.Req__c = true;
                riDoc1.reqAts__c = true;
                riDoc1.Tp__c = 'Entry permit';
                riDoc1.reqDoc__c = rDoc1.Id;
                insert riDoc1;
                riDoc2.reqItm__c = ritm.id;
                riDoc2.Name = 'Passport First Page';
                riDoc2.lbl__c = 'Passport First Page';
                riDoc2.mxAts__c = 1;
                riDoc2.mnAts__c = 1;
                riDoc2.Req__c = true;
                riDoc2.reqAts__c = true;
                riDoc2.Tp__c = 'Entry permit';
                riDoc2.reqDoc__c = rDoc2.Id;
                insert riDoc2;
                Attachment at = new Attachment(Name = 'FirstPage', ParentId = rDoc2.Id, Body = Blob.valueOf('iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAB1klEQVR42n2TzytEURTHv3e8N1joRhZGzJsoCjsLhcw0jClKWbHwY2GnLGUlIfIP2IjyY2djZTHSMJNQSilFNkz24z0/Ms2MrnvfvMu8mcfZvPvuPfdzz/mecwgKLNYKb0cFEgXbRvwV2s2HuWazCbzKA5LvNecDXayBjv9NL7tEpSNgbYzQ5kZmAlSXgsGGXmS+MjhKxDHgC+quyaPKQtoPYMQPOh5U9H6tBxF+Icy/aolqAqLP5wjWd5r/Ip3YXVILrF4ZRYAxDhCOJ/yCwiMI+/xgjOEzmzIhAio04GeGayIXjQ0wGoAuQ5cmIjh8jNo0GF78QwNhpyvV1O9tdxSSR6PLl51FnIK3uQ4JJQME4sCxCIRxQbMwPNSjqaobsfskm9l4Ky6jvCzWEnDKU1ayQPe5BbN64vYJ2vwO7CIeLIi3ciYAoby0M4oNYBrXgdgAbC/MhGCRhyhCZwrcEz1Ib3KKO7f+2I4iFvoVmIxHigGiZHhPIb0bL1bQApFS9U/AC0ulSXrrhMotka/lQy0Ic08FDeIiAmDvA2HX01W05TopS2j2/H4T6FBVbj4YgV5+AecyLk+CtvmsQWK8WZZ+Hdf7QGu7fobMuZHyq1DoJLvUqQrfM966EU/qYGwAAAAASUVORK5CYII='), ContentType = 'image/png');
                insert at;
            }
            if (ritm.itm__r.Name == 'ep' && (app == 'Payment' || app == '')) {
                ws_call__c wc = new ws_call__c();
                wc.rq_itm__c = ritm.id;
                wc.ws_typ__c = 'Immigration EVEP';
                wc.mtd_nm__c = 'submitPayment';
                wc.intsts__c = 'Ready for Integration';
                wc.sdt__c = Datetime.now().addDays(-1);
                wsCallLst.add(wc);
            }
        }
        update r.Items__r;
        insert wsCallLst;
        if (app == 'Document' || app == '') {
            List < g_reqitemDoc__c > ridocs = new List < g_reqitemDoc__c > ();
            ridocs.add(riDoc1); //[SELECT Id,reqItm__c,reqItm__r.xf__c,(SELECT Id,ParentId FROM Attachments ORDER BY CreatedDate DESC LIMIT 1) FROM g_reqitemDoc__c WHERE Name='Entry Permit Copy' AND Tp__c='Entry permit' AND Id=:riDoc.Id];
            ridocs.add(riDoc2);
            List < sObject > scope = (List < sObject > ) ridocs;
            System.assertNotEquals(scope.size(), 0);
        }
    }
    static testMethod void unitTest01() {
        loadData('');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockEngToArabicAPI());
        GDRFAUtil.getLookupByParentId('Faiths');

        GDRFAUtil.engToArabicStr('TranslatedText', 'Tsrts');
        GDRFAUtil.noOfWorkingDays(1);
        g_srvcitm_Status__c sts = [SELECT Id, itm__c, cd__c FROM g_srvcitm_Status__c limit 1];
        GDRFAUtil.statusId(sts.cd__c, sts.itm__c);
        List < ws_call__c > lst = [SELECT Id, rq_itm__r.AD__c, rq_itm__r.RQ__c, rq_itm__r.xf__c, rq_itm__c, ws_typ__c, mtd_nm__c, sdt__c, intsts__c, err_msg__c, rq_jsn__c, res_jsn__c From ws_call__c where intsts__c = 'Ready for Integration'
            limit 1
        ];
        GDRFAUtil.wsCallExpressCheck(lst[0].rq_itm__c, lst[0].ws_typ__c, lst[0].mtd_nm__c);
        GDRFAUtil.reqItem(lst[0].rq_itm__c);
        GDRFAUtil.strtoDate('02/02/2020');
        GDRFAUtil.strDate('02/02/2020');
        GDRFAUtil.noOfWorkingDays(date.today(), 4);
        GDRFAUtil.LookupIdByTypeNname();
        ApplicationDataWrapper wrp = new ApplicationDataWrapper();
        wrp.ApplicationNumber = '';
        wrp.residenceNo = '';
        ApplicationDataWrapper.EntrypermitDetails ad = new ApplicationDataWrapper.EntrypermitDetails();
        ad.entrypermitNo = '';
        ad.uidNo = '';
        ApplicationDataWrapper.cls_ApplicationDetails capp = new ApplicationDataWrapper.cls_ApplicationDetails();
        capp.IsDraft = false;
        capp.ResidencyPickup = '';
        ApplicationDataWrapper.cls_SponsorDetails cs = new ApplicationDataWrapper.cls_SponsorDetails();
        cs.EstCode = '';
        cs.MobileNumber = '';
        cs.SponsorEmail = '';
        ApplicationDataWrapper.cls_ApplicantDetails cad = new ApplicationDataWrapper.cls_ApplicantDetails();
        cad.FirstNameE = '';
        cad.FirstNameA = '';
        cad.MiddleNameE = '';
        cad.MiddleNameA = '';
        cad.LastNameE = '';
        cad.LastNameA = '';
        cad.MotherNameE = '';
        cad.MotherNameA = '';
        cad.CurrentNationalityId = '';
        cad.PreviousNationality = '';
        cad.BirthDate = '';
        cad.BirthCountryId = '';
        cad.BirthPlaceE = '';
        cad.BirthPlaceA = '';
        cad.SexId = '';
        cad.MaritalStatusId = '';
        cad.ReligionId = '';
        cad.Faith = '';
        cad.EducationId = '';
        cad.ProfessionId = '';
        cad.Language1 = '';
        cad.PassportNo = '';
        cad.PassportTypeId = '';
        cad.PassportIssueDate = '';
        cad.PassportExpiryDate = '';
        cad.PassportPlaceE = '';
        cad.PassportPlaceA = '';
        cad.PassportIssueCountryId = '';
        cad.PassportIssueGovId = '';
        cad.IsInsideUAE = '';
        cad.AddressOutsideCountryId = '';
        cad.AddressOutsideCity = '';
        cad.AddressOutside1 = '';
        cad.AddressOutside2 = '';
        cad.AddressOutsideTelNo = '';
        cad.EmirateId = '';
        cad.CityId = '';
        cad.AreaId = '';
        cad.Street = '';
        cad.Building = '';
        cad.Landmark = '';
        cad.MakaniNo = '';
        cad.MobileNo = '';
        cad.AreaId = '';
        cad.ResidenceRequestYear = '';



        ApplicationDataWrapper.cls_Application ca = new ApplicationDataWrapper.cls_Application();
        ca.ApplicantDetails = cad;
        ca.SponsorDetails = cs;
        ca.ApplicationDetails = capp;
        ApplicationDataWrapper.cls_applicationData cd = new ApplicationDataWrapper.cls_applicationData();

        cd.Application = ca;

        ResidentApplicationNewWrapper rpw = new ResidentApplicationNewWrapper();
        rpw.permitNo = rpw.permitNo;
        ResidentApplicationNewWrapper.cls_ApplicantDetails rpcs = new ResidentApplicationNewWrapper.cls_ApplicantDetails();
        rpcs.EmirateId = rpcs.EmirateId;
        rpcs.CityId = rpcs.CityId;
        rpcs.AreaId = rpcs.AreaId;
        rpcs.Street = rpcs.Street;
        rpcs.Building = rpcs.Building;
        rpcs.Landmark = rpcs.Landmark;
        rpcs.MakaniNo = rpcs.MakaniNo;
        rpcs.MobileNo = rpcs.MobileNo;
        rpcs.ResidenceRequestYear = rpcs.ResidenceRequestYear;

        ResidentApplicationNewWrapper.cls_SponsorDetails cst = new ResidentApplicationNewWrapper.cls_SponsorDetails();
        cst.SponsorEmail = '';
        cst.MobileNumber = '';
        cst.EstCode = '';
        ResidentApplicationNewWrapper.cls_ApplicationDetails csta = new ResidentApplicationNewWrapper.cls_ApplicationDetails();
        csta.IsDraft = true;
        csta.ResidencyPickup = '';
        ResidentApplicationNewWrapper.cls_Application cstb = new ResidentApplicationNewWrapper.cls_Application();
        cstb.ApplicantDetails = rpcs;
        cstb.SponsorDetails = cst;
        ResidentApplicationNewWrapper.cls_applicationData ct = new ResidentApplicationNewWrapper.cls_applicationData();
        ct.Application = cstb;

        String x = JSON.serialize(rpw);
        GDRFAUtil.requestBody(reqIm, '', GDRFAUtil.LookupIdByTypeNname());
        GDRFAUtil.getApplicantRPDetails('tst', 'tst', 'tst', 'tst', 'tst');

        DocumentConversionWrapper obj = DocumentConversionWrapper.parse('{"ConversionCost":1,"Files":[{"FileName":"my_file.jpg","FileExt":"jpg","FileSize":68073,"FileData":"/FAEGCgCYGCgCYMdJmANbg2ZrgoAAAD//Z"}]}');
        String fname = obj.Files[0].FileName;
        String FileExt = obj.Files[0].FileExt;
        String FileData = obj.Files[0].FileData;
        TravelDetailsWrapper obj1 = new TravelDetailsWrapper();
        obj1.residenceNo = '';
        obj1.permitNo = '';
        obj1.insideTheCountry = false;
        obj1.lastEntryDate = '';
        obj1.remainingStayDays = 0;
        obj1.lastExitDate = '';
        obj1.nextVisitStayDays = 0;
        obj1.stayUntilDate = '';
        obj1.firstUsageDate = '';
        Test.stopTest();
    }

    public class MockEngToArabicAPI implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"TranslatedText":"فيرست نعمه"}');
            res.setStatusCode(200);
            return res;
        }
    }
}