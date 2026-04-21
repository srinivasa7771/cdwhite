public class gctlPpl{

    public List<Contact> lstCon{get; set;}
    public List<String> lstStr {get;set;}
    string fldVal, criteria, ActId ;
    decimal fldRng {get; set;}
    public string newLn {get; set;}
    public boolean isOS {get;set;}
    public string accType {get;set;}
    
    public gctlPpl(ApexPages.StandardController std){   
        newLn = '\r\n'; 
        isOS = false;
        accType = '';
        lstStr = new List<String>{'str'};
        string fldParam = ApexPages.CurrentPage().getParameters().get('p');
        if(fldParam == 'All_Outsourced')
         isOS = true;   
    }
    
    
    public void gCon(){
        ActId = ApexPages.CurrentPage().getParameters().get('id');
            
        if(!isOS && setCriteria()){
            string selectQuery = 'select id, Name, jb__c, jb__r.Name, jbar__c, STA__c, rol__c, nc__c, p__c, ped__c, idtxt__c, rp__c, rped__c, MobilePhone,os__c,account.type ';        
            selectQuery += ' from Contact ';
           
            selectQuery += ' where ( AccountId =: ActId ' + criteria + ' ) ' ;            
            
            lstCon = Database.Query(selectQuery);
            if(lstCon != null && !lstCon.isEmpty())
               accType = lstCon[0].account.type; 
        }
        else if(isOS)
        {
            lstCon = [select id,name,account.name,STA__c,rol__c,p__c, ped__c, idtxt__c, rp__c, rped__c,MobilePhone from contact where id in (select contactId from AccountcontactRelation where accountId =:ActId  and isDirect = false and sts__c != 'InActive')];
        }
    }
    
    boolean setCriteria(){
        try{
            string fldParam = ApexPages.CurrentPage().getParameters().get('p');
            string intStr = ApexPages.CurrentPage().getParameters().get('d');
            if(intStr != null && intStr != ''){
                fldRng = integer.ValueOf(intStr);    }
            
            if(fldParam != null && fldParam != '' && ActId != null && ActId != ''){      
                            
                fldVal = gU.csStr(fldParam);
                
                if(fldRng != null && fldRng != 0)
                    fldVal += fldRng ;
                    
                criteria = ' and (' + fldVal + ') ';         
                return true;  
            } 
            return false; 
        }
        catch(exception ex){
            System.debug(LoggingLevel.ERROR, 'Exception: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
            return false;
        }                                               
    }
}