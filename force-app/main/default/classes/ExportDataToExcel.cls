public class ExportDataToExcel {

    public String excelName {get;set;}
    public string newLN {get;set;}
    public List<String> SelectedFields {get; set;}
    public List<String> conStatus = new List<String>{'Draft', 'Active', 'Under Activation', 'Under Deactivation', 'Under Absconder Declaration', 'Under Absconder Withdrawal', 'Absconder Withdrawn'};
    public transient List<wrapper> lstwrapper {get; set;}
    public class wrapper{
        public string val1{get; set;}
        public string val2{get; set;}
        public string val3{get; set;}
        public string val4{get; set;}
        public string val5{get; set;}
        public string val6{get; set;}
        public string val7{get; set;}
        public string val8{get; set;}
        public string val9{get; set;}
        public string val10{get; set;}
        public string val11{get; set;}
        public string val12{get; set;}
        public string val13{get; set;}
        public string val14{get; set;}
        public string val15{get; set;}
        public string val16{get; set;}
        public string val17{get; set;}
        public string val18{get; set;}
        public string val19{get; set;}
        public string val20{get; set;}
    }
    public string header{get;set;}

    public ExportDataToExcel() {
        SelectedFields= new List<String>();
        lstwrapper = new List<wrapper>();
        newLN = '\r\n';
        String accountId = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('AccountId'));
        String filVal = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('filter'));
        String fieVal = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('fieldVal'));
        String ptEmpVal = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('ptEmp'));
        List <String> strList = filVal.split( '-' );
        List<Contact> conList = New List<Contact>();
        List<g_Tran__c> transList = New List<g_Tran__c>();
        system.debug('---fieVal---'+fieVal+'------'+filVal);
        system.debug(ptEmpVal); //fieVal != 'transaction' && fieVal != 'transactions2' && fieVal!='AllData'
        if (ptEmpVal=='ptData' && filVal == 'Part time employees') {
            system.debug('---Inside today');
          header = 'Full Name, Gender, Nationality, University Name , Category, Course name, Email, Mobile, Company name, Location, Position, Allowed working hours per week, status\r\n';
                conList = [Select flnm__c, Gender__c, nc__c, account.name, Program__c, Course_Name__c,
                    Email, HomePhone, pte__r.name, pte__r.Prk__c, ptsta__c, (select id,
                        action__c, xawh__c from requests__r where service_code__c='136' and sta__c='Completed' order by CreatedDate Desc limit 1) From Contact where pte__c =:accountId AND rol__c ='Student' AND STA__c ='Active' LIMIT 9999];
                for (Contact con: conList) {
                    wrapper w = new wrapper();
                    w.val1 = con.flnm__c;
                    w.val2 = Con.Gender__c;
                    w.val3 = con.nc__c;
                    w.val4 = con.account.name;
                    w.val5 = con.Program__c;
                    w.val6 = con.Course_Name__c;
                    w.val7 = con.Email;
                    w.val8 = con.HomePhone;
                    w.val9 = con.pte__r.name;
                    w.val10 = con.pte__r.Prk__c;
                    w.val11 = con.requests__r[0].action__c;
                    w.val12 = string.valueof(con.requests__r[0].xawh__c);
                    w.val13 = con.ptsta__c;
                    //w.val13 = '';
                    lstwrapper.add(w);
                }
                excelName = 'PartTimeEmployeesExtract';
        }
        else if (fieVal != 'transaction' && fieVal != 'transactions2') {
            if (fieVal=='Age__c') {
                header = 'Full Name, Role, Passport Number, Date of Birth, Age\r\n';
                conList = [Select flnm__c, rol__c, p__c, Birthdate, Age__c From Contact where AccountId =:accountId AND rol__c IN:strList AND STA__c IN: conStatus LIMIT 9999];
                for (Contact con: conList) {
                    wrapper w = new wrapper();
                    w.val1 = con.flnm__c;
                    w.val2 = con.rol__c;
                    w.val3 = con.p__c;
                    w.val4 = String.valueOf(con.Birthdate);
                    w.val5 = String.valueOf(con.Age__c);
                    w.val6='';
                    w.val7='';
                    w.val8='';
                    w.val9='';
                    lstwrapper.add(w);
                }
                excelName = 'Age_Range';
            }
            else if (fieVal=='Gender__c') {
                header = 'Full Name, Role, Passport Number, Date of Birth, Gender\r\n';
                conList = [Select flnm__c, rol__c, p__c, Birthdate, Gender__c From Contact where AccountId =:accountId AND rol__c IN:strList AND STA__c IN: conStatus LIMIT 9999];
                for (Contact con: conList) {
                    wrapper w = new wrapper();
                    w.val1 = con.flnm__c;
                    w.val2 = con.rol__c;
                    w.val3 = con.p__c;
                    w.val4 = String.valueOf(con.Birthdate);
                    w.val5 = con.Gender__c;
                    w.val6='';
                    w.val7='';
                    w.val8='';
                    w.val9='';
                    lstwrapper.add(w);
                }
                excelName = 'Gender';
            }
            else if (fieVal=='rol__c') {
                header = 'Full Name, Role, Passport Number, Date of Birth\r\n';
                conList = [Select flnm__c, rol__c, p__c, Birthdate From Contact where AccountId =:accountId AND rol__c IN:strList AND STA__c IN: conStatus LIMIT 9999];
                for (Contact con: conList) {
                    wrapper w = new wrapper();
                    w.val1 = con.flnm__c;
                    w.val2 = con.rol__c;
                    w.val3 = con.p__c;
                    w.val4 = String.valueOf(con.Birthdate);
                    w.val5='';
                    w.val6='';
                    w.val7='';
                    w.val8='';
                    w.val9='';
                    lstwrapper.add(w);
                }
                excelName = 'Role';
            }
            else if (fieVal=='mgs__c') {
                header = 'Full Name, Role, Passport Number, Date of Birth, Basic Salary, Accommodation, Transport Allowance, Other Allowances, Total Salary\r\n';
                conList = [Select flnm__c, rol__c, p__c, Birthdate, mbs__c, ma__c, mta__c, moa__c,
                    mgs__c From Contact where AccountId =:accountId AND rol__c IN:strList AND STA__c IN: conStatus LIMIT 9999];
                for (Contact con: conList) {
                    wrapper w = new wrapper();
                    w.val1 = con.flnm__c;
                    w.val2 = con.rol__c;
                    w.val3 = con.p__c;
                    w.val4 = String.valueOf(con.Birthdate);
                    w.val5 = String.valueOf(con.mbs__c);
                    w.val6 = String.valueOf(con.ma__c);
                    w.val7 = String.valueOf(con.mta__c);
                    w.val8 = String.valueOf(con.moa__c);
                    w.val9 = String.valueOf(con.mgs__c);
                    lstwrapper.add(w);
                }
                excelName = 'Salary_Range';
            }
            else if (fieVal=='nc__c') {
                header = 'Full Name, Role, Passport Number, Date of Birth, Nationality\r\n';
                conList = [Select flnm__c, rol__c, p__c, Birthdate, nc__c From Contact where AccountId =:accountId AND rol__c IN:strList AND STA__c IN: conStatus LIMIT 9999];
                for (Contact con: conList) {
                    wrapper w = new wrapper();
                    w.val1 = con.flnm__c;
                    w.val2 = con.rol__c;
                    w.val3 = con.p__c;
                    w.val4 = String.valueOf(con.Birthdate);
                    w.val5 = con.nc__c;
                    w.val6='';
                    w.val7='';
                    w.val8='';
                    w.val9='';
                    lstwrapper.add(w);
                }
                excelName = 'Countries';
            }
            else if (fieVal=='p__c') {
                header = 'Full Name, Role, Passport Number, Date of Birth, Passport Exipry Date\r\n';
                conList = [Select flnm__c, rol__c, p__c, Birthdate, ped__c From Contact where AccountId =:accountId AND rol__c IN:strList AND STA__c IN: conStatus LIMIT 9999];
                for (Contact con: conList) {
                    wrapper w = new wrapper();
                    w.val1 = con.flnm__c;
                    w.val2 = con.rol__c;
                    w.val3 = con.p__c;
                    w.val4 = String.valueOf(con.Birthdate);
                    w.val5 = String.valueOf(con.ped__c);
                    w.val6='';
                    w.val7='';
                    w.val8='';
                    w.val9='';
                    lstwrapper.add(w);
                }
                excelName = 'Passport';
            }
            else if (fieVal=='rp__c') {
                header = 'Full Name, Role, Passport Number, Date of Birth, Residency Permit Number, Residency Permit Expiry Date, ID CARD NUMBER, ID CARD Expiry Date\r\n';
                conList = [Select flnm__c, rol__c, p__c, Birthdate, rp__c, rped__c,
                    idtxt__c, idedt__c From Contact where AccountId =:accountId AND rol__c IN:strList AND STA__c IN: conStatus LIMIT 9999];
                for (Contact con: conList) {
                    wrapper w = new wrapper();
                    w.val1 = con.flnm__c;
                    w.val2 = con.rol__c;
                    w.val3 = con.p__c;
                    w.val4 = String.valueOf(con.Birthdate);
                    w.val5 = con.rp__c;
                    w.val6 = String.valueOf(con.rped__c);
                    w.val7=con.idtxt__c;
                    w.val8=String.valueOf(con.idedt__c);
                    w.val9='';
                    lstwrapper.add(w);
                }
                excelName = 'Resident_Visa';
            }
            else if (fieVal=='AllData') {
                header = 'Full Name, Role, Passport Number, Passport Exipry Date, Date of Birth, Age, Gender, Basic Salary, Accommodation, Transport Allowance, Other Allowances, Total Salary, Nationality, Residency Permit Number, Residency Permit Expiry Date, ID CARD NUMBER, ID CARD Expiry Date, Mobile Number, Job Title, Status\r\n';
                conList = [Select flnm__c, Course_Name__c, rol__c, p__c, ped__c, Birthdate, MobilePhone,
                    Job_Title_Formula__c, STA__c, Age__c, Gender__c, mbs__c, ma__c, mta__c, moa__c, mgs__c,
                    nc__c, rp__c, rped__c, idtxt__c, idedt__c From Contact where AccountId =:accountId AND rol__c IN:strList AND STA__c IN: conStatus LIMIT 9999];
                for (Contact con: conList) {
                    wrapper w = new wrapper();
                    w.val1 = con.flnm__c;
                    w.val2 = con.rol__c;
                    w.val3 = con.p__c;
                    w.val4 = String.valueOf(con.ped__c);
                    w.val5 = String.valueOf(con.Birthdate);
                    w.val6 = String.valueOf(con.Age__c);
                    w.val7 = con.Gender__c;
                    w.val8 = String.valueOf(con.mbs__c);
                    w.val9 = String.valueOf(con.ma__c);
                    w.val10 = String.valueOf(con.mta__c);
                    w.val11 = String.valueOf(con.moa__c);
                    w.val12 = String.valueOf(con.mgs__c);
                    w.val13 = String.valueOf(con.nc__c);
                    w.val14 = String.valueOf(con.rp__c);
                    w.val15 = String.valueOf(con.rped__c);
                    w.val16 = String.valueOf(con.idtxt__c);
                    w.val17 = String.valueOf(con.idedt__c);
                    w.val18 = con.MobilePhone;
                    w.val19 = con.Job_Title_Formula__c;
                    w.val20 = con.STA__c;
                    lstwrapper.add(w);
                }
                excelName = 'AllDataExtract';
            }

            else{
                header = 'Full Name, Role, Passport Number, Date of Birth\r\n';
                conList = [Select flnm__c, rol__c, p__c, Birthdate From Contact where AccountId =:accountId AND rol__c IN:strList AND STA__c IN: conStatus LIMIT 9999];
                for (Contact con: conList) {
                    wrapper w = new wrapper();
                    w.val1 = con.flnm__c;
                    w.val2 = con.rol__c;
                    w.val3 = con.p__c;
                    w.val4 = String.valueOf(con.Birthdate);
                    w.val5='';
                    w.val6='';
                    w.val7='';
                    w.val8='';
                    w.val9='';
                    lstwrapper.add(w);
                }
                excelName = 'DataExtract';
            }
        }
        else if (fieVal == 'transactions2') {
            header = 'REFERENCE NUMBER, SERVICE NAME, SR NUMBER, PAYMENT TYPE, PAYMENT METHOD, APPLICANT NAME, PAYMENT INITIATED, PAYMENT PROCESSED, AMOUNT (AED), STATUS\r\n';
            String strtDt = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('startDate'));
            Date stdt = Date.valueOf(Date.parse(strtDt));
            System.debug('An=====stdt===='+stdt);
            String endDt = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('endDate'));
            Date endt = Date.valueOf(Date.parse(endDt));
            System.debug('An=====endt===='+endt);
            String addFilVal = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('addFilter'));
            List <String> addFliLst = addFilVal.split( '-' );
            transList = [Select Id, Name, RQ__r.srvc__r.Name, RQ__r.Name, RQ__r.Con__r.p__c, md__c, RQ__r.Con__r.Name, CreatedDate, A__c, STA__c, TP__c, dt__c from g_Tran__c
                         where Acc__c =: AccountId AND dt__c >=: stdt AND dt__c <=: endt AND TP__c !='Claim' LIMIT 9999];
            for (g_Tran__c t: transList) {
                wrapper w = new wrapper();
                w.val1 = t.Name;
                w.val2 = t.RQ__r.srvc__r.Name;
                w.val3 = t.RQ__r.Name;
                w.val4 = t.TP__c;
                w.val5 = t.md__c;
                w.val6 = t.RQ__r.Con__r.Name;
                w.val7 = String.valueOf(t.CreatedDate);
                w.val8 = String.valueOf(t.dt__c);
                w.val9 = String.valueOf(t.A__c);
                w.val10 = t.STA__c;
                lstwrapper.add(w);
            }
            excelName = 'TransactionDataExtract';
        }
        else{
            header = 'REFERENCENUMBER, SERVICE NAME, SR NUMBER, PAYMENT TYPE, PAYMENT METHOD, APPLICANT NAME, PAYMENT INITIATED, PAYMENT PROCESSED, AMOUNT (AED), STATUS\r\n';
            String strtDt1 = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('startDate'));
            Date stdt1= Date.valueOf(Date.parse(strtDt1));
            System.debug('An=====stdt1===='+stdt1);
            String endDt1 = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('endDate'));
            Date endt1 = Date.valueOf(Date.parse(endDt1));
            System.debug('An=====endt1===='+endt1);
            transList = [Select Id, Name, RQ__r.srvc__r.Name, RQ__r.Name, RQ__r.Con__r.p__c, md__c, RQ__r.Con__r.Name, CreatedDate, A__c, STA__c, TP__c, dt__c from g_Tran__c
                         where Acc__c =: AccountId AND dt__c >=: stdt1 AND dt__c <=: endt1 AND TP__c !='Claim' LIMIT 9999];
            for (g_Tran__c t: transList) {
                wrapper w = new wrapper();
                w.val1 = t.Name;
                w.val2 = t.RQ__r.srvc__r.Name;
                w.val3 = t.RQ__r.Name;
                w.val4 = t.TP__c;
                w.val5 = t.md__c;
                w.val6 = t.RQ__r.Con__r.Name;
                w.val7 = String.valueOf(t.CreatedDate);
                w.val8 = String.valueOf(t.dt__c);
                w.val9 = String.valueOf(t.A__c);
                w.val10 = t.STA__c;
                lstwrapper.add(w);
            }
            excelName = 'TransactionDataExtract';
        }

    }

}