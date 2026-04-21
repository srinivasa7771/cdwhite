public with sharing class grqCtrlAddSanction {
    public Account acc{get;set;}
    public string accId{get;set;}
    public  string profileName{get;set;}
    //public list<string> existingSanctions{get;set;}
    public user usr{get;set;}
    public grqCtrlAddSanction() {
        usr = [select id, firstname, lastname, profile.name from user where id=:userinfo.getUserId()];
        accId = ApexPages.CurrentPage().getparameters().get('id');
        acc = [select id, as__c , GSO__c, FIN__c, snc__c, lcsta__c, sn__c, snadrmd__c, VIP__c, CA_San__c, Lease__c, srb__c, snc_txt__c from Account where id =: accId ];
        profileName = [select id, name from profile where id=:userinfo.getProfileId()].name;
        //if (!string.isblank(Acc.snc__C)) {
        //existingSanctions =  Acc.snc__C.split(';');
        //}
    }

    public grqCtrlAddSanction(String s) {

    }

    public pagereference saveSanction() {

        if (acc.lcsta__c!='License Under Renewal' && acc.lcsta__c!='License Issued') {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'You can not add the sanctions to this account if the status is not in License Issued or License Under Renewal'));
            return null;
        }
        if (string.isBlank(acc.sn__c)) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please Provide Sanction Notes'));
            return null;
        }
        if (string.isBlank(acc.snadrmd__c)) {ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please Select the value in action to be taken'));return null;
                                          }
        if (!string.isblank(acc.as__c)) {ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'The record is already in approval process'));return null;
                                      }
        if (Acc.snadrmd__c=='Add Requested Sanction' && !string.isblank(Acc.snc__c) && ((!string.isblank(Acc.CA_San__c) && acc.snc__c.contains(acc.CA_San__c)) || (!string.isblank(Acc.Lease__c) && acc.snc__c.contains(acc.Lease__c))|| (!string.isblank(Acc.GSO__c) && acc.snc__c.contains(acc.GSO__c) )||( !string.isblank(Acc.FIN__c) && acc.snc__c.contains(acc.FIN__c)))) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please check the existing sanctions and add which are not there'));
            return null;
        }

        acc.snc_txt__c=!string.isblank(acc.GSO__c)?acc.GSO__c:!string.isblank(acc.Fin__c)?acc.Fin__c:!string.isblank(acc.CA_San__c)?acc.CA_San__c:!string.isblank(acc.lease__c)?acc.lease__c:'';
        acc.srb__c=usr.firstname+' '+usr.LastName;if (string.isblank(acc.as__c))Acc.as__c='Submitted';
        if (Schema.sObjectType.Account.isUpdateable()) {
            update Acc;
        }
        submitForApproval(Acc);

        PageReference pg = new PageReference('/'+acc.Id);
        pg.setRedirect(true);
        return pg;
    }
    public pagereference cancel() {
        PageReference pg = new PageReference('/'+acc.Id);
        pg.setRedirect(true);
        return pg;
    }
    public  void submitForApproval(Account acc) {
        map<string, id> sanctionsMap = new map<string, id>();
        // List<group> sncQueues= [select id, name from group where Developername in('GSO_Leasing_Sanction', 'VIP_Fin_Sanction', 'DDA_Sanction') and type='Queue' order by Developername asc];
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitted for sanction approval');
        req1.setObjectId(acc.id);
        for (group objGr:[select id, name, Developername from group where Developername in('GSO_Leasing_Sanction', 'VIP_Fin_Sanction', 'DDA_Sanction', 'SnC_Finance') and type='Queue']) {
            if (!sanctionsMap.containsKey(objGr.Developername)) {
                sanctionsMap.put(objGr.DeveloperName, objGr.Id);
            }
            if ( !string.isblank(acc.GSO__c) || !string.isblank(acc.Lease__c) ) {//acc.vip__c && !string.isblank(acc.CA_San__c) ||
                req1.setNextApproverIds(new Id[] {sanctionsMap.get('GSO_Leasing_Sanction')});
            }
            if ( !string.isblank(acc.CA_San__c)) {
                req1.setNextApproverIds(new Id[] {sanctionsMap.get('DDA_Sanction')});
            }
            if (acc.vip__c && !string.isblank(acc.FIN__c)) {
                req1.setNextApproverIds(new Id[] {sanctionsMap.get('VIP_Fin_Sanction')});
            }
            if (!acc.vip__c && !string.isblank(acc.FIN__c)) {
                req1.setNextApproverIds(new Id[] {sanctionsMap.get('SnC_Finance')});
            }
            //if ((!string.isblank(acc.GSO__c) || !string.isblank(acc.Lease__c))) {
            //sanctionsMap.get('GSO_Leasing_Sanction');
            //}
        }

        Approval.ProcessResult result = Approval.process(req1);
    }
    @InvocableMethod(label='Get Approved Accounts' description='Updating the value into Sanctions' category='Account')
    public static void appendSanctions() {
       List<Sanction_History__c> shList = new List<Sanction_History__c>();
        List<Account> accList = [select id, lastmodifiedby.name, srb__c , as__c , GSO__c,
            FIN__c, snc__c, lcsta__c, sn__c, snadrmd__c, CA_San__c, Lease__c, snc_txt__c from Account where as__c in('Approved',
            'Rejected')];
        Sanction_History__c sh= new Sanction_History__c();
        if (!test.isrunningtest()) {
        sh.Account__c=accList[0].id;sh.srb__c=accList[0].srb__c;sh.os__c=accList[0].snc__c;
        //insert sh;
        }
        List<Account> snAccList = new List<Account>();
        for (Account objAcc:accList) {
            if (objAcc.as__c=='Approved') {
                if (!string.isblank(objAcc.GSO__c)  ) {
                    if (objAcc.snadrmd__c=='Add Requested Sanction') {
                        objAcc.snc__c= !string.isblank(objAcc.snc__c)?objAcc.snc__c+';'+objAcc.GSO__c:objAcc.GSO__c;
                    }
                    else if (objAcc.snadrmd__c=='Remove Requested Sanction') { objAcc.snc__c=objAcc.snc__c.remove(objAcc.GSO__c);   }
                    objAcc.GSO__c='';
                }
                if (!string.isblank(objAcc.FIN__c)) {
                    if (objAcc.snadrmd__c=='Add Requested Sanction') {
                        objAcc.snc__c= !string.isblank(objAcc.snc__c)?objAcc.snc__c+';'+objAcc.FIN__c:objAcc.FIN__c;
                    }
                    else if (objAcc.snadrmd__c=='Remove Requested Sanction') {objAcc.snc__c=objAcc.snc__c.remove(objAcc.FIN__c);}
                    objAcc.FIN__c='';
                }
                if (!string.isblank(objAcc.CA_San__c)) {
                    if (objAcc.snadrmd__c=='Add Requested Sanction') {
                        objAcc.snc__c= !string.isblank(objAcc.snc__c)?objAcc.snc__c+';'+objAcc.CA_San__c:objAcc.CA_San__c;
                    }
                    else if (objAcc.snadrmd__c=='Remove Requested Sanction') {objAcc.snc__c=objAcc.snc__c.remove(objAcc.CA_San__c); }
                    objAcc.CA_San__c='';
                }
                if (!string.isblank(objAcc.Lease__c)) {
                    if (objAcc.snadrmd__c=='Add Requested Sanction') {
                        objAcc.snc__c= !string.isblank(objAcc.snc__c)?objAcc.snc__c+';'+objAcc.Lease__c:objAcc.Lease__c;
                    }
                    else if (objAcc.snadrmd__c=='Remove Requested Sanction') {objAcc.snc__c=objAcc.snc__c.remove(objAcc.Lease__c); }
                    objAcc.Lease__c='';
                }
                sh.sn__c=objAcc.snc__c;
                sh.sar__c=objAcc.lastmodifiedby.name;
                shList.add(sh);
            }
            if (objAcc.as__c=='Rejected') {
                if (!string.isblank(objAcc.GSO__c)) { objAcc.GSO__c=''; }
                if (!string.isblank(objAcc.FIN__c)) {objAcc.FIN__c='';}
                if (!string.isblank(objAcc.CA_San__c)) {objAcc.CA_San__c='';}
                if (!string.isblank(objAcc.Lease__c)) {objAcc.Lease__c='';}
            }
            objAcc.as__c=objAcc.sn__c=objAcc.snadrmd__c=objAcc.srb__c=objAcc.snc_txt__c='';
            snAccList.add(objAcc);
        }

        if (snAccList != null && !snAccList.isEmpty())update snAccList;
        if (!test.isrunningtest()&&shList != null && !shList.isEmpty()) upsert shList;
    }
}