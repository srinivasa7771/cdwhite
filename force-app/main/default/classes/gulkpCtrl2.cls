public with sharing class gulkpCtrl2 {
    public Boolean ispu{get;set;}
    public String sid{get;set;}
    public String qObj{get;set;}
    public User U{get;set;}
    public String rID {get;set;}
    public String jId {set;get;}
    public String cRole {get;set;}
    public String csRl {get;set;}
    public String prsn {get;set;}
    public String cSta {get;set;}
    public String isSponsor{get;set;}
    public Boolean onlyOutSourced{get;set;}
    public g_srvc__c ser {get;set;}
    public list<Contact> serContList {get;set;}
    public list<Contact> serSpnList {get;set;}
    public Contact preloadedContact {get;set;}
    public String serContString {get;set;}
    public String serSpnString {get;set;}
    public String selectedCon {get;set;}
    public String selectedSpn {get;set;}
    public String selectedJobTitle {get;set;}
    public Id cAccId {get;set;}
    public String title {get;set;}
    public list<g_jb__c> jobList {get;set;}
    public list<b_and_b__c> bNameList {get;set;}
    public g_req__c req {get;set;}
    public g_reqDoc__c reqDoc {get;set;}
    public String jobString {get;set;}
    public boolean certFlag {get;set;}
    public boolean showAtt {get;set;}
    public String docName { get; set; }
    public transient  String imageBase64 {get;set;}
    public Attachment A {get;set;}
    public doc attacheDoc {get;set;}
    public g_req__c rq {get;set;}
    public String parkingCard {get;set;}

    public String sdVisaType {get;set;}

    public gulkpCtrl2(){
        ispu=gU.isPortalUser(UserInfo.getProfileId());
        system.debug('rId30--> '+rq);
        /* for Bank Name lookup */
        bNameList = [select id, name,Branch_Name__c,Country__c,ccode__c,bcode__c from b_and_b__c where  Country__c='United Arab Emirates' limit 5];

    }
    public void searchPersons(){
        String p = prsn+'%';
        List<String> strLst = new List<String>();
        if (prsn.contains(' ')){
            system.debug('inside if');
            for (String str1: prsn.split(' ')){
                system.debug('str1===='+str1);
                strLst.add('%'+str1+'%');
            }
        }
        else
            strLst.add('%'+prsn+'%');

        system.debug('p-- '+p);
        system.debug('cSta-- '+cSta);
        system.debug('cAccId-- '+cAccId);
        List <String> roleStr = (csRl != null && csRl != '') ? csRl.split(';') : (cRole==null?new List<String>():cRole.split(';'));
            List <String> staStr = cSta==null?new List<String>():cSta.split(';');
        system.debug('roleStr-- '+roleStr);
        system.debug('staStr-- '+staStr);
        system.debug('parkingCard-- '+parkingCard);
        String baseQuery = 'select id,nc__c,jd__c,flnm__c,mbs__c,name,p__c,jb__r.name,Photo_ID__c,STA__c,rped__c, Salutation,firstName,middleName, LastName,Email,MobilePhone,eidid__c,rol__c,xped__c from contact where rol__c in :roleStr and STA__c in :staStr and account.id=:cAccId order by rped__c';
        String limitedBaseQuery = '';
        if (onlyOutSourced==true){
            system.debug('1::::::');
            baseQuery = baseQuery.replaceFirst(' order by rped__c', ' and os__c=true order by rped__c');
            system.debug('baseQuery -- '+baseQuery);
        }
        else if (String.isNotBlank(sdVisaType) && sdVisaType.equalsIgnoreCase('egv')){
            system.debug('1::::::');
            baseQuery = baseQuery.replaceFirst(' order by rped__c', ' and mbs__c>=30000 and jb__r.mgr__c=true and jd__c<LAST_N_DAYS:725 order by rped__c');
            system.debug('baseQuery -- '+baseQuery);
        }
        else if (String.isNotBlank(sdVisaType) && (sdVisaType.equalsIgnoreCase('par') || sdVisaType.equalsIgnoreCase('elig') )){
            system.debug('2::::::');
            system.debug('No change in baseQuery');
            system.debug('baseQuery -- '+baseQuery);
        }
        else if (String.isNotBlank(sdVisaType) && sdVisaType.equalsIgnoreCase('imp')){
            system.debug('3::::::');
            staStr = new List <String>{'Active','Under Activation','Under Deactivation','Absconded','Absconder Withdrawn'};
                system.debug('No change in baseQuery');
            system.debug('baseQuery -- '+baseQuery);
        }
        else if ((rq!=null && rq.srvc__r.uid__c!=null)&&(rq.srvc__r.uid__c==gu.csStr('ParkingActivation') || parkingCard!='')){
            system.debug('4::::::');
            baseQuery = baseQuery.replaceFirst(' order by rped__c', ' and apc__c=\'\' order by rped__c');
            system.debug('baseQuery -- '+baseQuery);
        }
        system.debug('roleStr -- '+roleStr);
        system.debug('staStr -- '+staStr);
        baseQuery = (p=='%')?baseQuery+' limit 10':baseQuery.replaceFirst('where', 'where  ((firstname LIKE: strLst) or (middlename LIKE: strLst) or (lastname LIKE: strLst) or (p__c LIKE: strLst)) and');
        system.debug('baseQuery -- '+baseQuery);
        /*//****toDo : use dynamic string and use database.query */
        /*if (onlyOutSourced==true){
system.debug('1::::::');
serContList = (p=='%')?[select id,nc__c,flnm__c,name,p__c,jb__r.name,Photo_ID__c,STA__c,rped__c, Salutation,firstName, LastName,Email,MobilePhone,eidid__c,rol__c,xped__c from contact where rol__c in:roleStr and  STA__c in:staStr and account.id=:cAccId and os__c=true order by rped__c limit 10]:[select id,nc__c,flnm__c,name,p__c,jb__r.name,Photo_ID__c,STA__c,rped__c, Salutation,firstName, LastName,Email,MobilePhone,eidid__c,rol__c,xped__c from contact where Name LIKE:p and rol__c in:roleStr and  STA__c in:staStr and account.id=:cAccId and os__c=true];
}else if (String.isNotBlank(sdVisaType) && (sdVisaType.equalsIgnoreCase('par') || sdVisaType.equalsIgnoreCase('elig') )){
system.debug('2::::::');
serContList = (p=='%')?[select id,nc__c,flnm__c,name,p__c,jb__r.name,Photo_ID__c,STA__c,rped__c, Salutation,firstName, LastName,Email,MobilePhone,eidid__c,rol__c,xped__c from contact where account.id=:cAccId and rol__c in:roleStr and  STA__c in:staStr order by rped__c limit 10]:[select id,nc__c,flnm__c,name,p__c,jb__r.name,Photo_ID__c,STA__c,rped__c, Salutation,firstName, LastName,Email,MobilePhone,eidid__c,rol__c,xped__c from contact where account.id=:cAccId and Name LIKE:p and rol__c in:roleStr and  STA__c in:staStr];
}else if (String.isNotBlank(sdVisaType) && sdVisaType.equalsIgnoreCase('imp')){
system.debug('3::::::');
serContList = (p=='%')?[select id,nc__c,flnm__c,name,p__c,jb__r.name,Photo_ID__c,STA__c,rped__c, Salutation,firstName, LastName,Email,MobilePhone,eidid__c,rol__c,xped__c from contact where account.id=:cAccId and rol__c in:roleStr and STA__c IN('Active','Under Activation','Under Deactivation','Absconded','Absconder Withdrawn') order by rped__c limit 10]:[select id,nc__c,flnm__c,name,p__c,jb__r.name,Photo_ID__c,STA__c,rped__c, Salutation,firstName, LastName,Email,MobilePhone,eidid__c,rol__c,xped__c from contact where account.id=:cAccId and Name LIKE:p and rol__c in:roleStr and STA__c IN('Active','Under Activation','Under Deactivation','Absconded','Absconder Withdrawn')];
}else{
system.debug('4::::::');
serContList = (p=='%')?[select id,nc__c,flnm__c,name,p__c,jb__r.name,Photo_ID__c,STA__c,rped__c, Salutation,firstName,middleName, LastName,Email,MobilePhone,eidid__c,rol__c,xped__c from contact where rol__c in:roleStr and STA__c in:staStr and account.id=:cAccId order by rped__c limit 10]:[select id,nc__c,flnm__c,name,p__c,jb__r.name,Photo_ID__c,STA__c,rped__c, Salutation,firstName,middleName, LastName,Email,MobilePhone,eidid__c,rol__c,xped__c from contact where ((firstname LIKE: strLst) or (middlename LIKE: strLst) or (lastname LIKE: strLst) or (p__c LIKE: strLst)) and rol__c in:roleStr and STA__c in:staStr and account.id=:cAccId];
}
if ((rq!=null && rq.srvc__r.uid__c!=null)&&(rq.srvc__r.uid__c==gu.csStr('ParkingActivation') || parkingCard!='')){
serContList = (p=='%')?[select id,nc__c,flnm__c,name,p__c,jb__r.name,Photo_ID__c,STA__c,rped__c, Salutation,firstName,middleName, LastName,Email,MobilePhone,eidid__c,rol__c,xped__c from contact where rol__c in:roleStr and STA__c in:staStr and account.id=:cAccId and apc__c='' order by rped__c limit 10]:[select id,nc__c,flnm__c,name,p__c,jb__r.name,Photo_ID__c,STA__c,rped__c, Salutation,firstName,middleName, LastName,Email,MobilePhone,eidid__c,rol__c,xped__c from contact where ((firstname LIKE: strLst) or (middlename LIKE: strLst) or (lastname LIKE: strLst)) and rol__c in:roleStr and STA__c in:staStr and account.id=:cAccId and apc__c=''];
}*/
        /*//serContList = [select id,flnm__c,name,p__c,jb__r.name,Photo_ID__c,STA__c,rped__c,xped__c from contact where Name LIKE:p and rol__c in:roleStr and STA__c =: cSta and account.id=:cAccId]; */
        serContList = Database.query(baseQuery);
        system.debug('serContList-- '+serContList);

        serContString = JSON.serialize(serContList);
        serSpnList = serContList;
        serSpnString = serContString;

    }

    public void updateRequest(){
        rq.STA__c = 'Under Review';
        update rq;
    }
    public PageReference saveDraft(){
        /*//string jblkp = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('lkp')); //system.debug('job---- '+jblkp); //rq.xcjb__c = jblkp; //rq.xcjb__c = 'a0O0I00000Nm8ZnUAJ'; //rq.STA__c = 'Draft'; */
        PageReference ref = null;
        system.debug('rq.xcjb__c::'+rq.xcjb__c);
        update rq;
        ref = new Pagereference('/' + rq.Id);
        ref.setRedirect(true);
        return ref;
    }
    public void saveDraft1(){
        system.debug('contact ---- 58');
        string lkpCon = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('lkpCon'));
        system.debug('contact ---- '+lkpCon);
        rq.con__c = lkpCon;
        system.debug('contact ---- '+lkpCon);
        update rq;
    }

    public void init_con(){
        /*//for contact lookup */
        List <String> roleStr = cRole==null?new List<String>():cRole.split(';');
        system.debug('roleStr --'+roleStr);
        system.debug('rq --'+rq);
        if (rq!=null){
            system.debug('req.Con__c --'+rq.Con__c);
            list<g_req__c> serReqList= [select con__r.id,con__r.flnm__c,con__r.name,con__r.p__c,con__r.jb__r.name,con__r.Photo_ID__c, con__r.eidid__c,con__r.rol__c from g_req__c where id =:rq.id];
            system.debug('cSta --'+cSta);
            system.debug('cAccId --'+cAccId);
            String Query = 'select id,flnm__c,name,p__c,jb__r.name,Photo_ID__c,eidid__c,rol__c,xped__c from contact where id ='+rq.Con__c+' and rol__c in'+roleStr+' and STA__c ='+cSta+' and account.id='+cAccId;
            system.debug('Query --'+Query);
            if (serReqList.size()<1)
                return;
            serContList= [select id,flnm__c,name,p__c,jb__r.name,Photo_ID__c,STA__c,rped__c,Salutation,firstName, LastName,Email,MobilePhone,eidid__c,rol__c,xped__c from contact where id =:serReqList[0].con__r.id];
            if (serContList.size()>0)
                preloadedContact = serContList[0];
            system.debug('preloadedContact --- '+preloadedContact);
            serContString = JSON.serialize(serContList);
        }
    }

    public void init_spn(){
        /*//for Sponcer lookup */
        List <String> roleStr = cRole==null?new List<String>():cRole.split(';');
        list<g_req__c> serReqList= [select con__r.id,con__r.flnm__c,con__r.name,con__r.p__c,con__r.jb__r.name,con__r.Photo_ID__c,con__r.rol__c from g_req__c where id =:rq.id];
        String Query = 'select id,flnm__c,name,p__c,jb__r.name,Photo_ID__c,xped__c from contact where id ='+rq.Con__c+' and rol__c in'+roleStr+' and STA__c ='+cSta+' and account.id='+cAccId;
        system.debug('Query --'+Query);
        if (serReqList.size()<1)
            return;
        serSpnList= [select id,flnm__c,name,p__c,jb__r.name,Photo_ID__c,rol__c,xped__c from contact where id =:rq.Spr__c];
        if (serSpnList.size()>0)
            preloadedContact = serSpnList[0];
        serSpnString = JSON.serialize(serSpnList);
    }
    public Boolean requiresCert {get;set;}
    public void init(){
        bNameList = new List<b_and_b__c>();
        requiresCert = false;
        system.debug('in init---- ');
        List<Attachment> A1; String jobid;
        system.debug('rq.xcjb__c--> '+rq.xcjb__c);
        List<g_jb__c> searchedList = new List<g_jb__c> ();
        /*// jId = rq.con__r.jb__c; */
        system.debug('jId --> '+jId);
        if (String.isNotBlank(jId))
            jobid = jId;
        else
            jobid = rq.xcjb__c;
        if (rq.acc__r.Legal_Framework__c=='Freelancer'){
            jobList = [select id,name,rc__c,aff__c from g_jb__c where id=:jobid and aff__c=true];
        }
        else
            jobList = [select id,name,rc__c,aff__c from g_jb__c where id=:jobid];
        if (jobList!=null && jobList.size()>0)
            requiresCert = jobList[0].rc__c;
        system.debug('jobList -- '+jobList);
        if (jobList != null && jobList.size()>0)
            jobString = JSON.serialize(jobList);

        list<g_reqDoc__c > reqDocLst = [select id,name from g_reqDoc__c where RQ__r.id=:rq.id and name like '%Attested Degree Certificate%' limit 1];
        system.debug('reqDocLst --> '+reqDocLst );
        if (reqDocLst.size()>0){
            reqDoc = reqDocLst[0];
            A1 = [select id, name from Attachment where parentId =: reqDoc.id order by createddate desc limit 1];
            if (A1.size()>0)
                A = A1[0];
            system.debug('A1 --> '+A1);
        }


    }
    public String bNameString{get;set;}
    public void searchBankNames(){
        String t = '%'+title+'%';
        bNameList = [select id,name,Branch_Name__c,ccode__c,Country__c,bcode__c from b_and_b__c where name like: t or Country__c like:t];
        system.debug('bNameList -- '+bNameList);
        bNameString = JSON.serialize(bNameList);
        system.debug('bNameString -- '+bNameString);

    }
    public void searchJobTitles(){
        system.debug('tsts:::');
        String t = title+'%';
        system.debug('t----  '+t);
        List<g_jb__c> searchedList = new List<g_jb__c> ();
        /* //jobList = (t!='%')?[select id,name,rc__c from g_jb__c where name like: t]:[select id,name,rc__c from g_jb__c limit 5]; */

        List<g_req__c> dummyReq = [Select id, name, acc__r.Legal_Framework__c from g_req__c where id=:rq.id];

        if (dummyReq!=null && dummyReq.size()>0 && String.isNotBlank(dummyReq[0].acc__r.Legal_Framework__c) && dummyReq[0].acc__r.Legal_Framework__c.equalsIgnoreCase('freelancer')){
            jobList = [select id,name,rc__c,aff__c from g_jb__c where name like: t and aff__c=true and h__c=false];
        }else{
            jobList = [select id,name,rc__c,aff__c from g_jb__c where name like: t and h__c=false];
        }
        system.debug('jobList -- '+jobList);
        jobString = JSON.serialize(jobList);
        system.debug('rId --> '+rID);
        list<g_reqDoc__c > reqDocLst = [select id,name from g_reqDoc__c where RQ__r.id=:rq.id and name like '%Attested Degree Certificate%' limit 1];
        if (reqDocLst.size()>0)
            reqDoc = reqDocLst[0];
        system.debug('reqDoc --> '+reqDoc);
    }
    public void insertAttachment(){
        system.debug('imageBase64--- '+imageBase64);
        system.debug('docName--- '+docName);
        system.debug('reqDoc.id--- '+reqDoc.id);
        A = new Attachment(Body = EncodingUtil.base64Decode(imageBase64), Name = docName, ParentId = reqDoc.id);
        system.debug('A-- '+A);
        insert A;
        attacheDoc = new doc(A.Name,A.id);
        system.debug('attacheDoc-- '+attacheDoc);
    }
    public void deleteAttachment(){
        system.debug('A.id-- '+A.id);
        /*//Attachment att = [Select id, name from Attachment where id=:attacheDoc.docId];
//system.debug('att-- '+att); */
        Delete A;
        A = new Attachment();
    }

    public class doc{
        public String docName{get;set;}
        public Id docId{get;set;}
        public doc(String docName,ID docId ){
            this.docName=docName;
            this.docId=docId;
        }
    }



    /* //PO BOX Zones */
    public String pob {get;set;}
    public list<pbzn__c> poboxList {get;set;}
    public String serPBString {get;set;}
    public String selectedZone {get;set;}
    public pbzn__c preloadedPOB {get;set;}

    public void searchPOBoxes(){
        String p = '%'+pob+'%';
        //poboxList = (p=='%%')?[select id,name,xapbc__c from pbzn__c where xapbc__c>0 AND name!='Dubai Healthcare City' order by name limit 10]:[select id,name,xapbc__c from pbzn__c where Name LIKE:p AND name!='Dubai Healthcare City' and xapbc__c>0 order by name];
        poboxList = (p=='%%')?[select id,name,xapbc__c from pbzn__c where xapbc__c>0 AND name!='Dubai Healthcare City' order by name]:[select id,name,xapbc__c from pbzn__c where Name LIKE:p AND name!='Dubai Healthcare City' and xapbc__c>0 order by name];
            serPBString = JSON.serialize(poboxList);
    }

    public void init_POB(){
        list<g_req__c> serReqList= [select id, name, xpaz__c from g_req__c where id =:rq.id];
        if (serReqList.isEmpty()){return;}
        poboxList= [select id,name,xapbc__c from pbzn__c where id =:serReqList[0].xpaz__c];
        if (poboxList.size()>0){preloadedPOB = poboxList[0];}
        serPBString = JSON.serialize(poboxList);
    }


    /*//PO BOXes
//ToDo: use str variable to query */
    public String allocatedPOB {get;set;}
    public list<alocpob__c> lstAllocatedPOB {get;set;}
    public String srcPBOString {get;set;}
    public String selected_POB {get;set;}
    public alocpob__c preloaded_POB {get;set;}
    public String pobSrvc {get;set;}

    public void searchAllocatedPOBoxes(){
        String p = '%'+allocatedPOB+'%';

        String qry = 'select id,name,zone__c,edt__c,idt__c,stts__c,typ__c from alocpob__c where acc__c = \''+rq.Acc__c+'\' and stts__c=\'Active\' ';
        if (String.isNotBlank(allocatedPOB)){qry += ' and Name LIKE \'' + p + '\'';}
        /*//Commented  because query condition  wrong for PO Box renewal */
        if (String.isNotBlank(pobSrvc) && pobSrvc.equalsIgnoreCase('renewal')){qry += ' and ( edt__c <= today OR edt__c = NEXT_N_DAYS:30) ';}
        lstAllocatedPOB = Database.query(qry);

        /*//lstAllocatedPOB = (p=='%%')?[select id,name,zone__c,edt__c,idt__c,stts__c,typ__c from alocpob__c where acc__c = :rq.Acc__c and stts__c='Active' and edt__c<today]:[select id,name,zone__c,edt__c,idt__c,stts__c,typ__c from alocpob__c where acc__c = :rq.Acc__c and stts__c='Active' and edt__c<today and Name LIKE:p ];*/
        srcPBOString = JSON.serialize(lstAllocatedPOB);
    }

    public void init_allocatedPOB(){
        list<g_req__c> serReqList= [select id, name,  xpbg__c from g_req__c where id =:rq.id];
        if (serReqList.isEmpty()){return;}
        list<alocpob__c> lstAllocatedPOB = [select id, name,zone__c,edt__c,idt__c,stts__c,typ__c from alocpob__c where id = :serReqList[0].xpbg__c];
        if (lstAllocatedPOB.size()>0){preloaded_POB = lstAllocatedPOB[0];}
        srcPBOString = JSON.serialize(lstAllocatedPOB);
    }
}