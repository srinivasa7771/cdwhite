@isTest
public class leCtlReqTest {

    @testSetup static void setup() { /*MS*/
        testData.init();
        Account a=testData.accCrt(false);
        Contact sp=testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        testData.bRulesReqCrt();testData.bRulesItemCrt();
        g_srvc_settings__c stg=testData.stgCrt();
        g_Srvc__c s=testData.srvcCrt(stg.Id);
        //gStg__c crtstng = testData.createSetting('test', 'testvalue');

    }

    static testmethod void test1() {
        g_srvc_definition__c sd= new g_srvc_definition__c(Name='test', ptype__c='Normal:10 Days;Express:3 Days;',
            cv__c='NewVisa', sd__c='Apply for new employment visa. Based on the information you provide, you will be either taken to the ‘New Visa’ or ‘Visa Transfer’ process. <br/><br/><strong>The new visa includes:</strong><ul class="ul-style"><li> Entry Permit</li><li> Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li><li> In-country status change (if required)</li></ul><strong>Visa transfer includes:</strong><br/><ul class="ul-style"><li>Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li></u>',
            docslbl__c='Passport - first page;Passport - last page (if applicable);Recent passport size photo (white background);Attested educational certificate (occupation dependent);Emirates ID - front (if available);Emirates ID - back (if available);Existing residence visa page (for transfers only);NOC from the releasing sponsor (for transfers only);Final settlement (for transfers within free zone only);Employment contract (conditional);Valid nationality identity card (for Pakistan, Afghanistan & Iraqi nationals - conditional);Medical Certificate from Origin Country Sri Lankan, Indonesian and Ethiopian nationalities (conditional) ;Good Contact Certificate for Kenyan nationalities (conditional);Health insurance card or certificate or opt for ADNIC Insurance during the application (for transfers only)');
        insert sd;
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
        system.debug('srvcLst----'+srvcLst);
        Contact c = new Contact(Id=conLst[0].Id, mbs__c=50000, eidid__c='784198774283257', eidedt__c=system.today().addyears(3));
        update c;

        List<g_srvc_settings__c> srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];
        srvcsettings[0].reqq__c = 'Select  Account_Brand__c, xvch__c, crflg__c, inUAE__c, xmamd__c, Acc__r.mtc__c, is_sponsered_fl__c, PRM_Name__c, PRM_Email__c, PRM_MobileNo__c, PRM_LandlineNo__c, piFlg__c, expflg__c, slaN__c, AUPV__c, xcamdt__c, AUP__c, Acc__r.Name, srvc__r.sdg__r.skpsd__c, xsi__c, xai__c, srvc__r.Milestone_Stage__c, srvc__r.sdg__r.ptype__c, srvc__r.sdg__r.cv__c, srvc__r.AddOn__c, srvc__r.AddOnSrv__c, Acc__r.lcedt__c, acc__r.lctp__c, srvc__r.xoi__c, xfb__c, xchn__c, xcsnc__c, xfsr__c, xddatc__c, xadtx3__c, xbtnm__c, xppor__c, rtacn__c, xccn__c, x30gr__c, xccl__c, xeng__c, xcawp__c, xdedln__c, ias__c, xcn__c, xlt__c, xcddocs__c, xtpa__c, xla2l__c  , xdedc__c, xdccaRq__c, Print__c   , xdrv__c , xadtx4__c, Provisional_Issuance__c, xaed__c, xlicd__c, xcs__c, xanum__c, xpmsle__c, xppsfv__c, xcne__c, xcna__c, xlne__c, xlna__c, xalfe__c, xaccbrand__c, Acc__r.lcidt1arb__c, Acc__r.licexdt__c, Acc__r.Legal_Framework__c, Acc__r.lcidt__c, Acc__r.lc__c, dsgu__c, epexpdt__c , Acc__r.lcedtarb__c, xmloc__c, xvn__c, xdei__c, xuvdet__c, xadtx1__c, xadtx2__c, Id, Name, STA__c, AT__c, AP__c, AOP__c, xdtcls__c, dsc__c, dsc__r.prct__c, xfpc__c, xnry__c, spCh__c, rmob__c, xawb__c, xaloc__c, xbrnd__c, xbn__c, nt__c, srvc__r.uid__c , srvc__r.pstg__c, srvc__r.kstp__c, xltr__c, xtcdl__c, InsChk__c, xadh__c, srvc__c, srvc__r.name, srvc__r.lbl__c, srvc__r.dsc__c, srvc__r.Prk__c, srvc__r.AccTp__c, Acc__r.lcsta__c, Con__c, ConRol__c , ConSTA__c, srvc__r.ckgsnc__c, srvc__r.snc__c, srvc__r.stg__r.pg__c, srvc__r.stg__r.apx__c, srvc__r.stg__r.reqq__c, Acc__r.lrd__c, Acc__r.onar__c, Acc__c, Acc__r.ORACLE_PARTY_ID__c, Acc__r.Type, Acc__r.Prk__c, Acc__r.Park__c, Acc__r.lcsnc__c, Acc__r.lcsncnt__c, Acc__r.psasnc__c, Acc__r.psasncnt__c, Acc__r.ecsnc__c, Acc__r.ecsncnt__c, Acc__r.cosnc__c, Acc__r.cosncnt__c, Acc__r.bgsnc__c, Acc__r.bgsncnt__c, Acc__r.snc__c, Acc__r.info__c, Acc__r.vestd__c, Acc__r.vbtemp__c, Acc__r.speabsc__c, Acc__r.os__c, LastModifiedDate, LastModifiedById, CreatedDate, CreatedById, xepAtt__c, xeidav__c, xcma__c, xcacctp__c, xcha__c, xcarea__c, xcmbs__c, xcbd__c, xccty__c, xcbc__c, xcnc__c, xceidid__c, xceidedt__c, xceididt__c, xceml__c, xcemrt__c, xcfan__c, xcfs__c, xcfn__c, xcfnar__c, xchph__c, xcln__c, xclnar__c, xcms__c, xcmn__c, xcmnar__c, xcmob__c, xcmon__c, xcof__c, xcot__c, xcjb__c, xcmoa__c, xcp__c, xcped__c, xcpid__c, xcpic__c, xcpip__c, xcbp__c, xcpobx__c, xcpobxarea__c, xcnp__c, xcql__c, xcrlg__c, xcslt__c, xclng__c, xcstrt__c, xcmta__c, amsgs__c, action__c, srvc__r.lsctg__c, os__c , (select id, Name, estE__c, actE__c, kstp__c, sla__c, acts__c, itm__c, itm__r.exp__c, itm__r.itm__r.exp__c, itm__r.itm__r.Name, itm__r.itm__r.lbl__c, f__c, f__r.Name, f__r.lbl__c, f__r.Tp__c, t__c, T__r.hisl__c , t__r.Name, t__r.kstp__c, t__r.lbl__c, t__r.Tp__c , CreatedBy.Name, CreatedById, vf__c, vt__c, Duration__c, to__c, xawb__c , Activity__c, cd__c, Within_SLA__c  from Status_History__r   where isDeleted=false order by itm__r.itm__r.ord__c, CreatedDate), (Select Id, Name, mxAts__c, mnAts__c, ats__c, nt__c, or__c, reqAts__c, reqOr__c, tplt__c, x30gr__c, upOk__c, mbr__c, mbr__r.Name From rDocs__r where Req__c=true and IsDeleted=false), (Select Id, Name, STA__c, dt__c, A__c, md__c, TP__c , fwf__c From Transactions__r where isDeleted=false), (select Name, Status__c, Summary__c, Request__c, More_Details__c, Type__c, createddate from Requests__r where isDeleted=false ORDER BY createddate DESC), (select id, Name, RQ__c, nc__c, rv__c, m__c, m__r.Name, vSTA__c, AP__c, AOP__c, AD__c, nt__c, xprnt__c, xr__c, xcnotes__c, xef__c , xips__c, Dsc__c, DscApp__c, KF__c, cN__c, scN__c, smN__c, exp__c, cXP__c, scXP__c, smXP__c, itm__c, itm__r.xf__c, itm__r.cd__c, itm__r.Name, itm__r.lbl__c, itm__r.Tp__c, itm__r.Req__c, itm__r.exp__c, itm__r.prcEdt__c, itm__r.dSTA__c, sta__c, sta__r.cd__c, sta__r.Name, sta__r.lbl__c, sta__r.Tp__c, sta__r.rc__c, sta__r.noEXP__c, LastModifiedDate, LastModifiedById, CreatedDate, CreatedById, sta__r.staown__c, sta__r.Next_Status__c, sta__r.amsgs__c, sta__r.next_status__r.rqSTA__c, sta__r.next_status__r.Courier_Stage__c, sta__r.Courier_Stage__c, sta__r.rqSTA__c, sta__r.imsgs__c, sta__r.action__c, sta__r.statype__c, xcdocs__c, xdcdocs__c, xfld__c, ccrmid__c From Items__r where IsDeleted=false order by itm__r.ord__c) , (SELECT id, AWB_Number__c, Courier_Booking_Log__c, Courier_req__c, Duration__c, End_Date__c, From_Courier_Status__c, Start_Date__c, To_Courier_Status__c, AWB_No__c, Activity__c, Item_Name__c, CreatedBy.name  , tp__c FROM Courier_Histories__r), (Select Id, CaseNumber, Origin, Type, Subject, Status, Category__c, Sub_Category__c, CreatedDate, ClosedDate from Cases__r Order By IsClosed, CreatedDate Desc), (select id, name from Attachments order by createddate desc), srvc__r.Category__c, xcqc__c, xcdd__c, xcqemrt__c, xvtyp__c, Location_Brand__c, xltp__c, Con__r.rol__c, Con__r.firstname, con__r.LastName, con__r.emrt__c, con__r.p__c, Con__r.Email, Con__r.MobilePhone, Con__r.Salutation, Con__r.ms__c, Con__r.nc__c, Con__r.eidid__c, Con__r.pobx__c, Con__r.mbs__c, Con__r.ma__c, Con__r.mta__c, Con__r.moa__c, Con__r.Birthdate, Con__r.rpui__c, xcst__c  From g_Req__c';
        update srvcsettings[0];

