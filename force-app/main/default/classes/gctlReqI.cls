public with sharing class gctlReqI{//stg
    public String empid{get;set;}
    public String encid{get;set;}
    public String sid{get;set;}
    public String pid{get;set;}
    public Boolean isgu{get;set;}
    public String ItemId {get; set;}
    public String AWBnumber {get; set;}
    public String msg {get; set;}
    public String stage {get; set;}
    public String itmcd {get; set;}
    public String cstatus {get; set;}
    public String ctmstp {get; set;}

    public g_Req__c rq{get;set;}
    private String m_SOQL;
    public String pt{get;set;}
    public String pDsc{get;set;}
    public Boolean pgHide{get;set;}
    public Boolean ispu{get;set;}
    public string lcl{get{return UserInfo.getLocale();}}
    public list<itm> Is{get;set;}
    public List<SelectOption>optSTA{get;set;}/*for security SF check the value of pickList is within initial list of options. for these shit we have to load the options initially*/
    public list<g_srvcitm_Status__c> STAs{get;set;}
    public list<xF> xFs{
        get{
            list<xF> fs = new list<xF>();
            map<String, Schema.SObjectField> mf=g_reqitem__c.sObjectType.getDescribe().fields.getMap();
            for (String fName:mf.keySet()) {
                if (fName.startsWithIgnoreCase('x')&&m_SOQL.containsIgnoreCase(fName)) {
                    fs.add(new xF(fName, mf.get(fName).getDescribe().isUpdateable()));
                }
            }
            return fs;
        }
    }
    //*** ------- Initialization --------------------------------------------------------------------------------
    public gctlReqI(ApexPages.StandardController c) {rq=(g_Req__c)c.getRecord();
                                                    pgHide=false;ispu=gU.isPortalUser(UserInfo.getProfileId()); isgu = gu.isGuestUser(userInfo.getProfileId());init();}
    private void init() {try{laodData();Validate();}catch (exception ex) { if (ispu) { gu.AddErrorMsg(Label.msgException+'1'); } else{ gu.AddErrorMsg(ex); } } }
    public pagereference authenticateUser() {
        empid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('empid'));
        encid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('enc'));
        pagereference pg=null;
        if (gu.isGuestUser(userInfo.getProfileId())) {
            if ((empid == '' || empid == null || encid == '' || encid == null   || !DEG_Checksum(empid, encid))) {
                pg = new pagereference('/apex/AccesDeniedPage');
            }
        }
        else{
            return null;
        }
        return pg;
    }
    private void laodData() {
    empid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('empid'));
    encid = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('enc'));
    sid = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('sid'));
    pid = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('pid'));
    isgu = gu.isGuestUser(userInfo.getProfileId());
    Is = new list < itm > ();
    if (isgu) {
        rq = (g_Req__c) Database.query('Select xadtx4__c, Con__c , Id, Name, Acc__c, srvc__c, srvc__r.lbl__c, Duration__c, STA__c, AT__c, AP__c, AOP__c, xmv__c , xosa__c , xltr__c, xfsr__c, dsc__c, dsc__r.prct__c, spCh__c, rmob__c, xaloc__c, xbrnd__c, xbn__c, nt__c, srvc__r.uid__c, nc__c, srvc__r.stg__r.itmq__c, srvc__r.stg__r.json__c, Acc__r.Name, Acc__r.lc__c, Acc__r.lcsnc__c, Acc__r.lcsncnt__c, Acc__r.psasnc__c, Acc__r.psasncnt__c, Acc__r.ecsnc__c, Acc__r.ecsncnt__c, Acc__r.cosnc__c, Acc__r.cosncnt__c, Acc__r.bgsnc__c, Acc__r.bgsncnt__c, Acc__r.snc__c, Acc__r.info__c, Con__r.id__c, xcjb__r.Name, Con__r.idtxt__c, Con__r.Proc__c, Con__r.emrt__c, Con__r.cty__c, Con__r.area__c, Con__r.pid__c, Con__r.ped__c, Con__r.pip__c , Con__r.p__c , Con__r.fnar__c, Con__r.mnar__c, Con__r.lnar__c, Con__r.bp__c, Con__r.bc__c , Con__r.fan__c, Con__r.mon__c, Con__r.ms__c, Con__r.MobilePhone, Con__r.Email, Con__r.strt__c, Con__r.pobx__c, Con__r.pobxarea__c, Con__r.acctp__c, Con__r.HomePhone, Con__r.ha__c, Con__r.eidid__c, Con__r.eidedt__c, Con__r.eididt__c , Con__r.ql__c, Con__r.fs__c, Con__r.of__c, Con__r.pic__c, Con__r.ot__c, Con__r.ma__c, Con__r.mbs__c, Con__r.moa__c, Con__r.mta__c, Con__r.rp__c, Con__r.rpid__c, Con__r.rped__c, Con__r.Salutation, Con__r.FirstName, Con__r.mn__c, Con__r.LastName, Con__r.nc__c, Con__r.rpui__c, Con__r.Birthdate, Con__r.jb__r.Name, LastModifiedDate, LastModifiedById, CreatedDate, CreatedById, xeidav__c, xcma__c, xcacctp__c, xcha__c, xcarea__c, xcmbs__c, xcbd__c, xccty__c, xcbc__c, xcnc__c, xceidid__c, xceidedt__c, xceididt__c, xceml__c, xcemrt__c, xcfan__c, xcfs__c, xcfn__c, xcfnar__c, xchph__c, xcln__c, xclnar__c, xcms__c, xcmn__c, xcmnar__c, xcmob__c, xcmon__c, xcof__c, xcot__c, xcjb__c, xcmoa__c, xcp__c, xcped__c, xcpid__c, xcpic__c, xcpip__c, xcbp__c, xcpobx__c, xcpobxarea__c, xcnp__c, xcql__c, xcrlg__c, xcslt__c, xclng__c, xcstrt__c, xcmta__c, (Select Id, Name From reqMbrs__r where isDeleted=false), (Select Id, or__c, reqOr__c, upOk__c From rDocs__r where Req__c=true and IsDeleted=false), (Select Id, Name, STA__c, A__c, md__c, TP__c From Transactions__r where isDeleted=false), (select id, Name, RQ__c, nc__c, m__c, m__r.Name, vSTA__c, rv__c , AP__c, AD__c, AOP__c, nt__c, xprnt__c, xr__c, Dsc__c, DscApp__c, KF__c, cN__c, scN__c, smN__c, exp__c, cXP__c, scXP__c, smXP__c, itm__c, itm__r.xf__c, itm__r.cd__c, itm__r.Name, itm__r.lbl__c, itm__r.Tp__c, itm__r.Req__c, itm__r.exp__c, itm__r.prcEdt__c, itm__r.dSTA__c, sta__c, sta__r.cd__c, sta__r.Name, sta__r.lbl__c, sta__r.Tp__c, sta__r.rc__c, sta__r.noEXP__c, sta__r.Courier_Stage__c, sta__r.Shift_At__c, sta__r.Shift_Items__c, LastModifiedDate, LastModifiedById, CreatedDate, CreatedById, xf__c, xfid__c, xfed__c, xcf__c, xcid__c, xced__c, xmid__c, xmed__c, xlid__c, xe__c, xeid__c, xeed__c, xi__c, xiid__c, xied__c, xjd__c, xaed__c, xrp__c, xrpid__c, xrped__c, xrcd__c, xui__c, xvd__c, xvip__c, xvt__c, xan__c, xad__c, xat__c, xed__c, xaf__c, xxd__c, xprt__c, xcbd__c, xcbdo__c, xcnc__c, xcnco__c, xcfn__c, xcfno__c, xcln__c, xclno__c, xcmn__c, xcmno__c, xcjb__c, xcjbo__c, xcp__c, xcpo__c, xcslt__c, xcslto__c, xef__c , xitdur__c, xcc__c, xcawb__c, xcnopro__c , xcub__c , xcco__c , xcasc__c, xcbp__c, xcbpo__c, xcfnar__c, xclnar__c, xcmnar__c, xcmonar__c, xcpipoar__c, xcpobar__c, xcmon__c, xcpip__c , xprsal__c, xciar__c, xcsla__c, xcmbso__c, xcmbs__c, xcmao__c, xcma__c, xcmtao__c, xcmta__c, xcmoao__c, xcmoa__c, xceidido__c, xceidid__c, xceididto__c, xceididt__c, xceidedto__c, xceidedt__c, xcqlo__c, xcql__c, xcfso__c, xcfs__c, xcofo__c, xcof__c, xcoto__c, xcot__c, xcpido__c, xcpid__c, xcpedo__c, xcped__c, xcpipo__c, xcmobo__c, xcmob__c, xcemlo__c, xceml__c, xcemrto__c, xcemrt__c, xcctyo__c, xccty__c, xcstrto__c, xcstrt__c, xcareao__c, xcarea__c, xcpobxo__c, xcpic__c, xcpico__c, xcpobx__c, xcpobxareao__c, xcpobxarea__c, xcacctpo__c, xcacctp__c, xchpho__c, xchph__c, xchao__c, xcha__c, xcnotes__c, xcdocs__c From Items__r where IsDeleted=false order by sta__r.Tp__c, itm__r.ord__c) , Zone__c, Full_Name__c, CreatedBy.Name From g_Req__c where id=\'' +
            rq.Id + '\' and isDeleted = false');
        m_SOQL = 'Select Con__c , Id, Name, Acc__c, srvc__c, srvc__r.lbl__c, Duration__c, STA__c, AT__c, AP__c, AOP__c, xmv__c , xosa__c , xltr__c, xfsr__c, dsc__c, dsc__r.prct__c, spCh__c, rmob__c, xaloc__c, xbrnd__c, xbn__c, nt__c, srvc__r.uid__c, nc__c, srvc__r.stg__r.itmq__c, srvc__r.stg__r.json__c, Acc__r.Name, Acc__r.lc__c, Acc__r.lcsnc__c, Acc__r.lcsncnt__c, Acc__r.psasnc__c, Acc__r.psasncnt__c, Acc__r.ecsnc__c, Acc__r.ecsncnt__c, Acc__r.cosnc__c, Acc__r.cosncnt__c, Acc__r.bgsnc__c, Acc__r.bgsncnt__c, Acc__r.snc__c, Acc__r.info__c, Con__r.id__c, xcjb__r.Name, Con__r.idtxt__c, Con__r.Proc__c, Con__r.emrt__c, Con__r.cty__c, Con__r.area__c, Con__r.pid__c, Con__r.ped__c, Con__r.pip__c , Con__r.p__c , Con__r.fnar__c, Con__r.mnar__c, Con__r.lnar__c, Con__r.bp__c, Con__r.bc__c , Con__r.fan__c, Con__r.mon__c, Con__r.ms__c, Con__r.MobilePhone, Con__r.Email, Con__r.strt__c, Con__r.pobx__c, Con__r.pobxarea__c, Con__r.acctp__c, Con__r.HomePhone, Con__r.ha__c, Con__r.eidid__c, Con__r.eidedt__c, Con__r.eididt__c , Con__r.ql__c, Con__r.fs__c, Con__r.of__c, Con__r.pic__c, Con__r.ot__c, Con__r.ma__c, Con__r.mbs__c, Con__r.moa__c, Con__r.mta__c, Con__r.rp__c, Con__r.rpid__c, Con__r.rped__c, Con__r.Salutation, Con__r.FirstName, Con__r.mn__c, Con__r.LastName, Con__r.nc__c, Con__r.rpui__c, Con__r.Birthdate, Con__r.jb__r.Name, LastModifiedDate, LastModifiedById, CreatedDate, CreatedById, xeidav__c, xcma__c, xcacctp__c, xcha__c, xcarea__c, xcmbs__c, xcbd__c, xccty__c, xcbc__c, xcnc__c, xceidid__c, xceidedt__c, xceididt__c, xceml__c, xcemrt__c, xcfan__c, xcfs__c, xcfn__c, xcfnar__c, xchph__c, xcln__c, xclnar__c, xcms__c, xcmn__c, xcmnar__c, xcmob__c, xcmon__c, xcof__c, xcot__c, xcjb__c, xcmoa__c, xcp__c, xcped__c, xcpid__c, xcpic__c, xcpip__c, xcbp__c, xcpobx__c, xcpobxarea__c, xcnp__c, xcql__c, xcrlg__c, xcslt__c, xclng__c, xcstrt__c, xcmta__c, (Select Id, Name From reqMbrs__r where isDeleted=false), (Select Id, or__c, reqOr__c, upOk__c From rDocs__r where Req__c=true and IsDeleted=false), (Select Id, Name, STA__c, A__c, md__c, TP__c From Transactions__r where isDeleted=false), (select id, Name, RQ__c, nc__c, m__c, m__r.Name, vSTA__c, rv__c , AP__c, AD__c, AOP__c, nt__c, xprnt__c, xr__c, Dsc__c, DscApp__c, KF__c, cN__c, scN__c, smN__c, exp__c, cXP__c, scXP__c, smXP__c, itm__c, itm__r.xf__c, itm__r.cd__c, itm__r.Name, itm__r.lbl__c, itm__r.Tp__c, itm__r.Req__c, itm__r.exp__c, itm__r.prcEdt__c, itm__r.dSTA__c, sta__c, sta__r.cd__c, sta__r.Name, sta__r.lbl__c, sta__r.Tp__c, sta__r.rc__c, sta__r.noEXP__c, sta__r.Courier_Stage__c, sta__r.Shift_At__c, sta__r.Shift_Items__c, LastModifiedDate, LastModifiedById, CreatedDate, CreatedById, xf__c, xfid__c, xfed__c, xcf__c, xcid__c, xced__c, xmid__c, xmed__c, xlid__c, xe__c, xeid__c, xeed__c, xi__c, xiid__c, xied__c, xjd__c, xaed__c, xrp__c, xrpid__c, xrped__c, xrcd__c, xui__c, xvd__c, xvip__c, xvt__c, xan__c, xad__c, xat__c, xed__c, xaf__c, xxd__c, xprt__c, xcbd__c, xcbdo__c, xcnc__c, xcnco__c, xcfn__c, xcfno__c, xcln__c, xclno__c, xcmn__c, xcmno__c, xcjb__c, xcjbo__c, xcp__c, xcpo__c, xcslt__c, xcslto__c, xef__c , xitdur__c, xcc__c, xcawb__c, xcnopro__c , xcub__c , xcco__c , xcasc__c, xcbp__c, xcbpo__c, xcfnar__c, xclnar__c, xcmnar__c, xcmonar__c, xcpipoar__c, xcpobar__c, xcmon__c, xcpip__c , xprsal__c, xciar__c, xcsla__c, xcmbso__c, xcmbs__c, xcmao__c, xcma__c, xcmtao__c, xcmta__c, xcmoao__c, xcmoa__c, xceidido__c, xceidid__c, xceididto__c, xceididt__c, xceidedto__c, xceidedt__c, xcqlo__c, xcql__c, xcfso__c, xcfs__c, xcofo__c, xcof__c, xcoto__c, xcot__c, xcpido__c, xcpid__c, xcpedo__c, xcped__c, xcpipo__c, xcmobo__c, xcmob__c, xcemlo__c, xceml__c, xcemrto__c, xcemrt__c, xcctyo__c, xccty__c, xcstrto__c, xcstrt__c, xcareao__c, xcarea__c, xcpobxo__c, xcpic__c, xcpico__c, xcpobx__c, xcpobxareao__c, xcpobxarea__c, xcacctpo__c, xcacctp__c, xchpho__c, xchph__c, xchao__c, xcha__c, xcnotes__c, xcdocs__c From Items__r where IsDeleted=false order by sta__r.Tp__c, itm__r.ord__c) , Zone__c, Full_Name__c, CreatedBy.Name From g_Req';
    } else {
        if (m_SOQL == null) {
            m_SOQL = rq.srvc__r.stg__r.itmq__c;
        }
        rq = (g_Req__c) Database.query(m_SOQL + ' where id=\'' + rq.Id + '\' and isDeleted = false');
    }
    /*check Documents STA */
    map < Id, Boolean > uD = new map < Id, Boolean > ();
    map < Id, Boolean > gD = new map < Id, Boolean > ();
    for (g_reqitemDoc__c d: [select id, reqItm__c, or__c, upOk__c from g_reqitemDoc__c where reqDoc__r.RQ__c =: rq.Id and isDeleted = false and Req__c = true]) {
        if (ud.get(d.reqItm__c) == null) {
            ud.put(d.reqItm__c, true);
        }
        if (gd.get(d.reqItm__c) == null) {
            gd.put(d.reqItm__c, true);
        }
        ud.put(d.reqItm__c, ud.get(d.reqItm__c) && d.upOk__c);

        gd.put(d.reqItm__c, gd.get(d.reqItm__c) && d.or__c);
    }
        boolean loadLoc = false;
       Set<String> codeList= new Set<String>();
    /*load request items*/
    for (g_reqitem__c i: rq.Items__r) {
        codeList.add(i.itm__r.cd__c);
        Is.add(new itm(i, gD.get(i.Id) == null ? true : gD.get(i.Id), ud.get(i.Id) == null ? true : ud.get(i.Id), Is.size()));
        /*if (rq.srvc__r.uid__c == '208' && i.itm__r.cd__c == 'dr' && (rq.xpmsle__c || rq.xmloc__c) && i.sta__r.cd__c == 'lcd') {
                    loadLoc = true;
                }*/
    }

        if (rq.srvc__r.uid__c == '208' || rq.srvc__r.uid__c == '216') {
            List<String> ofcItmCdList = Label.LicItmCds.split(';');
            codeList.addAll(ofcItmCdList);
            /*codeList.add('lc');codeList.add('lc2');codeList.add('kf');codeList.add('inf');
            codeList.add('lc3');codeList.add('lc4');codeList.add('lc5');codeList.add('lc6');codeList.add('lc7');
            codeList.add('pt');codeList.add('1pt');codeList.add('2pt');
            codeList.add('amd');  codeList.add('psf');codeList.add('pa1');codeList.add('pa2');codeList.add('pa3');*/
            if (rq.srvc__r.uid__c == '216') {
                codeList.add('nl');
            }
        }

    if (rq.Items__r != null) {
        rq.Items__r.clear();
    } /*minimize view state size*/
    /*load service items*/
    if (!loadLoc) {
     List<g_srvcitm__c> sitmLst = new List<g_srvcitm__c>();
      if (rq.srvc__r.uid__c == '208' || rq.srvc__r.uid__c == '216')
          sitmLst = [Select Id, cd__c, uid__c, Name, lbl__c, Stage__c, Tp__c, xf__c, Req__c,
              rv__c, aln__c, mxcnt__c, dSTA__c, prcEdt__c, DscApp__c, EXP__c, KF__c, cN__c, scN__c,
              smN__c, spChN__c, cXP__c, scXP__c, smXP__c, spChXP__c, slaN__c, slaXP__c, ngs__c,
              ngsXP__c, vscp__c, vsc__c, vesch__c, vspc__c, vspexc__c, vst__c, vec__c, su__c, vsu__c,
              TAX_CODE__c, TAX_TYPE__c, extc__c, TAXCODE_SC__c, extcsc__c From g_srvcitm__c where actv__c = true and cd__c=:codeList and IsDeleted = false and srvc__c =: rq.srvc__c order by ord__c];
      else
         sitmLst = [Select Id, cd__c, uid__c, Name, lbl__c, Stage__c, Tp__c, xf__c, Req__c,
             rv__c, aln__c, mxcnt__c, dSTA__c, prcEdt__c, DscApp__c, EXP__c, KF__c, cN__c, scN__c,
             smN__c, spChN__c, cXP__c, scXP__c, smXP__c, spChXP__c, slaN__c, slaXP__c, ngs__c,
             ngsXP__c, vscp__c, vsc__c, vesch__c, vspc__c, vspexc__c, vst__c, vec__c, su__c, vsu__c,
             TAX_CODE__c, TAX_TYPE__c, extc__c, TAXCODE_SC__c, extcsc__c From g_srvcitm__c where actv__c = true and IsDeleted = false and srvc__c =: rq.srvc__c order by ord__c];
        for (g_srvcitm__c si: sitmLst) {
        if (si.aln__c) {
            decimal nr = 0;
            for (itm i: Is) {
                if (i.I.itm__r.cd__c == si.cd__c) {
                    nr++;
                }
            }
            if (nr < si.mxcnt__c || si.mxcnt__c == 0) {
                Is.add(new itm(rq, si, null, nr > 0 ? true : false, Is.size()));
            }
        } else {
            for (g_reqMbr__c m: rq.reqMbrs__r) {
                decimal nr = 0;
                for (itm i: Is) {
                    if (i.I.itm__r.cd__c == si.cd__c && i.I.m__c == m.Id) {
                        nr++;
                    }
                }
                if (nr < si.mxcnt__c || si.mxcnt__c == 0) {
                    Is.add(new itm(rq, si, m, nr > 0 ? true : false, Is.size()));
                }
            }
        }
    }
  }

    if (rq.reqMbrs__r != null) {
        rq.reqMbrs__r.clear();
    } /*minimize view state size*/
    getSTAs();
    getOptSTAs();
}
    public static boolean DEG_Checksum(String msg, String encText) {
        String eCd = EncodingUtil.convertToHex(Crypto.generateDigest('SHA1', blob.valueOf('P@ssw0rdAXSHRMS'+msg))).toUpperCase();
        System.debug('** eCd:'+eCd);    System.debug('** encText:'+encText);
        return eCd == encText;
        }
    private void getSTAs() {
        STAs=new list<g_srvcitm_Status__c>([select id, cd__c, itm__r.cd__c, itm__r.uid__c,
            Name, lbl__c, Courier_Stage__c, Tp__c, rqSTA__c, rc__c, slaN__c,
                slaXP__c, noEXP__c from g_srvcitm_Status__c where itm__r.srvc__c=:rq.srvc__c and itm__r.actv__c = true and isDeleted = false]);
    }
    private void getOptSTAs() {
        optSTA=new List<SelectOption>();set<String>mS=new set<String>();mS.add('');
        for (g_srvcitm_Status__c s:STAs) {mS.add(s.cd__c == null?'':s.cd__c);}
        for (String c:mS) {optSTA.add(new SelectOption(c, ''));}
    }
    private void Validate() {
        if (!isgu) {
            if (!hasAccess()) {pgHide=true;}
        }
        if (!gU.checkNav()) {
            gU.addWarningMsg(Label.errPageExpired + '<br/><a onclick="setNav();(isgu == true?window.location.href=\'/apex/grqeii?id='+
                rq.Id+'&empid=' + String.escapeSingleQuotes(empid) + '&enc=' + String.escapeSingleQuotes(encid) + '&sid=' +
                String.escapeSingleQuotes(sid) + '&pid=' + String.escapeSingleQuotes(pid) + '\':window.location.href=\'/apex/grqei?id='+
                rq.Id+'\')" class="btnCncl" style="cursor:pointer;">Click here to reload most recent data.</a>');
            pgHide=true;
        }
    }
    private Boolean hasAccess() {
        System.debug('**Before');
        Boolean blOk=gU.canReqSrvc(rq.srvc__c, false, 'grqei');/*if (!blOk) {gU.addInfoMsg(Label.msgNoPrivilege);}*/
        blOk=true;
        System.debug('**After');
        if (rq.STA__c=='Draft'||rq.STA__c=='On Hold') {gu.addInfoMsg('Request is '+rq.STA__c);blOk=false;}
        return blOk;
    }
    //*** ------- JSON --------------------------------------------------------------------------------
    //public String iSettingsJS{get{PageReference pr=new PageReference('/resource/'+rq.srvc__r.stg__r.json__c+'/iSettings.json');return pr.getContent().toString();}}
    //public String iRulesJS{get{PageReference pr=new PageReference('/resource/'+rq.srvc__r.stg__r.json__c+'/iRules.json');return pr.getContent().toString();}}
    public String rqJS{get{return JSON.serialize(rq);}}
    public String itmsJS{get{return JSON.serialize(Is);}}
    public String staJS{get{return JSON.serialize(STAs);}}
    //*** ------- DB Handlers --------------------------------------------------------------------------------
    public enum iSTA{Err, Open, Closed}
    public static BusinessHours mBH;
    private iSTA adjustItm(itm i, Boolean autoC, map<String, g_srvcitm_Status__c> mSTA) {
        i.I.STA__c=null;
        i.calcDiscount(rq);
        g_srvcitm_Status__c s = mSTA.get(i.I.itm__r.cd__c+i.nSTA);
        if (s != null) {
        try{
            i.I.STA__c=s.id;
           i.I.slaN__c=s.slaN__c;
            i.I.slaXP__c=s.slaXP__c;
            if (i.I.dtsc__c == null &&  (i.oSTA != i.nSTA || i.n)) {i.I.dtsc__c=Datetime.now();}
           /* if (s.Tp__c!='Open' && i.I.dtiacls__c == null) {
            i.I.dtiacls__c=Datetime.now();
            } else{i.I.dtiacls__c=null;}*/

            if (i.oSTA != i.nSTA) {
                if (!nD&&!nP&&!nC && i.nSTA=='Under Review') {
                    rq.STA__c =i.nSTA;
                }else  if (i.nSTA!='Under Review') {
                    rq.STA__c =i.nSTA;

                }
            }

            if (mBH == NULL)
                mBH = [SELECT Id FROM BusinessHours WHERE id=: gU.csStr('BH')];
            if (s.rqSTA__c != null && i.I.AD__c == 0) {rq.STA__c=s.rqSTA__c;
                                                 System.debug('Inside doishfdus&&&&& '+rq.xfpc__c+'--'+s.rqSTA__c);
                                                 if (rq.xfpc__c != null && (s.rqSTA__c=='Completed' || s.rqSTA__c=='Rejected' || s.rqSTA__c=='Cancelled')) {
                                                     System.debug('Inside doishfdus&&&&&' + BusinessHours.diff(mBh.Id, rq.xfpc__c, System.now()) );
                                                     System.debug('Inside doishfdus&&&&&' + (Double)BusinessHours.diff(mBh.Id, rq.xfpc__c, System.now()) /(1000*60*60));
                                                     rq.duration__c =  (Double)BusinessHours.diff(mBh.Id, rq.xfpc__c, System.now())/(1000*60*60);
                                                 }
            }
            if (autoC && ispu && i.I.vSTA__c =='Requires Correction') {i.I.vSTA__c = 'Requires Verification';}
            if (s.Tp__c =='Open') {return iSTA.Open;}return iSTA.Closed;
            }catch (Exception ex) {gU.AddErrorMsg('---'+i.I.dtiacls__c);}
        }
        return iSTA.Err;
    }
    //private Boolean stopDirtyUpdate{get{for (g_reqitem__c dbi:[select id, LastModifiedDate, LastModifiedBy from g_reqitem__c where RQ__c=:rq.Id and isDeleted=false]) {for (itm i:Is) {if (i.I.id == dbi.Id&&dbi.LastModifiedDate != i.I.LastModifiedDate) {gu.AddErrorMsg('Someone else modified this record.<br/><a onclick="setNav(); window.location.href=\'/apex/grqei?id='+rq.Id+'\';"  class="btnCncl" style="cursor:pointer;">Click here to reload most recent data.</a>');pgHide=true;return true;}}}return false;}}

    private Boolean stopDirtyUpdate {
    get {
        for (g_reqitem__c dbi: [select id, LastModifiedDate, LastModifiedBy.id from g_reqitem__c where RQ__c =: rq.Id and isDeleted = false]) {
            for (itm i: Is) {
                if (i.I.id == dbi.Id && dbi.LastModifiedDate != i.I.LastModifiedDate && dbi.LastModifiedBy.id != Label.courier_user_id) {
                    gu.AddErrorMsg('Someone else modified this record.<br/><a onclick="setNav(); window.location.href=\'/apex/grqei?id=' +
                        rq.Id + '\';"  class="btnCncl" style="cursor:pointer;">Click here to reload most recent data.</a>');
                    pgHide = true;
                    return true;
                }
            }
        }
        return false;
    }
}

