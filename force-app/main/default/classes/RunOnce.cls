public class RunOnce {
    // ACCOUNT TRIGGER CHECKS
    public static boolean accountTrigger = true;
    public static boolean alternateAddressTrigger = true;

    // PRODUCT TRIGGER CHECKS
    public static boolean productTrigger = true;
    public static boolean allowFurure_ProdKitLine = false;
    
    // PART SUPPLIER TRIGGER
     public static boolean psTriggerCheck = true;
    
    // KIT PART TRIGGER
     public static boolean kpTriggerCheck = true;
    
    // ORDER LINE ITEM TRIGGER
    public static boolean olibeforeUpdate = true;
    public static boolean oliafterUpdate = true;
    public static boolean olibeforeDelete = true;
    
    // ORDER ITEM TRIGGER
    public static boolean odrBeforeInsert = true;
    public static boolean odrBeforeUpdate =true;
    public static boolean odrAfterUpdate=true;
}