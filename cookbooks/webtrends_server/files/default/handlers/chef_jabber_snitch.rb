class JabberSnitchHandler < Chef:Handler
# Notify admins via Jabber when a Chef run fails
 require 'chef-jabber-snitch'

 jabber_user = "chef@sengutil01.staging.dmz"
 jabber_password = "cookin"
 jabber_server = "sengutil01.staging.dmz"
 jabber_to = "martink@sengtil01.staging.dmz"