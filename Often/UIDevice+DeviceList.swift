public class Diagnostics : NSObject {
    
    //MARK: Device Platform
    /** A String value of the device platform information */
    private class var platform: String {
        // Declare an array that can hold the bytes required to store `utsname`, initilized
        // with zeros. We do this to get a chunk of memory that is freed upon return of
        // the method
        var sysInfo: [CChar] = Array(count: sizeof(utsname), repeatedValue: 0)
        
        // We need to get to the underlying memory of the array:
        let machine = sysInfo.withUnsafeMutableBufferPointer {
            (inout ptr: UnsafeMutableBufferPointer<CChar>) -> String in
            // Call uname and let it write into the memory Swift allocated for the array
            uname(UnsafeMutablePointer<utsname>(ptr.baseAddress))
            
            // Now here is the ugly part: `machine` is the 5th member of `utsname` and
            // each member member is `_SYS_NAMELEN` sized. We skip the the first 4 members
            // of the struct which will land us at the memory address of the `machine`
            // member
            let machinePtr = ptr.baseAddress.advancedBy(Int(_SYS_NAMELEN * 4))
            
            // Create a Swift string from the C string
            return String.fromCString(machinePtr)!
        }
        return machine
    }
    
    /**
    Provides platform specific information for the current device
    
    - returns: device A string of the Device type.  iPhone, iPad, iPod
    - returns: desciption A string of the Device types full description.. Verizon iPhone 4
    - returns: number An optional Int value of the device.. 6 - for iPhone 6 or 6 Plus
    */
    class func platformString() -> (device: String, desciption: String, number: Int?) {
        
        //will keep it simple here..
        switch platform {
        case "x86_64", "i386":
            return ("Simulator", "Simulator", nil)
            
            //iPhones
        case "iPhone1,1": return ("iPhone", "iPhone 1G", nil)
        case "iPhone1,2": return ("iPhone", "iPhone 3G", nil)
        case "iPhone2,1": return ("iPhone", "iPhone 3G3", nil)
            //iPhone 4's
        case "iPhone3,1": return ("iPhone", "iPhone 4", 4)
        case "iPhone3,3": return ("iPhone", "Verizon iPhone 4", 4)
        case "iPhone4,1": return ("iPhone", "iPhone 4S", 4)
            //iPhone 5's
        case "iPhone5,1": return ("iPhone", "iPhone 5 (GSM)", 5)
        case "iPhone5,2": return ("iPhone", "iPhone 5 (GSM+CDMA)", 5)
        case "iPhone5,3": return ("iPhone", "iPhone 5c GSM)", 5)
        case "iPhone5,4": return ("iPhone", "iPhone 5c (Global)", 5)
        case "iPhone6,1": return ("iPhone", "iPhone 5s (GSM)", 5)
        case "iPhone6,2": return ("iPhone", "iPhone 5s (Global)", 5)
            //iPhone 6's
        case "iPhone7,1": return ("iPhone", "iPhone 6 Plus", 6)
        case "iPhone7,2": return ("iPhone", "iPhone 6", 6)
            
            //iPods
        case "iPod1,1": return ("iPod", "iPod Touch 1G", nil)
        case "iPod2,1": return ("iPod", "iPod Touch 2G", nil)
        case "iPod3,1": return ("iPod", "iPod Touch 3G", nil)
        case "iPod4,1": return ("iPod", "iPod Touch 4G", nil)
        case "iPod5,1": return ("iPod", "iPod Touch 5G", nil)
            
            //iPads
        case "iPad1,1": return ("iPad", "iPad", nil)
            //iPad 2's
        case "iPad2,1": return ("iPad", "iPad 2 (WiFi)", 2)
        case "iPad2,2": return ("iPad", "iPad 2 (GSM)", 2)
        case "iPad2,3": return ("iPad", "iPad 2 (CDMA)", 2)
        case "iPad2,4": return ("iPad", "iPad 2", 2)
            //iPad 3's
        case "iPad3,1": return ("iPad", "iPad 3 (WiFi)", 3)
        case "iPad3,2": return ("iPad", "iPad 3 (CDMA)", 3)
        case "iPad3,3": return ("iPad", "iPad 3 (GSM)", 3)
            //iPad 4's
        case "iPad3,4": return ("iPad", "iPad 4 (WiFi)", 4)
        case "iPad3,5": return ("iPad", "iPad 4 (GSM)", 4)
        case "iPad3,6": return ("iPad", "iPad 4 (Global)", 4)
            //iPad Airs
        case "iPad4,1": return ("iPad", "iPad Air (WiFi)", nil)
        case "iPad4,2": return ("iPad", "iPad Air (Cellular)", nil)
            
            //iPad Mini's
        case "iPad2,5": return ("iPad", "iPad Mini (WiFi)", nil)
        case "iPad2,6": return ("iPad", "iPad Mini (GSM)", nil)
        case "iPad2,7": return ("iPad", "iPad Mini (Global)", nil)
        case "iPad4,4": return ("iPad", "iPad Mini Retina (WiFi)", nil)
        case "iPad4,5": return ("iPad", "iPad Mini Retina (Cellular)", nil)
            
            //AppleTV
        case "AppleTV2,1": return ("AppleTV", "AppleTV 2", 2)
        case "AppleTV3,1": return ("AppleTV", "AppleTV 3", 3)
        case "AppleTV3,2": return ("AppleTV", "AppleTV 3", 3)
            
        default:
            return ("unknown", "unknown", nil)
        }
        
    }
}