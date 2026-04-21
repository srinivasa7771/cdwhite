public with sharing class  ApplicantDetailController extends pgBsCtrl  {
    public boolean smeIN5 {get;set;}

    public g_Req__c req{set;get;}
    //public Component.Apex.SectionHeader dynComp{set;get;}
    public boolean editableMode{get;set;}
    public String surveyId { get;set;}
    public String nxtPgUrl{get;set;}
    public Boolean pgHide{get;set;}
    public Boolean ispu{get;set;}
    public string err{get;set;}
    public String pg{get;set;}
    public string framwrk{get;set;}
    public List<g_jb__c> jbTitles{get;set;}
    public Account Acc{get;set;}
    public g_Srvc__c srv{get;set;}
    public Boolean isgu{get;set;}
    public String empid{get;set;}
    public String encid{get;set;}
    public String pid{get;set;}
    public String srvcID{get;set;}
    public Contact emp{get;set;}
    public string lcl{get{return UserInfo.getLocale();}}
    public gu.pgMode md{get;set;}
    public List<string> priorityList {set;get;}
    public string srvDesc{get;set;}
    public string dd{get;set;}
    public boolean trueDoc{get;set;}
    public string xbrand{get;set;}
    public static String gApiToken {get;set;}
    public String delimitedActString {get;set;}
    //for ocr comp (PO BOX)
    public transient  String imageBase64 {get;set;}
    public transient  String tImageBase64 {get;set;}
    public String docName { get; set; }
    public Id reqId{ get; set; }
    public string conId{get;set;}
    public decimal BasicSal{ get; set; }
    public String eidid{ get; set; }
    public Date eidExpDt{ get; set; }
    public String conRol{ get; set; }
    public boolean isSponByGV {set;get;}
    public g_Req__c contReq{get;set;}
    public String pageValue{get;set;}
    public String ppAttId{get;set;}
    public String memResDocId {get;set;}

    //Recptcha
    public Boolean codeCheck { get; set; }
    public boolean noSRfg { get; set; }
    private static String baseUrl = 'https://www.google.com/recaptcha/api/siteverify';
    private static String secret =Label.CaptchaSecret;
    public static String TestResponse = 'System.HttpResponse[Status=OK, StatusCode=200]';
    public String sitekey { get { return Label.CaptchaSitekey; } }
    public String response { get { return String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('g-recaptcha-response')); } }



    public String firstNameCountries {get; set;}
    public gctlRequ componentOne {get; set;}
    //priority type
    public Map<String,String> slaMp {set;get;}
    public String reqPrk {get; set;}
    public List <String> arbicNationLst {set;get;}
    public List <String> gccNationLst {set;get;}
    public boolean isArabicCntry {set;get;}
    public List<Attachment> membRes{get;set;}
    public List<Attachment> dirRes{get;set;}
    public static  g_Req__c Rq2{get;set;}

    //fit out
    public Boolean isFContU{get;set;}
    public String pgeC{get;set;}
    public double totalArea{get;set;}
    public boolean showContForm {set;get;}
    public string leaseType{get;set;}
    public Boolean isRetailCat{get;set;}
    public List <String> archSubCat {set;get;}
    public List <String> mepSubCat {set;get;}
    public List <String> struSubCat {set;get;}

    /* private Boolean accesssOk
{get{Boolean acsOk = gu.canReqSrvc(req.srvc__c,false,null);if (!acsOk)
{if (md.isNew){gu.addWarningMsg(Label.msgNoPrivilege);}else {md.setView();gu.addInfoMsg(Label.msgReadOnly);}}return acsOk;}}*/
    //amountTobePaid=0; xcddocs='';
    //public transient ApexPages.Component headerComponent { get; set; }
    public ApplicantDetailController(ApexPages.StandardController controller){ segmentList = new List<string>(); delimitedActString = '';}
    //for making document list dynamic
    public String dynamicDoclst { get; set; }
    public Boolean gvElbl { get; set; }
    public String gvConId { get; set; }
    public String gvSrvId { get; set; }
    public String selectedConData { get; set; }
    public Contact gvCon { get; set; }
    public void checkGVElg(){
        gvElbl = false;gvCon = new Contact();
        String conId = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('conId'));
        gvCon = [select id,name,mgs__c,mbs__c,ma__c,mta__c,moa__c,Job_Title_Formula__c,jd__c,jb__c,jb__r.mgr__c,rped__c from contact where id=:conId];
        Date todayDate = System.today();

        Integer monthsBetween=0;
        Integer daysBetween=0;
        Date Jd = System.today();
        Date rp=System.today();
        if (gvCon.jd__c!=null){Jd=gvCon.jd__c;}else{Jd=todayDate;}
        if (gvCon.rped__c!=null){rp=gvCon.rped__c;}else{rp=todayDate;}
        monthsBetween = (Jd).monthsBetween(todayDate);
        daysBetween=(todayDate).daysBetween(rp);

        if (gvCon.mbs__c>=30000 && gvCon.jb__r.mgr__c==true && monthsBetween>23 && daysBetween > 29){
            gvElbl = true;
        }
        selectedConData = JSON.serialize(gvCon);

    }
    public PageReference createGVRequest(){
        String sid = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('sid'));

        PageReference pageRef= new PageReference('/apex/gvchk?sid='+sid);
        try{
            List<Contact> conLst = [select id,id__c,nc__c,rol__c,p__c,Proc__c,RP_Expiry_Due__c,mn__c,Spon__c,snc__c,sp__c,rp__c,rpid__c,rped__c,mbs__c,ma__c,mta__c,moa__c,ha__c,rpui__c,HomePhone,firstname,middlename,lastname,MobilePhone,mon__c,fan__c,Gender__c,Birthdate,bc__c,Email,fnar__c,mnar__c,lnar__c,lng__c,mona__c,jb__c,eidid__c,eidedt__c,ql__c,ot__c,fs__c,of__c,emrt__c,cty__c,strt__c,area__c,pobx__c,pobxarea__c,pic__c,pip__c,pid__c,ped__c,rlg__c,ms__c,bp__c,bpa__c,np__c,Salutation,xsgv__c from Contact where id=:gvConId ];

            srv = [select id,uid__c,name,sdg__c,sdg__r.sd__c,sdg__r.slbl__c,sdg__r.docslbl__c,lbl__c,dsc__c,Prk__c,AccTp__c,conrol__c,consta__c,
                   sprrole__c,sprsta__c,ckgsnc__c,snc__c,stg__r.pg__c,stg__r.apx__c,stg__r.reqq__c from g_Srvc__c where id=: req.srvc__c limit 1];

            String srvDefId = srv.sdg__c;
            Acc= U.contact.account;

            g_req__c rqst = new g_req__c();rqst.Acc__c= Acc.id;rqst.Con__c=gvConId;  rqst.srvc__c=sid; rqst.xcnc__c = conLst[0].nc__c; rqst.xcp__c = conLst[0].p__c; rqst.xcfn__c =  conLst[0].firstname; rqst.xcln__c = conLst[0].lastname; rqst.xcmn__c = conLst[0].middlename; rqst.xcmn__c = conLst[0].mn__c; rqst.xcfnar__c = conLst[0].fnar__c; rqst.xcmnar__c =  conLst[0].mnar__c; rqst.xclnar__c =  conLst[0].lnar__c; rqst.xcfan__c = conLst[0].fan__c; rqst.os__c = 'Under_Review'; rqst.xcsrs__c=conLst[0].rol__c; rqst.xcmon__c = conLst[0].mon__c; rqst.Gender__c = conLst[0].Gender__c; rqst.xcbd__c = conLst[0].Birthdate; rqst.xcbc__c =  conLst[0].bc__c; rqst.xceml__c =  conLst[0].Email; rqst.xclng__c =  conLst[0].lng__c; rqst.xcmonar__c = conLst[0].mona__c; rqst.xcjb__c = conLst[0].jb__c; rqst.xceidid__c = conLst[0].eidid__c; rqst.xceidedt__c = conLst[0].eidedt__c; rqst.xcql__c = conLst[0].ql__c; rqst.xcfs__c = conLst[0].fs__c; rqst.xcot__c = conLst[0].ot__c; rqst.xcof__c  = conLst[0].of__c; rqst.xcemrt__c = conLst[0].emrt__c; rqst.xccty__c = conLst[0].cty__c; rqst.xcstrt__c = conLst[0].strt__c; rqst.xcarea__c = conLst[0].area__c; rqst.xcpobx__c =  conLst[0].pobx__c; rqst.xcpobxarea__c = conLst[0].pobxarea__c; rqst.xcpic__c = conLst[0].pic__c; rqst.xcpip__c = conLst[0].pip__c; rqst.xcpid__c = conLst[0].pid__c; rqst.xcped__c = conLst[0].ped__c; rqst.xcrlg__c = conLst[0].rlg__c; system.debug('---MS---'+conLst[0].ms__c+'---Contact id---'+conLst[0].id); rqst.xcms__c = conLst[0].ms__c; rqst.xcbp__c = conLst[0].bp__c; rqst.xcpobar__c = conLst[0].bpa__c; rqst.xcnp__c = conLst[0].np__c; rqst.xcslt__c = conLst[0].Salutation; rqst.xcmbs__c = conLst[0].mbs__c; rqst.xcma__c = conLst[0].ma__c; rqst.xcmta__c = conLst[0].mta__c; rqst.xcmoa__c = conLst[0].moa__c; rqst.xcha__c = conLst[0].ha__c; rqst.xchph__c = conLst[0].HomePhone; if (String.isNotBlank(conLst[0].MobilePhone)){ String mph = conLst[0].MobilePhone; rqst.xcmob__c = mph.replaceAll('\\D', '').replaceFirst('971', '').replaceFirst('0',''); } rqst.xrp__c = conLst[0].rp__c; rqst.xui__c=conLst[0].rpui__c; rqst.xrpid__c = conLst[0].rpid__c; rqst.xrped__c = conLst[0].rped__c; rqst.Spr__c = conLst[0].Spon__c; rqst.xcsnc__c = conLst[0].snc__c; rqst.xcsp__c = conLst[0].sp__c; rqst.xcid__c=conLst[0].id__c; rqst.xceidid__c=conLst[0].eidid__c; rqst.xceidedt__c=conLst[0].eidedt__c;
            insert rqst;

            if (gvConId!=null && rqst.id!=null){
                pageRef = new PageReference('/apex/grqsdr?id='+rqst.id+'&sid='+srvDefId);
                pageRef.setRedirect(true);
                return pageRef;
            }
        }catch (Exception ex){
            String errorMessage = ex.getMessage();
            Integer occurence;
            if (ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                occurence = errorMessage.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION,') + 34;
                errorMessage = errorMessage.mid(occurence, errorMessage.length());
                occurence = errorMessage.lastIndexOf(':');
                errorMessage = errorMessage.mid(0, occurence);
            }
            else {
                errorMessage = ex.getMessage();
            }
            gu.AddErrorMsg(gvConId+'helo'+errorMessage);

            return pageRef;
        }
        return pageRef;
    }
    public Boolean hasSanctions{
        get{    grqH.rH h = new grqH.rH ();return !h.BC(req,srv,Acc);
           }

    }

    /* Added by Meenu to check if the current profile is Student */
    /*public Boolean isStuPfl {get;set;}
public Boolean isSuperUser {get;set;}
public String accLevel {get;set;}
public String role {get;set;}*/

    public void getAcc(){
        Acc = [select id,dedlic__c,lcidt1__c,isDS__c,ecedt__c,ccrm_sfid__c,lcsta__c,Name,Legal_Framework__c,vvsfp__c,lrd__c,onar__c,Phone,adb__c,bgb__c,bgnr__c,bg__c,lc__c,ORACLE_PARTY_ID__c,loc__c,Type,Prk__c,lcsnc__c,lcsncnt__c,psasnc__c,psasncnt__c,ecsnc__c,ecsncnt__c,cosnc__c,cosncnt__c,bgsnc__c,bgsncnt__c,snc__c,info__c,vestd__c,vbtemp__c,vbvv__c,lcedt__c,vbtst__c,(Select Id ,acct__c,act__c,act_type__c,bus_unit__c,dcca_id__c,lic__c,or_prty__c,seg__c,sDate__c from aseg__r),(Select Id,Loc__c,agrno__c,acc__c,bu__c,IsMain__c,IsSub__c,ls_end__c,ls_std__c,active__c,rpi__c,Is_frzn__c from aloc__r where Is_frzn__c=true  ) from Account where id=: req.Acc__c limit 1];
        framwrk = acc.Legal_Framework__c;
    }
    public PageReference validateAndRedirect(){

        //Write your logic here and redirect
        PageReference retURL = new PageReference('/ErrorPage');
        retURL.setRedirect(true);
        return retURL;

    }


    public PageReference assignAccount(){ System.debug('req.acc:: ' + req.acc__c); /*Acc = req.acc__c;*/ if (req.acc__c!=null)getAcc(); return null; }

    public boolean laAlert{get;set;}
    Public String laAlertListStr{get;set;}
    public user u{get;set;}
    public boolean isActiveLease{get;set;}/*US APD2635*/
    public integer activePoBoxSize{get;set;}/*US APD2635*/
    public List<alocpob__c> listPOB {get;set;}/*US APD2635*/
    public List<g_reqitem__c> cncRiList {get;set;}/*US APD2635*/
    public string OpenCNCreq {get;set;}/*US APD2635*/
    public string OpenCNCreqCat {get;set;}/*US APD2635*/
    public ApplicantDetailController(){
        listPOB= new List<alocpob__c> ();/*US APD2635*/
        amountTobePaid=0;
        xcddocs='';
        segmentList = new List<String>();
        segMap = new Map<String, SegmentsActivitiesController.SegWrapper>();
        /*isStuPfl = false;
isSuperUser = gU.checkSuperUser();
accLevel = '';
role = '';
if (!isSuperUser)
{
isStuPfl = gu.isStuProfile(UserInfo.getUserId());
accLevel = gu.chkStdAcc(UserInfo.getUserId());
}
role = (isStuPfl) ? 'Student' : accLevel == 'NONSTUDENT' ? 'Employee;Child;Spouse;Non Sponsored' : 'Employee;Student;Child;Spouse;Non Sponsored';
*/

        membRes= new List<Attachment>();
        dirRes = new List<Attachment>();
        archSubCat = new List<String>{'Retrofit/modification work other than painting, carpeting and replacement of existing finishes','Low height partitions (minimum 20% gap from false ceiling) with relocation of MEP devices only(Partion Work/Frunitiure layout/Florring layout /Sealing layout)','Addition/modification of office cabins with no additional MEP installations other than minor works','Server room with power distribution &amp; installation of clean agent fire extinguisher as approved by DCD','Floor Box relocations only to suit proposed furniture layout - No partitions or false ceiling work','Architectural layout Partion Work','Merging more than one premise into a single premise'};
            mepSubCat = new List<String>{'Modification of Heating Ventilation and Air Condition(HVAC)','New Machines Installation(Heat Load calculations)','Fire Protection Works','Electrical Works','Plumbing and drainage works','Core on floor Slab','Kitchen Installations','Retail Installations','Warehouse and Installation- Rack Sprinklers DCD if height (3.6 Meters)','Warehouse and Installation- Strorage hazardous materials','Warehouse and Installation- Setting up  paint booth','Warehouse and Installation- Installation  of stack furance'};
                struSubCat = new List<String>{'Introducing mezzanine floor or a platform','Any Steel Structural','Coring','Usage of Outside area(Machine outdoor, Tank location Etc...)'};
                    showContForm = false;
        isFContU = false;
        if (Label.FitOutContractorUser == UserInfo.getUserName()){isFContU = true;}
        smeIN5=false;
        system.debug('smeIN5::::::::::'+smeIN5);
        system.debug('ApplicantDetailController::::::::::');
        Id srvDefId;
        isSponByGV = false;
        isgu = gU.isGuestUser(UserInfo.getProfileId());
        arbicNationLst  = label.AXSArabic.split(';');
        gccNationLst = label.GCCNations.split(';');
        isArabicCntry = false;
        Boolean hasAccess2;
        reqId = apexpages.currentpage().getparameters().get('id');
        conId = apexpages.currentpage().getparameters().get('cid');
        srvcID =  String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('sid'));
        pgeC = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('pc'));
        jbTitles = [select id, name from g_jb__c where Name in('STUDENT','Business Person')];
        priorityList = new List<String>();
        nxtPgUrl = null;
        ispu=gU.isPortalUser(UserInfo.getProfileId());
        slaMp = new Map<String,String>();
        firstNameCountries =System.Label.countriesFirstName;//.split(';');
        srv = new  g_Srvc__c();
        if (reqId == null){
            req=new g_Req__c();
            req.srvc__c = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('sid'));
            srv = [select id,uid__c,name,sdg__c,sdg__r.sd__c,sdg__r.slbl__c,sdg__r.docslbl__c,lbl__c,dsc__c,Prk__c,AccTp__c,conrol__c,consta__c,
                   sprrole__c,sprsta__c,ckgsnc__c,snc__c,stg__r.pg__c,stg__r.apx__c,stg__r.reqq__c from g_Srvc__c where id=: req.srvc__c limit 1];

            srvDefId = srv.sdg__c;
            if (!ispu && !isgu){
                getServ(req.srvc__c);
                return;
            }

            U = [select id,FirstName,LastName,contact.account.vcspe__c,contact.account.mtc__c,contact.account.Name,contact.account.Email__c,contact.account.Phone,MobilePhone,accountid,
                 contact.account.id,contact.account.agv__c,contact.account.adb__c,contact.account.xcuzn__c,contact.account.xcublg__c,contact.account.bgb__c,contact.account.bgnr__c,contact.account.bg__c,contact.account.loc__c,contact.account.Type,contact.account.Prk__c,contact.account.lcsnc__c,contact.account.lcsncnt__c,contact.account.lcedt__c,contact.account.psasnc__c,contact.account.psasncnt__c,contact.account.ecsnc__c,contact.account.ecsncnt__c,contact.account.cosnc__c,contact.account.cosncnt__c,contact.account.bgsnc__c,contact.account.bgsncnt__c,contact.account.snc__c,contact.account.info__c,contact.account.vestd__c,contact.account.vbtemp__c,contact.account.vbvv__c,
                 contact.account.lc__c,contact.account.vbtst__c,contact.account.ORACLE_PARTY_ID__c,contact.account.lcsta__c,contact.account.lctp__c,contact.account.session__c,contact.account.vctemp__c,contact.account.vvsfp__c,contact.account.lcrndt__c,contact.account.os__c,contact.account.vespe__c from User where id=:UserInfo.getUserId() limit 1];

            if (srv.uid__c=='220'){ /*U_S APD2635 Start*/listPOB=[select id,sta__c,name from alocpob__c where acc__c=:U.contact.accountId and stts__c='Active']; if (listPOB!=null && listPOB.size()>0){activePoBoxSize=listPOB.size(); } OpenCNCreq=OpenCNCreqCat='';cncRiList=[select id,RQ__r.Legal_Framework__c,rq__r.name,RQ__r.xcamc__c from g_reqitem__c where RQ__r.acc__r.lc__c=:U.contact.account.lc__c and itm__r.cd__c='ddd' and sta__r.name not in('Waiting for Original Documents','Completed','Cancelled','Rejected') and RQ__r.Service_Code__c='220' and RQ__r.xcamc__c in('Company Name Change - Operating Name','Company Name Change - Parent Company Name','Company Name Change - FZ-LLC','Company Name Change - Operating Name & Parent Company Name')  order by createddate desc limit 1];if (cncRiList.size() > 0) {OpenCNCreq=cncRiList[0].RQ__r.name;OpenCNCreqCat=cncRiList[0].RQ__r.xcamc__c;} /*U_S APD2635 End*/string jsonStr = '{"methodname":"getcompanyalerts", "data":{"licenseNum":"' + U.contact.account.lc__c + '"}}'; String responseBody = DDAServices.getDDAServices('DCCA_Auth', 'onbordingapi', 'POST', jsonStr); laAlertListStr = responseBody; Map < String, Object > alertMap = (Map < String, Object > ) JSON.deserializeUntyped(responseBody); List < Object > alertList = (List < Object > ) alertMap.get('ListAlerts'); system.debug('--alertList--'+alertList); if (alertList != null && !alertList.isEmpty()) { laAlert=true; system.debug('--laAlert--'+laAlert); } }
            if (isgu){
                List<Account> accs=[select id,vespe__c,lcsta__c,Name,Phone,adb__c,bgb__c,bgnr__c,onar__c,lrd__c,bg__c,lc__c,ORACLE_PARTY_ID__c,loc__c,Type,Prk__c,lcsnc__c,sncNt__c,lcsncnt__c,psasnc__c,psasncnt__c,ecsnc__c,ecsncnt__c,cosnc__c,cosncnt__c,bgsnc__c,bgsncnt__c,snc__c,info__c,vestd__c,vbtemp__c,vbvv__c,lcedt__c,vbtst__c from Account where id =:System.Label.TecomAccnt];// 0012000001DbKS9
                if (accs != null && accs.size()>0){
                    req.Acc__c=accs[0].id;
                    Acc = accs[0];

                }
            }else{
                Acc= U.contact.account;
                xbrand = u.contact.account.xcuzn__c;
            }
            system.debug('ApplicantDetailController::::::::::'+Acc);

            req.Acc__c= Acc.id;
            system.debug('ApplicantDetailController::::::::::'+req.Acc__c);
            system.debug('req-----'+req);
            system.debug('req Id-----'+req.Id);
            system.debug('Acc'+Acc);
            getAcc();
            Date firstLID=Acc.lcidt1__c;
            system.debug('--firstLID--*'+firstLID);
            if (firstLID != null){ Integer nISDays= firstLID.daysBetween(Date.today()); if ((Acc.type=='Customer - IN5' && nISDays > 1461)  || (Acc.isDS__c && nISDays > 1826)){ smeIN5=true; system.debug('--smeIN5--*'+smeIN5); } }
            system.debug('--smeIN5--*'+smeIN5);
            system.debug('hasSanctions'+hasSanctions);
            system.debug('laAlert -- '+laAlert);
            if (hasSanctions ){
                pgHide=true;
            }else
                pgHide=false;

        }

        if (reqId != null){
            //fit out
            req = [select Id,name,Encrypted_QR_Code_URL__c, acc__r.id,Acc__r.Legal_Framework__c,Srvc__r.sdg__c,Srvc__r.sdg__r.sd__c,Srvc__r.sdg__r.ptype__c,acc__r.ORACLE_PARTY_ID__c,
                   srvc__c,sta__c, srvc__r.uid__c,srvc__r.Name,srvc__r.stg__c, srvc__r.stg__r.pg__c,srvc__r.AddOnSrv__c, srvc__r.stg__r.reqq__c,
                   srvc__r.stg__r.bopg__c,xcamc__c,xcamdt__c,xnry__c,tob__c,srvc__r.suvtp__c,hpr__c,xst__c,xet__c,Con__c,xcddocs__c,xadh__c,xadtx2__c,os__c,xceml__c,xcmob__c,xaccbrand__c,xvtyp__c,xfb__c,xcfan__c from g_Req__c where id =: reqId];
            srv = [select id,uid__c,name,sdg__c,sdg__r.sd__c,sdg__r.slbl__c,sdg__r.docslbl__c,lbl__c,dsc__c,Prk__c,AccTp__c,conrol__c,consta__c,
                   sprrole__c,sprsta__c,ckgsnc__c,snc__c,stg__r.pg__c,stg__r.apx__c,stg__r.reqq__c from g_Srvc__c where id=: req.srvc__c limit 1];
            if (req.os__c == 'Contractor Appointed'){
                if (!isFContU){
                    rediretCont();
                }else{
                    FitOutWebservice.fitOutWrapper adhocData = (FitOutWebservice.fitOutWrapper) System.JSON.deserialize(req.xadtx2__c, FitOutWebservice.fitOutWrapper.class);
                    totalArea = adhocData.totalarea;
                    if (req.srvc__r.uid__c == '327'){
                        showContForm = true;
                    }
                }
            }
            srvDefId = req.Srvc__r.sdg__c;


            memResDocId = getReqDocId(reqId,'Member(s) Resolution');
            system.debug('reqId:::'+reqId);
            /*req = [SELECT  xcot__c,xcql__c,xcjb__r.Name,xcmbs__c,xcnp__c,xcrlg__c,xclng__c,xcnc__c,xcbc__c,xcms__c,xcmon__c,xcarea__c,xcpobx__c,xcacctp__c,
xcfan__c,xclnar__c,xcmnar__c,xcfnar__c,xcmn__c,xcslt__c,acc__c,xcfn__c,xcln__c,xcfs__c,xcof__c,xcemrt__c,xccty__c,xcstrt__c,
Gender__c,xcbd__c,xceml__c,xcp__c,xcpid__c,xcped__c,NationalityPassport__c,Con__r.Personal_Photo__c,con__r.rol__c,xceidid__c,xceididt__c,
xceidedt__c,xcha__c,xcpobxarea__c,xchph__c,xcmob__c,xcma__c,xcbp__c,xcmta__c,xcmoa__c,xcpip__c,xcpic__c,xeidav__c,rmob__c,xbrnd__c,
xbn__c,xaloc__c,nt__c,Spr__c,xfsr__c,srvc__r.ConSTA__c
FROM g_Req__c WHERE id=:reqId]; */

            req = [select Id, acc__r.id,Acc__r.Legal_Framework__c , Srvc__r.sdg__c,Srvc__r.sdg__r.sd__c,Srvc__r.sdg__r.ptype__c,
                   srvc__c,sta__c, srvc__r.uid__c,srvc__r.Name,srvc__r.stg__c, srvc__r.stg__r.pg__c,srvc__r.AddOnSrv__c, srvc__r.stg__r.reqq__c,
                   srvc__r.stg__r.bopg__c,xcamc__c,xcamdt__c,xnry__c,tob__c,srvc__r.suvtp__c from g_Req__c where id =: reqId];
            getAcc();
            /* if (hasSanctions){pgHide=true; system.debug('hasSanctionshasSanctionshasSanctions--'+pgHide);}*/

            //priority assignment
            /*if (String.isNotBlank(req.Srvc__r.sdg__r.ptype__c)){
priorityList = (req.Srvc__r.sdg__r.ptype__c).split(';');
}*/

            system.debug('srv.sdg__r.ptype__c >>');
            system.debug('srv.sdg__r.ptype__c >>'+ req.Srvc__r.sdg__r.ptype__c);
            if (req.Srvc__r.uid__c =='220'){
                getAtts();
            }
            if (String.isNotBlank(req.Srvc__r.sdg__r.ptype__c)){
                list<String> prLst = (req.Srvc__r.sdg__r.ptype__c).split(';');
                for (String str : prLst){
                    system.debug('str++'+str);
                    list<String> slaLst = str.split(':');
                    system.debug('slaLst==='+slaLst);
                    slaMp.put(slaLst[0],slaLst[1]);
                }
                system.debug('slaMp++'+slaMp);
                priorityList.addAll(slaMp.keySet());
            }
            system.debug('priorityList+++'+priorityList);
            system.debug('req.srvc__r.uid__c >>'+ req.srvc__r.uid__c);
            system.debug('req query >>'+ req.srvc__r.stg__r.reqq__c);
            //if (isgu){
            //req = (g_Req__c)Database.query('Select xcid__c, rtacn__c,srvc__r.sdg__r.ptype__c,srvc__r.stg__r.itmq__c,srvc__r.stg__r.json__c,xcmonar__c,xcfanar__c,xadtx1__c,xai__c,xsi__c,srvc__r.xoi__c,srvc__r.AddOnSrv__c,srvc__r.Milestone_Stage__c,mtc__c,xcjb__r.jtm__c,con__r.Job_Title_Formula__c,con__r.rlg__c,con__r.MiddleName,con__r.bp__c,con__r.ped__c,Con__r.Personal_Photo__c,Con__c,xard__c,Con__r.Spon__r.xpmi__c,con__r.jb__c,Con__r.Spon__r.idtxt__c,con__r.mgs__c,Con__r.Spon__r.Name,Con__r.Spon__r.xpno__c,Con__r.Spon__r.intp__c,Con__r.Spon__r.Birthdate,Spr__r.idtxt__c,Spr__r.xpno__c,con__r.e__c,Spr__r.xpmi__c,Spr__r.intp__c,Spr__r.Birthdate,i_STA__c,xtpa__c,Id,Name,STA__c,AT__c,AP__c,AOP__c,xdtcls__c,dsc__c,dsc__r.prct__c,xfpc__c,spCh__c,rmob__c,xawb__c,xaloc__c,xbrnd__c,xbn__c,nt__c,srvc__r.uid__c, ConRol__c ,xadh__c,xpgs__c,InsChk__c,xintp__c,Con__r.rol__c,Con__r.firstname,con__r.LastName,con__r.emrt__c,con__r.p__c,Con__r.Email,Con__r.MobilePhone,Con__r.Salutation,Con__r.ms__c,Con__r.nc__c,Con__r.eidid__c,Con__r.pobx__c,Con__r.mbs__c,Con__r.ma__c,Con__r.mta__c,Con__r.moa__c,Con__r.Birthdate,Con__r.rpui__c,srvc__c,srvc__r.name,srvc__r.lbl__c,srvc__r.dsc__c,srvc__r.Prk__c,srvc__r.AccTp__c, srvc__r.ckgsnc__c,srvc__r.snc__c,srvc__r.stg__r.pg__c,srvc__r.stg__r.apx__c,srvc__r.stg__r.reqq__c, Acc__c,Acc__r.Name,Acc__r.lcedt__c ,Acc__r.mtc__c,Acc__r.Type,Acc__r.Prk__c,Acc__r.lcsnc__c,Acc__r.lcsncnt__c,Acc__r.psasnc__c,Acc__r.psasncnt__c,Acc__r.ecsnc__c,Acc__r.ecsncnt__c, Acc__r.cosnc__c,Acc__r.cosncnt__c,Acc__r.bgsnc__c,Acc__r.bgsncnt__c,Acc__r.snc__c,Acc__r.info__c,Acc__r.vestd__c,Acc__r.vbtemp__c,Acc__r.sncNt__c,LastModifiedDate,LastModifiedById,CreatedDate,CreatedById,CreatedBy.Name,Item_Count__c, xeidav__c,xcma__c,xcacctp__c,xcha__c,xcarea__c,xcmbs__c,xcbd__c,xccty__c,xcbc__c,xcnc__c,xceidid__c,xceidedt__c,xceididt__c, xceml__c,xcemrt__c,xcfan__c,xcfs__c,xcfn__c,xcfnar__c,xchph__c,xcln__c,xclnar__c,xcms__c,xcmn__c,xcmnar__c,xcmob__c,xcmon__c, xcof__c,xcot__c,xcjb__c,xcmoa__c,xcp__c, xcped__c,xcpid__c,xcpic__c,xcpip__c,xcbp__c,xcpobx__c,xcpobxarea__c,xcnp__c,xcql__c, xcrlg__c,xcslt__c,xclng__c,xcstrt__c,xcmta__c,xdedc__c,xdedln__c,xosa__c, xphid__c,xcs__c,xcn__c,Zone__c,Full_Name__c,amsgs__c,action__c,xspn__c,xinsv__c,xcpobar__c,Con__r.eid__c,Con__r.eed__c,Con__r.rp__c,Con__r.rpid__c,Con__r.rped__c,Con__r.eididt__c,Con__r.eidedt__c,Con__r.idtxt__c,Con__r.ididt__c,Con__r.idedt__c,xcpipoar__c,srvc__r.pstg__c,srvc__r.kstp__c,xcddocs__c,xmloc__c, (select id,f__r.Name,CreatedDate,CreatedBy.Name,actE__c,itm__r.Name,To__c,t__r.hisl__c,LastModifiedDate,t__r.kstp__c from Status_History__r where isDeleted=false order by LastModifiedDate desc), (Select Id,Name,mxAts__c,mnAts__c,ats__c,nt__c,or__c,reqAts__c,reqOr__c,tplt__c,upOk__c,mbr__c,mbr__r.Name From rDocs__r where Req__c=true and IsDeleted=false ), (Select Id,Name,STA__c,dt__c,A__c,md__c,TP__c ,fwf__c,Created_Date_Time__c From Transactions__r where isDeleted=false order by  tp__c),(select Name,Status__c,Summary__c,Request__c,More_Details__c,Type__c,createddate from Requests__r where isDeleted=false ORDER BY createddate DESC), (select id,Name,RQ__c,nc__c,rv__c,m__c,m__r.Name,vSTA__c, AP__c,AOP__c,AD__c,nt__c,xprnt__c,xr__c, xef__c , Dsc__c,DscApp__c,KF__c,cN__c,scN__c,smN__c,exp__c,cXP__c,scXP__c,smXP__c, xean__c,itm__c,itm__r.xf__c,itm__r.cd__c,itm__r.Name,itm__r.lbl__c,itm__r.Tp__c,itm__r.Req__c,itm__r.exp__c,itm__r.prcEdt__c,itm__r.dSTA__c, sta__c,sta__r.cd__c,sta__r.staown__c ,sta__r.statype__c,sta__r.Name,sta__r.lbl__c,sta__r.Tp__c,sta__r.rc__c,sta__r.noEXP__c,sta__r.amsgs__c,sta__r.namsgs__c,sta__r.Next_Status__c,sta__r.next_status__r.rqSTA__c,sta__r.next_status__r.Courier_Stage__c,sta__r.Courier_Stage__c,sta__r.rqSTA__c,sta__r.imsgs__c,sta__r.action__c,LastModifiedDate,LastModifiedById,CreatedDate,CreatedById,xhact__c,xhmsgs__c,xcnotes__c,xcdocs__c,xcdf__c,xceididt__c,xfld__c,xpdl__c,xpidl__c,xpno__c,xpsd__c,xped__c,xcsla__c,xdcdocs__c,itm__r.gctg__c,sta__r.slaa__c,sta__r.Milestone__c,sta__r.kstp__c,itm__r.mv__c,xcphc__c ,pnc__c From Items__r  where IsDeleted=false order by lastmodifieddate,itm__r.ord__c) ,(SELECT id,AWB_Number__c,Courier_Booking_Log__c,Courier_req__c,Duration__c,End_Date__c,From_Courier_Status__c,Start_Date__c,To_Courier_Status__c,AWB_No__c,Activity__c,Item_Name__c,CreatedBy.name ,tp__c FROM Courier_Histories__r limit 10),(Select Id,CaseNumber,Origin,Type,Subject,Status,Category__c,Sub_Category__c,CreatedDate,ClosedDate from Cases__r Order By IsClosed,CreatedDate Desc) ,srvc__r.Category__c,xcqc__c,xcdd__c,xcqemrt__c,AUP__c,xcamdt__c,slaN__c ,srvc__r.sdg__r.skpsd__c ,Gender__c,expcnt__c,noEXP__c,xdccn__c,AUPV__c From g_Req__c where id=\''+req.id+'\' and isDeleted = false');
            //}else
            //req = (g_Req__c)Database.query(req.srvc__r.stg__r.reqq__c + ' where id=\'' + reqId + '\' and isDeleted = false');
            req = fetchREQ(req.id);
            getServ(req.Srvc__c);
            if (arbicNationLst.contains(req.xcnc__c) || gccNationLst.contains(req.xcnc__c)){
                isArabicCntry = true;
            }
            if (String.isNotBlank(req.srvc__r.suvtp__c) && req.srvc__r.suvtp__c == 'Auto Completion'){
                List<Survey_Request__c> srvLst =  [select id from Survey_Request__c where Request__c=:Req.id and Survey__c=:gU.csStr('AXS SurveyId')];
                if (srvLst != null && !srvLst.isEmpty())
                    surveyId = srvLst[0].id;
            }
            List<Contact> cLst = [select id,mbs__c,eidid__c,eidedt__c,rol__c from Contact where id=:req.Con__c limit 1];
            system.debug('1 conatct cLst >> '+cLst);
            if (cLst!=null && cLst.size()>0){
                BasicSal = cLst[0].mbs__c;
                eidid = cLst[0].eidid__c;
                eidExpDt = cLst[0].eidedt__c;
                conRol = cLst[0].rol__c;
            }
            dynamicDoclst='';
            ContactPreDetailReq();
        }
        else{
            loadData();
            md = new gu.pgMode();
        }

        if (string.isNotBlank(conId))
            req.con__c = conId;

        srvDefId = srv.sdg__c;
        if (string.isNotBlank(srvDefId))
            hasAccess2 = gU.canAccess2(srvDefId,false,null);
        else
            hasAccess2 = true;
        if (!hasAccess2)
            pgHide = true;
        else
            pgHide = false;

    }
    /*US APD2635*/public String getCommaSeparatedPOBNames() {if (listPOB == null || listPOB.isEmpty()) return ''; List<String> names = new List<String>();for (AlocPOB__c p : listPOB) names.add(p.Name);return String.join(names, ', '); } /*US APD2635*/
    public pageReference rediretCont(){
        PageReference pageRef;
        if (!isFContU && req.srvc__r.uid__c == '327'){
            pageRef = new PageReference('/apex/grqStatus');
            pageRef.getParameters().put('id', req.id);
            pageRef.setRedirect(true);
        }
        return pageRef;
    }

    public void getAtts(){ ppAttId=''; List<g_reqDoc__c> rdocList = [select id,name from g_reqDoc__c where RQ__c =:req.id and upOk__c=true and name='Passport Copy']; system.debug('rdocList -- '+rdocList); for (Attachment a: [select id, name from Attachment where parentId=:rdocList order by createddate desc]){ if (a.name.startsWith('Passport Copy')){ system.debug('a -- '+a); ppAttId = a.Id; } } }
    //DedActivities json
    public String getDedActsJson(){ system.debug('populateDedACtJson::::::'); List<DED_Activity__c> dedActivitiesList = new List<DED_Activity__c>(); dedActivitiesList = [SELECT name FROM DED_Activity__c  ORDER BY Name]; system.debug('dedActivities size::::'+dedActivitiesList.size()); String jsStr=JSON.serialize(dedActivitiesList); system.debug('jsStr:::'+jsStr); return jsStr; }
    /*public string dedActsJson { get {return populateDedACtJson();} }
public String populateDedACtJson(){
system.debug('populateDedACtJson::::::');
List<DED_Activity__c> dedActivitiesList = new List<DED_Activity__c>();
dedActivitiesList = [SELECT name FROM DED_Activity__c  ORDER BY Name];
system.debug('dedActivities size::::'+dedActivitiesList.size());
String jsStr=JSON.serialize(dedActivitiesList);
system.debug('jsStr:::'+jsStr);
return jsStr;
}*/
    //load service data for new Requests
    public void loadData(){
        system.debug('req>>>'+req);
        if (hasSanctions){
            pgHide=true;
            system.debug('hasSanctions----'+pgHide);
        }
        /*req.srvc__c = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('sid'));
req.conrol__c = srv.conrol__c;req.consta__c = srv.consta__c;req.sprrole__c = srv.sprrole__c;req.sprsta__c = srv.sprsta__c;
req.STA__c='Draft';
User usr = [select id,contact.account.mtc__c,contact.account.Name,contact.account.Email__c,contact.account.Phone,MobilePhone,accountid,contact.account.id,contact.account.adb__c,contact.account.xcuzn__c,contact.account.xcublg__c,contact.account.bgb__c,contact.account.bgnr__c,contact.account.bg__c,contact.account.loc__c,contact.account.Type,contact.account.Prk__c,contact.account.lcsnc__c,contact.account.lcsncnt__c,contact.account.lcedt__c,contact.account.psasnc__c,contact.account.psasncnt__c,contact.account.ecsnc__c,contact.account.ecsncnt__c,contact.account.cosnc__c,contact.account.cosncnt__c,contact.account.bgsnc__c,contact.account.bgsncnt__c,contact.account.snc__c,contact.account.info__c,contact.account.vestd__c,contact.account.vbtemp__c,contact.account.vbvv__c,contact.account.lc__c,contact.account.ORACLE_PARTY_ID__c,contact.account.lcsta__c,contact.account.lctp__c,contact.account.session__c,contact.account.vctemp__c,contact.account.vvsfp__c from User where id=:UserInfo.getUserId() limit 1];
acc = usr.contact.account;req.acc__c = Acc.Id;req.xaloc__c = acc.loc__c;req.rmob__c = usr.MobilePhone;
req.xbrnd__c =acc.xcuzn__c;req.xbn__c =acc.xcublg__c;req.xceml__c = usr.contact.account.Email__c; req.xoln__c=usr.contact.account.Phone;
*/

        User usr = [select id,contact.account.mtc__c,contact.MobilePhone,contact.Email,contact.name,contact.Account.vetemp__c,contact.Job_Title_Formula__c,contact.account.Name,contact.account.Email__c,contact.account.Phone,MobilePhone,accountid,contact.account.id,contact.account.adb__c,contact.account.xcuzn__c,contact.account.xcublg__c,contact.account.bgb__c,contact.account.bgnr__c,contact.account.bg__c,contact.account.loc__c,contact.account.Type,contact.account.Prk__c,contact.account.lcsnc__c,contact.account.lcsncnt__c,contact.account.lcedt__c,contact.account.psasnc__c,contact.account.psasncnt__c,contact.account.ecsnc__c,contact.account.ecsncnt__c,contact.account.cosnc__c,contact.account.cosncnt__c,contact.account.bgsnc__c,contact.account.bgsncnt__c,contact.account.snc__c,contact.account.info__c,contact.account.vestd__c,contact.account.vbtemp__c,contact.account.vbvv__c,contact.account.lc__c,contact.account.ORACLE_PARTY_ID__c,contact.account.lcsta__c,contact.account.lctp__c,contact.account.session__c,contact.account.vctemp__c,contact.account.vvsfp__c,Contact.mbs__c from User where id=:UserInfo.getUserId() limit 1];
        String srvcID =  String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('sid'));
        req = new g_req__c();

        xbrand = usr.contact.account.xcuzn__c;

        getServ(srvcID);
        req.srvc__c = srvcID;
        if (!isgu)
            req.acc__c = usr.contact.accountId;
        jbTitles = [select id, name from g_jb__c where Name in('STUDENT','Business Person')];
        if (isgu) {
            applicantInfo();
        }
        if (srvcID!=null && !isgu){/* for adnic group insurance page(grqgins) */
            if (srv!=null && srv.uid__c == 'ail' && req!=null){
                req.xchn__c = usr.contact.name;
                req.xbtnm__c = usr.contact.Job_Title_Formula__c;
                req.xdedc__c = Acc.Name;
                req.xcmob__c = usr.contact.MobilePhone;
                req.xzn__c = Acc.Prk__c;
                req.xceml__c = usr.contact.Email;
                req.Duration__c = usr.contact.Account.vetemp__c;
            }
        }
        system.debug('req  >> '+ req);
    }

    private void getServ(String srvID){
        if (srvID!=null){
            srv = [select id,sdg__c,sdg__r.docslbl__c,sdg__r.slbl__c,sdg__r.ptype__c,sdg__r.sd__c,uid__c,name,lbl__c,dsc__c,Prk__c,AccTp__c,conrol__c,consta__c,sprrole__c,sprsta__c,ckgsnc__c,snc__c,stg__r.pg__c,stg__r.apx__c,stg__r.reqq__c from g_Srvc__c where id=: srvID limit 1];
            //priority assignment
            /*if (String.isNotBlank(srv.sdg__r.ptype__c)){
priorityList = (srv.sdg__r.ptype__c).split(';');
}*/
            priorityList = new List<String>();
            slaMp = new Map<String,String>();
            if (String.isNotBlank(srv.sdg__r.ptype__c)){
                list<String> prLst = (srv.sdg__r.ptype__c).split(';');
                for (String str : prLst){
                    list<String> slaLst = str.split(':');
                    slaMp.put(slaLst[0],slaLst[1]);
                }
                priorityList.addAll(slaMp.keySet());
            }

            srvDesc=srv.sdg__r.sd__c;

        }
    }

    //Get salutaions for displaying as radio button
    public List<SelectOption> getSalutations(){

        //system.debug('getSalutation:::::');
        List<selectOption> options = new List<selectOption>();
        options = getOptions('xcslt__c');
        return options;
    }
    public List<SelectOption> getCountryOfBirth(){
        List<selectOption> options = new List<selectOption>();
        options = getOptions('xcbc__c');
        return options;
    }
    public List<SelectOption> getPlaceOfBirthUAE(){
        List<selectOption> options = new List<selectOption>();
        options = getOptions('xcqemrt__c');
        return options;
    }
    public List<SelectOption> getNationalityVals(){
        List<selectOption> options = new List<selectOption>();
        options = getOptions('xcnc__c');
        return options;
    }
    public List<SelectOption> getReligionVals(){
        List<selectOption> options = new List<selectOption>();
        options = getOptions('xcrlg__c');
        return options;
    }
    public List<SelectOption> getCommunityVals(){
        List<selectOption> options = new List<selectOption>();
        options = getOptions('xbrnd__c');
        return options;
    }
    public List<SelectOption> getBldgNameVals(){
        List<selectOption> options = new List<selectOption>();
        options = getOptions('xbn__c');
        return options;
    }
    public List<SelectOption> getQualLevels(){
        List<selectOption> options = new List<selectOption>();
        options = getOptions('xcql__c');
        return options;
    }
    public List<SelectOption> getOccuType(){ List<selectOption> options = new List<selectOption>(); options = getOptions('xcot__c'); return options; } public List<SelectOption> getQualCountry(){ List<selectOption> options = new List<selectOption>(); options = getOptions('xcqc__c'); return options; } public List<SelectOption> getEmirateValues(){ List<selectOption> options = new List<selectOption>(); options = getOptions('xcemrt__c'); return options; } public List<SelectOption> getCityValues(){ List<selectOption> options = new List<selectOption>(); options = getOptions('xccty__c'); return options; } public List<SelectOption> getAreaValues(){ List<selectOption> options = new List<selectOption>(); options = getOptions('xcarea__c'); return options; } public List<SelectOption> getPOBoxAreas(){ List<selectOption> options = new List<selectOption>(); options = getOptions('xcpobxarea__c'); return options; } public List<SelectOption> getAccomTypes(){ List<selectOption> options = new List<selectOption>(); options = getOptions('xcacctp__c'); return options; } public List<SelectOption> getPPIssuCntrs(){ List<selectOption> options = new List<selectOption>(); options = getOptions('xcpic__c'); return options; }
    //Get SponsorType for displaying as radio button
    public List<SelectOption> getSponsorTypes(){

        //system.debug('getSalutation:::::');
        List<selectOption> options = new List<selectOption>();
        options = getOptions('xcstp__c');
        return options;
    }
    public List<SelectOption> getMartialStatus(){
        //system.debug('getMartialStatus:::::');
        List<selectOption> options = new List<selectOption>();
        options = getOptions('xcms__c');
        return options;
    }
    public List<String> getSpokenLanguages(){
        //system.debug('getSpokenLanguages:::::');
        List<selectOption> options = new List<selectOption>();
        options = getOptions('xclng__c');
        List<string> spokenLngList = new List<string>();
        for (selectOption op : options){
            spokenLngList.add(op.getValue());
        }
        return spokenLngList;
    }
    //Get picklist options
    public List<SelectOption> getOptions(String PickListFieldName){
        Schema.sObjectType sobject_type = g_Req__c.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get(PickListFieldName).getDescribe().getPickListValues();
        List<selectOption> options = new List<selectOption>();
        for (Schema.PicklistEntry a : pick_list_values) {
            system.debug('a--- '+a);
            options.add(new selectOption(a.getLabel(), a.getValue()));
        }
        return options;
    }

    public  void setDynamicDoclst(){
        String input_param = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('dLst'));
        system.debug('input_param>>'+ input_param);
        system.debug('dynamicDoclst>>'+ dynamicDoclst);
        dynamicDoclst= input_param;//'Salary Certificate';
        system.debug('dynamicDoclst>>'+ dynamicDoclst);
    }

    public PageReference rerenderDocs(){
        system.debug('<rerenderDocs> docName: ' + docName);
        system.debug('<rerenderDocs> tImageBase64: ' + tImageBase64);
        return null;
    }
    public PageReference saveBO(){
        system.debug('saveBO::::::::::');
        try{
            system.debug('req.xcpip__c  -- '+req.xcpip__c);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error while Upsert'));

            //gu.AddErrorMsg('Upsert Error ');
            //throw new Exception('Error while Upsert');
            upsert req;
        }catch (DMLException exDML){
            system.debug('**  exDML.getDmlType(i) : ' +  exDML.getNumDml());
            gu.AddErrorMsg('**  exDML.getDmlType(i) : ' +  exDML.getNumDml() + '   **StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION: '+StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION);
            return null;
        }
        system.debug('Back office updated req:::::::::'+req);
        return null;
    }


    private void sd(){

        system.debug('status'+req.sta__c);
        system.debug('service code'+req.srvc__r.uid__c);

        String oldSta = req.sta__c;

        if (ispu && req.srvc__r.uid__c == '322' &&(string.isBlank(req.sta__c) || req.sta__c=='Completed' || req.sta__c=='Draft')){
            req.sta__c = 'Open';
        }
        if (ispu && req.srvc__r.uid__c != '322' && (string.isBlank(req.sta__c) || req.sta__c == 'Completed' || req.sta__c == 'Open')) {
            req.sta__c = 'Draft';
        }
        system.debug('<ApplicantDetailController> SAVE DRAFT::');
        try{
            upsert req;
            system.debug('Immigration File Setup Receipt:::::'+req.xfsr__c);
            if (String.isNotBlank(tImageBase64)){
                system.debug('<ApplicantDetailController> ** saveAttachment');
                saveAttachment();
            }

        }catch (DMLException exDML){

            System.Debug('**  exDML.getDmlType(i) : ' +  exDML.getNumDml() + '   **StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION: '+StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION);


        }catch (exception ex){
            System.Debug('** gctlReq01 Exception:'+ex.getMessage() );
            //  gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString());

        }


    }
    public void deleteAttach() {
        try {
            string attId = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('attId'));
            system.debug('deleteAttach attId >>' + attId);
            Attachment A = [select id,name from Attachment where id=:attId];
            if (req.STA__c!='Open')
            {
                delete A;
            }
        } catch (Exception e) {
            system.debug('ex::' + e.getStackTraceString());
            gU.AddErrorMsg(e);
        }
    }
    public PageReference saveDraft(){
        sd();
        system.debug('req.id::'+req.id);
        if (getCompCtrlMap() !=null){
            componentOne = (gctlRequ) getCompCtrlMap().get('componentOne'); componentOne.init(req.id);
        }
        return null;
    }

    public PageReference saveDraftR(){
        //if (String.isBlank(oldSta)){PageReference pageRef = new PageReference('/'+req.id); return pageRef;}
        sd();
        if (String.isBlank(req.id) || srv.uid__c== 'uae'){return null;}

        return new PageReference('/'+req.id);
    }

    public String rqNo {get;set;}
    public void saveAttachment(){

        try {
            //docName = 'Eida Card (Front Side)';
            system.debug('Rq Id::'+req.id + '   ***docName: ' + docName);
            List<g_reqDoc__c> rqDocList = [select id,RQ__r.name from g_reqDoc__c where RQ__c =:req.id and name=:docName];
            system.debug('rqDocList -- '+rqDocList);
            if (rqDocList != null && !rqDocList.isEmpty()){
                transient  String base64 ;
                base64 = (tImageBase64!=null)?tImageBase64:imageBase64;
                system.debug('base64 ------ '+base64);
                system.debug('docName ------ '+docName);
                system.debug('ParentId ------ '+rqDocList[0].id);
                rqNo = rqDocList[0].Rq__r.name;
                Attachment A = new Attachment(Body = EncodingUtil.base64Decode(base64), Name = docName+'.jpg', ParentId = rqDocList[0].id);
                insert A;

                system.debug('rqNo:: '+rqNo + 'attachementID: ' + A.id);

            }
        } catch (Exception e) {
            system.debug('ex:: getMessage: '+ e.getMessage() +'*****'+e.getStackTraceString());
            //   gU.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + e.getMessage() + ' ' + e.getStackTraceString());

        }
    }
    public String componentName {get;set;}
    public pageReference updateComponent(){
        String cName = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('cName'));
        //List<ApexComponent> copmList = [SELECT ApiVersion,ControllerKey,Name FROM ApexComponent];
        if (String.isNotBlank(cName))
            componentName = cName;
        //else
        //  componentName = 'LicAmdMemsDir';
        return null;
    }
    public g_Req__c fetchREQ(ID rqid) {
        String m_SOQL;
        g_Req__c rqt = [Select id, name,srvc__r.suvtp__c, xuvdet__c,xcddocs__c,xadtx3__c,xadtx2__c,xadtx4__c,srvc__r.sdg__r.ptype__c, srvc__r.stg__r.reqq__c, srvc__r.sdg__c From g_Req__c where id = : rqid];
        m_SOQL = rqt.srvc__r.stg__r.reqq__c;
        system.debug('m_SOQL >>>' + m_SOQL);
        g_Req__c rRqt = (g_Req__c) Database.query(m_SOQL + ' where id=\'' + rqt.Id + '\' and isDeleted = false');
        rRqt.xadtx2__c = rqt.xadtx2__c;
        rRqt.xadtx3__c = rqt.xadtx3__c;
        rRqt.xadtx4__c = rqt.xadtx4__c;
        rRqt.xuvdet__c = rqt.xuvdet__c;
        rRqt.xcddocs__c = rqt.xcddocs__c;
        return rRqt;
    }
    public Pagereference saveReq() {    system.debug('------------PAGE VALUE------------' + pageValue);    System.debug('request value :: ' + req);    String str = Label.DynamicDocumentServices;    List < String > strList = str.split(',');    if (srv.uid__c == '220') {if (activePoBoxSize!=null){req.Duration__c=activePoBoxSize;}/*US APD-2635*/        if (String.isNotBlank(req.xadtx4__c)) {            system.debug('adhc4Resp -- ' + adhc4Resp);            req.xadtx4__c += adhc4Resp != null ? adhc4Resp : '';            system.debug('req.xadtx4__c -- ' + req.xadtx4__c);        } else {            system.debug('adhc4Resp -- ' + adhc4Resp);            req.xadtx4__c = adhc4Resp;            system.debug('req.xadtx4__c -- ' + req.xadtx4__c);        }    }    system.debug(' strList:::' + strList);    system.debug(' nxtPgUrl:::' + nxtPgUrl);    try {        system.debug('req -- ' + req);        if (isgu && (srv.uid__c == 'dnc' || srv.uid__c == 'ail')) {            req.Acc__c = System.Label.DED_NOC_Account;        }        if (srv.uid__c == '155' || srv.uid__c == '148') {            req.sta__c = 'Under Review';        } else {            req.sta__c = (req.sta__c == 'Draft' || string.isBlank(req.sta__c)) ? 'Open' : req.sta__c;            system.debug('status1' + req.sta__c);        }        if (srv.uid__c == 'dnc' || !isgu || (isgu && String.isBlank(req.id))) {            upsert req;        }/*if (srv.uid__c == 'dnc' || srv.uid__c == 'gv') {*//* PJ 1.1*/        gctlReq_L reql= new gctlReq_L();        reql.updateEncriptedQRCodeLink(req);     /*}*/        system.debug(' after req::::' + req);        system.debug(' after req id::::' + req.id);        system.debug(' nDnDnDnDnD:' + nD);            system.debug(' nPnPnPnPnP:' + nP);        system.debug('editableMode:::' + editableMode);        system.debug('contains::::' + strList.contains(req.srvc__r.uid__c));        srv = [SELECT id, sdg__r.ptype__c, sdg__r.cv__c, sdg__r.sd__c, sdg__r.docslbl__c, xoi__c, uid__c, AddOnSrv__c, Name, lbl__c, dsc__c, Prk__c, AccTp__c, conrol__c, consta__c, sprrole__c, sprsta__c, ckgsnc__c, snc__c, stg__r.pg__c, stg__r.apx__c, stg__r.reqq__c, sdg__r.slbl__c FROM g_Srvc__c WHERE id = : req.srvc__c LIMIT 1];        system.debug('srv>>' + srv);        system.debug('srv req>>' + req.srvc__c);        system.debug('srv req uid>>' + req.srvc__r.uid__c);        system.debug('srv uid>>' + srv.uid__c);        system.debug('contains::::' + strList.contains(srv.uid__c));        if (srv.uid__c == '322') {            system.debug('----------322----------'); /*Account a = [select id,ccrm_sfid__c from Account where id=:Acc.id];*/            if (String.isNotBlank(Acc.ccrm_sfid__c)) {                grqWsOnboard.updateFrlAccInfo(req, Acc.ccrm_sfid__c);            }        }        if (srv.uid__c == '220' && req.id != null && req.xadh__c.contains('dc;')) {            system.debug('----------Call LA WS---------- ' + req.id);            callLAWS();        }        if (srv.uid__c == 'ail') {            system.debug('---------ail--------');            PageReference pageRef = new PageReference('/' + req.id);            pageRef.setRedirect(true);            return pageRef;        }        if (srv.uid__c.contains(Label.INTERNAL_EMP_SRV) && isgu && nP) {            req.STA__c = 'Open';            update req;            system.debug('------dnc------');            PageReference pageRef = new PageReference('/apex/lrqup');            pageRef.getParameters().put('id', req.id);            pageRef.getParameters().put('empid', empid);            pageRef.getParameters().put('pid', pid);            pageRef.getParameters().put('enc', encid);            pageRef.setRedirect(true);            return pageRef;        } else if (srv.uid__c.contains(Label.INTERNAL_EMP_SRV) && isgu && !nD && !nP) {            system.debug('------dnc------');            PageReference pageRef = new PageReference('/apex/grqStatus');            pageRef.getParameters().put('id', req.id);            pageRef.getParameters().put('empid', empid);            pageRef.getParameters().put('pid', pid);            pageRef.getParameters().put('enc', encid);            pageRef.setRedirect(true);            return pageRef;        }        system.debug('nD----' + nD);        system.debug('srv.uid__c----' + srv.uid__c);        if (srv.uid__c == '327') {            if (req.os__c == 'Contractor Appointed' && req.xfb__c != null && req.xfb__c != '') {                List < g_reqitemDoc__c > updList = new List < g_reqitemDoc__c > ();                for (g_reqitemDoc__c reqItmDoc: [select id, Req__c, reqAts__c from g_reqitemDoc__c where name in : req.xcddocs__c.split((';')) and reqDoc__r.RQ__c = : req.id]) {                    reqItmDoc.Req__c = true;                    reqItmDoc.reqAts__c = true;                    updList.add(reqItmDoc);                }                update updList;                PageReference pageRef = new PageReference('/apex/lrqup?id=' + req.id);                return pageRef;            }            PageReference pageRef = new PageReference('/grqSInfo?id=' + req.id);            return pageRef;        }        if (nD && !isgu && req != null && ((strList.contains(srv.uid__c)) == false) && srv.uid__c != '112' && srv.uid__c != '213' && srv.uid__c != '133' && srv.uid__c != '122' && srv.uid__c != '116' && srv.uid__c != 'apt' && srv.uid__c != '322') {            gU.AddWarningMsg(Label.msgMoreDocs);            System.debug('Warning msg' + Label.msgMoreDocs);            return null;        } else if (isgu && ((strList.contains(srv.uid__c)) == false) && srv.uid__c != '112' && srv.uid__c != '213' && srv.uid__c != '133' && srv.uid__c != '122' && srv.uid__c != '116' && srv.uid__c != 'apt') {            system.debug('===528====' + req.id);            system.debug('===528====' + empid);            system.debug('===528====' + srvcID);            system.debug('===528====' + encid);            PageReference pageRef = new PageReference('/apex/lrqup');            pageRef.setRedirect(true);            pageRef.getParameters().put('id', req.id);            pageRef.getParameters().put('empid', empid);            pageRef.getParameters().put('sid', srvcID);            pageRef.getParameters().put('enc', encid);            return pageRef;        } else if ((nxtPgUrl != null && nxtPgUrl != '') || ((srv.uid__c == '112' || srv.uid__c == '213' || srv.uid__c == '122' || srv.uid__c == '116' || srv.uid__c == 'apt'))) {            system.debug('-----------nxtPgUrl value--------' + nxtPgUrl);            system.debug('lrqup:::::');            if (srv.uid__c == '213' && !nD && nP) {                system.debug('--------------if 213 and no doc and payment is there');                PageReference pageRef = new PageReference('/apex/grqpy?id=' + req.id);                return pageRef;            }            if (!nD && !nP) {                g_Req__c rqsta = [SELECT sta__c, srvc__c FROM g_Req__c where id = : req.id];                req.sta__c = (req.sta__c == 'Open' || string.isBlank(req.sta__c)) ? 'Under Review' : rqsta.sta__c;                upsert req;                system.debug('status2' + req.sta__c);                PageReference pageRef = new PageReference('/grqSInfo?id=' + req.id + '&nD=' + nD + '&nP=' + nP);                system.debug('test completed 1:::' + pageRef);                return pageRef;            }            if (!nD && nP) {                PageReference pageRef = new PageReference('/apex/grqpy?id=' + req.id);                return pageRef;            }            PageReference pageRef = new PageReference('/apex/lrqup?id=' + req.id);            system.debug('---------------after changing page refrence-------------------');            return pageRef;        } else if (editableMode == null && srv.AddOnSrv__c != null && (srv.AddOnSrv__c).length() > 0) {            system.debug('-----------debug 1--------');            Set < String > gccNations = new Set < String > {                'Bahrain', 'Kuwait', 'Oman', 'Qatar', 'Saudi Arabia', 'United Arab Emirates'            };            if (srv.uid__c == '322' && gccNations.contains(req.xcnc__c)) {                return new PageReference('/apex/grqpy?id=' + req.id);            }            PageReference pageRef = new PageReference('/apex/grqaddon?id=' + req.id);            return pageRef;        } else if (editableMode == null && !nD && nP) {            system.debug('-------------debug 2-------------');            PageReference pageRef = new PageReference('/apex/grqpy?id=' + req.id);            return pageRef;        } else if (!nD && !nP && (srv.uid__c != '148' && srv.uid__c != '155')) {            system.debug('--------------page Value ---------- :' + pageValue);            system.debug('Redirect to grqSInfo:::::');            system.debug('req status' + req.sta__c);            system.debug('req service' + srv.uid__c);            system.debug('req sta__c:: ' + req.sta__c);            if (srv.uid__c == '220') {                req.sta__c = 'Under Review';                system.debug('status3' + req.sta__c);            }            if (req.sta__c != 'Completed') {                system.debug('status4' + req.sta__c);                if (srv.uid__c != 'uae' && srv.uid__c != '135') {                    g_Req__c rqsta = [SELECT sta__c, srvc__c FROM g_Req__c where id = : req.id];                    req.sta__c = (req.sta__c == 'Open' || string.isBlank(req.sta__c)) ? 'Under Review' : rqsta.sta__c;                    system.debug('status5' + req.sta__c);                } else {                    updateItmSTA('ok');                    req.sta__c = 'Completed';                    system.debug('status6' + req.sta__c);                }            }            if (srv.uid__c == '135') {                system.debug('Program__c:::' + req.Program__c);                system.debug('Course_Name__c:::' + req.Course_Name__c);                system.debug('Current_Course_Year__c:::' + req.Current_Course_Year__c);                system.debug('GPA__c:::' + req.GPA__c);                updateItmSTA('ok');                req.sta__c = 'Completed';                system.debug('status7' + req.sta__c);                String docName = 'Student Curriculum Vitae';                List < Attachment > attLst = [select id, body from Attachment where parentid in (select id from g_reqDoc__c where RQ__r.id = : req.id and name = : docName) order by createddate desc limit 1];                req.xcCVDocID__c = attLst[0].id;                Contact con = new Contact(id = req.con__c);                con.CVDocID__c = attLst[0].id;                update con;            }            upsert req;            PageReference pageRef = new PageReference('/grqSInfo?id=' + req.id);            system.debug('test:::' + pageRef);            return pageRef;        } else if (editableMode == null && !nD && !nP && (srv.uid__c == '148' || srv.uid__c == '155')) {            system.debug('not nD');            system.debug('Redirect to grqSInfo new:::::');            system.debug('req status' + req.sta__c);            system.debug('req uid' + req.srvc__r.uid__c);            system.debug('req service' + srv.uid__c);            req.sta__c = req.sta__c == 'Open' ? 'Completed' : req.sta__c;            system.debug('status8' + req.sta__c);            if (srv.uid__c == '155') {                req.sta__c = 'Under Review';                system.debug('status9' + req.sta__c);            }            upsert req;            PageReference pageRef = new PageReference('/grqSInfo?id=' + req.id);            system.debug('test completed 2:::' + pageRef);            return pageRef;        } else {            editableMode = false;        }    } catch (Exception e) {        system.debug('ex::' + e.getStackTraceString());        system.debug('ex msg::' + e.getMessage());        system.debug('ex line number::' + e.getLineNumber());        gU.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + e.getMessage() + ' ' + e.getStackTraceString());        return null;    }    return null;}
    public void applicantInfo() {
        String conId = apexpages.currentpage().getparameters().get('pid');
        system.debug('conId:;' + conId);
        if (String.isNotBlank(conId)) {
            List < Contact > conLst = [select id, Accountid, id__c, nc__c, p__c, Proc__c, RP_Expiry_Due__c, mn__c, Spon__c, snc__c, sp__c, rp__c, rpid__c, rped__c, mbs__c, ma__c, mta__c, moa__c, ha__c, rpui__c, HomePhone, firstname, middlename, lastname, MobilePhone, mon__c, fan__c, Gender__c, Birthdate, bc__c, Email, fnar__c, mnar__c, lnar__c, lng__c, mona__c, jb__c, eidid__c, eidedt__c, ql__c, ot__c, fs__c, of__c, emrt__c, cty__c, strt__c, area__c, pobx__c, pobxarea__c, pic__c, pip__c, pid__c, ped__c, rlg__c, ms__c, bp__c, bpa__c, np__c, Salutation, Department from Contact where id =: conId];
            system.debug('contact mona__c::::::' + conLst[0].mona__c);
            if (conLst != null && !conLst.isEmpty()) {
                req.Con__c = conLst[0].id;
                req.xadh__c = 'md;';
                req.Acc__c = conLst[0].Accountid;
                req.xcnc__c = conLst[0].nc__c;
                req.xcp__c = conLst[0].p__c;
                req.xcfn__c = conLst[0].firstname;
                req.xcln__c = conLst[0].lastname;
                req.xcmn__c = conLst[0].middlename;
                req.xcmn__c = conLst[0].mn__c;
                req.xcmon__c = conLst[0].mon__c;
                req.xcfan__c = conLst[0].fan__c;
                req.Gender__c = conLst[0].Gender__c;
                req.xcbd__c = conLst[0].Birthdate;
                req.xcbc__c = conLst[0].bc__c;
                req.xceml__c = conLst[0].Email;
                req.xcfnar__c = conLst[0].fnar__c;
                req.xcmnar__c = conLst[0].mnar__c;
                req.xclnar__c = conLst[0].lnar__c;
                req.xclng__c = conLst[0].lng__c;
                req.xcmonar__c = conLst[0].mona__c;
                req.xcjb__c = conLst[0].jb__c;
                req.xceidid__c = conLst[0].eidid__c;
                req.xceidedt__c = conLst[0].eidedt__c;
                req.xcql__c = conLst[0].ql__c;
                req.xcfs__c = conLst[0].fs__c;
                req.xcot__c = conLst[0].ot__c;
                req.xcof__c = conLst[0].of__c;
                req.xcemrt__c = conLst[0].emrt__c;
                req.xccty__c = conLst[0].cty__c;
                req.xcstrt__c = conLst[0].strt__c;
                req.xcarea__c = conLst[0].area__c;
                req.xcpobx__c = conLst[0].pobx__c;
                req.xcpobxarea__c = conLst[0].pobxarea__c;
                req.xcpic__c = conLst[0].pic__c;
                req.xcpip__c = conLst[0].pip__c;
                req.xcpid__c = conLst[0].pid__c;
                req.xcped__c = conLst[0].ped__c;
                req.xcrlg__c = conLst[0].rlg__c;
                req.xcms__c = conLst[0].ms__c;
                req.xcbp__c = conLst[0].bp__c;
                req.xcpobar__c = conLst[0].bpa__c;
                req.xcnp__c = conLst[0].np__c;
                req.xcslt__c = conLst[0].Salutation;
                req.xcmbs__c = conLst[0].mbs__c;
                req.xcma__c = conLst[0].ma__c;
                req.xcmta__c = conLst[0].mta__c;
                req.xcmoa__c = conLst[0].moa__c;
                req.xcha__c = conLst[0].ha__c;
                req.xchph__c = conLst[0].HomePhone;
                req.xcmob__c = conLst[0].MobilePhone;
                req.xrp__c = conLst[0].rp__c;
                req.xui__c = conLst[0].rpui__c;
                req.xrpid__c = conLst[0].rpid__c;
                req.xrped__c = conLst[0].rped__c;
                req.Spr__c = conLst[0].Spon__c;
                req.xcsnc__c = conLst[0].snc__c;
                req.xcsp__c = conLst[0].sp__c;
                req.xcid__c = conLst[0].id__c;
                req.xdccn__c = conLst[0].Department;
                req.xcqc__c = conLst[0].nc__c;
                req.STA__c = 'Draft';
            }
        }
    }

    public void edit(){
        system.debug('edit:::');
        editableMode = true;
    }
    public void cancel(){
        system.debug('cancel:::');
        editableMode = false;
    }

    public PageReference CancelR(){ g_req__c rq = req; if (ispu){ Savepoint sp = null;String oldSTA = rq.STA__c; try{ If((rq.STA__c!='Draft' && rq.STA__c!='Open') || rq.AP__c>0 || rq.AOP__c>0){ gu.AddWarningMsg(Label.msgReqnoCancel); return null; } sp=Database.setSavePoint(); upsertR('Cancelled'); if (!cancelItms()){ Database.rollback(sp); rq.STA__c = oldSTA; return null; } return (new ApexPages.StandardController(rq)).view(); } catch (DMLException exDML){if (sp!=null){Database.rollback(sp);}for (Integer i = 0; i < exDML.getNumDml(); i++) {if ( exDML.getDmlType(i) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION ){System.Debug('** Exception:'+exDML.getDmlMessage(i)); gu.AddErrorMsg(Label.msgException);}}rq.STA__c= oldSTA;return null;}catch (exception ex){if (sp!=null){Database.rollback(sp);}gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString());rq.STA__c = oldSTA;return null;} }/*/add second id for M */ else if (UserInfo.getProfileId()=='00e20000001Ajl3' || UserInfo.getProfileId()=='00e20000001Ajl3AAC' || UserInfo.getProfileId()=='00e20000001mIim' || UserInfo.getProfileId()=='00e20000001mIimAAE' || UserInfo.getProfileId()=='00e28000001sbAlAAI'){ if (rq.AOP__c>0){ gu.AddErrorMsg('Request has open payments. Please close the payments before proceeding.'); return null; } Savepoint sp = null;String oldSTA = rq.STA__c; try{ sp=Database.setSavePoint(); upsertR('Cancelled'); if (rq.AP__c>0){ if (!cancelItms()){ Database.rollback(sp); rq.STA__c = oldSTA; return null; } } else{ if (!cancelItms()){ Database.rollback(sp); rq.STA__c = oldSTA; return null; } } return (new ApexPages.StandardController(rq)).view(); } catch (DMLException exDML){if (sp!=null){Database.rollback(sp);}for (Integer i = 0; i < exDML.getNumDml(); i++) {if ( exDML.getDmlType(i) != StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION ){System.Debug('** Exception:'+exDML.getDmlMessage(i)); gu.AddErrorMsg(Label.msgException);}}rq.STA__c= oldSTA;return null;}catch (exception ex){if (sp!=null){Database.rollback(sp);}gu.AddErrorMsg(Label.msgException); System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString());rq.STA__c = oldSTA;return null;} } else{ gu.AddErrorMsg('Invalid operation.'); return null; } /*/return null; */ }
    @TestVisible private void upsertR(String sta) { req.STA__c = sta; /*/ system.debug('spouse name::' + rq.xspn__c); */ upsert req; }

    private Boolean cancelItms(){
        map<String,Id> mapSTA = new map<String,Id>();
        for (g_srvcitm_Status__c s: [select id,cd__c,itm__r.cd__c from g_srvcitm_Status__c where itm__r.srvc__c=:req.srvc__c and cd__c='c']){
            mapSTA.put(s.itm__r.cd__c, s.Id);
        }
        list<g_reqitem__c> items = [select Id, itm__r.cd__c,sta__c from g_reqitem__c where RQ__c=: req.Id and isDeleted = false and sta__r.Tp__c='Open'];
        list<g_reqitem__c> toUpdate = new list<g_reqitem__c>();
        for (g_reqitem__c i: items){
            if (mapSTA.get(i.itm__r.cd__c)==null){gu.AddErrorMsg(Label.msgNFSTAC);return false;}
            i.sta__c = mapSTA.get(i.itm__r.cd__c);
            toUpdate.add(i);
        }
        if (toUpdate.size()>0){update toUpdate;}
        return true;
    }

    private Boolean updateItmSTA(String staCd){ map<String,Id> mapSTA = new map<String,Id>(); System.debug('<updateItmSTA> req: ' + req); System.debug('<updateItmSTA> req.srvc__c: ' + req.srvc__c);  for (g_srvcitm_Status__c s: [select id,cd__c,itm__r.cd__c from g_srvcitm_Status__c where itm__r.srvc__c=:req.srvc__c and cd__c=:staCd]){ mapSTA.put(s.itm__r.cd__c, s.Id); } list<g_reqitem__c> items = [select Id, itm__r.cd__c,sta__c from g_reqitem__c where RQ__c=: req.Id and isDeleted = false and sta__r.Tp__c='Open']; list<g_reqitem__c> toUpdate = new list<g_reqitem__c>(); for (g_reqitem__c i: items){ if (mapSTA.get(i.itm__r.cd__c)==null){gu.AddErrorMsg(Label.msgNFSTAC);return false;} i.sta__c = mapSTA.get(i.itm__r.cd__c); toUpdate.add(i); } if (toUpdate.size()>0){update toUpdate;} return true; }


    public PageReference ContactPreDetailReq(){
        system.debug('In >> ContactPreDetailReq()');
        contReq = new g_Req__c();
        if (req.con__c!=null)
            contReq = contactInfoRequest(contReq,req.Con__c);
        system.debug('contReq>>'+contReq);
        return null;
    }
    public g_Req__c contactInfoRequest(g_Req__c reqTp,Id ConId){
        List<Contact> conLst = [select id,nc__c,p__c,xean__c,RP_Expiry_Due__c,Spon__c,snc__c,sp__c,rp__c,rpid__c,eididt__c,rped__c,mbs__c,ma__c,mta__c,moa__c,ha__c,HomePhone,firstname,middlename,lastname,MobilePhone,mon__c,fan__c,Gender__c,Birthdate,bc__c,Email,fnar__c,mnar__c,lnar__c,lng__c,mona__c,jb__c,eidid__c,eidedt__c,ql__c,ot__c,fs__c,of__c,emrt__c,cty__c,strt__c,area__c,pobx__c,pobxarea__c,pic__c,pip__c,pid__c,ped__c,rlg__c,ms__c,bp__c,bpa__c,np__c,Salutation from Contact where id=:ConId ];
        system.debug('conLst'+conLst);
        if (conLst != null && !conLst.isEmpty()){

            reqTp.xcnc__c = conLst[0].nc__c; reqTp.xcp__c = conLst[0].p__c; reqTp.xcfn__c =  conLst[0].firstname; reqTp.xcln__c = conLst[0].lastname; reqTp.xcmn__c = conLst[0].middlename; reqTp.xcmon__c = conLst[0].mon__c; reqTp.xcfan__c = conLst[0].fan__c; reqTp.Gender__c = conLst[0].Gender__c; reqTp.xcbd__c = conLst[0].Birthdate; reqTp.xcbc__c =  conLst[0].bc__c; reqTp.xceml__c =  conLst[0].Email; reqTp.xcfnar__c = conLst[0].fnar__c; reqTp.xcmnar__c =  conLst[0].mnar__c; reqTp.xclnar__c =  conLst[0].lnar__c; reqTp.xclng__c =  conLst[0].lng__c; reqTp.xcmonar__c = conLst[0].mona__c; reqTp.xcjb__c = conLst[0].jb__c; reqTp.xceidid__c = conLst[0].eidid__c; reqTp.xceidedt__c = conLst[0].eidedt__c; reqTp.xceididt__c=conLst[0].eididt__c; reqTp.xcql__c = conLst[0].ql__c; reqTp.xcfs__c = conLst[0].fs__c; reqTp.xcot__c = conLst[0].ot__c; reqTp.xcof__c  = conLst[0].of__c; reqTp.xcemrt__c = conLst[0].emrt__c; reqTp.xccty__c = conLst[0].cty__c; reqTp.xcstrt__c = conLst[0].strt__c; reqTp.xcarea__c = conLst[0].area__c; reqTp.xcpobx__c =  conLst[0].pobx__c; reqTp.xcpobxarea__c = conLst[0].pobxarea__c; reqTp.xcpic__c = conLst[0].pic__c; reqTp.xcpip__c = conLst[0].pip__c; reqTp.xcpid__c = conLst[0].pid__c; reqTp.xcped__c = conLst[0].ped__c; reqTp.xcrlg__c = conLst[0].rlg__c; reqTp.xcms__c = conLst[0].ms__c; reqTp.xcbp__c = conLst[0].bp__c; reqTp.xcpobar__c = conLst[0].bpa__c; reqTp.xcnp__c = conLst[0].np__c; reqTp.xcslt__c = conLst[0].Salutation;
            system.debug('conLst salary'+conLst[0].mbs__c);
            reqTp.xcmbs__c = conLst[0].mbs__c; reqTp.xcma__c = conLst[0].ma__c; reqTp.xcmta__c = conLst[0].mta__c; reqTp.xcmoa__c = conLst[0].moa__c;  reqTp.xcha__c = conLst[0].ha__c; reqTp.xchph__c = conLst[0].HomePhone; reqTp.xcmob__c = conLst[0].MobilePhone; reqTp.xrp__c = conLst[0].rp__c; reqTp.xrpid__c = conLst[0].rpid__c; reqTp.xrped__c = conLst[0].rped__c; reqTp.Spr__c = conLst[0].Spon__c; reqTp.xcsnc__c = conLst[0].snc__c; reqTp.xcsp__c = conLst[0].sp__c;

            system.debug('reqTp'+reqTp);
            system.debug('reqTp salary'+reqTp.xcmbs__c);

            BasicSal = conLst[0].mbs__c;
            eidid = conLst[0].eidid__c;
            eidExpDt = conLst[0].eidedt__c;
        }
        return reqTp;
    }


    public PageReference ApplicantContactInfo(){
        Pagereference ref = null;
        String sdid = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('sid'));
        system.debug('In ApplicantContactInfo rq>> '+req);

        try {
            if (req!=null && !String.isBlank(req.con__c)){
                req.sta__c = (req.sta__c=='Draft' || string.isBlank(req.sta__c)) ? 'Draft' : req.sta__c;
                system.debug('applicant:'+req.Con__c);
                system.debug('srvc::'+req.srvc__c);

                List<Contact> conLst = [select id,nc__c,p__c,RP_Expiry_Due__c,Spon__c,snc__c,sp__c,rp__c,rpid__c,rped__c,mbs__c,ma__c,mta__c,moa__c,eididt__c,ha__c,HomePhone,firstname,middlename,lastname,MobilePhone,mon__c,fan__c,Gender__c,Birthdate,bc__c,Email,fnar__c,mnar__c,lnar__c,lng__c,mona__c,jb__c,eidid__c,eidedt__c,ql__c,ot__c,fs__c,of__c,emrt__c,cty__c,strt__c,area__c,pobx__c,pobxarea__c,pic__c,pip__c,pid__c,ped__c,rlg__c,ms__c,bp__c,bpa__c,np__c,Salutation from Contact where id=:req.Con__c ];
                system.debug('conLst'+conLst);
                if (conLst != null && !conLst.isEmpty()){

                    req = contactInfoRequest(req,req.Con__c);
                    String tsid =  String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('sid'));
                    if (tsid!=null){req.srvc__c=tsid;}
                    req.xadh__c = String.isNotBlank(req.xadh__c) ? req.xadh__c:'ptn;';

                    system.debug('req'+req);
                    system.debug('req salary >>'+req.xcmbs__c);
                    upsert req;

                    BasicSal = conLst[0].mbs__c;
                    eidid = conLst[0].eidid__c;
                    eidExpDt = conLst[0].eidedt__c;
                    reqId = req.id;
                    system.debug('req afer upset>>'+req);
                }

                PageReference pageRef = new PageReference('/'+reqId);
                return pageRef;
            }
            //system.debug('req.Con__c>>>'+req.Con__c);
        } catch (DMLException exDML) {
            system.debug('DMLExceptionEEEEEE: ' + exDML);
            system.debug('DMLExceptionEEEEEE error message: ' + exDML.getdmlMessage(0));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,exDML.getdmlMessage(0)));
            //PageReference pageRef = new PageReference('/grqatt?sid=a0L5D000001zLEeUAM');
            return null;
        } catch (exception ex) {system.debug('gctlReq01>>>'+ex );   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));}
        system.debug('Out ApplicantContactInfo rq>> '+req);
        return null;
    }

    @RemoteAction
    public Static String checkDoc(String reqid,String dNames){
        system.debug('inisde checkDoc>> '+dNames);
        system.debug('reqid>> '+reqid);
        list<String> dNms= new List<String>();
        list<ID> rdocList= new List<ID>();
        Map<String,ID> dNamDidMap = new Map<String,ID>();
        Map<ID,ID> DidAttidMap = new Map<ID,ID>();
        dNms = dNames.split(';');
        for (g_reqitemDoc__c doc : [select id,Name,reqItm__r.xcp__c,reqItm__r.rq__c,reqDoc__c from g_reqitemDoc__c where reqItm__r.rq__c=:reqid and Req__c=true and Name IN :dNms order by createddate]){
            system.debug('doc >>'+doc);
            rdocList.add(doc.reqDoc__c);
            dNamDidMap.put(doc.Name,doc.reqDoc__c);
        }
        Map<string,Attachment> attMp = new Map<string,Attachment>();
        for (Attachment att : [select id,name,body,parentid from Attachment where parentid=:rdocList]){
            attMp.put(att.name.split('\\.')[0],att);
        }

        Map<String,Boolean> resultMap = new Map<String,Boolean>();
        String erDoc='';
        system.debug('dNms::::'+dNms);
        for (String dn:dNms){
            if (attMp.get(dn)!=null){
                resultMap.put(dn,true);
            }else{
                resultMap.put(dn,false);
                erDoc = erDoc+' '+dn+',';
            }
        }
        erDoc = erDoc.trim();
        erDoc = erDoc.removeEnd(',');
        system.debug('dNamDidMap >>'+dNamDidMap);
        system.debug('attMp >>'+attMp);
        system.debug('resultMap >>'+resultMap);

        system.debug('erDoc >>'+erDoc);
        if (erDoc!=null && erDoc!=''){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Document ' +erDoc + ' need to be uploaded.'));
            return erDoc + ' document/s need to be uploaded.';
        }
        return 'true';
    }

    public pagereference authenticateUser(){
        empid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('empid'));
        encid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('enc'));
        isgu = gu.isGuestUser(userInfo.getProfileId());
        pagereference pg=null;
        if (gu.isGuestUser(userInfo.getProfileId())){
            System.debug('** Is Guest User');
            if ((req.srvc__r.uid__c != 'dnc' && (empid == '' || empid == null || encid == '' || encid == null   || !DEG_Checksum(empid,encid))&& !Test.isRunningTest())){
                pg = new pagereference('/apex/AccesDeniedPage');
            }
            if (String.isNotBlank(empid)){
                emp = [select sta__c,id, name,rped__c,RP_Expiry_Status__c from Contact where idtxt__c=:empid limit 1];
            }
        }
        else{return null;}
        return pg;

    }
    public static boolean DEG_Checksum(String msg, String encText) {
        String eCd = EncodingUtil.convertToHex(Crypto.generateDigest('SHA1', blob.valueOf('P@ssw0rdAXSHRMS'+msg))).toUpperCase();
        System.debug('** eCd:'+eCd);    System.debug('** encText:'+encText);
        return eCd == encText;
    }

    @RemoteAction
    public Static String getArabicName(String uName){
        String ArbName;
        system.debug('inisde getarabic');
        if (String.isBlank(gApiToken))
            gApiToken = [Select id, tokenvalue__c from GDRFAAPITOKEN__mdt LIMIT 1].tokenvalue__c;
        // SECURITY: Removed sensitive debug log
        system.debug('uName'+uName);
        ArbName = GDRFAUtil.engToArabicStr(uName,gApiToken);
        system.debug('ArbName'+ArbName);
        return ArbName;
    }


    /*Building Access Permit special methods - Start*/
    public String renewalRqId{get;set;}
    public List<String> lstPrmtReq {get;set;}
    public Map<id,g_req__c> mapActiveReq {get;set;}
    public list<g_req__c> lstActiveReq  {get;set;}
    public PageReference getPrmtReqs(){
        loadLocations();
        if (!Test.isRunningTest())loadActiveLease();
        PageReference pageRef;
        if (!isFContU && req.srvc__r.uid__c == '327'){
            pageRef = new PageReference('/apex/grqStatus');
            pageRef.getParameters().put('id', req.id);
            pageRef.setRedirect(true);
        }
        lstPrmtReq = new List<String>();
        if (String.isNotBlank(req.hpr__c)){lstPrmtReq = req.hpr__c.split(';');}
        // axs-2.0 get all active apt requests and display on the page
        mapActiveReq = new Map<id,g_req__c>([SELECT Id,xadh__c, Name, xcpid__c, xcped__c,xrap__c,xet__c, prf__c,xbn__c,csp__c,xchn__c,xceml__c,xcmob__c from g_req__c where srvc__r.uid__c='apt' and id!=:req.id and acc__c=:req.acc__c and i_STA__c='Access Permit | Approved' and xcped__c>today and (NOT xadh__c LIKE '%apr%')]);
        if (mapActiveReq.size()==0){mapActiveReq=null;}
        return pageRef;
    }

    public  List<String> strLocList {get;set;}
    //fitout
    public  Map<String,grqWsDccaGetService.Products> actLeaseLoc {get;set;}
    public void loadActiveLease(){ actLeaseLoc = new Map<String,grqWsDccaGetService.Products>(); List<grqWsDccaGetService.Records> leaseLoc = new List<grqWsDccaGetService.Records>(); String partyId = ''; if (u != null){ partyId = u.contact.account.ORACLE_PARTY_ID__c; }else{ partyId = req.acc__r.ORACLE_PARTY_ID__c; } leaseLoc = grqWsDccaGetService.loadD3Loc(partyId); if (leaseLoc.size() > 0 ){ for (grqWsDccaGetService.Records rec : leaseLoc){ if (string.isEmpty(rec.ContractNumber) && rec.BusinessPark!='D-Quarters'){isActiveLease = true; /*US APD2635 */    }if (rec.AgNo != null){ leaseType = rec.Type; isRetailCat = (rec.LeaseType == 'Retail' || rec.LeaseType == 'PMLA-Retail') ? true: false; system.debug('products size'+rec.Products.size()); if (rec.Products.size() > 0){ for (grqWsDccaGetService.Products product : rec.Products){ system.debug('product.ProductName'+product.ProductName); actLeaseLoc.put(product.ProductName , product); } } } } system.debug('actLeaseLoc'+actLeaseLoc.keySet()); /* leaseType = leaseLoc[0].Type; system.debug('**Retail'+leaseLoc[0].Category); isRetailCat = (leaseLoc[0].Category == 'Retail' || leaseLoc[0].Category == 'Retail Support') ? true: false; for (grqWsDccaGetService.Products product : leaseLoc[0].Products){ actLeaseLoc.put(product.ProductName , product); } */ } }
    public void loadLocations(){
        List <loc__c> loc = new List<loc__c>();
        strLocList = new  List<String>();
        if (req.Acc__c != null){Acc = [select id,SF_CRM_ID__c,ecedt__c,dedlic__c,lcsta__c,Name,Legal_Framework__c,lrd__c,onar__c,Phone,adb__c,bgb__c,bgnr__c,bg__c,lc__c,ORACLE_PARTY_ID__c,loc__c,Type,Prk__c,lcsnc__c,lcsncnt__c,psasnc__c,psasncnt__c,ecsnc__c,ecsncnt__c,cosnc__c,cosncnt__c,bgsnc__c,bgsncnt__c,snc__c,info__c,vestd__c,vbtemp__c,vbvv__c,lcedt__c,vbtst__c,vvsfp__c,(Select Id ,acct__c,act__c,act_type__c,bus_unit__c,dcca_id__c,lic__c,or_prty__c,seg__c,sDate__c from aseg__r),(Select Id,Loc__c,agrno__c,acc__c,bu__c,IsMain__c,IsSub__c,ls_end__c,ls_std__c,active__c,rpi__c,Is_frzn__c from aloc__r where Is_frzn__c=true  ),session__c from Account where id=: req.Acc__c limit 1];}
        if (Acc!=null && Acc.aloc__r.size()>0){
            loc =Acc.aloc__r;system.debug('Account loc'+loc);
            if (loc.size()>0){for (loc__c l : loc){ strLocList.add(l.Loc__c);}}
        }
    }

    public List<String> getlstActivities(){
        List<selectOption> options = new List<selectOption>(); List<string> lstActivities = new List<string>(); options = getOptions('hpr__c');
        for (selectOption op : options){  lstActivities.add(op.getValue());}
        return lstActivities;
    }

    public List<DED_Activity__c> getDedActivities(){
        system.debug('getDedActivities::::');
        List<selectOption> options = new List<selectOption>();
        List<DED_Activity__c> dedActivities = new List<DED_Activity__c>();
        dedActivities = [SELECT name FROM DED_Activity__c  ORDER BY Name limit 1000];
        system.debug('dedActivities:::'+dedActivities);
        return  dedActivities;
    }


    public PageReference updateRenewalReq(){ System.debug('<updateRenewalReq> renewalRqId: ' + renewalRqId); try{ g_req__c rqToUpdate = mapActiveReq.get(renewalRqId); rqToUpdate.xcpid__c = req.xcpid__c; rqToUpdate.xcped__c = req.xcped__c; rqToUpdate.xst__c = req.xst__c; rqToUpdate.xet__c = req.xet__c;rqToUpdate.xadh__c = 'apr;'; update rqToUpdate; return new PageReference('/grqSInfo?id='+rqToUpdate.id); }catch (Exception exDML){ System.Debug('**  exDML.getDmlType(i) : ' +  exDML.getNumDml() + '   **StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION: '+StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION);  return null; }  }
    public String wsFullName {get;set;} public Pagereference getFullNm(){ system.debug('<getFullNm starts>:: ' + req.Srvc__r.uid__c); system.debug('req passport::: ' + req.xcp__c); try{ Integer year = req.xcbd__c.year(); wsFullName = GDRFAUtil.getAppFullNm(req.xcp__c,GDRFAUtil.getCountryCd(req.xcpic__c),req.xcbd__c.year()); }catch (Exception ex){ /* show error msg on page?*/ system.debug('<getFullNm Exception>:: ' + ex.getMessage()); }  system.debug('<getFullNm ends>'); return null; }  public PageReference validateOtp(){ return null;} public PageReference generateOtp(){ return null;} public PageReference loginUsr(){ return null;}
    public String otpResult, grqfl_del, otpNumFromPage;
    public Integer otpAttempt;

    /*Building Access Permit special methods - End*/

    public Boolean nCou{get{for (g_reqitem__c i:req.Items__r){if (i.Courier_Stage__c=='Collection'){return true;}}return false;}}
    public Boolean nP{get{for (g_reqitem__c i: [select id,AD__c from g_reqitem__c where RQ__c=:req.id]){if (i.AD__c>0){return true;}}return false;}}
    public Boolean nRV{get{for (g_reqitem__c i: req.Items__r){if (i.AP__c==0 && i.AD__c==0 && (i.STA__r.cd__c=='n' || i.STA__r.cd__c=='rv')){return true;}}return false;}}
    public Boolean nD { get { /*if (req.rDocs__r == null || req.rDocs__r.isEmpty()) { return false; }*/ for (g_reqDoc__c d: [select id, upOk__c from g_reqDoc__c where RQ__c =: req.id]) { if (!d.upOk__c) { return true; } } return false; } }
    // public Boolean nD{get{if (req.rDocs__r == null || req.rDocs__r.isEmpty()){return false;}for (g_reqDoc__c d:[select id,upOk__c from g_reqDoc__c where  RQ__c=:req.id]){if (!d.upOk__c){return true;}}return false;}}
    // pageValue='lrqup'pageValue='';
    public String selectedEmb{get;set;}
    public List<SelectOption> getCountriesOptions() {
        List<SelectOption> countryOptions = new List<SelectOption>();
        //Map<String,String> mapCC = new Map<String,String>{'United Arab Emirates' => 'uae','Afganisthan '=>'xaf','Algeria'=>'xdz','Albania'=>'xal','Angola'=>'xao','Argentina'=>'xar','Armenia'=>'xam','Australia'=>'xau','Austria'=>'xat','Azerbaijan'=>'xaz','Bahrain'=>'xbx','Bangladesh'=>'xbd','Belarus'=>'xbl','Belgium'=>'xbe','Bosnia and Herzegovina '=>'xba','Brazil'=>'xbr','Bulgaria'=>'xbg','Canada'=>'xca','Chile'=>'xcl','China'=>'xcn','Colombia'=>'xco','Costa Rica'=>'xcr','Cyprus'=>'xcy','Denmark'=>'xdk','Dominican Republic'=>'xdu','Eritrea'=>'xer','Ethiopia'=>'xet','France'=>'xfr','Ghana'=>'xgh','Greece'=>'xgr','Grenada'=>'xgd','Guinea'=>'xgn','Hungary'=>'xhu','India'=>'xin','Indonasia'=>'xid','Iran'=>'xir','Ireland'=>'xie','Italy'=>'xit','Kazakhstan'=>'xkz','Kuwait'=>'xkw','Kyrgyzstan'=>'xkg','Lebanon'=>'xlb','Libya'=>'xly','Luxembourg'=>'xlu','Malaysia'=>'xmy','Malta'=>'xmt','Mexico'=>'xmx','Montenegro'=>'xcs','Mozambique'=>'xmz','Nepal'=>'xnp','Netherlands'=>'xnl','New Zealand'=>'xnz','Norway'=>'xnw','Oman'=>'xom','Pakistan'=>'xpk','Palestine'=>'xps','Panama'=>'xpa','Peru'=>'xpe','Philippine'=>'xph','Poland'=>'xpl','Portugal'=>'xpt','Republic of Korea'=>'xkr','Republic of Liberia'=>'xlr','Russian Federation'=>'xru','Rwanda'=>'xrw','Saint Kitts'=>'xkn','Saudi Arabia'=>'xsa','Senegal'=>'xsn','Serbia'=>'xsr','Seychelles'=>'xsc','Slova Republic'=>'xsk','Somalia'=>'xso','Spain'=>'xes','Sri Lanka'=>'xsl','Sudan'=>'xsd','Sweden'=>'xse','Switzerland'=>'xch','Tajikistan'=>'xtj','Tanzania'=>'xtz','Thailand'=>'xth','Tunisia'=>'xtn','Turkey'=>'xtr','Turkmenistan'=>'xtm','Uganda'=>'xug','Ukraine'=>'xua','Uzbekistan'=>'xuz','Venezuela'=>'xve','Vietnam'=>'xvn'};
        Map<String,String> mapCC = new Map<String,String>{'United Arab Emirates' => 'uae','Algeria'=>'xdz','Albania'=>'xal','Angola'=>'xao','Argentina'=>'xar','Armenia'=>'xam','Australia'=>'xau','Austria'=>'xat','Azerbaijan'=>'xaz','Bahrain'=>'xbx','Bangladesh'=>'xbd','Belarus'=>'xbl','Belgium'=>'xbe','Bosnia and Herzegovina '=>'xba','Brazil'=>'xbr','Bulgaria'=>'xbg','Canada'=>'xca','Chile'=>'xcl','China'=>'xcn','Colombia'=>'xco','Costa Rica'=>'xcr','Cyprus'=>'xcy','Denmark'=>'xdk','Dominican Republic'=>'xdu','Eritrea'=>'xer','Ethiopia'=>'xet','France'=>'xfr','Ghana'=>'xgh','Greece'=>'xgr','Grenada'=>'xgd','Guinea'=>'xgn','Hungary'=>'xhu','India'=>'xin','Indonasia'=>'xid','Ireland'=>'xie','Italy'=>'xit','Kazakhstan'=>'xkz','Kuwait'=>'xkw','Kyrgyzstan'=>'xkg','Lebanon'=>'xlb','Libya'=>'xly','Luxembourg'=>'xlu','Malaysia'=>'xmy','Malta'=>'xmt','Mexico'=>'xmx','Montenegro'=>'xcs','Mozambique'=>'xmz','Nepal'=>'xnp','Netherlands'=>'xnl','New Zealand'=>'xnz','Norway'=>'xnw','Oman'=>'xom','Pakistan'=>'xpk','Palestine'=>'xps','Panama'=>'xpa','Peru'=>'xpe','Philippine'=>'xph','Poland'=>'xpl','Portugal'=>'xpt','Republic of Korea'=>'xkr','Republic of Liberia'=>'xlr','Rwanda'=>'xrw','Saint Kitts'=>'xkn','Saudi Arabia'=>'xsa','Senegal'=>'xsn','Serbia'=>'xsr','Seychelles'=>'xsc','Slova Republic'=>'xsk','Somalia'=>'xso','Spain'=>'xes','Sri Lanka'=>'xsl','Sudan'=>'xsd','Sweden'=>'xse','Switzerland'=>'xch','Tajikistan'=>'xtj','Tanzania'=>'xtz','Thailand'=>'xth','Tunisia'=>'xtn','Turkey'=>'xtr','Turkmenistan'=>'xtm','Uganda'=>'xug','Uzbekistan'=>'xuz','Venezuela'=>'xve','Vietnam'=>'xvn'};
            countryOptions.add(new SelectOption('','--None--'));
        for (String s : mapCC.keySet()){
            if (srv.uid__c=='200' && (s.equalsIgnoreCase('switzerland') || s.equalsIgnoreCase('austria'))){continue;}
            countryOptions.add(new SelectOption(mapCC.get(s),s));
        }
        return countryOptions;
    }
    public List < SelectOption > getVfsCountriesOptions() { List < SelectOption > countryOptions = new List < SelectOption > (); Map < String, String > mapCC = new Map < String, String > { 'United Arab Emirates' => 'uae', 'Armenia' => 'xam', 'Australia' => 'xau', 'Austria' => 'xat', 'Azerbaijan' => 'xaz', 'Bahrain' => 'xbx', 'Bangladesh' => 'xbd', 'Belarus' => 'xbl', 'Belgium' => 'xbe', 'Bosnia and Herzegovina ' => 'xba', 'Brazil' => 'xbr', 'Canada' => 'xca', 'Czech Republic' => 'czp', 'Colombia' => 'xco', 'Cyprus' => 'xcy', 'Denmark' => 'xdk', 'Egypt ' => 'ept', 'Estonia ' => 'xst', 'France' => 'xfr', 'Greece' => 'xgr', 'Georgia' => 'gia', 'Germany' => 'gmn', 'Hungary' => 'xhu', 'Hong Kong' => 'hk', 'India' => 'xin', 'Indonesia' => 'ida', 'Ireland' => 'xie', 'Italy' => 'xit', 'Japan' => 'jpn', 'Jordan' => 'jrn', 'Kuwait' => 'xkw', 'Kyrgyzstan' => 'xkg', 'Kenya' => 'kya', 'Latvia' => 'xlv', 'Lebanon' => 'xlb', 'Luxembourg' => 'xlu', 'Malaysia' => 'xmy', 'Mauritius' => 'mts', 'Morocco' => 'mro', 'Monacco' => 'xmn', 'Netherlands' => 'xnl', 'New Zealand' => 'xnz', 'Norway' => 'xnw', 'Nigeria' => 'nga', 'Oman' => 'xom', 'Pakistan' => 'xpk', 'Philippines' => 'xph', 'Poland' => 'xpl', 'Portugal' => 'xpt', 'Qatar' => 'qtr', 'Romania' => 'rma', 'Saudi Arabia' => 'xsa', 'Seychelles' => 'xsc', 'Spain' => 'xes', 'Sri Lanka' => 'xsl', 'Sweden' => 'xse', 'Switzerland' => 'xch', 'Singapore' => 'Sge', 'Slovakia' => 'Ska', 'South Africa' => 'Saa', 'South Korea' => 'Ska', 'Tunisia' => 'xtn', 'Turkey' => 'xtr', 'Uzbekistan' => 'xuz', 'United Kingdom' => 'xuk', 'United States of America' => 'usa', 'Venezuela' => 'xve', 'Vietnam' => 'xvn', 'Zimbabwe' => 'Zmb' }; countryOptions.add(new SelectOption('', '--None--')); for (String s: mapCC.keySet()) { if (srv.uid__c == '200' && (s.equalsIgnoreCase('switzerland') || s.equalsIgnoreCase('austria'))) { continue; } countryOptions.add(new SelectOption(mapCC.get(s), s)); } return countryOptions; }
    //code for grqvfs page
    public List<String> getAllCountries(){
        List<SelectOption> options = new List<SelectOption>();
        options = getOptions('xcbc__c'); //country of birth picklist
        system.debug('returned options '+ options);
        List<string> allCountriesList = new List<string>();
        for (SelectOption op : options){
            allCountriesList.add(op.getValue());
            system.debug('COUNTRIES '+ allCountriesList);
        }
        system.debug('show all countries list' + allCountriesList);
        return allCountriesList;
    }

    public String existingMemDetail {get;set;}
    public DDAMembersWrapper membersList {get;set;}
    public List<mdWrapper> mdList {get;set;}
    public List<mdWrapper.IdentityInfo> infoList {get;set;}
    public PageReference fetchMemberDetails(){ if (!(Test.isRunningTest())){ String jsonStr = '{"methodname":"membersupdate", "data":{"licenseNum":"'+Acc .lc__c+'"}}'; String responseBody = DDAServices.getDDAServices(Label.LA_DDA_End_Point,'onbordingapi','POST',jsonStr); existingMemDetail = responseBody; infoList = new List<mdWrapper.IdentityInfo>(); mdList = (List<mdWrapper>)System.JSON.deserialize(responseBody,List<mdWrapper>.class); mdList[0].DirectersIdentityInfo = new List<mdWrapper.IdentityInfo>(); mdList[0].MembersIdentityInfo = new List<mdWrapper.IdentityInfo>(); for (mdWrapper.IdentityInfo info : mdList[0].IdentityInfo){ if (info != null && info.role == 'Director'){ mdList[0].DirectersIdentityInfo.add(info); }else if (info != null){ mdList[0].MembersIdentityInfo.add(info); } } } return null; }
    public string membersListStr {get;set;}
    public boolean isActivity {get;set;}
    public boolean isSegment {get;set;}
    public boolean isRemoveActivity{get;set;}
    public String activityJson{get;set;}
    public String activity {get;set;}
    public transient List<SegmentsActivitiesController.SegWrapper> allSegandAct {get;set;}
    public Map<String, List<String>> existingSegandActMap {get; set;}
    public Map<String, Integer> existingSegandActCountMap {get; set;}
    public String LabelName {get; set;}
    public List<String> segmentList {get;set;}
    public List<String> newSegmentList {get;set;}
    public List<String> removeActivityList {get;set;}
    public List<String> finalSegmentList {get;set;}
    Public Map<string, DDAMembersWrapper.LicensedActivities> actvityWithTitleList{get;set;}
    Public Map<string, DDAMembersWrapper.ChannelTitles> actvityWithChannelTitleList{get;set;}
    Public List<string> actvityWithChannelList{get;set;}
    public boolean isTitle {get;set;}
    public boolean isRemoveTitle {get;set;}
    public boolean isRemoveChannel {get; set;}
    public boolean isChannel {get;set;}
    public Map<String,string> segmentMap {get;set;}
    public Map<String, String> newSegMap {get;set;}
    public Map<String, Integer> activityCountMap {get;set;}
    public transient Map<String, List<SegmentsActivitiesController.ActWrapper>> activityMap {get; set;}
    public Map<String, List<SegmentsActivitiesController.ActWrapper>> newSegmentMap {get;set;}
    public transient Map<String, SegmentsActivitiesController.SegWrapper> segMap {get; set;}
    public transient Map<String, Integer> selectedCount {get; set;}
    public string channelReq {get; set;}
    public transient Map<String, string> activityMap1 {get; set;}
    public Map<String, SegmentsActivitiesController.SegWrapper> segMap1 {get; set;}
    public boolean isAmdReq{get;set;}
    public boolean noTitleChannels{get;set;}
    public string existingRequestNumber{get;set;}
    public string allLglFrwrk{get;set;}
    public string ammendVal{get; set;}
    public PageReference fetchAllDDAMembers() {
        system.debug('==license==' + Acc.lc__c);
        //if (!(Test.isRunningTest())) {
        String jsonStr = '{ "licenseNos": [ "' + Acc.lc__c + '" ] }';
        String responseBody = DDAServices.getDDAServices(Label.LA_DDA_End_Point, 'licenseAmendment/getLicenseInfo', 'POST', jsonStr);
        existingMemDetail = responseBody;
        DDAMembersWrapper ref = (DDAMembersWrapper) System.JSON.deserialize(responseBody, DDAMembersWrapper.class);
        system.debug('==ref==' + ref);
        membersList = new DDAMembersWrapper();
        membersList = ref;
        membersList.drWrp = new List < DDAMembersWrapper.Members > ();
        membersList.nonDrWrp = new List < DDAMembersWrapper.Members > ();
        for (DDAMembersWrapper.Members m: ref.LicenseInfos[0].Members) {
            system.debug('m--- ' + m);
            system.debug('m.positions--- ' + m.positions);
            if (m.positions.contains('Director')) {
                membersList.drWrp.add(m);
                system.debug('membersList.drWrp--- ' + membersList.drWrp);
            } else membersList.nonDrWrp.add(m);
        }
        system.debug('==membersList==' + membersList);
        membersListStr = JSON.serialize(membersList);
        membersListStr = membersListStr.replaceAll('\'', '');
        noTitleChannels=false;
        isAmdReq=false;
        isTitle=false;
        isChannel = false;
        activityJson = '';
        existingRequestNumber='';
        isRemoveChannel = false;
        isRemoveTitle = false;
        if (string.isNotBlank(req.xcddocs__c)){
            xcddocs = req.xcddocs__c;
        }

        ammendVal = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('ammendmentValue'));
        if (ammendVal == 'Add Activity') {
            isActivity = true;
            isSegment = false;
        } else if (ammendVal == 'Add Segment') {
            isActivity = false;
            isSegment = true;
        } else if (ammendVal == 'Remove Activity') {
            isActivity = isSegment=false;
            isRemoveActivity = true;
            activityCountMap = new Map<String, Integer>();
        } else if (ammendVal == 'Remove Segment') {
            //isActivity =
            isSegment=true;
            activityCountMap = new Map<String, Integer>();
        }
        system.debug('==license=='+Acc .lc__c);
        if (!string.isblank(ref.LicenseInfos[0].ActivityAmendmentRequestAXSRefNo)){
            isAmdReq=true;
            existingRequestNumber=ref.LicenseInfos[0].ActivityAmendmentRequestAXSRefNo;
            system.debug('--isAmdReq--'+isAmdReq);
        }
        system.debug('==ref=='+ref);
        existingSegandActMap = new Map<String, List<String>>();
        existingSegandActCountMap = new Map<String, Integer>();
        LabelName = '';
        channelReq = '';
        segmentList = new List<String>();
        newSegmentList = new List<String>();
        removeActivityList=new List<String>();
        finalSegmentList = new List<String>();
        segmentMap = new Map<String, string>();
        newSegMap = new Map<String, String>();
        actvityWithTitleList= new Map<String,DDAMembersWrapper.LicensedActivities>();
        actvityWithChannelList=new List<String>();
        actvityWithChannelTitleList = new Map<string, DDAMembersWrapper.ChannelTitles>();
        Map<String, List<String>> existingActMap = new Map<String, List<String>>();
        selectedCount = new Map<String, Integer>();
        integer i =1;
        activityCountMap = new Map<String, Integer>();
        for (DDAMembersWrapper.LicensedActivities l : ref.LicenseInfos[0].licensedActivities){
            system.debug(l.channelTitles);
            if (!selectedCount.containsKey(l.activityName)) {
                selectedCount.put(l.activityName, 0);
            }
            system.debug('--ammendVal--'+ammendVal);
            if (l.isRelatedtoTitles && (ammendVal=='Adding New Publishing title' || ammendVal=='Remove Publishing title')) {
                actvityWithTitleList.put(l.activityName,l);
                isTitle=true;
                isChannel = false;
                if (ammendVal=='Remove Publishing title') {
                    isRemoveTitle=true;
                }
                LabelName = 'Title Name';
                if (String.isNotBlank(req.xadtx3__c) && req.xadtx3__c.contains(l.activityDdaId)) {
                    selectedCount.put(l.activityName, selectedCount.get(l.activityName)+1);
                    system.debug('---selectedCount---'+selectedCount);
                }
                if (!activityCountMap.containsKey(l.activityName)) activityCountMap.put(l.activityName,0);


                if (!existingSegandActMap.containsKey(l.activityName)){
                    segmentMap.put(l.activityName, string.valueOf(i));
                    i++;
                    existingSegandActMap.put(l.activityName, new List<String>());
                }
                system.debug(l.channelTitles);
                for (DDAMembersWrapper.ChannelTitles c : l.channelTitles) {
                    existingSegandActMap.get(l.activityName).add(c.name);
                    actvityWithChannelTitleList.put(c.name, c);
                    activityCountMap.put(l.activityName,activityCountMap.get(l.activityName)+1);
                }
                system.debug('--actvityWithTitleList---'+actvityWithTitleList.size());
                system.debug('--isTitle---'+isTitle);
            }  else if (l.isRelatedtoChannel &&  ammendVal=='Adding New Broadcasting Channels'){
                actvityWithTitleList.put(l.activityName,l);
                system.debug('--actvityWithTitleList--'+actvityWithTitleList);
                isChannel=true;
                LabelName = 'Channel Name';

                if (!existingSegandActMap.containsKey(l.activityName)){
                    segmentMap.put(l.activityName, string.valueOf(i));
                    i++;
                    existingSegandActMap.put(l.activityName, new List<String>());
                }
                for (DDAMembersWrapper.ChannelTitles c : l.channelTitles) {
                    existingSegandActMap.get(l.activityName).add(c.name);
                    actvityWithChannelTitleList.put(c.name, c);
                    if (String.isNotBlank(req.xadtx3__c) && req.xadtx3__c.contains(c.licensedTitleChannelDdaId)) {
                        selectedCount.put(l.activityName, selectedCount.get(l.activityName)+1);
                        system.debug('---selectedCount---'+selectedCount);
                    }
                }
            } else if (l.isRelatedtoChannel && ammendVal=='Remove Broadcasting Channels') {
                LabelName = 'Channel Name';
                system.debug(l.activityName);
                actvityWithTitleList.put(l.activityName, l);

                if (!activityCountMap.containsKey(l.activityName)) activityCountMap.put(l.activityName,0);

                if (!existingSegandActMap.containsKey(l.activityName)){
                    segmentMap.put(l.activityName, string.valueOf(i));
                    i++;
                    existingSegandActMap.put(l.activityName, new List<String>());
                }
                system.debug(l.channelTitles);
                for (DDAMembersWrapper.ChannelTitles c : l.channelTitles) {
                    existingSegandActMap.get(l.activityName).add(c.name);
                    actvityWithChannelTitleList.put(c.name, c);
                    activityCountMap.put(l.activityName,activityCountMap.get(l.activityName)+1);
                    if (String.isNotBlank(req.xadtx3__c) && req.xadtx3__c.contains(c.licensedTitleChannelDdaId)) {
                        selectedCount.put(l.activityName, selectedCount.get(l.activityName)+1);
                        system.debug('---selectedCount---'+selectedCount);
                    }
                }
                isRemoveChannel=true;
            }
        }
        channelReq = Json.serialize(actvityWithTitleList);
        system.debug('--actvityWithTitleList---'+actvityWithTitleList);
        if (actvityWithTitleList.size()==0){
            noTitleChannels=true;
        }
        activityMap = new Map<String, List<SegmentsActivitiesController.ActWrapper>>();
        activityMap1 = new Map<String, String>();
        segMap = new Map<String, SegmentsActivitiesController.SegWrapper>();
        for (DDAMembersWrapper.LicensedActivities l : ref.LicenseInfos[0].licensedActivities){
            if (ammendVal !='Adding New Publishing title' && ammendVal !='Adding New Broadcasting Channels'&&
               ammendVal !='Remove Publishing title' && ammendVal !='Remove Broadcasting Channels') {
                   if (!existingSegandActMap.containsKey(l.segmentName)){
                       segmentMap.put(l.segmentName, string.valueOf(i));
                       i++;
                       if (ammendVal == 'Add Activity' || ammendVal == 'Add Segment' || ammendVal == 'Remove Activity' || ammendVal == 'Remove Segment') {
                           segmentList.add(l.segmentName);
                           if (ammendVal != 'Add Segment') {
                               activityMap1.put(l.segmentName, ''); //Added
                               selectedCount.put(l.segmentName, 0); //Added
                               activityCountMap.put(l.segmentName, 0); //Added
                               segMap.put(l.segmentName, new SegmentsActivitiesController.SegWrapper()); //Added
                           }
                           if (ammendVal == 'Remove Activity' || ammendVal == 'Remove Segment') {
                               activityMap.put(l.segmentName, new List<SegmentsActivitiesController.ActWrapper>());
                           }

                           system.debug('--segmentList--'+segmentList);
                       }
                       existingActMap.put(l.segmentName, new List<String>());
                       existingSegandActMap.put(l.segmentName, new List<String>());
                   }
                   existingSegandActMap.get(l.segmentName).add(l.activityName);
                   existingActMap.get(l.segmentName).add(l.activityDdaId);
                   removeActivityList.addAll(existingActMap.get(l.segmentName));
                   system.debug('---removeActivityList---'+removeActivityList);
                   if ((ammendVal == 'Remove Activity' || ammendVal == 'Remove Segment') && existingSegandActMap.containsKey(l.SegmentName)) {
                       SegmentsActivitiesController.ActWrapper s = new SegmentsActivitiesController.ActWrapper();
                       s.label = l.activityName;
                       s.Name = l.activityName;
                       s.activityId = l.activityDdaId;
                       s.isRelatedtoTitles = l.isRelatedtoTitles;
                       s.isRelatedtoChannel = l.isRelatedtoChannel;
                       activityMap.get(l.segmentName).add(s);

                       if (String.isNotBlank(req.xadtx3__c) && req.xadtx3__c.contains(s.activityId)) {
                           selectedCount.put(l.segmentName, selectedCount.get(l.segmentName)+1);
                       }
                       if (existingActMap.get(l.segmentName).contains(l.activityDdaId)){
                           system.debug('---Inside 4--');
                           if (!activityCountMap.containsKey(l.segmentName)) activityCountMap.put(l.segmentName,0);
                           activityCountMap.put(l.segmentName,activityCountMap.get(l.segmentName)+1);
                       }
                   }
               }
        }

        for (String s : existingSegandActMap.keySet()) {
            existingSegandActCountMap.put(s, existingSegandActMap.get(s).size());
        }

        String jsonBody='{"methodname": "segmentinformation", "data": [{"LegalFramework": "'+framwrk+'","businessUnit": "'+acc.prk__c+'"}]}';
        String responseBody1 = DDAServices.getDDAServices('DCCA_Auth','onbordingapi','POST',jsonBody);
        system.debug('---responseBody--'+responseBody1);
        newSegmentMap = new Map<String, List<SegmentsActivitiesController.ActWrapper>>();

        allSegandAct = (List<SegmentsActivitiesController.SegWrapper>)JSON.deserialize(responseBody1, List<SegmentsActivitiesController.SegWrapper>.class);
        system.debug('---allSegandAct--'+allSegandAct);
        Integer j = 1000;

        for (SegmentsActivitiesController.SegWrapper segAct:allSegandAct){
            system.debug('---Inside 1--'+segAct);
            system.debug(segAct.Segment);
            segMap.put(segAct.Segment, segAct);
            selectedCount.put(segAct.Segment, 0);
            for (SegmentsActivitiesController.ActWrapper wrap : segAct.Activities){
                if ((ammendVal == 'Add Activity') && existingSegandActMap.containsKey(segAct.Segment)){ // Existing Activities
                    system.debug('---activityMap---'+activityMap);
                    if (String.isNotBlank(req.xadtx3__c) && req.xadtx3__c.contains(wrap.activityId)) {
                        selectedCount.put(segAct.Segment, selectedCount.get(segAct.Segment)+1);
                        system.debug('---selectedCount---'+selectedCount);
                    }
                    if (!activityMap.containsKey(segAct.Segment)) activityMap.put(segAct.Segment, new List<SegmentsActivitiesController.ActWrapper>());
                    activityMap1.put(segAct.Segment, '');
                    if (!existingActMap.get(segAct.Segment).contains(wrap.activityId)){
                        system.debug('---Inside 4--');
                        activityMap.get(segAct.Segment).add(wrap);
                        system.debug('---activityMap---'+activityMap);
                    }
                } else if (ammendVal == 'Add Segment') {
                    if (String.isNotBlank(req.xadtx3__c) && req.xadtx3__c.contains(wrap.activityId)) {
                        selectedCount.put(segAct.Segment, selectedCount.get(segAct.Segment)+1);
                    }
                    if (!newSegmentList.contains(segAct.Segment) && !existingActMap.containsKey(segAct.Segment)) {
                        newSegmentList.add(segAct.Segment);
                        segmentMap.put(segAct.Segment, string.valueOf(j));
                        j++;
                    }
                    if (!activityMap.containsKey(segAct.Segment)) activityMap.put(segAct.Segment, new List<SegmentsActivitiesController.ActWrapper>());
                    activityMap.get(segAct.Segment).add(wrap);
                } else if ((ammendVal == 'Remove Activity' || ammendVal == 'Remove Segment') && existingSegandActMap.containsKey(segAct.Segment)){

                }
            }
        }
        if (ammendVal == 'Add Activity') {
            finalSegmentList = new List<String>(activityMap.keySet());
        }
        if (ammendVal == 'Add Segment') finalSegmentList = newSegmentList;
        if (ammendVal == 'Remove Activity') {
            finalSegmentList = new List<String>(activityMap.keySet()); //segmentList;//removeActivityList;
        }
        if (ammendVal == 'Remove Segment') {
            isSegment = true;
            finalSegmentList = new List<String>(activityMap.keySet()); //segmentList;
            system.debug('--finalSegmentList--'+finalSegmentList);
            activityJson = JSON.serialize(activityMap);
            system.debug(activityJson);
            for (String s : activityMap.keySet()) {
                Map<String, String> strMap = new Map<String, String>();
                string sr = '';
                for (SegmentsActivitiesController.ActWrapper w : activityMap.get(s)) {
                    sr += w.name+'-SPACE-'+w.activityId+':::';
                }
                activityMap1.put(s, sr);
            }
        } else {
            isSegment = false;
            for (string s : activityMap.keySet()) {
                Integer x = activityMap.get(s).size();
                activityMap1.put(s, String.valueOf(x));
            }
        }
        //}

        return null;
    }
    public PageReference fetchCalculationFees(){
        List<string> docList = new List<string>();
        List<g_reqDoc__c> tobeDeletedDocs = new List<g_reqDoc__c>();
        xcddocs='';
        system.debug(String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('jsonVal')));
        system.debug('==license=='+Acc .lc__c+'---'+enteredText1);
        //string dummyJsonstr='{"serviceRequests":[{"serviceId":"a15F700000OoYx5IAF","licenseNo":"30006","activities":[{"name":"Re-Printing","ddaId":"a12D0000001ZM4oIAG","actionType":"ADD","channelTitles":null,"noOfTitleAndChannels":null}],"members":[],"locations":null,"companyInfo":null,"isPaid":null}]}';
        String jsonStr =  String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('jsonVal')); //'{ "licenseNos": [ "'+Acc .lc__c+'" ] }';
        system.debug('====jsonStr===='+jsonStr);
        String responseBody = DDAServices.getDDAServices(Label.LA_DDA_End_Point,'licenseAmendment/serviceCalculateFees','POST',jsonStr);
        adhc4Resp=responseBody;
        system.debug('----responseBody---'+adhc4Resp);
        existingMemDetail = responseBody;
        //feeMap = new Map<string, Integer>();
        system.debug('---responseBody---'+responseBody);
        DccaBatchUtil.LAResponseWrapper ref = (DccaBatchUtil.LAResponseWrapper)System.JSON.deserialize(responseBody,DccaBatchUtil.LAResponseWrapper.class);
        system.debug('--ref--'+ref);
        /*if (ref.srList[0].SrFees!=null){
for (DccaBatchUtil.SrFees objFee:ref.srList[0].SrFees){
if (!feeMap.containsKey(objFee.axsServItemName)){
feeMap.put(objFee.axsServItemName,objFee.amount);
}  else {
feeMap.put(objFee.axsServItemName, feeMap.get(objFee.axsServItemName) + objFee.amount);
}
}
}*/
        //system.debug(feeMap);
        //obj = (Map<String,Object>)System.JSON.deserializeUntyped(responseBody);
        //system.debug('---obj---'+obj);
        if (ref.srList[0].totalAmount!=null && ref.srList[0].totalAmount>0){
            amountTobePaid = ref.srList[0].totalAmount;
        } else {
            amountTobePaid = 0;
        }
        system.debug('---amountTobePaid---'+amountTobePaid);
        //DccaBatchUtil.srList ref1= (DccaBatchUtil.srList)System.JSON.deserialize(responseBody,DccaBatchUtil.srList.class);
        system.debug('==ref=='+ref);
        system.debug('--Attachments--'+ref.srList[0].srAttachments);
        /*US APD3911*/if (ref.srList[0].srAttachments == null || ref.srList[0].srAttachments.isEmpty()){xcddocs = '';system.debug('--xcddocs--11' + xcddocs);}/*US APD3911*/
        if (ref.srList[0].srAttachments!=null){
            for (DccaBatchUtil.SrAttachments objStr: ref.srList[0].srAttachments){
                if (!string.isblank(objStr.name)){
                    docList.add(objStr.name);
                    system.debug('--docList--'+docList);
                    if (docList!=null && docList.size()>0)xcddocs= string.join(docList,';');
                    system.debug('--xcddocs--'+xcddocs);
                }
                else {
                    xcddocs='';
                }

            }
            if (req.id!=null){
                system.debug('---req----'+req);
                List<g_reqitem__c> rItmList=new List<g_reqitem__c>([select id,scn__c from g_reqitem__c where itm__r.cd__c not in('dsr','ddd','kf','inf') and rq__c=:req.id limit 1]);
                DccaBatchUtil.LAResponseWrapper res = (DccaBatchUtil.LAResponseWrapper)System.JSON.deserialize(req.xadtx4__c,DccaBatchUtil.LAResponseWrapper.class);
                rItmList[0].scn__c=amountTobePaid;
                update rItmList[0];
                if (req.xcamc__c.startswith('Add')){//docList
                    map<string,g_reqDoc__c> docsMap=new map<string,g_reqDoc__c>();
                    for (g_reqDoc__c objDoc:[select id,name,lbl__c from g_reqDoc__c where RQ__c=:req.id and   Req__c=true]){
                        system.debug('---docList---'+docList);
                        if (!docList.contains(objDoc.lbl__c)){
                            docsMap.put(objDoc.lbl__c,objDoc);
                            system.debug('---docsMap---'+docsMap);
                        }
                        if (String.isBlank(req.xcddocs__c) && !objDoc.name.contains('Director')){
                            tobeDeletedDocs.add(objDoc);
                        }
                    }
                    system.debug('---tobeDeletedDocs---'+tobeDeletedDocs);
                    if (!String.isBlank(req.xcddocs__c) && docsMap!=null && docsMap.size()>0)tobeDeletedDocs.addAll(docsMap.values());
                    if (tobeDeletedDocs!=null && tobeDeletedDocs.size()>0)delete tobeDeletedDocs;
                }
                if (req.xcamc__c=='Remove Segment'){
                    List<g_reqDoc__c> reqList=[select id,(select id from Attachments) from g_reqDoc__c where name ='Director(s) Resolution' and rq__c=:req.id limit 1];
                    system.debug('==reqList=='+reqList);
                    if (reqList[0].Attachments!=null && reqList[0].Attachments.size()>0){
                        delete reqList[0].Attachments;
                    }
                }
            }
        }
        return null;
    }
    public string enteredText1 {get; set;}
    public decimal amountTobePaid{get;set;}
    public string xcddocs{get;set;}
    public string adhc4Resp{get;set;}
    public void callLAWS(){upsert req;grqWsOnboard.LAWSCallCreation(req.id);}
    public PageReference createRQDoc(String docName) {
        //rq.xcddocs__c = docName;
        update req;
        return null;
    }

   /*US APD3911 Start*/
    public void deleteMemResolDoc(){
       /* List<g_reqDoc__c> membDoc = [Select id from g_reqDoc__c where Name ='Member(s) Resolution' and RQ__c =: req.id];
        if (membDoc!=null && membDoc.size()>0) membRes=[select id, name from Attachment where parentId=:membDoc[0].id ];
        if (membRes!=null && membRes.size()>0)delete membRes;*/
    }
    public void deleteDirResolDoc(){
       //List<g_reqDoc__c> membDireDoc = [Select id from g_reqDoc__c where Name ='Director(s) Resolution' and RQ__c =: req.id];
        //if (membDireDoc!=null && membDireDoc.size()>0)dirRes=[select id, name from Attachment where parentId=:membDireDoc[0].id ];
        //if (dirRes!=null && dirRes.size()>0)delete dirRes;
    }
    /*US APD3911 End*/
    public PageReference deleteRQDoc() { string docName = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('docName')); system.debug('docName deleteRQDoc --- '+docName); List<String> lstDocs = new List<String>(); if (docName.contains(';')){ lstDocs=docName.split(';'); }else{ lstDocs.add(docName); } system.debug('lstDocs -- '+lstDocs); List<g_reqDoc__c> lstdoc = [Select id from g_reqDoc__c where Name IN : lstDocs and RQ__c =: req.id]; system.debug('xcddocs__c --- '+lstdoc); update req; system.debug('xcddocs__c --- '+req.xcddocs__c); system.debug('lstdoc deleteRQDoc --- '+lstdoc); if (lstdoc!=null && lstdoc.size()>0)delete lstdoc; return null; }
    public String getReqDocId(String reqid, String attName) {
        attName = (attName.remove(';')).trim().toLowercase();
        system.debug('attName >>' + attName);
        List < g_reqDoc__c > rdocList = [select id, name, lbl__c from g_reqDoc__c where rq__c =: reqid];
        Map < String, String > dIdNamMap = new Map < String, String > ();
        for (g_reqDoc__c r: rdocList) {
            if (String.isNotBlank(r.lbl__c)) dIdNamMap.put((r.lbl__c).trim().toLowercase(), r.id);
            else dIdNamMap.put((r.name).trim().toLowercase(), r.id);
        }
        system.debug('dIdNamMap >>' + dIdNamMap);
        return dIdNamMap.get(attName);
    }
    public void deleteAttachment() {
        String reqDocId = String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('docName'));
        try {
            Attachment A = new Attachment(Id = reqDocId);
            delete A;
        } catch (Exception e) {
            gU.AddErrorMsg(e);
        }
    }


    // SECURITY: Prevent open redirect (CWE-601)
    private static String sanitizeRedirectUrl(String url) {
        if (String.isBlank(url)) return '/';
        // Block external redirects
        if (url.contains('://') || url.startsWith('//')) return '/';
        // Ensure relative URL
        if (!url.startsWith('/')) url = '/' + url;
        return url;
    }

}