import Foundation
import IOKit.ps

enum BatteryError: Error { case error }

do {
	// Take a snapshot of all the power source info
	guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue()
		else { throw BatteryError.error }
	
	// Pull out a list of power sources
	guard let sources: NSArray = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue()
		else { throw BatteryError.error }
	
	// For each power source...
	for ps in sources {
		// Fetch the information for a given power source out of our snapshot
		guard let info: NSDictionary = IOPSGetPowerSourceDescription(snapshot, ps as CFTypeRef)?.takeUnretainedValue()
			else { throw BatteryError.error }
		
		// Pull out the name and current capacity
		if let _ = info[kIOPSNameKey] as? String,
			let capacity = info[kIOPSCurrentCapacityKey] as? Int,
			let _ = info[kIOPSMaxCapacityKey] as? Int {
			print("\(capacity)%")
		}
	}
} catch {
	fatalError()
}
