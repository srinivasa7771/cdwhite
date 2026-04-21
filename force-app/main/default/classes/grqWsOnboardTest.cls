@isTest(SeeAllData = false)
public class grqWsOnboardTest {

    @testSetup /*MS*/
    static void setup() {
        testData.init();
        Account a = testData.accCrt(false);
        Contact sp = testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        testData.bRulesReqCrt();
        testData.bRulesItemCrt();
        g_srvc_settings__c stg = testData.stgCrt();
        g_Srvc__c s = testData.srvcCrt(stg.Id);

        g_srvcitm__c sItm = [SELECT id, name, cd__c, Req__c from g_srvcitm__c limit 1];
        sItm.Req__c = true;
        sItm.cd__c = 'frl';
        update sItm;

        ws_call__c ws1 = new ws_call__c(ws_typ__c = 'Onboarding', mtd_nm__c = 'updateAccInfo', intsts__c = 'Ready for Integration', rq_jsn__c = '{}');
        ws_call__c ws2 = new ws_call__c(ws_typ__c = 'Onboarding', mtd_nm__c = 'uploadDoc', intsts__c = 'Ready for Integration', rq_jsn__c = '{}');
        ws_call__c ws3 = new ws_call__c(ws_typ__c = 'Onboarding', mtd_nm__c = 'uploadDoc', intsts__c = 'Ready for Integration', rq_jsn__c = '{}');

        List < ws_call__c > lstWs = new List < ws_call__c > ();
        lstWs.add(ws1); //lstWs.add(ws2); lstWs.add(ws3);
        insert lstWs;
    }

