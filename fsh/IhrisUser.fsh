Profile:        IhrisPersonUser
Parent:         Person
Id:             ihris-person-user
Title:          "iHRIS Person profile for users."
Description:    "iHRIS profile of the Person resource to manage user access."
* telecom 1..1
* telecom ^slicing.discriminator.type = #pattern
* telecom ^slicing.discriminator.path = "system"
* telecom ^slicing.rules = #open
* telecom contains Email 1..1
* telecom[Email].system = #email
* telecom[Email].value 1..1
* name 1..1
* name ^slicing.discriminator.type = #pattern
* name ^slicing.discriminator.path = "use"
* name ^slicing.rules = #open
* name contains Fullname 1..1
* name[Fullname].use = #official
* name[Fullname].text 1..1
* extension contains 
      IhrisUserRole named role 0..* and
      IhrisPassword named password 0..1

Profile:        IhrisRole
Parent:         Basic
Id:             ihris-basic-role
Title:          "iHRIS Role"
Description:    "iHRIS profile of the Basic resource to manage user roles."
* code from IhrisResourceValueSet
* code = IhrisResourceCodeSystem#role
* extension contains IhrisTask named task 0..*

Extension:      IhrisUserRole
Id:             ihris-user-role
Title:          "iHRIS User Role"
Description:    "iHRIS User Roles with list of tasks given by this role."
* ^context.type = #element
* ^context.expression = "Person"
* value[x] only Reference
* valueReference 1..1
* valueReference only Reference(IhrisRole)
* valueReference.reference 1..1
* valueReference.type 0..0
* valueReference.identifier 0..0
* valueReference.display 0..0

Extension:      IhrisPassword
Id:             ihris-password
Title:          "iHRIS Password"
Description:    "iHRIS password extension for local users."
* ^context.type = #element
* ^context.expression = "Person"
* extension contains 
      password 1..1 MS and
      salt 1..1 MS
* extension[password].value[x] only string
* extension[password].valueString 1..1
* extension[salt].value[x] only string
* extension[salt].valueString 1..1

Extension:      IhrisTask
Id:             ihris-task
Title:          "iHRIS Task"
Description:    "A task assigned to a role."
* ^context.type = #element
* ^context.expression = "Basic"
* value[x] only string
* valueString 1..1

Instance:       ihris-role-admin
InstanceOf:     IhrisRole
Title:          "iHRIS Admin User Role"
Usage:          #example
* extension[IhrisTask][0].valueString = "user/*.*"

Instance:       ihris-role-any
InstanceOf:     IhrisRole
Title:          "iHRIS Any User Role"
Usage:          #example
* extension[IhrisTask][0].valueString = "user/StructureDefinition.read"

Instance:       ihris-user-admin
InstanceOf:     IhrisPersonUser
Title:          "iHRIS Admin User"
Usage:          #example
* telecom[Email].value = "admin@ihris.org"
* name[Fullname].text = "iHRIS Admin"
* identifier[0].system = "google"
* identifier[0].value = "12345"
* extension[IhrisUserRole].valueReference = Reference(Basic/ihris-role-admin)
* extension[IhrisPassword].extension[password].valueString = "PASS"
* extension[IhrisPassword].extension[salt].valueString = "SALT"