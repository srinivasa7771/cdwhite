public class AxsMethods {

    /* To trim and capitalaize a string */
    public static String trimAndCapitalize(String str) {
        str = str.trim();
        String retStr = '';
        List<String> lstStr = str.split(' ');
        for (String s:lstStr) {
            s = s.trim();
            if (String.isNotBlank(s)) {
                retStr += ' '+s.toLowerCase().capitalize();
            }
        }
        return retStr.trim();
    }
    /* To Create Random user name and check availability */
    public static String getUsername(String uEmail) {
        if (String.isBlank(uEmail) || !uEmail.contains('@')) {
            return '';
        }
        uEmail = uEmail.trim().toLowerCase();
        List<String> emailParts = uEmail.split('@');
        Set<String> existingUsers = new Set<String>();
        if (emailParts != null && emailParts.size()>1) {
            String searchStr = emailParts[0] +'%';
            String searchStr2 = '%'+emailParts[1];
            List<User> lstUser = [Select id, name, username from User where username like :searchStr and username like :searchStr2];
            if (lstUser == null || lstUser.size()==0) {
                return uEmail;
            }
            for (User u : lstUser) {
                existingUsers.add(u.username.toLowerCase());
            }
        }
        if (existingUsers.size()==0 || !existingUsers.contains(uEmail)) {
            return uEmail;
        }
        while (true) {
            String newUN = emailParts[0]+Math.round(Math.random()*10000)+'@'+emailParts[1];
            if (!existingUsers.contains(newUN)) {
                return newUN;
            }
        }
        return '';
    }

    /* To add any query in service settins  */
    public static void updateSrvcStngs(String ssFld, String fldToUpdate) {
        String qur = 'select id, name, '+ssFld+' from g_srvc_settings__c';
        List <g_srvc_settings__c> ss = [select id, name, reqq__c from g_srvc_settings__c];
        List <g_srvc_settings__c> ss1 = new List <g_srvc_settings__c>();
        for (g_srvc_settings__c  s : ss) {
            String str = s.reqq__c;
            if (str.containsIgnoreCase(fldToUpdate)) {
                /*Acc__r.Legal_Framework__c*/ s.reqq__c.replaceFirst('Select', 'Select '+fldToUpdate+', ');
                system.debug('s----'+s);
                ss1.add(s);
            }
        }
        if (Schema.sObjectType.g_srvc_settings__c.isUpdateable()) {
            update ss1;
        }
    }
}