    static testmethod void test1() {
        g_srvc_definition__c sd = new g_srvc_definition__c(Name = 'test', ptype__c = 'Normal:10 Days;Express:3 Days;', cv__c = 'NewVisa', sd__c = 'Apply for new employment visa. Based on the information you provide, you will be either taken to the ‘New Visa’ or ‘Visa Transfer’ process. <br/><br/><strong>The new visa includes:</strong><ul class="ul-style"><li> Entry Permit</li><li> Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li><li> In-country status change (if required)</li></ul><strong>Visa transfer includes:</strong><br/><ul class="ul-style"><li>Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li></u>', docslbl__c = 'Passport - first page;Passport - last page (if applicable);Recent passport size photo (white background);Attested educational certificate (occupation dependent);Emirates ID - front (if available);Emirates ID - back (if available);Existing residence visa page (for transfers only);NOC from the releasing sponsor (for transfers only);Final settlement (for transfers within free zone only);Employment contract (conditional);Valid nationality identity card (for Pakistan, Afghanistan & Iraqi nationals - conditional);Medical Certificate from Origin Country Sri Lankan, Indonesian and Ethiopian nationalities (conditional) ;Good Contact Certificate for Kenyan nationalities (conditional);Health insurance card or certificate or opt for ADNIC Insurance during the application (for transfers only)');
        insert sd;
        List < Contact > conLst = [select id from Contact where firstName = 'fName'
            LIMIT 1
        ];

        List < Account > accLst = [select id, ccrm_sfid__c, sharecap__c, noshrs__c from Account where Name = 'Acc'
            LIMIT 1
        ];
        accLst[0].ccrm_sfid__c = '00Q05000004fy3iEAA';
        accLst[0].sharecap__c = 100;
        accLst[0].noshrs__c = 100;
        update accLst[0];

        List < g_Srvc__c > srvcLst = [select id from g_Srvc__c where Name = 'Srvc'
            LIMIT 1
        ];
        Contact c = new Contact(Id = conLst[0].Id, mbs__c = 500000, eidid__c = '784198774283257', eidedt__c = system.today().addyears(3));
        update c;

        Contact emp = testData.conCrt(conLst[0], accLst[0].Id, 'Active', 'Employee', 'Pass2', 'Egypt');

        String reqQ = 'Select xadtx5__c,mtnm__c, isAMLCompleted__c, isMOAAmd__c, xvtyp__c, parCat__c,Acc__r.clt__c, os__c,xcflst__c,xadtx3__c,xadtx4__c,Acc__r.ccrm_sfid__c,piFlg__c,xvnum__c,xrp__c,Acc__r.lc__c,Acc__r.Legal_Framework__c,PRM_Name__c,PRM_Email__c,PRM_MobileNo__c,PRM_LandlineNo__c,xrped__c,xaccbrand__c,xadtx2__c,xui__c,activitiesFL__c,inUAE__c,is_sponsered_fl__c,segmentFL__c,con__r.middlename,srvc__r.sdg__r.ptype__c,srvc__r.stg__r.itmq__c,xoca__c,ias__c,xengt__c,xeng__c,xneng__c,xvown__c,xtr2__c,xltr_Others__c,Print__c,xln__c,xcst__c,xvbr__c,xvch__c,xvn__c,xwdt__c,xbdt__c,xbtnm__c,xltr__c,xlt__c,xla2__c,xla2d__c,xltp__c,xnld__c,xloc__c,xccn__c,srvc__r.stg__r.json__c,xcmonar__c,xcfanar__c,xengp__c,xai__c,xsi__c,srvc__r.xoi__c,srvc__r.AddOnSrv__c,srvc__r.Milestone_Stage__c,mtc__c,xcjb__r.jtm__c,con__r.Name,con__r.Job_Title_Formula__c,con__r.bp__c,con__r.ped__c,Con__r.Personal_Photo__c,Con__c,xard__c,Con__r.Spon__r.xpmi__c,Con__r.Spon__r.idtxt__c,Con__r.Spon__r.Name,Con__r.Spon__r.xpno__c,Con__r.Spon__r.intp__c,Con__r.Spon__r.Birthdate,Spr__r.idtxt__c,Spr__r.xpno__c,con__r.e__c,Spr__r.xpmi__c,Spr__r.intp__c,Spr__r.Birthdate,i_STA__c,xtpa__c,Id,Name,STA__c,AT__c,ATV__c,AP__c,AOP__c,xdtcls__c,dsc__c,dsc__r.prct__c,xfpc__c,spCh__c,rmob__c,xawb__c,xaloc__c,xbrnd__c,xbn__c,nt__c,srvc__r.uid__c, ConRol__c ,xadh__c,xpgs__c,InsChk__c,xintp__c,Con__r.rol__c,Con__r.firstname,con__r.LastName,con__r.emrt__c,con__r.p__c,Con__r.Email,Con__r.MobilePhone,Con__r.Salutation,Con__r.ms__c,Con__r.nc__c,Con__r.eidid__c,Con__r.pobx__c,Con__r.mbs__c,Con__r.ma__c,Con__r.mta__c,Con__r.moa__c,Con__r.Birthdate,Con__r.rpui__c,srvc__c,srvc__r.name,srvc__r.lbl__c,srvc__r.dsc__c,srvc__r.Prk__c,srvc__r.AccTp__c, srvc__r.ckgsnc__c,srvc__r.snc__c,srvc__r.stg__r.pg__c,srvc__r.stg__r.apx__c,srvc__r.stg__r.reqq__c, Acc__c,Acc__r.Name,Acc__r.lcedt__c ,Acc__r.mtc__c,Acc__r.Type,Acc__r.Prk__c,Acc__r.lcsnc__c,Acc__r.lcsncnt__c,Acc__r.psasnc__c,Acc__r.psasncnt__c,Acc__r.ecsnc__c,Acc__r.ecsncnt__c, Acc__r.cosnc__c,Acc__r.cosncnt__c,Acc__r.bgsnc__c,Acc__r.bgsncnt__c,Acc__r.snc__c,Acc__r.info__c,Acc__r.vestd__c,Acc__r.vbtemp__c,Acc__r.sncNt__c,LastModifiedDate,LastModifiedById,CreatedDate,CreatedById,CreatedBy.Name,Item_Count__c, xeidav__c,xcma__c,xcacctp__c,xcha__c,xcarea__c,xcmbs__c,xcbd__c,xccty__c,xcbc__c,xcnc__c,xceidid__c,xceidedt__c,xceididt__c, xceml__c,xcemrt__c,xcfan__c,xcfs__c,xcfn__c,xcfnar__c,xchph__c,xcln__c,xclnar__c,xcms__c,xcmn__c,xcmnar__c,xcmob__c,xcmon__c, xcof__c,xcot__c,xcjb__c,xcmoa__c,xcp__c, xcped__c,xcpid__c,xcpic__c,xcpip__c,xcbp__c,xcpobx__c,xcpobxarea__c,xcnp__c,xcql__c, xcrlg__c,xcslt__c,xclng__c,xcstrt__c,xcmta__c,xdedc__c,xdedln__c,xosa__c, xphid__c,xcs__c,xcn__c,Zone__c,Full_Name__c,amsgs__c,action__c,xspn__c,xinsv__c,xcpobar__c,Con__r.eid__c,Con__r.eed__c,Con__r.rp__c,Con__r.rpid__c,Con__r.rped__c,Con__r.eididt__c,Con__r.eidedt__c,Con__r.idtxt__c,Con__r.ididt__c,Con__r.idedt__c,xcpipoar__c,srvc__r.pstg__c,srvc__r.kstp__c,xcddocs__c,xmloc__c, (select id,f__r.Name,CreatedDate,CreatedBy.Name,actE__c,itm__r.Name,To__c,t__r.hisl__c,LastModifiedDate,t__r.kstp__c from Status_History__r where isDeleted=false order by CreatedDate desc limit 10), (Select Id,Name,mxAts__c,mnAts__c,ats__c,nt__c,or__c,reqAts__c,reqOr__c,tplt__c,x30gr__c,upOk__c,mbr__c,mbr__r.Name From rDocs__r where Req__c=true and IsDeleted=false ), (Select Id,Name,STA__c,dt__c,A__c,md__c,TP__c ,fwf__c,Created_Date_Time__c From Transactions__r where isDeleted=false  order by  tp__c),(select Name,Status__c,Summary__c,Request__c,More_Details__c,Type__c,createddate from Requests__r where isDeleted=false ORDER BY createddate DESC), (select id,Name,RQ__c,nc__c,rv__c,m__c,m__r.Name,vSTA__c, AP__c,AOP__c,AD__c,ATV__c, nt__c,xprnt__c,xr__c, xef__c , Dsc__c,DscApp__c,KF__c,cN__c,scN__c,smN__c,exp__c,cXP__c,scXP__c,smXP__c, xean__c,itm__c,itm__r.xf__c,itm__r.cd__c,itm__r.Name,itm__r.lbl__c,itm__r.Tp__c,itm__r.Req__c,itm__r.exp__c,itm__r.prcEdt__c,itm__r.dSTA__c, sta__c,sta__r.cd__c,sta__r.staown__c ,sta__r.statype__c,sta__r.Name,sta__r.lbl__c,sta__r.Tp__c,sta__r.rc__c,sta__r.noEXP__c,sta__r.amsgs__c,sta__r.namsgs__c,sta__r.Next_Status__c,sta__r.next_status__r.rqSTA__c,sta__r.next_status__r.Courier_Stage__c,sta__r.Courier_Stage__c,sta__r.rqSTA__c,sta__r.imsgs__c,sta__r.action__c,LastModifiedDate,LastModifiedById,CreatedDate,CreatedById,xhact__c,xhmsgs__c,xcnotes__c,xcdocs__c,xcdf__c,xceididt__c,xfld__c,xpdl__c,xpidl__c,xpno__c,xpsd__c,xped__c,xcsla__c,xdcdocs__c,itm__r.gctg__c,sta__r.slaa__c,sta__r.Milestone__c,sta__r.kstp__c,itm__r.mv__c,xcphc__c,xaed__c ,pnc__c From Items__r  where IsDeleted=false order by lastmodifieddate),(SELECT id,AWB_Number__c,Courier_Booking_Log__c,Courier_req__c,Duration__c,End_Date__c,From_Courier_Status__c,Start_Date__c,To_Courier_Status__c,AWB_No__c,Activity__c,Item_Name__c,CreatedBy.name ,tp__c FROM Courier_Histories__r limit 10),(Select Id,CaseNumber,Origin,Type,Subject,Status,Category__c,Sub_Category__c,CreatedDate,ClosedDate from Cases__r Order By IsClosed,CreatedDate Desc),(select id from Attachments order by lastmodifieddate limit 1) ,srvc__r.Category__c,xcqc__c,xcdd__c,xcqemrt__c,AUP__c,xcamdt__c,slaN__c ,srvc__r.sdg__r.skpsd__c ,Gender__c,expcnt__c,noEXP__c,AUPV__c,expflg__c ,noFnm__c,spnm__c,afn__c,xspnar__c,ntk__c,ntkar__c From g_Req__c';
        g_Req__c r = testData.reqCrt(accLst[0].Id, srvcLst[0].Id, emp.Id, 'Open', reqQ);
        r.activitiesFL__c = 'Graphic Designer';
        r.acc__c = accLst[0].id;
        update r;

        acc_sharehd__c sh = new acc_sharehd__c(xcfnar__c = 'test', xclnar__c = 'test', crole__c = 'Shareholder', ctgCode__c = 'sh', Shareholder_Type__c = '', fname__c = 'test', mname__c = 'test', lname__c = 'test', passno__c = 'test12121', Email__c = 'test@test.com', nat__c = 'India', Gender__c = 'Male', Mobile__c = '527654536', noshrs__c = 100, shName__c = 'test',
            pIsDt__c = Date.parse('11/11/2022'), pExDt__c = Date.parse('11/11/2022'), dob__c = Date.parse('11/11/2022'), ppi__c = 'test', phn__c = '31231123123213', accsh__c = accLst[0].id);
        insert sh;

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new mockResponse());
        grqWsOnboard.validateFreelancer(r);
        grqWsOnboard.fetchAccInfo('00105000004fy3iEAA');