public Boolean doSave(Boolean autoC, Boolean goNxt) {
    Savepoint sp = null;
    list < g_reqitem__c > toDelete = new list < g_reqitem__c > ();
    list < g_reqitem__c > toUpsert = new list < g_reqitem__c > ();
    list < g_reqitem__c > courBk = new list < g_reqitem__c > ();
    list < g_reqitem__c > courBk2 = new list < g_reqitem__c > ();
    Boolean loadLoc = false, amdFlg = false, awpFlg = false, canFlg = false;
    Date lsexpDt = null;
    Boolean rpUpdated = false;
    /*Sorna - v1.1*/ try {
        if (stopDirtyUpdate) {
            return false;
        }
        map < String, g_srvcitm_Status__c > mSTA = new map < String, g_srvcitm_Status__c > ();
        for (g_srvcitm_Status__c s: STAs) {
            mSTA.put(s.itm__r.cd__c + s.cd__c, s);
        }
        String oSTA = rq.STA__c;
        if (rq.srvc__r.uid__c == '208') lsexpDt = rq.Acc__r.lcedt__c;
        List<SObject> bulkDml3 = new List<SObject>();
        for (itm i: Is) {
            if (i.s) {
                if (adjustItm(i, autoC, mSTA) == iSTA.Err) {
                    gU.AddErrorMsg(i.I.itm__r.cd__c + '-' + i.nSTA + ': System Error: unable to resolve item status');
                    return false;
                }
                g_srvcitm_Status__c s = mSTA.get(i.I.itm__r.cd__c + i.nSTA);
                System.debug('<LDD> s.Courier_Stage__c : ' + s.Courier_Stage__c + '  i.I.AOP__c: ' + i.I.AOP__c + ' i.I.AD__c : ' + i.I.AD__c);
                if (s.Courier_Stage__c != null && i.I.AOP__c == 0 && i.I.AD__c <= 0 && (s.Courier_Stage__c == 'Collection' || (s.Courier_Stage__c == 'Delivery' && !ispu))) {
                    i.I.xcub__c = s.Courier_Stage__c;
                    courBk.add(i.I);
                }
                if ((i.I.xcub__c == 'Collection' || i.I.xcub__c == 'Delivery') && (s.Courier_Stage__c != 'Any' && s.Courier_Stage__c != 'Collection' && s.Courier_Stage__c != 'Delivery')) {
                    i.I.xcub__c = '';
                }
                if (rq.srvc__r.uid__c == '208' && i.I.itm__r.cd__c == 'dr' && (rq.xpmsle__c || rq.xmloc__c) && i.nSTA == 'lcd') {
                    loadLoc = true;
                }
                if (rq.srvc__r.uid__c == '922' && i.nSTA == 'ok') {
                    refundFormBanKController.adh4 adh = (refundFormBanKController.adh4) JSON.deserialize(rq.xadtx4__c, refundFormBanKController.adh4.class);
                    Account Acc = new Account();
                    Acc.id = rq.Acc__c;
                    Acc.bandb__c = adh.gbrnlkid;
                    Acc.bacnm__c = adh.g_bacnm;
                    Acc.bknm__c = adh.g_bacnm;
                    Acc.banum__c = adh.g_banum;
                    Acc.iban__c = adh.g_iban;
                    Acc.basft__c = adh.g_basft;
                    Acc.bfrc__c = adh.g_bfrc;
                    Acc.bfsc__c = adh.g_bfsc;
                    Acc.bifc__c = adh.g_bifc;
                    Acc.InBcd__c = adh.inba;
                    bulkDml3.add(Acc);
                    grqWsInsH.createBankAcc(rq, i.I);
                    awpFlg = true;
                }
                if (rq.srvc__r.uid__c == 'crf' && i.I.xvpa__c == 'Approved' && i.I.itm__r.cd__c == 'rf' && (i.nSTA == 'ok' || i.nSTA == 'pok')) {
                    /*grqWsInsH.createBankAcc(rq, i.I);
                    */ if (i.nSTA == 'pok') {
                        i.I.xcnotes__c = 'Refund for ' + i.I.xtrf__c + ' has been partially approved. Requested amount AED ' +
                            i.I.xrramt__c + ', Approved amount AED ' + i.I.xramt__c + ' Due to: ' + i.I.xcnotes__c;
                    }
                    awpFlg = true;
                }
                if (rq.srvc__r.uid__c == 'crf' && i.I.itm__r.cd__c == 'rf' && (i.nSTA == 'gr' || i.nSTA == 'r' || i.nSTA == 'c')) {
                    /*grqWsInsH.createBankAcc(rq, i.I);
                    */ canFlg = true;
                }
                if (rq.srvc__r.uid__c == '208' && i.I.itm__r.cd__c == 'dr' && rq.xpmsle__c && i.nSTA == 'vwp') {
                    awpFlg = true;
                }
                List < String > ofcItmCdList = Label.LicItmCds.split(';');
                if (rq.srvc__r.uid__c == '208' && ofcItmCdList.contains(i.I.itm__r.cd__c)) {
                    if (i.I.xleed__c != null && i.I.xleed__c > lsexpDt) lsexpDt = i.I.xleed__c;
                }
                if (rq.srvc__r.uid__c == '208' && i.I.itm__r.cd__c == 'amd' && (rq.xmamd__c == null || !rq.xmamd__c)) {
                    amdFlg = true;
                }
                if (((rq.srvc__r.uid__c == '216' && i.I.itm__r.cd__c == 'nl') || (rq.srvc__r.uid__c == '221')) && (i.nSTA == 'lcd' || i.nSTA == 'vwp')) {
                    amdFlg = true;
                }
                List < String > ItmVATIncSrvUIDLst = Label.ItmVATIncSrvUID.split(';');
                if (ItmVATIncSrvUIDLst.contains(rq.srvc__r.uid__c) && i.I.scN__c != null && i.I.scN__c != 0 && i.I.itm__r.vscp__c != null && i.I.itm__r.vscp__c != 0 && i.I.vsc__c != null && i.I.vsc__c == 0) {
                    i.I.vsc__c = i.I.scN__c * 0.05;
                }
                if (rq.srvc__r.uid__c != '208' || (rq.srvc__r.uid__c == '208' && i.I.itm__r.cd__c != 'psf') || (rq.srvc__r.uid__c == '208' && i.I.itm__r.cd__c == 'psf' && i.nSTA == 'ok' && i.oSTA != 'ok')) toUpsert.add(i.I);
                /*Sorna - v1.1 Start - Copy RP issue & expiry dates from RP item to Request*/ if (rq.srvc__r.uid__c == '045' && i.I.itm__r.cd__c == 'rp' && i.I.xrped__c != NULL && i.I.xrped__c != rq.xrped__c) {
                    System.debug('::inside if::');
                    rq.xrped__c = i.I.xrped__c;
                    rq.xrpid__c = i.I.xrpid__c;
                    rpUpdated = true;
                }
            /*v1.1 End*/ }
            else {
                if (!i.n) {
                    toDelete.add(i.I);
                }
            }
        }
        if (!bulkDml3.isEmpty()) {
            update bulkDml3;
        }
        system.debug('LDD : ' + courBk);
        system.debug('lsexpDt::' + String.valueOf(lsexpDt) + 'loadLoc:' + loadLoc);
        if (courBk != null && !courBk.isEmpty() && courBk.size() > 0) {
            XMLParserforEmpostWebservice cour = new XMLParserforEmpostWebservice();
            if (rq.srvc__r.uid__c == '197') {
                courBk[0].xcub__c = 'Collection';
            }
            else if (rq.srvc__r.uid__c == '196') {
                courBk[0].xcub__c = 'Delivery';
            }
            cour.courierBooking(courBk[0], rq, false, '');
        }
        if (rq.srvc__r.uid__c == '216' && amdFlg) {
            rq.activitiesFL__c = gwsPMSIntegration.ejariLeaseStr(rq.id);
            gwsPMSIntegration.updateLeaseInfo(rq);
        }
        if (rq.srvc__r.uid__c == '922' && awpFlg) {
            system.debug('######################rq.srvc__r.uid__c---' + rq.srvc__r.uid__c);
            grqWsInsH.createBankAcc(rq, null);
        }
        if (rq.srvc__r.uid__c == 'crf' && awpFlg && !rq.vfsFlag__c) {
            system.debug('######################rq.srvc__r.uid__c---' + rq.srvc__r.uid__c);
            grqWsInsH.createCDBGRefund(rq, null);
        }
        /* b-rls*/ if (rq.srvc__r.uid__c == 'crf' && canFlg && !rq.vfsFlag__c) {
            system.debug('######################rq.srvc__r.uid__c---' + rq.srvc__r.uid__c);
            /* grqWsInsH.createCDBGRefund(rq, null);
            */ Account a = [Select id, adrfi__c, bgrfi__c from Account where id =: rq.Acc__c limit 1];
            if (rq.xvtyp__c == 'Customer Deposit') {
                a.adrfi__c = a.adrfi__c - rq.xtpa__c;
            }
            if (rq.xvtyp__c == 'Bank Guarantee') {
                a.bgrfi__c = a.bgrfi__c - rq.xtpa__c;
            }
            update a;
        }
        if (rq.srvc__r.uid__c == '221' && amdFlg) {
            /*grqH.rAfter=true;
            */ rq.xcawp__c = true;
            rq.xppsfv__c = true;
            update rq;
            gwsPMSIntegration.updateLeaseAmdInfo(rq);
            update rq;
            system.debug('test awaiting paymnet flag:' + rq.xcawp__c);
        }
        if (rq.srvc__r.uid__c == '208' && !loadLoc && amdFlg) {
            rq.xmamd__c = true;
            Date licExpDt = null;
            if (rq.xcbd__c != null && rq.xcbd__c > rq.acc__r.lcedt__c) licExpDt = rq.xcbd__c;
            else licExpDt = rq.acc__r.lcedt__c;
            String dccaRes = grqWsDccaGetService.getReqDetails(rq.acc__r.lc__c, String.valueOf(licExpDt), rq.xdei__c, amdFlg);
            system.debug('dccaRes11::' + dccaRes);
        }
        /*v1.1 Start */ if (rq.srvc__r.uid__c == '045' && rpUpdated) {
            update rq;
        }
        /*v1.1 End*/ if (loadLoc) {
            Account Acc = rq.acc__r;
            Date accLcExpDt = (Acc.lcedt__c).addYears(1);
            if (lsexpDt > accLcExpDt) lsexpDt = accLcExpDt;
            List < grqWsDccaGetService.Records > tecomLeaseList = new List < grqWsDccaGetService.Records > ();
            String leaseDt = '';
            Decimal psfFee = 0;
            tecomLeaseList = grqWsDccaGetService.loadD3Loc(Acc.ORACLE_PARTY_ID__c);
            for (grqWsDccaGetService.Records rc: tecomLeaseList) {
                if (!String.IsBlank(rc.ContractStartDate)) {
                    rc.ContractStartDate = grqWsDccaGetService.formatDt(rc.ContractStartDate);
                }
                if (!String.IsBlank(rc.ContractEndDate)) {
                    rc.ContractEndDate = grqWsDccaGetService.formatDt(rc.ContractEndDate);
                }
            }
            if (tecomLeaseList != null && tecomLeaseList.size() > 0 && Acc.lcedt__c != null) leaseDt = grqWsDccaGetService.getNewLicDt(tecomLeaseList, Acc.lcedt__c, Acc.Legal_Framework__c);
            system.debug('leaseDt11:::' + leaseDt);
            if (String.isNotBlank(leaseDt)) {
                Date licExpDt = Date.valueOf(grqWsDccaGetService.formatDt2(leaseDt));
                if (licExpDt != null && licExpDt > lsexpDt) lsexpDt = licExpDt;
            }
            system.debug('lsexpDt22::' + lsexpDt);
            /*grDDAReq ddaRq = new grDDAReq();
            ddaRq.Acc = Acc;
            ddaRq.rq = rq;
            ddaRq.LoadAllLocSeg(true);
            tecomLeaseList = ddaRq.tecomLeaseList;
            leaseDt = ddaRq.leaseDt;
            rq = ddaRq.rq;
            Decimal psfAmount = 0;
            if (rq.xadtx3__c != null) {
                system.debug('r.xadtx3__c Inside loop' + rq.xadtx3__c);
                grqWsDccaGetService.ResponseData newResp = (grqWsDccaGetService.ResponseData) JSON.deserialize(String.ValueOf(rq.xadtx3__c), grqWsDccaGetService.ResponseData.class);
                List < grqWsDccaGetService.Records > getRecList = new List < grqWsDccaGetService.Records > ();
                if (newResp != null && newResp.Records != null) getRecList = newResp.Records;
                String invName = '';
                boolean tecomservice = false;
                for (grqWsDccaGetService.Records getRec: getRecList) {
                    if (getRec.Invoices != null) {
                        List < grqWsDccaGetService.Invoices > pyList = new List < grqWsDccaGetService.Invoices > ();
                        pyList = getRec.Invoices;
                        if (Acc.Prk__c != 'Dubai Design District' && Acc.Legal_Framework__c == 'Freelancer') getRec.FreelancerLease = true;
                        for (grqWsDccaGetService.Invoices py: pyList) {
                            if (py.InvoiceAmount != null && getRec.FreelancerLease != null && getRec.FreelancerLease == true) {
                                psfAmount = (psfAmount + Decimal.ValueOf(py.InvoiceAmount).setScale(2)) - 2775;
                                tecomservice = true;
                                invName += py.InvoiceName + '|';
                            }
                            else if (py.InvoiceAmount != null && py.InvoiceType == 'CHARGES') {
                                psfAmount = (psfAmount + Decimal.ValueOf(py.InvoiceAmount).setScale(2));
                                invName += py.InvoiceName + '|';
                            }
                        }
                    }
                }
                rq.xlinv__c = invName;
                rq.tsrv__c = tecomservice;
                psfFee = psfAmount + (psfAmount * 0.05);
            }
            */ system.debug('psfFee0::' + psfFee);
            system.debug('***getCpuTime()2***' + Limits.getCpuTime());
            if (lsexpDt != null) {
                rq.xcbd__c = lsexpDt;
                rq.xdedln__c = lsexpDt.day() + '/' + lsexpDt.month() + '/' + lsexpDt.year();
            }
            if (amdFlg) rq.xmamd__c = true;
            else rq.xmamd__c = false;
            grqDDAReqdta ddaRqd = new grqDDAReqdta();
            ddaRqd.Acc = Acc;
            ddaRqd.rq = rq;
            ddaRqd.tecomLeaseList = tecomLeaseList;
            /*/leaseDt='01-05-2019';
            */ ddaRqd.tecomd3LsList = new List < grqWsDccaGetService.Records > ();
            ddaRqd.leaseDt = leaseDt;
            ddaRqd.setDCCAReqValues();
            rq = ddaRqd.rq;
            system.debug('rq.xcbd__c3::' + rq.xcbd__c);
            rq.xcfn__c = ddaRqd.mangerName;
            rq.xcfnar__c = ddaRqd.mangerNameA;
            rq.xcln__c = ddaRqd.managerNation;
            rq.xclnar__c = ddaRqd.managerNationA;
            rq.xdei__c = ddaRqd.idRec;
            rq.xeng__c = ddaRqd.shareHldType;
            rq.xppsfv__c = true;
            rq.xcawp__c = true;
            if (rq.xtpa__c != null && rq.xtpa__c != 0 && psfFee != null && psfFee != 0 && ((rq.xpmsle__c == true && rq.xppsfv__c == true) || (rq.tsrv__c))) {
                system.debug('psfFee1::' + psfFee);
                rq.xtpa__c = rq.xtpa__c + psfFee;
                rq.xdedc__c = gU.AmountInWords(rq.xtpa__c.intValue());
            }
        }
        /* Parking - validate vehicle */ Map < String, String > vResp = validateVehicle(oSTA);
        if (vResp.get('ResponseCode') != '0') {
            gu.AddErrorMsg(vResp.get('errMessage'));
            return false;
        }
        /* Parking - push Data  */ Map < String, String > response = pushParkingData(oSTA);
        if (response.get('ResponseCode') != '0') {
            gU.AddErrorMsg(response.get('errMessage'));
            return false;
        }
        sp = Database.setSavePoint();
        if (toUpsert.size() > 0) {
            system.debug('Item update::');
            upsert toUpsert;
        }
        if (rq.srvc__r.uid__c == '208' && (loadLoc || amdFlg || awpFlg)) {
            system.debug('update req::');
            update rq;
            /* List<g_reqitem__c> psfItmLst = [select id, name from g_reqitem__c where rq__c=:rq.id and itm__r.cd__c='psf'];
            if (psfItmLst != null && !psfItmLst.isEmpty()) {
                ws_call__c ws = new ws_call__c();
                ws.rq_itm__c = psfItmLst[0].id;
                ws.ws_typ__c = 'DDA License Renewals';
                ws.mtd_nm__c = 'updatePMSInfo';
                ws.intsts__c = 'Ready for Integration';
                ws.uid__c = psfItmLst[0].id + ''+system.now() +'PMSInfo' ;
                insert ws;
            }
        */ }
        if (rq.srvc__r.uid__c == 'dnc') {
            gctlReq_L qrl = new gctlReq_L();
            qrl.updateEncriptedQRCodeLink(rq);
        }
        if (toDelete.size() > 0) {
            delete toDelete;
        }
        if (goNxt && !loadLoc) {
            String nSTA = rq.STA__c;
            laodData();
            rq.STA__c = nSTA;
            if (nSTA != 'Completed') {
                advanceRequest(oSTA);
            }
            else {
                update rq;
            }
        }
        if (loadLoc || awpFlg || (amdFlg && rq.srvc__r.uid__c == '216')) laodData();
        gu.addSuccessMsg(Label.msgSuccess);
        return true;
    }
    catch (exception ex) {
        if (sp != null) {
            Database.rollback(sp);
        }
        if (ispu) {
            gu.AddErrorMsg(Label.msgException + ':' + '2');
            gu.AddErrorMsg(ex.getMessage());
            gu.AddErrorMsg(ex.getStackTraceString());
            /*/addPortalUserMessage(ex.getMessage());
        */ }
        else {
            gu.AddErrorMsg(ex.getMessage());
        }
        return false;
    }
}

    @TestVisible Private void addPortalUserMessage(String eMsg) {
        if (eMsg.contains(', ')) {
            String[] msg=eMsg.split(', ');
            Integer i=msg.size();
            gu.AddErrorMsg(msg[i-1]);
        }
    }

    private void advanceRequest(String oSTA) {
        if (rq.STA__c != oSTA) {
            if (rq.xfpc__c != null ) {
                rq.duration__c =  (Double)BusinessHours.diff(mBh.Id, rq.xfpc__c, System.now())/(1000*60*60);
            }
            update rq;
            return;
        }
        if (rq.STA__c =='Open') {
            if (!nD&&!nP&&!nC && !allV && rqsV) {
                rq.STA__c='Under Review';
                update rq;
                return;
            }
        }
        if (rq.STA__c =='Under Review') {
            if (nC) {
                rq.STA__c='Open';
                update rq;
                return;
            }
            if (allV && rqsV ) {
                rq.STA__c='In Process';
                update rq;
                return;
            }
        }
    }
    public Boolean allV{get{for (itm i:Is) {if (i.s) {if (i.I.vSTA__c!='Verified' && i.I.rv__c) {return false;}}}return true;}}
    public Boolean rqsV{get{for (itm i:Is) {if (i.s) {if (i.I.rv__c) {return true;}}}return false;}}
    public Boolean nC{get{for (itm i:Is) {if (i.s) {if (i.I.rv__c && i.I.vSTA__c=='Requires Correction') {return true;}}}return false;}}
    public Boolean nCou{get{for (itm i:Is) {if (i.s) {if (i.I.Courier_Stage__c=='Collection') {return true;}}}return false;}}
    public Boolean nD{get{if (rq.rDocs__r == null) {return false;}for (g_reqDoc__c d:rq.rDocs__r) {if (!d.upOk__c) {return true;}}return false;}}
    public Boolean nP{get{for (itm i:Is) {if (i.s) {if (i.I.AD__c>0) {return true;}}}return false;}}
    /*new method to check if open payment*/
    public Boolean noP{get{for (itm i:Is) {if (i.s) {if (i.I.AOP__c>0) {return true;}}}return false;}}
    private PageReference nextPage {
    get {
        PageReference p;
        //EMPOST - Courier SH
        if (rq.srvc__r.uid__c=='196' || rq.srvc__r.uid__c=='197') {return new PageReference('/apex/spg?id=' + rq.Id + '&cn=' + rq.srvc__r.uid__c);}

        if (isgu) {
            p = new pagereference('/apex/grqupi?id=' + rq.Id + '&empid=' + String.escapeSingleQuotes(empid) + '&enc=' +
                String.escapeSingleQuotes(encid) + '&sid=' + String.escapeSingleQuotes(sid) + '&pid=' + pid);
        } else if (nD) {

            p = new PageReference('/apex/grqup?id=' + rq.Id);
        } else if (nC && ispu) {
            p = new PageReference('/apex/grqup?id=' + rq.Id);
        } else if (nP) {
            p = new PageReference('/apex/grqpy?id=' + rq.Id);
        } else {

            if (ispu) {

                return null;
                if (!nD&&!nP && nCou) {
                   //gu.AddErrorMsg('testing pls ignore '+nCou); return null;
                //CreateBooking();
               // gu.AddErrorMsg('testing pls ignore '+nCou); return null;
                }
                p = new PageReference('/apex/grqpstd?id=' + rq.Id);
            }if (!ispu) {
                p = (new ApexPages.StandardController(rq)).view();
            }
        }
        p.setRedirect(true);
        return p;
    }
    }

    public PageReference saveClose() {if (doSave(true, true)) {return(new ApexPages.StandardController(rq)).view();}return null;}
    public PageReference save() {
        if (doSave(true, true)) { PageReference p=new PageReference('/apex/grqei?id='+rq.Id);p.setRedirect(true);return p;}return null;}

    public PageReference saveContinue() {
        try{

            if (doSave(true, true)) {return nextPage;}
        }catch (exception ex) {
            if (ispu) { //gu.AddErrorMsg(Label.msgException+'3');
            } else{ gu.AddErrorMsg(ex); }
        }
        return null;
    }

    public PageReference nextPage() {try{return nextPage;}catch (exception ex) {if (ispu) {
                gu.AddErrorMsg(Label.msgException+'5');
            }
            else{
                gu.AddErrorMsg(ex);
            }}return null;}
    //*** ------- Wrappers --------------------------------------------------------------------------------
    public class itm{
        public g_reqitem__c I{get;set;}
        public Boolean n{get{return(I.Id == null);}} //is new
        public Boolean b{get{return I.itm__r.Req__c;}} // is a base package
        public Boolean r{get;set;} // is repeated item
        public Boolean s{get;set;}//is selected
        public Boolean v{get{return(I.itm__r.Req__c||I.Id != null);}}// is visible
        public String uid{get;set;} //unique id
        public String dSTA{get{return I.itm__r.dSTA__c;}}//default status Code
        public String nSTA{get;set;}//new Status Code
        public String oSTA{get{return nSTA;}} //old Status Code
        public String gSTA{get;set;} //original Status Code
        public Boolean gD{get;set;} //Original Documents are received
        public Boolean uD{get;set;} // required attachments are uploaded
        private void calcDiscount(g_Req__c rq) {
            //don't do anything if there is a payment happened or discount applied before or item is not eligible for discount
            if (I.AP__c>0||I.Dsc__c>0||!I.DscApp__c) {return;}
            if (rq.dsc__r.prct__c != null) {I.Dsc__c=math.floor((I.scN__c+(I.exp__c?I.scXP__c:0))*rq.dsc__r.prct__c/100);}else{I.Dsc__c=0;}
        }
        public itm(g_reqitem__c ri, Boolean isGD, Boolean isUD, Integer indx) {
            I=ri;
            s=true;r=false;
            gSTA=ri.sta__r.cd__c;nSTA=gSTA;
            gD =true; //isGD;
                uD =isUD;
            uid= ri.Id;// 'i'+indx.format();
        }
        public itm(g_Req__c rq, g_srvcitm__c si, g_reqMbr__c m, boolean isRepeated, Integer indx) {
            I=new g_reqitem__c(Name=si.Name, itm__c=si.id, RQ__c=rq.Id,
                m__c=si.aln__c?null:m.Id, rv__c=si.rv__c, vSTA__c=si.rv__c?'Requires Verification':'Verified',
                slaN__c=si.slaN__c, slaXP__c=si.slaXP__c, ngs__c=si.ngs__c, ngsXP__c=si.ngsXP__c,
                    TAX_CODE__c=si.TAX_CODE__c, TAX_TYPE__c=si.TAX_TYPE__c, extc__c=si.extc__c, TAXCODE_SC__c=si.TAXCODE_SC__c,
                    extcsc__c=si.extcsc__c,
                DscApp__c=si.DscApp__c, KF__c=si.KF__c, cN__c=si.cN__c, cXP__c=si.cXP__c, smN__c=si.smN__c,
                    smXP__c=si.smXP__c, scN__c=rq.spCh__c?si.spChN__c+si.scN__c:si.scN__c, scXP__c=rq.spCh__c?si.spChXP__c+
                    si.scXP__c:si.scXP__c, vsc__c=rq.spCh__c?si.vspc__c+si.vsc__c:si.vsc__c,  vesch__c=rq.spCh__c?si.vspexc__c+
                    si.vesch__c:si.vesch__c, vst__c=si.vst__c, vec__c=si.vec__c, su__c=si.su__c, vsu__c=si.vsu__c);
                s=si.Req__c; r=isRepeated;
                gSTA=si.dSTA__c; nSTA=gSTA;
                gD = false;uD = false;
                uid= (isRepeated?'r':'s')+si.Id;//indx.format();
                I.itm__r=si;
                I.m__r=si.aln__c?null:m;
                calcDiscount(rq);
                specialCases(rq, si);
        }
        private void specialCases(g_Req__c rq, g_srvcitm__c si) {
            if (si.xf__c != null) {
                if (si.xf__c.contains('xcemrt__c')) {
                    if (I.xcemrt__c == null) {
                        I.xcemrt__c = rq.Con__r.emrt__c;
                    }
                }
            }
            if (si.xf__c != null) {
                if (si.xf__c.contains('xccty__c')) {
                    if (I.xccty__c == null) {
                        I.xccty__c = rq.Con__r.cty__c;
                    }
                }
            }
            if (si.xf__c != null) {
                if (si.xf__c.contains('xcarea__c')) {
                    if (I.xcarea__c == null) {
                        I.xcarea__c = rq.Con__r.area__c;
                    }
                }
            }
        }
    }
    public class xF{
        public string f{get;set;}
        public Boolean e{get;set;}
        public xF(string fName, Boolean canEdit) {f=fName;e=canEdit;}
    }

  public Map<String, String> pushParkingData(String oSTA) {
      Map<String, String> response = new Map<String, String>();
      response.put('ResponseCode', '0');
      response.put('errMessage', '');
      if ((rq.srvc__r.uid__c == gu.csStr('ParkingActivation') || rq.srvc__r.uid__c == gu.csStr('ParkingModification')) && rq.STA__c != oSTA && Is.size()>0 && Is[0].nSTA=='cc' && rq.STA__c=='Under Review') {
          list<g_reqitem__c> itemsToPush=new list<g_reqitem__c>();
          for (itm i:Is) {
              itemsToPush.add(i.I);
          }
          ParkingM pm = new ParkingM();
          response = pm.pushReqItems(rq.Id, itemsToPush);
      }
      return response;
  }

   public Map<String, String> validateVehicle(String oSTA) {
       ParkingM pm = new ParkingM();
       Map<String, String> response = new Map<String, String>();
       response.put('ResponseCode', '0');
       response.put('errMessage', '');
       System.debug('rq.STA__c: ' + rq.STA__c + '  oSTA: '+oSTA);
       if ((rq.srvc__r.uid__c == gu.csStr('ParkingActivation') || rq.srvc__r.uid__c == gu.csStr('ParkingModification'))) {
           response = pm.validateVehicle2(rq, Is);
       }
       return response;
   }

}