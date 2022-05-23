//
//  BaseRepository.swift
//  Starter
//
//  Created by KC on 22/03/2022.
//

import Foundation
import CoreData

class BaseRepository: NSObject{
    
    override init(){
        super.init()
    }
    
    var coreData = CoreDataStack.shared
    
    public func handleCoreDataError(anError:NSError?) -> String {
        if anError != nil && anError!.domain.compare("NSCocoaErrorDomain") == .orderedSame {
            var messages:String = "Reason(s):\n"
            var errors = [AnyObject]()
            if (anError!.code == NSValidationMultipleErrorsError) {
                errors = anError!.userInfo[NSDetailedErrorsKey] as! [AnyObject]
            } else {
                errors = [AnyObject]()
                errors.append(anError!)
            }
            if (errors.count > 0) {
                for error in errors {
                    if (error as? NSError)!.userInfo.keys.contains("conflictList") {
                        messages = "Generic merge conflict. see details : \(error)"
                    }
                    else
                    {
                        let entityName = "\(String(describing: ((error as? NSError)!.userInfo["NSValidationErrorObject"] as! NSManagedObject).entity.name))"
                        let attributeName = "\(String(describing: (error as? NSError)!.userInfo["NSValidationErrorKey"]))"
                        var msg = ""
                        switch (error.code) {
                        case NSManagedObjectValidationError:
                            msg = "Generic validation error.";
                            break;
                        case NSValidationMissingMandatoryPropertyError:
                            msg = String(format:"The attribute '%@' mustn't be empty.", attributeName)
                            break;
                        case NSValidationRelationshipLacksMinimumCountError:
                            msg = String(format:"The relationship '%@' doesn't have enough entries.", attributeName)
                            break;
                        case NSValidationRelationshipExceedsMaximumCountError:
                            msg = String(format:"The relationship '%@' has too many entries.", attributeName)
                            break;
                        case NSValidationRelationshipDeniedDeleteError:
                            msg = String(format:"To delete, the relationship '%@' must be empty.", attributeName)
                            break;
                        case NSValidationNumberTooLargeError:
                            msg = String(format:"The number of the attribute '%@' is too large.", attributeName)
                            break;
                        case NSValidationNumberTooSmallError:
                            msg = String(format:"The number of the attribute '%@' is too small.", attributeName)
                            break;
                        case NSValidationDateTooLateError:
                            msg = String(format:"The date of the attribute '%@' is too late.", attributeName)
                            break;
                        case NSValidationDateTooSoonError:
                            msg = String(format:"The date of the attribute '%@' is too soon.", attributeName)
                            break;
                        case NSValidationInvalidDateError:
                            msg = String(format:"The date of the attribute '%@' is invalid.", attributeName)
                            break;
                        case NSValidationStringTooLongError:
                            msg = String(format:"The text of the attribute '%@' is too long.", attributeName)
                            break;
                        case NSValidationStringTooShortError:
                            msg = String(format:"The text of the attribute '%@' is too short.", attributeName)
                            break;
                        case NSValidationStringPatternMatchingError:
                            msg = String(format:"The text of the attribute '%@' doesn't match the required pattern.", attributeName)
                            break;
                        default:
                            msg = String(format:"Unknown error (code %i).", error.code) as String
                            break;
                        }

                        messages =  "\(entityName).\(attributeName):\(msg)\n"
                    }
                }
            }
            return messages
        }
        return "no error"
    }
}