        grqWsOnboard.updateFrlAccInfo(r, '00Q05000004fy3iEAA');
        grqWsOnboard.autoQualifyLead('00105000004fy3iEAA');
        grqWsOnboard.callUpdateAccInfo();


        ws_call__c ws = [Select id, name from ws_call__c where mtd_nm__c = 'updateAccInfo'
            limit 1
        ];
        grqWsOnboard.callUpdateAccInfo(ws.Id);

        ws_call__c ws2 = new ws_call__c(ws_typ__c = 'Onboarding', mtd_nm__c = 'uploadDoc', intsts__c = 'Ready for Integration', rq_jsn__c = '{}');
        insert ws2;
        /*ws = [Select id, name from  ws_call__c where mtd_nm__c='uploadDoc' limit 1];*/
        grqWsOnboard.callUploadDocs(ws2.Id);
        grqWsOnboard.callUploadDocs();


        List < g_reqitem__c > rqItSet = [Select id, name, rq__c from g_reqitem__c limit 1];
        Map < Id, g_Req__c > reqMap = new Map < Id, g_Req__c > ();
        reqMap.put(rqItSet[0].id, r);

        grqWsOnboard.fetchAccInfo(rqItSet, reqMap, 'Onboarding', 'fetchAccInfo');



        String query = 'Select  mtnm__c,Acc__r.van__c,xadtx5__c, isAMLCompleted__c, isMOAAmd__c ,Acc__r.clt__c, parCat__c,  Account_Brand__c,xvch__c,crflg__c,inUAE__c,lcexpdt__c,xmamd__c,Acc__r.mtc__c,is_sponsered_fl__c,PRM_Name__c,PRM_Email__c,PRM_MobileNo__c,PRM_LandlineNo__c,piFlg__c,expflg__c,slaN__c,AUPV__c,xcamdt__c,AUP__c,Acc__r.Name,srvc__r.sdg__r.skpsd__c,xsi__c,xai__c,srvc__r.Milestone_Stage__c,srvc__r.sdg__r.ptype__c,srvc__r.sdg__r.cv__c,srvc__r.AddOn__c,srvc__r.AddOnSrv__c,Acc__r.lcedt__c,acc__r.lctp__c,srvc__r.xoi__c,xfb__c,xchn__c,xcsnc__c,xfsr__c,xddatc__c,xadtx3__c,xbtnm__c,xppor__c,rtacn__c,xccn__c,x30gr__c,xccl__c,xeng__c, xcawp__c,xdedln__c,ias__c,xcn__c,xlt__c,xcddocs__c,xtpa__c,xla2l__c  ,xdedc__c,xdccaRq__c,Print__c   ,xdrv__c ,xadtx4__c,Provisional_Issuance__c, xaed__c,xlicd__c,xcs__c,xanum__c,xpmsle__c,xppsfv__c,xcne__c,xcna__c,xlne__c,xlna__c,xalfe__c,xaccbrand__c, Acc__r.lcidt1arb__c,Acc__r.licexdt__c,Acc__r.Legal_Framework__c,Acc__r.lcidt__c,Acc__r.lc__c,dsgu__c,epexpdt__c ,Acc__r.lcedtarb__c,xmloc__c,xvn__c,xdei__c,xuvdet__c,xadtx1__c,xadtx2__c,Id,Name,STA__c,AT__c,AP__c,AOP__c,xdtcls__c, dsc__c,dsc__r.prct__c,xfpc__c,xnry__c,spCh__c,rmob__c,xawb__c,xaloc__c,xbrnd__c,xbn__c,nt__c, srvc__r.uid__c ,srvc__r.pstg__c, srvc__r.kstp__c,xltr__c,xtcdl__c,InsChk__c,xadh__c,srvc__c,srvc__r.name,srvc__r.lbl__c,srvc__r.dsc__c,srvc__r.Prk__c,srvc__r.AccTp__c, Acc__r.lcsta__c,Con__c,ConRol__c ,ConSTA__c, srvc__r.ckgsnc__c,srvc__r.snc__c,srvc__r.stg__r.pg__c,srvc__r.stg__r.apx__c,srvc__r.stg__r.reqq__c, Acc__r.lrd__c,Acc__r.onar__c,Acc__c,Acc__r.ORACLE_PARTY_ID__c,Acc__r.Type,Acc__r.Prk__c,Acc__r.Park__c,Acc__r.lcsnc__c,Acc__r.lcsncnt__c,Acc__r.psasnc__c, Acc__r.psasncnt__c,Acc__r.ecsnc__c,Acc__r.ecsncnt__c, Acc__r.cosnc__c,Acc__r.cosncnt__c,Acc__r.bgsnc__c,Acc__r.bgsncnt__c,Acc__r.snc__c,Acc__r.info__c, Acc__r.vestd__c,Acc__r.vbtemp__c,Acc__r.speabsc__c,Acc__r.os__c, LastModifiedDate,LastModifiedById,CreatedDate,CreatedById,xepAtt__c, xeidav__c,xcma__c, xcacctp__c,xcha__c,xcarea__c,xcmbs__c,xcbd__c,xccty__c,xcbc__c,xcnc__c,xceidid__c,xceidedt__c,xceididt__c, xceml__c,xcemrt__c,xcfan__c,xcfs__c,xcfn__c, xcfnar__c,xchph__c,xcln__c,xclnar__c,xcms__c,xcmn__c,xcmnar__c,xcmob__c,xcmon__c, xcof__c,xcot__c,xcjb__c,xcmoa__c,xcp__c,xcped__c,xcpid__c,xcpic__c,xcpip__c, xcbp__c,xcpobx__c,xcpobxarea__c,xcnp__c,xcql__c, xcrlg__c,xcslt__c,xclng__c,xcstrt__c,xcmta__c,amsgs__c,action__c,srvc__r.lsctg__c,os__c ,(select id,Name,estE__c,actE__c,kstp__c,sla__c,acts__c,itm__c,itm__r.exp__c,itm__r.itm__r.exp__c,itm__r.itm__r.Name,itm__r.itm__r.lbl__c, f__c,f__r.Name,f__r.lbl__c,f__r.Tp__c,t__c,T__r.hisl__c ,t__r.Name,t__r.kstp__c,t__r.lbl__c,t__r.Tp__c ,CreatedBy.Name,CreatedById,vf__c,vt__c,Duration__c,to__c,xawb__c , Activity__c,cd__c,Within_SLA__c  from Status_History__r   where isDeleted=false order by itm__r.itm__r.ord__c,CreatedDate), (Select Id,Name,mxAts__c,mnAts__c,ats__c,nt__c,or__c,reqAts__c,reqOr__c,tplt__c,x30gr__c,upOk__c,mbr__c,mbr__r.Name From rDocs__r where Req__c=true and IsDeleted=false), (Select Id,Name,STA__c,dt__c,A__c,md__c,TP__c ,fwf__c From Transactions__r where isDeleted=false),(select Name,Status__c,Summary__c,Request__c,More_Details__c, Type__c,createddate from Requests__r where isDeleted=false ORDER BY createddate DESC), (select id,Name,RQ__c,nc__c,rv__c,m__c,m__r.Name,vSTA__c, AP__c,AOP__c,AD__c, nt__c,xprnt__c,xr__c, xcnotes__c,xef__c ,xips__c, Dsc__c,DscApp__c,KF__c,cN__c,scN__c,smN__c,exp__c,cXP__c,scXP__c,smXP__c, itm__c,itm__r.xf__c,itm__r.cd__c, itm__r.Name,itm__r.lbl__c,itm__r.Tp__c,itm__r.Req__c,itm__r.exp__c,itm__r.prcEdt__c,itm__r.dSTA__c, sta__c,sta__r.cd__c,sta__r.Name,sta__r.lbl__c,sta__r.Tp__c, sta__r.rc__c,sta__r.noEXP__c, LastModifiedDate,LastModifiedById,CreatedDate,CreatedById,sta__r.staown__c,sta__r.Next_Status__c,sta__r.amsgs__c, sta__r.next_status__r.rqSTA__c,sta__r.next_status__r.Courier_Stage__c,sta__r.Courier_Stage__c,sta__r.rqSTA__c,sta__r.imsgs__c,sta__r.action__c,sta__r.statype__c, xcdocs__c,xdcdocs__c,xfld__c,ccrmid__c From Items__r where IsDeleted=false order by itm__r.ord__c) ,(SELECT id,AWB_Number__c,Courier_Booking_Log__c,Courier_req__c, Duration__c,End_Date__c,From_Courier_Status__c,Start_Date__c,To_Courier_Status__c,AWB_No__c,Activity__c,Item_Name__c,CreatedBy.name  ,tp__c FROM Courier_Histories__r), (Select Id,CaseNumber,Origin,Type,Subject,Status,Category__c,Sub_Category__c,CreatedDate,ClosedDate from Cases__r Order By IsClosed,CreatedDate Desc), (select id,name from Attachments order by createddate desc),srvc__r.Category__c,xcqc__c,xcdd__c,xcqemrt__c,xvtyp__c,Location_Brand__c,xltp__c,Con__r.rol__c,Con__r.firstname,con__r.LastName,con__r.emrt__c,con__r.p__c,Con__r.Email,Con__r.MobilePhone,Con__r.Salutation,Con__r.ms__c,Con__r.nc__c,Con__r.eidid__c,Con__r.pobx__c,Con__r.mbs__c,Con__r.ma__c,Con__r.mta__c,Con__r.moa__c,Con__r.Birthdate,Con__r.rpui__c,xcst__c  From g_Req__c';
        r = Database.query(query);
        r.xadtx2__c = '[{"name":"Ancillary Services","segId":"a08D000000zezLjIAI","allowed":"3","price":"15000.00","SegActivities":[{"name":"Fashion and Luxury Consultancy","actId":"a1290000007ysreAAA","price":"15000.00","docs":[]},{"name":"Image Consultancy","actId":"a12D0000005B9YjIAK","price":"15000.00","docs":[]}]}]';
        r.xadtx3__c = '{"workorders":[{"status":"Draft","recType":"Brand_Approval","recid":"0WO05000000CzQJGA0","parentid":null,"members":null},{"status":"Draft","recType":"DDA_Name_Reservation","recid":"0WO05000000CzQLGA0","parentid":null,"members":null},{"status":"Draft","recType":"Security_Clearance","recid":"0WO05000000CzQKGA0","parentid":null,"members":null}],"usrName":"Wassim Yahia","scWorkid":"0WO05000000CzQKGA0","respMsg":"Success","requestid":null,"quotes":[],"proposedLegalForm":"DDA","paymentSchedules":[],"onbReqid":"a2l05000000CD5pAAG","nameResWorkid":null,"members":null,"lrWorkid":null,"licenseType":"DDA","legalFramework":"DDA","lcExpdate":null,"isSuccess":true,"Invoices":[],"hseWorkid":null,"documents":null,"DDAReqNo":null,"crmAccId":"0010500000JEWzZAAX","caseid":null,"businessPark":"DDA","brandWorkid":"0WO05000000CzQJGA0","actvities":null}';
        r.xadtx4__c = '{"shareHoldersType":"onlyMem","shareDetails":{"totalShares":100,"shareValue":1000},"members":[{"role":"Shareholder","ctg":"Shareholder","ctgCode":"sh","gender":"F","fname":"XXXXUBBB","lname":"UBO","passportNo":"J8369854","email":"s@s.com","nationality":"Albania","mobile":"527290539","sh":50,"fullName":"UBO XXXXUBBB","pIssuedDate":"10/10/2020","pExpDate":"10/10/2025","dob":"23/09/1959","address":"qwewqeq","placeissued":"HYDERABAD","phoneno":"131231","moreshares":false,"directorShares":false,"corpbody":false,"managementcontrol":false,"controlsCorpBody":false,"Area":"","street":"","city":"","buildingname":"","pobox":"","resnum":"","cityhm":"","countryhm":"","resphone":"","mobnumhm":"","legals":"","uboShDt":""},{"role":"Shareholder","ctg":"Shareholder","ctgCode":"sh","gender":"F","fname":"XXXXUBBB","lname":"asdacccvxvx","passportNo":"J8369854dsdsdsds","email":"ss@ee.com","nationality":"Canada","mobile":"527897653","sh":50,"fullName":"asdacccvxvx XXXXUBBB","pIssuedDate":"10/10/2020","pExpDate":"10/10/2026","passportId":"","dob":"23/09/1959","address":"eqweqwe","corpORind":"ind","placeissued":"asdada","phoneno":"12312313213213","moreshares":false,"directorShares":false,"corpbody":false,"managementcontrol":false,"controlsCorpBody":false,"Area":"","street":"","city":"","buildingname":"","pobox":"","resnum":"","cityhm":"","countryhm":"","resphone":"","mobnumhm":"","legals":"","uboShDt":""}],"currentpgid":"pg1","dropDownData":{"gm":{"disabled":false,"selected":"J8369854"},"ub":{"disabled":false},"bd":{"disabled":false,"selected":"J8369854"},"lr":{"disabled":false,"selected":"J8369854"},"sh":{}}}';
        r.xfb__c = 'Branch of UAE Company';
        r.xuvdet__c = '{"issuingauth":"12312","cntry1":"","addcity":"32131","ofcphone":"12312313","ofceml":"s@g.com"}';
        r.xadtx5__c = '[{"type":"Industrial Land","tycode":"il","info":{"Size required":"243424","Connected Power Load Required":"23423","Anticipated amount of water for your industry":"23424","Estimated BUA DM range (35-50%)":"44"}}]';

