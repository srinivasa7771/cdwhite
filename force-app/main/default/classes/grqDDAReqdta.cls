public class grqDDAReqdta {
     public Account Acc{get;set;}
    public g_Req__c rq{get;set;}
    public List<loc__c> regOffnew{get;set;}
    public Transient List<grqWsDccaGetService.Records> tecomLeaseList {get;set;}// to be set
    public Transient List<grqWsDccaGetService.Records> tecomd3LsList {get;set;}
    public  String leaseDt{get;set;}// to be set
    public map<String, Integer> priceMap {get;set;}
    public map<String, Integer> chanTMap {get;set;}
    public map<String, Integer> addMainOffMap {get;set;}
    public  Boolean brodcastFlag{get;set;}
    public String ddaReqStatus{get;set;}
    public  Boolean fine30Flag{get;set;}
    public  Boolean fine60Flag{get;set;}
    public  Boolean fine90Flag{get;set;}
    public  Integer fine30amount{get;set;}
    public  Integer fine60amount{get;set;}
    public  Integer fine90amount{get;set;}
    public String sanc{get;set;}
    public boolean sancflag{get;set;}
    public  Boolean spFlaf{get;set;}
    public String managerNation{get;set;}
    public String  managerNationA{get;set;}
    public String mangerName{get;set;}
    public String  mangerNameA{get;set;}
    public String idRec{get;set;}
    public String shareHldType{get;set;}

    public boolean uboFlg{get;set;}

    /**  public grqDDAReqdta() {
Acc= new Account();
rq= new g_Req__c();
}**/
    public void setDCCAReqValues() {
        system.debug('########################setDCCAReqValues###########################');
        try {
            //String dccaRes='{"Data":[{"name":"REQ-00212423", "mangerNameA":"عزت علي حسين الدوري", "mangerName":"Mr. Ezzat Ali Hussein Al-Doori", "lines":[{"segment":null, "lineName":"Knowledge Dirham", "amount":10, "activity":null}, {"segment":null, "lineName":"Innovation Dirham", "amount":10, "activity":null}, {"segment":"Consultancy", "lineName":"Consultancy - Project Management Consultancy", "amount":15000, "activity":"Project Management Consultancy"}, {"segment":"Design", "lineName":"Design - Concept Design", "amount":10000, "activity":"Concept Design"}, {"segment":"Design", "lineName":"Design - Consultancy (Free for Segment:Design)", "amount":0, "activity":"Consultancy"}, {"segment":"Design", "lineName":"Design - Architectural Design (Free for Segment:Design)", "amount":0, "activity":"Architectural Design"}], "licNo":"92063", "idRec":"a1C5D000000Tf4SUAS", "expDate":"2020-02-26", "docs":[{"name":"A copy of Valid Lease Agreement", "isRequired":true}, {"name":"Original Certificate of Good Standing", "isRequired":true}], "amount":25020}]}';
            //system.debug('JJJ Acc license No'+Acc.lc__c);
            boolean amdFlg = false;
            if (rq.xmloc__c && rq.xcawp__c) {
                regOffnew = [select lstyp__c, plt__c, pltarb__c, offno__c, flr__c, Bldg__c, bu__c, Loc__c from loc__c where isregof__c =: true and acc__c =: Acc.id and IsActive__c =: true limit 1];
            }
            if (rq.xpmsle__c && rq.xmamd__c)
                amdFlg = true;
            //
            // leaseDt=String.ValueOf(Acc.lcedt__c);
            system.debug(tecomLeaseList);
            system.debug('########################leaseDt###########################' + leaseDt);
            system.debug('########################rq.xdedln__c###########################' + rq.xdedln__c);

            leaseDt = String.ValueOf(rq.xdedln__c);
            if (leaseDt != null)
                leaseDt = grqWsDccaGetService.formatDt2(leaseDt);
            if (leaseDt == null) {
                leaseDt = String.ValueOf(Acc.lcedt__c);
            }
            system.debug('########################leaseDt22###########################' + leaseDt);
            //  leaseDt='11-12-2019';
            //system
            system.debug('########################leaseDt44444###########################' + leaseDt);
            system.debug('########################leaseDtrq.xdei__c###########################' + rq.xdei__c + 'Acc.lc__c::' + Acc.lc__c + 'leaseDt1::' + leaseDt);

            // for land lease and sublease  after approval
            if (rq.xcawp__c || rq.xmloc__c) {
                system.debug('########################leaseDt22###########################' + rq.xcbd__c);
                leaseDt = String.ValueOf(rq.xcbd__c);
                system.debug('########################leaseDt22###########################' + leaseDt);

                if (leaseDt != null) {
                    String[] str = leaseDt.split('-');

                    rq.xdedln__c = str[2] + '/' + str[1] + '/' + str[0];
                    system.debug('########################rq.xdedln__c###########################' + rq.xdedln__c);
                }
            }
            system.debug('########################leaseDtrq.xdei__c###########################' + rq.xdei__c + 'Acc.lc__c::' + Acc.lc__c + 'leaseDt::' + leaseDt);
            system.debug('####dccaRes1######Acc.lc__c#####################' + Acc.lc__c);
            system.debug('####dccaRes1###########leaseDt################' + leaseDt);
            system.debug('####dccaRes1############rq.xdei__c###############' + rq.xdei__c);

                String dccaRes = grqWsDccaGetService.getReqDetails(Acc.lc__c, leaseDt, rq.xdei__c, amdFlg);
            system.debug('---dccaRes Today11--' + dccaRes);
            if (rq.xdedln__c == null) {
                leaseDt = grqWsDccaGetService.formatDt(String.ValueOf(Acc.lcedt__c));
            }
            //String dccaRes = grqWsDccaGetService.getReqDetails(Acc.lc__c, '01-09-2018');
            system.debug('REquest Deatils@@@@@@@@@@@@@@@@@' + dccaRes);
            if (String.isNotBlank(dccaRes)) {
                grqWsDccaGetService jj = (grqWsDccaGetService) System.JSON.deserialize(dccaRes, grqWsDccaGetService.class);
                /* only for university to recalculate the expiry date*/
                if (jj.Data.get(0).errorCode != '1' && jj.Data.get(0).isUniv) {
                    rq.xcebr__c = jj.Data.get(0).isUniv;
                    system.debug('jj.Data.get(0).isUniv' + jj.Data.get(0).isUniv);
                    system.debug('####dccaRes2######leaseexp#####################' + rq.xdedln__c);
                    system.debug('####dccaRes2######Acc.lc__c#####################' + Acc.lc__c);
                    string x = rq.xdedln__c;
                    Date leaseexp = null;
                    if (!string.isblank(rq.xdedln__c)) {
                        leaseexp = date.parse(x);
                    } else {
                        leaseexp = Acc.lcedt__c;
                    }
                    system.debug('####dccaRes2######leaseexp---#####################' + leaseexp);
                    Date currentLicExp = Acc.lcedt__c;
                    Date UniEpDt = Date.newInstance(Date.today().Year(), 03, 31);
                    Date newUniExpDate = Date.newInstance(Date.today().Year() + 1, 03, 31);
                    Integer nays = currentLicExp.daysBetween(UniEpDt);
                    if (nays >= 30) {
                        newUniExpDate = UniEpDt;
                    }

                    if (leaseexp > Date.today()) {
                        Integer NooOfDays = currentLicExp.daysBetween(newUniExpDate);
                        system.debug('NooOfDays--' + NooOfDays);
                        if (NooOfDays > 30) {
                            leaseexp = newUniExpDate;
                            leaseDt = newUniExpDate.year() + '-' + newUniExpDate.month() + '-' + newUniExpDate.day();
                            system.debug('####dccaRes2######Acc.lc__c#####################' + Acc.lc__c);
                            system.debug('####dccaRes2###########leaseDt################' + leaseDt);
                            system.debug('####dccaRes2############rq.xdei__c###############' + rq.xdei__c);

                            // rq.xdei__c='a066F000014iGWXQA2';
                            dccaRes = grqWsDccaGetService.getReqDetails(Acc.lc__c, leaseDt, rq.xdei__c, amdFlg);
                            system.debug('####dccaRes2###########################' + dccaRes);
                            jj = (grqWsDccaGetService) System.JSON.deserialize(dccaRes, grqWsDccaGetService.class);
                            system.debug('####jj###########################' + jj);
                            rq.xcbd__c = newUniExpDate;
                            if (leaseDt != null) {
                                String[] str = leaseDt.split('-');
                                rq.xcbd__c = Date.newInstance(Date.today().Year() + 1, 03, 31);
                                rq.xdedln__c = str[2] + '/' + str[1] + '/' + str[0];
                                system.debug('########################rq.xdedln__c###########################' + rq.xdedln__c);
                            }
                        }
                    }
                } /* only for university to recalculate the expiry date end*/

                //grqWsDccaGetService.Data.parse(dccaRes);
                if (jj.Data.get(0).errorCode != '1') {
                    system.debug('REquest Deatils@@@@@@@@@@@@@@@@@1');
                    if (jj.Data.get(0).amount == 20) {
                        rq.xtpa__c = 0;
                    } else {
                        rq.xtpa__c = jj.Data.get(0).amount;
                    }

                    if (jj.Data.get(0).status != null) {
                        ddaReqStatus = jj.Data.get(0).status;
                    }

                    if (jj.Data.get(0).sancs != null && jj.Data.get(0).sancs.size() > 0) {
                        if (jj.Data.get(0).isRenewalAllowed == false) {
                            sancflag = true;
                            List < grqWsDccaGetService.sanctions > strLst = new List < grqWsDccaGetService.sanctions > ();
                            //List<String> strLst = new List<String>();
                            strLst.addAll(jj.Data.get(0).sancs);
                            for (grqWsDccaGetService.sanctions st: strLst) {
                                if (string.isBlank(sanc)) {
                                    sanc = 'Sanction has been added to the Company .';
                                    //'Below Sanction has been added to Account :';
                                    //sanc = sanc + '<li>'+st.sancdescriprtion +'</li>';
                                }
                                /**else{
sanc = sanc + '<li>'+st.sancdescriprtion+'</li>';
}**/
                            }
                            sanc = sanc + 'For more information please contact 800-4-DDA (332) OR 800 4 AXS(297).';
                        }
                    }

                    /** UBO FLAG ****/

                    if (jj.Data.get(0).isUBORequired == true && jj.Data.get(0).isUBOSubmitted == false) {
                        uboFlg = true;
                    }

                    /*** UBO FLAG END***/

                    Date today = Date.today();
                    Date expDt = Acc.lcedt__c != null ? Acc.lcedt__c : today;
                    Integer dueDays = expDt.daysBetween(today);
                    //rq.xcfn__c=jj.Data.get(0).mangerName;
                    //rq.xcfnar__c=jj.Data.get(0).mangerNameA;
                    mangerName = jj.Data.get(0).mangerName;
                    mangerNameA = jj.Data.get(0).mangerNameA;
                    if (String.isNotBlank(jj.Data.get(0).sme)) {
                        String smeType = jj.Data.get(0).sme;
                        if (smeType == 'SME-In5') {
                            rq.xcmn__c = 'SMEIN5';
                        } else if (smeType.containsIgnoreCase('sme')) {
                            rq.xcmn__c = 'SME';
                        } else {
                            rq.xcmn__c = jj.Data.get(0).licType;
                        }
                    } else {
                        rq.xcmn__c = jj.Data.get(0).licType;
                    }

                    if (String.isNotBlank(jj.Data.get(0).leaseType)) {
                        if (jj.Data.get(0).leaseType == 'PMS Lease' || jj.Data.get(0).leaseType.contains('PMS')) {
                            rq.xpmsle__c = true;
                        }
                    }
                    // SME-In5
                    //  rq.xcmn__c=jj.Data.get(0).licType;
                    /**rq.xcln__c=jj.Data.get(0).managerNation;
rq.xclnar__c=jj.Data.get(0).managerNationA;
rq.xdei__c = jj.Data.get(0).idRec;
rq.xeng__c= jj.Data.get(0).shareHldType; **/
                    managerNation = jj.Data.get(0).managerNation;
                    managerNationA = jj.Data.get(0).managerNationA;
                    idRec = jj.Data.get(0).idRec;
                    shareHldType = jj.Data.get(0).shareHldType;
                    String shrhld = jj.Data.get(0).shareHldType;

                    if (shrhld != null && Acc.Legal_Framework__c == 'Free Zone Limited Liability Company' && shrhld.indexOf('Corporate') != -1) {

                        rq.x30gr__c = true;
                    }
                    else if (Acc.Legal_Framework__c == 'Branch of a Foreign Company' || Acc.Legal_Framework__c == 'Branch of a UAE Company' || Acc.Legal_Framework__c == 'Branch of a UAE Establishment') {

                        rq.x30gr__c = true;
                    }
                    // rq.xdedln__c=jj.Data.get(0).licNo;

                    rq.xdccaRq__c = dccaRes;
                    system.debug(jj.Data.get(0).amount);

                    rq.xdedc__c = gU.AmountInWords(rq.xtpa__c.intValue());
                    system.debug(jj.Data.get(0).name);
                    system.debug(jj.Data.get(0).mangerNameA);
                    system.debug(jj.Data.get(0).mangerName);
                    system.debug(jj.Data.get(0).licNo);
                    system.debug(jj.Data.get(0).expDate);

                    brodcastFlag = jj.Data.get(0).buRecomendation;

                    priceMap = new Map < String, Integer > ();
                    chanTMap = new Map < String, Integer > ();
                    addMainOffMap = new Map < String, Integer > ();
                    for (Integer i = 0; i < jj.Data.get(0).lines.size(); i++) {
                        system.debug(jj.Data.get(0).lines.get(i).segment);
                        system.debug(jj.Data.get(0).lines.get(i).activity);
                        system.debug(jj.Data.get(0).lines.get(i).amount);
                        String seg = jj.Data.get(0).lines.get(i).segment;
                        String act = jj.Data.get(0).lines.get(i).lineName;
                        List < String > sancList = new List < String > ();
                        //if (jj.Data.get(0).sancs != null) sancList.add(jj.Data.get(0).sancs);
                        //if (sancList != null && ) {
                        //  sancflag= true;
                        //}

                        if (priceMap != null && seg != null && seg != 'null' && seg.length() > 0 && !priceMap.containsKey(jj.Data.get(0).lines.get(i).segment) && priceMap.get(jj.Data.get(0).lines.get(i).segment) != 0) {
                            priceMap.put(jj.Data.get(0).lines.get(i).segment, jj.Data.get(0).lines.get(i).amount);
                        }
                        else if (priceMap != null && seg != null && seg != 'null' && seg.length() > 0 && priceMap.containsKey(jj.Data.get(0).lines.get(i).segment) && jj.Data.get(0).lines.get(i).amount != 0) {
                            Integer x = priceMap.get(jj.Data.get(0).lines.get(i).segment);
                            priceMap.put(jj.Data.get(0).lines.get(i).segment, jj.Data.get(0).lines.get(i).amount + x);
                        }
                        else if (priceMap != null && act != null && act != 'null' && act != 'Knowledge Dirham' && act != 'Innovation Dirham' && (seg == null || seg == 'null') && (act != null && act != 'null') && !priceMap.containsKey(act)) {
                            chanTMap.put(act, jj.Data.get(0).lines.get(i).amount);
                        }

                        if (seg != null && seg.containsIgnoreCase('Over Due for 31-60 Days')) {
                            Integer x = priceMap.get(jj.Data.get(0).lines.get(i).segment);
                            if (x != null && x > 0) {
                                fine30amount = x;
                                fine30Flag = true;
                            }
                        }

                        if (seg != null && seg.containsIgnoreCase('Over Due 61-90 Days')) {
                            Integer x = priceMap.get(jj.Data.get(0).lines.get(i).segment);
                            if (x != null && x > 0) {
                                fine60amount = x;
                                fine60Flag = true;
                            }
                        }

                        if (seg != null && seg.containsIgnoreCase('Over Due over 91 Days')) {
                            Integer x = priceMap.get(jj.Data.get(0).lines.get(i).segment);
                            if (x != null && x > 0) {
                                fine90amount = x;
                                fine90Flag = true;
                            }
                        }

                        if (seg != null && (seg.equalsIgnoreCase('Support Service Provider') || seg.equalsIgnoreCase('Service Provider'))) {
                            spFlaf = true;
                        }

                    }
                    if (priceMap.isEmpty()) {
                        priceMap = null;
                    } else {
                        priceMap = gU.mapSort(priceMap);
                    }

                    String nts;
                    if (jj.Data.get(0).actspeNotes != null && String.isNotBlank(jj.Data.get(0).actspeNotes)) {
                        List < String > strLst = String.ValueOf(jj.Data.get(0).actspeNotes).split(';');
                        for (String str: strLst) {
                            if (String.isBlank(nts)) {
                                nts = '  • ' + str + '\n';
                            } else {
                                nts = nts + '\n' + '  • ' + str;
                            }
                        }
                    }
                    if (String.isNotBlank(nts)) {
                        rq.nt__c = nts;
                    }

                    String Docs = '';
                    String Docs2 = '<ul>';
                    set < String > uniqueDoc = new set < String > ();
                    String repDoc = '';
                    for (Integer i = 0; jj.Data.get(0).docs != null && i < jj.Data.get(0).docs.size(); i++) {

                        if (jj.Data.get(0).docs.get(i).shareHolderName != null) {
                            Docs = Docs + jj.Data.get(0).docs.get(i).name + ':' + jj.Data.get(0).docs.get(i).shareHolderName + ';';

                            //  newDocToCreat.add(jj.Data.get(0).docs.get(i).name +'(' +jj.Data.get(0).docs.get(i).shareHolderName +')');
                        } else {

                            Docs = Docs + jj.Data.get(0).docs.get(i).name + ';';

                        }

                        if (jj != null) { //&& !Docs2.contains(jj.Data.get(0).docs.get(i).name)
                            // system.debug('Docs2 Docs2'+Docs2);
                            // Account and License Name update
                            if (jj.Data.get(0).legaleng != null) rq.xcne__c = jj.Data.get(0).legaleng;
                            if (jj.Data.get(0).legalarabic != null) rq.xcna__c = jj.Data.get(0).legalarabic;
                            if (jj.Data.get(0).lincenseeeng != null) rq.xlne__c = jj.Data.get(0).lincenseeeng;
                            if (jj.Data.get(0).lincenseearabic != null) rq.xlna__c = jj.Data.get(0).lincenseearabic;
                            if (jj.Data.get(0).frameworkeng != null) rq.xalfe__c = jj.Data.get(0).frameworkeng;
                            if (jj.Data.get(0).businessPArk != null) rq.xaccbrand__c = jj.Data.get(0).businessPArk;
                            // Account and License Name update

                            if (string.isBlank(Docs2)) {
                                if (jj.Data.get(0).docs.get(i).shareHolderName != null) {
                                    Docs2 = '<li>' + jj.Data.get(0).docs.get(i).name + '(' + jj.Data.get(0).docs.get(i).shareHolderName + ') </li>';
                                    uniqueDoc.add(jj.Data.get(0).docs.get(i).name + jj.Data.get(0).docs.get(i).shareHolderName);
                                } else {
                                    if (jj.Data.get(0).docs.get(i).name != 'Approval from Publishing Committee' && jj.Data.get(0).docs.get(i).name != 'Approval from Broadcasting Committee')
                                        uniqueDoc.add(jj.Data.get(0).docs.get(i).name);
                                    Docs2 = '<li>' + jj.Data.get(0).docs.get(i).name + '</li>';
                                }
                            } else {
                                // repDoc=jj.Data.get(0).docs.get(i).name;
                                if (jj.Data.get(0).docs.get(i).shareHolderName != null && !uniqueDoc.contains(jj.Data.get(0).docs.get(i).name + jj.Data.get(0).docs.get(i).shareHolderName)) {
                                    Docs2 = Docs2 + '<li>' + jj.Data.get(0).docs.get(i).name + '(' + jj.Data.get(0).docs.get(i).shareHolderName + ') </li>';
                                    uniqueDoc.add(jj.Data.get(0).docs.get(i).name + jj.Data.get(0).docs.get(i).shareHolderName);
                                } else {
                                    if (!uniqueDoc.contains(jj.Data.get(0).docs.get(i).name) && jj.Data.get(0).docs.get(i).name != 'Approval from Publishing Committee' && jj.Data.get(0).docs.get(i).name != 'Approval from Broadcasting Committee')
                                        //repDoc=jj.Data.get(0).docs.get(i).name;
                                        Docs2 = Docs2 + '<li>' + jj.Data.get(0).docs.get(i).name + '</li>';
                                    uniqueDoc.add(jj.Data.get(0).docs.get(i).name);
                                }
                            }
                            // system.debug(uniqueDoc+'uniqueDoc XXXX');
                        }
                    }

                    if (Docs == ';') {
                        Docs = '';
                    }
                    Set < String > newSetDoc = new Set < String > ();
                    String newDocs;
                    if (Docs != null) {
                        String[] docString = Docs.split(';');
                        for (string str: docString) {
                            if (!newSetDoc.contains(str))
                                newSetDoc.add(str);
                        }
                        for (string setStr: newSetDoc) {
                            if (newDocs != null) {
                                newDocs = newDocs + setStr + ';';
                            } else {
                                newDocs = setStr + ';';
                            }
                        }
                    }
                    if (newDocs == ';') {
                        newDocs = '';
                    }
                    if (newDocs.contains('Certificate of Good Standing issued by the Registrar of Companies (if applicable as per Legal Framework);')) {
                        newDocs.replace('Certificate of Good Standing issued by the Registrar of Companies (if applicable as per Legal Framework);',
                            'Certificate of Good Standing issued by the Registrar of Companies;');
                    }
                    if (rq.xpmsle__c) {
                        integer ejariCnt = 0;
                        if (String.isNotBlank(rq.xadtx2__c) && String.isNotBlank(rq.xvnum__c)) {
                            List < PMSDataWrapper.ContractInformation > ejariContractlist = (List < PMSDataWrapper.ContractInformation > ) JSON.deserialize(rq.xadtx2__c,
                                List < PMSDataWrapper.ContractInformation > .class);
                            if (ejariContractlist != null && !ejariContractlist.isEmpty())
                                ejariCnt = ejariContractlist.size();
                        }
                        if (ejariCnt == 0) {
                            newDocs = newDocs + 'A copy of Valid Lease Agreement or Ejari certificate;';
                            Docs = Docs + 'A copy of Valid Lease Agreement or Ejari certificate;';
                        } else {
                            for (integer i = 1; i <= ejariCnt; i++) {
                                newDocs = newDocs + 'Ejari certificate:' + i + ';';
                                Docs = Docs + 'Ejari certificate:' + i + ';';
                            }
                        }

                    }
                    if (String.isBlank(newDocs)) {
                        rq.xcddocs__c = Docs;
                    } else {
                        rq.xcddocs__c = newDocs;
                    }

                    if (rq.xcddocs__c == ';') {
                        rq.xcddocs__c = '';
                    }

                    Docs2 = Docs2 + '</ul>';
                    rq.xuvdet__c = Docs2;
                    if (rq.xuvdet__c != null && (rq.xuvdet__c).contains('Copy of Occupational Agreement')) {
                        rq.xuvdet__c = rq.xuvdet__c.replace('Copy of Occupational Agreement', '');

                    }
                    if (rq.xcddocs__c != null && ((rq.xcddocs__c).contains('Community fee') || (rq.xcddocs__c).contains('Community Fee'))) {
                        rq.xcddocs__c = rq.xcddocs__c.replace('Community Fee', 'Partner Service Fee');
                        rq.xcddocs__c = rq.xcddocs__c.replace('Community Fee', 'Partner Service Fee');

                    }

                    if (rq.xuvdet__c != null && ((rq.xuvdet__c).contains('Community fee') || (rq.xuvdet__c).contains('Community Fee'))) {
                        rq.xuvdet__c = rq.xuvdet__c.replace('Community fee', 'Partner Service Fee');
                        rq.xuvdet__c = rq.xuvdet__c.replace('Community Fee', 'Partner Service Fee');

                    }

                    if (rq.xuvdet__c != null && rq.xuvdet__c.contains('Certificate of Good Standing issued by the Registrar of Companies (if applicable as per Legal Framework);')) {
                        rq.xuvdet__c = rq.xuvdet__c.replace('Certificate of Good Standing issued by the Registrar of Companies (if applicable as per Legal Framework);',
                            'Certificate of Good Standing issued by the Registrar of Companies;');
                    }

                    if (rq.xcddocs__c != null && rq.xcddocs__c.contains('Certificate of Good Standing issued by the Registrar of Companies (if applicable as per Legal Framework)')) {
                        rq.xcddocs__c = rq.xcddocs__c.replace('Certificate of Good Standing issued by the Registrar of Companies (if applicable as per Legal Framework)',
                            'Certificate of Good Standing issued by the Registrar of Companies');
                    }

                    if (rq.xcddocs__c != null && rq.xcddocs__c.contains('Approval from Broadcasting Committee')) {
                        //rq.xcddocs__c= rq.xcddocs__c.replace('Approval from Broadcasting Committee', '')  ;
                    }
                    if (rq.xcddocs__c != null && rq.xcddocs__c.contains('Approval from Broadcasting Committee;')) {
                        //rq.xcddocs__c= rq.xcddocs__c.replace('Approval from Broadcasting Committee;', '')  ;
                    }
                    if (rq.xcddocs__c != null && rq.xcddocs__c.contains('Approval from Publishing Committee')) {
                        // rq.xcddocs__c= rq.xcddocs__c.replace('Approval from Publishing Committee', '');
                    }
                    if (rq.xcddocs__c != null && rq.xcddocs__c.contains('Approval from Publishing Committee;')) {
                        // rq.xcddocs__c= rq.xcddocs__c.replace('Approval from Publishing Committee;', '')  ;
                    }

                    if (Acc.Legal_Framework__c != 'Freelancer' && (tecomLeaseList == null || (tecomLeaseList != null && tecomLeaseList.size() == 0 && tecomd3LsList != null && tecomd3LsList.size() == 0))) {

                        if ((rq.AP__c == null || (rq.AP__c != null && rq.AP__c == 0)) && rq.xcddocs__c != null && !rq.xcddocs__c.contains('A copy of Valid Lease Agreement;')) {
                            rq.xcddocs__c = rq.xcddocs__c + 'A copy of Valid Lease Agreement;';

                        } else if ((rq.AP__c == null || (rq.AP__c != null && rq.AP__c == 0)) && !rq.xcddocs__c.contains('A copy of Valid Lease Agreement;')) {
                            rq.xcddocs__c = 'A copy of Valid Lease Agreement;';
                        }

                        // rq.xuvdet__c
                        rq.x30gr__c = false;
                        if (!amdFlg)
                         rq.xmloc__c = true;
                    } else {
                        rq.xmloc__c = false;
                    }

                } else {
                    rq.xcha__c = jj.Data.get(0).errorMessage;
                }
            }
            system.debug('REquest Deatils@@@@@@@@@@@@@@@@@5');
        } catch (Exception e) {

            system.debug(e.getMessage());
        }

    }

    // new Licence

    public void setNewDDAReqValues() {
        system.debug('########################setNewDDAReqValues###########################');
        try {
            priceMap = new Map < String, Integer > ();
            grqWsDccaGetService jj;
            String dccaRes = grqWsDccaGetService.getNewReqDetails('REQ-00227922');
            if (String.isNotBlank(dccaRes)) {
                jj = (grqWsDccaGetService) System.JSON.deserialize(dccaRes, grqWsDccaGetService.class);
            }
            system.debug(jj);
            rq.xdccaRq__c = dccaRes;
            /*calculate price */ for (Integer i = 0;
            i < jj.Data.get(0).lines.size();
            i++) {
                system.debug(jj.Data.get(0).lines.get(i).segment);
                system.debug(jj.Data.get(0).lines.get(i).activity);
                system.debug(jj.Data.get(0).lines.get(i).amount);
                String seg = jj.Data.get(0).lines.get(i).segment;
                String act = jj.Data.get(0).lines.get(i).lineName;
                List < String > sancList = new List < String > ();
                system.debug('lines11:' + jj.Data.get(0).lines);
                priceMap.put(jj.Data.get(0).lines.get(i).lineName, jj.Data.get(0).lines.get(i).amount);
                if (seg != null && (seg.equalsIgnoreCase('Support Service Provider') || seg.equalsIgnoreCase('Service Provider'))) {
                    spFlaf = true;
                }
            }
            if (priceMap.isEmpty()) {
                priceMap = null;
            }
            else {
                priceMap = gU.mapSort(priceMap);
            }
            /*// to get documents*/ String Docs = '';
            String toUpDocs = '';
            String Docs2 = '<ul>';
            set < String > uniqueDoc = new set < String > ();
            String repDoc = '';
            for (Integer i = 0;
            jj.Data.get(0).docs != null && i < jj.Data.get(0).docs.size();
            i++) {
                /*uniqueDoc.add(jj.Data.get(0).docs.get(i).name);
                */ Docs = Docs + '<li>' + jj.Data.get(0).docs.get(i).name + '</li>';
                toUpDocs = toUpDocs + jj.Data.get(0).docs.get(i).name + ';';
            }
            Docs2 = Docs2 + Docs + '</ul>';
            if (toUpDocs == ';') {
                toUpDocs = '';
            }
            Set < String > newSetDoc = new Set < String > ();
            String newDocs;
            if (toUpDocs != null) {
                String[] docString = toUpDocs.split(';');
                for (string str: docString) {
                    if (!newSetDoc.contains(str)) newSetDoc.add(str);
                }
                for (string setStr: newSetDoc) {
                    if (newDocs != null) {
                        newDocs = newDocs + setStr + ';';
                    }
                    else {
                        newDocs = setStr + ';';
                    }
                }
            }
            if (String.isBlank(newDocs)) {
                rq.xcddocs__c = Docs;
            }
            else {
                rq.xcddocs__c = newDocs;
            }
            rq.xcddocs__c = Docs2;
            if (rq.xcddocs__c == ';') {
                rq.xcddocs__c = '';
            }
            rq.xuvdet__c = Docs2;
            system.debug('doc11::' + rq.xcddocs__c);
            system.debug('doc22::' + rq.xuvdet__c);
        }
        catch (Exception e) {
            system.debug('ex::' + e.getStackTraceString());
        }
    }

}