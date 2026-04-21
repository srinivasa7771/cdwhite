@isTest
private class gctlWSPushDDATest {
    static void loadData() {
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
        s.Name = 'Employee Visa (3 Years)';
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
    }

    static testMethod void unitTest01() {
        Test.startTest();
        loadData();
        List < g_reqitem__c > rilst = [select id from g_reqitem__c limit 1];
        gctlWSPushDDA ctrl = new gctlWSPushDDA();
        ApexPages.currentPage().getParameters().put('id', rilst[0].id);
        ctrl.createWsCAll();
        Test.stopTest();
    }
    static testMethod void unitTest02() {
        Test.startTest();
        loadData();
        List < g_reqitem__c > rilst = [select id from g_reqitem__c limit 1];
        ws_call__c ws = new ws_call__c();
        ws.ws_typ__c = 'Immigration EVEP';
        ws.mtd_nm__c = 'createApplication';
        ws.rq_itm__c = rilst[0].id;
        insert ws;
        gctlWSPushDDA ctrl = new gctlWSPushDDA();
        ApexPages.currentPage().getParameters().put('id', ws.id);
        ctrl.pushWsCall();
        Test.stopTest();
    }
    static testMethod void unitTest03() {
        Test.startTest();
        loadData();
        List < g_reqitem__c > rilst = [select id from g_reqitem__c limit 1];
        ws_call__c ws = new ws_call__c();
        ws.ws_typ__c = 'Immigration EVEP';
        ws.mtd_nm__c = 'createApplication';
        ws.rq_itm__c = rilst[0].id;
        ws.rq_jsn__c = '030b0e3e-a5cc-4ca9-b15e-65e670600663__Medical Certificate Document';
        insert ws;
        gctlWSPushDDA ctrl = new gctlWSPushDDA();
        ApexPages.currentPage().getParameters().put('id', ws.id);
        ctrl.createRQDoc();
        Test.stopTest();
    }
}