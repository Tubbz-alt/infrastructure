# Configuration for users

SMTP/IMAP server: mail.archlinux.org
SMTP port: 587 STARTTLS
IMAP port: 143 (STARTTLS), 993 (TLS)

username: the system account name
password: set by each user themselves with `passwd` on mail.archlinux.org

# Adding new archlinux.org email addresses

Login to mail.archlinux.org and edit `/etc/postfix/users`, add the new email address in the
appropriate category and run `postmap /etc/postfix/users`.

If the user wants to forward email, either enter the destination directly in
the /etc/postfix/users file or enter a username and then put the destination
into `~username/.forward` so that they can edit it themselves.

# SMTP Architecture

All hosts should be relaying outbound SMTP traffic via our primary MX server
(currently 'mail.archlinux.org'). Each hosts authenticates using SASL over a TLS connection
to the server. This gives us several benefits:

1. DKIM signing can be done centrally.
2. SPF records require less maintenance as servers are added/removed.
3. Our email reputation is focused on one well-maintained and (hopefully) well
   maintained host, rather than distributed across all hosts in our fleet.
4. Central traceability for debugging.
5. Central maintainability for rate-limiting to prevent abuse.

When a new host is provisioned:

- The *postfix* role has a task delegated to 'mail.archlinux.org' to create a local user
  on 'mail.archlinux.org' that is used for the new server to authenticate against. The user
  name is the shortname of the new servers hostname (ie, "foobar.archlinux.org"
  will authenticate with the username "foobar")
- You will need to run the *postfwd* role against mail.archlinux.org to update the
  rate-limiting it performs (servers are given higher rate-limits than normal
  users - see `/etc/postfwd/postfwd.cf` for exact limits). This *should*
  happen automatically as the *postfwd* role is a dependency of the *postfix*
  role (using `delegate_to` to run it against 'mail.archlinux.org' regardless of the target
  host that the postfix role is being run on)
- Any services on the new host that need to relay mail should relay using SMTP
  to `localhost` on port 10027 which bypasses any filtering/restrictions that
  are applied by postfix to port 25 traffic.
