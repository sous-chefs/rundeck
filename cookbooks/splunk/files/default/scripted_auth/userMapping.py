'''
This is a basic user database for storing users and their corresponding Splunk roles.

This is only intended to be a sample and is NOT SUPPORTED. If you only have a handful of users
this may suffice for mapping your users to roles. It may not scale well to thousands of users.

IMPORTANT: If you intend to use both the getUsersRole and getAllUsers functions defined here,
the roleMappingDict must have an entry for each user in your auth system. Otherwise, you could potentially
get roles for a particular user in getUsersRole that is not returned in getAllUsers (since we
default to returning the user role in getUsersRole). An incomplete database of users here would result in
undefined behavior.
'''


# If you want a user to have admin or power level you will need to add them
# to this map OR just replace getUserRole and getUserFilter function with
# your own code that restrieves this information from elsewhere.
roleMappingDict = {
#     #username     #splunk role           # search filter
#     'boo'     :  ([ "admin" ],           [ 'NOT APACHE', 'NOT FLUBBER', 'NOT FLUBBER' ]),
#     'root'    :  ([ "admin", "power" ],  []),
#     'peon'    :  ([ "user" ],            []),
#     'steve'   :  ([ "user" ],            [ 'NOT GLOBAL' ]),
#     'john'    :  ([ "power" ],           [] ),
#     'jack'    :  ([ "admin" ],           [] )
}



def getUsersRole( username ):
    if roleMappingDict.has_key( username ):
        return roleMappingDict[username][0]
    else:
        print "Unable to find user " + username
        print "Returning lowest role of user"
        return [ "user" ]


def getUsersFilters( username ):
    if roleMappingDict.has_key( username ):
        return roleMappingDict[username][1]
    else:
        print "Unable to find user " + username
        print "Returning no search filter"
        return [ "" ]

def getAllUsers():
    out = ""
    for u, r in roleMappingDict.iteritems():
        out += ' --userInfo=' + u + ';' + u + ';' + u + ';' + ':'.join(r[0])

    return out