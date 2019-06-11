# UserGroupTest

Fetch User Groups from AD using PerfectLDAP library
https://github.com/PerfectlySoft/Perfect-LDAP 

Currently there are following hardcoded values that i need to provide as input to make this work
When i bind ldap with a user and then try to fetch users, then it is working

<b>HardCoded Values</b>

let ldapUrl = "ldap://americas.ad.celestica.com"//"ldap://RootDSE"
let passwordForBinding = "Password1!"
let distinguishedName = "CN=Users,DC=Americas,DC=ad,DC=celestica,DC=com"
let userDistinguishedName = "CN=alice,CN=Users,DC=Americas,DC=ad,DC=celestica,DC=com"

Pending Issues:

1. LDAP://RootDSE not working, giving "Can't Contact LDAP server"
Not working with ldap client (Apache Directory Studio) as well

3. Current code fetches details of user groups within the same OU only and that too through which it was bind 
(currently I am specifying in search: base as CN=Users,DC=Americas,DC=ad,DC=celestica,DC=comm)
so it is giving all the details of groups within Users folder
If I specify in search: (base as DC=Americas,DC=ad,DC=celestica,DC=comm), then it the app hangs

2. If I dont bind AD with a user, instead I just use a URL to bind
 LDAP://Americas.ad.celestica.com
and in search if i specify no parameters
ldap.search()
then i can access defaultNamingContext, rootNamingContext etc. those fields

But if i search users using filter, i am getting zero results
but 

4. Primary Group (Domain Users) is not getting fetched via API 
