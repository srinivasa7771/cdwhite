global class BatchUpdateReqActions implements Database.Batchable < sObject > , Database.AllowsCallouts, Schedulable {

    public string whatToUpdate=''; //all, contactdata, adhoc, actions

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'Select Id, name, bamsgs__c, con__c, damsgs__c, xadh__c, (select id, t__r.daction__c, t__r.Baction__c from Status_History__r where kstp__c=true and isDeleted=false order by LastModifiedDate desc limit 1), (SELECT id, name, itm__r.cd__c from items__r ), ';
        query +='xcnc__c, xcp__c, xcfn__c, xcln__c, xcmn__c, xcmon__c, xcfan__c, Gender__c, xcbd__c, xcbc__c, xceml__c, xcfnar__c, xcmnar__c, xclnar__c, xclng__c, xcmonar__c, xcjb__c, xceidid__c, xceidedt__c, xceididt__c, xcql__c, xcfs__c, xcot__c, xcof__c, xcemrt__c, xccty__c, xcstrt__c, xcarea__c, xcpobx__c, xcpobxarea__c, xcpic__c, xcpip__c, xcpid__c, xcped__c, xcrlg__c, xcms__c, xcbp__c, xcpobar__c, xcnp__c, xcslt__c, xcmbs__c, xcma__c, xcmta__c, xcmoa__c, xcha__c, xchph__c, xcmob__c, xrp__c, xrpid__c, xrped__c, Spr__c, xcsnc__c, xcsp__c, ';
        query +='con__r.nc__c, con__r.p__c, con__r.firstname, con__r.lastname, con__r.middlename, con__r.mon__c, con__r.fan__c, con__r.Gender__c, con__r.Birthdate, con__r.bc__c, con__r.Email, con__r.fnar__c, con__r.mnar__c, con__r.lnar__c, con__r.lng__c , con__r.mona__c, con__r.jb__c, con__r.eidid__c, con__r.eidedt__c, con__r.eididt__c, con__r.ql__c, con__r.fs__c, con__r.ot__c, con__r.of__c, con__r.emrt__c, con__r.cty__c, con__r.strt__c, con__r.area__c, con__r.pobx__c, con__r.pobxarea__c, con__r.pic__c, con__r.pip__c, con__r.pid__c, con__r.ped__c, con__r.rlg__c, con__r.ms__c, con__r.bp__c, con__r.bpa__c, con__r.np__c, con__r.Salutation, con__r.mbs__c, con__r.ma__c, con__r.mta__c, con__r.moa__c, con__r.ha__c, con__r.HomePhone, con__r.MobilePhone  , con__r.rp__c, con__r.rpid__c, con__r.rped__c , con__r.Spon__c, con__r.snc__c, con__r.sp__c ';
        query += ' from g_req__c where sta__c in (\'Open\', \'In Process\', \'Under Review\') and isp__c=false ';
        if (!test.isRunningTest()) {
             query += ' and createddate = LAST_N_MONTHS:10 and ap__c>0 limit 999';
        }
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List <g_req__c> scope) {
        List<g_req__c> rqToUpdate = new List<g_req__c>();

        for (g_req__c rq : scope) {

            if (rq.Status_History__r != null && rq.Status_History__r.size()>0) {

                if (whatToUpdate.equalsIgnoreCase('all') || whatToUpdate.equalsIgnoreCase('actions')) {
                    if (String.isNotBlank(rq.Status_History__r[0].t__r.Baction__c)) {rq.bamsgs__c = rq.Status_History__r[0].t__r.Baction__c;}
                    if (String.isNotBlank(rq.Status_History__r[0].t__r.daction__c)) {rq.damsgs__c = rq.Status_History__r[0].t__r.daction__c;}
                }

                /*if (whatToUpdate.equalsIgnoreCase('all') || whatToUpdate.equalsIgnoreCase('adhoc')) {
                    if (String.isBlank(rq.xadh__c)) {rq.xadh__c='';}else{rq.xadh__c += ';';}

                    if (rq.items__r != null && rq.items__r.size()>0) {
                        for (g_reqItem__c i :  rq.items__r) {
                            if (!rq.xadh__c.contains(i.itm__r.cd__c+';')) {
                                rq.xadh__c += i.itm__r.cd__c+';';
                            }
                        }
                    }
                }*/

                if (rq.con__c != null && (whatToUpdate.equalsIgnoreCase('all') || whatToUpdate.equalsIgnoreCase('contactdata'))) {
                    if (String.isBlank(rq.xcnc__c )) {rq.xcnc__c = rq.con__r.nc__c;}
                    if (String.isBlank(rq.xcp__c )) {rq.xcp__c = rq.con__r.p__c;}
                    if (String.isBlank(rq.xcfn__c )) {rq.xcfn__c =  rq.con__r.firstname;}
                    if (String.isBlank(rq.xcln__c )) {rq.xcln__c = rq.con__r.lastname;}
                    if (String.isBlank(rq.xcmn__c )) {rq.xcmn__c = rq.con__r.middlename;}
                    if (String.isBlank(rq.xcmon__c )) {rq.xcmon__c = rq.con__r.mon__c;}
                    if (String.isBlank(rq.xcfan__c )) {rq.xcfan__c = rq.con__r.fan__c;}
                    if (String.isBlank(rq.Gender__c )) {rq.Gender__c = rq.con__r.Gender__c;}
                    if (rq.xcbd__c == null) {rq.xcbd__c = rq.con__r.Birthdate;}
                    if (String.isBlank(rq.xcbc__c )) {rq.xcbc__c =  rq.con__r.bc__c;}
                    if (String.isBlank(rq.xceml__c )) {rq.xceml__c =  rq.con__r.Email;}
                    if (String.isBlank(rq.xcfnar__c )) {rq.xcfnar__c = rq.con__r.fnar__c;}
                    if (String.isBlank(rq.xcmnar__c )) {rq.xcmnar__c =  rq.con__r.mnar__c;}
                    if (String.isBlank(rq.xclnar__c )) {rq.xclnar__c =  rq.con__r.lnar__c;}
                    if (String.isBlank(rq.xclng__c )) {rq.xclng__c =  rq.con__r.lng__c; }
                    if (String.isBlank(rq.xcmonar__c )) {rq.xcmonar__c = rq.con__r.mona__c;}
                    if (String.isBlank(rq.xcjb__c )) {rq.xcjb__c = rq.con__r.jb__c;}
                    if (String.isBlank(rq.xceidid__c )) {rq.xceidid__c = rq.con__r.eidid__c;}
                    if (rq.xceidedt__c == null) {rq.xceidedt__c = rq.con__r.eidedt__c;}
                    if (rq.xceididt__c == null) {rq.xceididt__c=rq.con__r.eididt__c;}
                    if (String.isBlank(rq.xcql__c )) {rq.xcql__c = rq.con__r.ql__c;}
                    if (String.isBlank(rq.xcfs__c )) {rq.xcfs__c = rq.con__r.fs__c;}
                    if (String.isBlank(rq.xcot__c )) {rq.xcot__c = rq.con__r.ot__c;}
                    if (String.isBlank(rq.xcof__c  )) {rq.xcof__c  = rq.con__r.of__c;}
                    if (String.isBlank(rq.xcemrt__c )) {rq.xcemrt__c = rq.con__r.emrt__c;}
                    if (String.isBlank(rq.xccty__c )) {rq.xccty__c = rq.con__r.cty__c;}
                    if (String.isBlank(rq.xcstrt__c )) {rq.xcstrt__c = rq.con__r.strt__c;}
                    if (String.isBlank(rq.xcarea__c )) {rq.xcarea__c = rq.con__r.area__c;}
                    if (String.isBlank(rq.xcpobx__c )) {rq.xcpobx__c =  rq.con__r.pobx__c;}
                    if (String.isBlank(rq.xcpobxarea__c )) {rq.xcpobxarea__c = rq.con__r.pobxarea__c;}
                    if (String.isBlank(rq.xcpic__c )) {rq.xcpic__c = rq.con__r.pic__c;}
                    if (String.isBlank(rq.xcpip__c )) {rq.xcpip__c = rq.con__r.pip__c;}
                    if (rq.xcpid__c == null) {rq.xcpid__c = rq.con__r.pid__c;}
                    if (rq.xcped__c == null) {rq.xcped__c = rq.con__r.ped__c;}
                    if (String.isBlank(rq.xcrlg__c )) {rq.xcrlg__c = rq.con__r.rlg__c;}
                    if (String.isBlank(rq.xcms__c )) {rq.xcms__c = rq.con__r.ms__c;}
                    if (String.isBlank(rq.xcbp__c )) {rq.xcbp__c = rq.con__r.bp__c;}
                    if (String.isBlank(rq.xcpobar__c )) {rq.xcpobar__c = rq.con__r.bpa__c;}
                    if (String.isBlank(rq.xcnp__c )) {rq.xcnp__c = rq.con__r.np__c;}
                    if (String.isBlank(rq.xcslt__c )) {rq.xcslt__c = rq.con__r.Salutation;}
                    if (rq.xcmbs__c == null || rq.xcmbs__c == 0.00) {rq.xcmbs__c = rq.con__r.mbs__c;}
                    if (rq.xcma__c == null || rq.xcma__c == 0.00) {rq.xcma__c = rq.con__r.ma__c;}
                    if (rq.xcmta__c == null || rq.xcmta__c == 0.00) {rq.xcmta__c = rq.con__r.mta__c;}
                    if (rq.xcmoa__c == null || rq.xcmoa__c == 0.00) {rq.xcmoa__c = rq.con__r.moa__c;  }
                    if (String.isBlank(rq.xcha__c)) {rq.xcha__c = rq.con__r.ha__c;  }
                    if (String.isBlank(rq.xchph__c )) {rq.xchph__c = rq.con__r.HomePhone;  }
                    if (String.isBlank(rq.xcmob__c )) {rq.xcmob__c = rq.con__r.MobilePhone;  }
                    if (String.isBlank(rq.xrp__c )) {rq.xrp__c = rq.con__r.rp__c;}
                    if (rq.xrpid__c == null) {rq.xrpid__c = rq.con__r.rpid__c;}
                    if (rq.xrped__c == null) {rq.xrped__c = rq.con__r.rped__c; }
                    if (String.isBlank(rq.Spr__c )) {rq.Spr__c = rq.con__r.Spon__c;}
                    if (String.isBlank(rq.xcsnc__c )) {rq.xcsnc__c = rq.con__r.snc__c;}
                    if (String.isBlank(rq.xcsp__c )) {rq.xcsp__c = rq.con__r.sp__c;}
                }

                rq.isp__c=true;
                rqToUpdate.add(rq);
            }
        }

        if (Schema.sObjectType.g_req__c.isUpdateable()) {
            update rqToUpdate;
        }
    }

    global void finish(Database.BatchableContext BC) {}

    global void execute(SchedulableContext sc) {
        BatchUpdateReqActions ra1 = new BatchUpdateReqActions();
        ra1.whatToUpdate = whatToUpdate;
        database.executeBatch(ra1, 1);}

}