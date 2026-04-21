public class grqAccConCntrl {
    public g_Req__c rq {
        get;
        set;
    }
    public String acc {
        get;
        set;
    }
    public String con {
        get;
        set;
    }
    public Boolean ispu {
        get;
        set;
    }
    public String serviceChoosen {
        get;
        set;
    }

public grqAccConCntrl(ApexPages.StandardController c) {
    ispu = gu.isPortalUser(UserInfo.getProfileId());
    rq = new g_Req__c();
}
public PageReference callAction() {
    string passedVariableString = String.escapeSingleQuotes(system.CurrentPageReference().getParameters().get('srvName'));
    system.debug('srvName=====' + passedVariableString);
    system.debug('serviceChoosen=====' + serviceChoosen);
    return null;
}
public PageReference CancelR() {
    System.debug('acc====' + acc);
    System.debug('con====' + con);
    System.debug('rq.Acc====' + rq.Acc__c);
    System.debug('rq.Con====' + rq.Con__c);
    System.debug('serviceChoosen====' + serviceChoosen);
    Contact c = [Select Id, rol__c, FirstName, LastName, Gender__c, nc__c, Age__c, p__c, pic__c, pid__c, ped__c, pip__c, fnar__c, lnar__c, mnar__c from Contact where Id =: rq.Con__c];
    Account a = [Select Id from Account where Id =: rq.Acc__c];
    if (c.rol__c == 'Employee') rq.srvc__c = [Select Id from g_Srvc__c where uid__c = '076' LIMIT 1 ].Id;
    if (c.rol__c == 'Student') rq.srvc__c = [Select Id from g_Srvc__c where uid__c = '092' LIMIT 1 ].Id;
    if (c.rol__c == 'Spouse' || c.rol__c == 'Child') rq.srvc__c = [Select Id from g_Srvc__c where uid__c = '090' LIMIT 1 ].Id;
    System.debug('CancelR rq=====' + rq);
    try {
        rq.sta__c = 'Draft';
        rq.xcfn__c = c.FirstName;
        rq.xcfnar__c = c.fnar__c;
        rq.xcmnar__c = c.mnar__c;
        rq.xclnar__c = c.lnar__c;
        rq.xcp__c = c.p__c;
        rq.xcpid__c = c.pid__c;
        rq.xcped__c = c.ped__c;
        rq.xcpic__c = c.pic__c;
        rq.xcln__c = c.LastName;
        rq.Gender__c = c.Gender__c;
        rq.xcpip__c = c.pip__c;
        rq.xcnc__c = c.nc__c;
        Database.SaveResult sr = Database.insert(rq);
        if (sr.isSuccess()) {
            System.debug('Successfully inserted Request. Request ID: ' + sr.getId());
            String srNumber = [Select Id, Name from g_Req__c where id =: sr.getId()].Name;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'SR is created Successfully with SR#' + srNumber));
            return new PageReference('/' + rq.Id);
        }
    }
    catch (Exception e) {
        system.debug(e.getStackTraceString());
        Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
        ApexPages.addMessage(errMsg);
    }
    return null;
}
public PageReference CancelInCounR() {
    System.debug('acc====' + acc);
    System.debug('con====' + con);
    System.debug('rq.Acc====' + rq.Acc__c);
    System.debug('rq.Con====' + rq.Con__c);
    System.debug('serviceChoosen====' + serviceChoosen);
    Contact c = [Select Id, rol__c, FirstName, LastName, Gender__c, nc__c, Age__c, p__c, pic__c, pid__c, ped__c, pip__c, fnar__c, lnar__c, mnar__c from Contact where Id =: rq.Con__c];
    Account a = [Select Id from Account where Id =: rq.Acc__c];
    if (c.rol__c == 'Employee') {
        rq.srvc__c = [Select Id from g_Srvc__c where uid__c = '076' LIMIT 1 ].Id;
        rq.xadh__c = 'ins;';
    }
    if (c.rol__c == 'Student') {
        rq.srvc__c = [Select Id from g_Srvc__c where uid__c = '092' LIMIT 1 ].Id;
        rq.xadh__c = 'ins;';
    }
    if (c.rol__c == 'Spouse' || c.rol__c == 'Child') {
        rq.srvc__c = [Select Id from g_Srvc__c where uid__c = '090' LIMIT 1 ].Id;
        rq.xadh__c = 'ins;';
    }
    System.debug('CancelR rq=====' + rq);
    try {
        rq.sta__c = 'Draft';
        rq.xcfn__c = c.FirstName;
        rq.xcfnar__c = c.fnar__c;
        rq.xcmnar__c = c.mnar__c;
        rq.xclnar__c = c.lnar__c;
        rq.xcp__c = c.p__c;
        rq.xcpid__c = c.pid__c;
        rq.xcped__c = c.ped__c;
        rq.xcpic__c = c.pic__c;
        rq.xcln__c = c.LastName;
        rq.Gender__c = c.Gender__c;
        rq.xcpip__c = c.pip__c;
        rq.xcnc__c = c.nc__c;
        Database.SaveResult sr = Database.insert(rq);
        if (sr.isSuccess()) {
            System.debug('Successfully inserted Request. Request ID: ' + sr.getId());
            String srNumber = [Select Id, Name from g_Req__c where id =: sr.getId()].Name;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'SR is created Successfully with SR#' + srNumber));
            return new PageReference('/' + rq.Id);
        }
    }
    catch (Exception e) {
        system.debug(e.getStackTraceString());
        Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
        ApexPages.addMessage(errMsg);
    }
    return null;
}
public PageReference CancelOutCounWPR() {
    System.debug('acc====' + acc);
    System.debug('con====' + con);
    System.debug('rq.Acc====' + rq.Acc__c);
    System.debug('rq.Con====' + rq.Con__c);
    System.debug('serviceChoosen====' + serviceChoosen);
    Contact c = [Select Id, rol__c, FirstName, LastName, Gender__c, nc__c, Age__c, p__c, pic__c, pid__c, ped__c, pip__c, fnar__c, lnar__c, mnar__c from Contact where Id =: rq.Con__c];
    Account a = [Select Id from Account where Id =: rq.Acc__c];
    if (c.rol__c == 'Employee') {
        rq.srvc__c = [Select Id from g_Srvc__c where uid__c = '076' LIMIT 1 ].Id;
        rq.xadh__c = 'oua;';
    }
    if (c.rol__c == 'Student') {
        rq.srvc__c = [Select Id from g_Srvc__c where uid__c = '092' LIMIT 1 ].Id;
        rq.xadh__c = 'oua;';
    }
    if (c.rol__c == 'Spouse' || c.rol__c == 'Child') {
        rq.srvc__c = [Select Id from g_Srvc__c where uid__c = '090' LIMIT 1 ].Id;
        rq.xadh__c = 'oua;';
    }
    System.debug('CancelR rq=====' + rq);
    try {
        rq.sta__c = 'Draft';
        rq.xcfn__c = c.FirstName;
        rq.xcfnar__c = c.fnar__c;
        rq.xcmnar__c = c.mnar__c;
        rq.xclnar__c = c.lnar__c;
        rq.xcp__c = c.p__c;
        rq.xcpid__c = c.pid__c;
        rq.xcped__c = c.ped__c;
        rq.xcpic__c = c.pic__c;
        rq.xcln__c = c.LastName;
        rq.Gender__c = c.Gender__c;
        rq.xcpip__c = c.pip__c;
        rq.xcnc__c = c.nc__c;
        Database.SaveResult sr = Database.insert(rq);
        if (sr.isSuccess()) {
            System.debug('Successfully inserted Request. Request ID: ' + sr.getId());
            String srNumber = [Select Id, Name from g_Req__c where id =: sr.getId()].Name;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'SR is created Successfully with SR#' + srNumber));
            return new PageReference('/' + rq.Id);
        }
    }
    catch (Exception e) {
        system.debug(e.getStackTraceString());
        Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
        ApexPages.addMessage(errMsg);
    }
    return null;
}
public PageReference CancelOutCounWoPR() {
    System.debug('acc====' + acc);
    System.debug('con====' + con);
    System.debug('rq.Acc====' + rq.Acc__c);
    System.debug('rq.Con====' + rq.Con__c);
    System.debug('serviceChoosen====' + serviceChoosen);
    Contact c = [Select Id, rol__c, FirstName, LastName, Gender__c, nc__c, Age__c, p__c, pic__c, pid__c, ped__c, pip__c, fnar__c, lnar__c, mnar__c from Contact where Id =: rq.Con__c];
    Account a = [Select Id from Account where Id =: rq.Acc__c];
    if (c.rol__c == 'Employee') {
        rq.srvc__c = [Select Id from g_Srvc__c where uid__c = '076' LIMIT 1 ].Id;
        rq.xadh__c = 'ip;oup;';
    }
    if (c.rol__c == 'Student') {
        rq.srvc__c = [Select Id from g_Srvc__c where uid__c = '092' LIMIT 1 ].Id;
        rq.xadh__c = 'ip;oup;';
    }
    if (c.rol__c == 'Spouse' || c.rol__c == 'Child') {
        rq.srvc__c = [Select Id from g_Srvc__c where uid__c = '090' LIMIT 1 ].Id;
        rq.xadh__c = 'ip;oup;';
    }
    System.debug('CancelR rq=====' + rq);
    try {
        rq.sta__c = 'Draft';
        rq.xcfn__c = c.FirstName;
        rq.xcfnar__c = c.fnar__c;
        rq.xcmnar__c = c.mnar__c;
        rq.xclnar__c = c.lnar__c;
        rq.xcp__c = c.p__c;
        rq.xcpid__c = c.pid__c;
        rq.xcped__c = c.ped__c;
        rq.xcpic__c = c.pic__c;
        rq.xcln__c = c.LastName;
        rq.Gender__c = c.Gender__c;
        rq.xcpip__c = c.pip__c;
        rq.xcnc__c = c.nc__c;
        Database.SaveResult sr = Database.insert(rq);
        if (sr.isSuccess()) {
            System.debug('Successfully inserted Request. Request ID: ' + sr.getId());
            String srNumber = [Select Id, Name from g_Req__c where id =: sr.getId()].Name;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'SR is created Successfully with SR#' + srNumber));
            return new PageReference('/' + rq.Id);
        }
    }
    catch (Exception e) {
        system.debug(e.getStackTraceString());
        Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
        ApexPages.addMessage(errMsg);
    }
    return null;
}
public PageReference cancelNonSPonsorId() {
    System.debug('acc====' + acc);
    System.debug('con====' + con);
    System.debug('rq.Acc====' + rq.Acc__c);
    System.debug('rq.Con====' + rq.Con__c);
    Contact c = [Select Id, rol__c, FirstName, LastName, Gender__c, nc__c, Age__c, p__c, pic__c, pid__c, ped__c, pip__c, fnar__c, lnar__c, mnar__c from Contact where Id =: rq.Con__c];
    Account a = [Select Id from Account where Id =: rq.Acc__c];
    rq.srvc__c = [Select Id from g_Srvc__c where uid__c = '069' LIMIT 1 ].Id;
    rq.xadh__c = 'rv;';
    System.debug('AbsDecR rq=====' + rq);
    try {
        rq.sta__c = 'Draft';
        rq.xcfn__c = c.FirstName;
        rq.xcfnar__c = c.fnar__c;
        rq.xcmnar__c = c.mnar__c;
        rq.xclnar__c = c.lnar__c;
        rq.xcp__c = c.p__c;
        rq.xcpid__c = c.pid__c;
        rq.xcped__c = c.ped__c;
        rq.xcpic__c = c.pic__c;
        rq.xcln__c = c.LastName;
        rq.Gender__c = c.Gender__c;
        rq.xcpip__c = c.pip__c;
        rq.xcnc__c = c.nc__c;
        Database.SaveResult sr = Database.insert(rq);
        if (sr.isSuccess()) {
            System.debug('Successfully inserted Request. Request ID: ' + sr.getId());
            String srNumber = [Select Id, Name from g_Req__c where id =: sr.getId()].Name;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'SR is created Successfully with SR#' + srNumber));
            return new PageReference('/' + rq.Id);
        }
    }
    catch (Exception e) {
        system.debug(e.getStackTraceString());
        Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getStackTraceString());
        ApexPages.addMessage(errMsg);
    }
    return null;
}
public PageReference AbsDecR() {
    System.debug('acc====' + acc);
    System.debug('con====' + con);
    System.debug('rq.Acc====' + rq.Acc__c);
    System.debug('rq.Con====' + rq.Con__c);
    Contact c = [Select Id, rol__c, FirstName, LastName, Gender__c, nc__c, Age__c, p__c, pic__c, pid__c, ped__c, pip__c, fnar__c, lnar__c, mnar__c from Contact where Id =: rq.Con__c];
    Account a = [Select Id from Account where Id =: rq.Acc__c];
    if (c.rol__c == 'Employee') {
        rq.srvc__c = [Select Id from g_Srvc__c where uid__c = '037' LIMIT 1 ].Id;
        rq.xadh__c = 'ip;';
    }
    if (c.rol__c == 'Student') {
        rq.srvc__c = [Select Id from g_Srvc__c where uid__c = '039' LIMIT 1 ].Id;
        rq.xadh__c = 'ip;';
    }
    System.debug('AbsDecR rq=====' + rq);
    try {
        rq.sta__c = 'Draft';
        rq.xcfn__c = c.FirstName;
        rq.xcfnar__c = c.fnar__c;
        rq.xcmnar__c = c.mnar__c;
        rq.xclnar__c = c.lnar__c;
        rq.xcp__c = c.p__c;
        rq.xcpid__c = c.pid__c;
        rq.xcped__c = c.ped__c;
        rq.xcpic__c = c.pic__c;
        rq.xcln__c = c.LastName;
        rq.Gender__c = c.Gender__c;
        rq.xcpip__c = c.pip__c;
        rq.xcnc__c = c.nc__c;
        Database.SaveResult sr = Database.insert(rq);
        if (sr.isSuccess()) {
            System.debug('Successfully inserted Request. Request ID: ' + sr.getId());
            String srNumber = [Select Id, Name from g_Req__c where id =: sr.getId()].Name;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'SR is created Successfully with SR#' + srNumber));
            return new PageReference('/' + rq.Id);
        }
    }
    catch (Exception e) {
        system.debug(e.getStackTraceString());
        Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getStackTraceString());
        ApexPages.addMessage(errMsg);
    }
    return null;
}
public PageReference WithdrawR() {
    System.debug('acc====' + acc);
    System.debug('con====' + con);
    System.debug('rq.Acc====' + rq.Acc__c);
    System.debug('rq.Con====' + rq.Con__c);
    Contact c = [Select Id, rol__c, FirstName, LastName, Gender__c, nc__c, Age__c, p__c, pic__c, pid__c, ped__c, pip__c, fnar__c, lnar__c, mnar__c from Contact where Id =: rq.Con__c];
    Account a = [Select Id from Account where Id =: rq.Acc__c];
    if (c.rol__c == 'Employee') {
        rq.srvc__c = [Select Id from g_Srvc__c where uid__c = '041' LIMIT 1 ].Id;
        rq.xadh__c = 'aw;ins;';
    }
    if (c.rol__c == 'Student') {
        rq.srvc__c = [Select Id from g_Srvc__c where uid__c = '043' LIMIT 1 ].Id;
        rq.xadh__c = 'aw;ins;';
    }
    System.debug('WithdrawR rq=====' + rq);
    try {
        rq.sta__c = 'Draft';
        rq.xcfn__c = c.FirstName;
        rq.xcfnar__c = c.fnar__c;
        rq.xcmnar__c = c.mnar__c;
        rq.xclnar__c = c.lnar__c;
        rq.xcp__c = c.p__c;
        rq.xcpid__c = c.pid__c;
        rq.xcped__c = c.ped__c;
        rq.xcpic__c = c.pic__c;
        rq.xcln__c = c.LastName;
        rq.Gender__c = c.Gender__c;
        rq.xcpip__c = c.pip__c;
        rq.xcnc__c = c.nc__c;
        Database.SaveResult sr = Database.insert(rq);
        if (sr.isSuccess()) {
            System.debug('Successfully inserted Request. Request ID: ' + sr.getId());
            String srNumber = [Select Id, Name from g_Req__c where id =: sr.getId()].Name;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'SR is created Successfully with SR#' + srNumber));
            return new PageReference('/' + rq.Id);
        }
    }
    catch (Exception e) {
        system.debug(e.getStackTraceString());
        Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getStackTraceString());
        ApexPages.addMessage(errMsg);
    }
    return null;
}
String validatePage(String srvc) {
    List<String> services = new List<String> {
    /** Services where Account & Contact are required **/ 'Cancellation Inside UAE', 'Cancellation Outside UAE with Passport', 'Cancellation Outside UAE without Passport', 'Cancellation Non Sponsor Id', 'Absconder Declaration', 'Withdrawal', 'Non Sponsored ID - Security Deposit' }
    ;
    String message = '';
    if (rq.Acc__c == NULL) {
        message = 'Please select Account';
    }
    else if (services.contains(srvc) && rq.Con__c == NULL) {
        message = 'Please select Contact';
    }
    return message;
}
public PageReference nsIDDeposit() {
    String message = validatePage('Non Sponsored ID - Security Deposit');
    if (String.isNotBlank(message)) {
        Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR, message);
        ApexPages.addMessage(errMsg);
    }
    else {
        Contact c = [Select Id, rol__c, FirstName, LastName, Gender__c, nc__c, Age__c, p__c, pic__c, pid__c, ped__c, pip__c, fnar__c, lnar__c, mnar__c from Contact where Id =: rq.Con__c];
        Account a = [Select Id from Account where Id =: rq.Acc__c];
        rq.srvc__c = [Select Id from g_Srvc__c where uid__c = 'gvd' LIMIT 1].Id;
        System.debug('nsIDDeposit rq=====' + rq);
        try {
            rq.sta__c = 'Draft';
            rq.xcfn__c = c.FirstName;
            rq.xcfnar__c = c.fnar__c;
            rq.xcmnar__c = c.mnar__c;
            rq.xclnar__c = c.lnar__c;
            rq.xcp__c = c.p__c;
            rq.xcpid__c = c.pid__c;
            rq.xcped__c = c.ped__c;
            rq.xcpic__c = c.pic__c;
            rq.xcln__c = c.LastName;
            rq.Gender__c = c.Gender__c;
            rq.xcpip__c = c.pip__c;
            rq.xcnc__c = c.nc__c;
            Database.SaveResult sr = Database.insert(rq);
            if (sr.isSuccess()) {
                System.debug('Successfully inserted Request. Request ID: ' + sr.getId());
                String srNumber = [Select Id, Name from g_Req__c where id =: sr.getId()].Name;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'SR is created Successfully with SR#' + srNumber));
                return new PageReference('/' + rq.Id);
            }
        }
        catch (Exception e) {
            system.debug(e.getStackTraceString());
            Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(errMsg);
        }
    }
    return NULL;
}

}