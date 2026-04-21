@RestResource(urlMapping='/getwsrpa/*')
global class grwsRPA {

    @HttpGet
    global static void getRpa() {

        /**RestContext.response.addHeader('Content-Type', 'application/json');
        String reqNum = RestContext.request.params.get('id');
        System.debug('reqNum: ' + reqNum);
        String resp = hhrpk(reqNum, '', '', '');

        RestContext.response.responseBody = Blob.valueOf(resp);//JSON.serialize(resp));
        **/

        RestContext.response.addHeader('Content-Type', 'application/json');
        String reqBody  = RestContext.request.requestBody.toString(); //String reqBody = req.requestBody.toString();
        grwsRPA.rpaReq dptData = (grwsRPA.rpaReq)JSON.deserialize(reqBody, grwsRPA.rpaReq.class);
        Boolean expPriority = dptData.expPriority=='1'?true:false;
        String resp = hhrpk(dptData.reqNum, dptData.srvcd, dptData.itmCd, expPriority);
        RestContext.response.responseBody = Blob.valueOf(resp);
    }

    @HttpPost
    global static void doPost() {

        RestContext.response.addHeader('Content-Type', 'application/json');

        String reqBody  = RestContext.request.requestBody.toString(); //String reqBody = req.requestBody.toString();
        System.debug('reqBody: ' + reqBody);

        grwsRPA.rpaReq dptData = (grwsRPA.rpaReq)JSON.deserialize(reqBody, grwsRPA.rpaReq.class);
        System.debug('dptData: ' + dptData);

        Boolean expPriority = dptData.expPriority=='1'?true:false;

        String reqNum = '1243';//RestContext.request.params.get('id');
        System.debug('reqNum: ' + reqNum);

        String resp = hhrpk(dptData.reqNum, dptData.srvcd, dptData.itmCd, expPriority);

        RestContext.response.responseBody = Blob.valueOf(resp);

        //JSON.serialize(resp));
    }

    public static String hhrpk(String reqNum, String srvd, String itmCd, Boolean expPriority) {

        /*System.debug('reqID2: ' + reqNum); rpaResp resp = new rpaResp();resp.respCode = '0';      resp.respMsg    = '';
        resp.SRN        = '65800320180726';
        resp.AxsId      = 'a0Ep00000001G5PEAU';
        resp.status     = 'Success';
        */

        List<g_reqitem__c> finalListRqItm  = new List<g_reqitem__c>();
        List<g_reqitem__c> expFnListRqItm  = new List<g_reqitem__c>();
        List<g_reqitem__c>  medReqItems = new List<g_reqitem__c>();
        Boolean exp=false;
         String JSONString;
        try{
            exp=expPriority;
            if (itmCd=='la' || itmCd=='ai') {expPriority=false;}
            List<String> srvcIDs = new List<String>();
            if (String.isNotBlank(srvd)) { srvcIDs = srvd.split(', ');}
            //List<String> stCd=new List<String>{'rv', 'n', 'v', 'dr'};
                List<String> stCd=new List<String>{'vb'};

                if (itmCd=='rpmd') {stCd=new List<String>{'ppr'};itmCd='rp';}
            List<g_reqitem__c> epItmList=new  List<g_reqitem__c>();
            map<String, g_reqitem__c>  epmapRefReqItm = new map<String, g_reqitem__c>();
            if (itmCd=='md' &&  srvd=='001, 002, 003, 004, 021, 078, 040, 020') {
                List<String> epstCd=new List<String>{'rv', 'n', 'v', 'nc', 'ncc', 'vb'};
                    epItmList = [Select Id, RQ__r.xfpc__c, xcpfv__c, xcstrt__c, xvt__c, xcpobx__c, xccty__c,
                        RQ__r.xspn__c, RQ__r.xecnop__c, RQ__r.xecedtp__c, RQ__r.xcitn__c, RQ__r.xcmonar__c,
                        RQ__r.xcpipoar__c, RQ__r.xcpobar__c, RQ__r.xcarea__c, RQ__r.xaloc__c, RQ__r.xchph__c,
                        RQ__r.xcpobx__c, RQ__r.xccty__c, xceidedt__c, RQ__r.xceidedt__c, Name, xf__c, RQ__r.srvc__r.stg__r.itmq__c,
                        RQ__r.xcemrt__c, xcp__c, xcped__c, xcpid__c, xcpic__c, xcpip__c, xcnc__c, xcslt__c,
                        xcfn__c, xcmn__c, xcln__c, xcbd__c, RQ__r.xcmob__c, RQ__r.Name, RQ__r.Spr__c, RQ__r.Acc__c,
                        RQ__r.Acc__r.ec__c, RQ__r.Acc__r.ecedt__c, RQ__r.Acc__r.onar__c, RQ__r.Acc__r.Name,
                        RQ__r.Acc__r.BillingCity, RQ__r.Acc__r.lctp__c, RQ__r.Acc__r.BillingPostalCode, RQ__r.Acc__r.Phone,
                        RQ__r.Acc__r.Type, RQ__r.Acc__r.Prk__c, RQ__r.xeidav__c, RQ__r.Con__r.Id, RQ__r.Con__r.flnm__c,
                        RQ__r.Con__c, RQ__r.Con__r.FirstName, RQ__r.Con__r.FlnAr__c, RQ__r.Con__r.mn__c,
                        RQ__r.Con__r.mnar__c, RQ__r.Con__r.Name, RQ__r.Con__r.Email, RQ__r.Con__r.fnar__c,
                        RQ__r.Con__r.LastName, RQ__r.Con__r.lnar__c, RQ__r.Con__r.nc__c, RQ__r.Con__r.qc__c,
                        RQ__r.Con__r.ot__c, RQ__r.Con__r.Birthdate, RQ__r.Con__r.bp__c, RQ__r.Con__r.bc__c,
                        RQ__r.Con__r.p__c, RQ__r.Con__r.pip__c, RQ__r.Con__r.eid__c, RQ__r.Con__r.eed__c,
                        RQ__r.Con__r.pic__c, RQ__r.Con__r.rped__c, RQ__r.Con__r.eidid__c, RQ__r.Con__r.eidedt__c,
                        RQ__r.Con__r.eididt__c, RQ__r.Con__r.rpui__c, RQ__r.Con__r.jb__c, RQ__r.Con__r.jb__r.moh__c,
                        RQ__r.Con__r.jb__r.jtm__c, RQ__r.Con__r.jb__r.jcm__c, RQ__r.Con__r.pid__c, RQ__r.Con__r.ped__c,
                        RQ__r.Con__r.rlg__c, RQ__r.Con__r.ms__c, RQ__r.Con__r.np__c, RQ__r.xphid__c, RQ__r.Con__r.MobilePhone,
                        RQ__r.Con__r.HomePhone, RQ__r.Con__r.ql__c, RQ__r.Con__r.mon__c, RQ__r.Con__r.lng__c,
                        RQ__r.Con__r.jb__r.name, RQ__r.Con__r.jb__r.cd__c, RQ__r.Con__r.Salutation, RQ__r.Con__r.e__c,
                        RQ__r.Con__r.rp__c, RQ__r.Con__r.rpid__c, RQ__r.Con__r.fan__c, RQ__r.Con__r.mona__c,
                        RQ__r.Con__r.pipa__c, RQ__r.Con__r.bpa__c, RQ__r.Con__r.strt__c, RQ__r.Con__r.pobx__c,
                        RQ__r.Con__r.ha__c, RQ__r.Con__r.Spon__r.rp__c, RQ__r.Con__r.Spon__r.e__c, RQ__r.Con__r.Spon__r.FirstName,
                        RQ__r.Con__r.Spon__r.rol__c, RQ__r.Con__r.Spon__r.LastName, RQ__r.Con__r.Spon__r.fnar__c,
                        RQ__r.Con__r.Spon__r.lnar__c, RQ__r.Con__r.Spon__r.nc__c, RQ__r.Con__r.Spon__r.Salutation,
                        RQ__r.Con__r.Spon__r.Birthdate, RQ__r.Con__r.Spon__r.rpid__c, RQ__r.Con__r.Spon__r.rped__c,
                        RQ__r.Con__r.Spon__r.p__c, RQ__r.Con__r.Spon__r.ped__c, RQ__r.Con__r.Spon__r.mon__c,
                        RQ__r.Con__r.Spon__r.Name, RQ__r.Con__r.rol__c, RQ__r.Con__r.Spon__r.mn__c, RQ__r.Con__r.Spon__r.mnar__c,
                        RQ__r.Con__r.emrt__c, RQ__r.Con__r.cty__c, RQ__r.Con__r.area__c, RQ__r.CreatedBy.Email,
                        RQ__r.CreatedBy.MobilePhone, sta__r.jscfddt__c, sta__r.itm__r.cd__c, xcjb__r.cd__c,
                        RQ__r.xcot__c, RQ__r.e__c, RQ__r.xctp__c, RQ__r.srvc__r.uid__c, RQ__r.xcslt__c, RQ__r.xcbc__c,
                        RQ__r.xcjb__r.cd__c, RQ__r.xcpic__c, RQ__r.xcrlg__c, RQ__r.xcms__c, RQ__r.xcnp__c,
                        RQ__r.xcql__c, RQ__r.xclng__c, RQ__r.xcmon__c, RQ__r.xcln__c, RQ__r.xclnar__c, RQ__r.xcfn__c,
                        RQ__r.xcfnar__c, RQ__r.xcbp__c, RQ__r.xcpip__c, RQ__r.xcp__c, RQ__r.xcpid__c, RQ__r.xcped__c,
                        RQ__r.xcbd__c, RQ__r.xcnc__c, RQ__r.xcmn__c, RQ__r.xcmnar__c, RQ__r.Spr__r.Name,
                        RQ__r.Spr__r.nc__c, RQ__r.Con__r.Spon__r.MobilePhone, RQ__r.Spr__r.Salutation, RQ__r.xcsrs__c,
                        RQ__r.Spr__r.e__c, RQ__r.Spr__r.rp__c, RQ__r.Spr__r.rpid__c, RQ__r.Spr__r.rped__c,
                        RQ__r.Spr__r.Birthdate, RQ__r.Con__r.Spon__r.mgs__c, RQ__r.Spr__r.p__c, RQ__r.Spr__r.ped__c,
                        RQ__r.Spr__r.mon__c, RQ__r.Spr__r.rol__c, RQ__r.Spr__r.FirstName, RQ__r.Spr__r.mn__c,
                        RQ__r.Spr__r.mnar__c, RQ__r.Spr__r.Email, RQ__r.Spr__r.fnar__c, RQ__r.Spr__r.LastName,
                        RQ__r.Spr__r.lnar__c, RQ__r.rmob__c, RQ__r.srvc__r.Name, xcjb__c, exp__c
                                 , itm__r.ilv__c, itm__r.elv__c, xaed__c, itm__r.cd__c FROM  g_reqitem__c WHERE EXP__c=:expPriority and RQ__r.Service_Code__c=:srvcIDs and itm__r.cd__c in('ep',
                                     'exu', 'exn', 'eca', 'eci') and AP__c>0 and STA__r.cd__c =:epstCd and  (RQ__r.STA__c ='Open' or RQ__r.STA__c ='In Process' or RQ__r.STA__c ='Under Review') Limit 200];
                if (epItmList.size()>0) {for (g_reqitem__c rqItm :epItmList ) { epmapRefReqItm.put(String.ValueOf(rqItm.RQ__r.Name), rqItm); } }
                //itmCd='ia';
            }
            List<g_reqitem__c> reqItmList = [Select Id, RQ__r.xfpc__c, xcpfv__c, xcstrt__c, xvt__c,
                xcpobx__c, xccty__c, RQ__r.xspn__c, RQ__r.xecnop__c, RQ__r.xecedtp__c, RQ__r.xcitn__c,
                RQ__r.xcmonar__c, RQ__r.xcpipoar__c, RQ__r.xcpobar__c, RQ__r.xcarea__c, RQ__r.xaloc__c,
                RQ__r.xchph__c, RQ__r.xcpobx__c, RQ__r.xccty__c, xceidedt__c, RQ__r.xceidedt__c,
                Name, xf__c, RQ__r.srvc__r.stg__r.itmq__c, RQ__r.xcemrt__c, xcp__c, xcped__c, xcpid__c,
                xcpic__c, xcpip__c, xcnc__c, xcslt__c, xcfn__c, xcmn__c, xcln__c, xcbd__c, RQ__r.xcmob__c,
                RQ__r.Name, RQ__r.Spr__c, RQ__r.Acc__c, RQ__r.Acc__r.ec__c, RQ__r.Acc__r.ecedt__c,
                RQ__r.Acc__r.onar__c, RQ__r.Acc__r.Name, RQ__r.Acc__r.BillingCity, RQ__r.Acc__r.lctp__c,
                RQ__r.Acc__r.BillingPostalCode, RQ__r.Acc__r.Phone, RQ__r.Acc__r.Type, RQ__r.Acc__r.Prk__c,
                RQ__r.xeidav__c, RQ__r.Con__r.Id, RQ__r.Con__r.flnm__c, RQ__r.Con__c, RQ__r.Con__r.FirstName,
                RQ__r.Con__r.FlnAr__c, RQ__r.Con__r.mn__c, RQ__r.Con__r.mnar__c, RQ__r.Con__r.Name,
                RQ__r.Con__r.Email, RQ__r.Con__r.fnar__c, RQ__r.Con__r.LastName, RQ__r.Con__r.lnar__c,
                RQ__r.Con__r.nc__c, RQ__r.Con__r.qc__c, RQ__r.Con__r.ot__c, RQ__r.Con__r.Birthdate,
                RQ__r.Con__r.bp__c, RQ__r.Con__r.bc__c, RQ__r.Con__r.p__c, RQ__r.Con__r.pip__c, RQ__r.Con__r.eid__c,
                RQ__r.Con__r.eed__c, RQ__r.Con__r.pic__c, RQ__r.Con__r.rped__c, RQ__r.Con__r.eidid__c,
                RQ__r.Con__r.eidedt__c, RQ__r.Con__r.eididt__c, RQ__r.Con__r.rpui__c, RQ__r.Con__r.jb__c,
                RQ__r.Con__r.jb__r.moh__c, RQ__r.Con__r.jb__r.jtm__c, RQ__r.Con__r.jb__r.jcm__c,
                RQ__r.Con__r.pid__c, RQ__r.Con__r.ped__c, RQ__r.Con__r.rlg__c, RQ__r.Con__r.ms__c,
                RQ__r.Con__r.np__c, RQ__r.xphid__c, RQ__r.Con__r.MobilePhone, RQ__r.Con__r.HomePhone,
                RQ__r.Con__r.ql__c, RQ__r.Con__r.mon__c, RQ__r.Con__r.lng__c, RQ__r.Con__r.jb__r.name,
                RQ__r.Con__r.jb__r.cd__c, RQ__r.Con__r.Salutation, RQ__r.Con__r.e__c, RQ__r.Con__r.rp__c,
                RQ__r.Con__r.rpid__c, RQ__r.Con__r.fan__c, RQ__r.Con__r.mona__c, RQ__r.Con__r.pipa__c,
                RQ__r.Con__r.bpa__c, RQ__r.Con__r.strt__c, RQ__r.Con__r.pobx__c, RQ__r.Con__r.ha__c,
                RQ__r.Con__r.Spon__r.rp__c, RQ__r.Con__r.Spon__r.e__c, RQ__r.Con__r.Spon__r.FirstName,
                RQ__r.Con__r.Spon__r.rol__c, RQ__r.Con__r.Spon__r.LastName, RQ__r.Con__r.Spon__r.fnar__c,
                RQ__r.Con__r.Spon__r.lnar__c, RQ__r.Con__r.Spon__r.nc__c, RQ__r.Con__r.Spon__r.Salutation,
                RQ__r.Con__r.Spon__r.Birthdate, RQ__r.Con__r.Spon__r.rpid__c, RQ__r.Con__r.Spon__r.rped__c,
                RQ__r.Con__r.Spon__r.p__c, RQ__r.Con__r.Spon__r.ped__c, RQ__r.Con__r.Spon__r.mon__c,
                RQ__r.Con__r.Spon__r.Name, RQ__r.Con__r.rol__c, RQ__r.Con__r.Spon__r.mn__c, RQ__r.Con__r.Spon__r.mnar__c,
                RQ__r.Con__r.emrt__c, RQ__r.Con__r.cty__c, RQ__r.Con__r.area__c, RQ__r.CreatedBy.Email,
                RQ__r.CreatedBy.MobilePhone, sta__r.jscfddt__c, sta__r.itm__r.cd__c, xcjb__r.cd__c,
                RQ__r.xcot__c, RQ__r.e__c, RQ__r.xctp__c, RQ__r.srvc__r.uid__c, RQ__r.xcslt__c, RQ__r.xcbc__c,
                RQ__r.xcjb__r.cd__c, RQ__r.xcpic__c, RQ__r.xcrlg__c, RQ__r.xcms__c, RQ__r.xcnp__c,
                RQ__r.xcql__c, RQ__r.xclng__c, RQ__r.xcmon__c, RQ__r.xcln__c, RQ__r.xclnar__c, RQ__r.xcfn__c,
                RQ__r.xcfnar__c, RQ__r.xcbp__c, RQ__r.xcpip__c, RQ__r.xcp__c, RQ__r.xcpid__c, RQ__r.xcped__c,
                RQ__r.xcbd__c, RQ__r.xcnc__c, RQ__r.xcmn__c, RQ__r.xcmnar__c, RQ__r.Spr__r.Name,
                RQ__r.Spr__r.nc__c, RQ__r.Con__r.Spon__r.MobilePhone, RQ__r.Spr__r.Salutation, RQ__r.xcsrs__c,
                RQ__r.Spr__r.e__c, RQ__r.Spr__r.rp__c, RQ__r.Spr__r.rpid__c, RQ__r.Spr__r.rped__c,
                RQ__r.Spr__r.Birthdate, RQ__r.Con__r.Spon__r.mgs__c, RQ__r.Spr__r.p__c, RQ__r.Spr__r.ped__c,
                RQ__r.Spr__r.mon__c, RQ__r.Spr__r.rol__c, RQ__r.Spr__r.FirstName, RQ__r.Spr__r.mn__c,
                RQ__r.Spr__r.mnar__c, RQ__r.Spr__r.Email, RQ__r.Spr__r.fnar__c, RQ__r.Spr__r.LastName,
                RQ__r.Spr__r.lnar__c, RQ__r.rmob__c, RQ__r.srvc__r.Name, xcjb__c, exp__c
                                             , itm__r.ilv__c, itm__r.elv__c, xaed__c, itm__r.cd__c FROM  g_reqitem__c WHERE EXP__c=:expPriority and RQ__r.Service_Code__c=:srvcIDs and itm__r.cd__c=:itmCd and (AP__c>0 or ((itm__r.cd__c='ai' or itm__r.cd__c='ofl') and AD__c=0)) and STA__r.cd__c =:stCd and  (RQ__r.STA__c ='Open' or RQ__r.STA__c ='In Process' or RQ__r.STA__c ='Under Review') and CALENDAR_YEAR(CreatedDate)>2016 Limit 200];

            //in ('001', '002', '020', '021', '040', '078') - srvcCds
            //in ('ep', 'la', 'exn', 'exu') - itmCd
            //////////////////////////////////
            map<String, g_reqitem__c>  mapRefReqItm = new map<String, g_reqitem__c>();
            String include;
            String exclude;

            IF(reqItmList.size()>0) {
                for (g_reqitem__c rqItm :reqItmList ) {
                    mapRefReqItm.put(String.ValueOf(rqItm.RQ__r.Name), rqItm);
                    if (rqItm.itm__r.ilv__c != null && String.IsBlank(include)) include= rqItm.itm__r.ilv__c;
                    if (rqItm.itm__r.elv__c != null && String.IsBlank(exclude)) exclude= rqItm.itm__r.elv__c;
                }
            }

            List<String> lst1 ;
            List<String> lst2;
            map<String, List<String>> inmapLst1 = new map<String, List<String>>();
            map<String, List<String>> exmapLst2 = new map<String, List<String>>();
            set<string> includeStatusList = new  set<string>();
            List<g_reqitem__c> newListRqItm = new List<g_reqitem__c>();
            if (itmCd=='rpmd') {include='md:ok;moh:ok;ia:ok';}

            if (String.isNotBlank(include) || String.isNotBlank(exclude) ) {
                if (String.isNotBlank(include)) lst1 = include.split(';');
                if (String.isNotBlank(exclude)) lst2 = exclude.split(';');
                if (lst1 != null && lst1.size()!=0) {
                    for (String str : lst1) {
                        List<String> nwLst = str.split(':');
                        if (inmapLst1.containsKey(nwLst[0])) {
                            List<String> statusList = inmapLst1.get(nwLst[0]);
                            statusList.add(nwLst[1]);
                            inmapLst1.put(nwLst[0], statusList);
                        }
                        else {
                            inmapLst1.put(nwLst[0], new List<String> {
                            nwLst[1] }
                            );
                        }
                        includeStatusList.add(nwLst[0]);
                    }
                }
                if (lst2 != null && lst2.size()!=0) {
                    for (String str : lst2) {
                        List<String> nwLst = str.split(':');
                        if (exmapLst2.containsKey(nwLst[0])) {
                            List<String> oldList = exmapLst2.get(nwLst[0]);
                            oldList.add(nwLst[1]);
                            exmapLst2.put(nwLst[0], oldList);
                        }
                        else {
                            exmapLst2.put(nwLst[0], new List<String> {
                            nwLst[1] }
                            );
                        }
                        includeStatusList.add(nwLst[0]);
                    }
                }
                List<String>  getallStatus = new List<String>();
                string itmCode;
                If(String.isBlank(exclude) ) {
                    for (String sts :includeStatusList ) {
                        if ( inmapLst1.containsKey(sts)) {
                            for (String s : inmapLst1.get(sts)) {
                                getallStatus.add(s);
                            }
                        }
                    }
                }
                If(String.isNotBlank(exclude) ) {
                    for (String sts :includeStatusList ) {
                        if ( exmapLst2.containsKey(sts)) {
                            for (String s : exmapLst2.get(sts)) {
                                getallStatus.add(s);
                            }
                        }
                    }
                }
                If(String.isBlank(exclude) ) {
                    newListRqItm = [Select Id, name, itmCd__c, itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name,
                        RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.prio__c, RQ__r.Account_Name__c,
                        RQ__r.Service__c, RQ__r.NationalityPassport__c, RQ__r.xfpc__c , STA__c, STA__r.cd__c,
                        STA__r.Name from g_reqitem__c where itmCd__c  in : inmapLst1.keySet() and sta__r.cd__c not in : getallStatus  and RQ__r.Name in : mapRefReqItm.keySet()];
                }
                else{
                    newListRqItm = [Select Id, name, itmCd__c, itm__r.ilv__c, itm__r.elv__c, itm__r.srvc__r.Name,
                        RQ__c, RQ__r.Name, RQ__r.STA__c, RQ__r.Con__c, RQ__r.prio__c, RQ__r.Account_Name__c,
                        RQ__r.Service__c, RQ__r.NationalityPassport__c, RQ__r.xfpc__c , STA__c, STA__r.cd__c,
                        STA__r.Name from g_reqitem__c where itmCd__c  in : exmapLst2.keySet() and sta__r.cd__c  in : getallStatus  and   RQ__r.Name in : mapRefReqItm.keySet()];
                }
                map<String, g_reqitem__c>  toRemovemapRefReqItm = new map<String, g_reqitem__c>();
                for (g_reqitem__c rqItm : newListRqItm ) {
                    toRemovemapRefReqItm.put(rqItm.RQ__r.Name, rqItm);
                }
                if (String.isBlank(exclude)) {
                    for (g_reqitem__c rqItm : newListRqItm ) {
                        toRemovemapRefReqItm.put(String.ValueOf(rqItm.RQ__r.Name), rqItm);
                        if ((mapRefReqItm.containsKey(rqItm.RQ__r.Name)) ) {
                            mapRefReqItm.remove(rqItm.RQ__r.Name) ;
                        }
                    }
                    for (g_reqitem__c rqItm : reqItmList ) {
                        if (mapRefReqItm.containsKey(rqItm.RQ__r.Name) ) {
                            finalListRqItm.add(mapRefReqItm.get(rqItm.RQ__r.Name));
                        }
                    }
                }
                else if (String.isNotBlank(exclude)) {
                    for (g_reqitem__c rqItm : reqItmList ) {
                        if ((mapRefReqItm.containsKey(rqItm.RQ__r.Name)) && toRemovemapRefReqItm.containsKey(rqItm.RQ__r.Name)) {
                            system.debug('#################rqItm.RQ__r.Name#################1'+rqItm.RQ__r.Name);
                            /* if (itmCd=='md' &&  srvd=='001, 002, 003, 004, 021, 078, 040, 020') {
                                if (epmapRefReqItm != null && !epmapRefReqItm.isEmpty() && !epmapRefReqItm.containsKey(rqItm.RQ__r.Name)) {
                                    finalListRqItm.add(mapRefReqItm.get(rqItm.RQ__r.Name));
                                }
                            }
                            else{
                                finalListRqItm.add(mapRefReqItm.get(rqItm.RQ__r.Name));
                            }
                            */  finalListRqItm.add(mapRefReqItm.get(rqItm.RQ__r.Name));
                        }
                    }
                }
            }

            if (finalListRqItm.size()==0) {
                if (String.isBlank(exclude) && String.isBlank(include)) {
                    finalListRqItm.addAll(reqItmList);
                }else{

                }

            }

            if (String.isNotBlank(itmCd) && (itmCd.equalsIgnoreCase('la') || itmCd.equalsIgnoreCase('ai'))) {
                medReqItems = [Select Id, RQ__r.Id, Name, itm__r.cd__c, exp__c, RQ__r.Name FROM g_reqitem__c WHERE RQ__r.Name in:mapRefReqItm.keySet() AND itm__r.cd__c in ('md',
                    'moh') AND exp__c=true];
            }
        }catch (Exception e) {
            system.debug(e.getMessage());
        }

        //mapRefReqItm

        Set<String> expReq = new Set<String>();
        for (g_reqitem__c itm : medReqItems) {
            expReq.add(itm.RQ__r.Name);
        }

        for (g_reqitem__c itm : finalListRqItm) {
            if ((itmCd.equalsIgnoreCase('la') || itmCd.equalsIgnoreCase('ai')) && expReq.contains(itm.RQ__r.Name)) {
               itm.exp__c = true;
            }
        }
        if (exp && String.isNotBlank(itmCd) && (itmCd.equalsIgnoreCase('la') || itmCd.equalsIgnoreCase('ai'))) {
         for (g_reqitem__c itm : finalListRqItm) {
            if (itm.exp__c && exp) {
              expFnListRqItm.add(itm);
            }
        }
          JSONString = JSON.serialize(expFnListRqItm);
        }else{

         JSONString = JSON.serialize(finalListRqItm);
        }

        System.debug('Serialized list of invoices into JSON format: ' + JSONString);

        return JSONString;
    }

    global class rpaResp {webService String respCode, status, respMsg, SRN, AxsId;}
    global class rpaReq  {webService String reqNum, srvcd, itmCd, expPriority;}

}