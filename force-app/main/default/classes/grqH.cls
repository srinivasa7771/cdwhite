public with sharing class grqH{

    /*** Variables ****/
    /*---- Variables to prevent recursive trigger calls */
    public static Boolean rBefore=true;
    public static Boolean rAfter=false;
    public static Boolean iBefore=true;
    public static Boolean iAfter=false;
    public static Boolean cBefore=true;
    /*---- Variables for bRules Data to be loaded only once (Before and After Triggers)*/
    //common variables
    private static boolean isShifted = true;
    private static Integer toDay=28800000;
    private static Integer toHour=3600000;
    //rH variables
    private static list<Document> mrdRL;//bRules files
    private static map<Id, g_Srvc__c> mSrvcs;
    private static map<Id, Account> mAccs;
    private static map<Id, Decimal> mVisitors;//Visitors count
    private static map<Id, User> mrUsrs;
    private static map<Id, Contact> mrCtcts;
    //iH variables
    private static BusinessHours mBH;
    private static list<Document> midRL;//bRules files
    public static map<Id, g_srvcitm_Status__c> mSTAs;
    public static map<Id, g_Req__c> mRqs;
    public static map<Id, User> miUsrs;
    public static map<Id, Contact> miCtcts;
    public static void reInit4Test() {
        rBefore=true;
        rAfter=false;
        iBefore=true;
        iAfter=false;
        mrdRL=null;
        mSrvcs=null;
        mAccs=null;
        mVisitors=null;
        mrUsrs=null;
        mrCtcts=null;
        mBH=null;
        midRL=null;
        mSTAs=null;
        mRqs=null;
        miUsrs=null;
        miCtcts=null;
    }
    /*** Generic Handlers ****/
    //private static void updDocCnt(list<Attachment> Ats, Boolean bInc) {set<Id> ids = new set<Id>();for (Attachment A: Ats) {if (A.ParentId.getSObjectType() == g_reqDoc__c.sObjectType) {ids.add(A.ParentId);}}if (ids.size()>0) {list<g_reqDoc__c> docs = [select Id, ats__c from g_reqDoc__c where id in: ids];for (g_reqDoc__c d: docs) {d.ats__c=d.ats__c == null?(bInc?1:0):d.ats__c+(bInc?1:d.ats__c == 0?0:-1);}update docs;}}

    private static void updDocCnt(list < Attachment > Ats, Boolean bInc) {
        set < Id > ids = new set < Id > ();
        for (Attachment A: Ats) {
            if (A.ParentId.getSObjectType() == g_reqDoc__c.sObjectType) {
                ids.add(A.ParentId);
            }
        }
        if (ids.size() > 0) {
            list < g_reqDoc__c > docs = [select Id, Name, ats__c, RQ__r.Service_Code__c, RQ__c,
                RQ__r.xdei__c from g_reqDoc__c where id in: ids and name not in ('Member(s) Resolution',
                'Director(s) Resolution')];
            ///*US APD3911*/

            system.debug('###@##@##@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#');
            for (g_reqDoc__c d: docs) {
                system.debug('Name-------'+d.Name);
                system.debug('ats__c-------'+d.ats__c);
                system.debug('bInc-------'+bInc);

                d.ats__c = d.ats__c == null ? (bInc ? 1 : 0) : d.ats__c + (bInc ? 1 : -1);
                if (!bInc  && d.ats__c<0) {d.ats__c=0;}
                system.debug('d.ats__c-------'+d.ats__c);
            }
            system.debug('###@##@##@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#@#');

            if (Schema.sObjectType.g_reqDoc__c.isUpdateable()) {
                update docs;
            }
        }
    }

    private static void updDocCnt1(list < Attachment > Ats, Boolean bInc) {
        set < Id > ids = new set < Id > ();
        for (Attachment A: Ats) {
            if (A.ParentId.getSObjectType() == g_reqDoc__c.sObjectType) {
                ids.add(A.ParentId);
            }
        }
        system.debug('ids:'+ids+':bInc'+bInc);
        if (ids.size() > 0) {
            list < g_reqDoc__c > docs = [select Id, ats__c from g_reqDoc__c where id in: ids];
            for (g_reqDoc__c d: docs) {
                /*/d.ats__c = d.ats__c == null ? (bInc ? 1 : 0) : d.ats__c + (bInc ? 1 : d.ats__c <= 0 ? 0 : -1);
                */ /*/if ( d.ats__c != null && d.ats__c<0) {
                    d.ats__c=0;
                }
                */ d.ats__c=d.ats__c == null?(bInc?1:0):d.ats__c+(bInc?1:-1);
                /*/if (d.ats__c<0) {
                    d.ats__c=0;
                }
            */ }
            system.debug('docs:'+docs);
            if (Schema.sObjectType.g_reqDoc__c.isUpdateable()) {
                update docs;
            }
        }
    }
    public static void hIAAttach(list<Attachment> news) {updDocCnt(news, true);}
    public static void hDAAttach(list<Attachment> olds) {updDocCnt(olds, false);}
    public static void hUBContact(map<Id, Contact>news, map<Id, Contact>olds) {
        if (cBefore) {
            list<Contact> cs=new list<Contact>();
            list<ID__c> ids=new list<ID__c>();
            for (Contact c:news.Values()) {
                Contact o = olds.get(c.Id);
                if (o.STA__c != c.STA__c && o.STA__c=='Under Activation' && c.STA__c=='Active' &&(c.rol__c=='Employee'||c.rol__c=='Non Sponsored'||c.rol__c=='Access Card'||c.rol__c=='Trainee'||c.rol__c=='Student')) {
                    ids.add(new ID__c());
                    cs.add(c);
                }
            }
            if (ids.size()>0) {
                if (Schema.sObjectType.ID__c.isCreateable()) {
                    insert ids;
                }
                for (integer i=0;i<ids.size();i++) {
                    Contact c = cs[i];
                    c.IDr__c = ids[i].Id;
                }
            }
            cBefore=false;
        }
    }
    /*************************/
    public enum tSCP {IB, IA, UB, UA, DB, DA}
    public class xObj{public sObject o;public payload pl;public xObj(sObject objNew, sObject objOld) {if (objNew == null) {o=objOld;}else{o=objNew;}pl=new payload(objNew, objOld);}}
    public class payload{
        public sObject nw;
        public sObject old;
        public map<string, object> mv;
        public map<string, sObject> mo;
        public map<string, list<sObject>> toInsert;
        public map<string, list<sObject>> toUpdate;
        public map<string, list<sObject>> toDelete;
        public payload(sObject objNew, sObject objOld) {
            nw=objNew;
            old=objOld;
            mv=new map<string, object>();
            mo=new map<string, sObject>();
            toInsert=new map<string, list<sObject>>();
            toUpdate=new map<string, list<sObject>>();
            toDelete=new map<string, list<sObject>>();
        }
    }
    private static map<String, list<bRLs.bRL>> getBRules(Boolean isRq, set<String> fNames, tSCP scp) {
        map<String, list<bRLs.bRL>> bRules = new map<String, list<bRLs.bRL>>();
        list<Document> docs;
        if (isRq) {
            if (mrdRL == null) {
                mrdRL=[Select Id, Body, Name From Document where Name in: fNames and Folder.Name ='bRules'];
            }
            docs=mrdRL;
        }
        else {
            if (midRL == null) {
                midRL=[Select Id, Body, Name From Document where Name in: fNames and Folder.Name ='bRules'];
            }
            docs=midRL;
        }
        for (Document d: docs) {
            if (d.Body != null&&bRules.get(d.Name)==null) {
                bRules.put(d.Name, bRLs.Parse(scp.name(), d.Body.toString()));
            }
        }
        return bRules;
    }
    private static void excBtch(list<xObj>os) {
        map<string, list<sObject>> toI=new map<string, list<sObject>>();
        map<string, list<sObject>> toD=new map<string, list<sObject>>();
        map<string, map<Id, sObject>> toU=new map<string, map<Id, sObject>>();
        /*prevent duplicate updates*/
        for (xObj o: os) {
            for (String obj: o.pl.toInsert.keySet()) {
                if (toI.get(obj)==null) {
                    toI.put(obj, new list<sObject>());
                }
                toI.get(obj).addAll(o.pl.toInsert.get(obj));
            }
            for (String obj: o.pl.toUpdate.keySet()) {
                if (toU.get(obj)==null) {
                    toU.put(obj, new map<Id, sObject>());
                }
                for (sObject sobj: o.pl.toUpdate.get(obj)) {
                    toU.get(obj).put(sobj.Id, sobj);
                }
            }
            for (String obj: o.pl.toDelete.keySet()) {
                if (toD.get(obj)==null) {
                    toD.put(obj, new list<sObject>());
                }
                toD.get(obj).addAll(o.pl.toDelete.get(obj));
            }
            o.pl.toInsert.clear();
            o.pl.toUpdate.clear();
            o.pl.toDelete.clear();
        }
        for (String obj: toI.keySet()) {
            insert toI.get(obj);
        }
        for (String obj: toD.keySet()) {
            delete toD.get(obj);
        }
        for (String obj: toU.keySet()) {
            update toU.get(obj).Values();
        }
    }
    /*Those are the fields prepared for JSON bRules*/
    private static map<Id, g_Req__c> getRqs(set<Id> ids) { // to be  compared from prod   missing fileds---xltp__c, xzn__c, xuvdet__c
        if (mRqs != null) {return mRqs;}
        if (ids.size()<=0) {mRqs=new map<Id, g_Req__c>();}
        else{
            mRqs=new map<Id, g_Req__c>([select id, mtnm__c, License_Authority__c, parCat__c, xcemrt__c,
                acc__r.Description, xcreson__c, xtdt__c, ptp__c, xvch__c, acc__r.Freehold__c, xvnum__c,
                cldt__c, ID_Generated__c, xnt__c, skpu__c, xcfan__c, xcmon__c, xcpipoar__c, xcpobar__c,
                Acc__r.Prk__c, createdBy.Email, xcmonar__c, expflg__c, xvcol__c, xcpic__c, xcpip__c,
                xpmsle__c, xui__c, xltp__c, xzn__c, xuvdet__c, xai__c, xoca__c, xcspb__c, Provisional_Issuance__c,
                os__c, xppsfv__c, Acc__r.SF_CRM_ID__c, xlne__c, xalfe__c, xaccbrand__c, xlna__c,
                Acc__r.licn__c, Acc__r.onar__c, Acc__r.on__c, xdei__c, xcne__c, xcna__c, xispd__c,
                xlicd__c, xdrv__c, xcawp__c, xdapp__c, dsgu__c, Acc__r.lcedtarb__c, Acc__r.lcsta__c,
                Acc__r.lcidt1arb__c, Acc__r.lcidtarb__c, xlicarb__c, xledarb__c, xcnexp__c, xvn__c,
                xmloc__c, xfpdd__c, Acc__r.type, Acc__r.dedlic__c, amsgs__c, xcddocs__c , AP__c,
                AT__c, AOP__c, lastModifiedDate, xrsv__c, xrap__c, Name, xawb__c, xltr__c, xcmob__c,
                xard__c, xcpid__c, xcped__c, xccn__c, xtcdl__c, xloc__c, STA__c, Con__c, xchn__c,
                Acc__r.ORACLE_PARTY_ID__c, rmob__c, xceml__c, xpgs__c, xcms__c, xopn__c, xanum__c,
                prntcnt__c, nt__c, xbrnd__c, xbn__c, xaloc__c, xcpobx__c, wftc__c, xeidav__c, epexpdt__c,
                e__c, Spr__c, xcid__c, xcstg__c, xrncar__c, xcslt__c, xcfn__c, xcmn__c, xcln__c,
                xcbd__c, xcnc__c, xcp__c, xcjb__c, xcmbs__c, xcmoa__c, xcmta__c, xcma__c, xcsfn__c,
                xcsp__c, xcsnc__c, xpbg__c, xfpc__c, Acc__c, srvc__c, Acc__r.mtc__c, Acc__r.Phone,
                Acc__r.vcspe__c, Acc__r.vcac__c, Acc__r.vcid__c, Acc__r.vbtemp__c, Acc__r.vcspst__c,
                Acc__r.lc__c, Acc__r.van__c, Acc__r.speabsc__c, Acc__r.spsabsc__c, Acc__r.vbtst__c,
                Acc__r.vev__c, Acc__r.lcsnc__c, Acc__r.lcsncnt__c, Acc__r.psasnc__c, Acc__r.psasncnt__c,
                Acc__r.ecsnc__c, Acc__r.ecsncnt__c, Acc__r.cosnc__c, Acc__r.cosncnt__c, Acc__r.snc__c,
                Acc__r.ec__c, Acc__r.ecedt__c, Acc__r.ecidt__c, Acc__r.lcedt__c, Acc__r.vvsfp__c,
                Acc__r.mvsfp__c, Acc__r.vvqe__c, Acc__r.vvqel__c, Acc__r.vvqem__c, Acc__r.voep__c,
                srvc__r.uid__c, srvc__r.ConRol__c, srvc__r.ConSTA__c, srvc__r.SprRole__c, srvc__r.SprSTA__c,
                srvc__r.snc__c, srvc__r.stg__c,
                                        srvc__r.stg__r.itmbrules__c, srvc__r.stg__r.iapx__c, xcfnar__c, xclnar__c, xcmnar__c,
                                            xdedln__c, xosa__c, xosln__c , Con__r.rpui__c, Con__r.np__c, xceidid__c, Con__r.xean__c,
                                            xintp__c, xqno__c, xtpa__c , Acc__r.Name, xirfn__c, Con__r.xpmi__c, Con__r.rol__c,
                                            Con__r.Spon__r.xpmi__c, Con__r.Spon__r.idtxt__c, Con__r.Spon__r.Birthdate, Con__r.Spon__r.Name,
                                            Con__r.Spon__r.MobilePhone, Zone__c, Spr__r.Name, Spr__r.xpmi__c, Spr__r.idtxt__c,
                                            Spr__r.Birthdate, Spr__r.MobilePhone, CreatedBy.Name, Full_Name__c, Con__r.pobx__c,
                                            Spr__r.pobx__c, Con__r.MobilePhone, xceididt__c, xceidedt__c, xcql__c , con__r.xpno__c,
                                            xcsrs__c, xadtx1__c, xadtx2__c, xadtx3__c, xadtx4__c, Con__r.area__c, con__r.e__c,
                                            con__r.rp__c, con__r.bpa__c, con__r.mona__c, con__r.lng__c, Con__r.spn__c,
                                        Con__r.bp__c, con__r.nc__c, xfb__c, xvtyp__c, rtacn__c, xbtnm__c, Acc__r.lctp__c,
                                            Acc__r.ccrm_sfid__c, xcCVDocID__c, Program__c, Course_Name__c, Current_Course_Year__c,
                                            GPA__c
                                        from g_Req__c where id in: ids and isDeleted=false]);}
        return mRqs;
    }
    private static map<Id, Account> getAccs(set<Id> ids) {
        if (mAccs != null) {return mAccs;}
        if (ids.size()<=0) {mAccs=new map<Id, Account>();}
        else{
            mAccs=new map<Id, Account>([select adrfi__c, adr__c, Freehold__c, Specification__c,
                Leasing_Category__c, id, Prk__c, Name, on__c, licn__c, licnarb__c, onar__c, lcedtarb__c,
                lcidt1arb__c, lcidtarb__c, dedlic__c, type, bg__c, Legal_Framework__c, lcsta__c,
                bgnr__c, vbvv__c, vcspe__c, vctst__c, vbtemp__c, vcspst__c, vcac__c, vcid__c, speabsc__c,
                vbtst__c, vev__c, lcsnc__c, lcsncnt__c, psasnc__c, psasncnt__c, ecsnc__c, ecsncnt__c,
                cosnc__c, cosncnt__c, snc__c, spsabsc__c, coreq__c, coaa__c, ec__c, ecidt__c, ecedt__c,
                lcedt__c, vvsfp__c, mvsfp__c, vvqe__c, vvqel__c, vvqem__c, voep__c, lc__c, adx__c,
                os__c from Account where id in: ids and isDeleted=false]);
        }
        return mAccs;
    }
    private static map<Id, Decimal> getAccVisitors(set<Id> ids) {
        Set<String> sts=new Set<String>{'Completed', 'Rejected', 'Cancelled'};
            if (mVisitors != null) {return mVisitors;}
        if (ids.size()<=0) {mVisitors=new map<Id, Decimal>();}
        else{
            mVisitors = new map<Id, Decimal>();
            for (aggregateResult ar:[select Acc__c Acc,
                count(id) C from g_Req__c where (srvc__r.uid__c='058' or srvc__r.uid__c='074' or srvc__r.uid__c='096' or srvc__r.uid__c='097') and isDeleted=false and ((STA__c!='Rejected' and STA__c!='Cancelled' and CreatedDate = THIS_MONTH) or STA__c='Open'or STA__c='Draft' ) and Acc__c in:ids group by Acc__c]) {
                mVisitors.put((Id)ar.get('Acc'), ar.get('C')==null?0:(Decimal)ar.get('C'));
            }
        }
        return mVisitors;
    }
    private static map<Id, Contact> getCtcts(Boolean isRq, set<Id> ids, set<String> uids) {

        if (isRq) {if (mrCtcts != null && !mrCtcts.isEmpty()) {return mrCtcts;}}
        else{if (miCtcts != null && !miCtcts.isEmpty()) {return miCtcts;}}
        map<Id, Contact> mc=new  map<Id, Contact>();

        if (ids.size()>0||uids.size()>0) {
            mc=new map<Id, Contact>([select CVDocID__c, xtdt__c, ptp__c, Program__c, efgv__c,
                Course_Name__c, Current_Course_Year__c, GPA__c, id, spn__c, lng__c, np__c, pipa__c,
                bpa__c, mona__c, ptsta__c, Photo_ID__c, xpno__c, pte__c, Ecol__c, Proc__c, AccountId,
                pc__c, name, STA__c, rol__c, absdt__c, nc__c, id__c, idtxt__c, ididt__c, idedt__c,
                jd__c, e__c, eid__c, eed__c, epui__c, rpid__c, rped__c, rpui__c, uid__c, cdt__c,
                okDEL__c, p__c, mbs__c, moa__c, mta__c, ma__c, jb__c, acctp__c, ha__c, area__c,  cty__c,
                jb__r.name, eidid__c, eidedt__c, eididt__c, emrt__c, fs__c, fnar__c, ms__c, mn__c,
                mon__c, of__c, ot__c,   ped__c, pid__c, Birthdate, pic__c, pip__c, bp__c, ql__c,
                rlg__c, rp__c, strt__c, HomePhone, pobx__c, pobxarea__c, Email, fan__c, bc__c, lnar__c,
                mnar__c, Salutation, FirstName, MiddleName, LastName, MobilePhone, mgs__c, rcup__c,
                xur__c, ast__c, pSTA__c, pRol__c, Spon__c, Spon__r.AccountId, Spon__r.nc__c, Spon__r.mgs__c,
                RP_Sts__c, Spon__r.rol__c, Spon__r.STA__c, Spon__r.Salutation, sfn__c, Account.lc__c,
                etd__c, os__c, hltcd__c, xean__c, xpmi__c, rpexp__c, Department,
                    snc__c, sp__c, (select id, Name, RQ__r.name,
                        RQ__r.STA__c, RQ__r.srvc__r.lbl__c from Service_Dependency__r) from Contact where(id in : ids or uid__c in : uids) and isDeleted = false]);
        }
        if (isRq) {mrCtcts=mc;}else{miCtcts=mc;}
        return mc;
    }
    private static map<Id, g_Srvc__c> getSrvcs(set<Id> ids) {
        if (mSrvcs != null) {return mSrvcs;}
        if (ids.size()<=0) {mSrvcs=new map<Id, g_Srvc__c>();}
        else{mSrvcs=new map<Id, g_Srvc__c>([select id, name, Prk__c, uid__c, ConRol__c, ConSTA__c, SprRole__c,
                                           SprSTA__c, snc__c, stg__c, stg__r.reqbrules__c, stg__r.apx__c,
                                           Milestone_SLA__c, Milestone_Stage__c, ExpMilestone_SLA__c, Total_Milestone_SLA_EXP__c, xur__c, xsif__c from g_Srvc__c
                                           where id in: ids and isDeleted=false]);}
        return mSrvcs;
    }
    private static map<Id, User> getUsrs(Boolean isRq, set<ID> cids, set<String> cuids) {
        if (isRq) {if (mrUsrs != null) {return mrUsrs;}}
        else{if (miUsrs != null) {return miUsrs;}}
        map<Id, User> mU=new map<Id, User>();
        if (cids.size()>0||cuids.size()>0) {
            for (User u:[select id, ProfileId, ContactId from User where (ContactId in: cids or Contact.uid__c in: cuids) and isActive=true]) {mu.put(u.ContactId, u);}
        }
        if (isRq) {mrUsrs=mU;} else{miUsrs=mU;}
        return mU;
    }
    public static map<Id, g_srvcitm_Status__c> getSTAs(set<Id> ids) {
        System.debug('<getSTAs> : ' + ids);
        if (mSTAs != null) {return mSTAs;}
        if (ids.size()<=0) {mSTAs=new map<Id, g_srvcitm_Status__c>();}
        else{
            mSTAs=new map<Id, g_srvcitm_Status__c>([Select Id, cd__c, Tp__c, ws_mtd__c, cmthd__c,
                ws_typ__c, statype__c, staown__c, Exclude_SLA__c, nm__c, actv__c, rfnd__c, clm__c,
                rc__c, kstp__c, slaa__c, slaat__c, noEXP__c, slaN__c, slaXP__c, Shift_At__c, Shift_Items__c,
                itm__c, itm__r.Id, itm__r.cd__c, itm__r.uid__c, itm__r.Tp__c, itm__r.dSTA__c, itm__r.actv__c,
                itm__r.Req__c, itm__r.aln__c, itm__r.mxcnt__c, itm__r.rv__c, Courier_Stage__c, Milestone__c,
                clmA__c, rfndA__c From g_srvcitm_Status__c where id in:ids]);
        }
        return mSTAs;
    }
    public class rH{
        public rH() {
            if (mBH == null) {mBH = [SELECT Id FROM BusinessHours WHERE id=: gU.csStr('BH')];}
            system.debug('  mBH  '+mBH);
        }
        //public  list<g_TranItem__c> transItms{get; set;}
        private void excBRLS(list < xObj > Rs, map < Id, g_Srvc__c > mSrvc, tSCP scp) {
            set < String > fNames = new set < String > ();

            for (g_Srvc__c s: mSrvc.values()) {
                fNames.add(s.stg__r.reqbrules__c);
            }
            map < String, list < bRLs.bRL >> mRules = getBRules(true, fNames, scp);

            for (Integer batch = 1; batch < 3; batch++) {
                for (xObj r: Rs) {
                    System.debug( '#####bRules' + r.o);
                    list < bRLs.bRL > bRules = mRules.get(mSrvc.get((Id)r.o.get('srvc__c')).stg__r.reqbrules__c);

                    if (bRules != null) {
                        bRLs.exc(r.pl, bRules, batch);
                    }
                }
                system.debug('test9');
                excBtch(Rs);
            }
        }
        private void lnkDisc(list<g_Req__c> rs) {
            set<id> aids=new set<id>();
            for (g_Req__c r:rs) {
                aids.add(r.Acc__c);
            }
            map<Id, g_Disc__c> mapD = new map<Id, g_Disc__c>();
            map<Id, g_Disc__c> m2Upd = new map<Id, g_Disc__c>();
            for (g_Disc__c d: [select id, Acc__c, Tp__c, srvc__c, sd__c, ed__c, q__c, prct__c, alc__c from g_Disc__c where STA__c='Approved' and Acc__c in:aids order by ed__c, CreatedDate desc]) {
                mapD.put(d.Acc__c, d);
            }
            for (g_Req__c r: rs) {
                g_Disc__c d = mapD.get(r.Acc__c);
                if (d != null) {
                    if (m2Upd.get(d.Id)!=null) {
                        d = m2Upd.get(d.Id);
                    }
                    if ((d.Tp__c=='Duration'&&d.ed__c>date.today())||(d.Tp__c=='Quota'&&d.alc__c <d.q__c)||(d.Tp__c=='Both'&&d.ed__c>date.today()&&d.alc__c<d.q__c)) {
                        r.dsc__c = d.Id;
                        d.alc__c++;
                        m2Upd.put(d.Id, d);
                    }
                }
            }
            if (m2Upd.size()>0) {
                update m2Upd.Values();
            }
        }
        private void dummyUpRIDs(list<g_Req__c> rs) {

            set<Id> rids = new set<Id>();
            for (g_Req__c r: rs) {rids.add(r.Id);}
            System.debug('<dummyUpRIDs> rids' + rids );
            list<g_reqitemDoc__c> ds = [Select id From g_reqitemDoc__c where isDeleted = false and reqItm__r.RQ__c in:rIds];if (ds.size()>0) {
                System.debug('<dummyUpRIDs> ds' + ds.size());
                if (Schema.sObjectType.g_reqitemDoc__c.isUpdateable()) {
                    update ds;
                }

            }
        }
        private void postRequestClosure(list<g_Req__c>news, map<Id, g_Req__c>olds) {
            for (g_Req__c r: news) {
                System.debug('#$#$#$#$#inside');
                //Calculate request duration - from payment date to closure date
                System.debug('#$#$#$#$#inside'+r.STA__c+'-'+r.xfpc__c);

                if (olds == null || (olds != null && olds.containsKey(r.id) && olds.get(r.id).STA__c != r.STA__c)) {
                    if (r.STA__c=='Completed' || r.STA__c=='Rejected' ||  r.STA__c=='Cancelled') {
                        System.debug('here');
                        if (r.xdtcls__c == null) {  r.xdtcls__c=System.now();}

                        System.debug('mbh is '+mBH.Id);
                        System.debug('creataed is '+r.CreatedDate);
                        System.debug('close is '+r.xdtcls__c);

                        if (r.xfpc__c == null) {r.Duration__c =((Double)BusinessHours.diff(mBH.Id, r.CreatedDate, r.xdtcls__c)/toHour);}
                        else r.Duration__c=(Double)BusinessHours.diff(mBH.Id, r.xfpc__c, System.now())/toHour;
                    }else if (r.xdtcls__c != null && (r.STA__c!='Completed' && r.STA__c!='Rejected' &&  r.STA__c!='Cancelled')) {
                        System.debug('#$#$#$#$#inside again');
                        r.xdtcls__c = null;
                        r.Duration__c=0.0;
                    }

                }
            }
        }
        private Boolean isServDependent(List < g_Req__c > news, Map < Id, g_Srvc__c > mSrvc, Map < Id, Contact > mCtct, map<String, Contact> mcLnk) {
            Boolean flag = false;
            for (g_Req__c r: news) {
                g_Srvc__c s = mSrvc.get(r.srvc__c);
                if (!mCtct.isEmpty() && ((r.Con__c != null && mCtct.containskey(r.Con__c)) || mcLnk.containskey(r.xcnc__c + r.xcp__c))) {
                    List < g_srvc_dep__c > sdLst = new List < g_srvc_dep__c > ();

                    if (r.Con__c != null) sdLst = mCtct.get(r.Con__c).Service_Dependency__r;
                    else sdLst = mcLnk.get(r.xcnc__c + r.xcp__c).Service_Dependency__r;
                    if (string.isNotBlank(s.xsif__c) && !sdLst.isEmpty()) {
                        for (g_srvc_dep__c sd: sdLst) {
                            if (s.xsif__c.contains(sd.name)) {
                                r.AddError('You cannot apply for this service as there is already an open request registered for this contact with reference ' +
                                    sd.RQ__r.name + ' for ' + sd.RQ__r.srvc__r.lbl__c + ', either cancel or complete the request.');
                                flag = true;
                            }
                        }
                    }
                }
            }
            return flag;
        }
        private void updateProcessFlg(list<g_Req__c>news, map<Id, g_Srvc__c>mSrvc, map<Id, Contact>mCtct) {
            //List<Contact> conLst = new List<Contact>();
            List<g_srvc_dep__c> sdLst = new List<g_srvc_dep__c>();
            for (g_Req__c r:news) {
                g_Srvc__c s = mSrvc.get(r.srvc__c);
                if (r.Con__c != null && s.xur__c != null) {
                    g_srvc_dep__c sd = new g_srvc_dep__c();
                    sd.name =s.xur__c;
                    sd.Con__c = r.Con__c;
                    sd.RQ__c = r.id;
                    sdLst.add(sd);
                    /*if (con.xur__c == null)con.xur__c='';
                    if (s.xur__c == null)s.xur__c='';
                    con.xur__c = con.xur__c+s.xur__c;
                    system.debug('test::Underprocess'+con.xur__c);
                    conLst.add(con);
                */}
            }
            /*if (conLst != null && !conLst.isEmpty()) update conLst;
            */ if (!sdLst.isEmpty()) insert sdLst;
        }
        public void clearProcessFlg(list < g_Req__c > news, map < Id, g_Req__c > olds) {
            Set < id > reqIdlst = new Set < id > ();
            for (g_Req__c r: news) {
                system.debug('r.STA__c::' + r.STA__c);
                System.debug(LoggingLevel.Info, 'r.STA__c::' + r.STA__c);
                if ((olds.get(r.id).STA__c != r.STA__c) && (r.STA__c == 'Completed' || r.STA__c == 'Rejected' || r.STA__c == 'Cancelled')) {
                    reqIdlst.add(r.id);
                }
                if (r.STA__c == 'Completed') {
                    new gu().createSurveyRes(r.Id);
                }
            }
            if (!reqIdlst.isEmpty()) {
                List < g_srvc_dep__c > sdLst = [select id from g_srvc_dep__c where RQ__c =: reqIdlst];
                if (sdLst != null && !sdLst.isEmpty()) delete sdLst;
            }
        }

        private void excRflc(map<String, list<g_Req__c>> mRflc, map<Id, g_Req__c> olds, map<Id,
            Account>mAcc, map<Id, g_Srvc__c>mSrvc, map<Id, Contact>mCtct, map<String, Contact>mcLnk,
            map<Id, User>mcU, tSCP scp) {
            if (scp == tSCP.IB) {
                for (String apx: mRflc.KeySet()) {
                    Type t = Type.forName(apx);
                    grqI.intR obj=(grqI.intR)t.newInstance();
                    obj.hIB(mRflc.get(apx), mAcc, mSrvc, mCtct, mcLnk, mcU);
                }
            }
            else if (scp == tSCP.IA) {for (String apx: mRflc.KeySet()) {Type t = Type.forName(apx);grqI.intR obj=(grqI.intR)t.newInstance();obj.hIA(mRflc.get(apx), mAcc, mSrvc, mCtct, mcLnk, mcU);}}
            else if (scp == tSCP.UB) {
                for (String apx: mRflc.KeySet()) {
                    Type t = Type.forName(apx);
                    grqI.intR obj=(grqI.intR)t.newInstance();
                    obj.hUB(mRflc.get(apx), olds, mAcc, mSrvc, mCtct, mcLnk, mcU);
                }
            }
            else if (scp == tSCP.UA) {for (String apx: mRflc.KeySet()) {Type t = Type.forName(apx);grqI.intR obj=(grqI.intR)t.newInstance();
                                                                  obj.hUA(mRflc.get(apx), olds, mAcc, mSrvc, mCtct, mcLnk, mcU);}}
            else if (scp == tSCP.DB) {
                for (String apx: mRflc.KeySet()) {
                    Type t = Type.forName(apx);
                    grqI.intR obj=(grqI.intR)t.newInstance();
                    obj.hDB(new map<Id, g_Req__c>(mRflc.get(apx)), mAcc, mSrvc, mCtct, mcLnk, mcU);
                }
            }
            else if (scp == tSCP.DA) {
                for (String apx: mRflc.KeySet()) {
                    Type t = Type.forName(apx);
                    grqI.intR obj=(grqI.intR)t.newInstance();
                    obj.hDA(new map<Id, g_Req__c>(mRflc.get(apx)), mAcc, mSrvc, mCtct, mcLnk, mcU);
                }
            }
        }
        private list<xObj> excH(list<g_Req__c>news, map<Id, g_Req__c>olds, tSCP scp) {
            list<xObj>Rs=new list<xObj>();if (news == null&&olds == null) {return Rs;}
            set<id> aids=new set<id>();set<id> sids=new set<id>();set<id> cids=new set<id>();set<String> cuids=new set<String>();
            list<g_Req__c>lst;if (news == null) {lst=olds.values();}else{lst=news;}
            for (g_Req__c r:lst) {
                aids.add(r.Acc__c);sids.add(r.srvc__c);
                if (r.Con__c != null) {cids.add(r.Con__c);}if (r.Spr__c != null) {cids.add(r.Spr__c);}
                if (r.xcnc__c != null&&r.xcp__c != null) {cuids.add(r.xcnc__c+r.xcp__c);}
            }
            if (news != null&&olds != null) {
                for (g_Req__c r:olds.Values()) {
                    if (r.Con__c != null) {cids.add(r.Con__c);}if (r.Spr__c != null) {cids.add(r.Spr__c);}
                    if (r.xcnc__c != null&&r.xcp__c != null) {cuids.add(r.xcnc__c+r.xcp__c);}
                }
            }
            map<Id, Account>mAcc=getAccs(aids);
            map<Id, g_Srvc__c>mSrvc=getSrvcs(sids);
            map<Id, Contact>mCtct=getCtcts(true, cids, cuids);
            map<String, Contact>mcLnk=new map<String, Contact>();
            map<Id, User>mcU=getUsrs(true, cids, cuids);
            for (Contact c:mCtct.Values()) {mcLnk.put(c.uid__c, c);}
            map<Id, Decimal> mV =getAccVisitors(aids);
            User u;Contact c;Decimal v; Account A;
            map<String, list<g_Req__c>> mRflc = new map<String, list<g_Req__c>>();
            for (g_Req__c r:lst) {
                g_Srvc__c s=null;
                if (mSrvc.get(r.srvc__c)!=null)
                    s= mSrvc.get(r.srvc__c);
                if (s != null && s.stg__r.apx__c != null) {
                    if (mRflc.get(s.stg__r.apx__c)==null) {
                        mRflc.put(s.stg__r.apx__c, new list<g_Req__c>());
                    }
                    mRflc.get(s.stg__r.apx__c).add(r);
                }
            }
            if (scp == tSCP.IB||scp == tSCP.IA) {
                if (scp == tSCP.IB) {  if (isServDependent(lst, mSrvc, mCtct, mcLnk))return Rs; lnkDisc(lst);}

                for (g_Req__c r:lst) {
                    xObj o = new xObj(r, null);o.pl.mv.put('@isN', true);
                    o.pl.mv.put('@isD', r.STA__c=='Draft');o.pl.mv.put('@isO', r.STA__c=='Open');o.pl.mv.put('@isUR', r.STA__c=='Under Review');
                    o.pl.mv.put('@isIP', r.STA__c=='In Process');o.pl.mv.put('@isCP', r.STA__c=='Completed');o.pl.mv.put('@isRJ', r.STA__c=='Rejected');
                    o.pl.mv.put('@isCL', r.STA__c=='Cancelled');o.pl.mv.put('@isOH', r.STA__c=='On Hold');o.pl.mv.put('@chgSTA', false);
                    o.pl.mv.put('@hasC', r.Con__c != null);o.pl.mv.put('@hadC', false);o.pl.mv.put('@chgC', r.Con__c != null);
                    o.pl.mv.put('@hasSP', r.Spr__c != null);o.pl.mv.put('@hadSP', false);o.pl.mv.put('@chgSP', r.Spr__c != null);
                    o.pl.mv.put('@hasNP', r.xcnc__c != null&&r.xcp__c != null);o.pl.mv.put('@hadNP', false);o.pl.mv.put('@chgNP', r.xcnc__c != null||r.xcp__c != null);
                    system.debug('r.srvc__c::'+r.srvc__c); system.debug('r.Acc__c::'+r.Acc__c);
                    o.pl.mo.put('#Srvc', mSrvc.get(r.srvc__c));
                    A=mAcc.get(r.Acc__c);o.pl.mo.put('#Acc', A);
                    v=mV.get(A.Id);if (v == null) {v=0;}
                    o.pl.mv.put('@vSanc', v >= A.vbvv__c);
                    if (r.Con__c != null) {
                        o.pl.mo.put('#nC', mCtct.get(r.Con__c));u=mcU.get(r.Con__c);
                        if (u != null) {o.pl.mo.put('#nCU', u);o.pl.mv.put('@nCSU', gU.isPortalSuperUser(u.ProfileId));
                                    o.pl.mv.put('@nCU', gU.isPortalUser(u.ProfileId));
                                    o.pl.mv.put('@rpxp', 10);}
                        //o.pl.mv.put('@rpxp', System.today().daysBetween(r.Con__r.rped__c));}
                    }
                    if (r.Spr__c != null) {
                        o.pl.mo.put('#nSP', mCtct.get(r.Spr__c));
                        u=mcU.get(r.Spr__c);
                        if (u != null) {
                            o.pl.mo.put('#nSPU', u);
                            o.pl.mv.put('@nSPSU', gU.isPortalSuperUser(u.ProfileId));
                        }
                    }
                    if (r.xcnc__c != null&&r.xcp__c != null) {c=mcLnk.get(r.xcnc__c+r.xcp__c);if (c != null) {o.pl.mo.put('#nlnkC', c);
                                                                                                    o.pl.mv.put('@rpxp', 10);
                                                                                                    //o.pl.mv.put('@rpxp', System.today().daysBetween(c.rped__c));
                                                                                                    u=mcU.get(c.Id);
                                                                                                    if (u != null) {
                                                                                                        o.pl.mo.put('#nlnkCU', u);
                                                                                                        o.pl.mv.put('@nlnkCSU', gU.isPortalSuperUser(u.ProfileId));
                                                                                                        o.pl.mv.put('@nlnkCU', gU.isPortalUser(u.ProfileId));
                                                                                                    }
                                                                                                    }
                                                                                                    }
                    Rs.add(o);
                }
            } else if (scp == tSCP.UB||scp == tSCP.UA) {

                if (scp == tSCP.UA) {
                    Map<Id, g_Req__c> newMp = new Map<id, g_Req__c>();
                    for (g_Req__c r:lst) {
                        newMp.put(r.id, r);
                    }
                    linkRequestDocs(newMp);
                    copydocs(newMp);
                    dummyUpRIDs(lst); //###
                }//postRequestClosure(lst);}
                for (g_Req__c r:lst) {
                    g_Req__c oldr=olds.get(r.Id);xObj o = new xObj(r, oldr);o.pl.mv.put('@isN', false);
                    o.pl.mv.put('@isD', r.STA__c=='Draft');o.pl.mv.put('@isO', r.STA__c=='Open');o.pl.mv.put('@isUR', r.STA__c=='Under Review');
                    o.pl.mv.put('@isIP', r.STA__c=='In Process');o.pl.mv.put('@isCP', r.STA__c=='Completed');o.pl.mv.put('@isRJ', r.STA__c=='Rejected');
                    o.pl.mv.put('@isCL', r.STA__c=='Cancelled');o.pl.mv.put('@isOH', r.STA__c=='On Hold');o.pl.mv.put('@chgSTA', r.STA__c != oldr.STA__c);
                    o.pl.mv.put('@hasC', r.Con__c != null);o.pl.mv.put('@hadC', oldr.Con__c != null);o.pl.mv.put('@chgC', r.Con__c != oldr.Con__c);
                    o.pl.mv.put('@hasSP', r.Spr__c != null);o.pl.mv.put('@hadSP', oldr.Spr__c != null);o.pl.mv.put('@chgSP', r.Spr__c != oldr.Spr__c);
                    o.pl.mv.put('@hasNP', r.xcnc__c != null&&r.xcp__c != null);
                    o.pl.mv.put('@hadNP', oldr.xcnc__c != null&&oldr.xcp__c != null);
                    o.pl.mv.put('@chgNP', r.xcnc__c != oldr.xcnc__c||r.xcp__c != oldr.xcp__c);
                    o.pl.mo.put('#Srvc', mSrvc.get(r.srvc__c));A=mAcc.get(r.Acc__c);o.pl.mo.put('#Acc', A);v=mV.get(A.Id);if (v == null) {v=0;}o.pl.mv.put('@vSanc', v >= A.vbvv__c);
                    system.debug('old rq status::'+oldr.STA__c);
                    system.debug('new rq status::'+r.STA__c);
                    if (r.Con__c != null) {
                        o.pl.mo.put('#nC', mCtct.get(r.Con__c));u=mcU.get(r.Con__c);
                        if (u != null) {o.pl.mo.put('#nCU', u);o.pl.mv.put('@nCSU', gU.isPortalSuperUser(u.ProfileId));o.pl.mv.put('@nCU', gU.isPortalUser(u.ProfileId));}
                    }
                    if (oldr.Con__c != null) {
                        o.pl.mo.put('#oC', mCtct.get(oldr.Con__c));u=mcU.get(oldr.Con__c);
                        if (u != null) {o.pl.mo.put('#oCU', u);o.pl.mv.put('@oCSU', gU.isPortalSuperUser(u.ProfileId));}
                    }
                    if (r.Spr__c != null) {
                        o.pl.mo.put('#nSP', mCtct.get(r.Spr__c));
                        u=mcU.get(r.Spr__c);
                        if (u != null) {
                            o.pl.mo.put('#nSPU', u);
                            o.pl.mv.put('@nSPSU', gU.isPortalSuperUser(u.ProfileId));
                        }
                    }
                    if (oldr.Spr__c != null) {
                        o.pl.mo.put('#oSP', mCtct.get(oldr.Spr__c));
                        u=mcU.get(oldr.Spr__c);
                        if (u != null) {
                            o.pl.mo.put('#oSPU', u);
                            o.pl.mv.put('@oSPSU', gU.isPortalSuperUser(u.ProfileId));
                        }
                    }
                    if (r.xcnc__c != null&&r.xcp__c != null) {
                        c=mcLnk.get(r.xcnc__c+r.xcp__c);
                        if (c != null) {
                            o.pl.mo.put('#nlnkC', c);
                            u=mcU.get(c.Id);
                            if (u != null) {
                                o.pl.mo.put('#nlnkCU', u);
                                o.pl.mv.put('@nlnkCSU', gU.isPortalSuperUser(u.ProfileId));
                                o.pl.mv.put('@nlnkCU', gU.isPortalUser(u.ProfileId));
                            }
                        }
                    }
                    if (oldr.xcnc__c != null&&oldr.xcp__c != null) {
                        c=mcLnk.get(oldr.xcnc__c+oldr.xcp__c);
                        if (c != null) {
                            o.pl.mo.put('#olnkC', c);
                            u=mcU.get(c.Id);
                            if (u != null) {
                                o.pl.mo.put('#olnkCU', u);
                                o.pl.mv.put('@olnkCSU', gU.isPortalSuperUser(u.ProfileId));
                            }
                        }
                    }
                    Rs.add(o);
                }
            } else if (scp == tSCP.DB||scp == tSCP.DA) {
                for (g_Req__c oldr:lst) {
                    xObj o = new xObj(null, oldr);o.pl.mv.put('@isN', false);
                    o.pl.mv.put('@isD', oldr.STA__c=='Draft');o.pl.mv.put('@isO', oldr.STA__c=='Open');o.pl.mv.put('@isUR', oldr.STA__c=='Under Review');
                    o.pl.mv.put('@isIP', oldr.STA__c=='In Process');o.pl.mv.put('@isCP', oldr.STA__c=='Completed');o.pl.mv.put('@isRJ', oldr.STA__c=='Rejected');
                    o.pl.mv.put('@isCL', oldr.STA__c=='Cancelled');o.pl.mv.put('@isOH', oldr.STA__c=='On Hold');o.pl.mv.put('@chgSTA', false);
                    o.pl.mv.put('@hasC', oldr.Con__c != null);o.pl.mv.put('@hadC', oldr.Con__c != null);o.pl.mv.put('@chgC', false);
                    o.pl.mv.put('@hasSP', oldr.Spr__c != null);o.pl.mv.put('@hadSP', oldr.Spr__c != null);o.pl.mv.put('@chgSP', false);
                    o.pl.mv.put('@hasNP', oldr.xcnc__c != null&&oldr.xcp__c != null);o.pl.mv.put('@hadNP', oldr.xcnc__c != null&&oldr.xcp__c != null);o.pl.mv.put('@chgNP', false);
                    o.pl.mo.put('#Srvc', mSrvc.get(oldr.srvc__c));A=mAcc.get(oldr.Acc__c);o.pl.mo.put('#Acc', A);v=mV.get(A.Id);if (v == null) {v=0;}o.pl.mv.put('@vSanc', v >= A.vbvv__c);
                    if (oldr.Con__c != null) {
                        o.pl.mo.put('#oC', mCtct.get(oldr.Con__c));
                        u=mcU.get(oldr.Con__c);
                        if (u != null) {
                            o.pl.mo.put('#oCU', u);
                            o.pl.mv.put('@oCSU', gU.isPortalSuperUser(u.ProfileId));
                        }
                    }
                    if (oldr.Spr__c != null) {
                        o.pl.mo.put('#oSP', mCtct.get(oldr.Spr__c));
                        u=mcU.get(oldr.Spr__c);
                        if (u != null) {
                            o.pl.mo.put('#oSPU', u);
                            o.pl.mv.put('@oSPSU', gU.isPortalSuperUser(u.ProfileId));
                        }
                    }
                    if (oldr.xcnc__c != null&&oldr.xcp__c != null) {
                        c=mcLnk.get(oldr.xcnc__c+oldr.xcp__c);
                        if (c != null) {
                            o.pl.mo.put('#olnkC', c);
                            u=mcU.get(c.Id);
                            if (u != null) {
                                o.pl.mo.put('#olnkCU', u);
                                o.pl.mv.put('@olnkCSU', gU.isPortalSuperUser(u.ProfileId));
                            }
                        }
                    }
                    Rs.add(o);
                }
            }
            system.debug('test4::');
            excRflc(mRflc, olds, mAcc, mSrvc, mCtct, mcLnk, mcU, scp);
            system.debug('test5::');
            if (scp == tSCP.UA) {unLinkDocs(news, olds);}
            excBRLS(Rs, mSrvc, scp);
            if (scp == tSCP.IA) {system.debug('after insert::');updateProcessFlg(lst, mSrvc, mCtct);}
            if (scp == tSCP.UB) {
                postRequestClosure(lst, olds);
            }
            //calling milestone helper to create milestones @manish
            if (scp == tSCP.IA) {grqSlaH.crtMlstn(news, mSrvc);}
            return Rs;
        }
        /*** Check Sanctions ***/
        private Boolean hSnc(Account A, g_Srvc__c S) {Boolean hasSnc = false;if (hiSnc(A, S)) {hasSnc=true;}if (S.ckgsnc__c) {if (hgSnc(A)) {hasSnc=true;}}return hasSnc;}
        private Boolean hiSnc(Account A, g_Srvc__c S) {
            if (S.Prk__c == null||S.AccTp__c == null||A.Prk__c == null||A.Type == null) {
                gU.addWarningMsg(Label.msgSrvcNA);
                return true;
            }
            Boolean bfnd=false;
            for (String prk:S.Prk__c.split('\\;')) {
                if (prk == A.Prk__c) {
                    bfnd=true;
                    break;
                }
            }
            if (!bfnd) {
                gU.addWarningMsg(Label.msgSrvcNA);
                return true;
            }
            bfnd=false;
            for (String tp:S.AccTp__c.split('\\;')) {
                if (tp == A.Type) {
                    bfnd=true;
                    break;
                }
            }
            if (!bfnd) {
                gU.addWarningMsg(Label.msgSrvcNA);
                return true;
            }
            if (A.snc__c == null||S.snc__c == null) {
                return false;
            }
            for (String asnc: S.snc__c.split('\\;')) {
                for (String ssnc: A.snc__c.split('\\;')) {
                    if (asnc == ssnc) {
                        gU.addWarningMsg(Label.msgSanc);
                        return true;
                    }
                }
            }
            return false;
        }
        private Boolean hgSnc(Account A) {
            Boolean hasSnc = false;
            if (A.lcsnc__c) {
                gU.addWarningMsg(A.lcsncnt__c);
                hasSnc=true;
            }
            if (A.psasnc__c) {
                gU.addWarningMsg(A.psasncnt__c);
                hasSnc=true;
            }
            if (A.ecsnc__c) {
                gU.addWarningMsg(A.ecsncnt__c);
                hasSnc=true;
            }
            if (A.cosnc__c) {
                gU.addWarningMsg(A.cosncnt__c);
                hasSnc=true;
            }
            return hasSnc;
        }

        public Boolean BC(g_Req__c R, g_Srvc__c S, Account A) {
            Boolean hasSnc = hSnc(A, S);
            if (s.stg__r.apx__c != null) {
                Type t = Type.forName(s.stg__r.apx__c);
                grqI.intR obj=(grqI.intR)t.newInstance();
                hasSnc=!obj.BC(hasSnc, R, S, A)||hasSnc;
            }
            return !hasSnc;
        }
        /*before create UI: return false to stop create*/
        public Boolean AC(g_Req__c R, g_Srvc__c S, Account A) {Boolean hasSnc = hSnc(A, S);return !hasSnc;}
        /*** End Check Sanctions ***/
        public void AP(g_Req__c R, g_Tran__c Trn) {}
         /*US APD3911 Start*/ private void unLinkDocs(List<g_Req__c> newReqList, Map<Id, g_Req__c> oldReqMap) { Map<Id, List<String>> reqPrDocOld = new Map<Id, List<String>>(); Map<Id, List<String>> reqPrDocNew = new Map<Id, List<String>>(); List<g_reqitemDoc__c> reqItmDocUp = new List<g_reqitemDoc__c>(); List<g_reqDoc__c> toBeDeletedDocs = new List<g_reqDoc__c>(); List<Attachment> tobeDeletedAttachments= new List<Attachment>(); Set<Id> parentReqDocIds = new Set<Id>(); for (g_Req__c req : newReqList) { system.debug('---req.xcddocs__c---'+req.xcddocs__c); system.debug('---oldReqMap.get(req.Id).xcddocs__c---'+oldReqMap.get(req.Id).xcddocs__c); if ( req.AOP__c>0 && req.xcddocs__c != oldReqMap.get(req.Id).xcddocs__c && oldReqMap.get(req.Id).xcddocs__c != null && req.xcddocs__c != null && req.xcddocs__c.contains(';')) { reqPrDocNew.put(req.Id, req.xcddocs__c.split(';')); reqPrDocOld.put(req.Id, oldReqMap.get(req.Id).xcddocs__c.split(';')); } } system.debug('---reqPrDocNew---'+reqPrDocNew); for (g_reqitemDoc__c itmDoc : [ SELECT Id, Name, reqItm__r.RQ__c, Req__c, reqDoc__c, reqItm__r.RQ__r.xcamc__c FROM g_reqitemDoc__c WHERE reqItm__r.RQ__c IN :reqPrDocNew.keySet() ]) { if (!reqPrDocNew.get(itmDoc.reqItm__r.RQ__c).contains(itmDoc.Name) && reqPrDocOld.get(itmDoc.reqItm__r.RQ__c).contains(itmDoc.Name)) { if (itmDoc.reqDoc__c != null) { parentReqDocIds.add(itmDoc.reqDoc__c); } } } system.debug('---parentReqDocIds---'+parentReqDocIds); List<g_reqDoc__c> memDirResolutionList = new List<g_reqDoc__c>([SELECT Id, (SELECT Id FROM Attachments) FROM g_reqDoc__c WHERE Name IN ('Member(s) Resolution', 'Director(s) Resolution') AND RQ__c IN :reqPrDocNew.keySet() AND RQ__r.xcamc__c NOT IN ('Company Name Change - FZ-LLC', 'Company Name Change - Operating Name', 'Company Name Change - Parent Company Name', 'Company Name Change - Operating Name & Parent Company Name')]); if (memDirResolutionList != null && memDirResolutionList.size()>0) { for (g_reqDoc__c objDoc:memDirResolutionList) { for (Attachment objAtt:objDoc.Attachments) { tobeDeletedAttachments.add(objAtt); } } } system.debug('----tobeDeletedAttachments---'+tobeDeletedAttachments); if (tobeDeletedAttachments != null && tobeDeletedAttachments.size()>0) { delete tobeDeletedAttachments; } if (!parentReqDocIds.isEmpty()) { for (ID objId:parentReqDocIds) { toBeDeletedDocs.add(new g_reqDoc__c(id=objId)); } if (!toBeDeletedDocs.isEmpty()) { System.debug('Deleted attachments: ' + toBeDeletedDocs); delete toBeDeletedDocs; } } } /*US APD3911 End*/

        public void AP(g_Req__c R, g_Tran__c Trn, Set<Id> riId) {
            System.debug('** Inside AP with 3');
            Boolean isUpdate;Boolean transComplete;
            /*List<ws_call__c> wsList = new List<ws_call__c>();
for (g_reqitem__c objRi:[select id, (select id from WS_Calls__r) from g_reqitem__c where RQ__c=:R.id]) {
if (objRi.WS_Calls__r.size()==0 && Trn.TP__c=='Payment' && R.STA__c == 'Completed') {
ws_call__c objWs= new ws_call__c(intsts__c='Ready for Integration', rq_jsn__c=Trn.name);
wsList.add(objWs);
}
}
if (wsList != null && !wsList.isEmpty())insert wsList;
*/
            try{
                if (R.srvc__r.stg__r.apx__c != null) {
                    System.debug('** R.srvc__r.stg__r.apx__c 1');
                    if (Trn.STA__c == 'Completed') {
                        System.debug('** Completed 1');
                        if (R.xfpc__c == null) {
                            R.xfpc__c = Datetime.now();
                            System.debug('** R.CreatedDate:'+R.CreatedDate);
                            System.debug('** R.xfpc__c:'+R.xfpc__c);
                            R.xrepd__c=((Double)BusinessHours.diff(mBH.Id, R.CreatedDate, R.xfpc__c))/toDay; /*update R;*/
                        }
                        transComplete = true;
                    }

                    System.debug('** After R.srvc__r.stg__r.apx__c');
                    Type t = Type.forName(R.srvc__r.stg__r.apx__c);
                    grqI.intR obj=(grqI.intR)t.newInstance();
                    System.debug('** before isUpdate');
                    isUpdate=obj.AP(R, Trn);
                    System.debug('** after isUpdate:'+isUpdate);
                }
                System.debug('** transComplete:'+transComplete);
                if (Trn.STA__c == 'Completed') {
                    System.debug('** inside if 23');

                    List<g_reqitem__c> rilst = [select id, sta__c, sta__r.Next_Status__c from g_reqitem__c where RQ__c=:R.id and sta__r.Next_Status__c != null and sta__r.cd__c in ('rc',
                        'rcc', 'nc', 'ncc')];
                    if (rilst != null && !rilst.isEmpty()) {
                        for (g_reqitem__c ri : rilst) {
                            ri.sta__c = ri.sta__r.Next_Status__c;
                        }
                        if (Schema.sObjectType.g_reqitem__c.isUpdateable()) {
                            update rilst;
                        }
                    }
                    List<String> crpUidLst = Label.CrpSrvUid.split(';');
                    if (crpUidLst != null && crpUidLst.contains(R.srvc__r.uid__c)) {
                        system.debug('srvid::'+R.srvc__r.uid__c);
                        Set<id> riIdLst = new Set<Id>();
                        for (g_reqitem__c ri : [select id from g_reqitem__c where RQ__c=:R.id]) {
                            riIdLst.add(ri.id);
                        }
                        ShiftItems(R, Trn, riIdLst);
                    }
                    else
                        ShiftItems(R, Trn, riId);
                    update R;

                }

            }catch (Exception e) {system.debug(e.getMessage());}
        }

        /*After payment processing*/
        /****Item creation and closure date ***/
        private void ShiftItems(g_Req__c R, g_Tran__c T, Set<Id> riIds) { List<g_Milestone__c> lstms=new List<g_Milestone__c>();
         if (riIds != NULL) {
             List<g_reqitem__c> itemsToShift = new List<g_reqitem__c>();
             Map<Id, g_reqitem__c> reqItemsmap = new Map<Id, g_reqitem__c>([Select CreatedDate,
                 exp__c, sta__r.rqSTA__c, sta__r.slaa__c, sta__r.slaXP__c, sta__r.slaN__c, RQ__c,
                 sta__r.Tp__c, dtsc__c, itmCd__c, sta__r.Milestone__c, sta__r.Shift_At__c, sta__r.Shift_Items__c,
                 sta__r.slaat__c, xited__c, dtic__c, xcsla__c, fpd__c, islax__c, islan__c, dtieclsx__c,
                 dtieclsn__c, dtielx__c, dtieln__c, slaXP__c, slaN__c from g_reqitem__c Where RQ__c =: R.Id  AND isDeleted=false]);
             Set<Id> reqIds= new Set<id>();
             reqIds.add(R.Id);
             Map<String, g_Milestone__c> mpMslId = MilestnH.getMilestoneMap(reqIds);
             //g_Milestone__c ms = mpMslId.get(i.RQ__c+oSTA.Milestone__c);

             Set<string> itmCodesToShift = new Set<String>();
             Map<String, String> statusSlaMap = new Map<string, String>();
             Map<String, String> requestStatusTypeMap = new Map<String, String>();

             for (Id reqItemId : riIds) {
                 g_reqitem__c reqItem = reqItemsmap.get(reqItemId);
                 if (reqItem.sta__r.Shift_At__c=='Payment') {
                     if (!String.isBlank(reqItem.sta__r.Shift_Items__c)) {
                         grqSlah.splitShiftItems(reqItem.sta__r.Shift_Items__c, reqItem, statusSlaMap, null, itmCodesToShift);
                     }

                     //if (reqItem.sta__r.Shift_At__c=='Immediate') {
                     g_Milestone__c ms = mpMslId.get(R.Id+reqItem.sta__r.Milestone__c);

                     system.debug('##############Status__cStatus__c#############');
                     system.debug(ms.Name__c);system.debug(ms.Status__c);
                     

                     if (ms.Status__c=='Draft') {
                         ms.Status__c='Open';
                         lstms.add(ms);
                     }

                     //}

                 }

                 System.debug('reqItem.sta__r: ' + reqItem.sta__r.rqSTA__c + '  '  + reqItem.sta__c);
                 if (R.STA__c != reqItem.sta__r.rqSTA__c && reqItem.sta__r.rqSTA__c=='Under Review') {
                     R.STA__c=reqItem.sta__r.rqSTA__c;
                 }

             }
             for (g_reqitem__c item : reqItemsmap.values()) {
                 if (itmCodesToShift.contains(item.itmCd__c)) {
                     itemsToShift.add(item);
                 }
             }
             System.debug('itemsToShift&&&&'+ itemsToShift);
             if (itemsToShift.size()>0)
                 grqSlaH.shiftItems(itemsToShift, true, mBH.Id, statusSlaMap, null);
         }

         if (lstms != null && lstms.size()>0) {
             if (Schema.sObjectType.g_Milestone__c.isUpdateable()) {
                 update lstms;
             }
         }
        }
        public void hIB(list<g_Req__c>news) {this.excH(news, null, tSCP.IB);}
        public void hIA(list<g_Req__c>news) {this.excH(news, null, tSCP.IA);}
        public void hUB(map<Id, g_Req__c> news, map<Id, g_Req__c>olds) {this.excH(news.values(), olds, tSCP.UB);}
        public void hUA(map<Id, g_Req__c> news, map<Id, g_Req__c>olds) {this.excH(news.values(), olds, tSCP.UA);}
        public void hDB(map<Id, g_Req__c>olds) {this.excH(null, olds, tSCP.DB);}
        public void hDA(map<Id, g_Req__c>olds) {this.excH(null, olds, tSCP.DA);}
    }

    public class iH{

        public iH() {
            if (mBH == null) {mBH = [SELECT Id FROM BusinessHours WHERE id=: gU.csStr('BH')];}
        }
        private void excBRLS(list<xObj>Is, map<Id, g_Req__c>mR, tSCP scp) {

            set<String> fNames = new set<String>();
            for (g_Req__c r:mR.values()) {
                fNames.add(r.srvc__r.stg__r.itmbrules__c);}
            map<String, list<bRLs.bRL>> mRules = getBRules(false, fNames, scp);
            for (Integer batch=1;batch<3;batch++) {
                for (xObj i: Is) {
                    system.debug('tst1::');
                    //if (mR.get((Id)i.o.get('RQ__c')).AP__c>0  || (mR.get((Id)i.o.get('RQ__c')).srvc__r.uid__c == '136') || (mR.get((Id)i.o.get('RQ__c')).srvc__r.uid__c == '155') || (mR.get((Id)i.o.get('RQ__c')).srvc__r.uid__c == '148') || (mR.get((Id)i.o.get('RQ__c')).srvc__r.uid__c == '019') ||  (mR.get((Id)i.o.get('RQ__c')).srvc__r.uid__c == '003') ) {
                    if (mR.get((Id)i.o.get('RQ__c')).AP__c>0 || (mR.get((Id)i.o.get('RQ__c')).AT__c == 0 && mR.get((Id)i.o.get('RQ__c')).AOP__c == 0 && mR.get((Id)i.o.get('RQ__c')).AP__c == 0) || (mR.get((Id)i.o.get('RQ__c')).AT__c >0 && mR.get((Id)i.o.get('RQ__c')).AOP__c == mR.get((Id)i.o.get('RQ__c')).AP__c )) {
                        system.debug('tst2::');
                        list<bRLs.bRL> bRules =  mRules.get(mR.get((Id)i.o.get('RQ__c')).srvc__r.stg__r.itmbrules__c);
                        if (bRules != null) {  system.debug('tst3::');bRLs.exc(i.pl, bRules, batch);}
                    }
                }
                excBtch(Is);
            }
        }

        /*Ms 1.1*/
        public void yardiAtt(list < g_reqitem__c > news, map < Id, g_reqitem__c > olds) {
            map<string, list<g_reqitem__c>> mapRqitm = new map<string, list<g_reqitem__c>>();
            list<g_reqitem__c> lstLandItem = new list<g_reqitem__c>();
            list<String> lstReq = new list<String>();
            for (g_reqitem__c objrqItm : [Select Id, sta__c , itmCd__c, RQ__c,
                RQ__r.xvtyp__c from g_reqitem__c where RQ__r.parCat__c = 'Land' and sta__r.name = 'Approve' and Service_Code__c = '216']) {
                if (objrqItm.sta__c != olds.get(objrqItm.id).sta__c) {
                    lstReq.add(objrqItm.RQ__c);
                    lstLandItem.add(objrqItm);
                }
            }
            set<String> setDedItm = new set<String>{
            'br', 'se', 'hsc', 'dr'}
            ;
            set<String> setDdaItm = new set<String>{
            'br', 'sc', 'dr'}
            ;
            map<String, list<g_reqitem__c>> maprqDedItm = new map<String, list<g_reqitem__c>>();
            map<String, list<g_reqitem__c>> maprqDdaItm = new map<String, list<g_reqitem__c>>();
            for (g_reqitem__c objItem:  [Select Id, rq__c, itmCd__c, rq__r.xvtyp__c, sta__r.name from g_reqitem__c where itmCd__c in: setDedItm and rq__c In: lstReq and  sta__r.name = 'Approved']) {
                if (objItem.rq__r.xvtyp__c == 'DED' && setDedItm.contains(objItem.itmCd__c)) {
                    if (!maprqDedItm.containsKey(objItem.rq__c)) {
                        maprqDedItm.put(objItem.rq__c, new list<g_reqitem__c>{
                        objItem}
                        );
                    }
                    else if (maprqDedItm.containsKey(objItem.rq__c)) {
                        list<g_reqitem__c> lstrqitm = maprqDedItm.get(objItem.rq__c);
                        lstrqitm.add(objItem);
                        maprqDedItm.put(objItem.rq__c, lstrqitm);
                    }
                }
                else  if (objItem.rq__r.xvtyp__c == 'DDA' && setDdaItm.contains(objItem.itmCd__c)) {
                    if (!maprqDdaItm.containsKey(objItem.rq__c)) {
                        maprqDdaItm.put(objItem.rq__c, new list<g_reqitem__c>{
                        objItem}
                        );
                    }
                    else if (maprqDdaItm.containsKey(objItem.rq__c)) {
                        list<g_reqitem__c> lstrqitm = maprqDdaItm.get(objItem.rq__c);
                        lstrqitm.add(objItem);
                        maprqDdaItm.put(objItem.rq__c, lstrqitm);
                    }
                }
            }
            list<String> lstrqid = new list<String>();
            if (!maprqDedItm.isEmpty()) {
                for (String strrqid : maprqDedItm.keySet()) {
                    if (maprqDedItm.get(strrqid).size() == 4) {
                        lstrqid.add(strrqid);
                    }
                }
            }
            if (!maprqDdaItm.isEmpty()) {
                for (String strrqid : maprqDdaItm.keySet()) {
                    if (maprqDdaItm.get(strrqid).size() == 3) {
                        lstrqid.add(strrqid);
                    }
                }
            }
            if (!lstrqid.isEmpty()) {
                /*gtFussionWs.insertLandWsAtt(lstrqid);
            */ }
        }

        // Webservice Calls Generic Method
        public void wsCalls(list < g_reqitem__c > news, map < Id, g_reqitem__c > olds, map < Id, g_srvcitm_Status__c > mSTA, map < Id, g_Req__c > mR, map<Id, Contact> mCtct) {
            system.debug('Inside ws call');
            Map<Id, g_Req__c> mapItmPolicyDoc    = new Map<Id, g_Req__c>();
            Map<Id, g_Req__c> reqMap             = new Map<Id, g_Req__c>();
            Map<Id, g_Req__c> mapItmPolicyGen    = new Map<Id, g_Req__c>();
            Map<Id, g_Req__c> mapDccaRenLic    = new Map<Id, g_Req__c>();
            List<g_Req__c>  dccaReqList= new  List<g_Req__c>();
            List<g_reqitem__c> regItmPolicyGen  = new List<g_reqitem__c>();
            List<g_reqitem__c> reqItmDHA  = new List<g_reqitem__c>();
             List<g_reqitem__c> reqGVItmDHA  = new List<g_reqitem__c>();
            List<g_reqitem__c> reqItmRP  = new List<g_reqitem__c>();
            List<g_reqitem__c> reqItmLA  = new List<g_reqitem__c>();
            List<g_reqitem__c> reqLAAmd  = new List<g_reqitem__c>();

            List<g_reqitem__c> regItmLetters    = new List<g_reqitem__c>();
            List<g_reqitem__c> extStatusUpdate    = new List<g_reqitem__c>();
            List<g_reqitem__c> regItmPolicyDoc  = new List<g_reqitem__c>();
            List<g_reqitem__c> regItmCour       = new List<g_reqitem__c>(); //added for courierSrvc, SH2.0
            List<g_reqitem__c> regItmCourCol       = new List<g_reqitem__c>(); //added for courierSrvc Collection, SH2.0
            List<g_reqitem__c> regDccaLic       = new List<g_reqitem__c>();
            List<g_reqitem__c> regDccaLicPSF       = new List<g_reqitem__c>();
            List<g_reqitem__c> regItmOb     = new List<g_reqitem__c>();
            List<g_reqitem__c> regItmOb1     = new List<g_reqitem__c>();
            List<g_reqitem__c> regItmObSts     = new List<g_reqitem__c>();
            List<id> usercreationWS     = new List<id>();

            Map<Id, String> callmethod  = new Map<Id, String>();
            for (g_reqitem__c i: news) {
                System.debug('<wsCalls> i.STA__c : ' + i.STA__c);
                Boolean cU = i.STA__c == null ? false : olds == null ? true : (olds.get(i.Id).STA__c != i.STA__c);
                    if (cU) {
                        g_Req__c rq = mR.get(i.RQ__c);
                        g_srvcitm_Status__c nSTA = mSTA.get(i.sta__c);
                        if (nSTA.ws_typ__c == 'Insurance') {
                            if (nSTA.cmthd__c != null && nSTA.cmthd__c != '') {
                                if (nSTA.cmthd__c.contains('generatePolicy')) {
                                    regItmPolicyGen.add(i);mapItmPolicyGen.put(i.id, rq);
                                }
                                if (nSTA.cmthd__c.contains('uploadDoc')) {regItmPolicyDoc.add(i); mapItmPolicyDoc.put(i.id, rq); }
                            }
                        }
                        System.debug('<WSCALL - nSTA.ws_typ__c> : ' + nSTA.ws_typ__c +':Method::'+nSTA.cmthd__c);
                        //Dcca Ren
                        if (nSTA.ws_typ__c == 'DCCA update status' && (nSTA.cmthd__c != null && (nSTA.cmthd__c.contains('dccaReqL'))) ) {
                            system.debug('JJJ adding Req');
                            regDccaLic.add(i);
                            reqMap.put(i.id, rq);
                                                                                                                                     }
                        //DCCA Letters
                        //Tecom PSF Approval
                        if (nSTA.ws_typ__c == 'TECOM' && (nSTA.cmthd__c != null && (nSTA.cmthd__c.contains('psfApproval'))) ) {
                            system.debug('JJJ adding PSF');
                            reqMap.put(i.id, rq);
                            regDccaLicPSF.add(i);
                            reqMap.put(i.id, rq);
                        }
                        if (nSTA.ws_typ__c == 'DHA Medical' && nSTA.ws_mtd__c == 'newDHA') {
                            reqItmDHA.add(i);
                        }
                         if (nSTA.ws_typ__c == 'DHA Medical' && rq.srvc__r.uid__c=='gv'  && nSTA.ws_mtd__c == 'createApplication') {
                            reqGVItmDHA.add(i);
                        }
                        if (nSTA.ws_typ__c == 'Immigration EVEP' && nSTA.ws_mtd__c == 'createLAApplication') {
                            reqItmLA.add(i);
                        }
                        if (nSTA.ws_typ__c == 'Immigration EVEP' && nSTA.ws_mtd__c == 'createApplication') {
                            reqItmRP.add(i);
                        }

                        if (nSTA.ws_typ__c == 'DCCA Letters' ) {
                            regItmLetters.add(i);reqMap.put(i.id, rq);
                            // if (nSTA.cmthd__c != null && (nSTA.cmthd__c.contains('dccaReqL'))) {callmethod.put(i.Id, 'dccaReqL');}
                            if (nSTA.cmthd__c != null && (nSTA.cmthd__c.contains('dccaApproval') || nSTA.cmthd__c.contains('uploadDoc') )) {
                                callmethod.put(i.Id, 'dccaApproval');
                            }else if (nSTA.cmthd__c != null && (nSTA.cmthd__c.contains('arabicDataMissing'))) {
                                callmethod.put(i.Id, 'arabicDataMissing');
                            } else if (nSTA.cmthd__c != null && (nSTA.cmthd__c.contains('getArabicData'))) {
                                callmethod.put(i.Id, 'getArabicData');
                            } else {
                                callmethod.put(i.Id, 'dccaServiceRq');
                            }
                        }

                        if (nSTA.ws_typ__c == 'DCCA update status') {system.debug('Inside loop JJ Update Status ');extStatusUpdate.add(i);reqMap.put(i.id, rq);
                                                                    if (nSTA.cmthd__c != null && (nSTA.cmthd__c.contains('dccaUpdStatus') )) {
                                                                        system.debug('Call method true JJJ');
                                                                        callmethod.put(i.Id, 'dccaUpdStatus');
                                                                    }
                                                                   }
                        if (nSTA.ws_typ__c == 'Onboarding' && (nSTA.cmthd__c != null && (nSTA.cmthd__c.contains('updateAccInfo'))) ) {
                            regItmOb.add(i);reqMap.put(i.id, rq);
                        }
                        if (nSTA.ws_typ__c == 'License Amendments' && (nSTA.cmthd__c != null && (nSTA.cmthd__c.contains('statusUpdate'))) ) {
                            reqLAAmd.add(i);reqMap.put(i.id, rq);
                        }

                        if (nSTA.ws_typ__c == 'Onboarding' && (nSTA.cmthd__c != null && (nSTA.cmthd__c.contains('fetchAccInfo'))) ) {
                            regItmOb1.add(i);reqMap.put(i.id, rq);
                        }
                        if (nSTA.ws_typ__c == 'Onboarding' && (nSTA.cmthd__c != null && (nSTA.cmthd__c.contains('updateStatus'))) ) {
                            regItmObSts.add(i);reqMap.put(i.id, rq);
                        }
                        if (nSTA.ws_typ__c == 'Onboarding' && (nSTA.cmthd__c != null && (nSTA.cmthd__c.contains('attachRICtoMember')))) {
                            regItmOb.add(i);reqMap.put(i.id, rq);
                        }
                        if (nSTA.ws_typ__c == 'Onboarding' && (nSTA.cmthd__c != null && (nSTA.cmthd__c.contains('userCreationLA'))) && nSTA.ws_mtd__c == 'UserCreation') {
                            usercreationWS.add(i.Id);
                        }
                        if (nSTA.ws_typ__c == 'Courier Booking') { if (nSTA.cmthd__c != null && (nSTA.cmthd__c.contains('booking;') )) { grqWsCourier.wsCourBooking(i.rq__c); } }
                        if (nSTA.ws_typ__c == 'Courier Service') {
                            system.debug('Call  collection method true JJJ');
                            if (nSTA.cmthd__c != null && (nSTA.cmthd__c.contains('collection;') )) {
                                system.debug('Call  collection 2 method true JJJ'); regItmCourCol.add(i);
                            } else {
                                regItmCour.add(i);
                                //toDo : check whether to create new map
                            }
                            reqMap.put(i.id, rq);
                        }
                    }
            }
            if (usercreationWS != null && usercreationWS.size() > 0) {
                grqWsInsH.createUserLA(usercreationWS);
            }
            if (reqItmDHA != null && reqItmDHA.size() > 0) {
                grqWsInsH.createMedicalRequest(reqItmDHA, 'DHA Medical', 'newDHA');
            }

            if (reqGVItmDHA != null  && reqGVItmDHA.size() > 0) {
                grqWsInsH.createMedicalRequest(reqGVItmDHA, 'DHA Medical', 'createApplication');
            }

            if (reqLAAmd != null && reqLAAmd.size()>0) {
                grqWsInsH.createLAMD(reqLAAmd, 'License Amendments', 'statusUpdate');
            }
            if (reqItmLA != null && reqItmLA.size() > 0) {
                grqWsInsH.createLARequest(reqItmLA, 'Immigration EVEP', 'createApplication');
            }
            if (reqItmRP != null && reqItmRP.size() > 0) {
                grqWsInsH.createRPRequest(reqItmRP, 'Immigration EVEP', 'createApplication');
            }

            // if (regDccaLicPSF.size()>0) {system.debug('JJJ Calling WS call for DCCA Ren PSF service'); grqWsPSFApproval.createPSFAppCall(regDccaLicPSF, reqMap, 'TECOMCALL', 'PSFApp');}
            if (regItmOb.size()>0) {grqWsOnboard.updateAccInfo(regItmOb, reqMap, 'Onboarding', 'updateAccInfo');}
            if (regItmOb1.size()>0) {grqWsOnboard.fetchAccInfo(regItmOb1, reqMap, 'Onboarding', 'fetchAccInfo');}
            if (regItmObSts.size()>0) {grqWsOnboard.fetchAccInfo(regItmObSts, reqMap, 'Onboarding', 'updateStatus');}
            if (regDccaLic.size()>0) {system.debug('JJJ Calling WS call for DCCA Ren'); grqWsDccaGetService.sendDccaLic(regDccaLic, reqMap, 'DCCA License Renewals', 'dccaReqL');}
            System.debug('<regItmCour>: ' + regItmCour.size());
            grqWsInsH.insgeneratePolicy(regItmPolicyGen, mapItmPolicyGen, 'Insurance', 'generatePolicy', mCtct);
            if (regItmLetters.size()>0) {
                grqWsDcca.createLetter(regItmLetters, reqMap, 'DCCA Letters', callmethod);
            }else if (regItmCour.size()>0) {
                /** toDo: use createLetter of class grqWsDcca **/
                grqWsCourier.insertRecord(regItmCour, reqMap, 'Courier Service', 'updateCourSta');
            }else if (regItmCourCol.size()>0) {
                /** toDo: use createLetter of class grqWsDcca **/
                String callMthd = (olds == null)?'updateCourColSta':'updateCourSta';
                grqWsCourier.insertRecord(regItmCourCol, reqMap, 'Courier Service', callMthd);
            }

            //else if (regItmCourBooking.size()>0) {
            //    grqWsCourier.wsCourBooking(regItmCourCol[0].id);
            //}

            if (extStatusUpdate.size()>0) {system.debug('Calling the calss grqWsExtStatusUpd'); grqWsExtStatusUpd.statusUpdate(extStatusUpdate, reqMap, 'DCCA update status', callmethod);}
        }

        private void claimRefund(list < g_reqitem__c > news, map < Id, g_reqitem__c > olds, map < Id, g_srvcitm_Status__c > mSTA, map < Id, g_Req__c > mR) {
            system.debug('inside claimrefund');
            map < String, g_Tran__c > mT = new map < String, g_Tran__c > ();
            list < g_TranItem__c > iTs = new list < g_TranItem__c > ();
            list < g_TranItem__c > niTs = new list < g_TranItem__c > ();
            list < g_Tran__c > Ts = new list < g_Tran__c > ();
            for (g_reqitem__c i: news) {
                Boolean cU = i.STA__c == null ? false : olds == null ? true : (olds.get(i.Id).STA__c != i.STA__c);
                if (cU && (i.AP__c > 0 || i.AT__c == 0 || i.Service_Code__c == 'grf'|| i.Service_Code__c=='159')) {
                    g_srvcitm_Status__c nSTA = mSTA.get(i.sta__c);
                    Decimal clmA = (nSTA.clmA__c == null ? 0 : nSTA.clmA__c) + (i.KF__c == null ? 0 : i.KF__c) + (i.cN__c == null ? 0 : i.cN__c) +
                        (i.vst__c == null ? 0 : i.vst__c) + (i.exp__c ? (i.cXP__c == null ? 0 : i.cXP__c) + (i.vec__c == null ? 0 : i.vec__c) : 0);
                    Decimal rfnA = ((i.KF__c == null ? 0 : i.KF__c) + (i.smN__c == null ? 0 : i.smN__c)) +
                        (i.exp__c ? +(i.smXP__c == null ? 0 : i.smXP__c) : 0) - (i.DscApp__c ? (i.Dsc__c == null ? 0 : i.Dsc__c) : 0) - (i.AR__c == null ? 0 : i.AR__c);
                    system.debug('#############clmA##################');
                    system.debug(clmA);
                    system.debug('########clmA#######################');
                    Decimal rfnGV = 0;
                    Decimal rfnNG = 0;
                    String taxCodeG = i.TAXCODE_SC__c;
                    String taxCode = i.TAX_CODE__c;
                    if ((i.vsc__c != 0 || i.vst__c != 0) || (i.exp__c && (i.vesch__c != 0 || i.vec__c != 0))) {
                        if (i.vsc__c != 0) rfnNG = rfnNG + i.scN__c + (i.vsc__c == null ? 0 : i.vsc__c);
                        else rfnA = rfnA + (i.scN__c == null ? 0 : i.scN__c);
                        if (i.vst__c != 0) rfnGV = rfnGV + i.cN__c + (i.vst__c == null ? 0 : i.vst__c);
                        else rfnA = rfnA + (i.cN__c == null ? 0 : i.cN__c);
                        if (i.exp__c) {
                            if (i.vesch__c != 0) {
                                taxCode = i.extc__c;
                                rfnNG = rfnNG + i.scXP__c + (i.vesch__c == null ? 0 : i.vesch__c);
                            }
                            else rfnA = rfnA + (i.scXP__c == null ? 0 : i.scXP__c);
                            if (i.vec__c != 0) {
                                taxCodeG = i.extcsc__c;
                                rfnGV = rfnGV + i.cXP__c + (i.vec__c == null ? 0 : i.vec__c);
                            }
                            else rfnA = rfnA + (i.cXP__c == null ? 0 : i.cXP__c);
                        }
                    }
                    else rfnA = rfnA + (i.cN__c == null ? 0 : i.cN__c) + (i.exp__c ? (i.cXP__c == null ? 0 : i.cXP__c) : 0) +
                        (i.scN__c == null ? 0 : i.scN__c) + (i.exp__c ? (i.scXP__c == null ? 0 : i.scXP__c) : 0);
                    g_Req__c rq = mR.get(i.RQ__c);
                    if (nSTA.clm__c && clmA >= 0 && i.Total_Claim__c == 0) {
                        /*if claim amount is zero*/ if (mT.get('Claim' + i.Id) == null) {
                            mT.put('Claim' + i.Id, new g_Tran__c(Acc__c = rq.Acc__c, RQ__c = i.RQ__c, dt__c = Date.today(), md__c = 'Cash', STA__c = 'Completed', TP__c = 'Claim'));
                        }
                        iTs.add(new g_TranItem__c(A__c = clmA, exp__c = i.exp__c, itm__c = i.id, STA__c = 'Completed', Tp__c = 'Claim'));
                    }
                    if (nSTA.rfnd__c && (rfnA > 0 || rfnGV > 0 || rfnNG > 0 || (nSTA.rfndA__c != null && nSTA.rfndA__c > 0))) {
                        /* if refund amount is zero*/ /*logic added to allocate the refund to main transaction*/ if (mT.get('Refund' + i.Id) == null && mT.size() == 0) {
                            mT.put('Refund' + i.Id, new g_Tran__c(Acc__c = rq.Acc__c, RQ__c = i.RQ__c, dt__c = Date.today(), md__c = 'Cash', STA__c = 'Open', TP__c = 'Refund'));
                        }
                        if (nSTA.rfndA__c != null && nSTA.rfndA__c > 0) iTs.add(new g_TranItem__c(A__c = nSTA.rfndA__c,
                            exp__c = i.exp__c, itm__c = i.id, STA__c = 'Open', Tp__c = 'Refund',
                            VAT__c = 0, TAX_CODE__c = gu.csStr('TAXCodeEXEMPTED')));
                        else {
                            if (rfnA > 0) iTs.add(new g_TranItem__c(A__c = rfnA, exp__c = i.exp__c,
                                itm__c = i.id, STA__c = 'Open', Tp__c = 'Refund', VAT__c = 0,
                                TAX_CODE__c = gu.csStr('TAXCodeEXEMPTED')));
                            if (rfnGV > 0) iTs.add(new g_TranItem__c(A__c = rfnGV, exp__c = i.exp__c, itm__c = i.id, STA__c = 'Open', VAT__c = i.tvatp__c, Tp__c = 'Refund', TAX_CODE__c = taxCodeG));
                            if (rfnNG > 0) iTs.add(new g_TranItem__c(A__c = rfnNG, exp__c = i.exp__c, itm__c = i.id, STA__c = 'Open', Tp__c = 'Refund', VAT__c = i.tvngp__c, TAX_CODE__c = taxCode));
                        }
                    }
                }
            }
            if (mT.size() > 0) {
                insert mT.Values();
                for (g_TranItem__c i: iTs) {
                    if (mT.get(i.Tp__c + i.itm__c) != null) {
                        i.T__c = mT.get(i.Tp__c + i.itm__c).Id;
                        niTs.add(i);
                    }
                    else if (mT != null && mT.size() == 1) {
                        String key1;
                        for (String key: mT.keySet()) {
                            key1 = key;
                        }
                        i.T__c = mT.get(key1).Id;
                        niTs.add(i);
                    }
                }
                if (niTs != null && niTs.size() > 0) {
                    if (Schema.sObjectType.g_TranItem__c.isCreateable()) {
                        insert niTs;
                    }
                }
            }
        }
        //private void linkDocs(list<g_reqitem__c> Is, map<Id, g_Req__c> mR) { try { /*map of Request/Member/Docs */ map<Id, map<Id, map<String, g_reqDoc__c>>> mapD = new map<Id, map<Id, map<String, g_reqDoc__c>>>(); /*map of SrvcItem and related ReqItems*/map<Id, list<g_reqitem__c>> mapI = new map<Id, list<g_reqitem__c>>(); for (g_reqitem__c i: Is) { mapD.put(i.RQ__c, new map<Id, map<String, g_reqDoc__c>>()); if (mapI.get(i.itm__c) == null) {mapI.put(i.itm__c, new list<g_reqitem__c>());} mapI.get(i.itm__c).add(i); } /*(1) load docs with members*/ for (g_reqDoc__c d: [select id, Name, RQ__c, mbr__c from g_reqDoc__c where RQ__c in: mapD.KeySet() ]) {if (mapD.get(d.RQ__c).get(d.mbr__c)==null) {mapD.get(d.RQ__c).put(d.mbr__c, new map<String, g_reqDoc__c>());}mapD.get(d.RQ__c).get(d.mbr__c).put(d.Name, d);} /*(2) load required docs for service items*/ list<g_srvcitm__c> sIs = new list<g_srvcitm__c>([select id, (Select Id, Name, lbl__c, mxAts__c, reqAts__c, reqOr__c, Req__c, mnAts__c, Tp__c, rqc__c, ord__c, Doc_Description__c, Download_Doc_Link__c From Docs__r where isDeleted=false) From g_srvcitm__c where id in:mapI.KeySet()]); /*(3)match required docs for every Req/Mem*/list<g_reqDoc__c> docs = new list<g_reqDoc__c>(); for (g_srvcitm__c si: sIs) { for (g_reqitem__c i: mapI.get(si.Id)) { map<String, g_reqDoc__c> mDocs = mapD.get(i.RQ__c).get(i.m__c); if (mDocs == null) {mDocs = new map<String, g_reqDoc__c>();} for (g_srvcitm_Doc__c d: si.Docs__r) {if (mDocs.get(d.Name)==null) {g_reqDoc__c rDoc = new g_reqDoc__c(Name=d.Name, RQ__c=i.RQ__c, mbr__c=i.m__c, ord__c=d.ord__c, Doc_Description__c=d.Doc_Description__c, Download_Doc_Link__c=d.Download_Doc_Link__c);docs.add(rDoc);mDocs.put(d.Name, rDoc);}} mapD.get(i.RQ__c).put(i.m__c, mDocs); } } /*(4)create unmatched docs*/if (docs.size()>0) {insert docs;} /*(5)create required docs for ReqItems*/list<g_reqitemDoc__c> iDocs = new list<g_reqitemDoc__c>();     Integer cnt=0;  for (g_srvcitm__c si: sIs) { for (g_reqitem__c i: mapI.get(si.Id)) { for (g_srvcitm_Doc__c d: si.Docs__r) { cnt=1;  Id docId = mapD.get(i.RQ__c).get(i.m__c).get(d.Name).Id; g_Req__c rq = mR.get(i.RQ__c); if (rq.xcddocs__c != null && rq.xcddocs__c != '') {  List<String> doclst = rq.xcddocs__c.split(';'); List<String> newdoclst = new List<String>(); map<String, Integer> countMap = new map<String, Integer>(); for (String doc:doclst) { system.debug('###doclst###'+doclst); if (doc.contains(':')) { system.debug('###cnt###'+cnt);   List<String> newdoc = doc.split(':'); if (!countMap.containsKey(newdoc[0])) { cnt=1; countMap.put(newdoc[0], cnt); }else{ Integer cnt1 = countMap.get(newdoc[0]); cnt1++; countMap.put(newdoc[0], cnt1); } newdoclst.add(newdoc[0]);  }else{ newdoclst.add(doc);  } system.debug('###newdoclst###'+newdoclst); } Integer newcnt; if (countMap.containsKey(d.name)) { newcnt = countMap.get(d.name);} else newcnt=1;  if (newdoclst != null && newdoclst.contains(d.name)) iDocs.add(new g_reqitemDoc__c(Name = d.Name, lbl__c = d.lbl__c, reqItm__c = i.Id, reqDoc__c = docId, Req__c = true, reqOr__c = d.reqOr__c, reqAts__c = true, mnAts__c = newcnt, mxAts__c = newcnt, Tp__c = d.Tp__c, rqc__c=d.rqc__c)); else iDocs.add(new g_reqitemDoc__c(Name = d.Name, lbl__c = d.lbl__c, reqItm__c = i.Id, reqDoc__c = docId, Req__c = d.Req__c, reqOr__c = d.reqOr__c, reqAts__c = d.reqAts__c, mnAts__c = d.mnAts__c, mxAts__c = d.mxAts__c, Tp__c = d.Tp__c, rqc__c=d.rqc__c));} else iDocs.add(new g_reqitemDoc__c(Name = d.Name, lbl__c = d.lbl__c, reqItm__c = i.Id, reqDoc__c = docId, Req__c = d.Req__c, reqOr__c = d.reqOr__c, reqAts__c = d.reqAts__c, mnAts__c = d.mnAts__c, mxAts__c = d.mxAts__c, Tp__c = d.Tp__c, rqc__c=d.rqc__c)); } } } if (iDocs.size()>0) {insert iDocs; copydocs(mR); } } catch (Exception e) { System.debug('** Exception Message:'+e.getStackTraceString()); } }
        private void linkDocs(list < g_reqitem__c > Is, map < Id, g_Req__c > mR) {
            try {
                /*map of Request/Member/Docs */ map < Id, map < Id, map < String, g_reqDoc__c >>> mapD = new map < Id, map < Id, map < String, g_reqDoc__c >>> ();
                /*map of SrvcItem and related ReqItems*/ map < Id, list < g_reqitem__c >> mapI = new map < Id, list < g_reqitem__c >> ();
                for (g_reqitem__c i: Is) {
                    mapD.put(i.RQ__c, new map < Id, map < String, g_reqDoc__c >> ());
                    if (mapI.get(i.itm__c) == null) {
                        mapI.put(i.itm__c, new list < g_reqitem__c > ());
                    }
                    mapI.get(i.itm__c).add(i);
                }
                /*(1) load docs with members*/ for (g_reqDoc__c d: [select id, Name, RQ__c, mbr__c from g_reqDoc__c where RQ__c in: mapD.KeySet()]) {
                    if (mapD.get(d.RQ__c).get(d.mbr__c) == null) {
                        mapD.get(d.RQ__c).put(d.mbr__c, new map < String, g_reqDoc__c > ());
                    }
                    mapD.get(d.RQ__c).get(d.mbr__c).put(d.Name, d);
                }
                /*(2) load required docs for service items*/ list < g_srvcitm__c > sIs = new list < g_srvcitm__c > ([select id, (Select Id, Name, lbl__c, mxAts__c, reqAts__c, reqOr__c, Req__c, mnAts__c, Tp__c, rqc__c, ord__c, Doc_Description__c, Download_Doc_Link__c From Docs__r where isDeleted = false) From g_srvcitm__c where id in: mapI.KeySet()]);
                /*(3)match required docs for every Req/Mem*/ list < g_reqDoc__c > docs = new list < g_reqDoc__c > ();
                for (g_srvcitm__c si: sIs) {
                    for (g_reqitem__c i: mapI.get(si.Id)) {
                        map < String, g_reqDoc__c > mDocs = mapD.get(i.RQ__c).get(i.m__c);
                        if (mDocs == null) {
                            mDocs = new map < String, g_reqDoc__c > ();
                        }
                        for (g_srvcitm_Doc__c d: si.Docs__r) {
                            if (mDocs.get(d.Name) == null) {
                                g_reqDoc__c rDoc = new g_reqDoc__c(Name = d.Name, RQ__c = i.RQ__c, mbr__c = i.m__c,
                                    ord__c = d.ord__c, Doc_Description__c = d.Doc_Description__c, Download_Doc_Link__c = d.Download_Doc_Link__c);
                                docs.add(rDoc);
                                mDocs.put(d.Name, rDoc);
                            }
                        }
                        mapD.get(i.RQ__c).put(i.m__c, mDocs);
                    }
                }
                /*(4)create unmatched docs*/ if (docs.size() > 0) {
                    if (Schema.sObjectType.g_reqDoc__c.isCreateable()) {
                        insert docs;
                    }
                }
                /*(5)create required docs for ReqItems*/ list < g_reqitemDoc__c > iDocs = new list < g_reqitemDoc__c > ();
                Integer cnt = 0;
                for (g_srvcitm__c si: sIs) {
                    for (g_reqitem__c i: mapI.get(si.Id)) {
                        for (g_srvcitm_Doc__c d: si.Docs__r) {
                            cnt = 1;
                            Id docId = mapD.get(i.RQ__c).get(i.m__c).get(d.Name).Id;
                            g_Req__c rq = mR.get(i.RQ__c);
                            if (rq.xcddocs__c != null && rq.xcddocs__c != '') {
                                List < String > doclst = rq.xcddocs__c.split(';');
                                List < String > newdoclst = new List < String > ();
                                map < String, Integer > countMap = new map < String, Integer > ();
                                for (String doc: doclst) {
                                    system.debug('###doclst###MKR' + doclst);
                                    if (doc.contains(':')) {
                                        system.debug('###cnt###' + cnt);
                                        List < String > newdoc = doc.split(':');
                                        if (!countMap.containsKey(newdoc[0])) {
                                            cnt = 1;
                                            countMap.put(newdoc[0], cnt);
                                        }
                                        else {
                                            Integer cnt1 = countMap.get(newdoc[0]);
                                            cnt1++;
                                            countMap.put(newdoc[0], cnt1);
                                        }
                                        newdoclst.add(newdoc[0]);
                                    }
                                    else {
                                        newdoclst.add(doc);
                                    }
                                    system.debug('###newdoclst###' + newdoclst);
                                }
                                Integer newcnt;
                                if (countMap.containsKey(d.name)) {
                                    newcnt = countMap.get(d.name);
                                }
                                else newcnt = 1;
                                if (newdoclst != null && newdoclst.contains(d.name)) iDocs.add(new g_reqitemDoc__c(Name = d.Name,
                                    lbl__c = d.lbl__c, reqItm__c = i.Id, reqDoc__c = docId, Req__c = true,
                                    reqOr__c = d.reqOr__c, reqAts__c = true, mnAts__c = newcnt, mxAts__c = newcnt,
                                    Tp__c = d.Tp__c, rqc__c = d.rqc__c));
                                else iDocs.add(new g_reqitemDoc__c(Name = d.Name, lbl__c = d.lbl__c,
                                    reqItm__c = i.Id, reqDoc__c = docId, Req__c = d.Req__c, reqOr__c = d.reqOr__c,
                                    reqAts__c = d.reqAts__c, mnAts__c = d.mnAts__c, mxAts__c = d.mxAts__c,
                                    Tp__c = d.Tp__c, rqc__c = d.rqc__c));
                            }
                            else iDocs.add(new g_reqitemDoc__c(Name = d.Name, lbl__c = d.lbl__c,
                                reqItm__c = i.Id, reqDoc__c = docId, Req__c = d.Req__c, reqOr__c = d.reqOr__c,
                                reqAts__c = d.reqAts__c, mnAts__c = d.mnAts__c, mxAts__c = d.mxAts__c,
                                Tp__c = d.Tp__c, rqc__c = d.rqc__c));
                        }
                    }
                }
                if (iDocs.size() > 0) {
                    insert iDocs;
                    copydocs(mR);
                }
            }
            catch (Exception e) {
                System.debug('** Exception Message:' + e.getStackTraceString());
            }
        }
        /*private void copydocs(map<Id, g_Req__c> mR) {

Map<string, Attachment> attMp = new Map<string, Attachment>();
List <Attachment> clnAttchLst = new List <Attachment>();
Attachment orgObj = null;
Attachment cloneObj = null;
for (Attachment att : [select id, name, body, parentid from Attachment where parentid=:mR.keySet()]) {
attMp.put(att.parentid+att.name.split('\\.')[0], att);
}
system.debug('mR.keySet()::'+mR.keySet());
system.debug('attMp size::'+attMp);
for (g_reqitemDoc__c doc : [select id, Name, reqItm__r.xcp__c,
    reqItm__r.rq__c, reqDoc__c from g_reqitemDoc__c where reqItm__r.rq__c=:mR.keySet() and Req__c=true and reqAts__c=true and upOk__c=false and rqc__c=true order by createddate]) {
system.debug('key::'+doc.reqItm__r.rq__c+doc.Name);

if ( attMp != null && (attMp.containsKey(doc.reqItm__r.rq__c+'Copy of Passport-'+doc.reqItm__r.xcp__c) || attMp.containsKey(doc.reqItm__r.rq__c+doc.Name))) {
system.debug('key1::'+doc.reqItm__r.rq__c+doc.Name);
if (attMp.containsKey(doc.reqItm__r.rq__c+'Copy of Passport-'+doc.reqItm__r.xcp__c))
orgObj = attMp.get(doc.reqItm__r.rq__c+'Copy of Passport-'+doc.reqItm__r.xcp__c);
else
orgObj = attMp.get(doc.reqItm__r.rq__c+doc.Name);
cloneObj = orgObj.clone(false, true, false, false);
cloneObj.parentid = doc.reqDoc__c;
clnAttchLst.add(cloneObj);
}
}
if (clnAttchLst != null && !clnAttchLst.isEmpty())
if (Schema.sObjectType.Attachment.isCreateable()) {
    insert clnAttchLst;
}

}*/

        private void dummyUpRIDs(list<g_reqitem__c> its) {
            set<Id> ids = new set<Id>();
            for (g_reqitem__c i: its) {
                ids.add(i.Id);
            }
            list<g_reqitemDoc__c> ds = [Select id From g_reqitemDoc__c where isDeleted = false and reqItm__c in:ids];
            if (ds.size()>0) {
                if (Schema.sObjectType.g_reqitemDoc__c.isUpdateable()) {
                    update ds;
                }
            }
        }
        private void shiftItmSTAs(list<g_reqitem__c>news, map<Id, g_reqitem__c>olds) {
            Set<Id> statusIdList = new Set<Id>();
            try{
                for (g_reqitem__c i: news) {
                    statusIdList.add(i.STA__c);
                }
                Map<Id, g_srvcitm_Status__c> statusMap = getSTAs(statusIdList);
                for (g_reqitem__c i: news) {
                    g_reqitem__c o = olds.get(i.Id);
                    if (o != null) {
                        if (o.STA__c != i.STA__c) {
                            statusIdList.add(i.STA__c);
                        }
                    }
                }
            }
            catch (Exception e) {
            }
        }

        private void iSTAhistory(list < g_reqitem__c > news, map < Id, g_reqitem__c > olds, map < Id, g_Req__c > rqMp) {
            System.debug('###inside status history creating');
            try {
                DateTime tdy = DateTime.now();
                Set < Id > requestIds = new Set < Id > ();
                Set < Id > statusIdList = new Set < Id > ();
                for (g_reqitem__c i: news) {
                    g_reqitem__c o = olds.get(i.Id);
                    if (o != null) {
                        if (o.STA__c != i.STA__c) {
                            requestIds.add(o.RQ__c);
                            statusIdList.add(o.STA__c);
                            statusIdList.add(i.STA__c);
                        }
                    }
                }
                list < g_itmHistorySTA__c > toInsert = new list < g_itmHistorySTA__c > ();
                Set < g_Milestone__c > mileStonesToUpdate = new Set < g_Milestone__c > ();
                Map < String, g_Milestone__c > mpMslId = MilestnH.getMilestoneMap(requestIds);
                Map < Id, g_srvcitm_Status__c > statusMap = getSTAs(statusIdList);
                boolean expFlg = false;
                for (g_reqitem__c i: news) {
                    g_reqitem__c o = olds.get(i.Id);
                    if (o != null) {
                        if (o.STA__c != i.STA__c) {
                            String nextStatus = 'Open';
                            if (statusMap.get(i.STA__c).slaa__c == 'Completed' || statusMap.get(i.STA__c).slaa__c == 'Cancelled' || statusMap.get(i.STA__c).slaa__c == 'Rejected') {
                                nextStatus = statusMap.get(i.STA__c).slaa__c;
                            }
                            g_srvcitm_Status__c oSTA = statusMap.get(o.STA__c);
                            g_Milestone__c ms = mpMslId.get(i.RQ__c + oSTA.Milestone__c);
                            if (ms != null) {
                                if (oSTA.slaa__c == 'Standard') expFlg = rqMp.get(i.RQ__c).expflg__c;
                                else expFlg = o.exp__c;
                                g_itmHistorySTA__c statusHistory = new g_itmHistorySTA__c(Milestone__c = ms.Id, RQ__c = i.RQ__c,
                                    staowner__c = oSTA.staown__c, itm__c = i.Id, f__c = o.STA__c, fcd__c=oSTA.cd__c,
                                    t__c = i.STA__c, tcd__c=statusMap.get(i.STA__c).cd__c, acts__c = o.dtsc__c, actE__c = tdy,
                                    estE__c = o.dtsecls__c, SLA_Action__c = oSTA.slaa__c, statype__c = oSTA.statype__c,
                                    sla__c = expFlg ? o.slaXP__c : o.slaN__c, exp__c = expFlg, Duration__c = ((Double) BusinessHours.diff(mBH.Id, o.dtsc__c != null ? o.dtsc__c : tdy, tdy)) / toHour,
                                    cd__c = 0);
                                if (!o.xcsla__c) {
                                    MilestnH.reCalculateHistoryAndMilestone(statusHistory, ms, mBH, nextStatus);
                                }
                                else if (oSTA.slaa__c != 'Auto') {
                                    statusHistory.SLA_Action__c = 'Parallel';
                                }
                                toInsert.add(statusHistory);
                            }
                        }
                    }
                }
                if (toInsert.size() > 0) {
                    if (Schema.sObjectType.g_itmHistorySTA__c.isCreateable()) {
                        insert toInsert;
                    }
                }
                if (mpMslId.size() > 0) {
                    update mpMslId.values();
                }
            }
            catch (Exception e) {
            }
        }
        private void excRflc(map<String, list<g_reqitem__c>>mRflc, map<Id, g_reqitem__c>olds,
            map<Id, g_Req__c>mR, map<Id, g_srvcitm_Status__c>mSTA, map<Id, Contact>mCtct, map<String,
            Contact>mcLnk, map<Id, User>mcU, tSCP scp) {

            if (scp == tSCP.IB) {for (String apx: mRflc.KeySet()) {Type t = Type.forName(apx);grqI.Intf obj=(grqI.Intf)t.newInstance();obj.hIB(mRflc.get(apx), mR, mSTA, mCtct, mcLnk, mcU);}}
            else if (scp == tSCP.IA) {for (String apx: mRflc.KeySet()) {Type t = Type.forName(apx);grqI.Intf obj=(grqI.Intf)t.newInstance();obj.hIA(mRflc.get(apx), mR, mSTA, mCtct, mcLnk, mcU);}}
            else if (scp == tSCP.UB) {
                for (String apx: mRflc.KeySet()) {
                    Type t = Type.forName(apx);
                    grqI.Intf obj=(grqI.Intf)t.newInstance();
                    obj.hUB(mRflc.get(apx), olds, mR, mSTA, mCtct, mcLnk, mcU);
                }
            }
            else if (scp == tSCP.UA) {
                for (String apx: mRflc.KeySet()) {
                    Type t = Type.forName(apx);
                    grqI.Intf obj=(grqI.Intf)t.newInstance();
                    obj.hUA(mRflc.get(apx), olds, mR, mSTA, mCtct, mcLnk, mcU);
                }
            }
            else if (scp == tSCP.DB) {
                for (String apx: mRflc.KeySet()) {
                    Type t = Type.forName(apx);
                    grqI.Intf obj=(grqI.Intf)t.newInstance();
                    obj.hDB(new map<Id, g_reqitem__c>(mRflc.get(apx)), mR, mSTA, mCtct, mcLnk, mcU);
                }
            }
            else if (scp == tSCP.DA) {
                for (String apx: mRflc.KeySet()) {
                    Type t = Type.forName(apx);
                    grqI.Intf obj=(grqI.Intf)t.newInstance();
                    obj.hDA(new map<Id, g_reqitem__c>(mRflc.get(apx)), mR, mSTA, mCtct, mcLnk, mcU);
                }
            }
        }

        private list<xObj> excH(list<g_reqitem__c>news, map<Id, g_reqitem__c>olds, tSCP scp) {
            list<xObj>Is=new list<xObj>();if (news == null&&olds == null) {return Is;}
            set<id> sids=new set<id>();set<id> rids=new set<id>();set<id> cids=new set<id>();set<String> cuids=new set<String>();
            list<g_reqitem__c>lst;if (news == null) {System.debug('#### OLD Items #####'); lst=olds.values();}else{System.debug('#### NEW Items #####');lst=news;}
            for (g_reqitem__c i:lst) {
                rids.add(i.RQ__c);sids.add(i.sta__c);
                if (i.xcnc__c != null&&i.xcp__c != null) {cuids.add(i.xcnc__c+i.xcp__c);}
            }
            if (news != null&&olds != null) {
                for (g_reqitem__c i:olds.Values()) {
                    sids.add(i.sta__c);
                    if (i.xcnc__c != null&&i.xcp__c != null) {cuids.add(i.xcnc__c+i.xcp__c);}
                }
            }
            map<Id, g_Req__c>mR=getRqs(rids);
            for (g_Req__c r:mR.Values()) {if (r.Con__c != null) {cids.add(r.Con__c);}if (r.Spr__c != null) {cids.add(r.Spr__c);}}
            map<Id, g_srvcitm_Status__c>mSTA=getSTAs(sids);
            map<Id, Contact>mCtct=getCtcts(false, cids, cuids);
            map<String, Contact>mcLnk=new map<String, Contact>();
            map<Id, User>mcU=getUsrs(false, cids, cuids);
            for (Contact c:mCtct.Values()) {mcLnk.put(c.uid__c, c);}
            User u;Contact c; g_Req__c rq; g_srvcitm_Status__c nSTA; g_srvcitm_Status__c oSTA;
            map<String, list<g_reqitem__c>> mRflc = new map<String, list<g_reqitem__c>>();
            //  for (g_reqitem__c i:lst) {g_Req__c r=mR.get(i.RQ__c);if (r.srvc__r.stg__r.iapx__c != null) {if (mRflc.get(r.srvc__r.stg__r.iapx__c)==null) {mRflc.put(r.srvc__r.stg__r.iapx__c, new list<g_reqitem__c>());}mRflc.get(r.srvc__r.stg__r.iapx__c).add(i);}}

            for (g_reqitem__c i:lst) {
                system.debug('i.RQ__c::'+i.RQ__c);
                g_Req__c r=mR.get(i.RQ__c);
                if (r.srvc__r.stg__r.iapx__c != null) {
                    if (mRflc.get(r.srvc__r.stg__r.iapx__c)==null) {
                        mRflc.put(r.srvc__r.stg__r.iapx__c, new list<g_reqitem__c>());}
                    mRflc.get(r.srvc__r.stg__r.iapx__c).add(i);}}

            if (scp == tSCP.IB||scp == tSCP.IA) {

                if (scp == tSCP.IB) {System.debug('&&&&&&&& Calling Insert Before*******');grqSlaH.prepItms(lst, null, mSTA);}
                //if (scp == tSCP.IA) {linkDocs(lst, mR);claimRefund(lst, null, mSTA, mR);}
                for (g_reqitem__c i:lst) {
                    xObj o = new xObj(i, null); rq= mR.get(i.RQ__c); nSTA = mSTA.get(i.sta__c);
                    o.pl.mv.put('@sc', (nSTA != null?'1':'0')+nSTA.itm__r.cd__c+nSTA.cd__c);
                    o.pl.mv.put('@vc', (i.vSTA__c != null?'1':'0')+nSTA.itm__r.cd__c+nSTA.cd__c);
                    o.pl.mv.put('@isN', true);o.pl.mv.put('@chgVF', i.vSTA__c != null);
                    o.pl.mv.put('@isO', nSTA == null?true:nSTA.Tp__c=='Open');
                    o.pl.mv.put('@isCL', nSTA == null?false:nSTA.Tp__c=='Cancelled');
                    o.pl.mv.put('@isRJ', nSTA == null?false:nSTA.Tp__c=='Rejected');
                    o.pl.mv.put('@isCP', nSTA == null?false:nSTA.Tp__c=='Completed');
                    o.pl.mv.put('@chgSTA', nSTA != null);o.pl.mv.put('@rqhasC', rq.Con__c != null);o.pl.mv.put('@rqhasSP', rq.Spr__c != null);
                    o.pl.mv.put('@hasNP', i.xcnc__c != null&&i.xcp__c != null);o.pl.mv.put('@hadNP', false);o.pl.mv.put('@chgNP', i.xcnc__c != null||i.xcp__c != null);
                    o.pl.mo.put('#Acc', rq.Acc__r);o.pl.mo.put('#Srvc', rq.srvc__r);o.pl.mo.put('#nSTA', nSTA);
                    o.pl.mo.put('#Rq', rq);
                    o.pl.mo.put('#sItm', nSTA == null?null:nSTA.itm__r);
                    if (rq.Con__c != null) {
                        o.pl.mo.put('#C', mCtct.get(rq.Con__c));u=mcU.get(rq.Con__c);
                        if (u != null) {o.pl.mo.put('#CU', u);o.pl.mv.put('@CSU', gU.isPortalSuperUser(u.ProfileId));}
                    }
                    if (rq.Spr__c != null) {
                        o.pl.mo.put('#SP', mCtct.get(rq.Spr__c));
                        u=mcU.get(rq.Spr__c);
                        if (u != null) {
                            o.pl.mo.put('#SPU', u);
                            o.pl.mv.put('@SPSU', gU.isPortalSuperUser(u.ProfileId));
                        }
                    }
                    if (i.xcnc__c != null&&i.xcp__c != null) {
                        c=mcLnk.get(i.xcnc__c+i.xcp__c);
                        if (c != null) {
                            o.pl.mo.put('#nlnkC', c);
                            u=mcU.get(c.Id);
                            if (u != null) {
                                o.pl.mo.put('#nlnkCU', u);
                                o.pl.mv.put('@nlnkCSU', gU.isPortalSuperUser(u.ProfileId));
                            }
                        }
                    }
                    Is.add(o);
                }
            } else if (scp == tSCP.UB||scp == tSCP.UA) {
                system.debug('After update:::');
                //commeted for milestone
                if (scp == tSCP.UB) {grqSlaH.prepItms(lst, olds, mSTA); }
                //if (scp == tSCP.UB) {grqSlaH.prepItms(lst, olds, mSTA); MilestnH.linkrqiMlstn(news);}
                //if (scp == tSCP.UA) {dummyUpRIDs(lst);claimRefund(lst, olds, mSTA, mR);iSTAhistory(news, olds); copyNotifications(news, olds);}
                //system.debug('lst::'+lst);
                for (g_reqitem__c i:lst) {
                    g_reqitem__c oldi=olds.get(i.Id);xObj o = new xObj(i, oldi);rq= mR.get(i.RQ__c);nSTA = mSTA.get(i.sta__c);oSTA = mSTA.get(oldi.sta__c);
                    if (nSTA != null) {
                        o.pl.mv.put('@sc', (nSTA.Id != oSTA.Id?'1':'0')+nSTA.itm__r.cd__c+nSTA.cd__c);
                        o.pl.mv.put('@vc', (i.vSTA__c != oldi.vSTA__c?'1':'0')+nSTA.itm__r.cd__c+nSTA.cd__c);

                        o.pl.mv.put('@isN', false);o.pl.mv.put('@chgVF', i.vSTA__c != oldi.vSTA__c);
                        o.pl.mv.put('@isO', nSTA == null?true:nSTA.Tp__c=='Open');
                        o.pl.mv.put('@isCL', nSTA == null?false:nSTA.Tp__c=='Cancelled');
                        o.pl.mv.put('@isRJ', nSTA == null?false:nSTA.Tp__c=='Rejected');
                        o.pl.mv.put('@isCP', nSTA == null?false:nSTA.Tp__c=='Completed');
                        o.pl.mv.put('@chgSTA', nSTA.Id != oSTA.Id);o.pl.mv.put('@rqhasC', rq.Con__c != null);o.pl.mv.put('@rqhasSP', rq.Spr__c != null);
                        o.pl.mv.put('@hasNP', i.xcnc__c != null&&i.xcp__c != null);
                        o.pl.mv.put('@hadNP', oldi.xcnc__c != null&&oldi.xcp__c != null);
                        o.pl.mv.put('@chgNP', i.xcnc__c != oldi.xcnc__c||i.xcp__c != oldi.xcp__c);
                        o.pl.mo.put('#Acc', rq.Acc__r);o.pl.mo.put('#Srvc', rq.srvc__r);o.pl.mo.put('#nSTA', nSTA);o.pl.mo.put('#oSTA', oSTA);
                        o.pl.mo.put('#Rq', rq);
                        o.pl.mo.put('#sItm', nSTA == null?null:nSTA.itm__r);
                        if (rq.Con__c != null) {

                            o.pl.mo.put('#C', mCtct.get(rq.Con__c));u=mcU.get(rq.Con__c);
                            if (u != null) {o.pl.mo.put('#CU', u);o.pl.mv.put('@CSU', gU.isPortalSuperUser(u.ProfileId));}
                        }
                        if (rq.Spr__c != null) {
                            o.pl.mo.put('#SP', mCtct.get(rq.Spr__c));
                            u=mcU.get(rq.Spr__c);
                            if (u != null) {
                                o.pl.mo.put('#SPU', u);
                                o.pl.mv.put('@SPSU', gU.isPortalSuperUser(u.ProfileId));
                            }
                        }
                        //  system.debug('val::'+i.xcnc__c+i.xcp__c);
                        if (i.xcnc__c != null&&i.xcp__c != null) {
                            c=mcLnk.get(i.xcnc__c+i.xcp__c);
                            if (c != null) {
                                o.pl.mo.put('#nlnkC', c);
                                u=mcU.get(c.Id);
                                if (u != null) {
                                    o.pl.mo.put('#nlnkCU', u);
                                    o.pl.mv.put('@nlnkCSU', gU.isPortalSuperUser(u.ProfileId));
                                }
                            }
                        }
                        if (oldi.xcnc__c != null&&oldi.xcp__c != null) {
                            c=mcLnk.get(oldi.xcnc__c+oldi.xcp__c);
                            if (c != null) {
                                o.pl.mo.put('#olnkC', c);
                                u=mcU.get(c.Id);
                                if (u != null) {
                                    o.pl.mo.put('#olnkCU', u);
                                    o.pl.mv.put('@olnkCSU', gU.isPortalSuperUser(u.ProfileId));
                                }
                            }
                        }
                        Is.add(o);
                    }
                }
            }
            else if (scp == tSCP.DB||scp == tSCP.DA) {
                for (g_reqitem__c oldi:lst) {
                    xObj o = new xObj(null, oldi);
                    rq= mR.get(oldi.RQ__c);
                    oSTA = mSTA.get(oldi.sta__c);
                    o.pl.mv.put('@sc', '0'+oSTA.itm__r.cd__c+oSTA.cd__c);
                    o.pl.mv.put('@vc', '0'+oSTA.itm__r.cd__c+oSTA.cd__c);
                    o.pl.mv.put('@isN', false);
                    o.pl.mv.put('@chgVF', false);
                    o.pl.mv.put('@isO', oSTA == null?true:oSTA.Tp__c=='Open');
                    o.pl.mv.put('@isCL', oSTA == null?false:oSTA.Tp__c=='Cancelled');
                    o.pl.mv.put('@isRJ', oSTA == null?false:oSTA.Tp__c=='Rejected');
                    o.pl.mv.put('@isCP', oSTA == null?false:oSTA.Tp__c=='Completed');
                    o.pl.mv.put('@chgSTA', false);
                    o.pl.mv.put('@rqhasC', rq.Con__c != null);
                    o.pl.mv.put('@rqhasSP', rq.Spr__c != null);
                    o.pl.mv.put('@hasNP', oldi.xcnc__c != null&&oldi.xcp__c != null);
                    o.pl.mv.put('@hadNP', oldi.xcnc__c != null&&oldi.xcp__c != null);
                    o.pl.mv.put('@chgNP', false);
                    o.pl.mo.put('#Acc', rq.Acc__r);
                    o.pl.mo.put('#Srvc', rq.srvc__r);
                    o.pl.mo.put('#nSTA', oSTA);
                    o.pl.mo.put('#oSTA', oSTA);
                    o.pl.mo.put('#Rq', rq);
                    o.pl.mo.put('#sItm', oSTA == null?null:oSTA.itm__r);
                    if (rq.Con__c != null) {
                        o.pl.mo.put('#C', mCtct.get(rq.Con__c));
                        u=mcU.get(rq.Con__c);
                        if (u != null) {
                            o.pl.mo.put('#CU', u);
                            o.pl.mv.put('@CSU', gU.isPortalSuperUser(u.ProfileId));
                        }
                    }
                    if (rq.Spr__c != null) {
                        o.pl.mo.put('#SP', mCtct.get(rq.Spr__c));
                        u=mcU.get(rq.Spr__c);
                        if (u != null) {
                            o.pl.mo.put('#SPU', u);
                            o.pl.mv.put('@SPSU', gU.isPortalSuperUser(u.ProfileId));
                        }
                    }
                    if (oldi.xcnc__c != null&&oldi.xcp__c != null) {
                        c=mcLnk.get(oldi.xcnc__c+oldi.xcp__c);
                        if (c != null) {
                            o.pl.mo.put('#olnkC', c);
                            u=mcU.get(c.Id);
                            if (u != null) {
                                o.pl.mo.put('#olnkCU', u);
                                o.pl.mv.put('@olnkCSU', gU.isPortalSuperUser(u.ProfileId));
                            }
                        }
                    }
                    Is.add(o);
                }
            }
            excRflc(mRflc, olds, mR, mSTA, mCtct, mcLnk, mcU, scp);
            system.debug('brls:::::');
            excBRLS(Is, mR, scp);

            if (scp == tSCP.IA) {linkDocs(lst, mR);linkRequestDocs(mR);claimRefund(lst, null, mSTA, mR);copyNotificationsIA(news);  wsCalls(lst, null, mSTA, mR, mCtct);}
            if (scp == tSCP.UA) {
                copydocs(mR);
                system.debug('##########claimRefund##################');
                system.debug('claimRefund');
                
                claimRefund(lst, olds, mSTA, mR);
                iSTAhistory(news, olds, mR); copyNotifications(news, olds);
                wsCalls(lst, olds, mSTA, mR, mCtct);
                /*yardiAtt(lst, olds);*//*to be confirmed with Srini*/
            }
            return Is;
        }

        public void hIB(list<g_reqitem__c>news) {this.excH(news, null, tSCP.IB);}
        public void hIA(list<g_reqitem__c>news) {this.excH(news, null, tSCP.IA);}
        public void hUB(map<Id, g_reqitem__c>news, map<Id, g_reqitem__c>olds) {this.excH(news.values(), olds, tSCP.UB);}
        public void hUA(map<Id, g_reqitem__c>news, map<Id, g_reqitem__c>olds) {this.excH(news.values(), olds, tSCP.UA);}
        public void hDB(map<Id, g_reqitem__c>olds) {this.excH(null, olds, tSCP.DB);}
        public void hDA(map<Id, g_reqitem__c>olds) {this.excH(null, olds, tSCP.DA);}

        private void copyNotifications(list < g_reqitem__c > Is, map < Id, g_reqitem__c > olds) {
            map < String, g_reqitem__c > RIfromNotifKey = new map < String, g_reqitem__c > ();
            list < String > reqNotifKeys = new list < String > ();
            for (g_reqitem__c i: Is) {
                if (olds.get(i.Id).sta__c != i.sta__c || ((olds.get(i.Id).AD__c != i.AD__c || olds.get(i.Id).AO__c != i.AO__c) && i.AD__c == 0 && i.AO__c == 0)) {
                    reqNotifKeys.add(i.Notification_Key__c);
                    RIfromNotifKey.put(i.Notification_Key__c, i);
                }
            }
            list < Notification__c > notifList = new list < Notification__c > ();
            list < Notification_Status__c > notifStatusList = [Select Recipients__c, Send_Delay_Express__c,
                Send_Delay_Normal__c, Service__c, Service_Item__c, Status__c, Template__c, Docs_Required__c,
                Notification_Key__c From Notification_Status__c Where Notification_Key__c in: reqNotifKeys and actv__c = true];
            system.debug('notifStatusList::' + notifStatusList);
            system.debug('RIfromNotifKey::' + RIfromNotifKey);
            if (notifStatusList.size() > 0) {
                for (Notification_Status__c ns: notifStatusList) {
                    Notification__c nt = new Notification__c();
                    nt.Request_Item__c = RIfromNotifKey.get(ns.Notification_Key__c).Id;
                    nt.Estimated_Date_Time__c = BusinessHours.add(mBH.id, datetime.now(),
                        60 * 60 * 1000* ((Long)(RIfromNotifKey.get(ns.Notification_Key__c).exp__c ? ns.Send_Delay_Express__c : ns.Send_Delay_Normal__c).intValue()));
                    nt.First_Recipient_To__c = getEmail(RIfromNotifKey.get(ns.Notification_Key__c).Notification_Email_List__c, ns.Recipients__c, 'Initiator');
                    nt.Second_Recipient_To__c = getEmail(RIfromNotifKey.get(ns.Notification_Key__c).Notification_Email_List__c, ns.Recipients__c, 'Sponsor');
                    nt.Third_Recipient_To__c = getEmail(RIfromNotifKey.get(ns.Notification_Key__c).Notification_Email_List__c, ns.Recipients__c, 'Company');
                    nt.Fourth_Recipient_To__c = getEmail(RIfromNotifKey.get(ns.Notification_Key__c).Notification_Email_List__c, ns.Recipients__c, 'Applicant');
                    nt.Docs_Required__c = ns.Docs_Required__c;
                    nt.Template__c = ns.Template__c;
                    nt.Notification_Status__c = ns.Id;
                    nt.rqEmail__c = getEmail(RIfromNotifKey.get(ns.Notification_Key__c).Notification_Email_List__c, ns.Recipients__c, 'Email');
                    System.debug('RIfromNotifKey.get(ns.Notification_Key__c) : ' + RIfromNotifKey.get(ns.Notification_Key__c));
                    System.debug('rq__r.xceml__c: ' + RIfromNotifKey.get(ns.Notification_Key__c).rq__r.xceml__c);
                    String mb = '';
                    if (RIfromNotifKey.get(ns.Notification_Key__c) != null && String.isNotBlank(RIfromNotifKey.get(ns.Notification_Key__c).Reference_Mobile__c)) {
                        mb = RIfromNotifKey.get(ns.Notification_Key__c).Reference_Mobile__c;
                        mb = mb.replaceAll('\\D', '');
                        if (mb.startsWith('971')) {
                            mb.replaceFirst('971', '');
                        }
                        if (mb.startsWith('0')) {
                            mb.replaceFirst('0', '');
                        }
                        nt.SMS_To__c = '971' + mb + '@email.smsglobal.com';
                    }
                    /*if (RIfromNotifKey.get(ns.Notification_Key__c) != null && String.isNotBlank(RIfromNotifKey.get(ns.Notification_Key__c).Reference_Mobile__c)) nt.SMS_To__c = '971' + (RIfromNotifKey.get(ns.Notification_Key__c).Reference_Mobile__c).trim() + '@email.smsglobal.com';
                    */ system.debug('[[[copyNotifications]]] - nt: ' + nt);
                    notifList.add(nt);
                }
            }
            if (notifList.size() > 0) {
                if (Schema.sObjectType.Notification__c.isCreateable()) {
                    insert notifList;
                }
            }
        }
        private void copyNotificationsIA(list < g_reqitem__c > Is) {
            try {
                map < String, g_reqitem__c > RIfromNotifKey = new map < String, g_reqitem__c > ();
                list < String > reqNotifKeys = new list < String > ();
                for (g_reqitem__c i: Is) {
                    if (i.AD__c == 0 && i.AO__c == 0) {
                        reqNotifKeys.add(i.Notification_Key__c);
                        RIfromNotifKey.put(i.Notification_Key__c, i);
                    }
                }
                list < Notification__c > notifList = new list < Notification__c > ();
                list < Notification_Status__c > notifStatusList = [Select Recipients__c, Send_Delay_Express__c,
                    Send_Delay_Normal__c, Service__c, Service_Item__c, Status__c, Template__c, Docs_Required__c,
                    Notification_Key__c From Notification_Status__c Where Notification_Key__c in: reqNotifKeys and actv__c = true];
                if (notifStatusList.size() > 0) {
                    for (Notification_Status__c ns: notifStatusList) {
                        Notification__c nt = new Notification__c();
                        nt.Request_Item__c = RIfromNotifKey.get(ns.Notification_Key__c).Id;
                        nt.Estimated_Date_Time__c = BusinessHours.add(mBH.id, datetime.now(),
                            60 * 60 * 1000L * ((Long)(RIfromNotifKey.get(ns.Notification_Key__c).exp__c ? ns.Send_Delay_Express__c : ns.Send_Delay_Normal__c).intValue()));
                        nt.First_Recipient_To__c = getEmail(RIfromNotifKey.get(ns.Notification_Key__c).Notification_Email_List__c, ns.Recipients__c, 'Initiator');
                        nt.Second_Recipient_To__c = getEmail(RIfromNotifKey.get(ns.Notification_Key__c).Notification_Email_List__c, ns.Recipients__c, 'Sponsor');
                        nt.Third_Recipient_To__c = getEmail(RIfromNotifKey.get(ns.Notification_Key__c).Notification_Email_List__c, ns.Recipients__c, 'Company');
                        nt.Fourth_Recipient_To__c = getEmail(RIfromNotifKey.get(ns.Notification_Key__c).Notification_Email_List__c, ns.Recipients__c, 'Applicant');
                        nt.Template__c = ns.Template__c;
                        nt.Docs_Required__c = ns.Docs_Required__c;
                        nt.Notification_Status__c = ns.Id;
                        nt.rqEmail__c = RIfromNotifKey.get(ns.Notification_Key__c).xceml__c;
                        String mb = '';
                        if (RIfromNotifKey.get(ns.Notification_Key__c) != null && String.isNotBlank(RIfromNotifKey.get(ns.Notification_Key__c).Reference_Mobile__c)) {
                            mb = RIfromNotifKey.get(ns.Notification_Key__c).Reference_Mobile__c;
                            mb = mb.replaceAll('\\D', '');
                            if (mb.startsWith('971')) {
                                mb.replaceFirst('971', '');
                            }
                            if (mb.startsWith('0')) {
                                mb.replaceFirst('0', '');
                            }
                            nt.SMS_To__c = '971' + mb + '@email.smsglobal.com';
                        }
                        /*if (RIfromNotifKey.get(ns.Notification_Key__c) != null && String.isNotBlank(RIfromNotifKey.get(ns.Notification_Key__c).Reference_Mobile__c)) nt.SMS_To__c = '971' + (RIfromNotifKey.get(ns.Notification_Key__c).Reference_Mobile__c).trim() + '@email.smsglobal.com';
                        */ system.debug('<<<copyNotificationsIA>>>> - nt: ' + nt);
                        notifList.add(nt);
                    }
                }
                if (notifList.size() > 0) {
                    if (Schema.sObjectType.Notification__c.isCreateable()) {
                        insert notifList;
                    }
                }
            }
            catch (Exception e) {
            }
        }

        private String getEmail(String emails, String recipients, String emailType) {
            list<string> emailList = emails.split('\\;');
            map<string, string> emailFromType=new map<string, string>();
            for (string s:emailList) {
                list<string> pair=s.split('\\:');
                if (pair.size()==2 && pair[0]==emailType && pair[1]<>null && recipients.contains(pair[0])) {
                    return pair[1];
                }
            }
            return '';
        }
    }

    //public static void linkRequestDocs(map < Id, g_Req__c > mR) { try { map < Id, map < String, g_reqDoc__c >> mapED = new map < Id, map < String, g_reqDoc__c >> (); map < Id, map < String, g_reqDoc__c >> mapD = new map < Id, map < String, g_reqDoc__c >> (); list < g_reqDoc__c > docs = new list < g_reqDoc__c > (); List < g_reqitem__c > riList = [select id, RQ__c from g_reqitem__c where rq__c =: mR.keyset() and itm__r.cd__c = 'dr']; if (riList != null && !riList.isEmpty()) { for (g_reqDoc__c d: [select id, Name, RQ__c from g_reqDoc__c where RQ__c in: mR.KeySet()]) { if (mapED.get(d.RQ__c) == null) { mapED.put(d.RQ__c, new map < String, g_reqDoc__c > ()); } mapED.get(d.RQ__c).put(d.Name, d); } for (g_reqitem__c ri: riList) { g_Req__c rq = mR.get(ri.RQ__c); if (String.isNotBlank(rq.xcddocs__c)) { map < String, g_reqDoc__c > mEDocs = mapED.get(ri.RQ__c); map < String, g_reqDoc__c > mDocs = mapD.get(ri.RQ__c); if (mDocs == null) { mDocs = new map < String, g_reqDoc__c > (); } List < String > doclst = rq.xcddocs__c.split(';'); for (String doc: doclst) { String docNm = ''; if (doc.contains(':')) { docNm = doc.split(':')[0]; } else docNm = doc; docNm = (docNm.length() > 79) ? docNm.substring(0, 79) : docNm; if (mEDocs == null || !mEDocs.containsKey(docNm)) { g_reqDoc__c rDoc = new g_reqDoc__c(Name = docNm, RQ__c = ri.RQ__c); docs.add(rDoc); mDocs.put(docNm, rDoc); } } mapD.put(ri.RQ__c, mDocs); } } /*(4)create unmatched docs*/ if (docs.size() > 0) { insert docs; } /*(5)create required docs for ReqItems*/ list < g_reqitemDoc__c > iDocs = new list < g_reqitemDoc__c > (); for (g_reqitem__c ri: riList) { g_Req__c rq = mR.get(ri.RQ__c); map < String, g_reqDoc__c > mDocs = mapD.get(ri.RQ__c); if (String.isNotBlank(rq.xcddocs__c)) { List < String > doclst = rq.xcddocs__c.split(';'); List < String > newdoclst = new List < String > (); map < String, Integer > countMap = new map < String, Integer > (); Integer cnt = 0; for (String doc: doclst) { if (String.isNotBlank(doc)) { cnt = 1; system.debug('###doclst###' + doclst); if (doc.contains(':')) { List < String > newdoc = doc.split(':'); if (!countMap.containsKey(newdoc[0])) { cnt = 1; countMap.put(newdoc[0], cnt); } else { Integer cnt1 = countMap.get(newdoc[0]); cnt1++; countMap.put(newdoc[0], cnt1); } newdoclst.add(newdoc[0]); } else { newdoclst.add(doc); } system.debug('###newdoclst###' + newdoclst); } } for (String doc: newdoclst) { String docR = (doc.length() > 79) ? doc.substring(0, 79) : doc; if (mDocs != null && mDocs.containsKey(docR)) { Integer newcnt = 1; Id docId = mapD.get(ri.RQ__c).get(docR).Id; if (countMap.containsKey(doc)) { newcnt = countMap.get(doc); } else newcnt = 1; iDocs.add(new g_reqitemDoc__c(Name = docR, lbl__c = doc, reqItm__c = ri.Id, reqDoc__c = docId, Req__c = true, reqOr__c = false, reqAts__c = true, mnAts__c = 1, mxAts__c = 2, Tp__c = 'DCCA License Docs', rqc__c = false)); } } } } if (iDocs.size() > 0) { insert iDocs; } } } catch (Exception e) { System.debug('** Exception Message:' + e.getStackTraceString()); } }
    public static void copydocs(map<Id, g_Req__c> mR) {
        Map<string, Attachment> attMp = new Map<string, Attachment>();
        List <Attachment> clnAttchLst = new List <Attachment>();
        Attachment orgObj = null;
        Attachment cloneObj = null;
        for (Attachment att : [select id, name, body, parentid from Attachment where parentid=:mR.keySet()]) {
            attMp.put(att.parentid+att.name.split('\\.')[0], att);
        }
        system.debug('mR.keySet()::'+mR.keySet());
        system.debug('attMp size::'+attMp);
        for (g_reqitemDoc__c doc : [select id, Name, reqItm__r.xcp__c,
            reqItm__r.rq__c, reqDoc__c from g_reqitemDoc__c where reqItm__r.rq__c=:mR.keySet() and Req__c=true and reqAts__c=true and upOk__c=false and rqc__c=true order by createddate]) {
            system.debug('key::'+doc.reqItm__r.rq__c+doc.Name);
            if ( attMp != null && ((doc.Name.contains('Passport - first page') && attMp.containsKey(doc.reqItm__r.rq__c+
                'Passport - first page#'+doc.reqItm__r.xcp__c)) || attMp.containsKey(doc.reqItm__r.rq__c+doc.Name))) {
                system.debug('key1::'+doc.reqItm__r.rq__c+doc.Name);
                if (attMp.containsKey(doc.reqItm__r.rq__c+'Passport - first page#'+doc.reqItm__r.xcp__c)) orgObj = attMp.get(doc.reqItm__r.rq__c+'Passport - first page#'+doc.reqItm__r.xcp__c);
                else orgObj = attMp.get(doc.reqItm__r.rq__c+doc.Name);
                cloneObj = orgObj.clone(false, true, false, false);
                cloneObj.parentid = doc.reqDoc__c;
                if (doc.Name.contains('Passport - first page')) cloneObj.name = cloneObj.name.replace(cloneObj.name.split('\\.')[0], 'Passport - first page');
                else cloneObj.name = cloneObj.name.replace(cloneObj.name.split('\\.')[0], doc.Name);
                clnAttchLst.add(cloneObj);
            }
        }
        if (clnAttchLst != null && !clnAttchLst.isEmpty()) insert clnAttchLst;
    }
    //    public static void linkRequestDocs(map < Id, g_Req__c > mR) { try { map < Id, map < String, g_reqDoc__c >> mapED = new map < Id, map < String, g_reqDoc__c >> (); map < Id, map < String, g_reqDoc__c >> mapELD = new map < Id, map < String, g_reqDoc__c >> (); map < Id, map < String, g_reqDoc__c >> mapD = new map < Id, map < String, g_reqDoc__c >> (); list < g_reqDoc__c > docs = new list < g_reqDoc__c > ();  List < g_reqitem__c > riList = [select id, RQ__c, RQ__r.Service_Code__c, itm__r.cd__c from g_reqitem__c where rq__c =: mR.keyset() and itm__r.cd__c in ('dr', 'ddd', 'vfs', 'vfk')]; if (riList != null && !riList.isEmpty()) { grqWsOnboard.Records rec = null; for (g_reqDoc__c d: [select id, Name, RQ__c, lbl__c from g_reqDoc__c where RQ__c in: mR.KeySet()]) { if (mapED.get(d.RQ__c) == null) { mapED.put(d.RQ__c, new map < String, g_reqDoc__c > ()); } mapED.get(d.RQ__c).put(d.Name, d); if (mapELD.get(d.RQ__c) == null) { mapELD.put(d.RQ__c, new map < String, g_reqDoc__c > ()); } if (String.isNotBlank(d.lbl__c)) mapELD.get(d.RQ__c).put(d.lbl__c, d); } for (g_reqitem__c ri: riList) { Boolean executeItem = false; if (ri.RQ__r.Service_Code__c!='220' || (ri.RQ__r.Service_Code__c=='220'&&ri.itm__r.cd__c =='ddd')) { executeItem = true; } if (executeItem) { g_Req__c rq = mR.get(ri.RQ__c); map < String, g_reqDoc__c > mEDocs = mapED.get(ri.RQ__c); map < String, g_reqDoc__c > mELDocs = mapELD.get(ri.RQ__c); map < String, g_reqDoc__c > mDocs = mapD.get(ri.RQ__c); if (mDocs == null) { mDocs = new map < String, g_reqDoc__c > (); } if (String.isNotBlank(rq.xadtx3__c)) { rec = (grqWsOnboard.Records) json.deserialize(rq.xadtx3__c, grqWsOnboard.Records.class); if (rec.documents != null && !rec.documents.isEmpty()) { for (grqWsOnboard.Document doc: rec.documents) { List < String > stg1docLst = Label.Onboarding_docs.split(';'); String stg1doc = doc.description.substringBefore(' - '); if ((mELDocs == null || !mELDocs.containsKey(doc.description)) && ((!doc.description.contains('Passport') && !doc.description.contains('National Media Council - NMC') && !stg1docLst.contains(stg1doc)) || (doc.isCallforReview != null && doc.isCallforReview))) { g_reqDoc__c rDoc = new g_reqDoc__c(Name = (doc.name.length() > 80) ? doc.name.substring(0, 79) : doc.name, lbl__c = doc.description, RQ__c = ri.RQ__c, x30gr__c = doc.gracePeriod); if (doc.isCallforReview != null) rDoc.nc__c = doc.isCallforReview; docs.add(rDoc); mDocs.put(doc.description, rDoc); } } } } if (String.isNotBlank(rq.xcddocs__c)) { List < String > doclst = rq.xcddocs__c.split(';');  /*  logic to remove already  inserted docs*/ List<g_reqDoc__c> rqDocList=[select id, name from g_reqDoc__c where  name in: doclst and RQ__c=:rq.id]; for (g_reqDoc__c rdoc: rqDocList) { Integer ind = doclst.indexOf((rdoc.Name).trim()); doclst.remove(ind); } /**** *****/    for (String doc: doclst) { String docNm = ''; String ddasrAtID = ''; Boolean ncFlag = false; Integer sortOrd; if (doc.contains('Passport'))sortOrd=1; if (doc.contains(':')) { docNm = doc.split(':')[0]; } else docNm = doc; if (doc.contains('@')) { docNm = doc.split('@')[0]; ddasrAtID = doc.split('@')[1]; ncFlag = true; } if ((mEDocs == null || !mEDocs.containsKey(docNm)) && (mELDocs == null || !mELDocs.containsKey(docNm))) { g_reqDoc__c rDoc = new g_reqDoc__c(ord__c=sortOrd, Name = (docNm.length() > 80 ? docNm.substring(0, 76) : docNm), lbl__c = docNm, RQ__c = ri.RQ__c, dda_att__c = ddasrAtID, nc__c = ncFlag); docs.add(rDoc); mDocs.put(docNm, rDoc); } } } if (mDocs != null && !mDocs.isEmpty()) mapD.put(ri.RQ__c, mDocs); } }/*(4)create unmatched docs*/ if (docs.size() > 0) { system.debug('===docs=' + docs); insert docs; } /*(5)create required docs for ReqItems*/ list < g_reqitemDoc__c > iDocs = new list < g_reqitemDoc__c > (); for (g_reqitem__c ri: riList) { Boolean executeItem = false; if (ri.RQ__r.Service_Code__c!='220' || (ri.RQ__r.Service_Code__c=='220'&&ri.itm__r.cd__c =='ddd')) { executeItem = true; } if (executeItem) { g_Req__c rq = mR.get(ri.RQ__c); map < String, g_reqDoc__c > mDocs = mapD.get(ri.RQ__c); if (rec != null && rec.documents != null && !rec.documents.isEmpty()) { for (grqWsOnboard.Document doc: rec.documents) { if (mDocs != null && mDocs.containsKey(doc.description)) { Id docId = mapD.get(ri.RQ__c).get(doc.description).Id; iDocs.add(new g_reqitemDoc__c(Name = (doc.name.length() > 80) ? doc.name.substring(0, 79) : doc.name, lbl__c = doc.description, reqItm__c = ri.Id, reqDoc__c = docId, Req__c = true, reqOr__c = false, reqAts__c = true, mnAts__c = 1, mxAts__c = 1, Tp__c = 'DCCA License Docs', rqc__c = false)); } } } if (String.isNotBlank(rq.xcddocs__c)) { List < String > doclst = rq.xcddocs__c.split(';'); List < String > newdoclst = new List < String > (); map < String, Integer > countMap = new map < String, Integer > (); Integer cnt = 0; for (String doc: doclst) { if (String.isNotBlank(doc)) { cnt = 1; system.debug('###doclst###' + doclst); if (doc.contains('@')) { doc = doc.split('@')[0]; } system.debug('###doc ###' + doc); if (doc.contains(':')) { List < String > newdoc = doc.split(':'); if (!countMap.containsKey(newdoc[0])) { cnt = 1; countMap.put(newdoc[0], cnt); } else { Integer cnt1 = countMap.get(newdoc[0]); cnt1++; countMap.put(newdoc[0], cnt1); } newdoclst.add(newdoc[0]); } else { newdoclst.add(doc); } system.debug('###newdoclst###' + newdoclst); } } for (String doc: newdoclst) { if (mDocs != null && mDocs.containsKey(doc)) { Integer newcnt = 1; Id docId = mapD.get(ri.RQ__c).get(doc).Id; if (countMap.containsKey(doc)) { newcnt = countMap.get(doc); } else newcnt = 1; /*iDocs.add(new g_reqitemDoc__c(Name = doc, lbl__c = doc, reqItm__c = ri.Id, reqDoc__c = docId, Req__c = true, reqOr__c = false, reqAts__c = true, mnAts__c = 1, mxAts__c = 1, Tp__c = 'DCCA License Docs', rqc__c = false));*/ iDocs.add(new g_reqitemDoc__c(Name = (doc.length() > 80 ? doc.substring(0, 76) : doc), lbl__c = doc, reqItm__c = ri.Id, reqDoc__c = docId, Req__c = true, reqOr__c = false, reqAts__c = true, mnAts__c = 1, mxAts__c = 1, Tp__c = 'DCCA License Docs', rqc__c = false)); } } } } } if (iDocs.size() > 0) { insert iDocs; } } } catch (Exception e) { System.debug('** Exception Message:' + e.getStackTraceString()); } }
   // public static void linkRequestDocs(map < Id, g_Req__c > mR) { try { map < Id, map < String, g_reqDoc__c >> mapED = new map < Id, map < String, g_reqDoc__c >> (); map < Id, map < String, g_reqDoc__c >> mapELD = new map < Id, map < String, g_reqDoc__c >> (); map < Id, map < String, g_reqDoc__c >> mapD = new map < Id, map < String, g_reqDoc__c >> (); List < String > doclst =new List < String >(); list < g_reqDoc__c > docs = new list < g_reqDoc__c > (); List < g_reqitem__c > riList = new List< g_reqitem__c >(); /*List < g_reqitem__c > riList = [select id, RQ__c, RQ__r.Service_Code__c, itm__r.cd__c from g_reqitem__c where rq__c =: mR.keyset() and sta__r.cd__c = 'rc' and itm__r.cd__c in ('dr', 'ddd', 'vfs', 'vfk', 'fit', 'fo', 'utn') ];*/ String reqItmQuery = ''; List < g_reqitem__c > reqitList = [select id, RQ__c, RQ__r.Service_Code__c, itm__r.cd__c, sta__r.cd__c, RQ__r.xadtx3__c from g_reqitem__c where rq__c =: mR.keyset() and itm__r.cd__c in ('dr', 'ddd', 'vfs', 'vfk', 'fit', 'fo', 'utn') ]; for (g_reqitem__c rqit : reqitList) { if ((rqit.RQ__r.Service_Code__c == '327' && rqit.sta__r.cd__c == 'rc') || (rqit.RQ__r.Service_Code__c == '327' && String.isNotBlank(rqit.RQ__r.xadtx3__c) && rqit.itm__r.cd__c == 'utn')) { riList.add(rqit); }else if (rqit.RQ__r.Service_Code__c != '327') { riList.add(rqit); } } if (riList != null && !riList.isEmpty()) { grqWsOnboard.Records rec = null; for (g_reqDoc__c d: [select id, Name, RQ__c, lbl__c from g_reqDoc__c where RQ__c in: mR.KeySet()]) { if (mapED.get(d.RQ__c) == null) { mapED.put(d.RQ__c, new map < String, g_reqDoc__c > ()); } mapED.get(d.RQ__c).put(d.Name, d); if (mapELD.get(d.RQ__c) == null) { mapELD.put(d.RQ__c, new map < String, g_reqDoc__c > ()); } if (String.isNotBlank(d.lbl__c)) mapELD.get(d.RQ__c).put(d.lbl__c, d); } for (g_reqitem__c ri: riList) { Boolean executeItem = false; if (ri.RQ__r.Service_Code__c != '220' || (ri.RQ__r.Service_Code__c == '220' && ri.itm__r.cd__c == 'ddd')) { executeItem = true; } if (executeItem) { g_Req__c rq = mR.get(ri.RQ__c); map < String, g_reqDoc__c > mEDocs = mapED.get(ri.RQ__c); map < String, g_reqDoc__c > mELDocs = mapELD.get(ri.RQ__c); map < String, g_reqDoc__c > mDocs = mapD.get(ri.RQ__c); if (mDocs == null) { mDocs = new map < String, g_reqDoc__c > (); } if (String.isNotBlank(rq.xadtx3__c)) { rec = (grqWsOnboard.Records) json.deserialize(rq.xadtx3__c, grqWsOnboard.Records.class); if (rec.documents != null && !rec.documents.isEmpty()) { for (grqWsOnboard.Document doc: rec.documents) { List < String > stg1docLst = Label.Onboarding_docs.split(';'); String stg1doc = doc.description.substringBefore(' - '); if ((mELDocs == null || !mELDocs.containsKey(doc.description)) && ((!doc.description.contains('Passport') && !doc.description.contains('National Media Council - NMC') && !stg1docLst.contains(stg1doc)) || (doc.isCallforReview != null && doc.isCallforReview))) { g_reqDoc__c rDoc = new g_reqDoc__c(Name = (doc.name.length() > 80) ? doc.name.substring(0, 79) : doc.name, lbl__c = doc.description, RQ__c = ri.RQ__c, x30gr__c = doc.gracePeriod); if (doc.isCallforReview != null) rDoc.nc__c = doc.isCallforReview; docs.add(rDoc); mDocs.put(doc.description, rDoc); } } } } if (String.isNotBlank(rq.xcddocs__c)) { doclst = rq.xcddocs__c.split(';'); /*  logic to remove already  inserted docs*/ List < g_reqDoc__c > rqDocList = [select id, name from g_reqDoc__c where  RQ__c =: rq.id]; /*for (g_reqDoc__c rdoc: rqDocList) { Integer ind = doclst.indexOf((rdoc.Name).trim()); doclst.remove(ind); }*/ /**** *****/ List <g_req__c> rqd=[select id, xcddocs__c from g_req__c  where id=: rq.id]; system.debug('##########################-rqd[0].xcddocs__c-'+rqd[0].xcddocs__c); doclst = rqd[0].xcddocs__c.split(';'); rqDocList = [select id, name from g_reqDoc__c where RQ__c =: rqd[0].id]; Set<String> uniqueSet = new Set<String>(); Set<String> rqdocsset = new Set<String>(); for (g_reqDoc__c rdoc: rqDocList) { rqdocsset.add((rdoc.name).trim()); } for (String element : doclst) { uniqueSet.add(element.trim()); } for (String element : rqdocsset) { uniqueSet.remove(element.trim()); } doclst = new List<String>(uniqueSet); for (String doc: doclst) { String docNm = ''; String ddasrAtID = ''; Boolean ncFlag = false; Integer sortOrd; if (doc.contains('Passport')) sortOrd = 1; if (doc.contains(':')) { docNm = doc.split(':')[0]; } else docNm = doc; if (doc.contains('@')) { docNm = doc.split('@')[0]; ddasrAtID = doc.split('@')[1]; ncFlag = true; } if ((mEDocs == null || !mEDocs.containsKey(docNm)) && (mELDocs == null || !mELDocs.containsKey(docNm))) { g_reqDoc__c rDoc = new g_reqDoc__c(ord__c = sortOrd, Name = (docNm.length() > 80 ? docNm.substring(0, 76) : docNm), lbl__c = docNm, RQ__c = ri.RQ__c, dda_att__c = ddasrAtID, nc__c = ncFlag); docs.add(rDoc); mDocs.put(docNm, rDoc); } } } if (mDocs != null && !mDocs.isEmpty()) mapD.put(ri.RQ__c, mDocs); } } /*(4)create unmatched docs*/ if (docs.size() > 0) { system.debug('===docs=' + docs); insert docs; } /*(5)create required docs for ReqItems*/ list < g_reqitemDoc__c > iDocs = new list < g_reqitemDoc__c > (); for (g_reqitem__c ri: riList) { Boolean executeItem = false; if (ri.RQ__r.Service_Code__c != '220' || (ri.RQ__r.Service_Code__c == '220' && ri.itm__r.cd__c == 'ddd')) { executeItem = true; } executeItem = true; if (executeItem) { g_Req__c rq = mR.get(ri.RQ__c); map < String, g_reqDoc__c > mDocs = mapD.get(ri.RQ__c); if (rec != null && rec.documents != null && !rec.documents.isEmpty()) { for (grqWsOnboard.Document doc: rec.documents) { if (mDocs != null && mDocs.containsKey(doc.description)) { Id docId = mapD.get(ri.RQ__c).get(doc.description).Id; iDocs.add(new g_reqitemDoc__c(Name = (doc.name.length() > 80) ? doc.name.substring(0, 79) : doc.name, lbl__c = doc.description, reqItm__c = ri.Id, reqDoc__c = docId, Req__c = true, reqOr__c = false, reqAts__c = true, mnAts__c = 1, mxAts__c = 1, Tp__c = 'DCCA License Docs', rqc__c = false)); } } } if (String.isNotBlank(rq.xcddocs__c)) { /* List < String > doclst = rq.xcddocs__c.split(';');*/ List < String > newdoclst = new List < String > (); map < String, Integer > countMap = new map < String, Integer > (); Integer cnt = 0; for (String doc: doclst) { if (String.isNotBlank(doc)) { cnt = 1; system.debug('###doclst###' + doclst); if (doc.contains('@')) { doc = doc.split('@')[0]; } system.debug('###doc ###' + doc); if (doc.contains(':')) { List < String > newdoc = doc.split(':'); if (!countMap.containsKey(newdoc[0])) { cnt = 1; countMap.put(newdoc[0], cnt); } else { Integer cnt1 = countMap.get(newdoc[0]); cnt1++; countMap.put(newdoc[0], cnt1); } newdoclst.add(newdoc[0]); } else { newdoclst.add(doc); } system.debug('###newdoclst###' + newdoclst); } } for (String doc: newdoclst) { if (mDocs != null && mDocs.containsKey(doc)) { Integer newcnt = 1; Id docId = mapD.get(ri.RQ__c).get(doc).Id; if (countMap.containsKey(doc)) { newcnt = countMap.get(doc); } else newcnt = 1; /*iDocs.add(new g_reqitemDoc__c(Name = doc, lbl__c = doc, reqItm__c = ri.Id, reqDoc__c = docId, Req__c = true, reqOr__c = false, reqAts__c = true, mnAts__c = 1, mxAts__c = 1, Tp__c = 'DCCA License Docs', rqc__c = false));*/ iDocs.add(new g_reqitemDoc__c(Name = (doc.length() > 80 ? doc.substring(0, 76) : doc), lbl__c = doc, reqItm__c = ri.Id, reqDoc__c = docId, Req__c = true, reqOr__c = false, reqAts__c = true, mnAts__c = 1, mxAts__c = 1, Tp__c = 'DCCA License Docs', rqc__c = false)); } } } } } if (iDocs.size() > 0) { insert iDocs; } } } catch (Exception e) { System.debug('** Exception Message:' + e.getStackTraceString()); } }
    //public static void linkRequestDocs(map < Id, g_Req__c > mR) { try { map < Id, map < String, g_reqDoc__c >> mapED = new map < Id, map < String, g_reqDoc__c >> (); map < Id, map < String, g_reqDoc__c >> mapELD = new map < Id, map < String, g_reqDoc__c >> (); map < Id, map < String, g_reqDoc__c >> mapD = new map < Id, map < String, g_reqDoc__c >> (); List < String > doclst = new List < String > (); list < g_reqDoc__c > docs = new list < g_reqDoc__c > (); List < g_reqitem__c > riList = new List < g_reqitem__c > (); /*List < g_reqitem__c > riList = [select id, RQ__c, RQ__r.Service_Code__c, itm__r.cd__c from g_reqitem__c where rq__c =: mR.keyset() and sta__r.cd__c = 'rc' and itm__r.cd__c in ('dr', 'ddd', 'vfs', 'vfk', 'fit', 'fo', 'utn') ];*/ String reqItmQuery = ''; List < g_reqitem__c > reqitList = [select id, RQ__c, RQ__r.Service_Code__c, itm__r.cd__c, sta__r.cd__c, RQ__r.xadtx3__c from g_reqitem__c where rq__c =: mR.keyset() and itm__r.cd__c in ('dr', 'ddd', 'vfs', 'vfk', 'fit', 'fo', 'utn')]; for (g_reqitem__c rqit: reqitList) { if ((rqit.RQ__r.Service_Code__c == '327' && rqit.sta__r.cd__c == 'rc') || (rqit.RQ__r.Service_Code__c == '327' && String.isNotBlank(rqit.RQ__r.xadtx3__c) && rqit.itm__r.cd__c == 'utn')) { riList.add(rqit); } else if (rqit.RQ__r.Service_Code__c != '327') { riList.add(rqit); } } if (riList != null && !riList.isEmpty()) { grqWsOnboard.Records rec = null; for (g_reqDoc__c d: [select id, Name, RQ__c, lbl__c from g_reqDoc__c where RQ__c in: mR.KeySet()]) { if (mapED.get(d.RQ__c) == null) { mapED.put(d.RQ__c, new map < String, g_reqDoc__c > ()); } mapED.get(d.RQ__c).put(d.Name, d); if (mapELD.get(d.RQ__c) == null) { mapELD.put(d.RQ__c, new map < String, g_reqDoc__c > ()); } if (String.isNotBlank(d.lbl__c)) mapELD.get(d.RQ__c).put(d.lbl__c, d); } for (g_reqitem__c ri: riList) { Boolean executeItem = false; if (ri.RQ__r.Service_Code__c != '220' || (ri.RQ__r.Service_Code__c == '220' && ri.itm__r.cd__c == 'ddd')) { executeItem = true; } if (executeItem) { g_Req__c rq = mR.get(ri.RQ__c); map < String, g_reqDoc__c > mEDocs = mapED.get(ri.RQ__c); map < String, g_reqDoc__c > mELDocs = mapELD.get(ri.RQ__c); map < String, g_reqDoc__c > mDocs = mapD.get(ri.RQ__c); if (mDocs == null) { mDocs = new map < String, g_reqDoc__c > (); } if (String.isNotBlank(rq.xadtx3__c)) { rec = (grqWsOnboard.Records) json.deserialize(rq.xadtx3__c, grqWsOnboard.Records.class); if (rec.documents != null && !rec.documents.isEmpty()) { for (grqWsOnboard.Document doc: rec.documents) { List < String > stg1docLst = Label.Onboarding_docs.split(';'); String stg1doc = doc.description.substringBefore(' - '); if ((mELDocs == null || !mELDocs.containsKey(doc.description)) && ((!doc.description.contains('Passport') && !doc.description.contains('National Media Council - NMC') && !stg1docLst.contains(stg1doc)) || (doc.isCallforReview != null && doc.isCallforReview))) { g_reqDoc__c rDoc = new g_reqDoc__c(Name = (doc.name.length() > 80) ? doc.name.substring(0, 79) : doc.name, lbl__c = doc.description, RQ__c = ri.RQ__c, x30gr__c = doc.gracePeriod); if (doc.isCallforReview != null) rDoc.nc__c = doc.isCallforReview; docs.add(rDoc); mDocs.put(doc.description, rDoc); } } } } if (String.isNotBlank(rq.xcddocs__c)) { doclst = rq.xcddocs__c.split(';'); /*  logic to remove already  inserted docs*/ /*Starts MS 1.1*/ /* List < g_reqDoc__c > rqDocList = [select id, name from g_reqDoc__c where RQ__c =: rq.id];*/ /*for (g_reqDoc__c rdoc: rqDocList) { Integer ind = doclst.indexOf((rdoc.Name).trim()); doclst.remove(ind); }*/ /**** *****/ /*  List < g_req__c > rqd = [select id, xcddocs__c from g_req__c where id =: rq.id];*/ system.debug('##########################-rq.xcddocs__c-' + rq.xcddocs__c); doclst = rq.xcddocs__c.split(';'); List < g_reqDoc__c > rqDocList =(mEDocs != null&&mEDocs.size()>0)?mEDocs.values():new  List < g_reqDoc__c >(); /*[select id, name from g_reqDoc__c where RQ__c =: rqd[0].id];*/ /*End MS 1.1*/ Set < String > uniqueSet = new Set < String > (); Set < String > rqdocsset = new Set < String > (); for (g_reqDoc__c rdoc: rqDocList) { rqdocsset.add((rdoc.name).trim()); } for (String element: doclst) { uniqueSet.add(element.trim()); } for (String element: rqdocsset) { uniqueSet.remove(element.trim()); } doclst = new List < String > (uniqueSet); for (String doc: doclst) { String docNm = ''; String ddasrAtID = ''; Boolean ncFlag = false; Integer sortOrd; if (doc.contains('Passport')) sortOrd = 1; if (doc.contains(':')) { docNm = doc.split(':')[0]; } else docNm = doc; if (doc.contains('@')) { docNm = doc.split('@')[0]; ddasrAtID = doc.split('@')[1]; ncFlag = true; } if ((mEDocs == null || !mEDocs.containsKey(docNm)) && (mELDocs == null || !mELDocs.containsKey(docNm))) { g_reqDoc__c rDoc = new g_reqDoc__c(ord__c = sortOrd, Name = (docNm.length() > 80 ? docNm.substring(0, 76) : docNm), lbl__c = docNm, RQ__c = ri.RQ__c, dda_att__c = ddasrAtID, nc__c = ncFlag); docs.add(rDoc); mDocs.put(docNm, rDoc); } } } if (mDocs != null && !mDocs.isEmpty()) mapD.put(ri.RQ__c, mDocs); } } /*(4)create unmatched docs*/ if (docs.size() > 0) { system.debug('===docs=' + docs); insert docs; } /*(5)create required docs for ReqItems*/ list < g_reqitemDoc__c > iDocs = new list < g_reqitemDoc__c > (); for (g_reqitem__c ri: riList) { Boolean executeItem = false; if (ri.RQ__r.Service_Code__c != '220' || (ri.RQ__r.Service_Code__c == '220' && ri.itm__r.cd__c == 'ddd')) { executeItem = true; } executeItem = true; if (executeItem) { g_Req__c rq = mR.get(ri.RQ__c); map < String, g_reqDoc__c > mDocs = mapD.get(ri.RQ__c); if (rec != null && rec.documents != null && !rec.documents.isEmpty()) { for (grqWsOnboard.Document doc: rec.documents) { if (mDocs != null && mDocs.containsKey(doc.description)) { Id docId = mapD.get(ri.RQ__c).get(doc.description).Id; iDocs.add(new g_reqitemDoc__c(Name = (doc.name.length() > 80) ? doc.name.substring(0, 79) : doc.name, lbl__c = doc.description, reqItm__c = ri.Id, reqDoc__c = docId, Req__c = true, reqOr__c = false, reqAts__c = true, mnAts__c = 1, mxAts__c = 1, Tp__c = 'DCCA License Docs', rqc__c = false)); } } } if (String.isNotBlank(rq.xcddocs__c)) { /* List < String > doclst = rq.xcddocs__c.split(';');*/ List < String > newdoclst = new List < String > (); map < String, Integer > countMap = new map < String, Integer > (); Integer cnt = 0; for (String doc: doclst) { if (String.isNotBlank(doc)) { cnt = 1; system.debug('###doclst###' + doclst); if (doc.contains('@')) { doc = doc.split('@')[0]; } system.debug('###doc ###' + doc); if (doc.contains(':')) { List < String > newdoc = doc.split(':'); if (!countMap.containsKey(newdoc[0])) { cnt = 1; countMap.put(newdoc[0], cnt); } else { Integer cnt1 = countMap.get(newdoc[0]); cnt1++; countMap.put(newdoc[0], cnt1); } newdoclst.add(newdoc[0]); } else { newdoclst.add(doc); } system.debug('###newdoclst###' + newdoclst); } } for (String doc: newdoclst) { if (mDocs != null && mDocs.containsKey(doc)) { Integer newcnt = 1; Id docId = mapD.get(ri.RQ__c).get(doc).Id; if (countMap.containsKey(doc)) { newcnt = countMap.get(doc); } else newcnt = 1; /*iDocs.add(new g_reqitemDoc__c(Name = doc, lbl__c = doc, reqItm__c = ri.Id, reqDoc__c = docId, Req__c = true, reqOr__c = false, reqAts__c = true, mnAts__c = 1, mxAts__c = 1, Tp__c = 'DCCA License Docs', rqc__c = false));*/ iDocs.add(new g_reqitemDoc__c(Name = (doc.length() > 80 ? doc.substring(0, 76) : doc), lbl__c = doc, reqItm__c = ri.Id, reqDoc__c = docId, Req__c = true, reqOr__c = false, reqAts__c = true, mnAts__c = 1, mxAts__c = 1, Tp__c = 'DCCA License Docs', rqc__c = false)); } } } } } if (iDocs.size() > 0) { insert iDocs; } } } catch (Exception e) { System.debug('** Exception Message:' + e.getStackTraceString()); } }
public static void linkRequestDocs(map < Id, g_Req__c > mR) {
    try {
        map < Id, map < String, g_reqDoc__c >> mapED = new map < Id, map < String, g_reqDoc__c >> ();
        map < Id, map < String, g_reqDoc__c >> mapELD = new map < Id, map < String, g_reqDoc__c >> ();
        map < Id, map < String, g_reqDoc__c >> mapD = new map < Id, map < String, g_reqDoc__c >> ();
        map < String, g_reqitem__c > mapRqItm = new map < String, g_reqitem__c > ();
        /*MS 1.1*/ map < String, List < String >> mapDocDesc = new map < String, list < String >> ();
        /*MS 1.1*/ List < String > doclst = new List < String > ();
        list < g_reqDoc__c > docs = new list < g_reqDoc__c > ();
        List < g_reqitem__c > riList = new List < g_reqitem__c > ();
        /*List < g_reqitem__c > riList = [select id, RQ__c, RQ__r.Service_Code__c, itm__r.cd__c from g_reqitem__c where rq__c =: mR.keyset() and sta__r.cd__c = 'rc' and itm__r.cd__c in ('dr', 'ddd', 'vfs', 'vfk', 'fit', 'fo', 'utn') ];
        */ String reqItmQuery = '';
        List < g_reqitem__c > reqitList = [select id, RQ__c, RQ__r.Service_Code__c, itm__r.cd__c,
            sta__r.cd__c, RQ__r.xadtx3__c from g_reqitem__c where rq__c =: mR.keyset() and itm__r.cd__c in ('dr',
            'ddd', 'vfs', 'vfk', 'fit', 'fo', 'utn', 'sh1', 'sh2', 'sh3', 'sh4', 'sh5', 'sd3',
            'sh6', 'sh7', 'gm', 'br', 'se', 'hsc', 'dr')];
        /*MS 1.1*/ for (g_reqitem__c rqit: reqitList) {
            if ((rqit.RQ__r.Service_Code__c == '327' && rqit.sta__r.cd__c == 'rc') || (rqit.RQ__r.Service_Code__c == '327' && String.isNotBlank(rqit.RQ__r.xadtx3__c) && rqit.itm__r.cd__c == 'utn')) {
                riList.add(rqit);
            }
            else if (rqit.RQ__r.Service_Code__c != '327') {
                if (rqit.itm__r.cd__c == 'dr' || rqit.itm__r.cd__c == 'ddd' || rqit.itm__r.cd__c == 'sd3' || rqit.itm__r.cd__c == 'vfs' || rqit.itm__r.cd__c == 'vfk') {
                    riList.add(rqit);
                }
                mapRqItm.put(rqit.itm__r.cd__c, rqit);
            }
        /*MS 1.1 end*/ }
        if (riList != null && !riList.isEmpty()) {
            grqWsOnboard.Records rec = null;
            for (g_reqDoc__c d: [select id, Name, RQ__c, lbl__c from g_reqDoc__c where RQ__c in: mR.KeySet()]) {
                if (mapED.get(d.RQ__c) == null) {
                    mapED.put(d.RQ__c, new map < String, g_reqDoc__c > ());
                }
                mapED.get(d.RQ__c).put(d.Name, d);
                if (mapELD.get(d.RQ__c) == null) {
                    mapELD.put(d.RQ__c, new map < String, g_reqDoc__c > ());
                }
                if (String.isNotBlank(d.lbl__c)) mapELD.get(d.RQ__c).put(d.lbl__c, d);
            }
            for (g_reqitem__c ri: riList) {
                Boolean executeItem = false;
                if (ri.RQ__r.Service_Code__c != '220' || (ri.RQ__r.Service_Code__c == '220' && ri.itm__r.cd__c == 'ddd')) {
                    executeItem = true;
                }
                if (executeItem) {
                    g_Req__c rq = mR.get(ri.RQ__c);
                    map < String, g_reqDoc__c > mEDocs = mapED.get(ri.RQ__c);
                    map < String, g_reqDoc__c > mELDocs = mapELD.get(ri.RQ__c);
                    map < String, g_reqDoc__c > mDocs = mapD.get(ri.RQ__c);
                    if (mDocs == null) {
                        mDocs = new map < String, g_reqDoc__c > ();
                    }
                    if (String.isNotBlank(rq.xadtx3__c)) {
                        rec = (grqWsOnboard.Records) json.deserialize(rq.xadtx3__c, grqWsOnboard.Records.class);
                        if (rec.documents != null && !rec.documents.isEmpty()) {
                            for (grqWsOnboard.Document doc: rec.documents) {
                                List < String > stg1docLst = Label.Onboarding_docs.split(';');
                                String stg1doc = doc.description?.substringBefore(' - ');
                                /*MS 1.1 */ if ((mELDocs == null || mELDocs.isempty() || !mELDocs.containsKey(doc.description)) && ((doc.description != null && !doc.description.contains('Passport') && !doc.description.contains('National Media Council - NMC') && !stg1docLst.contains(stg1doc)) || (doc.isCallforReview != null && doc.isCallforReview))) {
                                    g_reqDoc__c rDoc = new g_reqDoc__c(Name = (doc.name.length() > 80) ? doc.name.substring(0, 79) : doc.name,
                                        lbl__c = doc.description, RQ__c = ri.RQ__c, x30gr__c = doc.gracePeriod);
                                    if (doc.isCallforReview != null) rDoc.nc__c = doc.isCallforReview;
                                    else rDoc.nc__c = true;
                                    /*MS1.1*/ docs.add(rDoc);
                                    mDocs.put(doc.description, rDoc);
                                }
                            }
                        }
                    }
                    if (String.isNotBlank(rq.xcddocs__c)) {
                        doclst = rq.xcddocs__c.split(';');
                        /*  logic to remove already  inserted docs*/ /*Starts MS 1.1*/ /* List < g_reqDoc__c > rqDocList = [select id, name from g_reqDoc__c where RQ__c =: rq.id];
                        */ /*for (g_reqDoc__c rdoc: rqDocList) {
                            Integer ind = doclst.indexOf((rdoc.Name).trim());
                            doclst.remove(ind);
                        }
                        */ /**** *****/ /*  List < g_req__c > rqd = [select id, xcddocs__c from g_req__c where id =: rq.id];
                        */ /*MS 1.1 Start*/ for (String strXcDoc: doclst) {
                            if (strXcDoc.contains(':')) {
                                list < String > lstDesc = strXcDoc.split(':');
                                String docdesc = lstDesc[0];
                                /*.replace('~cr', '');
                                */ if (mapDocDesc.containsKey(docdesc)) {
                                    List < String > lstmp = mapDocDesc.get(docdesc);
                                    lstmp.add(lstDesc[1]);
                                    mapDocDesc.put(docdesc, lstmp);
                                }
                                else {
                                    mapDocDesc.put(docdesc, new list < String > {
                                    lstDesc[1] }
                                    );
                                }
                            }
                            else {
                                mapDocDesc.put(strXcDoc, null);
                            /*.replace('~cr', '')*/ }
                        }
                        doclst = new list < String > ();
                        doclst.addAll(mapDocDesc.keySet());
                        List < g_reqDoc__c > rqDocList = (mEDocs != null && !mEDocs.isEmpty()) ? mEDocs.values() : new List < g_reqDoc__c > ();
                        Set < String > uniqueSet = new Set < String > ();
                        Set < String > rqdocsset = new Set < String > ();
                        Set < String > rqReviewDoc = new Set < String > ();
                        for (g_reqDoc__c rdoc: rqDocList) {
                            if (rdoc.name.contains('~cr')) {
                                String strName = rdoc.name.split(':')[0].replace('~cr', '').trim();
                                rqReviewDoc.add(strName);
                            }
                            rqdocsset.add((rdoc.name).trim());
                        }
                        for (String element: doclst) {
                            if (element.contains('~cr')) {
                                String strName = element.split(':')[0].replace('~cr', '').trim();
                                rqReviewDoc.add(strName);
                            }
                            uniqueSet.add(element.replace('~cr', '').trim());
                        }
                        for (String element: rqdocsset) {
                            if (element.contains('~cr')) {
                                String strName = element.split(':')[0].replace('~cr', '').trim();
                                rqReviewDoc.add(element.replace('~cr', '').trim());
                            }
                            uniqueSet.remove(element.replace('~cr', '').trim());
                        }
                        doclst = new List < String > (uniqueSet);
                        for (String doc: doclst) {
                            doc = doc.replace('~cr', '');
                            String docNm = '';
                            String ddasrAtID = '';
                            Boolean ncFlag = false;
                            Integer sortOrd;
                            if (doc.contains('Passport')) sortOrd = 1;
                            if (doc.contains(':')) {
                                docNm = doc.split(':')[0];
                            }
                            else docNm = doc;
                            if (doc.contains('@')) {
                                docNm = doc.split('@')[0];
                                ddasrAtID = doc.split('@')[1];
                                ncFlag = true;
                            }
                            if ((mEDocs == null || !mEDocs.containsKey(docNm)) && (mELDocs == null || !mELDocs.containsKey(docNm))) {
                                Boolean isCallForReview = rqReviewDoc.contains(docNm) ? true : false;
                                isCallForReview = (!isCallForReview) && ncFlag ? true : isCallForReview;
                                docNm = docNm.replace('~cr', '');
                                g_reqDoc__c rDoc = new g_reqDoc__c(ord__c = sortOrd, Name = (docNm.length() > 80 ? docNm.substring(0, 76) : docNm),
                                    lbl__c = docNm, RQ__c = ri.RQ__c, dda_att__c = ddasrAtID, nc__c = ri.RQ__r.Service_Code__c == '220' ? true : isCallForReview);
                                /*MS 1.1*/ if (mDocs == null || (mDocs != null && !mDocs.containsKey(docNm))) docs.add(rDoc);
                                if (mDocs != null && !mDocs.containsKey(docNm)) mDocs.put(docNm, rDoc);
                            }
                        }
                    }
                    if (mDocs != null && !mDocs.isEmpty()) mapD.put(ri.RQ__c, mDocs);
                }
            }
            /*(4)create unmatched docs*/ if (docs.size() > 0) {
                if (Schema.sObjectType.g_reqDoc__c.isCreateable()) {
                    insert docs;
                }
            }
            /*(5)create required docs for ReqItems*/ list < g_reqitemDoc__c > iDocs = new list < g_reqitemDoc__c > ();
            for (g_reqitem__c ri: riList) {
                Boolean executeItem = false;
                if (ri.RQ__r.Service_Code__c != '220' || (ri.RQ__r.Service_Code__c == '220' && ri.itm__r.cd__c == 'ddd')) {
                    executeItem = true;
                }
                executeItem = true;
                set < String > setDocId = new set < String > ();
                if (executeItem) {
                    g_Req__c rq = mR.get(ri.RQ__c);
                    map < String, g_reqDoc__c > mDocs = mapD.get(ri.RQ__c);
                    if (rec != null && rec.documents != null && !rec.documents.isEmpty()) {
                        for (grqWsOnboard.Document doc: rec.documents) {
                            if (mDocs != null && mDocs.containsKey(doc.description)) {
                                Id docId = mapD.get(ri.RQ__c).get(doc.description).Id;
                                String docName = doc.name.replace('~cr', '');
                                iDocs.add(new g_reqitemDoc__c(Name = (docName.length() > 80) ? docName.substring(0, 79) : docName,
                                    lbl__c = doc.description, reqItm__c = (mapDocDesc != null && mapDocDesc.containsKey(docname) && mapDocDesc.get(docname) != null && mapRqItm.containskey(mapDocDesc.get(docname)[0])) ? mapRqItm.get(mapDocDesc.get(docName)[0]).id : ri.id,
                                    /*ri.id updated BY Meenu MS 1.1 */ reqDoc__c = docId, Req__c = true,
                                    reqOr__c = false, reqAts__c = true, mnAts__c = 1, mxAts__c = 1,
                                    Tp__c = 'DCCA License Docs', rqc__c = false));
                                setDocId.add(docId);
                            }
                        }
                    }
                    if (String.isNotBlank(rq.xcddocs__c)) {
                        /* List < String > doclst = rq.xcddocs__c.split(';');
                        */ List < String > newdoclst = new List < String > ();
                        map < String, Integer > countMap = new map < String, Integer > ();
                        Integer cnt = 0;
                        for (String doc: doclst) {
                            doc = doc.replace('~cr', '');
                            /*MS 1.1*/ if (String.isNotBlank(doc)) {
                                cnt = 1;
                                if (doc.contains('@')) {
                                    doc = doc.split('@')[0];
                                }
                                if (doc.contains(':')) {
                                    List < String > newdoc = doc.split(':');
                                    if (!countMap.containsKey(newdoc[0])) {
                                        cnt = 1;
                                        countMap.put(newdoc[0], cnt);
                                    }
                                    else {
                                        Integer cnt1 = countMap.get(newdoc[0]);
                                        cnt1++;
                                        countMap.put(newdoc[0], cnt1);
                                    }
                                    newdoclst.add(newdoc[0]);
                                }
                                else {
                                    newdoclst.add(doc);
                                }
                            }
                        }
                        for (String doc: newdoclst) {
                            if (mDocs != null && mDocs.containsKey(doc)) {
                                Integer newcnt = 1;
                                Id docId = mapD.get(ri.RQ__c).get(doc).Id;
                                if (countMap.containsKey(doc)) {
                                    newcnt = countMap.get(doc);
                                }
                                else newcnt = 1;
                                /*iDocs.add(new g_reqitemDoc__c(Name = doc, lbl__c = doc, reqItm__c = ri.Id, reqDoc__c = docId, Req__c = true, reqOr__c = false, reqAts__c = true, mnAts__c = 1, mxAts__c = 1, Tp__c = 'DCCA License Docs', rqc__c = false));
                                */ String docname = doc.replace('~cr', '');
                                if (!setDocId.contains(docId)) {
                                    iDocs.add(new g_reqitemDoc__c(Name = (docname.length() > 80 ? docname.substring(0, 76) : doc),
                                        lbl__c = docname, /*MS 1.1*/ reqItm__c = (mapDocDesc.containsKey(docname) && mapDocDesc.get(docname) != null && mapRqItm.containskey(mapDocDesc.get(docname)[0])) ? mapRqItm.get(mapDocDesc.get(docname)[0]).id : ri.id,
                                        /*ri.id updated BY Meenu*/ reqDoc__c = docId, Req__c = true,
                                        reqOr__c = false, reqAts__c = true, mnAts__c = 1, mxAts__c = 1,
                                        Tp__c = 'DCCA License Docs', rqc__c = false));
                                }
                            }
                        }
                    }
                }
            }
            if (iDocs.size() > 0) {
                insert iDocs;
            }
        }
    }
    catch (Exception e) {
        System.debug('** Exception Message:' + e.getStackTraceString());
    }
}
}