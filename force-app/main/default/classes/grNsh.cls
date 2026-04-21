public  class grNsh {
 public list<Contact> clst{get;set;}
 public String a{get;set;}
  public void init() {gNSpD();}
 public grNsh() {init();}
  public void gNSpD() {
        try{
         a=String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('a'));
         clst=[Select Id, FirstName, LastName, p__c, nc__c, pRol__c, Spon__r.FirstName,
             Spon__r.LastName from contact Where Spon__c != null and  Spon__r.AccountId=:a and STA__c='Active' and rol__c='Non Sponsored' limit 999];
         }catch (Exception e) {gU.AddErrorMsg(e);}}
   public string getTBx() {return String.escapeSingleQuotes(System.currentPageReference().getParameters().get('id'));}
    public string getSId() {return String.escapeSingleQuotes(System.currentPageReference().getParameters().get('c'));}
    public string getP() {return String.escapeSingleQuotes(System.currentPageReference().getParameters().get('p'));}
    public string getN() {return String.escapeSingleQuotes(System.currentPageReference().getParameters().get('n'));}

   }