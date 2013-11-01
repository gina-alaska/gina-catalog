#  Assuming webapp might use this variable at some point.
default['webapp']['app_name'] = "glynx"
default['glynx']['deploy_path'] = "/www/#{default['webapp']['app_name']}"

default['glynx']['account'] = "webdev"

#Git
default['gina-website']['repository'] = "git@github.com:gina-alaska/www"
default['gina-website']['revision'] = "master"
default['glynx']['deploy_key'] = "-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAuSR6aMY9nZJEjkp3WhRI0mcFyp9+im+272eCz7EMahR9UMOQ
FTI3aJ8SoFiLSnvDCJuhBaurfgt4fBeTKb3WcRr8h8eGGZw8D/QjHJletmzKeqJI
POo2V6XKLXVmwxCE3jIuHS20FGd6OsrPNgtD4GV+hHmnvCZJFo0FhnALCEk//1Ge
gcM09sPyr/cDLihJZ3tTW2Z1kFqUeP4ThaCw8yEb3IQm27JGXTalUzpWtzON/tA1
97OBDxAqTm/D+s5hOTp62jc6wnaC8p1dlGYiXPy23MqJn8Xk5TIULgB1fiBqQx9v
/vmEznkbui3+vnAAEsxO+093fhvdpB+7r3qArQIDAQABAoIBAAbRzyh41OAu+RN8
rrTEtoH5hX8XLOQQhV6AI5Ne5CQsKQmGipIdTWkvItKBMHBH6sEwalf5INH9vixj
+em5smJsKg0eTlQ3KwczaO+uvoxdqX+m5p5HykSkOLQ/9M8OlrZQht5QRqfRv/DW
c5d8Br4HPwfGK2WEy4BnJWL0UZO2fvbpdNGk9gevnf9KWCaXdqi0L5b6IRpdPX44
KrvpxoFFXDrhs8hZG44Rjs+PHBugmn+ADj2h7FyfC4f+rxkQgOxVSpK0etTU/4xb
B1KfSaJttf5lJtiWg6AxVXL0GqjqxYJUN7tvaWXMIxAD16hlD8b3eZxsLjdJN22u
WedYvwECgYEA4QX9lO5nMKGmjuJ7seyWEHPNzDkIWGK5nsvkAbv7oRGrANcRGdz7
sECJN7wu+VZ89dfZMFs1vIS0nPwZxAWC3ndZMCzm7bOKJ25cIaMK/HdIK37+sOAm
Sa4Dp4C0exc3LzpU9kcfskaGDsjQRFET52aoWeS/a7FzidBFAzs95GECgYEA0qEN
OdEaTTmUaMv1991KZr8zVFHoLhf1Y5lpt20d6Zeqi9Ssq6M0lO1DEx5ewPwasL6O
D9Mx1oLI+jqO8BPhCjKxQwq8hOmcx/dcoPAEzDXyboKUW6Ox0uv/YI6XGeVhcaNw
HbSMUakV9IkhhxMkgksUacB5SLpD7iNp7e8u/80CgYEAimfa3137zme/QKeBmaCB
dMEl1fVGcsbWkRurtH1hemKZobym4heQH4qyW7u90NMnrTcEeb/AP6IITX6qgm05
X4hdLUqRB6ek1DgHJxFX0o2zsD0+fqCALFWCHecGG6fd44indYutrUO/dRyDLWIJ
Mg1sg041hxHwlNWrfR9VJEECgYAuTkniFB58K9R81ZpVy8i3ngFi4D7zI0FHjEq5
kLuqxzUvWKo9cbv1odPFOEAMnWAgy0PgJsYmKsqUeJtEHJq060AdRRb9AX7+V1t9
5kanvpR1xy9mli5Z+JhEWhTOFKe/m/biEPdoXIv/HsbIM2UrX+Y0+aOwYYLdr9tx
+8uRYQKBgBQTucfqoZ1eMmSe5vpHPV+Km2wYKgICOng2agPqkyHzg6loizMyXXS1
/AcJLzkMA+R1Fqz2WoPW6vkkg7aGl2oIzU20Nv+RxyW53S/GsrLLJaEiVXI5e+y+
9Sx/FO/pyIwtUBNUHHxBMhiOEYIS2EWFx4RpHdUIkKY5//JvaYiG
-----END RSA PRIVATE KEY-----"
#Database Stuff

default['glynx']['database']['host'] = "yang.gina.alaska.edu"
default['glynx']['database']['name'] = "nssi_dev"
default['glynx']['database']['username'] = "nssi_dev"
default['glynx']['database']['password'] = "g0d0fn551"
default['glynx']['package_deps'] = %w{libicu-devel curl-devel}


default['glynx']['before_fork'] = "
defined?(ActiveRecord::Base) and
   ActiveRecord::Base.connection.disconnect!
sleep 1
"

default['glynx']['after_fork'] = "
defined?(ActiveRecord::Base) and
  ActiveRecord::Base.establish_connection
"