        update r;

        System.debug('rqItSet[0].rq__c:: ' + rqItSet[0].rq__c);
        reqMap.put(rqItSet[0].id, r);
        grqWsOnboard.updateAccInfo(rqItSet, reqMap, 'Onboarding', 'fetchAccInfo');

        grqWsOnboard.frmtAddrs('testadreess street1 testLocation testCountry test123455POBOX');
        grqWsOnboard.frmtAddrs('testadreesstest123455POBOXtestadreesstest123455POBOX');
        grqWsOnboard.frmtAddrs('testadreesstest123455POBOX');

        grqWsOnboard.frmStr('testadreesstest123455POBOXtestadreesstest123455POBOX');
        grqWsOnboard.strDate('2021/11/11');

        grqWsOnboard.getPySchedules();
        List < id > accIdlst = new List < id > ();
        accIdlst.add(accLst[0].id);
        List < id > rqIdlst = new List < id > ();
        rqIdlst.add(r.id);
        grqWsOnboard.closeOnbAcc(rqIdlst, accIdlst, srvcLst[0].id);
        grqWsOnboard.updateUsrAccess(accIdlst);
        grqWsOnboard.QuoteInfo qinfo = new grqWsOnboard.QuoteInfo();
        qinfo.requestId = 'tst';
        List < grqWsOnboard.QuoteInfo > qlst = new List < grqWsOnboard.QuoteInfo > ();
        grqWsOnboard.fetchLeaseDetails(qlst, 'tst');


