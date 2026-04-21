public class helpCenterController {
    public List<mySerivceGroupRequest> servOptions {get;set;}
    public List<myFAQsWrapper> mainfaqOptions {get;set;}
    public ServiceDetail sdDetails {get;set;}
    public boolean isSRSelected {get;set;}
    public boolean isSearching {get;set;}
    public Set<String> glosskeyValues {get;set;}
    public map<String,String> alpha {get;set;}
    public map<String,List<Glossary__c>> glossMap {get;set;}
    public List<FAQ__kav> displayFAQOptions {get;set;}
    public List<FAQ__kav> FAQList {get;set;}
    public List<Glossary__c> glossDetailList {get;set;}
    public List<Glossary__c> glossDefaultList {get;set;}
    public String filterVal {get;set;}
    public String keyWord {get;set;}
    public String pageNo {get;set;}
    public Set<String> FAQHeadVal {get;set;}
    public User U {
        get;
        set;
    }
    public Account A {
        get;
        set;
    }
    public List<SelectOption> getAllvalues() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All','Search in all categories'));
        options.add(new SelectOption('EMPLOYEE SERVICES','Search in Employee Services'));
        options.add(new SelectOption('VISAS AND IMMIGRATION','Search in Visa and Immigration'));
        options.add(new SelectOption('COMPANY SERVICES','Search in Company Services'));
        options.add(new SelectOption('OTHER SERVICES','Search in Other Services'));
        options.add(new SelectOption('GENERAL INFORMATION','Search in General Information'));
        return options;
    }
    public helpCenterController(){
        filterVal = 'All';
        servOptions = loadSerivceList();
        glossMap = loadGlossaryList();
        loadFAQList();
    }
    public List<mySerivceGroupRequest> loadSerivceList() {
        servOptions = new List<mySerivceGroupRequest>();
        isSRSelected = false;
        Schema.DescribeFieldResult serviceGrouping = g_Srvc__c.Service_Group__c.getDescribe();
        Schema.DescribeFieldResult subCategory = g_Srvc__c.Sub_Category__c.getDescribe();
        List<Schema.PicklistEntry> srPicklist = serviceGrouping.getPicklistValues();
        List<Schema.PicklistEntry> subCatPicklist = subCategory.getPicklistValues();
        U = [select Id, accountid, contact.account.id, contact.account.os__c, contact.account.Prk__c,contact.account.Type from User where id =: UserInfo.getUserId() limit 1 ];
        String accountTyp = U.contact.account.Type;

        for ( Schema.PicklistEntry f : srPicklist){
            mySerivceGroupRequest sr = new mySerivceGroupRequest();
            sr.grpName = f.getLabel();
            List<mySerivceCategory> catList = new List<mySerivceCategory>();
            for (Schema.PicklistEntry g : subCatPicklist){
                mySerivceCategory srCat = new mySerivceCategory();
                List<g_Srvc__c> serNameList = [SELECT lbl__c,payMd__c,sdg__c,sdg__r.Name,sdg__r.Sub_Category__c,sdg__r.slbl__c,sdg__r.sd__c,sdg__r.docslbl__c,sdg__r.ptype__c,Fee_Structure__c,
                                               Sub_Category__c,NotForServCatalogue__c FROM g_Srvc__c
                                               WHERE Service_Group__c includes (:f.getLabel()) AND isDeleted=false AND actv__c=true
                                               AND Sub_Category__c=:(g.getLabel()) AND AccTp__c includes (:accountTyp) AND Service_Group__c != null];
                Map<Id,ServiceDetail> serLabel = new Map<Id,ServiceDetail>();
                System.debug('serNameList======='+serNameList);
                for (g_Srvc__c sr1: serNameList){
                    List<String> pyMe = new List<String>();
                    List<String> prTm = new List<String>();
                    ServiceDetail srDe = new ServiceDetail();
                    srDe.payMethod = new List<String>();
                    srDe.processTime = new List<String>();
                    String docStr = (sr1.sdg__r.docslbl__c == null || sr1.sdg__r.docslbl__c == '')? null : sr1.sdg__r.docslbl__c.replace('#','');
                    srDe.srno = sr1.sdg__c;
                    srDe.heading = sr1.sdg__r.slbl__c;
                    srDe.about = sr1.sdg__r.sd__c;
                    srDe.docList = (docStr == null)? null : docStr.split(';');
                    pyMe = (sr1.payMd__c == null || sr1.payMd__c == '')? null : sr1.payMd__c.split(';');
                    if (pyMe != null){
                        for (String str: pyMe){
                            String capStr = str!=null ? str.capitalize():null;
                            if (capStr != null){
                                if (capStr != 'Customer Deposit')
                                    srDe.payMethod.add(capStr);
                                else
                                    srDe.payMethod.add('Portal Deposit');
                            }

                        }
                    }
                    else{
                        srDe.payMethod = null;
                    }
                    prTm = (sr1.sdg__r.ptype__c == null || sr1.sdg__r.ptype__c == '' || sr1.sdg__r.ptype__c == ' ')? null : sr1.sdg__r.ptype__c.split(';');
                    if (prTm != null){
                        for (String str1: prTm){
                            String capStr1 = str1!=null ? str1.capitalize():null;
                            if (capStr1 != null)
                                srDe.processTime.add(capStr1);
                        }
                    }else{
                        srDe.processTime = null;
                    }
                    srDe.feeStruct = (sr1.Fee_Structure__c == null || sr1.Fee_Structure__c == '')? null : sr1.Fee_Structure__c.split(';');
                    System.debug('======srDe======'+srDe);
                    if (srDe.about != null && srDe.about != '')
                        serLabel.put(sr1.sdg__c,srDe);//Serivce Label Set
                    System.debug('======serLabel======'+serLabel);
                }
                srCat.subCatName = g.getLabel();//Service Sub Category
                srCat.grpSerLabel = serLabel.values();
                System.debug('======srCat======'+srCat);
                if (serLabel.values().size()>0)
                    catList.add(srCat);
            }
            sr.grpSubCat = catList;// List of Service Categories
            servOptions.add(sr);
        }
        System.debug('result==='+servOptions);
        return servOptions;
    }
    public void serviceData(){
        System.debug('=======contentId1======='+String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('contentId1')));
        System.debug('=======contentId2======='+String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('contentId2')));
        System.debug('=======contentId3======='+String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('contentId3')));
        Integer sr1 = (Integer.valueOf(String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('contentId1'))))-1;
        Integer sr2 = (Integer.valueOf(String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('contentId2'))))-1;
        Integer sr3 = (Integer.valueOf(String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('contentId3'))))-1;
        if (!test.isRunningTest()){
        ServiceDetail sdSelected = servOptions[sr1].grpSubCat[sr2].grpSerLabel[sr3];
        System.debug('=====sdSelected===='+sdSelected);
        sdDetails = sdSelected;
        }
        isSRSelected = true;
    }

    public Map<String,List<Glossary__c>> loadGlossaryList() {
        glossMap = new Map<String,List<Glossary__c>>();
        isSRSelected = false;

        for ( Glossary__c gl : [Select id, Label__c, Definition__c from Glossary__c]){
            String str = gl.Label__c.left(1);
            if (glossMap.containsKey(str)) {
                List<Glossary__c> gll = glossMap.get(str);
                gll.add(gl);
                glossMap.put(str, gll);
            } else {
                glossMap.put(str, new List<Glossary__c> { gl });
            }
        }
        glosskeyValues = glossMap.keySet();
        //alpha = new map<String,String>();
        alpha = new map<String,String>{'A' => 'inactive disabled','B' => 'inactive disabled','C' => 'inactive disabled','D' => 'inactive disabled','E' => 'inactive disabled','F' => 'inactive disabled','G' => 'inactive disabled','H' => 'inactive disabled',
            'I' => 'inactive disabled','J' => 'inactive disabled','K' => 'inactive disabled','L' => 'inactive disabled','M' => 'inactive disabled','N' => 'inactive disabled','O' => 'inactive disabled','P' => 'inactive disabled','Q' => 'inactive disabled','R' => 'inactive disabled',
            'S' => 'inactive disabled','T' => 'inactive disabled','U' => 'inactive disabled','V' => 'inactive disabled','W' => 'inactive disabled','X' => 'inactive disabled','Y' => 'inactive disabled','Z' => 'inactive disabled'};
                for (String str : glosskeyValues){
                    if (str == 'A')
                        alpha.put(str,'active');
                    else
                        alpha.put(str,'');
                }
        System.debug('glossMap==='+glossMap);
        glossDefaultList = glossMap.get('A');
        glossDetailList = glossDefaultList;
        System.debug('glossDetailList==='+glossDetailList);
        return glossMap;
    }
    public void onGlossClick(){
        string x=String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('contentId1'));
        System.debug('value of x==='+x);
        if (x == '' || x == null){
            glossDetailList = glossDefaultList;
        }
        else{
            glossDetailList = glossMap.get(x);
        }
        System.debug('glossDetailList==='+glossDetailList);
    }

    public void loadFAQList() {
        mainfaqOptions = new List<myFAQsWrapper>();
        FAQHeadVal = new Set<String>();
        //RecordsPerPageslist = 10;
        FAQList  = [Select Id,Details__c,Summary,PublishStatus,Title,Header__c,Sub_Header__c FROM FAQ__kav
                    where ValidationStatus='Validated' and IsVisibleInCsp=true and IsVisibleInPkb=true and IsVisibleInPrm=true
                    and Language='en_US' and PublishStatus='Online' and Header__c != null];
        Map<String,List<FAQ__kav>> mapFAQ = new Map<String,List<FAQ__kav>>();
        for (FAQ__kav faqVal : FAQList){
            String str8;
            if (faqVal.Sub_Header__c == null || faqVal.Sub_Header__c == '')
                str8 = faqVal.Header__c;
            else
                str8 = faqVal.Header__c+faqVal.Sub_Header__c;
            System.debug('====str8====='+str8);
            if (mapFAQ.get(str8)==null){
                mapFAQ.put(str8,new list<FAQ__kav>());
                mapFAQ.get(str8).add(faqVal);
            }
            else
                mapFAQ.get(str8).add(faqVal);
        }
        System.debug('====mapFAQ====='+mapFAQ);
        //ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(FAQList);
        Schema.DescribeFieldResult headGrp = FAQ__kav.Header__c.getDescribe();
        Schema.DescribeFieldResult subHeadGrp = FAQ__kav.Sub_Header__c.getDescribe();
        List<Schema.PicklistEntry> headPicklist = headGrp.getPicklistValues();
        List<Schema.PicklistEntry> subHeadPicklist = subHeadGrp.getPicklistValues();

        for ( Schema.PicklistEntry f : headPicklist){
            myFAQsWrapper sr = new myFAQsWrapper();
            sr.header = f.getLabel();
            FAQHeadVal.add(f.getLabel());
            List<subHeaderDetailWrapper> catList = new List<subHeaderDetailWrapper>();
            System.debug('====header value====='+sr.header);
            for (Schema.PicklistEntry g : subHeadPicklist){
                subHeaderDetailWrapper srCat = new subHeaderDetailWrapper();
                srCat.subHeadName = g.getLabel();//Service Sub Category
                System.debug('====subheader value====='+srCat.subHeadName);
                String str2 = f.getLabel()+g.getLabel();
                System.debug('====str2====='+str2);
                srCat.relQA = mapFAQ.get(str2);
                System.debug('====subheader relQA====='+srCat.relQA);
                if (srCat.relQA !=null && srCat.relQA.size()>0 )
                    catList.add(srCat);
            }
            if (mapFAQ.get(f.getLabel())!=null){
                List<subHeaderDetailWrapper> cat2List = new List<subHeaderDetailWrapper>();
                subHeaderDetailWrapper srCat1 = new subHeaderDetailWrapper();
                srCat1.subHeadName = f.getLabel().toUpperCase();
                srCat1.relQA = mapFAQ.get(f.getLabel());
                catList.add(srCat1);
            }
            if (catList.size()>0)
                sr.subHeaderWrapper = catList;// List of Service Categories
            mainfaqOptions.add(sr);
        }
        System.debug('result==='+mainfaqOptions);
        loadDefaultFAQs();
    }
    public void loadDefaultFAQs() {
        displayFAQOptions = [select Details__c,Summary,PublishStatus,Title,Header__c,Sub_Header__c FROM FAQ__kav
                             where ValidationStatus='Validated' and IsVisibleInCsp=true and IsVisibleInPkb=true and IsVisibleInPrm=true and Language='en_US' and PublishStatus='Online'];
        System.debug('displayFAQOptions==='+mainfaqOptions);
    }

    public void onFAQCatChange(){
        System.debug('=======contentId1======='+String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('contentId1')));
        System.debug('=======contentId2======='+String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('contentId2')));
        Integer sr1 = (Integer.valueOf(String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('contentId1'))))-1;
        Integer sr2 = (Integer.valueOf(String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('contentId2'))))-1;
        displayFAQOptions = mainfaqOptions[sr1].subHeaderWrapper[sr2].relQA;
        System.debug('=====after select displayFAQOptions===='+displayFAQOptions);
    }
    public void searchFAQ(){
        System.debug('=======dataVal1======='+String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('dataVal1')));
        system.debug('====filterVal====='+filterVal);
        String str = String.valueOf(String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('dataVal1')));
        string searcstr = '%'+str+'%';
        if (str.length() >= 3){
            if (filterVal == 'All'){
                displayFAQOptions = [select Details__c,Summary,PublishStatus,Title,Header__c,Sub_Header__c FROM FAQ__kav
                                     where ValidationStatus='Validated' and IsVisibleInCsp=true and IsVisibleInPkb=true and IsVisibleInPrm=true
                                     and Language='en_US' and PublishStatus='Online' and Summary like :searcstr ];
            }
            else{
                displayFAQOptions = [select Details__c,Summary,PublishStatus,Title,Header__c,Sub_Header__c FROM FAQ__kav
                                     where ValidationStatus='Validated' and IsVisibleInCsp=true and IsVisibleInPkb=true and IsVisibleInPrm=true
                                     and Language='en_US' and PublishStatus='Online' and Summary like :searcstr and Header__c =:filterVal];

            }
        }else{
            loadDefaultFAQs();
        }
    }

    public class mySerivceGroupRequest{
        public String grpName{get;set;}
        public List<mySerivceCategory> grpSubCat{get;set;}
    }
    public class mySerivceCategory{
        public String subCatName{get;set;}
        public List<ServiceDetail> grpSerLabel{get;set;}
    }
    public class ServiceDetail{
        public String srno{get;set;}
        public String heading{get;set;}
        public String about{get;set;}
        public List<String> docList{get;set;}
        public List<String> payMethod{get;set;}
        public List<String> processTime{get;set;}
        public List<String> feeStruct{get;set;}
    }
    public class myFAQsWrapper{
        public String header{get;set;}
        public List<subHeaderDetailWrapper> subHeaderWrapper{get;set;}
    }
    public class subHeaderDetailWrapper{
        public String subHeadName{get;set;}
        public List<FAQ__kav> relQA{get;set;}
    }
}