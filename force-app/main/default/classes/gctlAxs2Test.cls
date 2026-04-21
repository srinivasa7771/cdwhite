@isTest
public class gctlAxs2Test {

    @testSetup static void setup() { /*MS*/
        testData.init();
        Account a = testData.accCrt(false);
        Contact sp = testData.conCrt(null, a.Id, 'Active', 'Employee', 'Pass1', 'Egypt');
        testData.bRulesReqCrt(); testData.bRulesItemCrt();
        g_srvc_settings__c stg = testData.stgCrt();
        g_Srvc__c s = testData.srvcCrt(stg.Id);

    }

    static testmethod void test1() {

        g_srvc_definition__c sd= new g_srvc_definition__c(Name='test', ptype__c='Normal:10 Days;Express:3 Days;',
            cv__c='NewVisa', sd__c='Apply for new employment visa. Based on the information you provide, you will be either taken to the ‘New Visa’ or ‘Visa Transfer’ process. <br/><br/><strong>The new visa includes:</strong><ul class="ul-style"><li> Entry Permit</li><li> Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li><li> In-country status change (if required)</li></ul><strong>Visa transfer includes:</strong><br/><ul class="ul-style"><li>Medical screening</li><li> Emirates ID application</li><li> Residence visa stamping</li></u>',
            docslbl__c='Passport - first page;Passport - last page (if applicable);Recent passport size photo (white background);Attested educational certificate (occupation dependent);Emirates ID - front (if available);Emirates ID - back (if available);Existing residence visa page (for transfers only);NOC from the releasing sponsor (for transfers only);Final settlement (for transfers within free zone only);Employment contract (conditional);Valid nationality identity card (for Pakistan, Afghanistan & Iraqi nationals - conditional);Medical Certificate from Origin Country Sri Lankan, Indonesian and Ethiopian nationalities (conditional) ;Good Contact Certificate for Kenyan nationalities (conditional);Health insurance card or certificate or opt for ADNIC Insurance during the application (for transfers only)');
        insert sd;
        List<Contact> conLst = [select id from Contact where firstName='fName' LIMIT 1];
        List<Account> accLst = [select id from Account where Name='Acc' LIMIT 1];
        List<g_Srvc__c> srvcLst = [select id from g_Srvc__c where Name='Srvc' LIMIT 1];
        Contact c = new Contact(Id=conLst[0].Id, mbs__c=50000, eidid__c='784198774283257', eidedt__c=system.today().addyears(3));
        update c;

        List<g_srvc_settings__c> srvcsettings = [select id, reqq__c, docq__c from g_srvc_settings__c where Name='srvcStg' LIMIT 1];
        srvcsettings[0].reqq__c = 'Select  xadtx5__c, isAMLCompleted__c, isMOAAmd__c, parcat__c, Acc__r.clt__c, Account_Brand__c, xvch__c, crflg__c, inUAE__c, xmamd__c, Acc__r.mtc__c, is_sponsered_fl__c, PRM_Name__c, PRM_Email__c, PRM_MobileNo__c, PRM_LandlineNo__c, piFlg__c, expflg__c, slaN__c, AUPV__c, xcamdt__c, AUP__c, Acc__r.Name, srvc__r.sdg__r.skpsd__c, xsi__c, xai__c, srvc__r.Milestone_Stage__c, srvc__r.sdg__r.ptype__c, srvc__r.sdg__r.cv__c, srvc__r.AddOn__c, srvc__r.AddOnSrv__c, Acc__r.lcedt__c, acc__r.lctp__c, srvc__r.xoi__c, xfb__c, xchn__c, xcsnc__c, xfsr__c, xddatc__c, xadtx3__c, xbtnm__c, xppor__c, rtacn__c, xccn__c, x30gr__c, xccl__c, xeng__c, xcawp__c, xdedln__c, ias__c, xcn__c, xlt__c, xcddocs__c, xtpa__c, xla2l__c  , xdedc__c, xdccaRq__c, Print__c   , xdrv__c , xadtx4__c, Provisional_Issuance__c, xaed__c, xlicd__c, xcs__c, xanum__c, xpmsle__c, xppsfv__c, xcne__c, xcna__c, xlne__c, xlna__c, xalfe__c, xaccbrand__c, Acc__r.lcidt1arb__c, Acc__r.licexdt__c, Acc__r.Legal_Framework__c, Acc__r.lcidt__c, Acc__r.lc__c, dsgu__c, epexpdt__c , Acc__r.lcedtarb__c, xmloc__c, xvn__c, xdei__c, xuvdet__c, xadtx1__c, xadtx2__c, Id, Name, STA__c, AT__c, AP__c, AOP__c, xdtcls__c, dsc__c, dsc__r.prct__c, xfpc__c, xnry__c, spCh__c, rmob__c, xawb__c, xaloc__c, xbrnd__c, xbn__c, nt__c, srvc__r.uid__c , srvc__r.pstg__c, srvc__r.kstp__c, xltr__c, xtcdl__c, InsChk__c, xadh__c, srvc__c, srvc__r.name, srvc__r.lbl__c, srvc__r.dsc__c, srvc__r.Prk__c, srvc__r.AccTp__c, Acc__r.lcsta__c, Con__c, ConRol__c , ConSTA__c, srvc__r.ckgsnc__c, srvc__r.snc__c, srvc__r.stg__r.pg__c, srvc__r.stg__r.apx__c, srvc__r.stg__r.reqq__c, Acc__r.lrd__c, Acc__r.onar__c, Acc__c, Acc__r.ORACLE_PARTY_ID__c, Acc__r.Type, Acc__r.Prk__c, Acc__r.Park__c, Acc__r.lcsnc__c, Acc__r.lcsncnt__c, Acc__r.psasnc__c, Acc__r.psasncnt__c, Acc__r.ecsnc__c, Acc__r.ecsncnt__c, Acc__r.cosnc__c, Acc__r.cosncnt__c, Acc__r.bgsnc__c, Acc__r.bgsncnt__c, Acc__r.snc__c, Acc__r.info__c, Acc__r.vestd__c, Acc__r.vbtemp__c, Acc__r.speabsc__c, Acc__r.os__c, LastModifiedDate, LastModifiedById, CreatedDate, CreatedById, xepAtt__c, xeidav__c, xcma__c, xcacctp__c, xcha__c, xcarea__c, xcmbs__c, xcbd__c, xccty__c, xcbc__c, xcnc__c, xceidid__c, xceidedt__c, xceididt__c, xceml__c, xcemrt__c, xcfan__c, xcfs__c, xcfn__c, xcfnar__c, xchph__c, xcln__c, xclnar__c, xcms__c, xcmn__c, xcmnar__c, xcmob__c, xcmon__c, xcof__c, xcot__c, xcjb__c, xcmoa__c, xcp__c, xcped__c, xcpid__c, xcpic__c, xcpip__c, xcbp__c, xcpobx__c, xcpobxarea__c, xcnp__c, xcql__c, xcrlg__c, xcslt__c, xclng__c, xcstrt__c, xcmta__c, amsgs__c, action__c, srvc__r.lsctg__c, os__c , (select id, Name, estE__c, actE__c, kstp__c, sla__c, acts__c, itm__c, itm__r.exp__c, itm__r.itm__r.exp__c, itm__r.itm__r.Name, itm__r.itm__r.lbl__c, f__c, f__r.Name, f__r.lbl__c, f__r.Tp__c, t__c, T__r.hisl__c , t__r.Name, t__r.kstp__c, t__r.lbl__c, t__r.Tp__c , CreatedBy.Name, CreatedById, vf__c, vt__c, Duration__c, to__c, xawb__c , Activity__c, cd__c, Within_SLA__c  from Status_History__r   where isDeleted=false order by itm__r.itm__r.ord__c, CreatedDate), (Select Id, Name, mxAts__c, mnAts__c, ats__c, nt__c, or__c, reqAts__c, reqOr__c, tplt__c, x30gr__c, upOk__c, mbr__c, mbr__r.Name From rDocs__r where Req__c=true and IsDeleted=false), (Select Id, Name, STA__c, dt__c, A__c, md__c, TP__c , fwf__c From Transactions__r where isDeleted=false), (select Name, Status__c, Summary__c, Request__c, More_Details__c, Type__c, createddate from Requests__r where isDeleted=false ORDER BY createddate DESC), (select id, Name, RQ__c, nc__c, rv__c, m__c, m__r.Name, vSTA__c, AP__c, AOP__c, AD__c, nt__c, xprnt__c, xr__c, xcnotes__c, xef__c , xips__c, Dsc__c, DscApp__c, KF__c, cN__c, scN__c, smN__c, exp__c, cXP__c, scXP__c, smXP__c, itm__c, itm__r.xf__c, itm__r.cd__c, itm__r.Name, itm__r.lbl__c, itm__r.Tp__c, itm__r.Req__c, itm__r.exp__c, itm__r.prcEdt__c, itm__r.dSTA__c, sta__c, sta__r.cd__c, sta__r.Name, sta__r.lbl__c, sta__r.Tp__c, sta__r.rc__c, sta__r.noEXP__c, LastModifiedDate, LastModifiedById, CreatedDate, CreatedById, sta__r.staown__c, sta__r.Next_Status__c, sta__r.amsgs__c, sta__r.next_status__r.rqSTA__c, sta__r.next_status__r.Courier_Stage__c, sta__r.Courier_Stage__c, sta__r.rqSTA__c, sta__r.imsgs__c, sta__r.action__c, sta__r.statype__c, xcdocs__c, xdcdocs__c, xfld__c, ccrmid__c From Items__r where IsDeleted=false order by itm__r.ord__c) , (SELECT id, AWB_Number__c, Courier_Booking_Log__c, Courier_req__c, Duration__c, End_Date__c, From_Courier_Status__c, Start_Date__c, To_Courier_Status__c, AWB_No__c, Activity__c, Item_Name__c, CreatedBy.name  , tp__c FROM Courier_Histories__r), (Select Id, CaseNumber, Origin, Type, Subject, Status, Category__c, Sub_Category__c, CreatedDate, ClosedDate from Cases__r Order By IsClosed, CreatedDate Desc), (select id, name from Attachments order by createddate desc), srvc__r.Category__c, xcqc__c, xcdd__c, xcqemrt__c, xvtyp__c, Location_Brand__c, xltp__c, Con__r.rol__c, Con__r.firstname, con__r.LastName, con__r.emrt__c, con__r.p__c, Con__r.Email, Con__r.MobilePhone, Con__r.Salutation, Con__r.ms__c, Con__r.nc__c, Con__r.eidid__c, Con__r.pobx__c, Con__r.mbs__c, Con__r.ma__c, Con__r.mta__c, Con__r.moa__c, Con__r.Birthdate, Con__r.rpui__c, xcst__c  From g_Req__c';
        update srvcsettings[0];

        Contact emp = testData.conCrt(conLst[0], accLst[0].Id, 'Active', 'Employee', 'Pass2', 'Egypt');
        g_Req__c r = testData.reqCrt(accLst[0].Id, srvcLst[0].Id, emp.Id, 'Open', srvcsettings[0].reqq__c);
        r.xadtx2__c = '[{"name":"Agricultural, Forestry, Horticulture", "segId":"a08D000000Zb6yzIAB", "allowed":"5", "price":"15000.00", "SegActivities":[{"name":"Import and Re-Export", "actId":"a12D0000001YyZ1IAK", "price":"15000.00", "docs":[]}, {"name":"Manufacturing and Production", "actId":"a12D0000001YyZ3IAK", "price":"25000.00", "docs":[]}, {"name":"Marketing and Sales Promotion", "actId":"a12D0000001YyZ2IAK", "price":"15000.00", "docs":[]}]}, {"name":"Air and Environment", "segId":"a08D000000Zb700IAB", "allowed":"5", "price":"15000.00", "SegActivities":[{"name":"Consultancy", "actId":"a12D0000001Yyf2IAC", "price":"15000.00", "docs":[]}, {"name":"Management", "actId":"a12D0000001ZP4cIAG", "price":"15000.00", "docs":[]}]}, {"name":"Educational Service Provider", "segId":"a08D000000Zb70LIAR", "allowed":"1", "price":"15000.00", "SegActivities":[{"name":"Academic Support Services", "actId":"a12D0000001YyhDIAS", "price":"15000.00", "docs":[]}]}]';
        update r;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new mockGetD3Locs());
        gctlAxs2 ga = new gctlAxs2();