        grqWsOnboard.Records rec = new grqWsOnboard.Records();
        rec.crmAccId = rec.crmAccId;
        rec.crmAccName = rec.crmAccName;
        rec.nameResWorkid = rec.nameResWorkid;
        rec.scWorkid = rec.scWorkid;
        rec.brandWorkid = rec.brandWorkid;
        rec.hseWorkid = rec.hseWorkid;
        rec.requestid = rec.requestid;
        rec.usrName = rec.usrName;
        rec.caseid = rec.caseid;
        rec.oppId = rec.oppId;
        rec.onbReqid = rec.onbReqid;
        rec.respMsg = rec.respMsg;
        rec.isSuccess = rec.isSuccess;
        rec.members = rec.members;
        rec.shareDetails = rec.shareDetails;
        rec.workorders = rec.workorders;
        rec.licenseType = rec.licenseType;
        rec.dedCompanyName = rec.dedCompanyName;
        rec.proposedLegalForm = rec.proposedLegalForm;
        rec.dedLeaseType = rec.dedLeaseType;
        rec.parentCompany = rec.parentCompany;
        rec.dedActivities = rec.dedActivities;
        rec.countryOfIncorp = rec.countryOfIncorp;
        rec.dedLicense = rec.dedLicense;
        rec.issuingAuthority = rec.issuingAuthority;
        rec.ofcAddress = rec.ofcAddress;
        rec.ofcEmail = rec.ofcEmail;
        rec.ofcPhone = rec.ofcPhone;
        rec.ofcCountry = rec.ofcCountry;
        rec.businessName1 = rec.businessName1;
        rec.businessName2 = rec.businessName2;
        rec.businessName3 = rec.businessName3;
        rec.nationality = rec.nationality;
        rec.pcRegNo = rec.pcRegNo;
        rec.pcDOI = rec.pcDOI;
        rec.fullName = rec.fullName;
        rec.fullNameAr = rec.fullNameAr;
        rec.prmFirstName = rec.prmFirstName;
        rec.prmLastName = rec.prmLastName;
        rec.prmEmail = rec.prmEmail;
        rec.prmPhone = rec.prmPhone;
        rec.prmMobile = rec.prmMobile;
        rec.BusinessPark = rec.BusinessPark;
        rec.StageName = rec.StageName;
        rec.AgNo = rec.AgNo;
        rec.crmOppId = rec.crmOppId;
        rec.lcExpdate = rec.lcExpdate;
        rec.ContractStartDate = rec.ContractStartDate;
        rec.ContractEndDate = rec.ContractEndDate;
        rec.Category = rec.Category;
        rec.SubCategory = rec.SubCategory;
        rec.ContractStatus = rec.ContractStatus;
        rec.ContractStatusReason = rec.ContractStatusReason;
        rec.productName = rec.productName;
        rec.skipLeaseValidations = rec.skipLeaseValidations;
        rec.quotes = rec.quotes;
        rec.paymentSchedules = rec.paymentSchedules;
        rec.Invoices = rec.Invoices;
        rec.Products = rec.Products;
        rec.actvities = rec.actvities;
        rec.documents = rec.documents;
        rec.shareHoldersType = rec.shareHoldersType;
        rec.currentpgid = rec.currentpgid;
        rec.noofShares = rec.noofShares;
        rec.shareCapital = rec.shareCapital;
        rec.DDAReqNo = rec.DDAReqNo;

