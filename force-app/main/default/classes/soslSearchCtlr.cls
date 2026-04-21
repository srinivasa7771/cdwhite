Public with sharing class soslSearchCtlr{

    Public String searchStr{get;set;}
    Public String objType{get;set;}
    Public List<g_Req__c> rqList {get;set;}
    Public List<People> conList{get;set;}
    Public List<case> csList {get;set;}
    Public List<g_Tran__c> transList {get;set;}

    Public Boolean hasRqList {get;set;}
    Public Boolean hasConList{get;set;}
    Public Boolean hasCsList {get;set;}
    Public Boolean hasTransList {get;set;}

    Public Boolean isParkingUser {get;set;}

    List<selectOption> options = new List<selectOption>();
    public List<selectOption> getSearchOption() {
        options = new List<selectOption>();
        options.add(new selectOption('All', 'All'));
        options.add(new selectOption('Request', 'Requests'));
        options.add(new selectOption('Contact', 'People & Visas'));
        options.add(new selectOption('Case', 'Tickets'));
        options.add(new selectOption('Transaction', 'Transactions'));
        return options;
    }

    Public soslSearchCtlr() {
        isParkingUser = gU.checkParkingUser(UserInfo.getUserId());
        searchDemo();
    }

    Public void searchDemo() {
        searchStr = apexpages.currentpage().getparameters().get('sos');
        if (searchStr == null)
            searchStr ='';
        objType = 'All';
        search();
    }
    Public void search() {
        searchSoql();
        //searchSosl();
    }

    public class People{
        public contact con{get;set;}
        public string passExp{get;set;} // Passport Expiry
        public string resiExp{get;set;} // residence Expiry
        public People(Contact c) {
            con = c;
            if (c.ped__c != null) {
                Integer  d1= Date.today().daysBetween(c.ped__c);
                if (d1 <= 0)
                    passExp = 'Expired';
                else if (d1 <= 30)
                    passExp = 'Expires in '+d1 +' days';
                else
                    passExp = 'Valid till : '+ DateTime.newInstance(c.ped__c.year(), c.ped__c.month(), c.ped__c.day()).format('dd/MM/YYYY');
            }
            if (c.rped__c != null) {
                Integer  d2 = Date.today().daysBetween(c.rped__c);
                if (d2 <= 0)
                    resiExp = 'Expired';
                else if (d2 <= 30)
                    resiExp = 'Expires in '+d2 +' days';
                else
                    resiExp = 'Valid till : '+ DateTime.newInstance(c.rped__c.year(), c.rped__c.month(), c.rped__c.day()).format('dd/MM/YYYY');
            }
        }
    }

    Public void searchSoql() {

        List <String> parkingSerCodes = System.Label.parkingSerCodes.split(', ');
        String parkingSerCodesSer ='';
        for (Integer i=0;i<parkingSerCodes.size();i++) {
            if (i == parkingSerCodes.size()-1)
                parkingSerCodesSer += '\''+parkingSerCodes[i]+'\'';
            else
                parkingSerCodesSer += '\''+parkingSerCodes[i]+'\', ';

        }
        system.debug('>>> In Search');
        rqList = New List<g_Req__c>();
        conList = New List<People>();
        csList = New List<Case>();
        transList = New List<g_Tran__c>();
        String srStr='';

        if (searchStr != null && searchStr != '')
            srStr = '\'%' + String.escapeSingleQuotes(searchStr) + '%\'';
        system.debug('srStr >>>'+srStr);
        system.debug('objType >>>'+objType);

        hasRqList = false;
        hasConList = false;
        hasCsList = false;
        hasTransList = false;

        if (!srStr.equals('')) {
            string rqQuery = 'select id, Name, Applicant_Name__c, xcfn__c, xcmn__c, xcln__c, srvc__c, srvc__r.name, STA__c, prio__c, Priority__c, xcnc__c, CurrentNationality__c, xcp__c, tmpp__c, xfpdd__c from g_Req__c ';
            rqQuery += ' where (Name LIKE '+srStr;
            rqQuery += ' OR xcfn__c LIKE '+srStr;
            rqQuery += ' OR xcmn__c LIKE '+srStr;
            rqQuery += ' OR xcln__c LIKE '+srStr;
            rqQuery += ' OR prio__c LIKE '+srStr;
            rqQuery += ' OR STA__c LIKE '+srStr;
            rqQuery += ' OR xcnc__c LIKE '+srStr;
            rqQuery += ' OR xcp__c LIKE '+srStr;
            rqQuery += ' OR Applicant_Name__c LIKE '+srStr+')';
            rqQuery += isParkingUser?' AND Service_Code__c in ('+parkingSerCodesSer+')':'';
            system.debug('rqQuery -- '+rqQuery);
            //rqQuery += ' OR xfpdd__c LIKE '+srStr;

            string conQuery = 'select id, Name, email, Photo_ID__c, STA__c, nc__c, p__c, rpexp__c, ped__c, rol__c, Job_Title_Formula__c, eidid__c, xean__c, eidedt__c, rp__c, RP_Expiry_Status__c, rped__c from Contact ';
            conQuery += ' where Name LIKE '+srStr;
            conQuery += ' OR email LIKE '+srStr;
            conQuery += ' OR STA__c LIKE '+srStr;
            conQuery += ' OR nc__c LIKE '+srStr;
            conQuery += ' OR p__c LIKE '+srStr;
            conQuery += ' OR rol__c LIKE '+srStr;
            conQuery += ' OR Job_Title_Formula__c LIKE '+srStr;
            conQuery += ' OR eidid__c LIKE '+srStr;
            conQuery += ' OR xean__c LIKE '+srStr;
            //conQuery += isParkingUser?' AND Service_Code__c in ('+parkingSerCodesSer+')':'';
            // conQuery += ' OR eidedt__c LIKE '+srStr;

            string csQuery = 'select id, CaseNumber, Subject, Request__c, Request__r.name, Request__r.xcfn__c, Request__r.xcmn__c, Request__r.xcln__c, CreatedDate, ClosedDate, Status, Service_Type__c from case ';
            csQuery += ' where (CaseNumber LIKE '+srStr;
            csQuery += ' OR Subject LIKE '+srStr;
            csQuery += ' OR Request__r.xcfn__c LIKE '+srStr;
            csQuery += ' OR Request__r.xcmn__c LIKE '+srStr;
            csQuery += ' OR Request__r.xcln__c LIKE '+srStr;
            csQuery += ' OR Service_Type__c LIKE '+srStr;
            csQuery += ' OR Status LIKE '+srStr+')';
            csQuery += isParkingUser?' AND Request__r.Service_Code__c in ('+parkingSerCodesSer+')':'';

            string tranQuery = 'select id, Name, RQ__c, RQ__r.name, Service_Name__c, STA__c, TP__c, md__c, A__c from g_Tran__c ';
            tranQuery += ' where TP__c NOT IN (\'Claim\') AND ( Name LIKE '+srStr;
            tranQuery += ' OR STA__c LIKE '+srStr;
            tranQuery += ' OR TP__c LIKE '+srStr;
            tranQuery += ' OR md__c LIKE '+srStr;
            tranQuery += ' OR  RQ__r.Name LIKE '+srStr;
            tranQuery += ' OR Acc__r.Name LIKE '+srStr;
            tranQuery += ' )';
            tranQuery += isParkingUser?' AND rq__r.Service_Code__c in ('+parkingSerCodesSer+')':'';

            system.debug('rqQuery >>>'+ rqQuery);
            system.debug('conQuery >>>'+ conQuery);
            system.debug('csQuery >>>'+ csQuery );
            system.debug('tranQuery >>>'+ tranQuery);

            if (objType =='All') {
                rqList = (List<g_Req__c>)Database.query(rqQuery + ' limit 100');
                List<Contact> cLst  = (List<Contact>)Database.query(conQuery + ' limit 100');
                for (Contact c:cLst) {conList.add(new People(c));}
                csList = (List<case>)Database.query(csQuery + ' limit 100');
                transList = (List<g_Tran__c>)Database.query(tranQuery + ' limit 100');
            }else if (objType =='Request') {
                rqList = (List<g_Req__c>)Database.query(rqQuery + ' limit 100');
                conList  = new List<People>();
                csList = new List<case>();
                transList = new List<g_Tran__c>();
            }else if (objType =='Contact') {
                rqList = new List<g_Req__c>();
                List<Contact> cLst  = (List<Contact>)Database.query(conQuery + ' limit 100');
                for (Contact c:cLst) {conList.add(new People(c));}
                csList = new List<case>();
                transList = new List<g_Tran__c>();
            }else if (objType =='Case') {
                rqList = new List<g_Req__c>();
                conList  = new List<People>();
                csList = (List<case>)Database.query(csQuery + ' limit 100');
                transList = new List<g_Tran__c>();
            }else if (objType =='Transaction') {
                rqList = new List<g_Req__c>();
                conList  = new List<People>();
                csList = new List<case>();
                transList = (List<g_Tran__c>)Database.query(tranQuery + ' limit 100');
            }

            system.debug('rqList >>>'+ rqList);
            system.debug('conList >>>'+ conList);
            system.debug('csList >>>'+ csList );
            system.debug('transList >>>'+ transList);

            if (rqList.size() == 0 && conList.size() == 0 && csList.size() == 0&& transList.size() == 0) {
                //  apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Sory, no results returned with matching string..'));
                system.debug('Sory, no results returned with matching string..');
                return;
            }else{
                system.debug('Set View Flags');
                if (rqList != null && rqList.size()>0)
                    hasRqList = true;
                if (conList != null && conList.size()>0)
                    hasConList = true;
                if (csList != null && csList.size()>0)
                    hascsList = true;
                if (transList != null && transList.size()>0)
                    hasTransList = true;
            }
        }
        else{
            apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Please enter at least two characters..'));
            return;
        }
    }

    /*
Public void searchSosl() {
system.debug('>>> In Search');
rqList = New List<g_Req__c>();
conList = New List<contact>();
csList = New List<Case>();
transList = New List<g_Tran__c>();

system.debug('searchStr >>>'+searchStr);
system.debug('objType >>>'+objType);

hasRqList = false;
hasConList = false;
hasCsList = false;
hasTransList = false;

if (searchStr.length() > 1) {
String searchStr1 = '*'+searchStr+'*';
String rqQuery = ' g_Req__c(Name, xcfn__c, xcmn__c, xcln__c, srvc__c, STA__c, CurrentNationality__c, xcp__c, xfpdd__c, Priority__c) ';
String conQuery = ' Contact(Name, email, STA__c, nc__c, p__c, rol__c, Job_Title_Formula__c, eidid__c, xean__c, eidedt__c) ';
String csQuery = ' case(CaseNumber, Subject, Request__c, CreatedDate, ClosedDate, Status) ';
String tranQuery = ' g_Tran__c(Name, RQ__c, Service_Name__c, STA__c, TP__c, md__c, A__c) ';
String qry ='';
if (objType =='All') {
qry = rqQuery +', '+ conQuery +', '+ csQuery +', '+ tranQuery;
hasRqList = true;
hasConList = true;
hascsList = true;
hasTransList = true;
}else if (objType =='Request') {
qry = rqQuery;
hasRqList = true;
}else if (objType =='Contact') {
qry = conQuery;
hasConList = true;
}else if (objType =='Case') {
qry = csQuery;
hascsList = true;
}else if (objType =='Transaction') {
qry = tranQuery;
hasTransList = true;
}

system.debug(' qry >>>'+ qry);
if (qry != null && qry!='') {
String searchQuery = 'FIND \'' + searchStr1 + '\' IN ALL FIELDS RETURNING '+ qry;
List<List <sObject>> searchList = search.query(searchQuery);
system.debug('searchList >>>'+ searchList);

if (objType =='All') {
rqList = ((List<g_Req__c>)searchList[0]);
conList  = ((List<Contact>)searchList[1]);
csList = ((List<case>)searchList[2]);
transList = ((List<g_Tran__c>)searchList[3]);

}else if (objType =='Request') {
rqList = ((List<g_Req__c>)searchList[0]);
conList  = new List<Contact>();
csList = new List<case>();
transList = new List<g_Tran__c>();

}else if (objType =='Contact') {
rqList = new List<g_Req__c>();
conList  = ((List<Contact>)searchList[0]);
csList = new List<case>();
transList = new List<g_Tran__c>();
}else if (objType =='Case') {
rqList = new List<g_Req__c>();
conList  = new List<Contact>();
csList = ((List<case>)searchList[0]);
transList = new List<g_Tran__c>();
}else if (objType =='Transaction') {
rqList = new List<g_Req__c>();
conList  = new List<Contact>();
csList = new List<case>();
transList = ((List<g_Tran__c>)searchList[0]);

}

}

if (rqList.size() == 0 && conList.size() == 0 && csList.size() == 0&& transList.size() == 0) {
//  apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Sory, no results returned with matching string..'));
system.debug('Sory, no results returned with matching string..');
return;
}else{
system.debug('rqList >>>'+ rqList);
system.debug('conList >>>'+ conList);
system.debug('csList >>>'+ csList );
system.debug('transList >>>'+ transList);
}
}
else{
apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Please enter at least two characters..'));
return;
}
}
*/
}