        ga.rq = r;
        ga.addSegment4mRQ();

        ga.segJson = r.xadtx2__c;
        ga.addSegment();

        r.xadtx1__c = '[{"vatAmount":"4.0", "totalPrice":"84.0", "term":"1", "tenantCode":"t0009466", "segId":"ejc", "SegActivities":null, "propertyCode":"dic_b16", "price":"80.0", "name":"Ejari Service Charge", "chargeTo":"2021-12-05", "chargeFrom":"2021-12-05", "chargeCode":"ejarisc", "allowed":null}, {"vatAmount":"0.0", "totalPrice":"120.0", "term":"1", "tenantCode":"t0009466", "segId":"ej", "SegActivities":null, "propertyCode":"dic_b16", "price":"120.0", "name":"Ejari Services", "chargeTo":"2021-12-05", "chargeFrom":"2021-12-05", "chargeCode":"ejrsvc", "allowed":null}, {"vatAmount":"5573.8", "totalPrice":"117049.8", "term":"1", "tenantCode":"t0009466", "segId":"1py", "SegActivities":null, "propertyCode":"dic_b16", "price":"111476.0", "name":"Lease Fees - Term 1", "chargeTo":"2022-12-04", "chargeFrom":"2021-12-05", "chargeCode":"rntoff", "allowed":null}, {"vatAmount":"5573.8", "totalPrice":"117049.8", "term":"1", "tenantCode":"t0009466", "segId":"1py", "SegActivities":null, "propertyCode":"dic_b16", "price":"111476.0", "name":"Lease Fees - Term 2", "chargeTo":"2022-12-04", "chargeFrom":"2021-12-05", "chargeCode":"rntoff", "allowed":null}, {"vatAmount":"1153.2", "totalPrice":"24217.2", "term":"1", "tenantCode":"t0009466", "segId":"1py", "SegActivities":null, "propertyCode":"dic_b16", "price":"23064.0", "name":"Lease Fees - Term 1", "chargeTo":"2022-12-04", "chargeFrom":"2021-12-05", "chargeCode":"srvchrg", "allowed":null}, {"vatAmount":"1153.2", "totalPrice":"24217.2", "term":"1", "tenantCode":"t0009466", "segId":"1py", "SegActivities":null, "propertyCode":"dic_b16", "price":"23064.0", "name":"Lease Fees - Term 2", "chargeTo":"2022-12-04", "chargeFrom":"2021-12-05", "chargeCode":"srvchrg", "allowed":null}, {"vatAmount":"0", "totalPrice":"15000", "term":"1", "tenantCode":null, "segId":"dr", "SegActivities":null, "propertyCode":null, "price":"15000", "name":"New Licence Fee", "chargeTo":null, "chargeFrom":null, "chargeCode":null, "allowed":null}]';
        update r;
        ga.addSegment4mRQ();
        ga.loadAccountLocation();
        ga.editFromLeaseCmp();
        ga.formationUpdate();
        ga.indTypUpdate();
        ga.setRq(r);

        ga.getPick1();
        ga.getPick2();

        ga.setSegJson('test12');
        ga.getSegJson();
        Test.stopTest();
    }

    public class mockGetD3Locs implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            String dummyResp = '{"ResponseData":{"PartyId":"1747973", "Success":true, "Source":"D3", "Error":"", "ResponseCode":"200", "Records":[{"StageName":"Closed Won", "AgNo":"AG-076454", "LeaseType":"Office", "Type":"New", "BusinessPark":"DIC", "ContractStartDate":"2021-12-05", "ContractEndDate":"2022-12-04", "Building":"Bldg 16", "Area":768.80, "Category":"Commercial Office", "SubCategory":"Office", "ContractStatus":"Closed Won", "ContractStatusReason":"LA sent for Signoff", "Products":[{"LineItemName":"00308663", "ProductName":"DIC-Bldg 16-571", "UnitNumber":"571", "Floor":"First Floor"}, {"LineItemName":"00308664", "ProductName":"DIC-Bldg 16-571", "UnitNumber":"571", "Floor":"First Floor"}]}]}}';
            res.setBody(dummyResp);
            res.setStatusCode(200);
            return res;
        }
    }

}