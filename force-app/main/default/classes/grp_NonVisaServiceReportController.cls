public class grp_NonVisaServiceReportController {

    public transient pageData ChartData {get;set;}
    public String exportAllSelVal{get;set;}
    public String ageSelectedValue{get;set;}
    public String genderSelectedValue{get;set;}
    public String salarySelectedValue{get;set;}
    public String passSelectedValue{get;set;}
    public String rpSelectedValue{get;set;}
    public String countrySelectedValue{get;set;}
    public String transSelectedValue{get;set;}
    public String payMetSelectedValue{get;set;}
    public String paySelectedValue {get;set;}
    public String paySelectedValue2 {get;set;}
    public String TypeSelectedValue{get;set;}
    public Id AccountId {get;set;}
    public transient  List<Contact> contactList {get;set;}
    public String fieldVal{get;set;}
    public string ptEmp{get;set;}
    public String filterVal{get;set;}
    public String addfilterVal{get;set;}
    public integer PageSize {get;set;}
    public integer PageNumber {get;set;}
    public integer RecordCount {get;set;}
    public Boolean metChange {get;set;}
    public Boolean nxt1Yr {get;set;}
    public Boolean lstMonth {get;set;}
    public Boolean lst3Month {get;set;}
    public Boolean lst6Month {get;set;}
    public Boolean lst12Month {get;set;}
    public Boolean payType {get;set;}
    public Boolean hidTab {get;set;}
    public Boolean showIdCardData {get;set;}
    public Boolean showStudentThings {get;set;}
    public String dateVal1 {get;set;}
    public String dateVal2 {get;set;}
    public String dateVal3 {get;set;}
    public String dateVal4 {get;set;}
    public Integer TotalEmployeeCount {get;set;}
    public Integer TotalStudentCount {get;set;}
    public Integer EmployeeCount {get;set;}
    public Integer nonSponCount {get;set;}
    public Integer nationCount {get;set;}
    public List<String> conStatus = new List<String>{'Draft', 'Active', 'Under Activation', 'Under Deactivation', 'Under Absconder Declaration', 'Under Absconder Withdrawal', 'Absconder Withdrawn'};
        public Id approverProfile = [Select Id From Profile Where Name='X' LIMIT 1].Id;

    public List<SelectOption> getAllvalues() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Employee', 'Employees'));
        options.add(new SelectOption('Non Sponsored', 'Non Sponsored'));
        options.add(new SelectOption('Student', 'Student'));
        options.add(new SelectOption('Spouse', 'Spouse'));
        options.add(new SelectOption('Child', 'Child'));
        options.add(new SelectOption('Part time employees', 'Part time employees'));
        return options;
    }
    public List<SelectOption> getSalDropValues() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Employee', 'Employee'));
        options.add(new SelectOption('Non Sponsored', 'Non Sponsored'));
        return options;
    }
    public List<SelectOption> getEmpTypeDropValues() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Employee-Non Sponsored-Student-Spouse-Child', 'All People'));
        options.add(new SelectOption('Employee-Non Sponsored', 'All Employee'));
        options.add(new SelectOption('Spouse-Child', 'All Dependents'));
        return options;
    }
    public List<SelectOption> getpayDropValues() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Payment-Refund', 'All'));
        options.add(new SelectOption('Payment', 'Payments'));
        options.add(new SelectOption('Refund', 'Refunds'));
        return options;
    }
    public List<SelectOption> getPayMethodDropValues() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Cash-Credit / Debit Card-Wire Transfer-Customer Deposit', 'All Payment Methods'));
        options.add(new SelectOption('Cash', 'Cash'));
        options.add(new SelectOption('Credit / Debit Card', 'Credit / Debit Card'));
        options.add(new SelectOption('Wire Transfer', 'Bank transfer'));
        options.add(new SelectOption('Customer Deposit', 'Portal deposit'));
        return options;
    }

    public grp_NonVisaServiceReportController() {
        ChartData = prepareData();
    }

    private pageData prepareData() {

        try{
            exportAllSelVal = 'Employee';
            ageSelectedValue = 'Employee';
            genderSelectedValue = 'Employee';
            salarySelectedValue = 'Employee';
            passSelectedValue = 'Employee';
            rpSelectedValue = 'Employee';
            transSelectedValue = 'Employee';
            payMetSelectedValue = 'Cash-Credit / Debit Card-Wire Transfer-Customer Deposit';
            paySelectedValue = 'Payment-Refund';
            paySelectedValue2 = 'Payment-Refund';
            PageSize = 10;
            PageNumber = 1;
            metChange = false;
            nxt1Yr = false;
            lstMonth = false;
            lst3Month = false;
            lst6Month = false;
            lst12Month = false;
            payType=false;
            String usId = String.escapeSingleQuotes(ApexPages.currentPage().getParameters().get('usId'));
            usId  = String.isNotBlank(usId) ? usId : UserInfo.getUserId();
            User us = [Select Id, Contact.AccountId, ProfileId from User where id =: usId limit 1];
            if (us.ProfileId == approverProfile)
                hidTab = true;
            else
                hidTab = false;
            AccountId = us.Contact.AccountId;
            dateVal1 =  date.today().addYears(-1).format();
            dateVal2 = date.today().format();
            dateVal3 =  date.today().addYears(-1).format();
            dateVal4 = date.today().format();
            contactList = [Select Id, Name, Birthdate, Gender__c, rol__c, bc__c, mgs__c, agp__c,
                           Age__c, rp__c, rped__c, ped__c, p__c, ptsta__c from Contact where AccountId =: us.Contact.AccountId AND STA__c IN: conStatus];
            RecordCount = [Select Count() from g_Tran__c where Acc__c =: AccountId AND CreatedDate = THIS_FISCAL_YEAR AND TP__c != 'Claim'];
            Date DaysFromNow = Date.Today().addDays(30);
            AggregateResult aggregate = [Select AVG(Age__c) avgAge, MIN(Age__c) minAge, MAX(Age__c) maxAge from contact
                                         where AccountId =: us.Contact.AccountId AND STA__c IN: conStatus AND (rol__c ='Employee' OR rol__c ='Non Sponsored')];
            AggregateResult aggregateSal = [Select AVG(mgs__c) avgSal, MIN(mgs__c) minSal, MAX(mgs__c) maxSal from contact
                                            where AccountId =: us.Contact.AccountId AND STA__c IN: conStatus AND rol__c='Employee'];
            Integer passExpToday = [Select COUNT() from contact
                                    where AccountId =: us.Contact.AccountId AND ped__c = TODAY AND STA__c IN: conStatus AND (rol__c ='Employee' OR rol__c ='Non Sponsored')];
            Integer passExpNxt30Day = [Select COUNT() from contact
                                       where AccountId =: us.Contact.AccountId AND ped__c >= TODAY AND ped__c <=: DaysFromNow AND STA__c IN: conStatus AND (rol__c ='Employee' OR rol__c ='Non Sponsored')];
            Integer passExpthisYear = [Select COUNT() from contact
                                       where AccountId =: us.Contact.AccountId AND ped__c = THIS_FISCAL_YEAR AND STA__c IN: conStatus AND (rol__c ='Employee' OR rol__c ='Non Sponsored')];
            Integer rpExpToday = [Select COUNT() from contact
                                  where AccountId =: us.Contact.AccountId AND rped__c = TODAY AND STA__c IN: conStatus AND (rol__c ='Employee' OR rol__c ='Non Sponsored')];
            Integer rpExpNxt30Day = [Select COUNT() from contact
                                     where AccountId =: us.Contact.AccountId AND rped__c >= TODAY AND rped__c <=: DaysFromNow AND STA__c IN: conStatus AND (rol__c ='Employee' OR rol__c ='Non Sponsored')];
            Integer rpExpthisYear = [Select COUNT() from contact
                                     where AccountId =: us.Contact.AccountId AND rped__c = THIS_FISCAL_YEAR AND STA__c IN: conStatus];
            TotalEmployeeCount = Integer.valueOf([Select vctemp__c from Account where Id =: us.Contact.AccountId].vctemp__c);
            TotalStudentCount = Integer.valueOf([Select vctst__c from Account where Id =: us.Contact.AccountId].vctst__c);
            if (TotalStudentCount == 0) {
                showStudentThings = false;
            }
            else
                showStudentThings = true;
            nonSponCount = [Select COUNT() from contact where AccountId =: us.Contact.AccountId AND rol__c ='Non Sponsored'AND STA__c IN: conStatus];
            Decimal averageAge = (Decimal)aggregate.get('avgAge');
            Decimal minimumAge = (Decimal)aggregate.get('minAge');
            Decimal maximumAge = (Decimal)aggregate.get('maxAge');
            Decimal averageSal = (Decimal)aggregateSal.get('avgSal');
            Decimal minimumSal = (Decimal)aggregateSal.get('minSal');
            Decimal maximumSal = (Decimal)aggregateSal.get('maxSal');
            List<String> strLst = new List<String>();
            strLst.add('Employee');

            List<String> str1Lst = new List<String>();
            str1Lst.add('Employee');
            str1Lst.add('Non Sponsored');
            str1Lst.add('Student');
            str1Lst.add('Spouse');
            str1Lst.add('Child');
            str1Lst.add('Part time employees');

            List<String> str2Lst = new List<String>();
            str2Lst.add('Employee');
            str2Lst.add('Non Sponsored');
            sectionData sdAgeData = new sectionData();
            sdAgeData.totalAvg = Integer.valueOf(averageAge);
            sdAgeData.largestNumber = Integer.valueOf(maximumAge);
            sdAgeData.smallestNumber = Integer.valueOf(minimumAge);
            sdAgeData.grData = getNumericData('Age__c', contactList, strLst);

            sectionData sdSalData = new sectionData();
            sdSalData.totalAvg = Integer.valueOf(averageSal);
            sdSalData.largestNumber = Integer.valueOf(maximumSal);
            sdSalData.smallestNumber = Integer.valueOf(minimumSal);
            sdSalData.grData = getNumericData('mgs__c', contactList, strLst);

            sectionData sdGenderData = new sectionData();
            sdGenderData.BarGrData = genderData(contactList, strLst);

            sectionData sdEmpTypeData = new sectionData();
            sdEmpTypeData.BarGrData = employeeTypeData(str1Lst);

            sectionData sdPassData = new sectionData();
            sdPassData.totalAvg = passExpToday;
            sdPassData.largestNumber = passExpNxt30Day;
            sdPassData.smallestNumber = passExpthisYear;
            sdPassData.BarGrData = passportData(AccountId, strLst);

            sectionData sdrpData = new sectionData();
            sdrpData.totalAvg = rpExpToday;
            sdrpData.largestNumber = rpExpNxt30Day;
            sdrpData.smallestNumber = rpExpthisYear;
            sdrpData.BarGrData = rpData(AccountId, strLst);

            sectionData sdTransData = new sectionData();
            sdTransData.transData = transactionData(us.Contact.AccountId);

            sectionData sdCounData = new sectionData();
            sdCounData.grData = gettingCountryData(strLst);
            nationCount = sdCounData.grData.size();

            pageData pg = new pageData();
            pg.ageRangeData = sdAgeData;
            pg.genderData = sdGenderData;
            pg.employeeTypeData = sdEmpTypeData;
            pg.salaryRangeData = sdSalData;
            pg.passportData = sdPassData;
            pg.rpData = sdrpData;
            pg.transData = sdTransData;
            pg.countryData = sdCounData;

            return pg;
        }catch (Exception e) {
            system.debug('ex::' + e.getStackTraceString());
            gU.AddErrorMsg(e);
            return null;
        }
    }

    public List<GraphData> getNumericData(String fld, List<Contact> lstContact, List<String> filterVal) {
        integer lessthat10K=0, bwt2030=0, bwt3040=0, bwt4050=0, morethen50K=0;
        List<GraphData> gpData = new List<GraphData>();
        Integer Total = 0;
        try{
            for (Contact con : lstContact) {
                if (filterVal.contains(con.rol__c)) {
                    Total=Total+1;
                    if (fld == 'Age__c') {
                        if (con.Age__c != null && con.Age__c != 0) {
                            String str = String.ValueOf(Integer.valueOf(con.Age__c));
                            Integer first2Digits = Integer.valueOf(str.length()<2? str.substring(0, 1):str.substring(0, 2));
                            if (first2Digits<20)
                                lessthat10K = lessthat10K+1;
                            else if (first2Digits >= 20 && first2Digits<30)
                                bwt2030 = bwt2030+1;
                            else if (first2Digits >= 30 && first2Digits<40)
                                bwt3040 = bwt3040+1;
                            else if (first2Digits >= 40 && first2Digits<50)
                                bwt4050 = bwt4050+1;
                            else
                                morethen50K = morethen50K+1;
                        }
                    }
                    if (fld == 'mgs__c') {
                        if (con.mgs__c != null && con.mgs__c != 0) {
                            String str1 = String.ValueOf(Integer.valueOf(con.mgs__c));
                            Integer first2Digits1 = Integer.valueOf(str1.length()<2? str1.substring(0, 1):str1.substring(0, 2));
                            if (first2Digits1<20)
                                lessthat10K = lessthat10K+1;
                            else if (first2Digits1 >= 20 && first2Digits1<30)
                                bwt2030 = bwt2030+1;
                            else if (first2Digits1 >= 30 && first2Digits1<40)
                                bwt3040 = bwt3040+1;
                            else if (first2Digits1 >= 40 && first2Digits1<50)
                                bwt4050 = bwt4050+1;
                            else
                                morethen50K = morethen50K+1;
                        }
                    }
                }
            }
            if (Total == 0) {Total=1;}
            Decimal percent20 = lessthat10K*100/Total;
            Decimal percent2030 = bwt2030*100/Total;
            Decimal percent3040 = bwt3040*100/Total;
            Decimal percent4050 = bwt4050*100/Total;
            Decimal percent50 = morethen50K*100/Total;
            if (fld == 'mgs__c') {
                GraphData gd1 = new GraphData(lessthat10K, '< 20, 000', percent20);
                gpData.add(gd1);
                GraphData gd2 = new GraphData(bwt2030, '20, 000 - 30, 000', percent2030);
                gpData.add(gd2);
                GraphData gd3 = new GraphData(bwt3040, '30, 000 - 40, 000', percent3040);
                gpData.add(gd3);
                GraphData gd4 = new GraphData(bwt4050, '40, 000 - 50, 000', percent4050);
                gpData.add(gd4);
                GraphData gd5 = new GraphData(morethen50K, '> 50, 000', percent50);
                gpData.add(gd5);
            }
            if (fld == 'Age__c') {
                GraphData gd1 = new GraphData(lessthat10K, '<20', percent20);
                gpData.add(gd1);
                GraphData gd2 = new GraphData(bwt2030, '20-30', percent2030);
                gpData.add(gd2);
                GraphData gd3 = new GraphData(bwt3040, '30-40', percent3040);
                gpData.add(gd3);
                GraphData gd4 = new GraphData(bwt4050, '40-50', percent4050);
                gpData.add(gd4);
                GraphData gd5 = new GraphData(morethen50K, '>50', percent50);
                gpData.add(gd5);
            }
            return gpData;
        }catch (Exception e) {
            system.debug('ex::' + e.getStackTraceString());
            gU.AddErrorMsg(e);
            return null;
        }

    }

    public List<BarGraphData> genderData(List<Contact> lstContact, List<String> filterVal) {
        integer maleCount=0, femaleCount=0, otherCount=0;
        List<BarGraphData> gpData = new List<BarGraphData>();
        try{
            for (Contact con : lstContact) {
                if (filterVal.contains(con.rol__c)) {
                    if (con.Gender__c == 'Female')
                        femaleCount = femaleCount +1;
                    else if (con.Gender__c == 'Male')
                        maleCount = maleCount +1;
                    else
                        otherCount = otherCount +1;
                }
            }
            BarGraphData gd1 = new BarGraphData(maleCount, 'Male');
            gpData.add(gd1);
            BarGraphData gd2 = new BarGraphData(femaleCount, 'Female');
            gpData.add(gd2);
            system.debug('======##182'+gpData);
            return gpData;
        }catch (Exception e) {
            system.debug('ex::' + e.getStackTraceString());
            gU.AddErrorMsg(e);
            return null;
        }
    }

    public List<BarGraphData> employeeTypeData(List<String> filterVal) {

        List<BarGraphData> gpData = new List<BarGraphData>();
        List<AggregateResult> conLst = [SELECT COUNT(Id) personCount, rol__c FROM contact where AccountId =: AccountId AND rol__c IN: filterVal  AND STA__c IN: conStatus
                                        GROUP BY rol__c];
        system.debug('conLis===='+conLst);
        try{
            for (AggregateResult agg : conLst) {
                BarGraphData gd1 = new BarGraphData((Integer)agg.get('personCount'), (String)agg.get('rol__c'));
                gpData.add(gd1);
            }

            return gpData;
        }catch (Exception e) {
            system.debug('ex::' + e.getStackTraceString());
            gU.AddErrorMsg(e);
            return null;
        }
    }

    public List<GraphData> gettingCountryData(List<String> filterVal) {
        List<GraphData> gpData = new List<GraphData>();
        try{
            AggregateResult total = [Select Count(Id) tt from contact where AccountId =: AccountId AND rol__c IN: filterVal];
            List<AggregateResult> conLst = [SELECT COUNT(Id) personCount, nc__c FROM contact where AccountId =: AccountId AND rol__c IN: filterVal AND STA__c IN: conStatus
                                            GROUP BY nc__c ORDER BY COUNT(Id) DESC];
            system.debug('conLis===='+conLst);
            for (AggregateResult agg : conLst) {
                Decimal dec = ((Integer)agg.get('personCount'))*100/((Integer)total.get('tt'));
                GraphData gd1 = new GraphData((Integer)agg.get('personCount'), (String)agg.get('nc__c'), dec);
                gpData.add(gd1);
            }
            return gpData;
        }catch (Exception e) {
            system.debug('ex::' + e.getStackTraceString());
            gU.AddErrorMsg(e);
            return null;
        }
    }

    public List<BarGraphData> passportData(Id accID , List<String> filterVal) {
        List<BarGraphData> gpData = new List<BarGraphData>();
        try{
            Date tdy = Date.Today();
            Date nxt1yrdate = Date.Today().addYears(1);
            map<String, integer> monthCount = new map<String, integer>();
            List<Contact> conLis = [SELECT Id, ped__c FROM Contact WHERE AccountId =: AccountId AND ped__c >= Today AND ped__c <=: nxt1yrdate AND rol__c IN: filterVal AND STA__c IN: conStatus];
            do {
                string s1=string.valueof(tdy.year()).right(2);
                String str;
                if (tdy.month() == 1)
                    str = 'JAN-'+s1;
                else if (tdy.month() == 2)
                    str = 'FEB-'+s1;
                else if (tdy.month() == 3)
                    str = 'MAR-'+s1;
                else if (tdy.month() == 4)
                    str = 'APR-'+s1;
                else if (tdy.month() == 5)
                    str = 'MAY-'+s1;
                else if (tdy.month() == 6)
                    str = 'JUN-'+s1;
                else if (tdy.month() == 7)
                    str = 'JUL-'+s1;
                else if (tdy.month() == 8)
                    str = 'AUG-'+s1;
                else if (tdy.month() == 9)
                    str = 'SEP-'+s1;
                else if (tdy.month() == 10)
                    str = 'OCT-'+s1;
                else if (tdy.month() == 11)
                    str = 'NOV-'+s1;
                else if (tdy.month() == 12)
                    str = 'DEC-'+s1;
                monthCount.put(str, 0);
                tdy = tdy.addMonths(1);
            } while (tdy <= nxt1yrdate);

            integer jan=0, feb=0, mar=0, april=0, may=0, june=0, july=0, aug=0, sep=0, oct=0, nov=0, dec=0;
            for (Contact con: conLis) {
                string s1=string.valueof(con.ped__c.year()).right(2);
                String str;
                switch on con.ped__c.Month() {
                    when 1{
                        str = 'JAN-'+s1;
                    }
                    when 2{
                        str ='FEB-'+s1;
                    }
                    when 3{
                        str ='MAR-'+s1;
                    }
                    when 4{
                        str ='APR-'+s1;
                    }
                    when 5{
                        str ='MAY-'+s1;
                    }
                    when 6{
                        str ='JUN-'+s1;
                    }
                    when 7{
                        str ='JUL-'+s1;
                    }
                    when 8{
                        str ='AUG-'+s1;
                    }
                    when 9{
                        str ='SEP-'+s1;
                    }
                    when 10{
                        str ='OCT-'+s1;
                    }
                    when 11{
                        str ='NOV-'+s1;
                    }
                    when 12{
                        str ='DEC-'+s1;
                    }
                }
                if (!monthCount.containsKey(str)) {
                    monthCount.put(str, 0);
                }
                Integer currentInt=monthCount.get(str)+1;
                monthCount.put(str, currentInt);
            }
            for (String key : monthCount.keySet()) {
                integer cntr = monthCount.get(key);
                BarGraphData gd = new BarGraphData(cntr, key);
                gpData.add(gd);
            }
            System.debug('gpData -- '+gpData);
            return gpData;
        }catch (Exception e) {
            system.debug('ex::' + e.getStackTraceString());
            gU.AddErrorMsg(e);
            return null;
        }

    }

    public List<BarGraphData> rpData(Id accID, List<String> filterVal) {
        List<BarGraphData> gpData = new List<BarGraphData>();
        List<Contact> conLis = new List<Contact>();
        try{
            Date tdy = Date.Today();
            Boolean isNonSponEmp = false;
            showIdCardData = false;
            Date nxt1yrdate = Date.Today().addYears(1);
            map<String, integer> monthCount = new map<String, integer>();
            if (filterVal.contains('Non Sponsored')) {
                conLis = [SELECT Id, idtxt__c, idedt__c FROM Contact WHERE AccountId =: accID AND idedt__c >= Today AND idedt__c <=: nxt1yrdate AND rol__c IN: filterVal AND STA__c IN: conStatus];
                isNonSponEmp = true;
                showIdCardData = true;
            }
            else{
                conLis = [SELECT Id, rp__c, rped__c FROM Contact WHERE AccountId =: accID AND rped__c >= Today AND rped__c <=: nxt1yrdate AND rol__c IN: filterVal AND STA__c IN: conStatus];
                isNonSponEmp = false;
                showIdCardData = false;
            }
            System.debug('====ID CARD CHANGES: conLis====='+conLis);
            System.debug('====ID CARD CHANGES: isNonSponEmp====='+isNonSponEmp);
            System.debug('====ID CARD CHANGES: showIdCardData====='+showIdCardData);
            do {
                string s1= string.valueof(tdy.year()).right(2);
                String str;
                if (tdy.month() == 1) str = 'JAN-'+s1;
                else if (tdy.month() == 2) str = 'FEB-'+s1;
                else if (tdy.month() == 3) str = 'MAR-'+s1;
                else if (tdy.month() == 4) str = 'APR-'+s1;
                else if (tdy.month() == 5) str = 'MAY-'+s1;
                else if (tdy.month() == 6) str = 'JUN-'+s1;
                else if (tdy.month() == 7) str = 'JUL-'+s1;
                else if (tdy.month() == 8) str = 'AUG-'+s1;
                else if (tdy.month() == 9) str = 'SEP-'+s1;
                else if (tdy.month() == 10) str = 'OCT-'+s1;
                else if (tdy.month() == 11) str = 'NOV-'+s1;
                else if (tdy.month() == 12) str = 'DEC-'+s1;
                monthCount.put(str, 0);
                tdy = tdy.addMonths(1);
            } while (tdy <= nxt1yrdate);
            integer jan=0, feb=0, mar=0, april=0, may=0, june=0, july=0, aug=0, sep=0, oct=0, nov=0, dec=0;
            for (Contact con: conLis) {
                string s1= isNonSponEmp ? string.valueof(con.idedt__c.year()).right(2) : string.valueof(con.rped__c.year()).right(2);
                String str;
                Integer monthInt = isNonSponEmp ? con.idedt__c.Month() : con.rped__c.Month();
                switch on monthInt{
                    when 1{
                        str = 'JAN-'+s1;
                    }
                    when 2{
                        str ='FEB-'+s1;
                    }
                    when 3{
                        str ='MAR-'+s1;
                    }
                    when 4{
                        str ='APR-'+s1;
                    }
                    when 5{
                        str ='MAY-'+s1;
                    }
                    when 6{
                        str ='JUN-'+s1;
                    }
                    when 7{
                        str ='JUL-'+s1;
                    }
                    when 8{
                        str ='AUG-'+s1;
                    }
                    when 9{
                        str ='SEP-'+s1;
                    }
                    when 10{
                        str ='OCT-'+s1;
                    }
                    when 11{
                        str ='NOV-'+s1;
                    }
                    when 12{
                        str ='DEC-'+s1;
                    }
                }
                if (!monthCount.containsKey(str)) {
                    monthCount.put(str, 0);
                }
                Integer currentInt=monthCount.get(str)+1;
                monthCount.put(str, currentInt);
            }
            for (String key : monthCount.keySet()) {
                integer cntr = monthCount.get(key);
                BarGraphData gd = new BarGraphData(cntr, key);
                gpData.add(gd);
            }
            System.debug(gpData);
            return gpData;
        }catch (Exception e) {
            system.debug('ex::' + e.getStackTraceString());
            gU.AddErrorMsg(e);
            return null;
        }

    }

    public List<TransactionDataWrap> transactionData(Id accID) {

        return null;

    }
    public integer PageIndex {get { return (PageNumber - 1); }}
    public integer PageCount {get { return getPageCount(); } }
    public integer Offset {get { return (PageSize * PageIndex); }}
    public g_Tran__c[] gettransDa() {
        try {
            g_Tran__c[] objAccList;
            Date nxt1yrdate = Date.Today().addYears(1);
            Date lstmnthDate = Date.Today().addMonths(-1);
            Date lst3mnthDate = Date.Today().addMonths(-3);
            Date lst6mnthDate = Date.Today().addMonths(-3);
            Date lst12mnthDate = Date.Today().addYears(-1);
            if (metChange == false && nxt1Yr == false && lstMonth == false && lst3Month == false && lst6Month == false && lst12Month == false && payType == false) objAccList = [Select Id,
                Name, RQ__r.srvc__r.Name, RQ__r.Name, RQ__r.Con__r.p__c, md__c, RQ__r.Con__r.Name,
                CreatedDate, A__c, STA__c, TP__c, dt__c from g_Tran__c where Acc__c =: AccountId AND dt__c >=: lst12mnthDate AND dt__c <= Today AND TP__c != 'Claim' Limit: PageSize offset: Offset];
            else if (payType) {
                if (paySelectedValue2 == 'Payment-Refund') objAccList = [Select Id, Name, RQ__r.srvc__r.Name,
                    RQ__r.Name, RQ__r.Con__r.p__c, md__c, RQ__r.Con__r.Name, CreatedDate, A__c, STA__c,
                    TP__c, dt__c from g_Tran__c where Acc__c =: AccountId AND dt__c >=: lst12mnthDate AND dt__c <= Today AND TP__c != 'Claim' Limit: PageSize offset: Offset];
                else objAccList = [Select Id, Name, RQ__r.srvc__r.Name, RQ__r.Name, RQ__r.Con__r.p__c,
                    md__c, RQ__r.Con__r.Name, CreatedDate, A__c,
                        STA__c, TP__c, dt__c from g_Tran__c where Acc__c =: AccountId AND dt__c >=: lst12mnthDate AND dt__c <= Today AND TP__c =: paySelectedValue2 Limit: PageSize offset: Offset];
            }
            else if (metChange) objAccList = [Select Id, Name, RQ__r.srvc__r.Name, RQ__r.Name,
                RQ__r.Con__r.p__c, md__c, RQ__r.Con__r.Name, CreatedDate, A__c,
                    STA__c, TP__c, dt__c from g_Tran__c where Acc__c =: AccountId AND dt__c >=: lst12mnthDate AND dt__c <= Today AND TP__c != 'Claim' AND md__c =: payMetSelectedValue Limit: PageSize offset: Offset];
            else if (nxt1Yr) objAccList = [Select Id, Name, RQ__r.srvc__r.Name, RQ__r.Name, RQ__r.Con__r.p__c,
                md__c, RQ__r.Con__r.Name, CreatedDate, A__c,
                    STA__c, TP__c, dt__c from g_Tran__c where Acc__c =: AccountId AND dt__c >= Today AND dt__c <=: nxt1yrdate AND TP__c != 'Claim' Limit: PageSize offset: Offset];
            else if (lstMonth) objAccList = [Select Id, Name, RQ__r.srvc__r.Name, RQ__r.Name,
                RQ__r.Con__r.p__c, md__c, RQ__r.Con__r.Name, CreatedDate, A__c,
                    STA__c, TP__c, dt__c from g_Tran__c where Acc__c =: AccountId AND dt__c >=: lstmnthDate AND dt__c <= Today AND TP__c != 'Claim' Limit: PageSize offset: Offset];
            else if (lst3Month) objAccList = [Select Id, Name, RQ__r.srvc__r.Name, RQ__r.Name,
                RQ__r.Con__r.p__c, md__c, RQ__r.Con__r.Name, CreatedDate, A__c,
                    STA__c, TP__c, dt__c from g_Tran__c where Acc__c =: AccountId AND dt__c >=: lst3mnthDate AND dt__c <= Today AND TP__c != 'Claim' Limit: PageSize offset: Offset];
            else if (lst6Month) objAccList = [Select Id, Name, RQ__r.srvc__r.Name, RQ__r.Name,
                RQ__r.Con__r.p__c, md__c, RQ__r.Con__r.Name, CreatedDate, A__c,
                    STA__c, TP__c, dt__c from g_Tran__c where Acc__c =: AccountId AND dt__c >=: lst6mnthDate AND dt__c <= Today AND TP__c != 'Claim' Limit: PageSize offset: Offset];
            else if (lst12Month) objAccList = [Select Id, Name, RQ__r.srvc__r.Name, RQ__r.Name,
                RQ__r.Con__r.p__c, md__c, RQ__r.Con__r.Name, CreatedDate, A__c,
                    STA__c, TP__c, dt__c from g_Tran__c where Acc__c =: AccountId AND dt__c >=: lst12mnthDate AND dt__c <= Today AND TP__c != 'Claim' Limit: PageSize offset: Offset];
            else objAccList = [Select Id, Name, RQ__r.srvc__r.Name, RQ__r.Name, RQ__r.Con__r.p__c,
                md__c, RQ__r.Con__r.Name, CreatedDate, A__c,
                    STA__c, TP__c, dt__c from g_Tran__c where Acc__c =: AccountId AND dt__c >=: lst12mnthDate AND dt__c <= Today AND TP__c != 'Claim' Limit: PageSize offset: Offset];
            return objAccList;
        }
        catch (QueryException e) {
            ApexPages.addMessages(e);
            return null;
        }
    }

    public integer LNumber {
        get {
            return RecordCount == 0 ? 0 : (Offset + 1);
        }
    }
    public integer UNumber {
        get {
            integer iUNum = ((LNumber + PageSize) - 1);
            return (iUnum > RecordCount) ? RecordCount : iUNum;
        }
    }
    public boolean AllowMoveNext {
        get{
            return ((PageIndex + 1) < PageCount);
        }
    }
    public boolean AllowMovePrev {
        get{
            return (PageIndex > 0);
        }
    }
    public void Prev() {
        PageNumber--;
        if (PageNumber <= 0) {
            PageNumber = 1;
        }
    }
    public void Next() {
        PageNumber++;
        if (PageNumber > PageCount) {
            PageNumber = PageCount;
        }
    }
    public void Last() {
        PageNumber = PageCount;
    }
    public void First() {
        PageNumber = 1;
    }
    private integer getPageCount() {
        integer iPageCount = 1;
        if (RecordCount != 0 && PageSize != 0) {
            iPageCount = (RecordCount/PageSize) + ((Math.mod(RecordCount, PageSize)) > 0 ? 1 : 0);
        }
        return iPageCount;
    }

    public void ageChangeMethod() {
        String selVal = ageSelectedValue;
        try{
            List <String> strList = ageSelectedValue.split( '-' );
            AggregateResult aggregate = [Select AVG(Age__c) avgAge, MIN(Age__c) minAge, MAX(Age__c) maxAge from contact
                                         where AccountId =: AccountId AND rol__c IN: strList AND STA__c IN: conStatus];

            Decimal averageAge = (Decimal)aggregate.get('avgAge');

            Decimal minimumAge = (Decimal)aggregate.get('minAge');

            Decimal maximumAge = (Decimal)aggregate.get('maxAge');

            sectionData sdAgeData = new sectionData();
            sdAgeData.totalAvg = Integer.valueOf(averageAge);
            sdAgeData.largestNumber = Integer.valueOf(maximumAge);
            sdAgeData.smallestNumber = Integer.valueOf(minimumAge);
            sdAgeData.grData = getNumericData('Age__c', contactList, strList);

            ChartData.ageRangeData = sdAgeData;
        }catch (Exception e) {
            system.debug('ex::' + e.getStackTraceString());
            gU.AddErrorMsg(e);
        }
    }

    public void genderChangeMethod() {
        List <String> strList = genderSelectedValue.split( '-' );
        try{
            sectionData sdGenderData = new sectionData();
            sdGenderData.BarGrData = genderData(contactList, strList);

            ChartData.genderData = sdGenderData;
        }catch (Exception e) {
            system.debug('ex::' + e.getStackTraceString());
            gU.AddErrorMsg(e);
        }
    }

    public void typeChangeMethod() {
        try{
            List <String> strList = TypeSelectedValue.split( '-' );
            sectionData sdGenderData = new sectionData();
            sdGenderData.BarGrData = employeeTypeData(strList);

            ChartData.employeeTypeData = sdGenderData;
        }catch (Exception e) {
            system.debug('ex::' + e.getStackTraceString());
            gU.AddErrorMsg(e);
        }
    }

    public void salaryChangeMethod() {
        try{
            List <String> strList = salarySelectedValue.split( '-' );
            system.debug('=====#432'+strList);
            AggregateResult aggregate = [Select AVG(mgs__c) avgAge, MIN(mgs__c) minAge, MAX(mgs__c) maxAge from contact
                                         where AccountId =: AccountId AND rol__c IN: strList AND STA__c IN: conStatus];

            Decimal averageAge = (Decimal)aggregate.get('avgAge');

            Decimal minimumAge = (Decimal)aggregate.get('minAge');

            Decimal maximumAge = (Decimal)aggregate.get('maxAge');

            sectionData sdAgeData = new sectionData();
            sdAgeData.totalAvg = Integer.valueOf(averageAge);
            sdAgeData.largestNumber = Integer.valueOf(maximumAge);
            sdAgeData.smallestNumber = Integer.valueOf(minimumAge);
            sdAgeData.grData = getNumericData('mgs__c', contactList, strList);
            system.debug('=====#446'+sdAgeData);
            ChartData.salaryRangeData = sdAgeData;
        }catch (Exception e) {
            system.debug('ex::' + e.getStackTraceString());
            gU.AddErrorMsg(e);
        }
    }

    public void countryChangeMethod() {
        try{
            List <String> strList = countrySelectedValue.split( '-' );
            sectionData sdCounData = new sectionData();
            sdCounData.grData = gettingCountryData(strList);

            ChartData.countryData = sdCounData;
        }catch (Exception e) {
            system.debug('ex::' + e.getStackTraceString());
            gU.AddErrorMsg(e);
        }

    }

    public void passportChangeMethod() {
        try{
            List <String> strList = passSelectedValue.split( '-' );
            Date DaysFromNow = Date.Today().addDays(30);
            Integer passExpToday = [Select COUNT() from contact
                                    where AccountId =: AccountId AND ped__c = TODAY AND rol__c IN: strList AND STA__c IN: conStatus];
            Integer passExpNxt30Day = [Select COUNT() from contact
                                       where AccountId =: AccountId AND ped__c >= TODAY AND ped__c <=: DaysFromNow AND rol__c IN: strList AND STA__c IN: conStatus];
            Integer passExpthisYear = [Select COUNT() from contact
                                       where AccountId =: AccountId AND ped__c = THIS_FISCAL_YEAR AND rol__c IN: strList AND STA__c IN: conStatus];

            sectionData sdPassData = new sectionData();
            sdPassData.totalAvg = passExpToday;
            sdPassData.largestNumber = passExpNxt30Day;
            sdPassData.smallestNumber = passExpthisYear;
            sdPassData.BarGrData = passportData(AccountId, strList);
            ChartData.passportData = sdPassData;
        }catch (Exception e) {
            system.debug('ex::' + e.getStackTraceString());
            gU.AddErrorMsg(e);
        }
    }

    public void rpChangeMethod() {
        try{
            List <String> strList = rpSelectedValue.split( '-' );
            system.debug('=====#432'+strList);
            Date DaysFromNow = Date.Today().addDays(30);
            Integer rpExpToday = [Select COUNT() from contact
                                  where AccountId =: AccountId AND rped__c = TODAY AND rol__c IN: strList AND STA__c IN: conStatus];
            Integer rpExpNxt30Day = [Select COUNT() from contact
                                     where AccountId =: AccountId AND rped__c >= TODAY AND rped__c <=: DaysFromNow AND rol__c IN: strList AND STA__c IN: conStatus];
            Integer rpExpthisYear = [Select COUNT() from contact
                                     where AccountId =: AccountId AND rped__c = THIS_FISCAL_YEAR AND rol__c IN: strList AND STA__c IN: conStatus];
            sectionData sdrpData = new sectionData();
            sdrpData.totalAvg = rpExpToday;
            sdrpData.largestNumber = rpExpNxt30Day;
            sdrpData.smallestNumber = rpExpthisYear;
            sdrpData.BarGrData = rpData(AccountId, strList);
            ChartData.rpData = sdrpData;
        }catch (Exception e) {
            system.debug('ex::' + e.getStackTraceString());
            gU.AddErrorMsg(e);
        }
    }

    public void payMetChangeMethod() {
        system.debug('====payMetChangeMethod=='+payMetSelectedValue);
        List <String> strList = payMetSelectedValue.split( '-' );
        metChange = true;
        nxt1Yr = false;
        lstMonth = false;
        lst3Month = false;
        lst6Month = false;
        lst12Month = false;
        payType=false;
        PageSize = 10;
        PageNumber = 1;
        RecordCount = [Select Count() from g_Tran__c where Acc__c =: AccountId AND CreatedDate = THIS_FISCAL_YEAR AND TP__c != 'Claim' AND md__c IN : strList];
        system.debug('====payMetChangeMethod RecordCount=='+RecordCount);
    }
    public void payChangeMethod() {
        system.debug('====payChangeMethod=='+paySelectedValue2);
        metChange = false;
        nxt1Yr = false;
        lstMonth = false;
        lst3Month = false;
        lst6Month = false;
        lst12Month = false;
        payType=true;
        PageSize = 10;
        PageNumber = 1;
        if (paySelectedValue2 == 'Payment-Refund') RecordCount = [Select Count() from g_Tran__c where Acc__c =: AccountId AND CreatedDate = THIS_FISCAL_YEAR AND TP__c != 'Claim'];
        else RecordCount = [Select Count() from g_Tran__c where Acc__c =: AccountId AND CreatedDate = THIS_FISCAL_YEAR AND TP__c =: paySelectedValue2];
        system.debug('====payChangeMethod RecordCount=='+RecordCount);
    }

    public void nxtOneYrData() {
        Date nxt1yrdate = Date.Today().addYears(1);
        system.debug('====nxtOneYrData===='+nxt1yrdate);
        metChange = false;
        nxt1Yr = true;
        lstMonth = false;
        lst3Month = false;
        lst6Month = false;
        lst12Month = false;
        payType=false;
        PageSize = 10;
        PageNumber = 1;
        dateVal3 = date.today().format();
        dateVal4 = date.today().addYears(1).format();
        RecordCount = [Select Count() from g_Tran__c where Acc__c =: AccountId AND (dt__c >= TODAY AND dt__c <=: nxt1yrdate) AND TP__c != 'Claim'];
        system.debug('====nxtOneYrData RecordCount=='+RecordCount);
    }
    public void lastMonthData() {
        system.debug('====lastMonthData====');
        Date lstmnthDate = Date.Today().addMonths(-1);
        metChange = false;
        nxt1Yr = false;
        lstMonth = true;
        lst3Month = false;
        lst6Month = false;
        lst12Month = false;
        payType=false;
        PageSize = 10;
        PageNumber = 1;
        dateVal3 = date.today().addMonths(-1).format();
        dateVal4 = date.today().format();
        RecordCount = [Select count() from g_Tran__c where Acc__c =: AccountId AND dt__c >=: lstmnthDate AND dt__c <= Today AND TP__c != 'Claim'];
        system.debug('====lastMonthData RecordCount=='+RecordCount);
    }
    public void last3MonthData() {
        system.debug('====last3MonthData====');
        Date lst3mnthDate = Date.Today().addMonths(-3);
        metChange = false;
        nxt1Yr = false;
        lstMonth = false;
        lst3Month = true;
        lst6Month = false;
        lst12Month = false;
        payType=false;
        PageSize = 10;
        PageNumber = 1;
        dateVal3 = date.today().addMonths(-3).format();
        dateVal4 = date.today().format();
        RecordCount = [Select count() from g_Tran__c where Acc__c =: AccountId AND dt__c >=: lst3mnthDate AND dt__c <= Today AND TP__c != 'Claim'];
        system.debug('====last3MonthData RecordCount=='+RecordCount);
    }
    public void last6MonthData() {
        system.debug('====last6MonthData====');
        Date lst6mnthDate = Date.Today().addMonths(-6);
        metChange = false;
        nxt1Yr = false;
        lstMonth = false;
        lst3Month = false;
        lst6Month = true;
        lst12Month = false;
        payType=false;
        PageSize = 10;
        PageNumber = 1;
        dateVal3 = date.today().addMonths(-6).format();
        dateVal4 = date.today().format();
        RecordCount = [Select count() from g_Tran__c where Acc__c =: AccountId AND dt__c >=: lst6mnthDate AND dt__c <= Today AND TP__c != 'Claim'];
        system.debug('====last6MonthData RecordCount=='+RecordCount);
    }
    public void last12MonthData() {
        system.debug('====last12MonthData====');
        Date lst12mnthDate = Date.Today().addYears(-1);
        metChange = false;
        nxt1Yr = false;
        lstMonth = false;
        lst3Month = false;
        lst6Month = false;
        lst12Month = true;
        payType=false;
        PageSize = 10;
        PageNumber = 1;
        dateVal3 = date.today().addYears(-1).format();
        dateVal4 = date.today().format();
        RecordCount = [Select count() from g_Tran__c  where Acc__c =: AccountId AND dt__c >=: lst12mnthDate AND dt__c <= Today AND TP__c != 'Claim'];
        system.debug('====last12MonthData RecordCount=='+RecordCount);
    }

    public PageReference exportData() {
    PageReference pageRef = new PageReference('/apex/ExportDataToExcel');
    pageRef.setRedirect(true);
    pageRef.getParameters().put('AccountId', AccountId);
    pageRef.getParameters().put('filter', filterVal);
    pageRef.getParameters().put('fieldVal', fieldVal);
    pageRef.getParameters().put('ptEmp', ptEmp);
    system.debug('====fieldVal==' + fieldVal);
    system.debug('====dateVal1==' + dateVal1);
    system.debug('====dateVal2==' + dateVal2);
    system.debug('====dateVal3==' + dateVal3);
    system.debug('====dateVal4==' + dateVal4);
    system.debug('====filterVal==' + filterVal);
    if (fieldVal == 'transaction') {
        pageRef.getParameters().put('fieldVal', 'transaction');
        pageRef.getParameters().put('startDate', dateVal1);
        pageRef.getParameters().put('endDate', dateVal2);
    }
    if (fieldVal == 'transactions2') {
        pageRef.getParameters().put('fieldVal', 'transactions2');
        pageRef.getParameters().put('startDate', dateVal3);
        pageRef.getParameters().put('endDate', dateVal4);
        pageRef.getParameters().put('addFilter', addfilterVal);
    }
    return pageRef;
}

    public void valueupdateDate1() { string x=String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('dat1FromVf')); dateVal1 = x; }
    public void valueupdateDate2() { string x=String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('dat2FromVf')); dateVal2 = x;  }
    public void valueupdateDate3() { string x=String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('dat3FromVf')); dateVal3 = x;  }
    public void valueupdateDate4() { string x=String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('dat4FromVf')); dateVal4 = x;  }
    public void valuepay1() { string x=String.escapeSingleQuotes(Apexpages.currentPage().getParameters().get('pay1Val')); paySelectedValue = x;  }

    public class pageData
    {
        public sectionData ageRangeData {get;set;}
        public sectionData genderData {get;set;}
        public sectionData employeeTypeData {get;set;}
        public sectionData salaryRangeData {get;set;}
        public sectionData countryRangeData {get;set;}
        public sectionData passportData {get;set;}
        public sectionData rpData {get;set;}
        public sectionData transData {get;set;}
        public sectionData countryData {get;set;}
    }
    public class sectionData
    {
        public Integer totalAvg{get;set;}
        public Integer largestNumber{get;set;}
        public Integer smallestNumber{get;set;}
        public List<GraphData> grData{get;set;}
        public List<BarGraphData> BarGrData{get;set;}
        public List<TransactionDataWrap> transData{get;set;}
    }
    public class GraphData
    {
        public Integer peopleCount{get;set;}
        public String Range{get;set;}
        public Decimal peoplePercent{get;set;}
        public GraphData(Integer peopleCount, String Range, Decimal peoplePercent) {
            try{
                this.peopleCount = peopleCount;
                this.Range = Range;
                this.peoplePercent = peoplePercent;
            }catch (Exception e) {
                system.debug('ex::' + e.getStackTraceString());
                gU.AddErrorMsg(e);
            }
        }
    }
    public class BarGraphData
    {
        public Integer peopleCountParam{get;set;}
        public String RangeParam{get;set;}
        public BarGraphData(Integer peopleCount, String Range) {
            try{
            this.peopleCountParam = peopleCount;
            this.RangeParam = Range;
        }catch (Exception e) {
            system.debug('ex::' + e.getStackTraceString());
            gU.AddErrorMsg(e);
        }
        }
    }
    public class TransactionDataWrap {
        public String Name{
            get;
            set;
        }
        public String Service{
            get;
            set;
        }
        public String passNo{
            get;
            set;
        }
        public String paymentType{
            get;
            set;
        }
        public String paymentMethod{
            get;
            set;
        }
        public String payInitDate{
            get;
            set;
        }
        public String payProccessDate{
            get;
            set;
        }
        public String amount{
            get;
            set;
        }
        public String transcStatus{
            get;
            set;
        }
        public TransactionDataWrap() {
        }
        public TransactionDataWrap(String Name, String Service, String passNo, String paymentType,
            String paymentMethod, String payInitDate, String payProccessDate, String amount,
            String transcStatus) {
            this.Name = Name;
            this.Service = Service;
            this.passNo = passNo;
            this.paymentType = paymentType;
            this.paymentMethod = paymentMethod;
            this.payInitDate = payInitDate;
            this.payProccessDate = payProccessDate;
            this.amount = amount;
            this.transcStatus = transcStatus;
        }
    }

}