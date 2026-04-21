public with sharing class bRLs {
    public static list<bRL> Parse(String scope, String str) {
        list<bRL> rules=new list<bRL>();
        JSONParser parser = JSON.createParser(str);
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser.nextToken() != null) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        bRL r= (bRL)parser.readValueAs(bRL.class);
                        if (r.inScope(scope)) {rules.add(r);}
                        parser.skipChildren();
                    }
                }
            }
        }
        return rules;
    }
    public static Boolean exc(grqH.payload pl, list<bRL> rules, Integer seq) {for (Integer i=0;i<rules.size();i++) {bRL r=rules[i];if (!r.eval(i+1, pl, seq)) {return false;}}return true;}
    private static object evalSide(Integer idx, grqH.payload pl, String attr, String o, String val, String valType) {
        if (o != null) {
            if (attr != null) {
                if (o == 'new') {if (pl.nw == null) {throw new gU.customException('Settings Error - Rule Number ('+ idx.format() + '): new is not initialized');}return getAttr(pl.nw, attr);}
                else if (o == 'old') {if (pl.old == null) {throw new gU.customException('Settings Error - Rule Number ('+ idx.format() + '): old is not initialized');}return getAttr(pl.old, attr);}
                else if (o.startsWith('#')) {
                    sObject obj=pl.mo.get(o);
                    if (obj == null) {
                        throw new gU.customException('Settings Error - Rule Number ('+ idx.format() + '): ' + String.escapeSingleQuotes(o) + ' is not initialized');
                    }
                    return getAttr(obj, attr);
                }
                else if (o.startsWith('@')) {
                    throw new gU.customException('Settings Error - Rule Number ('+ idx.format() + '): ' + String.escapeSingleQuotes(attr) + ' is not supported with ' + o);
                }
                else {
                    throw new gU.customException('Settings Error - Rule Number ('+ idx.format() + '): ' + String.escapeSingleQuotes(o) + ' is not supported');
                }
            }
            else {
                if (o == 'new') {return pl.nw;}
                else if (o == 'old') {return pl.old;}
                else if (o.startsWith('#')) {return pl.mo.get(o);}
                else if (o.startsWith('@')) {return pl.mv.get(o);}
                else {throw new gU.customException('Settings Error - Rule Number ('+ idx.format() + '): ' + String.escapeSingleQuotes(o) + ' is not supported');}
            }
        }
        else {return convertVal(val, valType);}
    }
    private static object getAttr(sObject obj, String attr) {
        sObject o = obj;
        list<String> pO = attr.split('\\.');
        for (integer i=0; i< pO.size()-1;i++) {o = o.getSObject(pO[i]);}
        return o.get(pO[pO.size()-1]);
    }
    private static object convertVal(String vl, String tp) {
        if (vl == null) {return null;}
        if (tp == 'Boolean') {return Boolean.valueOf(vl);}
        else if (tp == 'Date') {return Date.valueOf(vl);}
        else if (tp == 'Datetime') {return Datetime.valueOf(vl);}
        else if (tp == 'Decimal') {return Decimal.valueOf(vl);}
        else if (tp == 'Double') {return Double.valueOf(vl);}
        else if (tp == 'Long') {return Decimal.valueOf(vl).longValue();}
        else if (tp == 'Integer') {return Integer.valueOf(vl);}
        else if (tp == 'Id') {return Id.valueOf(vl);}
        else if (tp == 'Blob') {return Blob.valueOf(vl);}
        else {return vl;}
    }
    public class bRL{
        private String scp;
        private Integer sq;
        public Boolean inScope(String s) {
            Boolean bl = scp == null?false:scp.contains(s);
            scp=null;
            return bl;
        }
        private String Fn;
        private String lbl;
        private String obj;
        private String oFlds;
        private errM errMsg;
        private CMPL excIf;
        private CMPL lgc;
        private list<ASN>Flds;
        private Boolean canExec(Integer idx, grqH.payload pl, Integer seq) {return sq != seq?false:(excIf == null?true:excIf.eval(idx, pl));}
        private void setFields(Integer idx, grqH.payload pl, sObject sObj) {for (ASN f: Flds) {f.eval(idx, pl, sObj);}}
        public Boolean eval(Integer idx, grqH.payload pl, Integer seq) {
            if (!canExec(idx, pl, seq)) {return true;}
            try{
                if (Fn == 'evBL') {
                    if (lbl == null || lgc == null) {
                        throw new gU.customException('Settings Error - Rule Number ('+ idx.format() + '): lbl or lgc is not identified');
                    }
                    pl.mv.put(lbl, lgc.eval(idx, pl));
                    return true;
                }
                else if (Fn == 'ERR') {
                    if (errMsg == null) {
                        throw new gU.customException('Settings Error - Rule Number ('+ idx.format() + '): errMsg is not identified');
                    }
                    pl.nw.addError(errMsg.getMessage(idx, pl));
                    return false;
                }
                else if (Fn == 'dSLCT') {
                    if (lbl == null||obj == null||oFlds == null) {
                        throw new gU.customException('Settings Error - Rule Number ('+ idx.format() + '): lbl or obj or oFlds is not identified');
                    }
                    list<sObject> sObjs = Database.query('select ' + String.escapeSingleQuotes(oFlds) + ' from '+obj+lgc.toSOQL(idx, pl));
                    /*+' limit 1'*/if (sObjs.size()>0) {
                        pl.mo.put(lbl, sObjs[0]);
                    }
                    return true;
                }
                else if (Fn == 'UPD') {
                    if (lbl == null||Flds == null) {throw new gU.customException('Settings Error - Rule Number ('+ idx.format() + '): lbl or Flds is not identified');}
                    if (lbl == 'new') {
                        if (pl.nw == null) {throw new gU.customException('Settings Error - Rule Number (' + idx.format() + '): new is not initialized');}
                    setFields(idx, pl, pl.nw);
                    }
                    else if (lbl == 'old') {
                        if (pl.old == null) {throw new gU.customException('Settings Error - Rule Number (' + idx.format() + '): old is not initialized');}
                        setFields(idx, pl, pl.old);
                    }
                    else if (lbl.startsWith('#')) {
                        sObject sObj = pl.mo.get(lbl);
                        if (sObj == null) {throw new gU.customException('Settings Error - Rule Number (' + idx.format() + '): ' + String.escapeSingleQuotes(lbl) + 'is not initialized');}
                        setFields(idx, pl, sObj);
                    }
                    else if (lbl.startsWith('@')) {
                        throw new gU.customException('Settings Error - Rule Number (' + idx.format() + '): ' + String.escapeSingleQuotes(lbl) + ' is not supported');
                    }
                    else {throw new gU.customException('Settings Error - Rule Number (' + idx.format() + '): ' + String.escapeSingleQuotes(lbl) + ' is not supported');}
                    return true;
                }
                else if (Fn == 'dUPD') {
                    if (lbl == null||obj == null||Flds == null) {
                        throw new gU.customException('Settings Error - Rule Number ('+ idx.format() + '): lbl or obj or Flds is not identified');
                    }
                    if (lbl == 'new') {
                        throw new gU.customException('Settings Error - Rule Number (' + idx.format() + '): ' + String.escapeSingleQuotes(lbl) + ' is not supported');
                    }
                    else if (lbl == 'old') {
                        throw new gU.customException('Settings Error - Rule Number (' + idx.format() + '): ' + String.escapeSingleQuotes(lbl) + ' is not supported');
                    }
                    else if (lbl.startsWith('#')) {
                        sObject sObj = pl.mo.get(lbl);
                        if (sObj == null) {
                            throw new gU.customException('Settings Error - Rule Number (' + idx.format() + '): ' + String.escapeSingleQuotes(lbl) + ' is not initialized');
                        }
                        setFields(idx, pl, sObj);
                        if (pl.toUpdate.get(obj)==null) {
                            pl.toUpdate.put(obj, new list<sObject>());
                        }
                        pl.toUpdate.get(obj).add(sObj);
                    }
                    else if (lbl.startsWith('@')) {
                        throw new gU.customException('Settings Error - Rule Number (' + idx.format() + '): ' + String.escapeSingleQuotes(lbl) + ' is not supported');
                    }
                    else {
                        throw new gU.customException('Settings Error - Rule Number (' + idx.format() + '): ' + String.escapeSingleQuotes(lbl) + ' is not supported');
                    }
                    return true;
                }
                else if (Fn == 'dCRT') {
                    if (lbl == null||obj == null||Flds == null) {
                        throw new gU.customException('Settings Error - Rule Number ('+ idx.format() + '): lbl or obj or Flds is not identified');
                    }
                    sObject sObj = Schema.getGlobalDescribe().get(obj).newSObject() ;
                    setFields(idx, pl, sObj);
                    pl.mo.put(lbl, sObj);
                    if (pl.toInsert.get(obj)==null) {
                        pl.toInsert.put(obj, new list<sObject>());
                    }
                    pl.toInsert.get(obj).add(sObj);
                    return true;
                }
                else if (Fn == 'dDLT') {
                    if (lbl == null||obj == null) {
                        throw new gU.customException('Settings Error - Rule Number ('+ idx.format() + '): lbl or obj is not identified');
                    }
                    if (lbl == 'new') {
                        throw new gU.customException('Settings Error - Rule Number (' + idx.format() + '): ' + String.escapeSingleQuotes(lbl) + ' is not supported');
                    }
                    else if (lbl == 'old') {
                        throw new gU.customException('Settings Error - Rule Number (' + idx.format() + '): ' + String.escapeSingleQuotes(lbl) + ' is not supported');
                    }
                    else if (lbl.startsWith('#')) {
                        sObject sObj = pl.mo.get(lbl);
                        if (sObj == null) {
                            throw new gU.customException('Settings Error - Rule Number (' + idx.format() + '): ' + String.escapeSingleQuotes(lbl) + ' is not initialized');
                        }
                        if (pl.toDelete.get(obj)==null) {
                            pl.toDelete.put(obj, new list<sObject>());
                        }
                        pl.toDelete.get(obj).add(sObj);
                    }
                    else if (lbl.startsWith('@')) {
                        throw new gU.customException('Settings Error - Rule Number (' + idx.format() + '): ' + String.escapeSingleQuotes(lbl) + ' is not supported ');
                    }
                    else {
                        throw new gU.customException('Settings Error - Rule Number (' + idx.format() + '): ' + String.escapeSingleQuotes(lbl) + ' is not supported');
                    }
                    return true;
                }
                else {throw new gU.customException('Settings Error - Rule Number (' + idx.format() + '): ' + String.escapeSingleQuotes(Fn) + ' is not supported function');}
            }
            catch (Exception ex) {throw new gU.customException('Settings Error - Rule Number (' + idx.format() + '): ' + ex.getMessage() + '-' + ex.getStackTraceString());}
        }
    }
    private class CMPL{
        private String logic; private list<CMP> cmps; private list<CMPL> cmpls;
        public Boolean eval(Integer idx, grqH.payload pl) {
            if (cmps == null&&cmpls == null) {
                return true;
            }
            if (logic == 'and') {
                if (cmps != null) {
                    for (CMP c: cmps) {
                        if (!c.eval(idx, pl)) {
                            return false;
                        }
                    }
                }
                if (cmpls != null) {
                    for (CMPL cg: cmpls) {
                        if (!cg.eval(idx, pl)) {
                            return false;
                        }
                    }
                }
                return true;
            }
            else if (logic == 'or') {
                if (cmps != null) {
                    for (CMP c: cmps) {
                        if (c.eval(idx, pl)) {
                            return true;
                        }
                    }
                }
                if (cmpls != null) {
                    for (CMPL cg: cmpls) {
                        if (cg.eval(idx, pl)) {
                            return true;
                        }
                    }
                }
                return false;
            }
            else {
                throw new gU.customException('Settings Error - Rule Number ('+ idx.format() + '): ' + String.escapeSingleQuotes(logic) + ' is not supported logic');
            }
        }
        public String toSOQL(Integer idx, grqH.payload pl) {
            if (cmps == null && cmpls == null) {
                return '';
            }
            if (logic != 'and' && logic != 'or') {
                throw new gU.customException('Settings Error - Rule Number (' + idx.format() + '): ' + String.escapeSingleQuotes(logic) + ' is not supported logic');
            }
            String strSOQL ='';
            if (cmps != null) {
                for (CMP c: cmps) {
                    strSOQL += strSOQL==''?c.toSOQL(idx, pl):' ' + String.escapeSingleQuotes(logic) + ' '+ c.toSOQL(idx, PL);
                }
            }
            if (cmpls != null) {
                for (CMPL cg: cmpls) {
                    strSOQL += strSOQL == ''?cg.toSOQL(idx, pl):' ' + String.escapeSingleQuotes(logic) + ' ( ' + cg.toSOQL(idx, PL) + ' ) ';
                }
            }
            return ' where ' + strSOQL;
        }
    }
    private class CMP{
        private String op;
        private String attrL;
        private String objL;
        private String valL;
        private String valLType;
        private String attrR;
        private String objR;
        private String valR;
        private String valRType;
        public Boolean eval(Integer idx, grqH.payload pl) {
            object LHS = evalSide(idx, pl, attrL, objL, valL, valLType);
            object RHS = evalSide(idx, pl, attrR, objR, valR, valRType);
            if (op == '=') {
                return LHS == RHS;
            }
            else if (op == '!=') {
                return LHS != RHS;
            }
            else if (op == '>') {
                if (LHS instanceof Integer) {
                    return (Integer)LHS > (Integer)RHS;
                }
                else if (LHS instanceof Long) {
                    return (Long)LHS > (Long)RHS;
                }
                else if (LHS instanceof Double) {
                    return (Double)LHS > (Double)RHS;
                }
                else if (LHS instanceof Decimal) {
                    return (Decimal)LHS > (Decimal)RHS;
                }
                else if (LHS instanceof Date) {
                    return (Date)LHS > (Date)RHS;
                }
                else if (LHS instanceof DateTime) {
                    return (DateTime)LHS > (DateTime)RHS;
                }
                else if (LHS instanceof String) {
                    return (String)LHS > (String)RHS;
                }
                throw new gU.customException('Settings Error - Rule Number ('+ idx.format() + '): > is not supported for [' + String.valueOf(LHS) + ' - ' +   String.valueOf(RHS) + ']');
            }
            else if (op == '<') {
                if (LHS instanceof Integer) {
                    return (Integer)LHS < (Integer)RHS;
                }
                else if (LHS instanceof Long) {
                    return (Long)LHS < (Long)RHS;
                }
                else if (LHS instanceof Double) {
                    return (Double)LHS < (Double)RHS;
                }
                else if (LHS instanceof Decimal) {
                    return (Decimal)LHS < (Decimal)RHS;
                }
                else if (LHS instanceof Date) {
                    return (Date)LHS < (Date)RHS;
                }
                else if (LHS instanceof DateTime) {
                    return (DateTime)LHS < (DateTime)RHS;
                }
                else if (LHS instanceof String) {
                    return (String)LHS < (String)RHS;
                }
                throw new gU.customException('Settings Error - Rule Number ('+ idx.format() + '): > is not supported for [' + String.valueOf(LHS) + ' - ' +   String.valueOf(RHS) + ']');
            }
            else if (op == '>=') {
                if (LHS instanceof Integer) {
                    return (Integer)LHS >= (Integer)RHS;
                }
                else if (LHS instanceof Long) {
                    return (Long)LHS >= (Long)RHS;
                }
                else if (LHS instanceof Double) {
                    return (Double)LHS >= (Double)RHS;
                }
                else if (LHS instanceof Decimal) {
                    return (Decimal)LHS >= (Decimal)RHS;
                }
                else if (LHS instanceof Date) {
                    return (Date)LHS >= (Date)RHS;
                }
                else if (LHS instanceof DateTime) {
                    return (DateTime)LHS >= (DateTime)RHS;
                }
                else if (LHS instanceof String) {
                    return (String)LHS >= (String)RHS;
                }
                throw new gU.customException('Settings Error - Rule Number ('+ idx.format() + '): > is not supported for [' + String.valueOf(LHS) + ' - ' +   String.valueOf(RHS) + ']');
            }
            else if (op == '<=') {
                if (LHS instanceof Integer) {
                    return (Integer)LHS <= (Integer)RHS;
                }
                else if (LHS instanceof Long) {
                    return (Long)LHS <= (Long)RHS;
                }
                else if (LHS instanceof Double) {
                    return (Double)LHS <= (Double)RHS;
                }
                else if (LHS instanceof Decimal) {
                    return (Decimal)LHS <= (Decimal)RHS;
                }
                else if (LHS instanceof Date) {
                    return (Date)LHS <= (Date)RHS;
                }
                else if (LHS instanceof DateTime) {
                    return (DateTime)LHS <= (DateTime)RHS;
                }
                else if (LHS instanceof String) {
                    return (String)LHS <= (String)RHS;
                }
                throw new gU.customException('Settings Error - Rule Number ('+ idx.format() + '): > is not supported for [' + String.valueOf(LHS) + ' - ' +   String.valueOf(RHS) + ']');
            }
            else if (op == 'co') {
                return String.valueOf(LHS).contains(String.valueOf(RHS));
            }
            else if (op == 'coA') {
                return String.valueOf(LHS).containsAny(String.valueOf(RHS));
            }
            else if (op == 'coIC') {
                return String.valueOf(LHS).containsIgnoreCase(String.valueOf(RHS));
            }
            else if (op == 'coN') {
                return String.valueOf(LHS).containsNone(String.valueOf(RHS));
            }
            else if (op == 'coO') {
                return String.valueOf(LHS).containsOnly(String.valueOf(RHS));
            }
            else if (op == 'ew') {
                return String.valueOf(LHS).endsWith(String.valueOf(RHS));
            }
            else if (op == 'ewIC') {
                return String.valueOf(LHS).endsWithIgnoreCase(String.valueOf(RHS));
            }
            else if (op == 'sw') {
                return String.valueOf(LHS).startsWith(String.valueOf(RHS));
            }
            else if (op == 'swIC') {
                return String.valueOf(LHS).startsWithIgnoreCase(String.valueOf(RHS));
            }
            else if (op == 'eqMC') {
                return String.valueOf(LHS).equals(String.valueOf(RHS));
            }
            else if (op == 'eqIC') {
                return String.valueOf(LHS).equalsIgnoreCase(String.valueOf(RHS));
            }
            throw new gU.customException('Settings Error - Rule Number ('+ idx.format() + '):' + String.escapeSingleQuotes(op) + 'is not supported');
        }
        public String toSOQL(Integer idx, grqH.payload pl) {
            if (attrL == null) {
                throw new gU.customException('Settings Error - Rule Number ('+ idx.format() + '): attrL is not identified');
            }
            object RHS = evalSide(idx, pl, attrR, objR, valR, valRType);
            Boolean useQuote = false;
            String strRHS;
            if (RHS == null) {
                strRHS = 'null';
            }
            else if (RHS instanceof Date) {
                useQuote = true;
                DateTime d=(DateTime)RHS;
                strRHS = d.format('yyyy-MM-dd');
            }
            else if (RHS instanceof DateTime) {
                useQuote = true;
                DateTime d=(DateTime)RHS;
                strRHS = d.format('yyyy-MM-dd')+'T'+ d.format('HH:mm')+':00.000Z';
            }
            else if (RHS instanceof String) {
                useQuote = true;
                strRHS = (String)RHS;
            }
            else {
                useQuote = false;
                strRHS = String.valueOf(RHS);
            }
            return attrL + op + (useQuote?'\'':'') + strRHS + (useQuote?'\'':'');
        }
    }
    private class ASN{
        private String op;
        private String attrL;
        private String attrR;
        private String objR;
        private String valR;
        private String valRType;
        public void eval(Integer idx, grqH.payload pl, sObject sObj) {
            object LHS = sObj.get(attrL);
            object RHS = evalSide(idx, pl, attrR, objR, valR, valRType);
            if (op == '=') {
                sObj.put(attrL, RHS);
                return;
            }
            else if (op == '+=') {
                if (LHS instanceof Integer) {
                    sObj.put(attrL, (Integer)LHS+(Integer)RHS);
                    return;
                }
                else if (LHS instanceof Long) {
                    sObj.put(attrL, (Long)LHS+(Long)RHS);
                    return;
                }
                else if (LHS instanceof Double) {
                    sObj.put(attrL, (Double)LHS+(Double)RHS);
                    return;
                }
                else if (LHS instanceof Decimal) {
                    sObj.put(attrL, (Decimal)LHS+(Decimal)RHS);
                    return;
                }
                else if (LHS instanceof String) {
                    sObj.put(attrL, (String)LHS+(String)RHS);
                    return;
                }
                throw new gU.customException('Settings Error - Rule Number ('+ idx.format() + '): operation is not supported for [' + String.valueOf(LHS) + ' += ' +   String.valueOf(RHS) + ']');
            }
            else if (op == '-=') {
                if (LHS instanceof Integer) {
                    sObj.put(attrL, (Integer)LHS-(Integer)RHS);
                    return;
                }
                else if (LHS instanceof Long) {
                    sObj.put(attrL, (Long)LHS-(Long)RHS);
                    return;
                }
                else if (LHS instanceof Double) {
                    sObj.put(attrL, (Double)LHS-(Double)RHS);
                    return;
                }
                else if (LHS instanceof Decimal) {
                    sObj.put(attrL, (Decimal)LHS-(Decimal)RHS);
                    return;
                }
                else if (LHS instanceof String) {
                    sObj.put(attrL, (String)LHS+(String)RHS);
                    return;
                }
                throw new gU.customException('Settings Error - Rule Number ('+ idx.format() + '): operation is not supported for [' + String.valueOf(LHS) + ' -= ' +   String.valueOf(RHS) + ']');
            }
            throw new gU.customException('Settings Error - Rule Number ('+ idx.format() + '): ' + String.escapeSingleQuotes(op) + 'is not supported');
        }
    }
    private class errM{
        private String msg;
        private list<mrgF> mrg;
        public String getMessage(Integer idx, grqH.payload pl) {
            if (msg == null) {
                throw new gU.customException('Settings Error - Rule Number ('+ idx.format() + '): error message is not identified');
            }
            if (mrg != null) {
                for (mrgF f: mrg) {
                    object RHS = evalSide(idx, pl, f.attrR, f.objR, f.valR, f.valRType);
                    msg = msg.replaceAll('#'+f.field, String.valueOf(RHS));
                }
            }
            return msg;
        }
    }
    private class mrgF{private String field;private String attrR; private String objR; private String valR; private String valRType;}
}