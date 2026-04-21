global with sharing class gU {
    public enum pmd {mNew, mEdit, mView}
    global class pgMode{
        private pmd m = pmd.mNew;
        public Boolean isNew{
            get{
                return m == pmd.mNew;
            }
        }
        public Boolean isEdit{
            get{
                return m == pmd.mEdit;
            }
        }
        public Boolean isView{
            get{
                return m == pmd.mView;
            }
        }
        public void setNew() {
            m = pmd.mNew;
        }
        public void setEdit() {
            m = pmd.mEdit;
        }
        public void setView() {
            m = pmd.mView;
        }
        public void getPgParam() {
            String p = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('m'));
            if (p== 'n') {
                m = pmd.mNew;
            }
            else if (p== 'e') {
                m = pmd.mEdit;
            }
            else {
                m = pmd.mView;
            }
        }
    }
    //*************************************************************** ----- Errors Helper Functions
    public class customException extends Exception {}
    public static void AddErrorMsg(exception ex) {Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.FATAL, ex.getMessage());ApexPages.addMessage(errMsg);}
    public static void AddErrorMsg(String Msg) {Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR, Msg);ApexPages.addMessage(errMsg);}
    public static void AddWarningMsg(String Msg) {Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.WARNING, Msg);ApexPages.addMessage(errMsg);}
    public static void AddSuccessMsg(String Msg) {Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.CONFIRM, Msg);ApexPages.addMessage(errMsg);}
    public static void AddInfoMsg(String Msg) {Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.INFO, Msg);ApexPages.addMessage(errMsg);}
    //*************************************************************** ----- Ids
    public static Boolean IdsEqual(String id1, String id2) {
        if ((id1 == null)&&(id2 == null)) {
            return true;
        }
        if ((id1 == null)||(id2 == null)) {
            return false;
        }
        if (id1.subString(0, 15).equals(id2.subString(0, 15))) {
            return true;
        }
        return false;
    }
    public static Boolean ValueIsNull(Object val) {if (val == null || String.valueOf(val).length() == 0) {return true;}return false;}
    //*************************************************************** ----- custom Settings
    public static Boolean csBool(String sName) {return gStg__c.getInstance(sName).Checkbox_Value__c;}

    @TestVisible public static String csStr(String sName) { System.debug('inside csStr===='+gStg__c.getInstance(sName).Text_Value__c); return gStg__c.getInstance(sName).Text_Value__c; }
    public static Decimal csNum(String sName) {return gStg__c.getInstance(sName).Number_Value__c;}
    public static Decimal csCurr(String sName) {return gStg__c.getInstance(sName).Currency_Value__c;}
    //*************************************************************** ----- Map Sorting
    public static List<string> Sort(Set<String> keyset) {List<string> keys = new List<string>(keyset);keys.sort();return keys;}
    public static List<Date> Sort(Set<Date> keyset) {List<Date> keys = new List<Date>(keyset);keys.sort();return keys;}
    //*************************************************************** ----- convert to Text
    public static string AmountInWords(long n) {
        /*Assuming max of Billions*/if (n<0) {
            return '('+AmountInWords(-n)+')';
        }
        else if (n == 0) {
            return '';
        }
        else if (n <= 19) {
            return new string[] {
            'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'}
            [n.intValue() - 1] + ' ';
        }
        else if (n <= 99) {
            return new string[] {
            'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'}
            [n.intValue() / 10 - 2] + ' ' + AmountInWords(System.Math.mod(n, 10));
        }
        else if (n <= 199) {
            return 'One Hundred ' + AmountInWords(System.Math.mod(n, 100));
        }
        else if (n <= 999) {
            return AmountInWords(n / 100) + 'Hundred ' + AmountInWords(System.Math.mod(n, 100));
        }
        else if (n <= 1999) {
            return 'One Thousand ' + AmountInWords(System.Math.mod(n, 1000));
        }
        else if (n <= 999999) {
            return AmountInWords(n / 1000) + 'Thousand ' +  (System.Math.mod(n, 1000)==0 ? '' : 'and ' + AmountInWords(System.Math.mod(n, 1000)));
        }
        else if (n <= 1999999) {
            return 'One Million ' + AmountInWords(System.Math.mod(n, 1000000));
        }
        else if (n <= 999999999) {
            return AmountInWords(n / 1000000) + 'Million ' + (System.Math.mod(n, 1000000)==0? '' : 'and ' + AmountInWords(System.Math.mod(n, 1000000)));
        }
        else if (n <= 1999999999) {
            return 'One Billion ' + AmountInWords(System.Math.mod(n, 1000000000));
        }
        else{
            return AmountInWords(n / 1000000000) + 'Billion '  + (System.Math.mod(n, 1000000000)==0? '' : 'and ' + AmountInWords(System.Math.mod(n, 1000000000)) );
        }
    }
    public static String PeriodInWords(Date startDate, Date endDate) {
        if (startDate == null || endDate == null) {
            return '';
        }
        if (startDate == endDate) {
            return '';
        }
        DateTime d2 = DateTime.newInstance(0);
        d2 = d2.addDays(startDate.daysBetween(endDate.addDays(1)));
        DateTime d1 = DateTime.newInstance(0);
        integer years =d2.Year()-d1.Year();
        integer months =d2.Month()-1;
        integer days =d2.Day()-1;
        return (String)((years <= 0?'':(years == 1?'One (1) year ':AmountInWords(years)+'('+ String.ValueOf(years)+
            ') years'))+(months <= 0?'':(years>0 && days <= 0 ?' and ':'')+(months == 1?'One (1) month ':AmountInWords(months)+
            ' ('+ String.ValueOf(months)+') months '))+(days <= 0?'':(years>0||months>0?' and ':'')+(days == 1? 'One (1) day ':AmountInWords(days)+
            ' ('+String.ValueOf(days) +') days'))).trim();
    }
    //*************************************************************** ----- VF Pages
    public static String pageURL {
        get{
            String pgURL = ApexPages.CurrentPage().getUrl();
            pgURL = pgURL.replaceFirst('/apex', '');
            pgURL = pgURL.replaceFirst('//', '');
            pgURL = pgURL.split('/')[1];
            return pgURL.split('\\?')[0];
        }
    }
    //*************************************************************** ----- Profiles & Security
    public static Boolean FindProfileId(String sName, Id profileId) {
        System.debug('====inside FindProfileId===='+sName);
        System.debug('split output=='+csStr(sName).split('\\;', 0));
        for (String pId : csStr(sName).split('\\;', 0)) {
            System.debug('pid===='+pId);
            System.debug('profileId===='+profileId);
            if (IdsEqual(pId, profileId)) {
                System.debug('====inside Equal====');
                return true;
            }
        }
        return false;
    }
    public static Boolean isGuestUser(Id pid) {return FindProfileId('guprfl', pid);}
    public static Boolean isPortalUser(Id pid) {return FindProfileId('gpPrfls', pid);}
    public static Boolean isPortalSuperUser(Id pid) {return FindProfileId('gpSU', pid);}
    public static Boolean isFmUser(Id pid) {return FindProfileId('fmprfl', pid);}
    public static Boolean isCallUser(Id pid) {return FindProfileId('grucall', pid);}
    //public static Boolean canReqSrvc(Id sid, Boolean toPay, String vfPage) {try{Id pid = UserInfo.getProfileId();g_Srvc__c srvc= [select actv__c, AccTp__c, (select DE__c, AP__c from g_srvcAL__r where isDeleted = false and usr__c=:UserInfo.getUserId()) from g_Srvc__c where id=:sid limit 1];if (!srvc.actv__c) {return false;}if (srvc.AccTp__c == null) {return false;}if (isPortalUser(pid)) {User u = [select Contact.Account.Type from User where id=: UserInfo.getUserId() limit 1];Boolean tpOk = false;for (String tp: srvc.AccTp__c.split('\\;')) {if (tp == u.Contact.Account.Type) {tpOk=true;break;}}if (!tpOk) {return false;}if (isPortalSuperUser(UserInfo.getProfileId())) {return true;}if (srvc.g_srvcAL__r.size()>0) {g_srvcAL__c  al = srvc.g_srvcAL__r[0];return toPay == true?(al.AP__c == null?false:al.AP__c):(al.DE__c == null?false:al.DE__c);}else{return false;}}if (vfPage != null) {if (!FindProfileId(vfPage, pid)) {return false;}}return true; /*Handover to standard profile settings of the current user.*/}catch (exception ex) {return false;}}
    public static Boolean canReqSrvc(Id sid, Boolean toPay, String vfPage) {
        try {
            Id pid = UserInfo.getProfileId();
            g_Srvc__c srvc = [select actv__c, AccTp__c, (select DE__c, AP__c from g_srvcAL__r where isDeleted = false and usr__c =: UserInfo.getUserId()) from g_Srvc__c where id =: sid limit 1];
            if (!srvc.actv__c) {
                return false;
            }
            if (srvc.AccTp__c == null) {
                return false;
            }
            if (isPortalUser(pid)) {
                User u = [select Contact.Account.Type, Contact.Account.isIN5__c from User where id =: UserInfo.getUserId() limit 1];
                Boolean tpOk = false;
                for (String tp: srvc.AccTp__c.split('\\;')) {
                    if (tp == u.Contact.Account.Type || u.Contact.Account.isIN5__c) {
                        tpOk = true;
                        break;
                    }
                }
                if (!tpOk) {
                    return false;
                }
                if (isPortalSuperUser(UserInfo.getProfileId())) {
                    return true;
                }
                if (srvc.g_srvcAL__r.size() > 0) {
                    g_srvcAL__c al = srvc.g_srvcAL__r[0];
                    return toPay == true ? (al.AP__c == null ? false : al.AP__c) : (al.DE__c == null ? false : al.DE__c);
                }
                else {
                    return false;
                }
            }
            if (vfPage != null) {
                if (!FindProfileId(vfPage, pid)) {
                    return false;
                }
            }
            return true;
        /*Handover to standard profile settings of the current user.*/     }
        catch (exception ex) {
            return false;
        }
    }
    public static Boolean canAccess2(Id sid, Boolean toPay, String vfPage) {
        try {
            Id pid = UserInfo.getProfileId();
            String profileName = [Select Id, Name from Profile where Id =: pid].Name;
            system.debug('ProfileName' + profileName);
            Set < String > accType = new set < String > ();
            List < g_Srvc__c > srvLst = new List < g_Srvc__c > ();
            srvLst = [Select Id, AccTp__c from g_Srvc__c where sdg__c =: sid];
            for (g_Srvc__c srv: srvLst) {
                List < String > selections = srv.AccTp__c.split(';');
                for (String str: selections) accType.add(str);
            }
            System.debug('accType List====' + accType);
            String currentAccType = [Select Id, contactId, contact.accountId, contact.Account.Type from user where id =: Userinfo.getUserid()].contact.Account.Type;
            System.debug('currentAccType====' + currentAccType);
            if (profileName == 'X') {
                if (accType.Contains(currentAccType)) {
                    list < g_srvcAL__c > slAcc = [select DE__c, AP__c, srvc__r.sdg__c from g_srvcAL__c where isDeleted = false and usr__c =: UserInfo.getUserId() and srvc__r.sdg__c =: sid];
                    if (slAcc.isEmpty()) {
                        return false;
                    }
                }
                else {
                    return false;
                }
            }
            return true;
        }
        catch (exception ex) {
            return false;
        }
    }
    //*************************************************************** ----- DEG Payment
    public static string DEG_Encrypt(string message) {return EncodingUtil.convertToHex(Crypto.generateDigest('MD5', blob.valueOf(EncodingUtil.urlEncode(message, 'UTF-8')))).toUpperCase();}
    public static void DEG_PrepareCall(decimal amount, string refNo) {
        PageReference P = ApexPages.currentPage();
        P.getParameters().put('AMOUNT', string.valueOf(amount));
        P.getParameters().put('PAYMENTCHANNELCODE', csStr('gwChnl'));
        P.getParameters().put('SERVCODE', csStr('gwsc'));
        P.getParameters().put('SPCODE', csStr('gwspc'));
        P.getParameters().put('VERSIONCODE', csStr('gwvc'));
        P.getParameters().put('SPTRN', refNo);
        P.getParameters().put('payurl', csStr('gwURL'));
        P.getParameters().put('ENCRYPTEDMSG', DEG_Encrypt(string.valueOf(amount)+csStr('gwChnl')+csStr('gwsc')+csStr('gwspc')+refNo+csStr('gwvc')+csStr('gwKy')));
    }
    public static boolean DEG_Checksum(String msg, String hashMsg) {
        String eCd= EncodingUtil.convertToHex(Crypto.generateDigest('MD5', blob.valueOf(msg+csStr('gwKy')))).toUpperCase();
        return eCd == hashMsg;
    }
    //*************************************************************** ----- Navigation & Caching
    public static Boolean checkNav() {
        Cookie grqv = ApexPages.currentPage().getCookies().get('grqv');
        if (grqv == null && !isCallUser(UserInfo.getProfileId())) {
            return false;
        }
        else {
            grqv = new Cookie('grqv', null, null, -1, true);
            ApexPages.currentPage().setCookies(new Cookie[] {
            grqv }
            );
            return true;
        }
    }

    /*****check parkig user*****/
    public static Boolean checkParkingUser(String userId) {
        Boolean onlyParkingUser = false;
        List <String> parkingSerCodes = System.Label.parkingSerCodes.split(', ');
        list < g_srvcAL__c > slAcc = [select srvc__r.uid__c from g_srvcAL__c where isDeleted = false and usr__c =:userId];
        if (slAcc != null&&parkingSerCodes.size()==slAcc.size()) {
            onlyParkingUser = true;
            for (g_srvcAL__c s:slAcc) {
                if (!parkingSerCodes.contains(s.srvc__r.uid__c)) onlyParkingUser = false;
            }
        }
        return onlyParkingUser;
    }
    public class MapWrapper implements Comparable {
        public string key;
        public Integer value;
        public MapWrapper(string key, Integer value) {
            this.key = key;
            this.value = value;
        }
        public Integer compareTo(Object other) {
            return value-((MapWrapper)other).value;
        }
    }
    public static Map<String, Integer> mapSort(Map<String, Integer> srcMap) {
        List<MapWrapper> mapList = new  List<MapWrapper>();
        for (string key: srcMap.keyset()) {
            mapList.add(new MapWrapper(key, srcMap.get(key)));
        }
        if (mapList != null) {
            mapList.sort();
        }
        Map<String, Integer> dest=new Map<String, Integer>();
        for (Integer i = mapList.size()-1;
        i >= 0 && mapList != null;
        i--) {
            MapWrapper warp=mapList.get(i);
            dest.put(warp.key, warp.value);
        }
        return dest;
    }

    public static string DED_Decrypt(string message) {
        String dcStr = '';
        Blob encodedEncryptedBlob = EncodingUtil.base64Decode(message);
        Blob key = Blob.valueOf(gu.csStr('ddakey'));
        Blob decryptedBlob = Crypto.decryptWithManagedIV('AES128', key , encodedEncryptedBlob);
        dcStr = decryptedBlob.toString();
        return dcStr;
    }
    public static string DED_Encrypt(string message) {
        String enStr = '';
        Blob key = Blob.valueOf(gu.csStr('ddakey'));
        Blob cipherText = Crypto.encryptWithManagedIV('AES128', key, Blob.valueOf(message));
        enStr = EncodingUtil.base64Encode(cipherText);
        return enStr;
    }

    public static Datetime strDateTime(String dttm) {
        String[] dd=dttm.split(' ');
        String[] dt=dd[0].split('/');
        String[] tm=dd[1].split(':');
        Integer hrs=Integer.valueof(tm[0]);
        if (dd[2]=='PM') {if (hrs == 12) {hrs=12;}else{hrs=hrs+12;}}
        if (dd[2]=='AM') {if (hrs == 12) {hrs=0;}}
        Datetime dtm = Datetime.newInstance(Integer.valueof(dt[2]), Integer.valueof(dt[0]), Integer.valueof(dt[1]), hrs, Integer.valueof(tm[1]), Integer.valueof(tm[2]));
        return dtm;
    }

    public static string converBolobToBytes(Blob bSalt) {
        Map<string, Integer> base64 = new map<string, Integer>{
        'A'=>0, 'B'=>1, 'C'=>2, 'D'=>3, 'E'=>4, 'F'=>5, 'G'=>6, 'H'=>7, 'I'=>8, 'J'=>9, 'K'=>10,
            'L'=>11, 'M'=>12, 'N'=>13, 'O'=>14, 'P'=>15, 'Q'=>16, 'R'=>17, 'S'=>18, 'T'=>19,
            'U'=>20, 'V'=>21, 'W'=>22, 'X'=>23, 'Y'=>24, 'Z'=>25, 'a'=>26, 'b'=>27, 'c'=>28,
            'd'=>29, 'e'=>30, 'f'=>31, 'g'=>32, 'h'=>33, 'i'=>34, 'j'=>35, 'k'=>36, 'l'=>37,
            'm'=>38, 'n'=>39, 'o'=>40, 'p'=>41, 'q'=>42, 'r'=>43, 's'=>44, 't'=>45, 'u'=>46,
            'v'=>47, 'w'=>48, 'x'=>49, 'y'=>50, 'z'=>51, '0'=>52, '1'=>53, '2'=>54, '3'=>55,
            '4'=>56, '5'=>57, '6'=>58, '7'=>59, '8'=>60, '9'=>61, '+'=>62, '/'=>63
        }
        ;
            Map<integer, string> hex = new Map<integer, string>{
            0=>'00', 1=>'01', 2=>'02', 3=>'03', 4=>'04', 5=>'05', 6=>'06', 7=>'07', 8=>'08', 9=>'09',
                10=>'0A', 11=>'0B', 12=>'0C', 13=>'0D', 14=>'0E', 15=>'0F', 16=>'10', 17=>'11', 18=>'12',
                19=>'13', 20=>'14', 21=>'15', 22=>'16', 23=>'17', 24=>'18', 25=>'19', 26=>'1A', 27=>'1B',
                28=>'1C', 29=>'1D', 30=>'1E', 31=>'1F', 32=>'20', 33=>'21', 34=>'22', 35=>'23', 36=>'24',
                37=>'25', 38=>'26', 39=>'27', 40=>'28', 41=>'29', 42=>'2A', 43=>'2B', 44=>'2C', 45=>'2D',
                46=>'2E', 47=>'2F', 48=>'30', 49=>'31', 50=>'32', 51=>'33', 52=>'34', 53=>'35', 54=>'36',
                55=>'37', 56=>'38', 57=>'39', 58=>'3A', 59=>'3B', 60=>'3C', 61=>'3D', 62=>'3E', 63=>'3F',
                64=>'40', 65=>'41', 66=>'42', 67=>'43', 68=>'44', 69=>'45', 70=>'46', 71=>'47', 72=>'48',
                73=>'49', 74=>'4A', 75=>'4B', 76=>'4C', 77=>'4D', 78=>'4E', 79=>'4F', 80=>'50', 81=>'51',
                82=>'52', 83=>'53', 84=>'54', 85=>'55', 86=>'56', 87=>'57', 88=>'58', 89=>'59', 90=>'5A',
                91=>'5B', 92=>'5C', 93=>'5D', 94=>'5E', 95=>'5F', 96=>'60', 97=>'61', 98=>'62', 99=>'63',
                100=>'64', 101=>'65', 102=>'66', 103=>'67', 104=>'68', 105=>'69', 106=>'6A', 107=>'6B',
                108=>'6C', 109=>'6D', 110=>'6E', 111=>'6F', 112=>'70', 113=>'71', 114=>'72', 115=>'73',
                116=>'74', 117=>'75', 118=>'76', 119=>'77', 120=>'78', 121=>'79', 122=>'7A', 123=>'7B',
                124=>'7C', 125=>'7D', 126=>'7E', 127=>'7F', 128=>'80', 129=>'81', 130=>'82', 131=>'83',
                132=>'84', 133=>'85', 134=>'86', 135=>'87', 136=>'88', 137=>'89', 138=>'8A', 139=>'8B',
                140=>'8C', 141=>'8D', 142=>'8E', 143=>'8F', 144=>'90', 145=>'91', 146=>'92', 147=>'93',
                148=>'94', 149=>'95', 150=>'96', 151=>'97', 152=>'98', 153=>'99', 154=>'9A', 155=>'9B',
                156=>'9C', 157=>'9D', 158=>'9E', 159=>'9F', 160=>'A0', 161=>'A1', 162=>'A2', 163=>'A3',
                164=>'A4', 165=>'A5', 166=>'A6', 167=>'A7', 168=>'A8', 169=>'A9', 170=>'AA', 171=>'AB',
                172=>'AC', 173=>'AD', 174=>'AE', 175=>'AF', 176=>'B0', 177=>'B1', 178=>'B2', 179=>'B3',
                180=>'B4', 181=>'B5', 182=>'B6', 183=>'B7', 184=>'B8', 185=>'B9', 186=>'BA', 187=>'BB',
                188=>'BC', 189=>'BD', 190=>'BE', 191=>'BF', 192=>'C0', 193=>'C1', 194=>'C2', 195=>'C3',
                196=>'C4', 197=>'C5', 198=>'C6', 199=>'C7', 200=>'C8', 201=>'C9', 202=>'CA', 203=>'CB',
                204=>'CC', 205=>'CD', 206=>'CE', 207=>'CF', 208=>'D0', 209=>'D1', 210=>'D2', 211=>'D3',
                212=>'D4', 213=>'D5', 214=>'D6', 215=>'D7', 216=>'D8', 217=>'D9', 218=>'DA', 219=>'DB',
                220=>'DC', 221=>'DD', 222=>'DE', 223=>'DF', 224=>'E0', 225=>'E1', 226=>'E2', 227=>'E3',
                228=>'E4', 229=>'E5', 230=>'E6', 231=>'E7', 232=>'E8', 233=>'E9', 234=>'EA', 235=>'EB',
                236=>'EC', 237=>'ED', 238=>'EE', 239=>'EF', 240=>'F0', 241=>'F1', 242=>'F2', 243=>'F3',
                244=>'F4', 245=>'F5', 246=>'F6', 247=>'F7', 248=>'F8', 249=>'F9', 250=>'FA', 251=>'FB',
                252=>'FC', 253=>'FD', 254=>'FE', 255=>'FF'
            }
            ;
                string saltbSalt = EncodingUtil.base64Encode(bSalt);
        Integer strIDX = 0;
        string strSALT = '';
        for (Integer idx=0; idx < saltbSalt.length()-4; idx+=4) {
            strSALT += hex.get((base64.get(saltbSalt.substring(idx, idx+1)) << 2) | (base64.get(saltbSalt.substring(idx+1, idx+2)) >>> 4))
                + hex.get(((base64.get(saltbSalt.substring(idx+1, idx+2)) & 15)<<4) | (base64.get(saltbSalt.substring(idx+2, idx+3)) >>> 2))
                + hex.get(((base64.get(saltbSalt.substring(idx+2, idx+3)) & 3)<<6) | base64.get(saltbSalt.substring(idx+3, idx+4)));
        }

        if (saltbSalt.substring(saltbSalt.length()-1, saltbSalt.length()) != '=') {
            Integer idx = saltbSalt.length() - 4;
            strSALT += hex.get((base64.get(saltbSalt.substring(idx, idx+1)) << 2) | (base64.get(saltbSalt.substring(idx+1, idx+2)) >>> 4))
                + hex.get(((base64.get(saltbSalt.substring(idx+1, idx+2)) & 15)<<4) | (base64.get(saltbSalt.substring(idx+2, idx+3)) >>> 2))
                + hex.get(((base64.get(saltbSalt.substring(idx+2, idx+3)) & 3)<<6) | base64.get(saltbSalt.substring(idx+3, idx+4)));

        } else if (saltbSalt.substring(saltbSalt.length()-2, saltbSalt.length()-1) != '=') {
            Integer idx = saltbSalt.length() - 4;
            strSALT += hex.get((base64.get(saltbSalt.substring(idx, idx+1)) << 2) | (base64.get(saltbSalt.substring(idx+1, idx+2)) >>> 4))
                + hex.get(((base64.get(saltbSalt.substring(idx+1, idx+2)) & 15)<<4) | (base64.get(saltbSalt.substring(idx+2, idx+3)) >>> 2));

        } else{
            Integer idx = saltbSalt.length() - 4;
            strSALT += hex.get((base64.get(saltbSalt.substring(idx, idx+1)) << 2) | (base64.get(saltbSalt.substring(idx+1, idx+2)) >>> 4));
        }
        System.debug(strSALT);

        return strSALT;
    }
    public void createSurveyRes(String rid) {
        try {
            List < g_req__c > rqlst = [select id, srvc__r.suvtp__c, CreatedBy.id from g_req__c where id =: rid];
            if (rqlst != null && !rqlst.isEmpty() && String.isNotBlank(rqlst[0].srvc__r.suvtp__c) && rqlst[0].srvc__r.suvtp__c == 'After Payment') {
                List < Survey_Request__c > srvLst = [select id from Survey_Request__c where Request__c =: rid and Survey__c =: gU.csStr('AXS SurveyId')];
                if (srvLst == null || srvLst.isEmpty()) {
                    Survey_Request__c req = new Survey_Request__c();
                    req.Survey__c = gU.csStr('AXS SurveyId');
                    req.Request__c = rid;
                    req.unique__c = rid + '' + gU.csStr('AXS SurveyId');
                    req.Request_User__c = rqlst[0].CreatedBy.id;
                    if (Schema.sObjectType.Survey_Request__c.isCreateable()) {
                        insert req;
                    }
                }
            }
        }
        catch (Exception e) {
        }
    }
    public class FromJSON {
        public String TranslatedText;
        public FromJSON parse(String json) {
            return (FromJSON) System.JSON.deserialize(json, FromJSON.class);
        }
    }

    /*************************************************************************************************
* Description        : Method to set OTP on request and create WS call record to trigger OTP email.
* Created Date        : 25-08-2024
* Created By        : Prateek Jangir
**************************************************************************************************/
    public static g_Req__c  sendEmailOTP(String serviceName, String emailAddress, g_Req__c requestRec) {  //1.1

        Integer min = 100000;
        Integer max = 999999;
        String randomvalue = String.valueOf(Math.round(Math.random() * (max - min)) + min);

        if (serviceName == 'UBO') {
            UBOSubmissionCtl_2 uboIns = new UBOSubmissionCtl_2('x');
            requestRec = uboIns.closeCreateUBORequest(requestRec, 'Open');
        }
        requestRec.ivramsgs__c= randomvalue;
        requestRec.xceml__c=emailAddress;
        if (Schema.sObjectType.g_req__c.isUpdateable()) {
            update requestRec;
        }

        /* Creating WS call to for audit and to trigger OTP email to user */
        ws_call__c ws = new ws_call__c();
        ws.mtd_nm__c = 'OTP';
        ws.rq_jsn__c = 'Your OTP is '+randomvalue+'. Please do not share your OTP with anyone.';
        ws.Rq_email__c = emailAddress;
        if (Schema.sObjectType.ws_call__c.isCreateable()) {
            insert ws;
        }

        return requestRec;
    }

    /*************************************************************************************************
* Description        : Method to validate OTP for email and mobile change.
* Created Date        : 25-08-2024
* Created By        : Prateek Jangir
**************************************************************************************************/
    public static String validateOtp(String serviceName, g_Req__c requestRec, UBOSubmissionCtl_2.IndvInfo indvInformation, String otpVal, Boolean isMobileOTP, String otpReqId) {  //1.1
        try {
            String otpResult='';
            String otpValue = [select id, ivramsgs__c from g_Req__c where id=:requestRec.Id]?.ivramsgs__c;
            if (isMobileOTP == false && otpValue != null) {
                if (otpVal == otpValue) {
                    otpResult = 'Verified';
                    if (serviceName == 'UBO') {
                        indvInformation.isEmailVerified = true;
                        indvInformation.emailVerificationDatetime = System.Now();
                    }
                }
            }
            else{
                if (Label.Onboarding_OTP!='NA') {
                    if (otpVal == Label.Onboarding_OTP) {
                        otpResult = 'Verified';
                    }
                    else{
                        otpResult = SMSService.otpValidate(otpReqId, otpVal);
                    }
                }
                else{
                    otpResult = SMSService.otpValidate(otpReqId, otpVal);
                }

                if (otpResult == 'Verified' && indvInformation != null) {
                    indvInformation.isMobilePhoneVerified = true;
                    indvInformation.mobilePhoneVerificationDatetime = System.Now();
                }
            }
            return otpResult;
        } catch (Exception e) {
            gU.AddErrorMsg('OTP validation failed, regenerate the OTP and verify.');
            return 'Not Verified';
        }
    }
    public static void updateItemSTA(String rqId) {

        g_req__c rq = new g_req__c(Id = rqId);
        list < g_reqitem__c > Itms = new list < g_reqitem__c > ();
        boolean isReqCompleted = false;

        List < g_reqitem__c > itmIds = [SELECT Id, RQ__c, sta__c, sta__r.Next_Status__c, sta__r.Next_Status__r.rqSTA__c,
                                        itm__c, itm__r.cd__c from g_reqitem__c where RQ__c =: rqId and sta__r.isfn__c = true and isdeleted = false order by createdDate desc
                                       ];
        /*To be checked with Srini MS 1.1*/
        g_srvcitm_Status__c verSta = [SELECT id , name , itm__r.cd__c, rqSTA__c from     g_srvcitm_Status__c where cd__c = 'v' and srv_code__c = '216'  and itm__r.cd__c = 'nl' limit 1];
        System.debug('updateItemSTA - <itmIds> : ' + itmIds);
        System.debug('updateItemSTA - verSta : ' + verSta);
        if (!itmIds.isEmpty() && itmIds.size() > 0) {
            for (g_reqitem__c i: itmIds) {
                i.sta__c = verSta.id;
                if ((i.sta__r.Next_Status__c != null && i.sta__r.Next_Status__r.rqSTA__c == 'Completed') || (i.itm__r.cd__c == 'ai' && i.sta__r.Next_Status__c != null)) {
                    rq.STA__c = verSta.rqSTA__c;
                    isReqCompleted = true;
                }
                Itms.add(i);
            }
        }
        if (!Itms.isEmpty() && Itms.size() > 0) {
            if (Schema.sObjectType.g_reqitem__c.isUpdateable()) {
                update Itms;
            }
        }
    }

    public static void initiateDocumentUploadOIC(g_Req__c  reqRec, String methodName, String destinationName) {
        List<ws_call__c> wsToInsert = new List<ws_call__c>();
            if (reqRec != null) {
                Map<Id, g_reqDoc__c> reqDocMap = new Map<Id, g_reqDoc__c>([ select id, rq__r.xdei__c,
                    name from g_reqDoc__c where RQ__c =: reqRec.id AND (Req__c = true or ats__c > 0) and IsDeleted = false]);
                system.debug('---reqDocMap---'+reqDocMap);
                List<Attachment> attachmentList = [
                    SELECT Id, Name, ParentId, CreatedDate
                    FROM Attachment
                    WHERE ParentId IN :reqDocMap.keySet()
                    ORDER BY CreatedDate DESC
                ];

                Map<Id, String> docIdToLatestAttachmentName = new Map<Id, String>();

                for (Attachment att : attachmentList) {
                    if (!docIdToLatestAttachmentName.containsKey(att.ParentId)) {
                        docIdToLatestAttachmentName.put(att.ParentId, att.Name);
                    }
                }
                System.debug('docIdToLatestAttachmentName :'+docIdToLatestAttachmentName);
                system.debug('--reqDocMap--'+reqDocMap.values());
                if (!reqDocMap.isEmpty()) {
                    for (g_reqDoc__c reqDoc : reqDocMap.values()) {
                        ws_call__c oicDocPush = new ws_call__c();
                        oicDocPush.ws_typ__c = 'Onboarding';
                        oicDocPush.mtd_nm__c = methodName;
                        oicDocPush.intsts__c = 'Ready for Integration';
                        oicDocPush.rq_jsn__c = reqDoc.id;
                        oicDocPush.adhoc_text1__c =docIdToLatestAttachmentName.get(reqDoc.id)?.replaceAll('\\s+', '');
                        oicDocPush.pmid__c = reqRec.xdei__c;
                        oicDocPush.Document_Destination__c=destinationName;
                        wsToInsert.add(oicDocPush);
                    }
                }
                if (!wsToInsert.isEmpty()) {
                    if (Schema.sObjectType.ws_call__c.isCreateable()) {
                        insert wsToInsert;
                    }
                }
        }
    }

    /*
    public static void initiateDocumentUploadOIC(g_Req__c  reqRec, String methodName, String destinationName, id reqDocId) {
        List<ws_call__c> wsToInsert = new List<ws_call__c>();
            if (reqRec != null) {

                if (reqDocId != null) {
                    List<Attachment> attachmentList = [
                        SELECT Id, Name, ParentId, CreatedDate
                        FROM Attachment
                        WHERE ParentId =:reqDocId
                        ORDER BY CreatedDate DESC
                    ];

                    if (!attachmentList.isEmpty()) {
                            ws_call__c oicDocPush = new ws_call__c();
                            oicDocPush.ws_typ__c = 'Onboarding';
                            oicDocPush.mtd_nm__c = methodName;
                            oicDocPush.intsts__c = 'Ready for Integration';
                            oicDocPush.rq_jsn__c = reqDocId;
                            oicDocPush.adhoc_text1__c =attachmentList[0].Name.replaceAll('\\s+', '');
                            oicDocPush.pmid__c = reqRec.xdei__c;
                            oicDocPush.Document_Destination__c=destinationName;
                            if (Schema.sObjectType.ws_call__c.isCreateable()) {
                                insert oicDocPush;
                            }
                    }
                }
                else{
                    Map<Id, g_reqDoc__c> reqDocMap = new Map<Id, g_reqDoc__c>([ select id, name from g_reqDoc__c where RQ__c =: reqRec.id AND (Req__c = true or ats__c > 0) and IsDeleted = false]);
                    List<Attachment> attachmentList = [
                        SELECT Id, Name, ParentId, CreatedDate
                        FROM Attachment
                        WHERE ParentId IN :reqDocMap.keySet()
                        ORDER BY CreatedDate DESC
                    ];

                    Map<Id, String> docIdToLatestAttachmentName = new Map<Id, String>();

                    for (Attachment att : attachmentList) {
                        if (!docIdToLatestAttachmentName.containsKey(att.ParentId)) {
                            docIdToLatestAttachmentName.put(att.ParentId, att.Name);
                        }
                    }
                    System.debug('docIdToLatestAttachmentName :'+docIdToLatestAttachmentName);
                    if (!reqDocMap.isEmpty()) {
                        for (g_reqDoc__c reqDoc : reqDocMap.values()) {
                            ws_call__c oicDocPush = new ws_call__c();
                            oicDocPush.ws_typ__c = 'Onboarding';
                            oicDocPush.mtd_nm__c = methodName;
                            oicDocPush.intsts__c = 'Ready for Integration';
                            oicDocPush.rq_jsn__c = reqDoc.id;
                            oicDocPush.adhoc_text1__c =docIdToLatestAttachmentName.get(reqDoc.id)?.replaceAll('\\s+', '');
                            oicDocPush.pmid__c = reqRec.xdei__c;
                            oicDocPush.Document_Destination__c=destinationName;
                            wsToInsert.add(oicDocPush);
                        }
                    }
                    if (!wsToInsert.isEmpty()) {
                        if (Schema.sObjectType.ws_call__c.isCreateable()) {
                            insert wsToInsert;
                        }
                    }
                }

        }
    }

    public static void initiateDocumentUploadOICBulk(List<Map<String, Object>> methodParamsList) {
        List<ws_call__c> wsToInsert = new List<ws_call__c>();

        // Get custom metadata for service code configuration
        Map<String, List<Document_Push_Integration_Setup__mdt>> serviceCodeToConfigMap = new Map<String, List<Document_Push_Integration_Setup__mdt>>();
        for (Document_Push_Integration_Setup__mdt config : [SELECT DeveloperName, Service_Type__c,
            Service_Code__c, Destination__c, Method_Name__c, Pmid_Mapping_Field__c FROM Document_Push_Integration_Setup__mdt]) {
            if (!serviceCodeToConfigMap.containsKey(config.Service_Code__c)) {
                serviceCodeToConfigMap.put(config.Service_Code__c, new List<Document_Push_Integration_Setup__mdt>());
            }
            serviceCodeToConfigMap.get(config.Service_Code__c).add(config);
        }

        for (Map<String, Object> params : methodParamsList) {
            List<Attachment> attachments = (List<Attachment>)params.get('attachments');
            String serviceCode = (String)params.get('serviceCode');
            Id reqId = (Id)params.get('reqId');
            g_Req__c req = (g_Req__c)params.get('reqRecord');
            Map<Id, g_reqDoc__c> reqDocMap = (Map<Id, g_reqDoc__c>)params.get('reqDocMap');

            if (serviceCodeToConfigMap.containsKey(serviceCode)) {
                List<Document_Push_Integration_Setup__mdt> configs = serviceCodeToConfigMap.get(serviceCode);

                for (Attachment att : attachments) {
                    if (!reqDocMap.containsKey(att.ParentId)) {
                        continue;
                    }

                    for (Document_Push_Integration_Setup__mdt setup : configs) {
                        ws_call__c ws = new ws_call__c();
                        ws.ws_typ__c = setup.Service_Type__c;
                        ws.mtd_nm__c = setup.Method_Name__c;
                        ws.intsts__c = 'Ready for Integration';
                        ws.rq_jsn__c = att.Id;
                        ws.adhoc_text1__c = att.Name != null ? att.Name.replaceAll('\\s+', '') : null;
                        ws.Document_Destination__c = setup.Destination__c;

                        System.debug('setup.Pmid_Mapping_Field__c :'+setup.Pmid_Mapping_Field__c);
                        // Dynamic field mapping for pmid__c
                        if (setup.Pmid_Mapping_Field__c != null && req != null) {
                            try {
                                Object pmidVal = req.get(setup.Pmid_Mapping_Field__c);
                                System.debug('pmidVal:'+pmidVal);
                                if (pmidVal != null) {
                                    ws.pmid__c = String.valueOf(pmidVal);
                                }
                            } catch (Exception ex) {
                                System.debug('Failed to map dynamic field: ' + setup.Pmid_Mapping_Field__c);
                            }
                        }

                        wsToInsert.add(ws);
                    }
                }
            }
        }

        if (!wsToInsert.isEmpty()) {
            if (Schema.sObjectType.ws_call__c.isCreateable()) {
                insert wsToInsert;
            }
        }
    }

    public static void initiateDocumentUploadOICBulk(Id reqId) {
        List<ws_call__c> wsToInsert = new List<ws_call__c>();

        // Fetch the main request record
        g_Req__c req = [
            SELECT Id, Service_Code__c, xdei__c
            FROM g_Req__c
            WHERE Id = :reqId
            LIMIT 1
        ];

        String serviceCode = req.Service_Code__c;
        if (String.isBlank(serviceCode)) return;

        // Load metadata config per service code
        Map<String, List<Document_Push_Integration_Setup__mdt>> serviceCodeToConfigs = new Map<String, List<Document_Push_Integration_Setup__mdt>>();
        for (Document_Push_Integration_Setup__mdt config : [
            SELECT DeveloperName, Service_Type__c, Service_Code__c, Destination__c, Method_Name__c, Pmid_Mapping_Field__c
            FROM Document_Push_Integration_Setup__mdt
        ]) {
            if (!serviceCodeToConfigs.containsKey(config.Service_Code__c)) {
                serviceCodeToConfigs.put(config.Service_Code__c, new List<Document_Push_Integration_Setup__mdt>());
            }
            serviceCodeToConfigs.get(config.Service_Code__c).add(config);
        }

        List<Document_Push_Integration_Setup__mdt> configs = serviceCodeToConfigs.get(serviceCode);
        if (configs == null || configs.isEmpty()) return;

        // Fetch all attachments where parent is g_reqDoc__c and g_reqDoc__c is linked to given request
        List<Attachment> attachments = [
            SELECT Id, Name, ParentId
            FROM Attachment
            WHERE ParentId IN (
                SELECT Id FROM g_reqDoc__c WHERE RQ__c = :reqId AND IsDeleted = false
            )
        ];

        // Proceed if we have any attachments
        if (!attachments.isEmpty()) {
            for (Attachment att : attachments) {
                for (Document_Push_Integration_Setup__mdt setup : configs) {
                    ws_call__c ws = new ws_call__c();
                    ws.ws_typ__c = setup.Service_Type__c;
                    ws.mtd_nm__c = setup.Method_Name__c;
                    ws.intsts__c = 'Ready for Integration';
                    ws.rq_jsn__c = att.Id;
                    ws.adhoc_text1__c = att.Name != null ? att.Name.replaceAll('\\s+', '') : null;
                    ws.Document_Destination__c = setup.Destination__c;

                    if (!String.isBlank(setup.Pmid_Mapping_Field__c)) {
                        try {
                            Object pmidVal = req.get(setup.Pmid_Mapping_Field__c);
                            if (pmidVal != null) {
                                ws.pmid__c = String.valueOf(pmidVal);
                            }
                        } catch (Exception ex) {
                            System.debug('PMID mapping error: ' + ex.getMessage());
                        }
                    }

                    wsToInsert.add(ws);
                }
            }

            if (Schema.sObjectType.ws_call__c.isCreateable()) {
                insert wsToInsert;
            }
        }
    } */

}