        grqWsOnboard.QuoteInfo quo = new grqWsOnboard.QuoteInfo();
        quo.rqtype = quo.rqtype;
        quo.quoteName = quo.quoteName;
        quo.quoteNo = quo.quoteNo;
        quo.AgNo = quo.AgNo;
        quo.status = quo.status;
        quo.quoteId = quo.quoteId;
        quo.opportunityId = quo.opportunityId;
        quo.lsStDt = quo.lsStDt;
        quo.lsEndDt = quo.lsEndDt;
        quo.requestId = quo.requestId;
        quo.locDet = quo.locDet;
        quo.lsStatus = quo.lsStatus;
        quo.productName = quo.productName;
        quo.totalBstRate = quo.totalBstRate;
        quo.totalOfrPrice = quo.totalOfrPrice;
        quo.paymentSchedules = quo.paymentSchedules;
        quo.totalDiscount = quo.totalDiscount;
        quo.units = quo.units;

        grqWsOnboard.paymentScheduleWrapper pysh = new grqWsOnboard.paymentScheduleWrapper();
        pysh.Id = pysh.Id;
        pysh.quote = pysh.quote;
        pysh.billedAmount = pysh.billedAmount;
        pysh.chargeCode = pysh.chargeCode;
        pysh.chargeFrom = pysh.chargeFrom;
        pysh.chargeTo = pysh.chargeTo;
        pysh.description = pysh.description;
        pysh.propertyCode = pysh.propertyCode;
        pysh.tenantCode = pysh.tenantCode;
        pysh.totalDays = pysh.totalDays;
        pysh.vatAmount = pysh.vatAmount;
        pysh.totalAmountIncludingVat = pysh.totalAmountIncludingVat;
        pysh.yearNo = pysh.yearNo;


        grqWsOnboard.Products pd = new grqWsOnboard.Products();
        pd.ProductName = pd.ProductName;
        pd.LineItemName = pd.ProductName;
        pd.UnitNumber = pd.ProductName;


        grqWsOnboard.Unit ut = new grqWsOnboard.Unit();
        ut.name = ut.name;
        ut.floor = ut.floor;
        ut.buildingName = ut.buildingName;
        ut.productName = ut.productName;
        ut.area = ut.area;
        ut.status = ut.status;
        ut.isActive = ut.isActive;



