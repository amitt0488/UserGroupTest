import PerfectLDAP
import Foundation
import PerfectICONV
import OpenLDAP

let ldapUrl = "ldap://americas.ad.celestica.com"//"ldap://RootDSE"
let passwordForBinding = "Password1!"
let distinguishedName = "CN=Users,DC=Americas,DC=ad,DC=celestica,DC=com"
let userDistinguishedName = "CN=alice,CN=Users,DC=Americas,DC=ad,DC=celestica,DC=com"
let testCPG: Iconv.CodePage = .UTF8

func getGroupNameFromDNString(argDistinguishedName: String) -> (String) {
    // group is of the form: CN=group1,CN=Users,Dc=Americas,Dc=ad,DC=celestica,DC=com
    // need to extract group from this string
    let groupNameWithDNArray = argDistinguishedName.components(separatedBy: ",") // this gives us, [CN=group1, CN=Users, Dc=Americas]
    let groupNameArray = groupNameWithDNArray[0].components(separatedBy: "=") // this gives us [CN=group1]
    
    return groupNameArray[1]
}

func getUserDomainGroups(argUsername: String) -> (Array<String>) {
    
    var groups: Array<String> = Array()
    do {
        let cred = LDAP.Login(binddn: userDistinguishedName, password: passwordForBinding)
        
        let ldap = try LDAP(url: ldapUrl, loginData: cred, codePage: testCPG) // TODO: should work with RootDSE
        
        // "(objectclass=group)"  - to get all the groups
        //let completeDataFilter = "(objectclass=group)"
        let sAMAccountNameFilter = "sAMAccountName=" + argUsername
        //let allDataFilter = "(objectclass=*)"
        
        let res = try ldap.search(base: distinguishedName, filter: sAMAccountNameFilter, scope:.SUBTREE, attributes: ["sAMAccountName", "distinguishedName","memberof", "primaryGroupID"])
        
        for (userDN, properties) in res {
            //print("Key: \(userDN)")
            for prop in properties {
                if(prop.key == "memberOf") {
                    
                    if let groupsWithDN = prop.value as? [String] {
                        for group in groupsWithDN {
                            groups.append(getGroupNameFromDNString(argDistinguishedName: group))
                        }
                    }
                    else if let groupWithDN = prop.value as? String {
                        groups.append(getGroupNameFromDNString(argDistinguishedName: groupWithDN))
                    }
                    else {
                        print("No groups exist for this user.")
                    }
                }
            }
        }
    }
    catch (let err) {
        print(err)
    }
    
    return groups;
}

print("Enter username whose groups need to be fetched")
let unameTobeQueried = readLine()

let userDomainGroups = getUserDomainGroups(argUsername: unameTobeQueried ?? "alice")
print("User: " + unameTobeQueried! + " belongs to following groups -->")
print("\n")
print(userDomainGroups)