        Contact emp=testData.conCrt(conLst[0], accLst[0].Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        system.debug('conLst[0].Id'+conLst[0].Id);
        g_Req__c r=testData.reqCrt(accLst[0].Id, srvcLst[0].Id, emp.Id, 'Open', srvcsettings[0].reqq__c);
        system.Debug('request r'+r);

        r.xadtx3__c = '{"workorders":[{"status":"Submitted", "recType":"Brand_Approval", "recid":"0WO05000000DSbcGAG", "parentid":null, "members":null, "ddaRequestId":null}, {"status":"Submitted", "recType":"License_Registration_Request", "recid":"0WO05000000DSbeGAG", "parentid":null, "members":null, "ddaRequestId":null}, {"status":"Submitted", "recType":"Security_Clearance", "recid":"0WO05000000DSbdGAG", "parentid":null, "members":null, "ddaRequestId":null}], "usrName":"Huwaida Atrach", "SubCategory":null, "StageName":null, "shareHoldersType":null, "shareDetails":null, "shareCapital":null, "scWorkid":"0WO05000000DSbdGAG", "respMsg":"Success", "requestid":"a0E1s0000000zELEAY", "quotes":[], "proposedLegalForm":"DDA", "Products":null, "productName":null, "prmPhone":"0097143692241", "prmMobile":"971500000000", "prmLastName":"Atrach", "prmFirstName":"Huwaida", "prmEmail":"huwaida.atrach@dsp.ae.invalid", "pcRegNo":null, "pcDOI":null, "paymentSchedules":null, "parentCompany":null, "onbReqid":"a2l05000000CNUmAAO", "ofcPhone":null, "ofcEmail":null, "ofcCountry":null, "ofcAddress":null, "noofShares":null, "nationality":null, "nameResWorkid":"0WO05000000DSbeGAG", "members":[{"street":null, "sh":"100", "security":null, "salutation":"Ms.", "rpNo":null, "rpExpDate":null, "role":"Member;General Manager;Legal Representative;Ultimate Beneficiary", "postalCode":null, "placeissued":"India", "pIssuedDate":null, "phoneno":"132131", "pExpDate":"2023-10-12", "passportNo":"J8369854", "passportId":null, "nationality":"India", "mobile":"+971527826562", "mname":null, "mailingStreet":null, "mailingPostalCode":null, "mailingCountry":null, "mailingCity":null, "lnameAr":null, "lname":"RAMADUGULA", "gender":"Female", "fullName":null, "fnameAr":null, "fname":"SITA MAHA LAKSHMI", "email":"a@a.com", "eid":null, "eExpDate":null, "dob":"1959-09-23", "ctgCode1":null, "ctgCode":null, "ctg":null, "corpORind":"Individual Shareholder", "contryCode":null, "conid":"0030500000JmdhoAAB", "city":null, "birthplace":null, "address":null}], "licenseType":"DDA", "lcExpdate":null, "issuingAuthority":null, "isSuccess":true, "Invoices":[], "hseWorkid":null, "fullNameAr":null, "fullName":null, "documents":[{"name":"Application Form", "gracePeriod":false, "description":"Application Form", "ddaDocId":"a3eO0000000iHMjIAM", "ccrmParentId":"0WO05000000DSbeGAG", "ccrmDocId":"a0H05000001jHiFEAU"}, {"name":"Signed Resolution", "gracePeriod":false, "description":"Signed Resolution", "ddaDocId":"a3eO0000000iHMlIAM", "ccrmParentId":"0WO05000000DSbeGAG", "ccrmDocId":"a0H05000001jHiHEAU"}, {"name":"Signed AOA", "gracePeriod":false, "description":"Signed AOA", "ddaDocId":"a3eO0000000iHMkIAM", "ccrmParentId":"0WO05000000DSbeGAG", "ccrmDocId":"a0H05000001jHiGEAU"}], "dedLicense":null, "dedLeaseType":null, "dedCompanyName":null, "dedActivities":null, "DDAReqNo":null, "currentpgid":null, "crmOppId":null, "crmAccId":"0010500000MTxeWAAT", "countryOfIncorp":null, "ContractStatusReason":null, "ContractStatus":null, "ContractStartDate":null, "ContractEndDate":null, "Category":null, "caseid":null, "BusinessPark":"DDA", "businessName3":null, "businessName2":null, "businessName1":null, "brandWorkid":"0WO05000000DSbcGAG", "AgNo":null, "actvities":[{"vatAmount":null, "totalPrice":null, "term":null, "tenantCode":null, "segment":"Media & Marketing Services", "propertyCode":null, "price":null, "name":"Digital Marketing", "docs":null, "description":null, "chargeTo":null, "chargeFrom":null, "chargeCode":null, "actId":"a0L2R00000LOmTMUA1"}]}';
        update r;

        Test.startTest();
        PageReference myVfPage = new PageReference('/apex/lerqOb');
        myVfPage.getParameters().put('id', r.Id);
        myVfPage.getParameters().put('sid', srvcLst[0].Id);
        Test.setCurrentPage(myVfPage);

        String rid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));

        ApexPages.StandardController sc = new ApexPages.StandardController(r);

        ApexPages.currentPage().getParameters().put('id', r.Id);
        leCtlReq lr = new leCtlReq(sc);

        lr.reqItems = new Map<Id, g_reqitem__c>();
        lr.rqItemDocLst = new List<g_reqitemDoc__c>();
        lr.attGCId = '';

        lr.navigatePage();
        try{lr.authenticateUser();}catch (Exception e) {}

        String segJson = '[{"name":"Agricultural, Forestry, Horticulture", "segId":"a08D000000Zb6yzIAB", "allowed":"5", "price":"15000.00", "SegActivities":[{"name":"Import and Re-Export", "actId":"a12D0000001YyZ1IAK", "price":"15000.00", "docs":[]}, {"name":"Manufacturing and Production", "actId":"a12D0000001YyZ3IAK", "price":"25000.00", "docs":[]}, {"name":"Marketing and Sales Promotion", "actId":"a12D0000001YyZ2IAK", "price":"15000.00", "docs":[]}]}, {"name":"Air and Environment", "segId":"a08D000000Zb700IAB", "allowed":"5", "price":"15000.00", "SegActivities":[{"name":"Consultancy", "actId":"a12D0000001Yyf2IAC", "price":"15000.00", "docs":[]}, {"name":"Management", "actId":"a12D0000001ZP4cIAG", "price":"15000.00", "docs":[]}]}, {"name":"Educational Service Provider", "segId":"a08D000000Zb70LIAR", "allowed":"1", "price":"15000.00", "SegActivities":[{"name":"Academic Support Services", "actId":"a12D0000001YyhDIAS", "price":"15000.00", "docs":[]}]}]';
        myVfPage.getParameters().put('segmentActivityJson', segJson);
        lr.updateRequest();

        lr.docName = 'MoA and AoA of Parent Company'; lr.imageBase64 = 'test1231';
        lr.saveAttachment();
        lr.saveItemAttachment();

        lr.saveOpen();
        lr.save();
        lr.CancelR();
        leCtlReq.DEG_Checksum('abc', 'def');

        lr.cs = new case();
        lr.saveCase();
        lr.proceedToPay();

        List<Attachment> delAtt = [select id, name from attachment limit 1];
        lr.delDocID = delAtt[0].id;
        lr.deleteDoc();

        leCtlReq.Address ad = new leCtlReq.Address();
        ad.city = ''; ad.emirates='';
        ad.postCode='1222'; ad.street='';

        leCtlReq lr2 = new leCtlReq();

    }
    static testmethod void test2() {
        g_srvc_definition__c sd= new g_srvc_definition__c(Name='test', ptype__c='Normal:10 Days;Express:3 Days;',
            cv__c='NewVisa', sd__c='Apply for new employment visa. Based on the information you provide, you will be either taken to the ‘New Visa’ or ‘Visa Transfer’ process. <br/><br/><strong>The new visa includes:</strong><ul class="ul-style"><li> Entry Permit</li><li> Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li><li> In-country status change (if required)</li></ul><strong>Visa transfer includes:</strong><br/><ul class="ul-style"><li>Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li></u>',
            docslbl__c='Passport - first page;Passport - last page (if applicable);Recent passport size photo (white background);Attested educational certificate (occupation dependent);Emirates ID - front (if available);Emirates ID - back (if available);Existing residence visa page (for transfers only);NOC from the releasing sponsor (for transfers only);Final settlement (for transfers within free zone only);Employment contract (conditional);Valid nationality identity card (for Pakistan, Afghanistan & Iraqi nationals - conditional);Medical Certificate from Origin Country Sri Lankan, Indonesian and Ethiopian nationalities (conditional) ;Good Contact Certificate for Kenyan nationalities (conditional);Health insurance card or certificate or opt for ADNIC Insurance during the application (for transfers only)');
        insert sd;
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
        system.debug('srvcLst----'+srvcLst);
        Contact c = new Contact(Id=conLst[0].Id, mbs__c=50000, eidid__c='784198774283257', eidedt__c=system.today().addyears(3));
        update c;

        List<g_srvc_settings__c> srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];
        srvcsettings[0].reqq__c = 'Select  Account_Brand__c, xvch__c, crflg__c, inUAE__c, xmamd__c, Acc__r.mtc__c, is_sponsered_fl__c, PRM_Name__c, PRM_Email__c, PRM_MobileNo__c, PRM_LandlineNo__c, piFlg__c, expflg__c, slaN__c, AUPV__c, xcamdt__c, AUP__c, Acc__r.Name, srvc__r.sdg__r.skpsd__c, xsi__c, xai__c, srvc__r.Milestone_Stage__c, srvc__r.sdg__r.ptype__c, srvc__r.sdg__r.cv__c, srvc__r.AddOn__c, srvc__r.AddOnSrv__c, Acc__r.lcedt__c, acc__r.lctp__c, srvc__r.xoi__c, xfb__c, xchn__c, xcsnc__c, xfsr__c, xddatc__c, xadtx3__c, xbtnm__c, xppor__c, rtacn__c, xccn__c, x30gr__c, xccl__c, xeng__c, xcawp__c, xdedln__c, ias__c, xcn__c, xlt__c, xcddocs__c, xtpa__c, xla2l__c  , xdedc__c, xdccaRq__c, Print__c   , xdrv__c , xadtx4__c, Provisional_Issuance__c, xaed__c, xlicd__c, xcs__c, xanum__c, xpmsle__c, xppsfv__c, xcne__c, xcna__c, xlne__c, xlna__c, xalfe__c, xaccbrand__c, Acc__r.lcidt1arb__c, Acc__r.licexdt__c, Acc__r.Legal_Framework__c, Acc__r.lcidt__c, Acc__r.lc__c, dsgu__c, epexpdt__c , Acc__r.lcedtarb__c, xmloc__c, xvn__c, xdei__c, xuvdet__c, xadtx1__c, xadtx2__c, Id, Name, STA__c, AT__c, AP__c, AOP__c, xdtcls__c, dsc__c, dsc__r.prct__c, xfpc__c, xnry__c, spCh__c, rmob__c, xawb__c, xaloc__c, xbrnd__c, xbn__c, nt__c, srvc__r.uid__c , srvc__r.pstg__c, srvc__r.kstp__c, xltr__c, xtcdl__c, InsChk__c, xadh__c, srvc__c, srvc__r.name, srvc__r.lbl__c, srvc__r.dsc__c, srvc__r.Prk__c, srvc__r.AccTp__c, Acc__r.lcsta__c, Con__c, ConRol__c , ConSTA__c, srvc__r.ckgsnc__c, srvc__r.snc__c, srvc__r.stg__r.pg__c, srvc__r.stg__r.apx__c, srvc__r.stg__r.reqq__c, Acc__r.lrd__c, Acc__r.onar__c, Acc__c, Acc__r.ORACLE_PARTY_ID__c, Acc__r.Type, Acc__r.Prk__c, Acc__r.Park__c, Acc__r.lcsnc__c, Acc__r.lcsncnt__c, Acc__r.psasnc__c, Acc__r.psasncnt__c, Acc__r.ecsnc__c, Acc__r.ecsncnt__c, Acc__r.cosnc__c, Acc__r.cosncnt__c, Acc__r.bgsnc__c, Acc__r.bgsncnt__c, Acc__r.snc__c, Acc__r.info__c, Acc__r.vestd__c, Acc__r.vbtemp__c, Acc__r.speabsc__c, Acc__r.os__c, LastModifiedDate, LastModifiedById, CreatedDate, CreatedById, xepAtt__c, xeidav__c, xcma__c, xcacctp__c, xcha__c, xcarea__c, xcmbs__c, xcbd__c, xccty__c, xcbc__c, xcnc__c, xceidid__c, xceidedt__c, xceididt__c, xceml__c, xcemrt__c, xcfan__c, xcfs__c, xcfn__c, xcfnar__c, xchph__c, xcln__c, xclnar__c, xcms__c, xcmn__c, xcmnar__c, xcmob__c, xcmon__c, xcof__c, xcot__c, xcjb__c, xcmoa__c, xcp__c, xcped__c, xcpid__c, xcpic__c, xcpip__c, xcbp__c, xcpobx__c, xcpobxarea__c, xcnp__c, xcql__c, xcrlg__c, xcslt__c, xclng__c, xcstrt__c, xcmta__c, amsgs__c, action__c, srvc__r.lsctg__c, os__c , (select id, Name, estE__c, actE__c, kstp__c, sla__c, acts__c, itm__c, itm__r.exp__c, itm__r.itm__r.exp__c, itm__r.itm__r.Name, itm__r.itm__r.lbl__c, f__c, f__r.Name, f__r.lbl__c, f__r.Tp__c, t__c, T__r.hisl__c , t__r.Name, t__r.kstp__c, t__r.lbl__c, t__r.Tp__c , CreatedBy.Name, CreatedById, vf__c, vt__c, Duration__c, to__c, xawb__c , Activity__c, cd__c, Within_SLA__c  from Status_History__r   where isDeleted=false order by itm__r.itm__r.ord__c, CreatedDate), (Select Id, Name, mxAts__c, mnAts__c, ats__c, nt__c, or__c, reqAts__c, reqOr__c, tplt__c, x30gr__c, upOk__c, mbr__c, mbr__r.Name From rDocs__r where Req__c=true and IsDeleted=false), (Select Id, Name, STA__c, dt__c, A__c, md__c, TP__c , fwf__c From Transactions__r where isDeleted=false), (select Name, Status__c, Summary__c, Request__c, More_Details__c, Type__c, createddate from Requests__r where isDeleted=false ORDER BY createddate DESC), (select id, Name, RQ__c, nc__c, rv__c, m__c, m__r.Name, vSTA__c, AP__c, AOP__c, AD__c, nt__c, xprnt__c, xr__c, xcnotes__c, xef__c , xips__c, Dsc__c, DscApp__c, KF__c, cN__c, scN__c, smN__c, exp__c, cXP__c, scXP__c, smXP__c, itm__c, itm__r.xf__c, itm__r.cd__c, itm__r.Name, itm__r.lbl__c, itm__r.Tp__c, itm__r.Req__c, itm__r.exp__c, itm__r.prcEdt__c, itm__r.dSTA__c, sta__c, sta__r.cd__c, sta__r.Name, sta__r.lbl__c, sta__r.Tp__c, sta__r.rc__c, sta__r.noEXP__c, LastModifiedDate, LastModifiedById, CreatedDate, CreatedById, sta__r.staown__c, sta__r.Next_Status__c, sta__r.amsgs__c, sta__r.next_status__r.rqSTA__c, sta__r.next_status__r.Courier_Stage__c, sta__r.Courier_Stage__c, sta__r.rqSTA__c, sta__r.imsgs__c, sta__r.action__c, sta__r.statype__c, xcdocs__c, xdcdocs__c, xfld__c, ccrmid__c From Items__r where IsDeleted=false order by itm__r.ord__c) , (SELECT id, AWB_Number__c, Courier_Booking_Log__c, Courier_req__c, Duration__c, End_Date__c, From_Courier_Status__c, Start_Date__c, To_Courier_Status__c, AWB_No__c, Activity__c, Item_Name__c, CreatedBy.name  , tp__c FROM Courier_Histories__r), (Select Id, CaseNumber, Origin, Type, Subject, Status, Category__c, Sub_Category__c, CreatedDate, ClosedDate from Cases__r Order By IsClosed, CreatedDate Desc), (select id, name from Attachments order by createddate desc), srvc__r.Category__c, xcqc__c, xcdd__c, xcqemrt__c, xvtyp__c, Location_Brand__c, xltp__c, Con__r.rol__c, Con__r.firstname, con__r.LastName, con__r.emrt__c, con__r.p__c, Con__r.Email, Con__r.MobilePhone, Con__r.Salutation, Con__r.ms__c, Con__r.nc__c, Con__r.eidid__c, Con__r.pobx__c, Con__r.mbs__c, Con__r.ma__c, Con__r.mta__c, Con__r.moa__c, Con__r.Birthdate, Con__r.rpui__c, xcst__c  From g_Req__c';
        update srvcsettings[0];

        Contact emp=testData.conCrt(conLst[0], accLst[0].Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        system.debug('conLst[0].Id'+conLst[0].Id);
        g_Req__c r=testData.reqCrt(accLst[0].Id, srvcLst[0].Id, emp.Id, 'Open', srvcsettings[0].reqq__c);
        system.Debug('request r'+r);
        Test.startTest();
        PageReference myVfPage = new PageReference('/apex/lerqOb');
        myVfPage.getParameters().put('id', r.Id);
        myVfPage.getParameters().put('sid', srvcLst[0].Id);
        Test.setCurrentPage(myVfPage);

        String rid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('id'));

        ApexPages.StandardController sc = new ApexPages.StandardController(r);
        r.xceididt__c = date.today();
        ApexPages.currentPage().getParameters().put('id', r.Id);
        leCtlReq lr = new leCtlReq(sc);
        lr.trdStDate = Date.today().format();
        lr.trdEdDate = Date.today().format();
        lr.taxRdNum = 'werwete';
        lr.saveDraft();
        lr.conInfo();
        lr.saveCommAdd();
    }
}