        /*grqWsOnboard.PaymentSchedules psh1=new grqWsOnboard.PaymentSchedules();
        psh1.Id= psh1.Id;
        psh1.quote=psh1.quote;
        psh1.billedAmount=psh1.billedAmount;
        psh1.chargeFrom=psh1.chargeFrom;
        psh1.chargeTo=psh1.chargeTo;
        psh1.description= psh1.description;
        psh1.totalDays=psh1.totalDays;
        psh1.vatAmount=psh1.vatAmount;
        psh1.totalAmountIncludingVat=psh1.totalAmountIncludingVat;
        psh1.yearNo=psh1.yearNo;        
        psh1.chargeCode=psh1.chargeCode;
        psh1.propertyCode=psh1.propertyCode;
        psh1.tenantCode=psh1.tenantCode;        
        psh1.schName=psh1.schName;
        psh1.billedAmt=psh1.billedAmt;
        psh1.term=psh1.term;*/

        Test.stopTest();
    }


    static testmethod void test2() {
        grqWsOnboard.QuoteInfo qi = new grqWsOnboard.QuoteInfo();
        qi.rqtype = '';
        qi.quoteName = '';
        qi.quoteNo = '';
        qi.AgNo = '';
        qi.status = '';
        qi.quoteId = '';
        qi.opportunityId = '';
        qi.lsStDt = '';
        qi.lsEndDt = '';
        qi.requestId = '';
        qi.locDet = '';
        qi.lsStatus = '';
        qi.productName = '';
        qi.totalBstRate = 10;
        qi.totalOfrPrice = 10;
        qi.totalDiscount = 10;

        grqWsOnboard.Unit unit = new grqWsOnboard.Unit();
        unit.name = 'test';
        unit.floor = 'test';
        unit.buildingName = 'test';
        unit.productName = 'test';
        unit.status = 'test';
        unit.area = 1200;
        unit.isActive = true;

        grqWsOnboard.Products pr = new grqWsOnboard.Products();
        pr.ProductName = '';
        pr.LineItemName = '';
        pr.UnitNumber = '';

        grqWsOnboard.PaymentSchedules pys = new grqWsOnboard.PaymentSchedules(null);
        pys.quote = '';
        pys.billedAmount = 0;
        pys.chargeFrom = '';
        pys.chargeTo = '';
        pys.description = '';
        pys.totalDays = 10;
        pys.vatAmount = 5;
        pys.totalAmountIncludingVat = 10;
        pys.yearNo = '';
        pys.chargeCode = '';
        pys.propertyCode = '';
        pys.tenantCode = '';
        pys.schName = '';
        pys.billedAmt = 10;
        pys.term = '';

        grqWsOnboard.paymentScheduleWrapper pysw = new grqWsOnboard.paymentScheduleWrapper();

        pysw.quote = '';
        pysw.billedAmount = 1000;
        pysw.chargeCode = '';
        pysw.chargeFrom = '';
        pysw.chargeTo = '';
        pysw.description = '';
        pysw.propertyCode = '';
        pysw.tenantCode = '';
        pysw.totalDays = 30;
        pysw.vatAmount = 55;
        pysw.totalAmountIncludingVat = 8797;
        pysw.yearNo = '';
    }

    static testmethod void test3() {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new LicenceInfomockResponse());
        Account acc = new Account();
        grqWsOnboard.updateAccName(acc);
        grqWsOnboard.AccInfo wrapperList = new grqWsOnboard.AccInfo();
        wrapperList.licNo = '34534534';
        grqWsOnboard.getLicInfo('34534534', '');
        grqWsOnboard.accInfoNew(wrapperList);
        grqWsOnboard.updateAccLicInfo('1');

        Test.stopTest();
    }

    public class mockResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String dummyResp = '';
            res.setBody(dummyResp);
            res.setStatusCode(200);
            return res;
        }
    }
    public class LicenceInfomockResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String dummyResp = '{"errorMessage":"Success","responseCode":200,"members":[{"attributes":{"type":"Identity_Relation__c","url":"/services/data/v54.0/sobjects/Identity_Relation__c/a1g6F000001zMqzQAE"},"Id":"a1g6F000001zMqzQAE","Position__c":"Manager","Relation_Target__c":"a06D000000SotBLIAZ","Relation_Source__c":"a06D000000SW3kTIAT","Relation_Source__r":{"attributes":{"type":"Identity__c","url":"/services/data/v54.0/sobjects/Identity__c/a06D000000SW3kTIAT"},"Id":"a06D000000SW3kTIAT","Name":"Test One","Full_Name_Arabic__c":"ليو  جوزيف","Nationality__c":"a0AD000000MZZIdMAP","Nationality__r":{"attributes":{"type":"Country__c","url":"/services/data/v54.0/sobjects/Country__c/a0AD000000MZZIdMAP"},"Id":"a0AD000000MZZIdMAP","Name":"India","Arabic_Country_Name__c":"الهند"}}},{"attributes":{"type":"Identity_Relation__c","url":"/services/data/v54.0/sobjects/Identity_Relation__c/a1gD0000000E28pIAC"},"Id":"a1gD0000000E28pIAC","Position__c":"Director","Relation_Target__c":"a06D000000SotBLIAZ","Relation_Source__c":"a06D000000SW3kTIAT","Relation_Source__r":{"attributes":{"type":"Identity__c","url":"/services/data/v54.0/sobjects/Identity__c/a06D000000SW3kTIAT"},"Id":"a06D000000SW3kTIAT","Name":"Test One","Full_Name_Arabic__c":"ليو  Test One","Nationality__c":"a0AD000000MZZIdMAP","Nationality__r":{"attributes":{"type":"Country__c","url":"/services/data/v54.0/sobjects/Country__c/a0AD000000MZZIdMAP"},"Id":"a0AD000000MZZIdMAP","Name":"India","Arabic_Country_Name__c":"الهند"}}}],"shareholders":[{"attributes":{"type":"R_L_Share_Info__c","url":"/services/data/v54.0/sobjects/R_L_Share_Info__c/a2S6F000000qcAUUAY"},"Id":"a2S6F000000qcAUUAY","Identity__c":"a06D000000SW3kTIAT","Number_of_Shares__c":50.00,"Value_of_Share__c":1000.00,"Share_Percentage_New__c":100.00,"Revision__c":"a266F0000023OkGQAU","Identity__r":{"attributes":{"type":"Identity__c","url":"/services/data/v54.0/sobjects/Identity__c/a06D000000SW3kTIAT"},"Id":"a06D000000SW3kTIAT","Name":"Test One","Full_Name_Arabic__c":"ليو  جوزيف","Nationality__c":"a0AD000000MZZIdMAP","RIC__c":"RIC-00004260","Nationality__r":{"attributes":{"type":"Country__c","url":"/services/data/v54.0/sobjects/Country__c/a0AD000000MZZIdMAP"},"Id":"a0AD000000MZZIdMAP","Name":"India","Arabic_Country_Name__c":"الهند"}},"Revision__r":{"attributes":{"type":"R_L_Company_Revision__c","url":"/services/data/v54.0/sobjects/R_L_Company_Revision__c/a266F0000023OkGQAU"},"Id":"a266F0000023OkGQAU","Share_Value__c":1000.00,"Currency__c":"AED","Number_of_Shares__c":50.00,"Share_Capital__c":50000.00}}],"activities":[{"attributes":{"type":"R_L_Licensed_Activity__c","url":"/services/data/v54.0/sobjects/R_L_Licensed_Activity__c/a296F000006fbSRQAY"},"Id":"a296F000006fbSRQAY","Activity_Name__c":"Production - Film, TV, and Radio","R_L_Activity__c":"a1290000007ysrVAAQ","Segment__c":"Production (Film/TV and Radio)","License_Issue_Date__c":"2020-03-04","R_L_Activity__r":{"attributes":{"type":"R_L_Activity__c","url":"/services/data/v54.0/sobjects/R_L_Activity__c/a1290000007ysrVAAQ"},"Id":"a1290000007ysrVAAQ","R_L_Segment__c":"a08D000000Zb703IAB","R_L_Segment__r":{"attributes":{"type":"R_L_Segment__c","url":"/services/data/v54.0/sobjects/R_L_Segment__c/a08D000000Zb703IAB"},"Id":"a08D000000Zb703IAB"}}},{"attributes":{"type":"R_L_Licensed_Activity__c","url":"/services/data/v54.0/sobjects/R_L_Licensed_Activity__c/a29D00000004ZejIAE"},"Id":"a29D00000004ZejIAE","Activity_Name__c":"Post Production","R_L_Activity__c":"a12D0000001YyfFIAS","Segment__c":"Production (Film/TV and Radio)","License_Issue_Date__c":"2012-10-23","R_L_Activity__r":{"attributes":{"type":"R_L_Activity__c","url":"/services/data/v54.0/sobjects/R_L_Activity__c/a12D0000001YyfFIAS"},"Id":"a12D0000001YyfFIAS","R_L_Segment__c":"a08D000000Zb703IAB","R_L_Segment__r":{"attributes":{"type":"R_L_Segment__c","url":"/services/data/v54.0/sobjects/R_L_Segment__c/a08D000000Zb703IAB"},"Id":"a08D000000Zb703IAB"}}}],"licenseinfo":{"attributes":{"type":"Identity__c","url":"/services/data/v54.0/sobjects/Identity__c/a06D000000SotBLIAZ"},"Id":"a06D000000SotBLIAZ","License__c":"1","Licensee_Name__c":"Test FZ LLC","Licensee_Name_Arabic__c":"Test FZ LLC","Legal_Name__c":"Test FZ LLC","Legal_name_Arabic__c":"Test FZ LLC","License_First_Issue_Date__c":"2011-10-23","License_Issue_Date__c":"2021-11-23","License_Expiry_Date__c":"2022-11-22","Manager_In_Charge__c":"a06D000000SW3kTIAT","Legal_Framework__c":"a0CD000000INeCyMAL","Country_of_Incorporation__c":"a0AD000000MZZ00MAH","RecordTypeId":"012D00000006oM6IAI","Manager_In_Charge__r":{"attributes":{"type":"Identity__c","url":"/services/data/v54.0/sobjects/Identity__c/a06D000000SW3kTIAT"},"Id":"a06D000000SW3kTIAT","Name":"Leo Joseph","Full_Name_Arabic__c":"ليو  جوزيف","Nationality__c":"a0AD000000MZZIdMAP","Nationality__r":{"attributes":{"type":"Country__c","url":"/services/data/v54.0/sobjects/Country__c/a0AD000000MZZIdMAP"},"Id":"a0AD000000MZZIdMAP","Name":"India","Arabic_Country_Name__c":"الهند"}},"Legal_Framework__r":{"attributes":{"type":"Legal_Framework__c","url":"/services/data/v54.0/sobjects/Legal_Framework__c/a0CD000000INeCyMAL"},"Id":"a0CD000000INeCyMAL","Name":"Free Zone Limited Liability Company","Legal_Framework_Arabic__c":"شركة منطقة حرة ذات مسؤولية محدودة"},"Country_of_Incorporation__r":{"attributes":{"type":"Country__c","url":"/services/data/v54.0/sobjects/Country__c/a0AD000000MZZ00MAH"},"Id":"a0AD000000MZZ00MAH","Name":"United Arab Emirates","Arabic_Country_Name__c":"الامارات العربية المتحدة"}}}';
            res.setBody(dummyResp);
            res.setStatusCode(200);
            return res;
        }
    }
}