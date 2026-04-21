public with sharing class gctRprt{
    public User U{get;set;}public Account A{get;set;}
    public Boolean ispu{get;set;}public string lcl{get{return UserInfo.getLocale();}}public Boolean pgHide{get;set;}
    public gctRprt() {ispu=gu.isPortalUser(UserInfo.getProfileId());pgHide=!ispu;init();}
    private void init() {try{if (ispu) {loadData();}gU.checkNav();}catch (exception ex) {gu.AddErrorMsg(ex);pgHide=true;}}

    public Decimal EDraft {get;set;}
    public Decimal EActive {get;set;}
    public Decimal UnderAct {get;set;}
    public Decimal UnderDeac {get;set;}
    public Decimal UnderAbs {get;set;}
    public Decimal UnderAbW {get;set;}
    public Decimal EAW {get;set;}

    public integer NcMapSize{get;set;}

    public Decimal NDraft {get;set;}
    public Decimal NActive {get;set;}
    public Decimal NUnderAct {get;set;}
    public Decimal NUnderDeac {get;set;}
    public Decimal NUnderAbs {get;set;}
    public Decimal NUnderAbW {get;set;}
    public Decimal NAW {get;set;}

    public Decimal ADraft {get;set;}
    public Decimal AActive {get;set;}
    public Decimal AUnderAct {get;set;}
    public Decimal AUnderDeac {get;set;}
    public Decimal AUnderAbs {get;set;}
    public Decimal AUnderAbW {get;set;}
    public Decimal AAW {get;set;}

     public Decimal cRPExp {get;set;} {cRPExp = 0;}
     public Decimal cRPExp30 {get;set;} {cRPExp30 = 0;}
     public Decimal cRPExp360 {get;set;} {cRPExp360 = 0;}

     public Decimal cPSExp {get;set;} {cPSExp = 0;}
     public Decimal cPSExp30 {get;set;} {cPSExp30 = 0;}
     public Decimal cPSExp360 {get;set;} {cPSExp360 = 0;}

    private map<String, Decimal> mEmpRL; public String gDataEmpRL{get{return frmtChart(new list<String> {'Sponsorship', 'Employees'}, mEmpRL);}}/*Role*/

    private map<String, Decimal> mApGen; public String gDataApGen{get{return frmtChartDonut(mApGen);}} /*Gender*/

    private map<String, Decimal> mApNC; public String gDataApNC{get{return frmtChartTbl(new list<String> {'Country', 'Nationality'}, mApNC);}} /*Nationality*/

    private map<String, Decimal> mApAge; public String gDataApAge{get{return frmtChartBar(new list<String> {'Age', 'Age Range'}, mApAge);}} /*Age Range*/

    private map<String, Decimal> mApSal; public String gDataApSal{get{return frmtChartBar(new list<String> {'Salary', 'Salary Range'}, mApSal);}} /*Age Range*/

    private map<String, map<String, Decimal>> mRP; public String gDataRP{get{return frmtChart(mRP);}}/*RP Expiry: by Date/Role*/
    private map<String, map<String, Decimal>> mPS; public String gDataPS{get{return frmtChart(mPS);}}/*Passport Expiry: by Date/Role*/
    public g_Tran__c tF{get;set;}{tF = new g_Tran__c();} /*Used for Filtering Statements*/
    public g_Tran__c tT{get;set;}{tT = new g_Tran__c();} /*Used for Filtering Statements*/

    private String frmtChart(list < String > cols, map < String, Decimal > m) {
        String d = '';
        for (String c: cols) {
            d += d == '' ? '[\'' + c + '\'' : ', \'' + c + '\'';
        }
        d += ']';
        for (String k: gU.sort(m.KeySet())) {
            String v='';
            if (k != null) {
                v=String.valueOf(Integer.ValueOf(m.Get(k)));
                v=v.replace(', ', '');
                v=v.replace('.00', '');
            }
            d += ', [\'' + k + '\', ' + v + ']';
        }
        return d;
    }

    private String frmtChart(map<String, map<String, Decimal>>m) {
        set<String> cols = new set<String>();
        for (String dt:m.KeySet()) {
            for (String c: m.get(dt).KeySet()) {
                cols.add(c);
            }
        }
        String d='[\'Month\'';
        for (String c: gU.sort(cols)) {
            d+=', \''+c+'\'';
        }
        d+=']';
        for (String dt:gU.sort(m.KeySet())) {
            d+=', [\''+dt+'\'';
            for (String k: gU.sort(cols)) {
                if (m.get(dt).get(k)==null) {
                    d+=', 0';
                }
                else{
                    d+=', '+ m.get(dt).get(k).format();
                }
            }
            d+=']';
        }
        return d;
    }

    //Donut
    private String frmtChartDonut(map < String, Decimal > m) {
        set < String > cols = new set < String > ();
        for (String c: m.KeySet()) {
            cols.add(c);
        }
        String d = '';
        for (String c: cols) {
            d += d == '' ? '[\'' + c + '\'' : ', \'' + c + '\'';
        }
        d += ']';
        for (String k: gU.sort(m.KeySet())) {
            String v='';
            if (k != null) {
                v=String.valueOf(Integer.ValueOf(m.Get(k)));
                v=v.replace(', ', '');
                v=v.replace('.00', '');
            }
            d += ', [\'' + k + '\', ' + v + ']';
        }
        return d;
    }

    //barchart
    private String frmtChartBar(list < String > lab, map < String, Decimal > m) {
        String d = '';
        d += d == '' ? '[\'' + lab[0] + '\'' : ', \'' + lab[0] + '\'';
        d += d == '' ? '[\'' + lab[1] + '\'' : ', \'' + lab[1] + '\'';
        d += ']';
        for (String k: gU.sort(m.KeySet())) {
            String v='';
            if (k != null) {
                v=String.valueOf(Integer.ValueOf(m.Get(k)));
                v=v.replace(', ', '');
                v=v.replace('.00', '');
            }
            d += ', [\'' + k + '\', ' + v + ']';
        }
        return d;
    }

    //Table
    private String frmtChartTbl(list < String > lab, map < String, Decimal > m) {
        String d = '';
        for (String k: gU.sort(m.KeySet())) {
            String v='';
            if (k != null) {
                v=String.valueOf(Integer.ValueOf(m.Get(k)));
                v=v.replace(', ', '');
                v=v.replace('.00', '');
            }
            if (String.isBlank(d)) {
                d +='[\'' + k + '\', ' + v + ']';
            }
            else{
                d += ', [\'' + k + '\', ' + v + ']';
            }
        }
        return d;
    }

    private void loadData() {
        U = [select Id, FirstName, LastName, accountid, contact.account.id, contact.account.Name from User where id=:UserInfo.getUserId() limit 1];
        A = U.contact.account;
        loadReports();
    }

    private void loadReports() {
    mRP = new map < String, map < String, Decimal >> ();
    mPS = new map < String, map < String, Decimal >> ();
    mEmpRL = new map < String, Decimal > ();
    mEmpRL.put('Sponsored Employee', 0);
    mEmpRL.put('Non Sponsored', 0);
    mEmpRL.put('Access Card', 0);

    mApGen = new map < String, Decimal > ();
    mApNC = new map < String, Decimal > ();
    mApAge = new map < String, Decimal > ();
    mApSal = new map < String, Decimal > ();
    //mEmpSt=new map<String, Decimal>();mNpSt = new map<String, Decimal>();

    NcMapSize = 0;
    EDraft = 0;
    EActive = 0;
    UnderAct = 0;
    UnderDeac = 0;
    UnderAbs = 0;
    UnderAbW = 0;
    EAW = 0;
    NDraft = 0;
    NActive = 0;
    NUnderAct = 0;
    NUnderDeac = 0;
    NUnderAbs = 0;
    NUnderAbW = 0;
    NAW = 0;
    ADraft = 0;
    AActive = 0;
    AUnderAct = 0;
    AUnderDeac = 0;
    AUnderAbs = 0;
    AUnderAbW = 0;
    AAW = 0;

    for (Contact c: [select Id, STA__c, rol__c, Gender__c, nc__c, ms__c, ql__c, Salutation,
        rped__c, ped__c, lua__c, luas__c, agp__c, Salary_range__c, Name from Contact where isDeleted = false and(STA__c = 'Draft'
            OR STA__c = 'Draft'
            OR STA__c = 'Active'
            OR STA__c = 'Under Activation'
            OR STA__c = 'Under Deactivation'
            OR STA__c = 'Under Absconder Declaration'
            OR STA__c = 'Under Absconder Withdrawal'
            OR STA__c = 'Absconder Withdrawn') and AccountId =: A.Id]) {
        if (c.rol__c == null) {
            c.rol__c = 'N/A';
        }

        if (c.STA__c == 'Draft') {
            if (c.rol__c == 'Employee') {
                EDraft = EDraft + 1;
            }
            if (c.rol__c == 'Non Sponsored') {
                NDraft = NDraft + 1;
            }
            if (c.rol__c == 'Access Card') {
                ADraft = ADraft + 1;
            }
        }

        if (c.STA__c == 'Active') {
            if (c.rol__c == 'Employee') {
                EActive = EActive + 1;
            }
            if (c.rol__c == 'Non Sponsored') {
                NActive = NActive + 1;
            }
            if (c.rol__c == 'Access Card') {
                AActive = AActive + 1;
            }
        }

        if (c.STA__c == 'Absconder Withdrawn') {
            if (c.rol__c == 'Employee') {
                EAW = EAW + 1;
            }
            if (c.rol__c == 'Non Sponsored') {
                NAW = NAW + 1;
            }
            if (c.rol__c == 'Access Card') {
                AAW = AAW + 1;
            }
        }

        if (c.STA__c == 'Under Activation') {
            if (c.rol__c == 'Employee') {
                UnderAct = UnderAct + 1;
            }
            if (c.rol__c == 'Non Sponsored') {
                NUnderAct = NUnderAct + 1;
            }
            if (c.rol__c == 'Access Card') {
                AUnderAct = AUnderAct + 1;
            }
        }
        if (c.STA__c == 'Under Deactivation') {
            if (c.rol__c == 'Employee') {
                UnderDeac = UnderDeac + 1;
            }
            if (c.rol__c == 'Non Sponsored') {
                NUnderDeac = NUnderDeac + 1;
            }
            if (c.rol__c == 'Access Card') {
                AUnderDeac = AUnderDeac + 1;
            }
        }
        if (c.STA__c == 'Under Absconder Declaration') {
            if (c.rol__c == 'Employee') {
                UnderAbs = UnderAbs + 1;
            }
            if (c.rol__c == 'Non Sponsored') {
                NUnderAbs = NUnderAbs + 1;
            }
            if (c.rol__c == 'Access Card') {
                AUnderAbs = AUnderAbs + 1;
            }
        }
        if (c.STA__c == 'Under Absconder Withdrawal') {
            if (c.rol__c == 'Employee') {
                UnderAbW = UnderAbW + 1;
            }
            if (c.rol__c == 'Non Sponsored') {
                NUnderAbW = NUnderAbW + 1;
            }
            if (c.rol__c == 'Access Card') {
                AUnderAbW = AUnderAbW + 1;
            }
        }

        if (c.rped__c < Date.today() && NotGCC(c.nc__c) && c.STA__c == 'Active' && (c.rol__c == 'Employee' || c.rol__c == 'Non Sponsored' || c.rol__c == 'Access Card' || c.rol__c == 'Student')) {
            cRPExp++;
        }

        if (c.STA__c == 'Active' && NotGCC(c.nc__c) && (c.rol__c == 'Employee' || c.rol__c == 'Non Sponsored' || c.rol__c == 'Access Card' || c.rol__c == 'Student')) {

            if (c.ped__c <= Date.today()) {
                cPSExp++;
            }

        }

        if (c.rol__c == 'Employee' || c.rol__c == 'Non Sponsored' || c.rol__c == 'Access Card') {
            if (c.rol__c == 'Employee') {
                mEmpRL.put('Sponsored Employee', mEmpRL.get('Sponsored Employee') + 1);
            } else {
                mEmpRL.put(c.rol__c, mEmpRL.get(c.rol__c) + 1);
            }
        }
        // if (c.STA__c == 'Active' && &&(c.rol__c=='Employee'||c.rol__c=='Non Sponsored'||c.rol__c=='Access Card' ||c.rol__c=='Student')) {
        String dt = c.rped__c == null ? 'N/A' : datetime.newInstance(c.rped__c, time.newInstance(0, 0, 0, 0)).format('YYYY-MM');

        if (c.rped__c > Date.today() && c.rped__c <= Date.today().addDays(365) && c.STA__c == 'Active' && NotGCC(c.nc__c) && (c.rol__c == 'Employee' || c.rol__c == 'Non Sponsored' || c.rol__c == 'Access Card' || c.rol__c == 'Student')) {
            if (mRP.get(dt) == null) {
                mRP.put(dt, new map < String, Decimal > ());
            }
            cRPExp360++;

            if (c.rped__c != null) {

                if (mRP.get(dt).get(c.rol__c) == null) {
                    mRP.get(dt).put(c.rol__c, 1);
                } else {
                    mRP.get(dt).put(c.rol__c, mRP.get(dt).get(c.rol__c) + 1);
                }
            }

            if (c.rped__c > Date.today() && c.rped__c <= Date.today().addDays(30)) {
                cRPExp30++;
            }

        }

        dt = c.ped__c == null ? 'N/A' : datetime.newInstance(c.ped__c, time.newInstance(0, 0, 0, 0)).format('YYYY-MM');
        if (c.ped__c > Date.today() && c.ped__c <= Date.today().addDays(365) && c.STA__c == 'Active' && (c.rol__c == 'Employee' || c.rol__c == 'Non Sponsored' || c.rol__c == 'Access Card' || c.rol__c == 'Student')) {
            if (mPS.get(dt) == null) {
                mPS.put(dt, new map < String, Decimal > ());
            }
            if (mPS.get(dt).get(c.rol__c) == null) {
                mPS.get(dt).put(c.rol__c, 1);
            } else {
                mPS.get(dt).put(c.rol__c, mPS.get(dt).get(c.rol__c) + 1);
            }

            if (c.ped__c > Date.today() && c.ped__c <= Date.today().addDays(30)) {
                cPSExp30++;
            }

            cPSExp360++;

        }
        system.debug('JJD mPS' + mPS);
        /**Nationality**/
        if (c.nc__c != null) {
            if (mApNC == null || mApNC.isEmpty()) {
                mApNC.put(c.nc__c, 1);
            } else {
                if (mApNC.containsKey(c.nc__c)) {
                    mApNC.put(c.nc__c, mApNC.get(c.nc__c) + 1);
                } else {
                    mApNC.put(c.nc__c, 1);
                }
            }
        }

        /** Gender **/
        if (c.Gender__c != null && (c.Gender__c == 'Male' || c.Gender__c =='Female') ) {
            if (mApGen == null || mApGen.isEmpty()) {
                mApGen.put(c.Gender__c, 1);
            } else {
                if (mApGen.containsKey(c.Gender__c)) {
                    mApGen.put(c.Gender__c, mApGen.get(c.Gender__c) + 1);
                } else {
                    mApGen.put(c.Gender__c, 0);
                }
            }
        }

        if (c.agp__c != null) {
            if (mApAge == null || mApAge.isEmpty()) {
                mApAge.put(c.agp__c, 1);
            } else {
                if (mApAge.containsKey(c.agp__c)) {
                    mApAge.put(c.agp__c, mApAge.get(c.agp__c) + 1);
                } else {
                    mApAge.put(c.agp__c, 1);
                }

            }
        }

        if (c.Salary_range__c != null) {
            if (mApSal == null || mApSal.isEmpty()) {
                mApSal.put(c.Salary_range__c, 1);
            } else {
                if (mApSal.containsKey(c.Salary_range__c)) {
                    mApSal.put(c.Salary_range__c, mApSal.get(c.Salary_range__c) + 1);
                } else {
                    mApSal.put(c.Salary_range__c, 1);
                }

            }
        }

    }
    NcMapSize = mApNC.size();

}

    private boolean NotGCC(String nationality) {
        if (nationality <> 'Bahrain' && nationality <> 'Kuwait' && nationality <> 'Oman' && nationality <> 'Qatar' && nationality <> 'Saudi Arabia' && nationality <> 'United Arab Emirates') {
            return true;
        } else {
            return false;
        }
    }

}