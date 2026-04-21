/*U_S DFZC made the changes in the class*/
@isTest
public class OnboardQueueableTest implements HttpCalloutMock
{
    public HTTPResponse respond(HTTPRequest req) {

            String attReqData = '{"ActionName":"insertvehicleattachment", "VehicleNumber":"", "contentType":"", "attachmentName":"", "body":""}';
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(attReqData);
            res.setStatusCode(200);
            return res;
            }
     @isTest static void TestQueue() {

        Test.startTest();
         try{
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

            String ad4 = '{"ActionName":"insertparkingrequest", "OracleID":1234, "AgNo":"", "AXSId":33232323232, "CardNumber":"AAD-1", "Eligibility":"ELG-43823", "RequestType":"Parking Card", "BusinessPark":"", "Sector":"DIAC Parking", "CardRequestType":"Registration", "ParkingType":"Free", "EndDate":"2022-11-22", "CardsDetail":[{"cardHolderName":"HIRALIBEN BHAVINKUMAR PATEL", "Email":"mohammad.imtiyazuddin@dham.ae", "Mobile":"+971562351086", "Phone":"", "Vehicles":[{"PlateNumberCode":"A123456", "PlaceOfReg":"Dubai"}]}]}';

             System.enqueueJob(new OnboardQueueable('uploadDoc', new List<Id>()));
             System.enqueueJob(new OnboardQueueable('uploadDoc', rq1.id));
             System.enqueueJob(new OnboardQueueable('parking', ad4, rq1.id+';33232323232'));
         }catch (Exception e) {}
          Test.stopTest();
      }
 }